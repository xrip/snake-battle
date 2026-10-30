#!/usr/bin/env python3
"""Assemble the recovered register-ABI MIDI readers with original TASM 3.1.

Only ASM source and its symbolic manifest are read; SNAKE.EXE is never read.
Individual objects let the normal link place these procedures among the C
translation units in the original order.
"""
import argparse,hashlib,json,os,shutil,subprocess
from pathlib import Path
BASE=Path(__file__).resolve().parent
ROOT=BASE.parents[1]

def assemble(output,compiler=None,dosbox=None):
    output=Path(output).resolve();output.mkdir(parents=True,exist_ok=True)
    compiler=Path(compiler or ROOT.parent/'work/gamemaker-tools/tools/BORLANDC').resolve()
    dosbox=Path(dosbox or ROOT.parent/'work/tools/dosbox-bin/usr/bin/dosbox').resolve()
    manifest=json.loads((BASE/'readers/manifest.json').read_text())
    commands=['@echo off',r'path d:\bin'];hashes={}
    for row in manifest:
        source=BASE/'readers'/row['source'];name=source.stem
        shutil.copyfile(source,output/source.name)
        hashes[source.name]=hashlib.sha256(source.read_bytes()).hexdigest()
        commands.extend([f'tasm /ml {source.name},{name}.OBJ,{name}.LST > {name}.LOG','if errorlevel 1 goto failed'])
    commands.extend(['echo OK > ASMOK.TXT','exit',':failed','echo FAILED > ASMOK.TXT','exit'])
    (output/'BUILD.BAT').write_bytes(('\r\n'.join(commands)+'\r\n').encode('ascii'))
    (output/'ASMOK.TXT').unlink(missing_ok=True)
    libs=dosbox.parents[1]/'lib/x86_64-linux-gnu'
    env=dict(os.environ,LD_LIBRARY_PATH=str(libs)+':'+str(libs/'sdl12-compat'),SDL_VIDEODRIVER='dummy',SDL_AUDIODRIVER='dummy')
    result=subprocess.run([str(dosbox),'-noconsole','-c','config -set "cpu cycles=100000"','-c',f'mount c "{output}"','-c',f'mount d "{compiler}"','-c','c:','-c','BUILD.BAT'],env=env,stdout=subprocess.PIPE,stderr=subprocess.STDOUT,timeout=60)
    (output/'DOSBOX.LOG').write_bytes(result.stdout)
    passed=(output/'ASMOK.TXT').exists() and (output/'ASMOK.TXT').read_text().strip()=='OK'
    report=dict(passed=passed,source_sha256=hashes,assembler='Borland TASM 3.1',flags='/ml')
    (output/'assemble.json').write_text(json.dumps(report,indent=2)+'\n')
    return report

if __name__=='__main__':
    ap=argparse.ArgumentParser(description=__doc__);ap.add_argument('--output',type=Path,default=BASE/'readers/build');ap.add_argument('--compiler',type=Path);ap.add_argument('--dosbox',type=Path);a=ap.parse_args();r=assemble(a.output,a.compiler,a.dosbox);print(json.dumps(r,indent=2));raise SystemExit(0 if r['passed']else 1)
