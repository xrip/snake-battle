#!/usr/bin/env python3
"""Compare Borland-generated C functions with the supplied SNAKE.EXE.

This is function-level evidence, not a claim that the whole EXE matches.
The card transforms and matcher reference CRT routines or static data whose
link addresses differ between a small test program and the original game.
Every adjusted operand is declared, checked against the link MAP or the
referenced constant bytes, and reported; all other bytes compare unchanged.
"""
from pathlib import Path
import argparse
import hashlib
import json
import re
import struct

SOURCE_HASH = 'c4e064a1cf15e438017d4d6443817424f816ce4b749fcc279f2d97dc7bd86821'
FUNCTIONS = [
    ('_sb_mirror_x', 0x829D, 0xA7, [(0x75,'F_SCOPY@',0,0x03A9),
                                    (0x9C,'_memcpy',0,0x2B8E)]),
    ('_sb_rotate_clockwise', 0x8344, 0xA7, [(0x75,'F_SCOPY@',0,0x03A9),
                                           (0x9C,'_memcpy',0,0x2B8E)]),
    ('_sb_compare_matches', 0x9292, 0x56, []),
    ('_sb_match_card', 0x92E8, 0x212, [(0x15,'F_SCOPY@',0,0x03A9),
                                       (0x27,'F_SCOPY@',0,0x03A9),
                                       (0x39,'F_SCOPY@',0,0x03A9)]),
]

MATCHER_DATA = [
    (0x0D,0x04A3,'seen initializer',bytes(10),b'\xB8'),
    (0x1F,0x04AD,'score initializer',bytes(10),b'\xB8'),
    (0x31,0x04B7,'AND/OR initializer',bytes.fromhex('01000000000001000100'),b'\xB8'),
    (0x41,0x049E,'no-match.score',bytes(2),b'\xA1'),
    (0x45,0x049C,'no-match.matched',bytes(2),b'\x8B\x16'),
]


def read_map(text):
    symbols = {}
    for line in text.splitlines():
        match = re.match(r'\s*([0-9a-fA-F]{4}):([0-9a-fA-F]{4})\s+(\S+)\s*$', line)
        if match:
            cs, ip, name = match.groups()
            symbols[name] = (int(cs,16), int(ip,16))
    return symbols


def verify(original, candidate, link_map):
    if hashlib.sha256(original).hexdigest() != SOURCE_HASH:
        raise ValueError('Unsupported original EXE SHA-256')
    if candidate[:2] != b'MZ':
        raise ValueError('Candidate must be a DOS MZ executable')
    header_size = 16*struct.unpack_from('<H',candidate,8)[0]
    symbols = read_map(link_map)
    results = []
    for name, source_offset, size, bindings in FUNCTIONS:
        cs, ip = symbols[name]
        offset = header_size + 16*cs + ip
        original_code = original[source_offset:source_offset+size]
        candidate_code = candidate[offset:offset+size]
        if len(candidate_code) != size:
            raise ValueError('Candidate function exceeds image')
        adjusted = bytearray(candidate_code)
        differences = [dict(relative_offset=i, original=a, compiled=b)
                       for i,(a,b) in enumerate(zip(original_code,candidate_code)) if a != b]
        adjustments = []
        for operand, symbol, original_cs, original_ip in bindings:
            compiled_cs, compiled_ip = symbols[symbol]
            old = struct.pack('<HH',original_ip,original_cs)
            new = struct.pack('<HH',compiled_ip,compiled_cs)
            if original_code[operand-1] != 0x9A or candidate_code[operand-1] != 0x9A:
                raise AssertionError('Expected immediate FAR CALL opcode')
            if original_code[operand:operand+4] != old:
                raise AssertionError('Original binding disagrees with declared evidence')
            if candidate_code[operand:operand+4] != new:
                raise AssertionError('Compiled binding disagrees with its linker MAP')
            adjusted[operand:operand+4] = old
            adjustments.append(dict(symbol=symbol, relative_operand_offset=operand,
                                    width=4, original_file_offset=source_offset+operand,
                                    compiled_file_offset=offset+operand,
                                    original_cs_ip=f'{original_cs:04X}:{original_ip:04X}',
                                    compiled_cs_ip=f'{compiled_cs:04X}:{compiled_ip:04X}',
                                    original_bytes=old.hex(), compiled_bytes=new.hex(),
                                    meaning='Link-resolved FAR CALL operand; only segment half is an MZ loader relocation'))
        if name == '_sb_match_card':
            data_cs,data_ip = symbols['DATASEG@']
            for operand,old_ds_offset,label,expected,prefix in MATCHER_DATA:
                old = struct.pack('<H',old_ds_offset)
                new = candidate_code[operand:operand+2]
                new_ds_offset = struct.unpack('<H',new)[0]
                if original_code[operand:operand+2] != old:
                    raise AssertionError('Original data binding disagrees with declared evidence')
                if (original_code[operand-len(prefix):operand] != prefix or
                    candidate_code[operand-len(prefix):operand] != prefix):
                    raise AssertionError('Unexpected data-reference instruction')
                old_file = 0x1000 + 0x16790 + old_ds_offset
                new_file = header_size + 16*data_cs + data_ip + new_ds_offset
                if original[old_file:old_file+len(expected)] != expected:
                    raise AssertionError('Original static initializer differs')
                if candidate[new_file:new_file+len(expected)] != expected:
                    raise AssertionError('Compiled static initializer differs')
                adjusted[operand:operand+2] = old
                adjustments.append(dict(symbol=label,relative_operand_offset=operand,width=2,
                                        original_file_offset=source_offset+operand,
                                        compiled_file_offset=offset+operand,
                                        original_ds_offset=f'1679:{old_ds_offset:04X}',
                                        compiled_ds_offset=f'{data_cs:04X}:{new_ds_offset:04X}',
                                        original_bytes=old.hex(),compiled_bytes=new.hex(),
                                        original_target_file_offset=old_file,
                                        compiled_target_file_offset=new_file,
                                        verified_target_bytes=expected.hex(),
                                        meaning='Link-resolved DS-relative static-data address; referenced initializer bytes checked in both EXEs'))
        adjusted_differences = [i for i,(a,b) in enumerate(zip(original_code,adjusted)) if a != b]
        results.append(dict(symbol=name, size=size, original_file_offset=source_offset,
                            original_image_offset=source_offset-0x1000,
                            compiled_file_offset=offset, compiled_cs_ip=f'{cs:04X}:{ip:04X}',
                            original_sha256=hashlib.sha256(original_code).hexdigest(),
                            compiled_sha256=hashlib.sha256(candidate_code).hexdigest(),
                            raw_equal=candidate_code == original_code,
                            raw_difference_count=len(differences), raw_differences=differences,
                            link_bindings=adjustments,
                            binding_adjusted_equal=bytes(adjusted) == original_code,
                            unexpected_difference_offsets=adjusted_differences,
                            matched_bytes_after_declared_link_bindings=size-len(adjusted_differences)))
    return dict(original_exe_sha256=SOURCE_HASH,
                compiled_exe_sha256=hashlib.sha256(candidate).hexdigest(),
                compilation='Borland C++ 3.1: -ml -a- -k -O -r- -Z -G- -M',
                functions=results,
                passed=all(item['binding_adjusted_equal'] for item in results),
                scope='Function-level code generation only. Borland C++ 3.1 C, no inline assembly or embedded executable bytes. Declared FAR CALL and DS-relative static-data addresses are explicitly rebound in memory solely for comparison. This does not reconstruct or claim a byte-identical full EXE.')


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('original',type=Path)
    parser.add_argument('candidate',type=Path)
    parser.add_argument('map',type=Path)
    parser.add_argument('--output',type=Path)
    args = parser.parse_args()
    report = verify(args.original.read_bytes(),args.candidate.read_bytes(),
                    args.map.read_text(encoding='cp437'))
    text = json.dumps(report,indent=2)+'\n'
    if args.output:
        args.output.write_text(text)
    print(text,end='')
    if not report['passed']:
        raise SystemExit(1)


if __name__ == '__main__':
    main()
