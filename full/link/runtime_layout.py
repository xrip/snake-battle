#!/usr/bin/env python3
"""Recover and reproduce the complete Borland runtime contribution layout.

Uses actual OMF library modules, never code bytes from SNAKE.EXE as build input.
The game initialized/BSS spans below are layout constraints, not implementations.
An optional native-link witness reserves only those DATA spans to validate CRT
link order; it is explicitly not a reconstructed game.
"""
import argparse
import hashlib
import json
import sys
from collections import defaultdict
from pathlib import Path
import verify_object as vo
from verify_module import verify_segment

ROOT=vo.ROOT
GAME_DATA_START=0x0094
GAME_DATA_SIZE=0x12b8
GAME_BSS_SIZE=0x49d0
DGROUP=0x1679
TEXT_END=0x3ef3
DATA_BASE=DGROUP*16
TINY={'REALCVT':0x1d56,'SCANTOD':0x1d5a,'READU':0x3307,'WRITEU':0x3e7b}
CLASS_ORDER=['_DATA','_CVTSEG','_SCNSEG','_CONST','_INIT_','_INITEND_',
             '_EXIT_','_EXITEND_','_BSS','_BSSEND','_STACK']


def alignment(segment):
    return {0:1,1:1,2:2,3:16,4:256,5:4,6:4096}.get(segment.attributes>>5,1)


def align(value,boundary):
    return (value+boundary-1)//boundary*boundary


def choose_aliases(groups):
    """Select the unique sequence consistent with physical CL.LIB module order."""
    paths=[[]]
    for origin,options in sorted(groups.items()):
        paths=[path+[option] for path in paths for option in options
               if not path or option['module_file_offset']>path[-1]['module_file_offset']]
        if len(paths)>100000:
            raise ValueError('too many library-order alternatives')
    if len(paths)!=1:
        raise ValueError(f'library-order selection is not unique: {len(paths)} candidates')
    return paths[0]


def make_layout(compiler,match_report):
    lib=compiler/'LIB/CL.LIB';startup=compiler/'LIB/C0L.OBJ'
    modules=vo.omf.parse_omf(lib);c0=vo.omf.parse_omf(startup)[0]
    lookup={m.file_offset:m for m in modules}
    groups=defaultdict(list)
    for row in match_report['candidates'][0]['matches']:
        hit=row['candidates'][0]
        if row['accepted'] and row['module']!='c0.ASM' and hit['image_offset']<TEXT_END:
            groups[hit['image_offset']].append(row)
    selected=[lookup[r['module_file_offset']]for r in choose_aliases(groups)]
    selected.extend(next(m for m in modules if m.name==n)for n in TINY)
    while True:
        definitions={p['name']for m in [c0]+selected for p in m.publics}
        references={e['name']for m in [c0]+selected for e in m.externals if e['kind']!='COMDEF'}
        missing=references-definitions-{'_main'}
        additions=[]
        for name in sorted(missing):
            providers=[m for m in modules if any(p['name']==name for p in m.publics)]
            if len(providers)!=1:
                raise ValueError(f'unresolved/ambiguous runtime dependency {name}: {[m.name for m in providers]}')
            if providers[0]not in selected and providers[0]not in additions:
                additions.append(providers[0])
        if not additions:break
        selected.extend(additions)
    selected.sort(key=lambda m:m.file_offset)
    allmods=[c0]+selected
    placements={}
    cursor=0
    code_rows=[]
    for m in allmods:
        for s in m.segments:
            if s.name=='_TEXT':
                cursor=align(cursor,alignment(s));placements[(m.name,s.index)]=vo.Address(0,cursor)
                if s.size:
                    code_rows.append(dict(module=m.name,library_offset=m.file_offset,
                        image_start=cursor,image_end=cursor+s.size,size=s.size))
                cursor+=s.size
    if cursor!=TEXT_END:raise ValueError(f'CRT code end {cursor:#x}, expected {TEXT_END:#x}')
    for row in code_rows:
        if row['module']in TINY and row['image_start']!=TINY[row['module']]:
            raise ValueError('tiny runtime module order failed')
    cursor=0
    shared=[]
    game_spans=[]
    for name in CLASS_ORDER:
        segment_alignment=max([alignment(s)for m in allmods for s in m.segments if s.name==name]or[1])
        cursor=align(cursor,segment_alignment)
        begin=cursor
        for module_index,m in enumerate(allmods):
            if module_index==1 and name=='_DATA':
                cursor=align(cursor,2)
                if cursor!=GAME_DATA_START:raise ValueError('C0 data size/alignment changed')
                game_spans.append(dict(name='game_initialized_data',offset=cursor,size=GAME_DATA_SIZE))
                cursor+=GAME_DATA_SIZE
            if module_index==1 and name=='_BSS':
                game_spans.append(dict(name='game_bss',offset=cursor,size=GAME_BSS_SIZE))
                cursor+=GAME_BSS_SIZE
            for s in m.segments:
                if s.name!=name:continue
                cursor=align(cursor,alignment(s))
                placements[(m.name,s.index)]=vo.Address(DGROUP,cursor)
                cursor+=s.size
        shared.append(dict(name=name,dgroup_start=begin,dgroup_end=cursor,size=cursor-begin))
    # Empty far-data/overlay stubs precede DGROUP and share its paragraph.
    for m in allmods:
        for s in m.segments:
            if (m.name,s.index)not in placements:
                if s.size:raise ValueError(f'unplaced segment {m.name}:{s.name}')
                placements[(m.name,s.index)]=vo.Address(DGROUP,0)
    externals={'_main':vo.Address(0x03ef,3)}
    for m in allmods:
        for p in m.publics:
            if p['segment']:
                externals[p['name']]=placements[(m.name,p['segment'])].plus(p['offset'])
            else:
                externals[p['name']]=vo.Address(p['frame']or 0,p['offset'])
    # STACK is a distinct frame even though its address is conveniently described
    # as a DGROUP-relative offset for the layout table.
    for m in allmods:
        for s in m.segments:
            if s.name=='_STACK':
                a=placements[(m.name,s.index)]
                placements[(m.name,s.index)]=vo.Address(a.linear//16,a.linear%16)
    return allmods,placements,externals,dict(code=code_rows,shared_segments=shared,game_spans=game_spans,
        runtime_module_count=len(selected),runtime_code_contributions=len(code_rows),
        dgroup_segment=DGROUP,dgroup_image=DATA_BASE,crt_code_end=cursor if False else TEXT_END,
        total_group_allocation=cursor,
        initialized_group_end=next(s['dgroup_end']for s in shared if s['name']=='_EXITEND_'),
        library_sha256=hashlib.sha256(lib.read_bytes()).hexdigest(),
        startup_sha256=hashlib.sha256(startup.read_bytes()).hexdigest(),
        selection_basis='unique monotone physical CL.LIB order, then exact dependency closure')


def main():
    p=argparse.ArgumentParser(description=__doc__)
    p.add_argument('--compiler',required=True,type=Path)
    p.add_argument('--matches',type=Path,default=ROOT/'analysis/crt_symbols.json')
    p.add_argument('--exe',type=Path,default=ROOT/'original/SNAKE.EXE')
    p.add_argument('--output',type=Path,default=ROOT/'full/link/runtime')
    a=p.parse_args();a.output.mkdir(parents=True,exist_ok=True)
    mods,places,externals,layout=make_layout(a.compiler,json.loads(a.matches.read_text()))
    objects=a.output/'OBJ';objects.mkdir(exist_ok=True)
    reports=[];inputs=[]
    for i,m in enumerate(mods):
        source=a.compiler/('LIB/C0L.OBJ'if i==0 else'LIB/CL.LIB')
        filename='C0L.OBJ'if i==0 else m.name+'.OBJ'
        if len(Path(filename).stem)>8:raise ValueError('DOS name too long: '+filename)
        out=objects/filename;out.write_bytes(source.read_bytes()[m.file_offset:m.end_offset])
        bindings=dict(externals={k:v.as_dict()for k,v in externals.items()},functions={},
            groups={'DGROUP':'1679:0000'},segments={str(s.index):places[(m.name,s.index)].as_dict()for s in m.segments})
        inputs.append(dict(module=m.name,object=filename,library_offset=m.file_offset,
                          segments=bindings['segments']))
        for s in m.segments:
            if s.class_name=='CODE'and s.size:
                reports.append(verify_segment(out,a.exe,str(s.index),places[(m.name,s.index)],bindings,s.size))
    layout['inputs']=inputs
    layout['symbols']={k:v.as_dict()for k,v in externals.items()}
    layout['code_verification']=dict(passed=all(r['passed']for r in reports),
        bytes=sum(r['object_size']for r in reports),segments=len(reports),
        failures=[dict(module=r['module'],unresolved=r['unresolved'],mismatches=r['mismatches'][:10],
                       relocations=r['relocation_representation_equal'])for r in reports if not r['passed']])
    (a.output/'layout.json').write_text(json.dumps(layout,indent=2)+'\n')
    (a.output/'verification.json').write_text(json.dumps(reports,indent=2)+'\n')
    (a.output/'bindings.json').write_text(json.dumps(dict(externals=layout['symbols'],groups={'DGROUP':'1679:0000'}),indent=2)+'\n')
    # A native TLINK witness reserves *data* spans only. These are clearly named
    # probes and are never presented as reconstructed game variables or code.
    (a.output/'PROBE.C').write_text('/* Link-layout witness only; not the game. */\n'
        f'unsigned char probe_initialized_game_data[{GAME_DATA_SIZE}] = {{ 1 }};\n'
        f'unsigned char probe_game_bss[{GAME_BSS_SIZE}];\n'
        'int main(void) { return 0; }\n')
    names=['OBJ\\C0L.OBJ','PROBE.OBJ']+[f'OBJ\\{m.name}.OBJ'for m in mods[1:]]
    rsp=' +\r\n'.join(names)+'\r\nPROBE.EXE\r\nPROBE.MAP\r\n\r\n'
    (a.output/'PROBE.RSP').write_bytes(rsp.encode('ascii'))
    bat='@echo off\r\npath d:\\bin\r\nbcc -ml -a- -k -O -r- -Z -G- -c -Id:\\include PROBE.C > COMPILE.LOG\r\n'
    bat+='if errorlevel 1 goto failed\r\ntlink /m /s @PROBE.RSP > LINK.LOG\r\nif errorlevel 1 goto failed\r\necho OK > RESULT.TXT\r\nexit\r\n:failed\r\necho FAILED > RESULT.TXT\r\nexit\r\n'
    (a.output/'BUILD.BAT').write_bytes(bat.encode('ascii'))
    print(json.dumps(layout['code_verification'],indent=2))
    print('Shared segments:',layout['shared_segments'])
    if not layout['code_verification']['passed']:raise SystemExit(1)


if __name__=='__main__':main()
