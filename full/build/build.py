#!/usr/bin/env python3
"""Build the recovered sources with original DOS compilers and native TLINK.

Missing modules remain ordinary undefined symbols.  No placeholder CODE, copied
EXE ranges, opcode arrays, address trampolines, or binary patches are generated.
This script does not open the reference executable.  Run verify.py separately.
"""
import argparse
import importlib.util
import json
import os
import shutil
import subprocess
import sys
import time
from pathlib import Path

HERE = Path(__file__).resolve().parent
FULL = HERE.parent
ROOT = FULL.parent
BASE = ROOT.parent
sys.path.insert(0, str(HERE))
sys.path.insert(0, str(FULL / 'link'))
import aliases
import prepare
import stage_link


def load_module(name, path):
    spec = importlib.util.spec_from_file_location(name, path)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def native_link(output, compiler, dosbox):
    """Execute the actual linker; leave all diagnostics and its MAP intact."""
    output, compiler, dosbox = [Path(p).resolve() for p in (output, compiler, dosbox)]
    (output / 'RESULT.TXT').unlink(missing_ok=True)
    executable = output / 'SNAKE.EXE'
    executable.unlink(missing_ok=True)
    libbase = dosbox.parents[1] / 'lib/x86_64-linux-gnu'
    environment = dict(os.environ, LD_LIBRARY_PATH=str(libbase) + ':' + str(libbase / 'sdl12-compat'),
                       SDL_VIDEODRIVER='dummy', SDL_AUDIODRIVER='dummy')
    command = [str(dosbox), '-noconsole', '-c', 'config -set "cpu cycles=100000"',
               '-c', f'mount c "{output}"', '-c', f'mount d "{compiler}"',
               '-c', 'c:', '-c', 'LINK.BAT']
    started = time.monotonic()
    process = subprocess.run(command, env=environment, stdout=subprocess.PIPE,
                             stderr=subprocess.STDOUT, timeout=120)
    (output / 'DOSBOX.LOG').write_bytes(process.stdout)
    passed = ((output / 'RESULT.TXT').exists()
              and (output / 'RESULT.TXT').read_text().strip() == 'OK')
    # TLINK can write an unusable EXE even after undefined-symbol errors.
    # Keep its MAP and diagnostics, but never expose that as a built game.
    if not passed:
        executable.unlink(missing_ok=True)
    return dict(passed=passed, seconds=round(time.monotonic() - started, 3),
                executable_produced=passed and executable.exists(),
                diagnostics=(output / 'LINK.LOG').read_text(errors='replace')
                if (output / 'LINK.LOG').exists() else 'No linker log was produced.')


def build(args):
    runtime = Path(getattr(args, 'runtime', None) or FULL/'link/runtime').resolve()
    prepared = prepare.prepare()
    specs = json.loads((HERE / 'modules.json').read_text())
    available = [m for m in specs if not m.get('pending')]
    compilation = []
    if not args.skip_compile:
        bc = load_module('native_borland_compile', FULL / 'compile.py')
        assembler = load_module('native_tasm_compile', FULL / 'gpf/assemble.py')
        groups = {}
        for m in available:
            if m['compiler'] in ('tasm31', 'tasm31-ega'):
                continue
            key = (m['compiler'], m.get('flags', '-ml -a- -k- -O -r- -Z -G-'))
            groups.setdefault(key, []).append(Path(m['source']).name.upper())
        for i, ((compiler, flags), files) in enumerate(groups.items()):
            if compiler not in ('bc31', 'bc2'):
                raise ValueError('Compiler integration is not implemented: ' + compiler)
            print(f'Compiling {compiler}: {", ".join(files)}', flush=True)
            result = bc.compile_sources(HERE / 'src', HERE / 'obj', files, flags,
                                        getattr(args, compiler), args.dosbox)
            compilation.append(result)
            (HERE / f'compile_{i:02d}.json').write_text(json.dumps(result, indent=2) + '\n')
            if not result['passed']:
                raise RuntimeError('Native compiler failed; inspect full/build/obj/*.LOG')
        for m in available:
            if m['compiler'] == 'tasm31-ega':
                ega = load_module('native_ega_assembler', FULL / 'ega/assemble.py')
                packer = load_module('original_ega_encoding', FULL / 'ega/pack.py')
                print('Assembling and encoding EGA driver', flush=True)
                result = ega.assemble(HERE / 'egaobj', args.bc31, args.dosbox)
                compilation.append(result)
                if not result['passed']:
                    raise RuntimeError('Native EGA assembler failed; inspect egaobj/EGA.LOG')
                packed = packer.pack(HERE / 'egaobj/EGA.OBJ', HERE / 'obj/EGA.OBJ')
                (HERE / 'egaobj/pack.json').write_text(json.dumps(packed, indent=2)+'\n')
                compilation.append(packed)
            if m['compiler'] == 'tasm31':
                if m['name'] != 'LZSS':
                    raise ValueError('Assembly recipe not specified: ' + m['name'])
                print('Assembling LZSS with original TASM', flush=True)
                # TASM's DOS path probing is sensitive to an existing mixed
                # compiler-output directory. Assemble in its own directory.
                result = assembler.assemble(HERE / 'asmobj', args.bc31, args.dosbox)
                compilation.append(result)
                if not result['passed']:
                    raise RuntimeError('Native assembler failed; inspect asmobj/ASMLZSS.LOG')
                shutil.copyfile(HERE / 'asmobj/LZSS.OBJ', HERE / 'obj/LZSS.OBJ')
    for m in available:
        if not (HERE / 'obj' / (m['name'] + '.OBJ')).is_file():
            raise FileNotFoundError('Missing native compiler output: ' + m['name'])
    resolved = aliases.run(runtime=runtime)
    objects = [HERE / 'linkobj' / (m['name'] + '.OBJ') for m in available]
    staged = stage_link.stage(runtime, objects, HERE / 'native')
    result = dict(preparation=prepared, compilation=compilation,
                  alias_objects=len(resolved['objects']),
                  public_layout_mismatches=resolved['public_layout_mismatches'],
                  missing_externals=resolved['missing_externals'],
                  pending_modules=[m['name'] for m in specs if m.get('pending')],
                  native_link=None, uses_reference_executable_as_input=False,
                  contains_placeholder_code=False, complete_executable_proven=False)
    if not args.stage_only:
        print('Linking recovered objects with original TLINK', flush=True)
        result['native_link'] = native_link(HERE / 'native', args.bc31, args.dosbox)
    (HERE / 'build.json').write_text(json.dumps(result, indent=2) + '\n')
    return result


if __name__ == '__main__':
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument('--bc31', type=Path, default=BASE / 'work/gamemaker-tools/tools/BORLANDC')
    p.add_argument('--bc2', type=Path, default=BASE / 'work/bc2/original/BC2')
    p.add_argument('--dosbox', type=Path, default=BASE / 'work/tools/dosbox-bin/usr/bin/dosbox')
    p.add_argument('--runtime', type=Path, help='Fresh extract_runtime.py output directory')
    p.add_argument('--skip-compile', action='store_true', help='Link existing native OBJ files for diagnosis')
    p.add_argument('--stage-only', action='store_true', help='Emit LINK.BAT and LINK.RSP without running DOS')
    args = p.parse_args()
    report = build(args)
    print(json.dumps({k: report[k] for k in ('alias_objects', 'public_layout_mismatches',
          'missing_externals', 'pending_modules', 'native_link')}, indent=2))
    raise SystemExit(0 if report['native_link'] and report['native_link']['passed']
                     and not report['pending_modules'] else 1)
