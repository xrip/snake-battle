#!/usr/bin/env python3
"""Build recovered sound hardware/ABI fragments using original Borland TASM.

The assembly source is the build input. Reference EXE is used only by the
separate verification phase. No instructions are imported from a binary.
"""
import argparse
import hashlib
import json
import os
from pathlib import Path
import shutil
import subprocess
import sys

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
PIECES = [('SNDIRQ', 0x006e, 0x0090), ('SNDWAIT', 0x0496, 0x0022),
          ('SNDMEM', 0x053d, 0x0021), ('SNDTAIL', 0x30c4, 0x01bf)]


def assemble(output=None, compiler=None, dosbox=None, verify=True):
    output = Path(output or HERE/'control_asm').resolve()
    compiler = Path(compiler or ROOT.parent/'work/gamemaker-tools/tools/BORLANDC').resolve()
    dosbox = Path(dosbox or ROOT.parent/'work/tools/dosbox-bin/usr/bin/dosbox').resolve()
    output.mkdir(parents=True, exist_ok=True)
    commands = ['@echo off', r'path d:\bin']
    hashes = {}
    for name, _, _ in PIECES:
        source = HERE/(name+'.ASM')
        shutil.copyfile(source, output/source.name)
        hashes[source.name] = hashlib.sha256(source.read_bytes()).hexdigest()
        for extension in ('OBJ', 'LST', 'LOG'):
            (output/(name+'.'+extension)).unlink(missing_ok=True)
        commands += [f'tasm /ml {name}.ASM,{name}.OBJ,{name}.LST > {name}.LOG',
                     'if errorlevel 1 goto failed']
    commands += ['echo OK > RESULT.TXT', 'exit', ':failed',
                 'echo FAILED > RESULT.TXT', 'exit']
    (output/'BUILD.BAT').write_bytes(('\r\n'.join(commands)+'\r\n').encode('ascii'))
    (output/'RESULT.TXT').unlink(missing_ok=True)
    libs = dosbox.parents[1]/'lib/x86_64-linux-gnu'
    environment = dict(os.environ, LD_LIBRARY_PATH=str(libs)+':'+str(libs/'sdl12-compat'),
                       SDL_VIDEODRIVER='dummy', SDL_AUDIODRIVER='dummy')
    result = subprocess.run([str(dosbox), '-noconsole', '-c',
        'config -set "cpu cycles=100000"', '-c', f'mount c "{output}"', '-c',
        f'mount d "{compiler}"', '-c', 'c:', '-c', 'BUILD.BAT'], env=environment,
        stdout=subprocess.PIPE, stderr=subprocess.STDOUT, timeout=60)
    (output/'DOSBOX.LOG').write_bytes(result.stdout)
    passed = ((output/'RESULT.TXT').exists()
              and (output/'RESULT.TXT').read_text().strip() == 'OK'
              and all((output/(n+'.OBJ')).exists() for n, _, _ in PIECES))
    report = dict(passed=passed, assembler='Borland TASM 3.1', flags='/ml',
                  source_hashes=hashes)
    (output/'assemble.json').write_text(json.dumps(report, indent=2)+'\n')
    if passed and verify:
        sys.path.insert(0, str(ROOT/'full/link'))
        import verify_object as vo
        from verify_module import verify_segment
        bindings = vo.load_bindings(HERE/'bindings.json')
        bindings['externals'].update({'_snd_isr_count':'1341:006E',
            '_snd_old_int8':'1341:0070', '__aNulmul':'1341:3179',
            '__aFuldiv':'1341:31AA'})
        bindings['functions']['_snd_0074'] = '1341:0074'
        reports = []
        for name, origin, length in PIECES:
            item = verify_segment(output/(name+'.OBJ'), ROOT/'original/SNAKE.EXE',
                                  '_TEXT', f'1341:{origin:04X}', bindings, length)
            (output/(name.lower()+'_check.json')).write_text(json.dumps(item,indent=2)+'\n')
            reports.append(dict(name=name, expected_bytes=length, compiled_bytes=item['object_size'],
                                passed=item['passed'], differences=len(item['mismatches']),
                                unresolved=item['unresolved']))
        report['verification'] = reports
        report['all_verified'] = all(r['passed'] for r in reports)
        (output/'verification.json').write_text(json.dumps(report,indent=2)+'\n')
    return report


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--output', type=Path)
    parser.add_argument('--compiler', type=Path)
    parser.add_argument('--dosbox', type=Path)
    parser.add_argument('--no-verify', action='store_true')
    args = parser.parse_args()
    result = assemble(args.output, args.compiler, args.dosbox, not args.no_verify)
    print(json.dumps(result, indent=2))
    raise SystemExit(0 if result['passed'] and result.get('all_verified', True) else 1)
