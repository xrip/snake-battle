#!/usr/bin/env python3
"""Compare three complete C-compiled Borland procedures with SNAKE.EXE.

Uses the Borland linker MAP and the two MZ headers. No masking, relocation
normalization, searching for byte arrays, or executable reconstruction occurs.
These particular procedures contain no relocation operands or external calls.
"""
import argparse
import hashlib
import json
from pathlib import Path
import re
import struct

PROCEDURES = (
    ("snk_encode", "0B2B:000F", 0xC2BF, 55),
    ("snk_decode", "0B2B:0046", 0xC2F6, 61),
    ("snk_complement_password", "044D:022F", 0x56FF, 30),
)


def sha(data):
    return hashlib.sha256(data).hexdigest()


def main():
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("--original", type=Path, required=True)
    ap.add_argument("--rebuilt", type=Path, required=True)
    ap.add_argument("--map", type=Path, required=True)
    ap.add_argument("--report", type=Path)
    args = ap.parse_args()
    original = args.original.read_bytes()
    rebuilt = args.rebuilt.read_bytes()
    if original[:2] != b"MZ" or rebuilt[:2] != b"MZ":
        raise ValueError("both executables must have MZ headers")
    header_size = struct.unpack_from("<H", rebuilt, 8)[0]*16
    listing = args.map.read_text(encoding="ascii", errors="strict")
    root = Path(__file__).resolve().parent.parent
    result = {
        "compiler": "Borland C++ 3.1 (1992), 16-bit DOS C mode",
        "flags": "-ml -a- -k -M -O -r- -Z -G-",
        "original_exe_sha256": sha(original),
        "rebuilt_verification_exe_sha256": sha(rebuilt),
        "map_sha256": sha(args.map.read_bytes()),
        "source_sha256": {name: sha((root/"src"/name).read_bytes())
                           for name in ("snkrec.c", "snkrec.h")},
        "comparison": "raw bytes, no masking or normalization",
        "procedures": [],
    }
    for name, address, offset, size in PROCEDURES:
        match = re.search(r"([0-9A-F]{4}):([0-9A-F]{4})\s+_"+name+r"\b",
                          listing, re.IGNORECASE)
        if not match:
            raise ValueError("symbol missing from MAP: " + name)
        segment, relative = (int(x, 16) for x in match.groups())
        where = header_size + segment*16 + relative
        expected = original[offset:offset+size]
        actual = rebuilt[where:where+size]
        if len(actual) != size or actual != expected:
            raise AssertionError(name+": compiled bytes differ from original")
        result["procedures"].append({
            "c_symbol": name, "original_cs_ip": address,
            "original_file_offset": offset, "compiled_cs_ip": "%04X:%04X"%(segment, relative),
            "compiled_file_offset": where, "complete_routine_bytes": size,
            "sha256": sha(actual), "byte_identical": True,
        })
    result["all_byte_identical"] = True
    result["complete_routines"] = len(PROCEDURES)
    result["total_identical_bytes"] = sum(item[3] for item in PROCEDURES)
    result["scope"] = "three complete reconstructed C procedures, not the whole game executable"
    text = json.dumps(result, ensure_ascii=False, indent=2)+"\n"
    if args.report:
        args.report.write_text(text, encoding="utf-8")
    print(text)


if __name__ == "__main__":
    main()
