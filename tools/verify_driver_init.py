#!/usr/bin/env python3
"""Execute the original sprite-driver decoder and relocation initializer.

Only memory/CPU initialization runs; no video operations or DOS game startup.
"""
from pathlib import Path
import argparse
import hashlib
import json
import struct
import sys

sys.path.insert(0, str(Path(__file__).resolve().parents[1]/'recovered'))
from decrypt_sprite_driver import decode, encode, START, END


def verify(exe):
    from unicorn import Uc, UC_ARCH_X86, UC_MODE_16
    from unicorn.x86_const import (UC_X86_REG_CS, UC_X86_REG_IP, UC_X86_REG_DS,
                                  UC_X86_REG_SS, UC_X86_REG_SP)
    digest = hashlib.sha256(exe).hexdigest()
    if digest != 'c4e064a1cf15e438017d4d6443817424f816ce4b749fcc279f2d97dc7bd86821':
        raise ValueError('This verifier targets the supplied Snake Battle EXE')
    plain = decode(exe[START:END])
    assert encode(plain) == exe[START:END]
    uc = Uc(UC_ARCH_X86, UC_MODE_16)
    uc.mem_map(0, 0x100000)
    uc.mem_write(0, exe[0x1000:])
    for reg, value in [(UC_X86_REG_CS,0xED6), (UC_X86_REG_IP,6),
                       (UC_X86_REG_DS,0x1679), (UC_X86_REG_SS,0x8000),
                       (UC_X86_REG_SP,0xF000)]:
        uc.reg_write(reg, value)
    uc.mem_write(0x8F000, struct.pack('<HH',0,0x9000))
    uc.emu_start(0xED66, 0x90000, count=500000)
    assert uc.reg_read(UC_X86_REG_CS) == 0x9000
    assert uc.reg_read(UC_X86_REG_DS) == 0x1679
    assert bytes(uc.mem_read(0xEE00,0x2EC0)) == plain[:0x2EC0]
    assert bytes(uc.mem_read(0xED66,5)) == bytes.fromhex('eab000d50e')
    return dict(source_sha256=digest, passed=True,
                decrypted_file_range=[START,END], decrypted_size=len(plain),
                decoded_sha256=hashlib.sha256(plain).hexdigest(),
                inverse_reencoding_exact=True,
                original_wrapper_and_initializer_executed=True,
                relocation=dict(source_image_offset='0xEE16', destination_image_offset='0xEE00',
                                length=0x2EC0, downward_shift=0x16,
                                rewritten_entry_image_offset='0xED66',
                                rewritten_entry_bytes='EA B0 00 D5 0E',
                                entry_cs_ip='0ED5:00B0',
                                offset_mapping='decoded file-equivalent = 0xFD66 + driver offset; runtime image = 0xED50 + driver offset'),
                scope='Original decoder plus memory relocation initializer returned to caller. No graphics dispatch, EGA hardware or DOS execution.')


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('exe', type=Path)
    parser.add_argument('--output', type=Path)
    args = parser.parse_args()
    report = verify(args.exe.read_bytes())
    text = json.dumps(report, indent=2)+'\n'
    if args.output:
        args.output.write_text(text)
    print(text, end='')


if __name__ == '__main__':
    main()
