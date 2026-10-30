#!/usr/bin/env python3
"""Compare recovered C movement with the supplied game's 16-bit instructions.

Requires Unicorn and a host C compiler. Example:
  python tools/verify_movement.py original/SNAKE.EXE --output report.json

Only drawing, sound and clock callees are replaced with returns. The original
movement instructions and all their logical callees execute unchanged.
"""
from pathlib import Path
import argparse
import ctypes as C
import hashlib
import json
import random
import struct
import subprocess
import tempfile


class Cell(C.Structure):
    _pack_ = 1
    _fields_ = [('owner', C.c_short), ('kind', C.c_short)]


class Segment(C.Structure):
    _pack_ = 1
    _fields_ = [('x', C.c_byte), ('y', C.c_byte), ('direction', C.c_byte)]


class Snake(C.Structure):
    _pack_ = 1
    _fields_ = [('length', C.c_short), ('score', C.c_short),
                ('unknown', C.c_short), ('head', C.c_short),
                ('body', Segment*41), ('color', C.c_short),
                ('sprite', C.c_ubyte*32)]


class Battle(C.Structure):
    _pack_ = 1
    _fields_ = [('board', (Cell*37)*37), ('snakes', Snake*4),
                ('alive', C.c_short), ('active_count', C.c_short),
                ('pending_count', C.c_short), ('active', C.c_short*4),
                ('pending', C.c_short*4), ('moved', C.c_short)]


def verify(exe, library):
    from unicorn import Uc, UC_ARCH_X86, UC_MODE_16, UC_HOOK_CODE
    from unicorn.x86_const import (UC_X86_REG_CS, UC_X86_REG_IP,
                                  UC_X86_REG_DS, UC_X86_REG_SS,
                                  UC_X86_REG_SP, UC_X86_REG_AX, UC_X86_REG_DX)
    digest = hashlib.sha256(exe).hexdigest()
    if digest != 'c4e064a1cf15e438017d4d6443817424f816ce4b749fcc279f2d97dc7bd86821':
        raise ValueError('This verifier targets the supplied Snake Battle EXE')
    lib = C.CDLL(str(library.resolve()))
    rng = random.Random(7359)
    done, hooks = 0, set()
    ds = 0x16790
    stubs = {0x7CB0: 'draw snake segment', 0xD3D3: 'sprite update',
             0xC10A: 'clock read', 0xC116: 'timing wait',
             0x429A: 'audio service'}

    def setup(points, slot, battle, index, active):
        snake = battle.snakes[slot]
        snake.length, snake.score, snake.head = len(points), len(points)+10, index
        for n, (x, y, direction) in enumerate(points):
            snake.body[(index+n)%41] = Segment(x, y, direction)
            kind = 8 if n == 0 and len(points) > 1 else 4 if n == len(points)-1 else 6
            battle.board[x][y] = Cell(slot, kind)
        battle.active[slot] = battle.pending[slot] = active

    for case in ['empty', 'enemy3', 'enemy2', 'enemy1', 'self', 'growth']:
        for _ in range(30):
            battle = Battle()
            lib.sb_make_board(C.byref(battle.board), 6, 6, 30, 30)
            index = rng.randrange(1, 41)
            setup([(20,18,3), (21,18,3), (22,18,3), (23,18,3)],
                  0, battle, index, 1)
            if case == 'self':
                setup([(20,18,3), (20,19,0), (19,19,1), (19,18,2)],
                      0, battle, index, 1)
            if case.startswith('enemy'):
                n = int(case[-1])
                setup([(19,19-n+i,2) for i in range(n)], 1, battle,
                      rng.randrange(1, 41), int(n > 1))
            battle.active_count = sum(battle.active)
            battle.pending_count = sum(battle.pending)
            battle.alive = sum(1 for snake in battle.snakes if snake.length)
            uc = Uc(UC_ARCH_X86, UC_MODE_16)
            uc.mem_map(0, 0x100000)
            uc.mem_write(0, exe[0x1000:])
            uc.mem_write(ds+0x1B55, bytes(battle.board))
            uc.mem_write(ds+0x3171, bytes(battle.snakes))
            uc.mem_write(ds+0x1B41, struct.pack('<hh', battle.active_count,
                                              battle.pending_count))
            uc.mem_write(ds+0x1B45, bytes(battle.pending))
            uc.mem_write(ds+0x1B4D, bytes(battle.active))
            uc.mem_write(ds+0x340F, struct.pack('<hh', battle.alive, 0))
            for reg, value in [(UC_X86_REG_CS,0x729), (UC_X86_REG_IP,0xBEC),
                               (UC_X86_REG_DS,0x1679), (UC_X86_REG_SS,0x8000),
                               (UC_X86_REG_SP,0xF000)]:
                uc.reg_write(reg, value)
            uc.mem_write(0x8F000, struct.pack('<5H', 0, 0x9000, 0, 3,
                                             int(case != 'growth')))

            def hook(machine, address, size, data):
                if address in stubs:
                    hooks.add(address)
                    sp = machine.reg_read(UC_X86_REG_SP)
                    ss = machine.reg_read(UC_X86_REG_SS)
                    ip, cs = struct.unpack('<HH', machine.mem_read(16*ss+sp,4))
                    machine.reg_write(UC_X86_REG_AX, 0)
                    machine.reg_write(UC_X86_REG_DX, 0)
                    machine.reg_write(UC_X86_REG_SP, sp+4)
                    machine.reg_write(UC_X86_REG_CS, cs)
                    machine.reg_write(UC_X86_REG_IP, ip)

            uc.hook_add(UC_HOOK_CODE, hook)
            uc.emu_start(0x7E7C, 0x90000, count=300000)
            assert uc.reg_read(UC_X86_REG_CS) == 0x9000
            lib.sb_apply_move(C.byref(battle), 0, 3, int(case != 'growth'))
            assert bytes(uc.mem_read(ds+0x1B55,5476)) == bytes(battle.board), (case,'board')
            assert bytes(uc.mem_read(ds+0x3171,660)) == bytes(battle.snakes), (case,'snakes')
            assert bytes(uc.mem_read(ds+0x1B45,8)) == bytes(battle.pending), (case,'pending')
            assert bytes(uc.mem_read(ds+0x1B4D,8)) == bytes(battle.active), (case,'active')
            assert struct.unpack('<hh',uc.mem_read(ds+0x1B41,4)) == (battle.active_count,battle.pending_count)
            assert struct.unpack('<hh',uc.mem_read(ds+0x340F,4)) == (battle.alive,battle.moved)
            done += 1
    return dict(source_sha256=digest, passed=True, cases=done, seed=7359,
                categories=['empty cell', 'enemy tail length 3', 'enemy tail length 2',
                            'enemy last remaining segment', 'own tail', 'initial growth'],
                state_compared=['board: 5476 bytes', 'four snake states: 660 bytes',
                                'active and pending arrays', 'alive/active/pending counts',
                                'moved flag'],
                stubs_image_offsets={hex(k): stubs[k] for k in sorted(hooks)},
                scope='Original 0729:0BEC logical updates versus compiled C. Drawing, audio and timing callees stubbed. No complete DOS or EGA validation.')


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('exe', type=Path)
    parser.add_argument('--library', type=Path, help='Already compiled shared library')
    parser.add_argument('--cc', default='cc')
    parser.add_argument('--output', type=Path)
    args = parser.parse_args()
    with tempfile.TemporaryDirectory(prefix='snake-move-check-') as temporary:
        library = args.library
        if library is None:
            library = Path(temporary)/'logic.so'
            source = Path(__file__).resolve().parents[1]/'src'/'logic.c'
            subprocess.run([args.cc, '-std=c89', '-Wall', '-Wextra', '-Werror',
                            '-shared', '-fPIC', str(source), '-o', str(library)], check=True)
        report = verify(args.exe.read_bytes(), library)
    text = json.dumps(report, indent=2)+'\n'
    if args.output:
        args.output.write_text(text)
    print(text, end='')


if __name__ == '__main__':
    main()
