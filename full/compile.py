#!/usr/bin/env python3
"""Run the original Borland compiler in DOSBox, retaining OMF and listing.

This compiles source; it does not insert any bytes from the reference EXE.
Toolchain paths may be supplied through the command line. The defaults point
to the already verified toolchain in this analysis workspace.
"""
import argparse
import hashlib
import json
import os
from pathlib import Path
import shutil
import subprocess
import time

BASE = Path(__file__).resolve().parents[2]
FLAGS = '-ml -a- -k -O -r- -Z -G-'


def compile_sources(source, output, files, flags=FLAGS, compiler=None, dosbox=None):
    compiler = Path(compiler or BASE/'work/gamemaker-tools/tools/BORLANDC').resolve()
    dosbox = Path(dosbox or BASE/'work/tools/dosbox-bin/usr/bin/dosbox').resolve()
    source, output = Path(source).resolve(), Path(output).resolve()
    output.mkdir(parents=True, exist_ok=True)
    hashes = {}
    for path in source.iterdir():
        if path.suffix.upper() in ('.C', '.H'):
            if len(path.stem) > 8:
                raise ValueError('DOS 8.3 required: '+path.name)
            target = output/path.name.upper()
            if target != path:
                shutil.copyfile(path, target)
            hashes[path.name] = hashlib.sha256(path.read_bytes()).hexdigest()
    commands = ['@echo off', r'path d:\bin']
    for filename in files:
        name = Path(filename).name.upper()
        commands.extend([f'bcc -c {flags} -Id:\\include {name} > {Path(name).stem}.LOG',
                         'if errorlevel 1 goto failed'])
    commands.extend(['echo OK > RESULT.TXT', 'exit', ':failed',
                     'echo FAILED > RESULT.TXT', 'exit'])
    (output/'BUILD.BAT').write_bytes(('\r\n'.join(commands)+'\r\n').encode('ascii'))
    (output/'RESULT.TXT').unlink(missing_ok=True)
    command = [str(dosbox), '-noconsole', '-c', 'config -set "cpu cycles=100000"',
               '-c', f'mount c "{output}"', '-c', f'mount d "{compiler}"',
               '-c', 'c:', '-c', 'BUILD.BAT']
    environment = dict(os.environ)
    libbase = dosbox.parents[1]/'lib/x86_64-linux-gnu'
    environment['LD_LIBRARY_PATH'] = str(libbase)+':'+str(libbase/'sdl12-compat')
    environment['SDL_VIDEODRIVER'] = 'dummy'
    environment['SDL_AUDIODRIVER'] = 'dummy'
    start = time.monotonic()
    result = subprocess.run(command, stdout=subprocess.PIPE, stderr=subprocess.STDOUT,
                            env=environment, timeout=300)
    (output/'DOSBOX.LOG').write_bytes(result.stdout)
    ok = (output/'RESULT.TXT').exists() and (output/'RESULT.TXT').read_text().strip() == 'OK'
    report = dict(passed=ok, source_hashes=hashes, flags=flags,
                  seconds=round(time.monotonic()-start, 3), files=files)
    (output/'compile.json').write_text(json.dumps(report, indent=2)+'\n')
    return report


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('source', type=Path)
    parser.add_argument('output', type=Path)
    parser.add_argument('files', nargs='+')
    parser.add_argument('--flags', default=FLAGS)
    parser.add_argument('--compiler', type=Path)
    parser.add_argument('--dosbox', type=Path)
    args = parser.parse_args()
    report = compile_sources(args.source, args.output, args.files, args.flags,
                             args.compiler, args.dosbox)
    print(json.dumps(report, indent=2))
    raise SystemExit(0 if report['passed'] else 1)
