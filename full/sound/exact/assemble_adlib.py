#!/usr/bin/env python3
"""Assemble the symbolic executable specification using TASM 3.1.

This baseline does not establish the compiler or claim C byte matching.

ADLIB.ASM is the only reconstruction input. Verification against the reference
EXE is a separate operation; this builder never reads that executable.
"""
import argparse
import hashlib
import json
import os
from pathlib import Path
import shutil
import subprocess

BASE = Path(__file__).resolve().parent
ROOT = BASE.parents[2]


def assemble(output=None, compiler=None, dosbox=None):
    output = Path(output or BASE/'adlib_build').resolve()
    compiler = Path(compiler or ROOT.parent/'work/gamemaker-tools/tools/BORLANDC').resolve()
    dosbox = Path(dosbox or ROOT.parent/'work/tools/dosbox-bin/usr/bin/dosbox').resolve()
    output.mkdir(parents=True, exist_ok=True)
    source = BASE/'ADLIB.ASM'
    if source.resolve() != (output/'ADLIB.ASM').resolve():
        shutil.copyfile(source, output/'ADLIB.ASM')
    for name in ('ADLIB.OBJ', 'ADLIB.LST', 'ADLIB.LOG', 'RESULT.TXT'):
        (output/name).unlink(missing_ok=True)
    commands = ['@echo off', r'path d:\bin',
        'tasm /ml ADLIB.ASM,ADLIB.OBJ,ADLIB.LST > ADLIB.LOG',
        'if errorlevel 1 goto failed', 'echo OK > RESULT.TXT', 'exit',
        ':failed', 'echo FAILED > RESULT.TXT', 'exit']
    (output/'BUILD.BAT').write_bytes(('\r\n'.join(commands)+'\r\n').encode('ascii'))
    libs = dosbox.parents[1]/'lib/x86_64-linux-gnu'
    env = dict(os.environ, LD_LIBRARY_PATH=str(libs)+':'+str(libs/'sdl12-compat'),
               SDL_VIDEODRIVER='dummy', SDL_AUDIODRIVER='dummy')
    result = subprocess.run([str(dosbox), '-noconsole', '-c',
        'config -set "cpu cycles=100000"', '-c', f'mount c "{output}"', '-c',
        f'mount d "{compiler}"', '-c', 'c:', '-c', 'BUILD.BAT'], env=env,
        stdout=subprocess.PIPE, stderr=subprocess.STDOUT, timeout=60)
    (output/'DOSBOX.LOG').write_bytes(result.stdout)
    passed = (output/'RESULT.TXT').exists() and (output/'RESULT.TXT').read_text().strip() == 'OK'
    report = dict(passed=passed, assembler='Borland TASM 3.1', flags='/ml',
        source_sha256=hashlib.sha256(source.read_bytes()).hexdigest())
    (output/'assemble.json').write_text(json.dumps(report, indent=2)+'\n')
    return report


if __name__ == '__main__':
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument('--output', type=Path)
    p.add_argument('--compiler', type=Path)
    p.add_argument('--dosbox', type=Path)
    a = p.parse_args()
    result = assemble(a.output, a.compiler, a.dosbox)
    print(json.dumps(result, indent=2))
    raise SystemExit(0 if result['passed'] else 1)
