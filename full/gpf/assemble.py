#!/usr/bin/env python3
"""Assemble LZSS.ASM with the original Borland TASM under native DOSBox."""
import argparse
import hashlib
import json
import os
from pathlib import Path
import shutil
import subprocess

ROOT = Path(__file__).resolve().parents[2]
BASE = ROOT.parent


def assemble(output, compiler, dosbox):
    output, compiler, dosbox = [Path(p).resolve() for p in (output, compiler, dosbox)]
    output.mkdir(parents=True, exist_ok=True)
    source = Path(__file__).with_name('LZSS.ASM')
    shutil.copyfile(source, output/'LZSS.ASM')
    commands = ['@echo off', r'path d:\bin',
                'tasm /ml LZSS.ASM,LZSS.OBJ,LZSS.LST > ASMLZSS.LOG',
                'if errorlevel 1 goto failed', 'echo OK > ASMOK.TXT', 'exit',
                ':failed', 'echo FAILED > ASMOK.TXT', 'exit']
    (output/'ASMLZSS.BAT').write_bytes(('\r\n'.join(commands)+'\r\n').encode('ascii'))
    (output/'ASMOK.TXT').unlink(missing_ok=True)
    # TASM's output-path probing under this DOSBox version misclassifies an
    # existing output file as a directory.  Recreate these derived artifacts.
    (output/'LZSS.OBJ').unlink(missing_ok=True)
    (output/'LZSS.LST').unlink(missing_ok=True)
    libbase = dosbox.parents[1]/'lib/x86_64-linux-gnu'
    environment = dict(os.environ, LD_LIBRARY_PATH=str(libbase)+':'+str(libbase/'sdl12-compat'),
                       SDL_VIDEODRIVER='dummy', SDL_AUDIODRIVER='dummy')
    command = [str(dosbox), '-noconsole', '-c', 'config -set "cpu cycles=100000"',
               '-c', f'mount c "{output}"', '-c', f'mount d "{compiler}"',
               '-c', 'c:', '-c', 'ASMLZSS.BAT']
    result = subprocess.run(command, env=environment, stdout=subprocess.PIPE,
                            stderr=subprocess.STDOUT, timeout=60)
    (output/'ASMDOS.LOG').write_bytes(result.stdout)
    passed = (output/'ASMOK.TXT').exists() and (output/'ASMOK.TXT').read_text().strip() == 'OK'
    report = {'passed': passed, 'source_sha256': hashlib.sha256(source.read_bytes()).hexdigest(),
              'assembler': 'original Borland TASM', 'flags': '/ml'}
    (output/'assemble.json').write_text(json.dumps(report, indent=2)+'\n')
    return report


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--output', type=Path, default=ROOT/'full/gpf/build')
    parser.add_argument('--compiler', type=Path, default=BASE/'work/gamemaker-tools/tools/BORLANDC')
    parser.add_argument('--dosbox', type=Path, default=BASE/'work/tools/dosbox-bin/usr/bin/dosbox')
    args = parser.parse_args()
    report = assemble(args.output, args.compiler, args.dosbox)
    print(json.dumps(report, indent=2))
    raise SystemExit(0 if report['passed'] else 1)
