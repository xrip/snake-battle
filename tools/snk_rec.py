#!/usr/bin/env python3
"""Lossless, structured Snake Battle SNK/REC reader and writer.

Recovered from the supplied SNAKE.EXE, not from an original source release.
All offsets and evidence are documented in docs/SNK_REC.md. No dependency is
needed for normal use. Optional CPU-oracle verification needs Unicorn.

Examples:
  python tools/snk_rec.py decode original/TEST.SNK TEST.json
  python tools/snk_rec.py encode TEST.json TEST.SNK
  python tools/snk_rec.py inventory original --json-dir analysis/snakes
  python tools/snk_rec.py verify original --exe original/SNAKE.EXE

String objects preserve bytes after the first NUL: those bytes can be stale
editor data and must not be discarded in a byte-exact reconstruction.
"""
from __future__ import annotations

import argparse
import hashlib
import json
import random
import struct
from pathlib import Path
from typing import Any

HEADER_SIZE = 105
CARD_SIZE = 152
MAX_CARDS = 9
CODEC_ENCODE = (0x0B2B, 0x000F)
CODEC_DECODE = (0x0B2B, 0x0046)
GROUP_AND = (True, False, False, True, True)
TILES = {
    0: "empty", 1: "barrier", 2: "editor_placeholder_unresolved", 3: "enemy_tail",
    4: "own_tail", 5: "enemy_body", 6: "own_body", 7: "enemy_head",
    8: "own_head_anchor", 9: "wildcard",
}


def xor_decode(data: bytes, seed: int) -> tuple[bytes, int]:
    """0B2B:0046. Return plain bytes and last ciphertext byte (or seed)."""
    prev = seed
    out = bytearray()
    for encrypted in data:
        out.append(encrypted ^ prev)
        prev = encrypted
    return bytes(out), prev


def xor_encode(data: bytes, seed: int) -> tuple[bytes, int]:
    """0B2B:000F. The state is the preceding ciphertext byte."""
    prev = seed
    out = bytearray()
    for plain in data:
        prev ^= plain
        out.append(prev)
    return bytes(out), prev


def _string_read(raw: bytes, complement: bool = False) -> dict[str, Any]:
    end = raw.find(b"\0")
    if end < 0:
        end = len(raw)
    text = raw[:end]
    if complement:
        text = bytes(255 - c for c in text)
    return {"text": text.decode("cp866"), "after_text_hex": raw[end:].hex()}


def _string_write(obj: dict[str, Any], width: int,
                  complement: bool = False) -> bytes:
    text = obj["text"].encode("cp866")
    if b"\0" in text:
        raise ValueError("NUL in a string's text; use after_text_hex for padding")
    if complement:
        text = bytes(255 - c for c in text)
    if "after_text_hex" in obj:
        tail = bytes.fromhex(obj["after_text_hex"])
        if tail and tail[0] != 0:
            raise ValueError("after_text_hex must start with the NUL terminator")
        data = text + tail
        if len(data) != width:
            raise ValueError(f"string size {len(data)}, expected {width}; "
                             "remove after_text_hex to zero-pad an edited string")
        return data
    if len(text) >= width:
        raise ValueError(f"string requires a NUL; maximum text size {width-1}")
    return text.ljust(width, b"\0")


def parse_header(data: bytes) -> dict[str, Any]:
    if len(data) != HEADER_SIZE:
        raise ValueError("SNK header must be exactly 105 bytes")
    version, level, count, games, rating = struct.unpack_from("<5H", data)
    return {
        "version": version, "editor_level": level, "card_count": count,
        "battle_count": games, "rating": rating,
        "password": _string_read(data[10:21], True),
        "name": _string_read(data[21:30]),
        "date": _string_read(data[30:40]),
        "comments": [_string_read(data[40 + 21*i:61 + 21*i]) for i in range(3)],
        "color": struct.unpack_from("<H", data, 103)[0],
    }


def build_header(obj: dict[str, Any]) -> bytes:
    comments = obj["comments"]
    if len(comments) != 3:
        raise ValueError("exactly three comment lines are required")
    data = struct.pack("<5H", obj["version"], obj["editor_level"],
                       obj["card_count"], obj["battle_count"], obj["rating"])
    data += _string_write(obj["password"], 11, True)
    data += _string_write(obj["name"], 9)
    data += _string_write(obj["date"], 10)
    data += b"".join(_string_write(s, 21) for s in comments)
    data += struct.pack("<H", obj["color"])
    assert len(data) == HEADER_SIZE
    return data


def parse_card(data: bytes) -> dict[str, Any]:
    if len(data) != CARD_SIZE:
        raise ValueError("card must be exactly 152 bytes")
    group, x, y = struct.unpack_from("<Bhh", data)
    # Native indexing is x-major, unlike conventional row-major image buffers.
    columns = []
    for cx in range(7):
        column = []
        for cy in range(7):
            p = 5 + 21*cx + 3*cy
            g, negate, tile = data[p:p+3]
            column.append({"group": g, "negate": negate, "tile": tile})
        columns.append(column)
    return {"group": group, "head_x": x, "head_y": y, "columns": columns}


def build_card(obj: dict[str, Any]) -> bytes:
    if len(obj["columns"]) != 7 or any(len(c) != 7 for c in obj["columns"]):
        raise ValueError("card must have seven columns, each with seven cells")
    data = bytearray(struct.pack("<Bhh", obj["group"], obj["head_x"], obj["head_y"]))
    for column in obj["columns"]:
        for cell in column:
            data.extend((cell["group"], cell["negate"], cell["tile"]))
    return bytes(data)


def parse_snk(raw: bytes, strict: bool = True) -> dict[str, Any]:
    if len(raw) < 107:
        raise ValueError("SNK too short for seed, header and trailer")
    header_plain, _ = xor_decode(raw[1:106], raw[0])
    header = parse_header(header_plain)
    count = header["card_count"]
    if strict and (header["version"] != 1 or not 1 <= count <= MAX_CARDS):
        raise ValueError("unsupported SNK version/card count")
    expected = 107 + CARD_SIZE*count
    if len(raw) != expected:
        raise ValueError(f"SNK size {len(raw)}, expected {expected}")
    plain, last = xor_decode(raw[1:-1], raw[0])
    if strict and raw[-1] != last:
        raise ValueError("SNK trailer differs from final ciphertext byte")
    return {
        "format": "snake-battle-snk-v1", "seed": raw[0],
        "header": header,
        "cards": [parse_card(plain[105 + i*152:105 + (i+1)*152]) for i in range(count)],
        # Retaining a broken trailer is supported for archival inspection.
        "trailer": raw[-1],
        "_source_sha256": hashlib.sha256(raw).hexdigest(),
    }


def build_snk(obj: dict[str, Any], preserve_trailer: bool = False) -> bytes:
    header = dict(obj["header"])
    header["card_count"] = len(obj["cards"])
    if header["version"] != 1 or not 1 <= header["card_count"] <= MAX_CARDS:
        raise ValueError("supported SNK version is 1 with 1..9 cards")
    plain = build_header(header) + b"".join(build_card(c) for c in obj["cards"])
    encrypted, last = xor_encode(plain, obj["seed"])
    # For an edited document the checksum is recomputed by default.
    trailer = obj["trailer"] if preserve_trailer else last
    return bytes([obj["seed"]]) + encrypted + bytes([trailer])


def _pack_nibbles(values: list[int]) -> bytes:
    if len(values) % 2:
        raise ValueError("an even number of stored nibbles is required")
    if any(not 0 <= n <= 15 for n in values):
        raise ValueError("nibble outside 0..15")
    return bytes((a << 4) | b for a, b in zip(values[::2], values[1::2]))


def _unpack_nibbles(data: bytes) -> list[int]:
    return [n for b in data for n in (b >> 4, b & 15)]


def parse_rec(raw: bytes) -> dict[str, Any]:
    if len(raw) < 2:
        raise ValueError("REC missing seed/header")
    seed = raw[0]
    prev = seed
    pos = 1
    participants = []
    while pos < len(raw):
        slot = raw[pos] ^ prev
        prev = raw[pos]
        pos += 1
        if slot == 12:
            break
        if slot not in range(4) or any(p["slot"] == slot for p in participants):
            raise ValueError(f"invalid/repeated participant slot {slot} at {pos-1:#x}")
        if pos + HEADER_SIZE > len(raw):
            raise ValueError("truncated participant header")
        plain, prev = xor_decode(raw[pos:pos+HEADER_SIZE], prev)
        participants.append({"slot": slot, "header": parse_header(plain)})
        pos += HEADER_SIZE
    else:
        raise ValueError("missing REC 0x0C header terminator")
    # No XOR applies after the marker. The same channel changes mode to raw
    # high-nibble-first storage. This boundary is proven at 0E92:00F8.
    nibbles = _unpack_nibbles(raw[pos:])
    active_slots = sorted(p["slot"] for p in participants)
    events = []
    i = 0
    decisions = []
    trailing = []
    playback_stop = None
    while i < len(nibbles):
        value = nibbles[i]
        if value <= 3:
            decisions.append(value)
            i += 1
            continue
        if decisions:
            events.append({"type": "decisions", "tokens": decisions})
            decisions = []
        if value == 14:
            need = 4*len(active_slots)
            if i + 1 + need > len(nibbles):
                raise ValueError("truncated round score record")
            payload = _pack_nibbles(nibbles[i+1:i+1+need])
            scores = struct.unpack("<" + "H"*len(active_slots), payload)
            events.append({"type": "round_end", "scores": [
                {"slot": slot, "value": score} for slot, score in zip(active_slots, scores)
            ]})
            i += 1 + need
        elif value == 13:
            playback_stop = i
            # The original writes DD, then a third D if needed to complete
            # the byte. Open uses 0x8104 WITHOUT O_TRUNC: old bytes can remain
            # after this end. They do not belong to the current playback.
            count = 2 + (i & 1)
            if nibbles[i:i+count] != [13]*count:
                count = 1  # Retain malformed/noncanonical endings verbatim.
            events.append({"type": "end_markers", "count": count})
            i += count
            trailing = nibbles[i:]
            break
        else:
            # Preserve a future extension without inventing its semantics.
            events.append({"type": "unknown", "token": value})
            i += 1
    if decisions:
        events.append({"type": "decisions", "tokens": decisions})
    result = {
        "format": "snake-battle-rec-v1", "seed": seed,
        "participants": participants, "events": events,
        "_packed_stream_file_offset": pos,
        "_source_sha256": hashlib.sha256(raw).hexdigest(),
    }
    if playback_stop is not None:
        result["_playback_stop_nibble_index"] = playback_stop
        if i % 2 == 0:
            result["_recording_storage_end_file_offset"] = pos + i//2
            result["trailing_bytes_hex"] = _pack_nibbles(trailing).hex()
        else:
            # Only used for a noncanonical single-D ending in a high nibble.
            result["trailing_nibbles"] = trailing
    return result


def build_rec(obj: dict[str, Any]) -> bytes:
    header = bytearray()
    slots = []
    for participant in obj["participants"]:
        slot = participant["slot"]
        if slot not in range(4) or slot in slots:
            raise ValueError("participant slots must be distinct values 0..3")
        slots.append(slot)
        header.append(slot)
        header.extend(build_header(participant["header"]))
    header.append(12)
    encrypted, _ = xor_encode(bytes(header), obj["seed"])
    nibbles = []
    for event in obj["events"]:
        kind = event["type"]
        if kind == "decisions":
            if any(n not in range(4) for n in event["tokens"]):
                raise ValueError("decision values must be 0..3")
            nibbles.extend(event["tokens"])
        elif kind == "round_end":
            scores = event["scores"]
            if [s["slot"] for s in scores] != sorted(slots):
                raise ValueError("round scores must contain all present slots in numeric order")
            nibbles.append(14)
            payload = struct.pack("<" + "H"*len(scores), *(s["value"] for s in scores))
            nibbles.extend(_unpack_nibbles(payload))
        elif kind == "end_markers":
            nibbles.extend([13]*event["count"])
        elif kind == "unknown":
            nibbles.append(event["token"])
        else:
            raise ValueError(f"unknown event kind {kind}")
    if "trailing_bytes_hex" in obj:
        if len(nibbles) % 2:
            raise ValueError("trailing bytes require a byte-aligned event ending")
        nibbles.extend(_unpack_nibbles(bytes.fromhex(obj["trailing_bytes_hex"])))
    if "trailing_nibbles" in obj:
        nibbles.extend(obj["trailing_nibbles"])
    return bytes([obj["seed"]]) + encrypted + _pack_nibbles(nibbles)


def parse(raw: bytes, suffix: str) -> dict[str, Any]:
    if suffix.upper() == ".SNK":
        return parse_snk(raw)
    if suffix.upper() == ".REC":
        return parse_rec(raw)
    raise ValueError("use .SNK or .REC filenames")


def build(obj: dict[str, Any]) -> bytes:
    if obj["format"] == "snake-battle-snk-v1":
        return build_snk(obj)
    if obj["format"] == "snake-battle-rec-v1":
        return build_rec(obj)
    raise ValueError("unknown format")


def summary(obj: dict[str, Any]) -> dict[str, Any]:
    if obj["format"] == "snake-battle-snk-v1":
        h = obj["header"]
        return {"name": h["name"]["text"], "cards": len(obj["cards"]),
                "level": h["editor_level"], "battle_count": h["battle_count"],
                "rating": h["rating"], "color": h["color"], "date": h["date"]["text"]}
    return {"participants": [
        {"slot": p["slot"], "name": p["header"]["name"]["text"]} for p in obj["participants"]
    ], "round_scores": [e["scores"] for e in obj["events"] if e["type"] == "round_end"],
        "decision_tokens": sum(len(e["tokens"]) for e in obj["events"] if e["type"] == "decisions"),
        "end_markers": [e["count"] for e in obj["events"] if e["type"] == "end_markers"],
        "recording_storage_end_file_offset": obj.get("_recording_storage_end_file_offset"),
        "trailing_byte_count": len(bytes.fromhex(obj.get("trailing_bytes_hex", ""))),
        "unknown_tokens": [e["token"] for e in obj["events"] if e["type"] == "unknown"]}


def original_codec_check(exe: Path, cases: int = 128) -> dict[str, Any]:
    """Execute the actual original encode/decode routines in isolated x86-16.

    This is a procedure-level CPU oracle, not a DOS/gameplay execution test.
    No DOS services, graphics or filesystem code from the game is run.
    """
    from unicorn import Uc, UC_ARCH_X86, UC_MODE_16, UC_HOOK_CODE
    from unicorn.x86_const import (
        UC_X86_REG_CS, UC_X86_REG_IP, UC_X86_REG_SS, UC_X86_REG_SP,
        UC_X86_REG_DS, UC_X86_REG_AX,
    )
    original = exe.read_bytes()
    header_size = struct.unpack_from("<H", original, 8)[0]*16
    image = original[header_size:]
    u = Uc(UC_ARCH_X86, UC_MODE_16)
    u.mem_map(0, 0x100000)
    u.mem_write(0x10000, image)
    u.mem_write(0x50000, b"\xF4")
    def stop_at_return(uc, address, size, _):
        if address == 0x50000:
            uc.emu_stop()
    u.hook_add(UC_HOOK_CODE, stop_at_return)
    def invoke(entry, data, seed):
        u.mem_write(0x30000, data or b"\0")
        # far return IP:CS, then C far-pointer, int16 length, int16 seed.
        u.mem_write(0x4F000, struct.pack("<6H", 0, 0x5000, 0, 0x3000, len(data), seed))
        cs, ip = entry
        for reg, value in ((UC_X86_REG_CS, 0x1000+cs), (UC_X86_REG_IP, ip),
                           (UC_X86_REG_SS, 0x4000), (UC_X86_REG_SP, 0xF000),
                           (UC_X86_REG_DS, 0x2679)):
            u.reg_write(reg, value)
        u.emu_start((0x1000+cs)*16+ip, 0, count=max(100, 40*len(data)+100))
        if u.reg_read(UC_X86_REG_CS) != 0x5000:
            raise AssertionError("original procedure did not return")
        return bytes(u.mem_read(0x30000, len(data))), u.reg_read(UC_X86_REG_AX)&255
    rng = random.Random(0x534E414B45)
    lengths = [0, 1, 2, 105, 152, 257, 1473, 2048]
    for i in range(cases):
        length = lengths[i] if i < len(lengths) else rng.randrange(0, 1600)
        data = bytes(rng.randrange(256) for _ in range(length))
        seed = rng.randrange(256)
        for entry, method in ((CODEC_ENCODE, xor_encode), (CODEC_DECODE, xor_decode)):
            expected = method(data, seed)
            actual = invoke(entry, data, seed)
            if actual != expected:
                raise AssertionError((entry, i, length, seed))
    return {"oracle": "original x86-16 machine code executed by Unicorn",
            "exe_sha256": hashlib.sha256(original).hexdigest(),
            "cases_per_routine": cases, "routine_invocations": 2*cases,
            "encode": "0B2B:000F / file 0xC2BF",
            "decode": "0B2B:0046 / file 0xC2F6", "passed": True}


def _files(directory: Path):
    return sorted(p for p in directory.iterdir() if p.is_file() and
                  p.suffix.upper() in (".SNK", ".REC"))


def main() -> None:
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    subs = ap.add_subparsers(dest="command", required=True)
    dec = subs.add_parser("decode")
    dec.add_argument("input", type=Path)
    dec.add_argument("output", type=Path)
    enc = subs.add_parser("encode")
    enc.add_argument("input", type=Path)
    enc.add_argument("output", type=Path)
    for cmd in ("inventory", "verify"):
        sub = subs.add_parser(cmd)
        sub.add_argument("directory", type=Path)
        sub.add_argument("--json-dir", type=Path)
        sub.add_argument("--report", type=Path)
        if cmd == "verify":
            sub.add_argument("--exe", type=Path, help="also test original machine-code codec (requires Unicorn)")
    args = ap.parse_args()
    if args.command == "decode":
        obj = parse(args.input.read_bytes(), args.input.suffix)
        args.output.write_text(json.dumps(obj, ensure_ascii=False, indent=2)+"\n", encoding="utf-8")
        return
    if args.command == "encode":
        obj = json.loads(args.input.read_text(encoding="utf-8"))
        args.output.write_bytes(build(obj))
        return
    report = {"files": []}
    for path in _files(args.directory):
        raw = path.read_bytes()
        obj = parse(raw, path.suffix)
        reconstructed = build(obj)
        if reconstructed != raw:
            mismatch = next((i for i, (a,b) in enumerate(zip(raw,reconstructed)) if a != b), None)
            raise AssertionError(f"{path}: reconstruction mismatch at {mismatch}")
        if args.json_dir:
            args.json_dir.mkdir(parents=True, exist_ok=True)
            (args.json_dir/(path.name+".json")).write_text(
                json.dumps(obj, ensure_ascii=False, indent=2)+"\n", encoding="utf-8")
        report["files"].append({"filename": path.name, "size": len(raw),
                                "sha256": hashlib.sha256(raw).hexdigest(),
                                "byte_exact": True, **summary(obj)})
    report["file_count"] = len(report["files"])
    report["all_byte_exact"] = True
    if args.command == "verify" and args.exe:
        report["machine_code_check"] = original_codec_check(args.exe)
    text = json.dumps(report, ensure_ascii=False, indent=2)+"\n"
    if args.report:
        args.report.write_text(text, encoding="utf-8")
    print(text)


if __name__ == "__main__":
    main()
