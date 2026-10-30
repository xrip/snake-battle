#!/usr/bin/env python3
"""Snake Battle 2.3 GPF: lossless extraction, canonical recompression and graphics.

Reconstructed from the supplied SNAKE.EXE and SNAKE.GPF. The compressor uses
an ordered binary match tree; all 94 original streams are reproduced exactly
from the uncompressed resources, without retained compressed bytes/tokens.
Python 3 stdlib; only the optional render command needs Pillow.
"""
from __future__ import annotations
import argparse
import hashlib
import json
import struct
from pathlib import Path

SIGNATURE = b"\x1aGAMOS PACKED FILE\0"
HEADER_SIZE, ENTRY_SIZE = 33, 22
RING_SIZE, MATCH_MAX, INITIAL_CURSOR = 4096, 18, 4078


def sha256(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def lzss_decode(data: bytes, expected_size: int | None = None) -> bytes:
    """EXE file 0x1438D / original image 0x1338D, CS 1238:100D.

    Flags are LSB first. Token word: bits 0..11 absolute ring position;
    bits 12..15 length-3. Each call resets positions 0..4077 to ASCII space.
    The original leaves the last 18 ring bytes untouched; valid streams in
    this archive never read those bytes before writing them in the same call.
    """
    ring = bytearray(b" " * INITIAL_CURSOR + b"\0" * MATCH_MAX)
    initialized = bytearray(b"\1" * INITIAL_CURSOR + b"\0" * MATCH_MAX)
    cursor = INITIAL_CURSOR
    pos = 0
    out = bytearray()
    while pos < len(data):
        flags = data[pos]
        pos += 1
        for bit in range(8):
            if pos == len(data):
                break
            if flags & (1 << bit):
                value = data[pos]
                pos += 1
                out.append(value)
                ring[cursor] = value
                initialized[cursor] = 1
                cursor = (cursor + 1) & 0xFFF
            else:
                if pos + 2 > len(data):
                    raise ValueError("truncated two-byte LZSS match")
                token = data[pos] | (data[pos + 1] << 8)
                pos += 2
                source, length = token & 0xFFF, (token >> 12) + 3
                for i in range(length):
                    address = (source + i) & 0xFFF
                    if not initialized[address]:
                        raise ValueError("LZSS depends on unwritten persistent decoder state")
                    value = ring[address]
                    out.append(value)
                    ring[cursor] = value
                    initialized[cursor] = 1
                    cursor = (cursor + 1) & 0xFFF
            if expected_size is not None and len(out) > expected_size:
                raise ValueError("decoded stream exceeds declared output length")
            if len(out) > 65535:
                raise ValueError("a GPF LZSS stream exceeds a 16-bit output segment")
    if expected_size is not None and len(out) != expected_size:
        raise ValueError(f"decoded length {len(out)} != {expected_size}")
    return bytes(out)


def lzss_encode(data: bytes) -> bytes:
    """Canonical original-compatible greedy binary-tree LZSS encoder.

    Ordered roots are selected by the first byte; comparison uses unsigned
    bytes. A strictly longer match replaces the current candidate. An exact
    18-byte match replaces the old tree node. These tie-breaking details are
    required for byte equality, not merely for successful decompression.
    """
    n, f, nil = RING_SIZE, MATCH_MAX, RING_SIZE
    text = bytearray(n + f - 1)
    left = [nil] * (n + 1)
    right = [nil] * (n + 257)
    parent = [nil] * (n + 1)
    match_position = match_length = 0

    def insert(node: int) -> None:
        nonlocal match_position, match_length
        comparison = 1
        p = n + 1 + text[node]
        right[node] = left[node] = nil
        match_length = 0
        while True:
            if comparison >= 0:
                if right[p] != nil:
                    p = right[p]
                else:
                    right[p], parent[node] = node, p
                    return
            else:
                if left[p] != nil:
                    p = left[p]
                else:
                    left[p], parent[node] = node, p
                    return
            i = 1
            while i < f:
                comparison = text[node + i] - text[p + i]
                if comparison:
                    break
                i += 1
            if i > match_length:
                match_position, match_length = p, i
                if i >= f:
                    break
        parent[node], left[node], right[node] = parent[p], left[p], right[p]
        parent[left[p]] = parent[right[p]] = node
        if right[parent[p]] == p:
            right[parent[p]] = node
        else:
            left[parent[p]] = node
        parent[p] = nil

    def delete(node: int) -> None:
        if parent[node] == nil:
            return
        if right[node] == nil:
            successor = left[node]
        elif left[node] == nil:
            successor = right[node]
        else:
            successor = left[node]
            if right[successor] != nil:
                while right[successor] != nil:
                    successor = right[successor]
                right[parent[successor]] = left[successor]
                parent[left[successor]] = parent[successor]
                left[successor] = left[node]
                parent[left[node]] = successor
            right[successor] = right[node]
            parent[right[node]] = successor
        parent[successor] = parent[node]
        if right[parent[node]] == node:
            right[parent[node]] = successor
        else:
            left[parent[node]] = successor
        parent[node] = nil

    oldest, cursor = 0, n - f
    text[:cursor] = b" " * cursor
    available = min(f, len(data))
    text[cursor:cursor + available] = data[:available]
    pos = available
    if not available:
        return b""
    for i in range(1, f + 1):
        insert(cursor - i)
    insert(cursor)
    result = bytearray()
    group = bytearray([0])
    flag = 1
    while available:
        match_length = min(match_length, available)
        if match_length <= 2:
            match_length = 1
            group[0] |= flag
            group.append(text[cursor])
        else:
            group.extend(struct.pack("<H", match_position | ((match_length - 3) << 12)))
        flag <<= 1
        if flag == 256:
            result.extend(group)
            group, flag = bytearray([0]), 1
        consumed = match_length
        i = 0
        while i < consumed and pos < len(data):
            value = data[pos]
            pos += 1
            delete(oldest)
            text[oldest] = value
            if oldest < f - 1:
                text[oldest + n] = value
            oldest, cursor = (oldest + 1) & (n - 1), (cursor + 1) & (n - 1)
            insert(cursor)
            i += 1
        while i < consumed:
            delete(oldest)
            oldest, cursor = (oldest + 1) & (n - 1), (cursor + 1) & (n - 1)
            available -= 1
            if available:
                insert(cursor)
            i += 1
    if len(group) > 1:
        result.extend(group)
    return bytes(result)


def read_gpf(data: bytes) -> dict:
    if len(data) < HEADER_SIZE or data[:19] != SIGNATURE:
        raise ValueError("not the observed GAMOS PACKED FILE format")
    count = struct.unpack_from("<H", data, 23)[0]
    directory_end = HEADER_SIZE + count * ENTRY_SIZE
    if directory_end > len(data):
        raise ValueError("truncated directory")
    entries = []
    next_offset = directory_end
    names = set()
    for ordinal in range(count):
        raw = data[HEADER_SIZE + ordinal * ENTRY_SIZE:HEADER_SIZE + (ordinal + 1) * ENTRY_SIZE]
        name_field, method, offset, packed, unpacked = struct.unpack("<13sBIHH", raw)
        name = name_field.split(b"\0", 1)[0].decode("ascii")
        if not name or Path(name).name != name or "/" in name or "\\" in name or name in names:
            raise ValueError("unsafe/duplicate archive name")
        names.add(name)
        if offset != next_offset or offset + packed > len(data):
            raise ValueError("unsupported gaps, overlaps or truncated member")
        next_offset = offset + packed
        compressed = data[offset:next_offset]
        chunks = []
        if method == 1:
            decoded = lzss_decode(compressed, unpacked)
            chunks = [{"stored_size": packed, "decoded_size": unpacked}]
        elif method == 2:
            position, parts = 0, []
            while position < len(compressed):
                if position + 2 > len(compressed):
                    raise ValueError("truncated screen chunk header")
                length = struct.unpack_from("<H", compressed, position)[0]
                position += 2
                if position + length > len(compressed):
                    raise ValueError("truncated screen chunk")
                part = lzss_decode(compressed[position:position + length], 28000)
                chunks.append({"stored_size": length, "decoded_size": len(part)})
                parts.append(part)
                position += length
            if len(parts) != 4 or unpacked != 0:
                raise ValueError("unsupported method-2 screen layout")
            decoded = b"".join(parts)
        elif method == 0:
            decoded = compressed  # defined raw path; not present in this supplied GPF
        else:
            raise ValueError(f"unsupported GPF method {method}")
        entries.append({"index": ordinal, "name": name, "name_field_hex": name_field.hex(),
                        "method": method, "original_offset": offset,
                        "original_stored_size": packed, "directory_decoded_size": unpacked,
                        "decoded_size": len(decoded), "decoded_sha256": sha256(decoded),
                        "stored_sha256": sha256(compressed), "chunks": chunks,
                        "data": decoded})
    if next_offset != len(data):
        raise ValueError("unsupported trailing GPF bytes")
    return {"format": "GAMOS-GPF-SnakeBattle-2.3", "signature_hex": data[:19].hex(),
            "header_bytes_19_22_hex": data[19:23].hex(), "reserved_25_32_hex": data[25:33].hex(),
            "original_size": len(data), "original_sha256": sha256(data), "entries": entries}


def unpack(path: Path, directory: Path) -> dict:
    archive = read_gpf(path.read_bytes())
    resources = directory / "resources"
    resources.mkdir(parents=True, exist_ok=True)
    for entry in archive["entries"]:
        (resources / entry["name"]).write_bytes(entry.pop("data"))
    (directory / "gpf_manifest.json").write_text(json.dumps(archive, indent=2) + "\n")
    return archive


def pack(manifest_path: Path) -> bytes:
    manifest = json.loads(manifest_path.read_text())
    entries = manifest["entries"]
    header = (bytes.fromhex(manifest["signature_hex"]) +
              bytes.fromhex(manifest["header_bytes_19_22_hex"]) + struct.pack("<H", len(entries)) +
              bytes.fromhex(manifest["reserved_25_32_hex"]))
    if len(header) != HEADER_SIZE:
        raise ValueError("bad manifest header lengths")
    directory, payloads = bytearray(), bytearray()
    offset = HEADER_SIZE + len(entries) * ENTRY_SIZE
    for entry in entries:
        name = entry["name"]
        if Path(name).name != name or "/" in name or "\\" in name:
            raise ValueError("unsafe manifest resource name")
        content = (manifest_path.parent / "resources" / name).read_bytes()
        method = entry["method"]
        if method == 1:
            compressed, unpacked = lzss_encode(content), len(content)
        elif method == 2:
            if len(content) != 112000:
                raise ValueError("screen must contain four 28000-byte planes")
            blocks = [lzss_encode(content[p * 28000:(p + 1) * 28000]) for p in range(4)]
            compressed = b"".join(struct.pack("<H", len(block)) + block for block in blocks)
            unpacked = 0
        elif method == 0:
            compressed, unpacked = content, entry["directory_decoded_size"]
        else:
            raise ValueError("unknown compression method")
        raw_name = bytes.fromhex(entry["name_field_hex"])
        if raw_name.split(b"\0", 1)[0] != name.encode("ascii") or len(raw_name) != 13:
            raise ValueError("manifest name and name_field_hex disagree")
        if len(compressed) > 65535 or unpacked > 65535:
            raise ValueError("member exceeds a 16-bit GPF size field")
        directory.extend(struct.pack("<13sBIHH", raw_name, method, offset, len(compressed), unpacked))
        payloads.extend(compressed)
        offset += len(compressed)
    return header + directory + payloads


EGA_PALETTE = [(0, 0, 0), (0, 0, 170), (0, 170, 0), (0, 170, 170),
               (170, 0, 0), (170, 0, 170), (170, 85, 0), (170, 170, 170),
               (85, 85, 85), (85, 85, 255), (85, 255, 85), (85, 255, 255),
               (255, 85, 85), (255, 85, 255), (255, 255, 85), (255, 255, 255)]


def blo_info(data: bytes, full_screen: bool = False) -> dict:
    if full_screen:
        if len(data) != 112000:
            raise ValueError("bad full-screen size")
        return {"width": 640, "height": 350, "stride": 80,
                "plane_offsets": [0, 28000, 56000, 84000], "plane_color_bits": [0, 1, 2, 3], "layout": "full_screen"}
    if len(data) < 32:
        raise ValueError("truncated BLO header")
    width, height, stride, flags = struct.unpack_from("<4H", data)
    planes = [16 * i for i in struct.unpack_from("<4H", data, 8)]
    if width < 1 or height < 1 or stride < (width + 7) // 8:
        raise ValueError("bad BLO dimensions")
    if any(offset + stride * height > len(data) for offset in planes):
        raise ValueError("BLO plane outside resource")
    return {"width": width, "height": height, "stride": stride, "flags": flags,
            "plane_offsets": planes, "preserved_header_tail_16_31_hex": data[16:32].hex(),
            "plane_color_bits": [3, 2, 1, 0],
            "layout": "sprite"}


def blo_image(data: bytes, full_screen: bool = False):
    from PIL import Image
    description = blo_info(data, full_screen)
    w, h, stride, planes = (description[k] for k in ("width", "height", "stride", "plane_offsets"))
    image = Image.new("P", (w, h))
    image.putpalette([v for color in EGA_PALETTE for v in color])
    pixels = bytearray(w * h)
    for y in range(h):
        for x in range(w):
            byte, shift = y * stride + x // 8, 7 - x % 8
            pixels[y * w + x] = sum(((data[offset + byte] >> shift) & 1) << plane
                                    for plane, offset in zip(description["plane_color_bits"], planes))
    image.putdata(pixels)
    return image.convert("RGB")


def render(manifest_path: Path, output: Path) -> dict:
    from PIL import Image, ImageDraw, ImageFont
    manifest = json.loads(manifest_path.read_text())
    output.mkdir(parents=True, exist_ok=True)
    metadata, sprites, screens = [], [], []
    for entry in manifest["entries"]:
        if not entry["name"].endswith(".BLO"):
            continue
        data = (manifest_path.parent / "resources" / entry["name"]).read_bytes()
        screen = entry["method"] == 2
        description = blo_info(data, screen)
        description["name"] = entry["name"]
        image = blo_image(data, screen)
        image.save(output / (entry["name"] + ".png"))
        metadata.append(description)
        (screens if screen else sprites).append((entry["name"], image))
    try:
        font = ImageFont.truetype("DejaVuSans.ttf", 13)
    except OSError:
        font = ImageFont.load_default()
    # Compact overview: full-size screens plus four-column sprite/contact sheet.
    sheet = Image.new("RGB", (1320, 770), (24, 27, 35))
    draw = ImageDraw.Draw(sheet)
    for i, (name, image) in enumerate(screens):
        x, y = 10 + (i % 2) * 660, 10 + (i // 2) * 380
        draw.text((x, y), name + " | 640 x 350 | four EGA planes", font=font, fill="white")
        sheet.paste(image, (x, y + 22))
    sheet.save(output / "screens-overview.png")
    columns, cell_w = 4, 340
    rows = []
    for i in range(0, len(sprites), columns):
        row = sprites[i:i + columns]
        rows.append((row, max(min(im.height, 280) for _, im in row) + 40))
    sheet = Image.new("RGB", (columns * cell_w, sum(h for _, h in rows)), (24, 27, 35))
    draw, top = ImageDraw.Draw(sheet), 0
    for row, height in rows:
        for column, (name, im) in enumerate(row):
            x = column * cell_w + 8
            draw.text((x, top + 7), f"{name} | {im.width} x {im.height}", font=font, fill="white")
            scaled = im.copy()
            scaled.thumbnail((324, 280), Image.Resampling.NEAREST)
            sheet.paste(scaled, (x, top + 30))
        top += height
    sheet.save(output / "sprites-overview.png")
    (output / "graphics.json").write_text(json.dumps(metadata, indent=2) + "\n")
    return {"graphics": len(metadata), "screens": len(screens), "sprites": len(sprites)}


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    sub = parser.add_subparsers(dest="command", required=True)
    unpack_parser = sub.add_parser("unpack")
    unpack_parser.add_argument("archive", type=Path)
    unpack_parser.add_argument("directory", type=Path)
    pack_parser = sub.add_parser("pack")
    pack_parser.add_argument("manifest", type=Path)
    pack_parser.add_argument("output", type=Path)
    verify_parser = sub.add_parser("verify")
    verify_parser.add_argument("original", type=Path)
    verify_parser.add_argument("manifest", type=Path)
    verify_parser.add_argument("--report", type=Path)
    render_parser = sub.add_parser("render")
    render_parser.add_argument("manifest", type=Path)
    render_parser.add_argument("output", type=Path)
    args = parser.parse_args()
    if args.command == "unpack":
        result = unpack(args.archive, args.directory)
        print(f"Extracted {len(result['entries'])} members; archive SHA-256 {result['original_sha256']}")
    elif args.command == "pack":
        result = pack(args.manifest)
        args.output.parent.mkdir(parents=True, exist_ok=True)
        args.output.write_bytes(result)
        print(f"Wrote {len(result)} bytes; SHA-256 {sha256(result)}")
    elif args.command == "verify":
        original = args.original.read_bytes()
        rebuilt = pack(args.manifest)
        parsed = read_gpf(original)
        report = {"original_size": len(original), "rebuilt_size": len(rebuilt),
                  "original_sha256": sha256(original), "rebuilt_sha256": sha256(rebuilt),
                  "byte_exact": original == rebuilt, "member_count": len(parsed["entries"]),
                  "lzss_streams": sum(len(e["chunks"]) for e in parsed["entries"]),
                  "method": "recompress each decoded resource with ordered match-tree encoder",
                  "compressed_original_bytes_needed_by_rebuild": False}
        if args.report:
            args.report.parent.mkdir(parents=True, exist_ok=True)
            args.report.write_text(json.dumps(report, indent=2) + "\n")
        print(json.dumps(report, indent=2))
        if original != rebuilt:
            raise SystemExit(1)
    else:
        print(json.dumps(render(args.manifest, args.output), indent=2))


if __name__ == "__main__":
    main()
