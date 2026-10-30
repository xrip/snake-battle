#!/usr/bin/env python3
"""Produce C/DOS test vectors by executing the supplied original EXE.

Requires unicorn. No decompiled or reconstructed implementation supplies the
expected outputs. The fixed source digest prevents using offsets on a different
release. Run: python tools/make_logic_vectors.py original/SNAKE.EXE LOGIC.VEC
"""
from pathlib import Path
import argparse
import hashlib
import json
import random
import struct


def generate(exe: bytes) -> tuple[bytes, dict]:
    from unicorn import Uc, UC_ARCH_X86, UC_MODE_16
    from unicorn.x86_const import (UC_X86_REG_CS, UC_X86_REG_IP, UC_X86_REG_DS,
                                  UC_X86_REG_SS, UC_X86_REG_SP, UC_X86_REG_AX)
    digest = hashlib.sha256(exe).hexdigest()
    if digest != "c4e064a1cf15e438017d4d6443817424f816ce4b749fcc279f2d97dc7bd86821":
        raise ValueError("These addresses belong to the supplied SNAKE.EXE only")
    rng = random.Random(0x534E414B45)

    def run(ip, args, blobs, output_address, output_length):
        u = Uc(UC_ARCH_X86, UC_MODE_16)
        u.mem_map(0, 0x100000)
        u.mem_write(0, exe[0x1000:])
        for address, data in blobs:
            u.mem_write(address, data)
        for register, value in ((UC_X86_REG_CS, 0x729), (UC_X86_REG_IP, ip),
                                (UC_X86_REG_DS, 0x1679), (UC_X86_REG_SS, 0x8000),
                                (UC_X86_REG_SP, 0xF000)):
            u.reg_write(register, value)
        u.mem_write(0x8F000, struct.pack("<" + "H"*(2+len(args)), 0, 0x9000, *args))
        u.emu_start(0x7290+ip, 0x90000, count=500000)
        if u.reg_read(UC_X86_REG_CS) != 0x9000:
            raise AssertionError("Original function failed to return")
        if output_length:
            return bytes(u.mem_read(output_address, output_length))
        return struct.pack("<H", u.reg_read(UC_X86_REG_AX))

    records = []
    for _ in range(150):
        card = struct.pack("<Bhh", rng.randrange(5), rng.randrange(7), rng.randrange(7))
        card += bytes(value for _ in range(49) for value in
                      (rng.randrange(5), rng.randrange(2), rng.randrange(10)))
        for kind, ip in ((1, 0x000D), (2, 0x00B4)):
            expected = run(ip, [0, 0x7000], [(0x70000, card)], 0x70000, 152)
            records.append(bytes([kind])+card+expected)
    for i in range(700):
        vision = [[rng.randrange(1, 9) for _ in range(13)] for _ in range(13)]
        ax, ay = rng.randrange(7), rng.randrange(7)
        cells = []
        for x in range(7):
            for y in range(7):
                symbol = 9 if rng.random() < 0.7 else rng.randrange(10)
                negate = rng.randrange(2)
                if i % 3 == 0 and symbol not in (8, 9):
                    actual = vision[6-ax+x][6-ay+y]
                    symbol = actual if not negate else (actual % 7)+1
                cells.extend((rng.randrange(5), negate, symbol))
        card = struct.pack("<Bhh", rng.randrange(5), ax, ay)+bytes(cells)
        view = bytes(value for x in range(13) for y in range(13)
                     for value in (0, 0, vision[x][y]))
        expected = run(0x1058, [0, 0x7100, 0, 0x7000, 0, 0x7200],
                       [(0x71000, view), (0x70000, card), (0x72000, b'\xff'*4)],
                       0x72000, 4)
        records.append(b'\x03'+view+card+expected)
    for a in (0, 1):
        for b in (0, 1):
            for sa in (0, 1, 9, 49):
                for sb in (0, 1, 9, 49):
                    left, right = struct.pack("<HH", a, sa), struct.pack("<HH", b, sb)
                    expected = run(0x1002, [0, 0x7000, 0, 0x7100],
                                   [(0x70000, left), (0x71000, right)], 0, 0)
                    records.append(b'\x04'+left+right+expected)
    result = b'SBV1'+struct.pack('<H', len(records))+b''.join(records)
    return result, dict(source_sha256=digest, vector_sha256=hashlib.sha256(result).hexdigest(),
                        count=len(records), mirror=150, rotate=150, matcher=700, comparator=64,
                        expected_output="Executed original real-mode machine code with Unicorn")


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('exe', type=Path)
    parser.add_argument('output', type=Path)
    args = parser.parse_args()
    vectors, report = generate(args.exe.read_bytes())
    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_bytes(vectors)
    args.output.with_suffix('.json').write_text(json.dumps(report, indent=2)+'\n')
    print(json.dumps(report, indent=2))


if __name__ == '__main__':
    main()
