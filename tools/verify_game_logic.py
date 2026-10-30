#!/usr/bin/env python3
"""Differential checks against original 16-bit EXE code, using Unicorn.

Run: python tools/verify_game_logic.py path/to/SNAKE.EXE --output report.json
This executes selected pure memory routines, not the DOS game or its hardware.
"""
from pathlib import Path
import argparse
import hashlib
import json
import random
import struct
import sys

sys.path.insert(0, str(Path(__file__).resolve().parents[1]/"recovered"))
from game_logic import (RuleCard, RuleCell, MatchScore, mirror_card_x,
                        rotate_card_clockwise, match_card, compare_matches)
from decrypt_sprite_driver import decode, encode, START, END


def verify(exe: bytes) -> dict:
    from unicorn import Uc, UC_ARCH_X86, UC_MODE_16, UC_HOOK_CODE
    from unicorn.x86_const import (UC_X86_REG_CS, UC_X86_REG_IP, UC_X86_REG_DS,
                                  UC_X86_REG_SS, UC_X86_REG_SP, UC_X86_REG_AX)
    if hashlib.sha256(exe).hexdigest() != "c4e064a1cf15e438017d4d6443817424f816ce4b749fcc279f2d97dc7bd86821":
        raise ValueError("This verifier is tied to the supplied Snake Battle EXE")
    rng = random.Random(0x534E414B45)
    counts = dict(mirror=0, rotate=0, matcher=0, comparator=0, decrypt_wrapper=0)
    def run(ip, arguments, blobs, result_address, result_length):
        u = Uc(UC_ARCH_X86, UC_MODE_16)
        u.mem_map(0, 0x100000)
        u.mem_write(0, exe[0x1000:])
        for address, data in blobs:
            u.mem_write(address, data)
        u.reg_write(UC_X86_REG_CS, 0x729)
        u.reg_write(UC_X86_REG_IP, ip)
        u.reg_write(UC_X86_REG_DS, 0x1679)
        u.reg_write(UC_X86_REG_SS, 0x8000)
        u.reg_write(UC_X86_REG_SP, 0xF000)
        u.mem_write(0x8F000, struct.pack("<"+"H"*(2+len(arguments)), 0, 0x9000, *arguments))
        u.emu_start(0x7290+ip, 0x90000, count=500000)
        if u.reg_read(UC_X86_REG_CS) != 0x9000:
            raise AssertionError(f"Routine {ip:04x} did not return")
        return bytes(u.mem_read(result_address, result_length)) if result_length else u.reg_read(UC_X86_REG_AX)

    for _ in range(150):
        card = RuleCard(rng.randrange(5), rng.randrange(7), rng.randrange(7),
                        tuple(RuleCell(rng.randrange(5),rng.randrange(2),rng.randrange(10)) for _ in range(49)))
        b=card.to_bytes()
        for key, ip, translate in (("mirror",0x000D,mirror_card_x),("rotate",0x00B4,rotate_card_clockwise)):
            actual=run(ip,[0,0x7000],[(0x70000,b)],0x70000,152)
            assert actual == translate(card).to_bytes(), (key,card)
            counts[key]+=1

    # Sparse cards and forced matches cover successful AND/OR outcomes as well
    # as early mismatches, sticky group failures and ignored cells.
    for i in range(700):
        vision=[[rng.randrange(1,9) for _ in range(13)] for _ in range(13)]
        ax,ay=rng.randrange(7),rng.randrange(7)
        cells=[]
        for x in range(7):
            for y in range(7):
                kind=9 if rng.random()<0.7 else rng.randrange(10)
                negate=rng.randrange(2)
                if i%3==0 and kind not in (8,9):
                    actual=vision[6-ax+x][6-ay+y]
                    kind=actual if not negate else (actual%7)+1
                cells.append(RuleCell(rng.randrange(5),negate,kind))
        card=RuleCard(rng.randrange(5),ax,ay,tuple(cells))
        view=bytes(v for x in range(13) for y in range(13) for v in (0,0,vision[x][y]))
        actual=run(0x1058,[0,0x7100,0,0x7000,0,0x7200],
                   [(0x71000,view),(0x70000,card.to_bytes()),(0x72000,b'\xff'*4)],0x72000,4)
        found,score=struct.unpack('<HH',actual)
        expected=match_card(vision,card)
        assert (found,score)==(int(expected.matched),expected.score),(i,(found,score),expected)
        counts['matcher']+=1

    for a in (False,True):
        for b in (False,True):
            for sa in (0,1,9,49):
                for sb in (0,1,9,49):
                    left,right=MatchScore(a,sa),MatchScore(b,sb)
                    actual=run(0x1002,[0,0x7000,0,0x7100],
                               [(0x70000,struct.pack('<HH',a,sa)),(0x71000,struct.pack('<HH',b,sb))],0,0)
                    assert actual==compare_matches(left,right)
                    counts['comparator']+=1

    plain=decode(exe[START:END])
    assert encode(plain)==exe[START:END]
    u=Uc(UC_ARCH_X86,UC_MODE_16)
    u.mem_map(0,0x100000);u.mem_write(0,exe[0x1000:])
    for reg,value in [(UC_X86_REG_CS,0xED6),(UC_X86_REG_IP,6),(UC_X86_REG_DS,0x1679),
                      (UC_X86_REG_SS,0x8000),(UC_X86_REG_SP,0xF000)]:u.reg_write(reg,value)
    u.emu_start(0xED66,0x11DA2,count=500000)
    assert bytes(u.mem_read(START-0x1000,len(plain)))==plain
    counts['decrypt_wrapper']=1
    return dict(source_sha256=hashlib.sha256(exe).hexdigest(),
                checks=counts, total=sum(counts.values()), passed=True,
                scope="Original machine code for mirror, rotate, matcher, score comparator, and driver decrypt wrapper. No full DOS or EGA runtime.",
                seed=0x534E414B45)


def main():
    p=argparse.ArgumentParser(description=__doc__)
    p.add_argument('exe',type=Path)
    p.add_argument('--output',type=Path)
    a=p.parse_args()
    report=verify(a.exe.read_bytes())
    text=json.dumps(report,indent=2)+'\n'
    if a.output:a.output.write_text(text)
    print(text,end='')


if __name__=='__main__':main()
