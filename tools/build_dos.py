#!/usr/bin/env python3
"""Compile and verify the recovered C with an original Borland DOS compiler.

Example:
  python tools/build_dos.py --compiler /path/to/BORLANDC --dosbox /usr/bin/dosbox

This builds four verification/resource utilities, not the full SNAKE.EXE.
The compiler is not bundled. Source and output hashes, compiler banners, logs,
maps, generated EXEs and original-file comparisons are retained in --output.
"""
from pathlib import Path
import argparse
import hashlib
import json
import os
import shutil
import subprocess
import tempfile
import time

ROOT = Path(__file__).resolve().parents[1]
FLAGS = '-ml -a- -k -O -r- -Z -G- -M'


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def case_file(directory, name):
    matches = [path for path in directory.iterdir() if path.name.upper() == name.upper()]
    if len(matches) != 1:
        raise FileNotFoundError(f'Expected one {name} in {directory}')
    return matches[0]


def compiler_file(root, *parts):
    result = root
    for part in parts:
        result = case_file(result, part)
    return result


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--compiler', required=True, type=Path,
                        help='Borland root containing BIN, INCLUDE and LIB')
    parser.add_argument('--dosbox', default='dosbox')
    parser.add_argument('--original', type=Path, default=ROOT/'original')
    parser.add_argument('--output', type=Path, default=ROOT/'build/dos')
    parser.add_argument('--timeout', type=int, default=1200)
    args = parser.parse_args()
    compiler = args.compiler.resolve()
    original = args.original.resolve()
    output = args.output.resolve()
    output.mkdir(parents=True, exist_ok=True)
    stage = Path(tempfile.mkdtemp(prefix='stage-', dir=output))
    for folder in ('INPUT', 'OUT', 'RES'):
        (stage/folder).mkdir()
    source_hashes = {}
    for path in (ROOT/'src').iterdir():
        if path.suffix.lower() in ('.c', '.h'):
            if len(path.stem) > 8 or len(path.suffix) > 4:
                raise ValueError(f'Not a DOS 8.3 filename: {path.name}')
            shutil.copyfile(path, stage/path.name.upper())
            source_hashes['src/'+path.name] = sha(path)
    driver = ROOT/'tools/snkrtest.c'
    shutil.copyfile(driver, stage/'SNKRTEST.C')
    source_hashes['tools/snkrtest.c'] = sha(driver)
    shutil.copyfile(ROOT/'tests/LOGIC.VEC', stage/'LOGIC.VEC')
    inputs = []
    for path in sorted(original.iterdir()):
        if path.suffix.upper() in ('.SNK', '.REC', '.GPF'):
            inputs.append(path)
            shutil.copyfile(path, stage/'INPUT'/path.name.upper())
    for path in (ROOT/'assets/resources').iterdir():
        if path.is_file():
            shutil.copyfile(path, stage/'RES'/path.name.upper())
    targets = [('GPFTEST', 'GPFTEST.C GPFCODEC.C'),
               ('GPFBUILD', 'GPFBUILD.C GPFCODEC.C'),
               ('SNKRTEST', 'SNKRTEST.C SNKREC.C'),
               ('LOGICTST', 'LOGICTST.C LOGIC.C')]
    lines = ['@echo off', r'path d:\bin']
    for name, sources in targets:
        lines += [f'bcc {FLAGS} -Id:\\include -Ld:\\lib -e{name}.EXE {sources} > {name}.LOG',
                  'if errorlevel 1 goto failed']
    lines += [r'GPFTEST INPUT\SNAKE.GPF > GPFTEST.OUT', 'if errorlevel 1 goto failed',
              r'GPFBUILD RES OUT\SNAKE.GPF > GPFBUILD.OUT', 'if errorlevel 1 goto failed',
              'LOGICTST LOGIC.VEC > LOGICTST.OUT', 'if errorlevel 1 goto failed']
    for path in inputs:
        if path.suffix.upper() in ('.SNK', '.REC'):
            lines += [f'SNKRTEST {path.suffix[1:].lower()} INPUT\\{path.name.upper()} '
                      f'OUT\\{path.name.upper()} >> SNKREC.OUT', 'if errorlevel 1 goto failed']
    lines += ['echo ALL_OK > RESULT.TXT', 'exit', ':failed',
              'echo FAILED > RESULT.TXT', 'exit']
    (stage/'BUILD.BAT').write_bytes(('\r\n'.join(lines)+'\r\n').encode('ascii'))
    for path in (compiler, stage):
        if any(character in str(path) for character in ('"', '\r', '\n')):
            raise ValueError('DOS mount path contains a command delimiter')
    command = [args.dosbox, '-noconsole', '-c', 'config -set "cpu cycles=100000"',
               '-c', f'mount c "{stage}"', '-c', f'mount d "{compiler}"',
               '-c', 'c:', '-c', 'build.bat']
    environment = dict(os.environ)
    environment.setdefault('SDL_VIDEODRIVER', 'dummy')
    environment.setdefault('SDL_AUDIODRIVER', 'dummy')
    started = time.monotonic()
    completed = subprocess.run(command, stdout=subprocess.PIPE, stderr=subprocess.STDOUT,
                               timeout=args.timeout, env=environment, check=False)
    (output/'DOSBOX.LOG').write_bytes(completed.stdout)
    report = dict(flags=FLAGS, seconds=round(time.monotonic()-started, 3),
                  sources=source_hashes, compiler_files={}, compiler_banners={},
                  binaries={}, comparisons=[], passed=False,
                  full_game_reconstructed=False,
                  scope='Original-compiler builds of recovered C modules and utilities; '
                        'GPF/SNK/REC byte-exact reconstruction and 1064 core logic vectors. '
                        'These utility EXEs are not the original game executable.')
    for parts in [('BIN','BCC.EXE'), ('BIN','TLINK.EXE'), ('LIB','C0L.OBJ'), ('LIB','CL.LIB')]:
        path = compiler_file(compiler, *parts)
        report['compiler_files']['/'.join(parts)] = sha(path)
    for name, _ in targets:
        log = stage/(name+'.LOG')
        if log.exists():
            report['compiler_banners'][name] = log.read_text(errors='replace').splitlines()
    marker = stage/'RESULT.TXT'
    succeeded = marker.exists() and marker.read_text().strip() == 'ALL_OK'
    for path in inputs:
        rebuilt = stage/'OUT'/path.name.upper()
        same = rebuilt.exists() and path.read_bytes() == rebuilt.read_bytes()
        report['comparisons'].append(dict(name=path.name, original_sha256=sha(path),
                                         rebuilt_sha256=sha(rebuilt) if rebuilt.exists() else None,
                                         byte_exact=same))
    for path in stage.iterdir():
        if path.is_file() and path.suffix in ('.EXE', '.MAP', '.LOG', '.OUT', '.OBJ', '.BAT'):
            shutil.copyfile(path, output/path.name)
            if path.suffix == '.EXE':
                report['binaries'][path.name] = sha(path)
    for name in ('GPFTEST.OUT', 'GPFBUILD.OUT', 'LOGICTST.OUT', 'SNKREC.OUT'):
        path = stage/name
        report[name] = path.read_text(errors='replace') if path.exists() else None
    if succeeded:
        for path in (stage/'OUT').iterdir():
            (output/'rebuilt').mkdir(exist_ok=True)
            shutil.copyfile(path, output/'rebuilt'/path.name)
    report['passed'] = (succeeded and len(report['comparisons']) == 21 and
                        all(item['byte_exact'] for item in report['comparisons']) and
                        'PASS 1064' in (report['LOGICTST.OUT'] or '') and
                        'PASS 82 members, 94 streams' in (report['GPFTEST.OUT'] or ''))
    (output/'verification.json').write_text(json.dumps(report, indent=2)+'\n')
    print(json.dumps(dict(passed=report['passed'], output=str(output),
                          seconds=report['seconds'], comparisons=len(report['comparisons'])), indent=2))
    if not report['passed']:
        raise SystemExit(f'Build or verification failed; retained staging tree: {stage}')
    shutil.rmtree(stage)


if __name__ == '__main__':
    main()
