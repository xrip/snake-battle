#!/usr/bin/env python3
"""Combine native C compiler listings and recovered register-ABI sound source.

This is a source-level placement tool. It neither reads the reference EXE nor
edits compiler instructions, padding, prologues, returns, or calling conventions.
The result is diagnostic until the separate byte comparison passes.
"""
import argparse
import hashlib
import json
import os
from pathlib import Path
import re
import subprocess

HERE = Path(__file__).resolve().parent
FULL = HERE.parent
ROOT = FULL.parent
SOUND = FULL/'sound'
IDENT = r'[A-Za-z_$][A-Za-z0-9_$]*'
PROC = re.compile(r'^\s*('+IDENT+r')\s+PROC\s+(NEAR|FAR)\s*$', re.I)
EXTRN = re.compile(r'^\s*EXTRN\s+(.+)$', re.I)
PUBLIC = re.compile(r'^\s*PUBLIC\s+(.+)$', re.I)
SEGMENT = re.compile(r'^\s*('+IDENT+r')\s+SEGMENT(?:\s+.*)?$', re.I)
ENDS = re.compile(r'^\s*('+IDENT+r')\s+ENDS\s*$', re.I)


def declarations(lines):
    result = []
    for raw in lines:
        line = raw.split(';', 1)[0]
        m = EXTRN.match(line)
        if m:
            for item in m[1].split(','):
                name, kind = item.strip().split(':')
                result.append((name.strip(), kind.strip().upper()))
    return result


def code_lines(path):
    """Take CODE contents; require every nonempty storage segment to be empty."""
    lines = path.read_text(errors='strict').splitlines()
    current = None
    code = []
    for line in lines:
        clean = line.split(';', 1)[0].strip()
        m = SEGMENT.match(clean)
        if m:
            current = m[1]
            continue
        if ENDS.match(clean):
            current = None
            continue
        if current and current.upper().endswith('TEXT'):
            if re.match(r'^ASSUME\b', clean, re.I) or EXTRN.match(clean):
                continue
            code.append(line)
        elif current and clean and not EXTRN.match(clean):
            raise ValueError(f'Unexpected initialized storage in {path}: {line}')
    return code, declarations(lines)


def compiler_pieces(path):
    lines, externals = code_lines(path)
    result = []
    i = 0
    while i < len(lines):
        clean = lines[i].split(';', 1)[0].strip()
        if not clean or PUBLIC.match(clean):
            i += 1
            continue
        m = PROC.match(clean)
        if not m or not re.fullmatch(r'_snd_[0-9A-Fa-f]{4}', m[1]):
            raise ValueError(f'Unparsed compiler CODE in {path}: {lines[i]}')
        name, kind = m.groups()
        end = re.compile(r'^\s*'+re.escape(name)+r'\s+ENDP\s*$', re.I)
        start = i
        while i < len(lines) and not end.match(lines[i].strip()):
            i += 1
        if i == len(lines):
            raise ValueError('Missing ENDP: '+name)
        body = '\n'.join(lines[start:i+1])
        # Only names are changed. Microsoft-generated local labels are scoped
        # to their translation unit, so merging requires a textual namespace.
        body = re.sub(r'\$[A-Za-z_][A-Za-z0-9_$]*',
                      lambda m: 'C_'+path.stem+'_'+m[0], body)
        result.append(dict(origin=int(name[-4:], 16), name=name, kind='compiler-C',
                           source=str(path), publics=[name], body='PUBLIC '+name+'\n'+body))
        i += 1
    return result, externals


def assembly_piece(path, origin):
    lines, externals = code_lines(path)
    publics = []
    for line in lines:
        m = PUBLIC.match(line.split(';', 1)[0])
        if m:
            publics.extend(x.strip() for x in m[1].split(','))
    # Private assembly labels receive a namespace, too. PUBLIC symbols retain
    # their declared names and are resolved normally by the native assembler.
    local = []
    for line in lines:
        m = re.match(r'^\s*('+IDENT+r')\s*:', line)
        if m and m[1] not in publics:
            local.append(m[1])
    body = '\n'.join(lines)
    for name in sorted(set(local), key=len, reverse=True):
        body = re.sub(r'(?<![A-Za-z0-9_$])'+re.escape(name)+r'(?![A-Za-z0-9_$])',
                      'A_'+path.stem+'_'+name, body)
    return dict(origin=origin, name=path.stem, kind='register-ABI-ASM',
                source=str(path), publics=publics, body=body), externals


def combine(listings, output):
    listings, output = Path(listings).resolve(), Path(output).resolve()
    output.mkdir(parents=True, exist_ok=True)
    pieces, externals, hashes = [], [], {}
    inputs = [listings/(name+'.ASM') for name in ('SOUND', 'MIDISND', 'ADLIB')]
    for path in inputs:
        part, ext = compiler_pieces(path)
        pieces.extend(part); externals.extend(ext)
    assembly = [(SOUND/'SNDIRQ.ASM', 0x006e),
                (SOUND/'SNDWAIT.ASM', 0x0496),
                (SOUND/'SNDMEM.ASM', 0x053d),
                (SOUND/'ADIO.ASM', 0x2e9b),
                (SOUND/'SNDTAIL.ASM', 0x30c4)]
    for row in json.loads((SOUND/'readers/manifest.json').read_text()):
        assembly.append((SOUND/'readers'/row['source'], int(row['address'].split(':')[1], 16)))
    for path, origin in assembly:
        part, ext = assembly_piece(path, origin)
        pieces.append(part); externals.extend(ext); inputs.append(path)
    for path in inputs:
        hashes[str(path)] = hashlib.sha256(path.read_bytes()).hexdigest()
    pieces.sort(key=lambda p:p['origin'])
    origins = [p['origin'] for p in pieces]
    if len(origins) != len(set(origins)):
        raise ValueError('Overlapping function/piece origins')
    defined = [s for p in pieces for s in p['publics']]
    if len(defined) != len(set(defined)):
        raise ValueError('Duplicate PUBLIC definitions')
    remaining = {}
    for name, kind in externals:
        if name in defined:
            continue
        if name in remaining and remaining[name] != kind:
            old = remaining[name]
            if old in ('NEAR', 'FAR') or kind in ('NEAR', 'FAR'):
                raise ValueError(f'Conflicting function ABI: {name} {old}/{kind}')
            # All original data operands carry their own explicit width.
            remaining[name] = 'BYTE'
        else:
            remaining[name] = kind
    header = ['; Built from original compiler /Fa output and recovered symbolic ASM.',
              '; Compiler instructions and compiler-inserted NOPs are unmodified.',
              '.286p', '.287', 'jumps',
              '_DATA segment word public \'DATA\'']
    header.extend('extrn '+n+':'+k for n, k in sorted(remaining.items()) if k not in ('NEAR', 'FAR'))
    header += ['_DATA ends',
              '_BSS segment word public \'BSS\'', '_BSS ends',
              'DGROUP group _DATA, _BSS',
              'SOUND_TEXT segment word public \'CODE\'',
              'assume cs:SOUND_TEXT, ds:DGROUP, ss:DGROUP']
    header.extend('extrn '+n+':'+k for n, k in sorted(remaining.items()) if k in ('NEAR', 'FAR'))
    for piece in pieces:
        header += ['', '; '+piece['kind']+' '+piece['name']+' (original order %04X)'%piece['origin'], piece['body']]
    header += ['SOUND_TEXT ends', 'end', '']
    source = output/'SNDSRC.ASM'
    source.write_bytes('\r\n'.join(header).encode('ascii'))
    report = dict(passed=True, input_sha256=hashes,
                  pieces=[{k:v for k,v in p.items() if k!='body'} for p in pieces],
                  unresolved_assembler_externals=remaining,
                  compiler_instructions_modified=False,
                  assembler_may_expand_conditional_branches=True,
                  reads_reference_executable=False,
                  byte_exact_claim=False,
                  assembly_sha256=hashlib.sha256(source.read_bytes()).hexdigest())
    (output/'combine.json').write_text(json.dumps(report, indent=2)+'\n')
    return report


def assemble(output, compiler=None, dosbox=None):
    output = Path(output).resolve()
    compiler = Path(compiler or ROOT.parent/'work/gamemaker-tools/tools/BORLANDC').resolve()
    dosbox = Path(dosbox or ROOT.parent/'work/tools/dosbox-bin/usr/bin/dosbox').resolve()
    for name in ('SNDSRC.OBJ', 'SNDSRC.LST', 'SNDSRC.LOG', 'RESULT.TXT'):
        (output/name).unlink(missing_ok=True)
    batch = ['@echo off', r'path d:\bin',
             'tasm /ml /m3 /l SNDSRC.ASM > SNDSRC.LOG',
             'if errorlevel 1 goto failed', 'echo OK > RESULT.TXT', 'exit',
             ':failed', 'echo FAILED > RESULT.TXT', 'exit']
    (output/'BUILD.BAT').write_bytes(('\r\n'.join(batch)+'\r\n').encode('ascii'))
    libs = dosbox.parents[1]/'lib/x86_64-linux-gnu'
    env = dict(os.environ, LD_LIBRARY_PATH=str(libs)+':'+str(libs/'sdl12-compat'),
               SDL_VIDEODRIVER='dummy', SDL_AUDIODRIVER='dummy')
    result = subprocess.run([str(dosbox), '-noconsole', '-c',
        'config -set "cpu cycles=100000"', '-c', f'mount c "{output}"',
        '-c', f'mount d "{compiler}"', '-c', 'c:', '-c', 'BUILD.BAT'],
        env=env, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, timeout=90)
    (output/'DOSBOX.LOG').write_bytes(result.stdout)
    passed = ((output/'RESULT.TXT').exists() and
              (output/'RESULT.TXT').read_text().strip() == 'OK' and
              (output/'SNDSRC.OBJ').is_file())
    report = dict(passed=passed, assembler='Borland TASM 3.1', flags='/ml /m3 /l')
    (output/'assemble.json').write_text(json.dumps(report, indent=2)+'\n')
    return report


if __name__ == '__main__':
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument('listings', type=Path)
    ap.add_argument('output', type=Path)
    ap.add_argument('--assemble', action='store_true')
    ap.add_argument('--compiler', type=Path)
    ap.add_argument('--dosbox', type=Path)
    a = ap.parse_args()
    r = combine(a.listings, a.output)
    if a.assemble:
        r['assembler'] = assemble(a.output, a.compiler, a.dosbox)
    print(json.dumps(dict(pieces=len(r['pieces']), generated=a.output/'SNDSRC.ASM',
                         assembler=r.get('assembler'), byte_exact_claim=False), default=str, indent=2))
    raise SystemExit(0 if r.get('assembler', {}).get('passed', True) else 1)
