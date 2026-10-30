#!/usr/bin/env python3
"""Stage actual recovered game OBJ files and the exact CRT for native TLINK.

No target executable bytes are consulted. Missing game symbols produce ordinary
linker errors; this tool creates no code fillers or fallback implementations.
Input object order is intentional and determines both segment and relocation order.
"""
import argparse
import hashlib
import json
import shutil
from pathlib import Path
import verify_object as vo


def stage(runtime, game_objects, output, executable='SNAKE'):
    layout=json.loads((runtime/'layout.json').read_text())
    for folder in ('CRT','GAME'):(output/folder).mkdir(parents=True,exist_ok=True)
    entries=[]
    for i,path in enumerate(game_objects):
        if not path.is_file():raise FileNotFoundError(path)
        target=f'G{i:03}.OBJ';shutil.copyfile(path,output/'GAME'/target)
        entries.append(dict(input=str(path),dos_path='GAME\\'+target,
                            sha256=hashlib.sha256(path.read_bytes()).hexdigest()))
    names=[]
    for entry in layout['inputs']:
        filename=entry['object'];shutil.copyfile(runtime/'OBJ'/filename,output/'CRT'/filename)
        names.append('CRT\\'+filename)
    order=names[:1]+[e['dos_path']for e in entries]+names[1:]
    response=' +\r\n'.join(order)+f'\r\n{executable}.EXE\r\n{executable}.MAP\r\n\r\n'
    (output/'LINK.RSP').write_bytes(response.encode('ascii'))
    batch='@echo off\r\nd:\\bin\\tlink /m /s @LINK.RSP > LINK.LOG\r\n'
    batch+='if errorlevel 1 goto failed\r\necho OK > RESULT.TXT\r\nexit\r\n:failed\r\necho FAILED > RESULT.TXT\r\nexit\r\n'
    (output/'LINK.BAT').write_bytes(batch.encode('ascii'))
    manifest=dict(game_objects=entries,runtime_layout=str(runtime/'layout.json'),
        object_order=order,executable=executable+'.EXE',
        uses_original_executable_as_build_input=False,contains_placeholder_code=False)
    (output/'link_manifest.json').write_text(json.dumps(manifest,indent=2)+'\n')
    return manifest


def main():
    p=argparse.ArgumentParser(description=__doc__)
    p.add_argument('--runtime',type=Path,default=vo.ROOT/'full/link/runtime')
    source=p.add_mutually_exclusive_group(required=True)
    source.add_argument('--game',nargs='+',type=Path,help='All game OBJ files, in original object order')
    source.add_argument('--game-manifest',type=Path,help='Ordered build modules.json; includes every listed module')
    p.add_argument('--game-directory',type=Path,help='Directory containing NAME.OBJ for --game-manifest')
    p.add_argument('--output',type=Path,required=True)
    p.add_argument('--name',default='SNAKE')
    a=p.parse_args()
    if not a.name.isalnum()or len(a.name)>8:raise ValueError('DOS executable name must be 1..8 alphanumerics')
    if a.game_manifest:
        if not a.game_directory:p.error('--game-manifest requires --game-directory')
        specs=json.loads(a.game_manifest.read_text())
        a.game=[a.game_directory/(s['name']+'.OBJ')for s in specs]
    elif a.game_directory:
        p.error('--game-directory requires --game-manifest')
    result=stage(a.runtime,a.game,a.output,a.name)
    print(json.dumps(dict(staged=len(result['object_order']),game=len(result['game_objects']),response=str(a.output/'LINK.RSP')),indent=2))


if __name__=='__main__':main()
