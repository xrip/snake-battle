#!/usr/bin/env python3
"""Read 16/32-bit Intel OMF object/library records and match linker-stable code.

This is an analysis utility, not an OMF linker. It reads the OMF records used by
Borland's real-mode CRT libraries. Unknown records remain in the record inventory.
Fixup locations are preserved explicitly; they are never treated as original
machine-code bytes. Optional far-transfer relaxation additionally accepts TLINK's
90 0E E8 xx xx / 0E E8 xx xx 90 replacements of CALL FAR and 90 90 E9 xx xx /
E9 xx xx 90 90 replacements of JMP FAR.

Reference: TIS OMF 1.1; Intel 8086 Object Module Formats, November 1981.
"""
from __future__ import annotations

import argparse
import hashlib
import json
import struct
from dataclasses import dataclass, field
from pathlib import Path


class OMFError(ValueError):
    pass


class Reader:
    def __init__(self, data: bytes):
        self.data = data
        self.pos = 0

    def take(self, n: int) -> bytes:
        p = self.pos
        self.pos += n
        if self.pos > len(self.data):
            raise OMFError(f"record truncated at +{p:#x}, requested {n} bytes")
        return self.data[p:self.pos]

    def byte(self) -> int:
        return self.take(1)[0]

    def word(self, wide: bool = False) -> int:
        return int.from_bytes(self.take(4 if wide else 2), "little")

    def index(self) -> int:
        x = self.byte()
        return ((x & 0x7f) << 8) | self.byte() if x & 0x80 else x

    def name(self) -> str:
        return self.take(self.byte()).decode("latin-1")

    def number(self) -> int:
        leaf = self.byte()
        if leaf <= 0x80:
            return leaf
        widths = {0x81: 2, 0x84: 3, 0x88: 4}
        if leaf not in widths:
            raise OMFError(f"unsupported communal numeric leaf {leaf:#x}")
        return int.from_bytes(self.take(widths[leaf]), "little")

    def remaining(self) -> bool:
        return self.pos < len(self.data)


LOCATION_WIDTHS = {0: 1, 1: 2, 2: 2, 3: 4, 4: 1, 5: 2,
                   9: 4, 11: 6, 13: 4}
METHOD_NAMES = {0: "segment", 1: "group", 2: "external", 3: "absolute",
                4: "location", 5: "target", 6: "none"}


def ranges(mask: bytes | bytearray) -> list[list[int]]:
    result = []
    start = None
    for i in range(len(mask) + 1):
        active = i < len(mask) and bool(mask[i])
        if active and start is None:
            start = i
        elif not active and start is not None:
            result.append([start, i])
            start = None
    return result


@dataclass
class Segment:
    index: int
    name: str
    class_name: str
    overlay: str
    attributes: int
    size: int
    record_offset: int
    absolute_frame: int | None = None
    absolute_offset: int | None = None
    data: bytearray = field(default_factory=bytearray)
    initialized: bytearray = field(default_factory=bytearray)
    fixups: list[dict] = field(default_factory=list)
    records: list[dict] = field(default_factory=list)

    def __post_init__(self):
        if self.size > 16 * 1024 * 1024:
            raise OMFError("segment too large for this analysis utility")
        self.data = bytearray(self.size)
        self.initialized = bytearray(self.size)

    def put(self, offset: int, data: bytes, record_offset: int, kind: str):
        if offset < 0 or offset + len(data) > self.size:
            raise OMFError(f"{self.name}: data outside declared segment")
        for i, value in enumerate(data, offset):
            if self.initialized[i] and self.data[i] != value:
                raise OMFError(f"{self.name}: inconsistent overlapping LEDATA")
        self.data[offset:offset+len(data)] = data
        self.initialized[offset:offset+len(data)] = b"\x01" * len(data)
        self.records.append(dict(file_offset=record_offset, kind=kind,
                                 segment_offset=offset, size=len(data)))

    def to_dict(self):
        return dict(index=self.index, name=self.name, class_name=self.class_name,
                    overlay=self.overlay, attributes=self.attributes, size=self.size,
                    record_offset=self.record_offset, absolute_frame=self.absolute_frame,
                    absolute_offset=self.absolute_offset, data_hex=self.data.hex(),
                    initialized_ranges=ranges(self.initialized),
                    data_records=self.records, fixups=self.fixups)


@dataclass
class Module:
    name: str
    file_offset: int
    end_offset: int = 0
    names: list[str] = field(default_factory=lambda: [""])
    segments: list[Segment] = field(default_factory=list)
    groups: list[dict] = field(default_factory=list)
    externals: list[dict] = field(default_factory=list)
    publics: list[dict] = field(default_factory=list)
    records: list[dict] = field(default_factory=list)
    comments: list[dict] = field(default_factory=list)
    threads: dict = field(default_factory=lambda: {"frame": {}, "target": {}})
    last_data: dict | None = None

    def to_dict(self):
        return dict(name=self.name, file_offset=self.file_offset,
                    end_offset=self.end_offset, names=self.names,
                    segments=[s.to_dict() for s in self.segments],
                    groups=self.groups, externals=self.externals,
                    publics=self.publics, records=self.records, comments=self.comments)

    def reference(self, method: int, datum: int | None) -> dict:
        ref = dict(method=method, method_name=METHOD_NAMES.get(method, "unknown"), datum=datum)
        if datum is not None:
            if method == 0 and 0 < datum <= len(self.segments):
                ref["name"] = self.segments[datum-1].name
            elif method == 1 and 0 < datum <= len(self.groups):
                ref["name"] = self.groups[datum-1]["name"]
            elif method == 2 and 0 < datum <= len(self.externals):
                ref["name"] = self.externals[datum-1]["name"]
        return ref


def _datum(r: Reader, method: int) -> int | None:
    if method <= 2:
        return r.index()
    if method == 3:
        return r.word()
    return None


def _lidata_block(r: Reader, wide: bool, depth=0) -> bytes:
    if depth > 64:
        raise OMFError("nested LIDATA too deep")
    repeats, count = r.word(wide), r.word()
    if count:
        block = b"".join(_lidata_block(r, wide, depth+1) for _ in range(count))
    else:
        block = r.take(r.byte())
    if repeats * len(block) > 16 * 1024 * 1024:
        raise OMFError("expanded LIDATA too large")
    return block * repeats


def _fixupp(m: Module, r: Reader, wide: bool, file_offset: int):
    while r.remaining():
        sub_offset = r.pos
        a = r.byte()
        if not a & 0x80:
            kind = "frame" if a & 0x40 else "target"
            method = (a >> 2) & 7
            if kind == "target":
                method &= 3
            m.threads[kind][a & 3] = m.reference(method, _datum(r, method))
            continue
        if m.last_data is None:
            raise OMFError("FIXUP without preceding data")
        location = ((a & 3) << 8) | r.byte()
        location_type = (a >> 2) & 15
        if location_type not in LOCATION_WIDTHS:
            raise OMFError(f"unsupported FIXUP location type {location_type}")
        fd = r.byte()
        if fd & 0x80:
            frame = dict(m.threads["frame"][(fd >> 4) & 3])
            frame["thread"] = (fd >> 4) & 3
        else:
            method = (fd >> 4) & 7
            frame = m.reference(method, _datum(r, method))
        if fd & 8:
            target = dict(m.threads["target"][fd & 3])
            target["thread"] = fd & 3
        else:
            method = fd & 3
            target = m.reference(method, _datum(r, method))
        displacement = 0 if fd & 4 else r.word(wide)
        # LIDATA fixups refer to the encoded iteration records, not simply to
        # expanded bytes. None occur in the compared CODE segments. Refuse a
        # misleading mask until that mapping is implemented.
        if m.last_data["kind"] != "LEDATA":
            raise OMFError("LIDATA/COMDAT fixup expansion not implemented")
        seg = m.segments[m.last_data["segment"] - 1]
        offset = m.last_data["offset"] + location
        width = LOCATION_WIDTHS[location_type]
        if location + width > m.last_data["size"]:
            raise OMFError("FIXUP location outside preceding data")
        seg.fixups.append(dict(record_offset=file_offset, subrecord_offset=sub_offset,
                               offset=offset, width=width, location_type=location_type,
                               mode="segment_relative" if a & 0x40 else "self_relative",
                               frame=frame, target=target, displacement=displacement))


def parse_omf(path: str | Path) -> list[Module]:
    """Return modules, with reconstructed segments and explicit fixup metadata."""
    data = Path(path).read_bytes()
    offset, page_size, dictionary = 0, None, len(data)
    modules, current = [], None
    while offset < min(len(data), dictionary):
        if offset + 3 > len(data):
            raise OMFError(f"short record header at {offset:#x}")
        kind = data[offset]
        length = int.from_bytes(data[offset+1:offset+3], "little")
        end = offset + 3 + length
        if length < 1 or end > len(data):
            raise OMFError(f"invalid record {kind:#x} at {offset:#x}, length {length}")
        raw, body = data[offset:end], data[offset+3:end-1]
        checksum_ok = sum(raw) % 256 == 0
        if raw[-1] != 0 and not checksum_ok:
            raise OMFError(f"bad record checksum at {offset:#x}")
        r = Reader(body)
        wide = bool(kind & 1)
        base = kind & 0xfe
        if kind == 0xf0:
            page_size = length + 3
            dictionary = int.from_bytes(body[:4], "little")
            if dictionary == 0:
                dictionary = len(data)
        elif kind == 0xf1:
            break
        elif base == 0x80:
            if current is not None:
                raise OMFError("THEADR before previous module ended")
            current = Module(r.name(), offset)
            modules.append(current)
        elif current is None:
            raise OMFError(f"record outside module at {offset:#x}")
        if current:
            current.records.append(dict(file_offset=offset, kind=kind, length=length,
                                        checksum_valid=checksum_ok,
                                        checksum_omitted=(raw[-1] == 0 and not checksum_ok)))
            try:
                if base == 0x96:
                    while r.remaining():
                        current.names.append(r.name())
                elif base == 0x98:
                    attr = r.byte()
                    frame, abs_offset = (r.word(), r.byte()) if attr >> 5 == 0 else (None, None)
                    size = r.word(wide)
                    if attr & 2 and size == 0:
                        size = 1 << (32 if wide else 16)
                    ni, ci, oi = r.index(), r.index(), r.index()
                    current.segments.append(Segment(len(current.segments)+1,
                        current.names[ni], current.names[ci], current.names[oi],
                        attr, size, offset, frame, abs_offset))
                elif base == 0x9a:
                    name, segs = current.names[r.index()], []
                    while r.remaining():
                        if r.byte() != 0xff:
                            raise OMFError("unsupported GRPDEF member")
                        segs.append(r.index())
                    current.groups.append(dict(name=name, segments=segs))
                elif base in (0x8c, 0xb4):
                    while r.remaining():
                        current.externals.append(dict(name=r.name(), type_index=r.index(),
                                                      kind="LEXTDEF" if base == 0xb4 else "EXTDEF"))
                elif base == 0xbc:
                    while r.remaining():
                        current.externals.append(dict(name=current.names[r.index()],
                            type_index=r.index(), kind="CEXTDEF"))
                elif base in (0xb0, 0xb8):
                    while r.remaining():
                        name, type_index, dtype = r.name(), r.index(), r.byte()
                        if dtype == 0x61:
                            count, element_size = r.number(), r.number()
                        elif dtype == 0x62:
                            count, element_size = 1, r.number()
                        else:
                            raise OMFError(f"unsupported communal type {dtype:#x}")
                        current.externals.append(dict(name=name, type_index=type_index,
                            kind="COMDEF", data_type=dtype, count=count, element_size=element_size))
                elif base in (0x90, 0xb6):
                    group, seg = r.index(), r.index()
                    frame = r.word() if seg == 0 else None
                    while r.remaining():
                        current.publics.append(dict(name=r.name(), group=group, segment=seg,
                            frame=frame, offset=r.word(wide), type_index=r.index(),
                            local=(base == 0xb6), record_offset=offset))
                elif base in (0xa0, 0xa2):
                    si, off = r.index(), r.word(wide)
                    if base == 0xa0:
                        payload = r.take(len(body)-r.pos)
                        data_kind = "LEDATA"
                    else:
                        parts = []
                        while r.remaining():
                            parts.append(_lidata_block(r, wide))
                        payload, data_kind = b"".join(parts), "LIDATA"
                    current.segments[si-1].put(off, payload, offset, data_kind)
                    current.last_data = dict(segment=si, offset=off, size=len(payload), kind=data_kind)
                elif base == 0x9c:
                    _fixupp(current, r, wide, offset)
                elif base == 0xb2:
                    current.last_data = dict(kind="COMDAT")
                elif base == 0x88:
                    current.comments.append(dict(file_offset=offset, data_hex=body.hex(),
                        text="".join(chr(c) if 32 <= c < 127 else "." for c in body)))
                elif base == 0x8a:
                    current.end_offset = end
                    current = None
                    if page_size:
                        end = ((end + page_size - 1) // page_size) * page_size
            except (IndexError, KeyError, OMFError) as exc:
                raise OMFError(f"{path}, module {modules[-1].name}, record {kind:#x} "
                               f"at {offset:#x}: {exc}") from exc
        offset = end
    if current is not None:
        raise OMFError("module missing MODEND")
    return modules


def stable_mask(segment: Segment, relax_far_calls: bool = True):
    mask = bytearray(segment.initialized)
    relaxations = []
    for f in segment.fixups:
        p, w = f["offset"], f["width"]
        mask[p:p+w] = b"\0" * w
        if relax_far_calls and f["location_type"] == 3 and p > 0 and segment.data[p-1] in (0x9a, 0xea):
            mask[p-1] = 0
            relaxations.append(p-1)
    return mask, relaxations


def read_mz(path: str | Path):
    data = Path(path).read_bytes()
    if data[:2] != b"MZ":
        raise OMFError("expected MZ executable")
    header_size = struct.unpack_from("<H", data, 8)[0] * 16
    reloc_count = struct.unpack_from("<H", data, 6)[0]
    reloc_offset = struct.unpack_from("<H", data, 0x18)[0]
    relocs = []
    for i in range(reloc_count):
        off, seg = struct.unpack_from("<HH", data, reloc_offset + 4*i)
        relocs.append(16*seg+off)
    return data[header_size:], header_size, relocs


def match_segment(segment: Segment, image: bytes, relax_far_calls=True,
                  minimum_stable=12, maximum_matches=100):
    mask, relaxations = stable_mask(segment, relax_far_calls)
    stable_ranges = ranges(mask)
    if sum(mask) < minimum_stable or not stable_ranges:
        return []
    a, b = max(stable_ranges, key=lambda z: z[1]-z[0])
    anchor = bytes(segment.data[a:b])
    matches, start = [], 0
    while True:
        found = image.find(anchor, start)
        if found < 0:
            break
        start = found+1
        origin = found-a
        if origin < 0 or origin + segment.size > len(image):
            continue
        if not all(image[origin+x:origin+y] == segment.data[x:y] for x, y in stable_ranges):
            continue
        actual_relaxations, bad = [], False
        for p in relaxations:
            raw = image[origin+p:origin+p+5]
            original_opcode = segment.data[p]
            if raw[0] == original_opcode:
                continue
            if original_opcode == 0x9a and raw[:3] == b"\x90\x0e\xe8":
                actual_relaxations.append(dict(offset=p, replacement="NOP; PUSH CS; CALL near"))
            elif original_opcode == 0x9a and raw[:2] == b"\x0e\xe8" and raw[4] == 0x90:
                actual_relaxations.append(dict(offset=p, replacement="PUSH CS; CALL near; NOP"))
            elif original_opcode == 0xea and raw[:3] == b"\x90\x90\xe9":
                actual_relaxations.append(dict(offset=p, replacement="NOP; NOP; JMP near"))
            elif original_opcode == 0xea and raw[0] == 0xe9 and raw[3:] == b"\x90\x90":
                actual_relaxations.append(dict(offset=p, replacement="JMP near; NOP; NOP"))
            else:
                bad = True
                break
        if not bad:
            matches.append(dict(image_offset=origin, size=segment.size,
                stable_bytes=sum(mask), masked_bytes=segment.size-sum(mask),
                anchor_offset=a, anchor_length=b-a,
                relaxed_calls=[r for r in actual_relaxations if "CALL" in r["replacement"]],
                relaxed_transfers=actual_relaxations))
            if len(matches) > maximum_matches:
                return []
    return matches


def match_modules(modules: list[Module], image: bytes, header_size: int,
                  relax_far_calls=True, minimum_stable=12) -> list[dict]:
    result = []
    for m in modules:
        for s in m.segments:
            if s.class_name.upper() != "CODE":
                continue
            matches = match_segment(s, image, relax_far_calls, minimum_stable)
            if matches:
                mask, relaxations = stable_mask(s, relax_far_calls)
                for candidate in matches:
                    candidate["file_offset"] = header_size + candidate["image_offset"]
                result.append(dict(module=m.name, module_file_offset=m.file_offset,
                    segment_index=s.index, segment_name=s.name, segment_size=s.size,
                    candidate_count=len(matches), candidates=matches,
                    stable_ranges=ranges(mask), fixups=s.fixups,
                    potential_far_transfer_relaxations=relaxations,
                    symbols=[p for p in m.publics if p["segment"] == s.index]))
    return result


def main():
    p = argparse.ArgumentParser(description=__doc__)
    sub = p.add_subparsers(dest="command", required=True)
    d = sub.add_parser("dump")
    d.add_argument("input", type=Path)
    d.add_argument("-o", "--output", type=Path)
    m = sub.add_parser("match")
    m.add_argument("input", type=Path)
    m.add_argument("--exe", required=True, type=Path)
    m.add_argument("-o", "--output", type=Path)
    m.add_argument("--no-relax-far-calls", action="store_true")
    m.add_argument("--minimum-stable", type=int, default=12)
    a = p.parse_args()
    modules = parse_omf(a.input)
    result = dict(input=str(a.input), sha256=hashlib.sha256(a.input.read_bytes()).hexdigest(),
                  module_count=len(modules))
    if a.command == "dump":
        result["modules"] = [mod.to_dict() for mod in modules]
    else:
        image, header_size, relocs = read_mz(a.exe)
        result.update(exe=str(a.exe), exe_sha256=hashlib.sha256(a.exe.read_bytes()).hexdigest(),
            mz_header_size=header_size, mz_relocations=relocs,
            matches=match_modules(modules, image, header_size, not a.no_relax_far_calls,
                                  a.minimum_stable))
        result["matched_segment_count"] = len(result["matches"])
        result["unique_segment_count"] = sum(v["candidate_count"] == 1 for v in result["matches"])
    output = json.dumps(result, ensure_ascii=False, indent=2) + "\n"
    if a.output:
        a.output.parent.mkdir(parents=True, exist_ok=True)
        a.output.write_text(output, encoding="utf-8")
        print(f"{a.output}: {len(modules)} modules" + (f", {result['matched_segment_count']} matching CODE segments, "
              f"{result['unique_segment_count']} unique" if a.command == "match" else ""))
    else:
        print(output, end="")


if __name__ == "__main__":
    main()
