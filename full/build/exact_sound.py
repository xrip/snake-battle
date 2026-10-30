#!/usr/bin/env python3
"""Build a separate whole-program baseline from symbolic sound instructions.

Ordinary game modules still compile from the recovered C. The sound baseline
is an executable symbolic specification while matching its ordinary C to a
historical compiler remains unfinished. This builder never reads SNAKE.EXE.
It never copies opcode ranges, emits a binary template, or patches an EXE.
"""
import argparse
import hashlib
import json
from pathlib import Path
import re
import shutil
import sys
from types import SimpleNamespace

HERE = Path(__file__).resolve().parent
FULL = HERE.parent
ROOT = FULL.parent
SOUND = FULL/'sound'
sys.path.insert(0, str(HERE))
sys.path.insert(0, str(FULL/'link'))
sys.path.insert(0, str(ROOT/'tools'))
import aliases
import build
import extract_runtime
import omf
import sound_listing as listing
import stage_link

# Order and lengths are part of the recovered source layout specification.
# Their bytes are produced solely by TASM from instruction/data declarations.
INTERVALS = [
    ('exact/CONTROL.ASM', 'SC000C', 0x000c, 0x006e, 'symbolic specification'),
    ('SNDIRQ.ASM', '_TEXT', 0x006e, 0x00fe, 'register-ABI source'),
    ('exact/CONTROL.ASM', 'SC00FE', 0x00fe, 0x0496, 'symbolic specification'),
    ('SNDWAIT.ASM', '_TEXT', 0x0496, 0x04b8, 'register-ABI source'),
    ('exact/CONTROL.ASM', 'SC04B8', 0x04b8, 0x053d, 'symbolic specification'),
    ('SNDMEM.ASM', '_TEXT', 0x053d, 0x055e, 'register-ABI source'),
    ('exact/CONTROL.ASM', 'SC055E', 0x055e, 0x0db9, 'symbolic specification'),
    ('exact/MIDI.ASM', '_TEXT', 0x0db9, 0x1e1a, 'symbolic specification and register-ABI readers'),
    ('exact/ADLIB.ASM', '_TEXT', 0x1e1a, 0x2e9b, 'symbolic specification'),
    ('ADIO.ASM', '_TEXT', 0x2e9b, 0x30c4, 'register-ABI source'),
    ('SNDTAIL.ASM', '_TEXT', 0x30c4, 0x3283, 'register-ABI source'),
    ('exact/CONTROL.ASM', 'SC3283', 0x3283, 0x3371, 'symbolic specification'),
]


def read_source(path):
    lines = path.read_text().splitlines()
    code = {}
    current = None
    externals = listing.declarations(lines)
    publics = []
    for line in lines:
        clean = line.split(';',1)[0].strip()
        m = listing.PUBLIC.match(clean)
        if m:
            publics.extend(n.strip() for n in m[1].split(','))
        m = listing.SEGMENT.match(clean)
        if m:
            current = m[1]
            if re.search(r"'CODE'", clean, re.I):
                code.setdefault(current, [])
            continue
        if listing.ENDS.match(clean):
            current = None
            continue
        if current in code:
            if re.match(r'^ASSUME\b',clean,re.I) or listing.EXTRN.match(clean) or listing.PUBLIC.match(clean):
                continue
            code[current].append(line)
        elif current and clean and not listing.EXTRN.match(clean) and not listing.PUBLIC.match(clean):
            raise ValueError(f'Unexpected storage definition outside sound CODE in {path}: {line}')
    return code, publics, externals


def combine(output):
    output = Path(output).resolve()
    output.mkdir(parents=True,exist_ok=True)
    loaded = {}
    for filename, _, _, _, _ in INTERVALS:
        if filename not in loaded:
            loaded[filename] = read_source(SOUND/filename)
    pieces, externals, all_publics = [], [], []
    for filename, segment, start, end, kind in INTERVALS:
        code, file_publics, ext = loaded[filename]
        if segment not in code:
            raise ValueError(f'{filename}: missing CODE segment {segment}')
        lines = code[segment]
        definitions = set()
        local = []
        for line in lines:
            m = re.match(r'^\s*('+listing.IDENT+r')\s*(?::|\s+(?:label|proc|dw|dd|db|dq|dt|equ)\b)',line,re.I)
            if m:
                definitions.add(m[1])
                if m[1] not in file_publics:
                    local.append(m[1])
        publics = [n for n in file_publics if n in definitions]
        body = '\n'.join(lines)
        prefix = 'X_%04X_'%start
        for name in sorted(set(local),key=len,reverse=True):
            body = re.sub(r'(?<![A-Za-z0-9_$])'+re.escape(name)+r'(?![A-Za-z0-9_$])',prefix+name,body)
        pieces.append(dict(source=filename,segment=segment,origin=start,end=end,kind=kind,
                           publics=publics,body=body))
        all_publics.extend(publics);externals.extend(ext)
    if len(all_publics)!=len(set(all_publics)):
        raise ValueError('Duplicate PUBLIC symbols in combined sound specification')
    ext = {}
    for name, kind in externals:
        if name in all_publics:
            continue
        if name in ext and ext[name]!=kind:
            if kind in ('NEAR','FAR') or ext[name] in ('NEAR','FAR'):
                raise ValueError('Conflicting external function ABI: '+name)
            ext[name]='BYTE'
        else:
            ext[name]=kind
    header = ['; Symbolic SOUND specification; not a historical-source claim.',
              '; Recovered ordinary C is retained separately; compiler matching is pending.',
              '.286p','.287','_DATA segment word public \'DATA\'']
    header += ['extrn '+n+':'+k for n,k in sorted(ext.items()) if k not in ('NEAR','FAR')]
    header += ['_DATA ends','_BSS segment word public \'BSS\'','_BSS ends',
               'DGROUP group _DATA, _BSS','SOUND_TEXT segment word public \'CODE\'',
               'assume cs:SOUND_TEXT, ds:DGROUP, ss:DGROUP']
    header += ['extrn '+n+':'+k for n,k in sorted(ext.items()) if k in ('NEAR','FAR')]
    for p in pieces:
        header += ['', '; '+p['source']+' '+p['segment']+' %04X..%04X'%(p['origin'],p['end'])]
        header += ['public '+n for n in p['publics']]
        header.append(p['body'])
    header += ['SOUND_TEXT ends','end','']
    source = output/'SNDSRC.ASM'
    source.write_bytes('\r\n'.join(header).encode('ascii'))
    result = dict(source_sha256={n:hashlib.sha256((SOUND/n).read_bytes()).hexdigest()for n in loaded},
                  pieces=[{k:v for k,v in p.items()if k!='body'}for p in pieces],
                  code_origin='1341:000C',code_end='1341:3371',expected_code_size=0x3371-0xc,
                  expected_linker_alignment_before_dgroup=15,
                  remaining_external_names=sorted(ext),
                  reads_reference_executable=False,emits_opcode_arrays=False,
                  historical_sound_source_language_proven=False,
                  ordinary_sound_C_compiler_match_proven=False,
                  generated_assembly_sha256=hashlib.sha256(source.read_bytes()).hexdigest())
    (output/'combine.json').write_text(json.dumps(result,indent=2)+'\n')
    return result


def run(args):
    output = Path(args.output).resolve()
    output.mkdir(parents=True,exist_ok=True)
    for name in ('build.json','comparison.json','provenance.json','native/SNAKE.EXE'):
        (output/name).unlink(missing_ok=True)
    runtime_report = extract_runtime.extract(args.bc31,output/'runtime')
    core_report = None
    if not args.skip_core_compile:
        core_report = build.build(SimpleNamespace(bc31=args.bc31,bc2=args.bc2,dosbox=args.dosbox,
                                                 runtime=output/'runtime',
                                                 skip_compile=False,stage_only=True))
    source_report = combine(output/'sound')
    asm_report = listing.assemble(output/'sound',args.bc31,args.dosbox)
    if not asm_report['passed']:
        raise RuntimeError('TASM failed; inspect exact/sound/SNDSRC.LOG')
    module = omf.parse_omf(output/'sound/SNDSRC.OBJ')[0]
    code = next(s for s in module.segments if s.class_name=='CODE')
    if code.size != source_report['expected_code_size']:
        raise ValueError(f'Unexpected SOUND size: {code.size}; expected {source_report["expected_code_size"]}')
    specs = json.loads((HERE/'modules.json').read_text())
    objects = output/'obj';objects.mkdir(exist_ok=True)
    for spec in specs:
        source = output/'sound/SNDSRC.OBJ' if spec['name']=='SOUND' else HERE/'obj'/(spec['name']+'.OBJ')
        shutil.copyfile(source,objects/(spec['name']+'.OBJ'))
    alias_report = aliases.run(True,objects,output/'linkobj',output,output/'runtime')
    stage_link.stage(output/'runtime',[output/'linkobj'/(s['name']+'.OBJ')for s in specs],output/'native')
    link_report = build.native_link(output/'native',args.bc31,args.dosbox)
    provenance = provenance_report(args,source_report,runtime_report,core_report)
    (output/'provenance.json').write_text(json.dumps(provenance,indent=2)+'\n')
    report = dict(kind='Symbolic sound specification with compiler-built game C and original CRT',
                  source=source_report,assembly=asm_report,native_link=link_report,
                  runtime_extracted_from_original_compiler_this_run=True,
                  runtime_extraction=runtime_report,
                  provenance_file='provenance.json',
                  core_compiled_from_sources_this_run=not args.skip_core_compile,
                  core_compilation=core_report,
                  linked_input_objects=[dict(module=s['name'],
                      sha256=hashlib.sha256((output/'linkobj'/(s['name']+'.OBJ')).read_bytes()).hexdigest())
                      for s in specs],
                  missing_externals=alias_report['missing_externals'],
                  public_layout_mismatches=alias_report['public_layout_mismatches'],
                  no_reference_executable_build_input=True,no_executable_patches=True,
                  historical_sound_source_language_proven=False,
                  ordinary_sound_C_compiler_match_proven=False,
                  full_file_equality_checked_by_separate_verifier=False)
    (output/'build.json').write_text(json.dumps(report,indent=2)+'\n')
    return report


def provenance_report(args,source_report,runtime_report,core_report):
    """Hash build inputs only; no reference executable is inspected."""
    def describe(path,root=None):
        path=Path(path).resolve()
        data=path.read_bytes()
        return dict(path=str(path.relative_to(root))if root else str(path),
                    size=len(data),sha256=hashlib.sha256(data).hexdigest())
    tools=[]
    for distribution,root,names in (
            ('Borland C++ 3.1',Path(args.bc31).resolve(),('BIN/BCC.EXE','BIN/TASM.EXE','BIN/TLINK.EXE')),
            ('Borland C++ 2.0',Path(args.bc2).resolve(),('BIN/BCC.EXE',))):
        for name in names:
            tools.append(dict(distribution=distribution,**describe(extract_runtime.compiler_file(root,name))))
    tools.append(dict(distribution='DOSBox host',**describe(args.dosbox)))
    configs=[]
    for distribution,root in (('Borland C++ 3.1',Path(args.bc31).resolve()),
                              ('Borland C++ 2.0',Path(args.bc2).resolve())):
        for name in ('BIN/BCC.CFG','BIN/TASM.CFG','BIN/TLINK.CFG'):
            try:
                path=extract_runtime.compiler_file(root,name)
            except FileNotFoundError:
                continue
            configs.append(dict(distribution=distribution,**describe(path)))
    headers=[]
    for distribution,root in (('Borland C++ 3.1',Path(args.bc31).resolve()),
                              ('Borland C++ 2.0',Path(args.bc2).resolve())):
        include=extract_runtime.compiler_file(root,'INCLUDE')
        for path in sorted(p for p in include.rglob('*')if p.is_file()):
            headers.append(dict(distribution=distribution,**describe(path,root)))
    files={HERE/'modules.json',HERE/'globals/manifest.json',
           HERE/'exact_sound.py',HERE/'build.py',HERE/'prepare.py',HERE/'aliases.py',
           HERE/'sound_listing.py',FULL/'compile.py',FULL/'gpf/assemble.py',
           FULL/'ega/assemble.py',FULL/'ega/pack.py',FULL/'link/stage_link.py',
           FULL/'link/extract_runtime.py',FULL/'link/runtime/layout.json',ROOT/'tools/omf.py'}
    files.update((HERE/'globals').glob('*.inc'))
    files.update(FULL/d/f for d,f in (
        ('link/runtime','bindings.json'),('ui','ui_symbols.json'),
        ('game','bindings.json'),('render','bindings.json'),('formats','bindings.json'),
        ('graphics','bindings.json'),('low','bindings.json'),('gpf','bindings.json'),
        ('hardware','bindings.json'),('ega','retrace_bindings.json'),
        ('sound','data_bindings.json'),('sound','bindings.json')))
    files.update(SOUND/name for name in source_report['source_sha256'])
    prepared=core_report['preparation']if core_report else json.loads((HERE/'prepare.json').read_text())
    files.update(FULL/name for name in prepared['source_hashes'])
    return dict(original_tool_binaries=tools,original_tool_configuration_files=configs,
        compiler_include_file_inventory=headers,
        recovered_sources_and_build_scripts=[describe(p,ROOT)for p in sorted(files)],
        runtime_library_sha256=runtime_report['library_sha256'],
        runtime_startup_sha256=runtime_report['startup_sha256'],
        runtime_objects=runtime_report['objects'],
        freshly_compiled_core=not args.skip_core_compile,
        compiler_generated_source_snapshots=prepared['staged'],
        all_paths_are_build_inputs_or_source_metadata=True,
        reads_reference_executable=False,
        note='Header inventory records the supplied include tree; individual include use is compiler-dependent.')


if __name__=='__main__':
    p=argparse.ArgumentParser(description=__doc__)
    p.add_argument('--output',type=Path,default=HERE/'exact')
    p.add_argument('--bc31',type=Path,default=ROOT.parent/'work/gamemaker-tools/tools/BORLANDC')
    p.add_argument('--bc2',type=Path,default=ROOT.parent/'work/bc2/original/BC2')
    p.add_argument('--dosbox',type=Path,default=ROOT.parent/'work/tools/dosbox-bin/usr/bin/dosbox')
    p.add_argument('--skip-core-compile',action='store_true')
    a=p.parse_args();r=run(a)
    print(json.dumps({k:r[k]for k in ('kind','missing_externals','public_layout_mismatches',
        'native_link','ordinary_sound_C_compiler_match_proven')},indent=2))
    raise SystemExit(0 if r['native_link']['passed']else 1)
