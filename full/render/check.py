#!/usr/bin/env python3
"""Compile object verification, applying real declared OMF bindings."""
import json,sys
from pathlib import Path
ROOT=Path(__file__).resolve().parents[2]
sys.path.insert(0,str(ROOT/'full/link'))
import verify_object as vo
obj=Path(sys.argv[1]) if len(sys.argv)>1 else ROOT/'full/render/build/RENDER.OBJ'
bind=vo.load_bindings(ROOT/'full/render/bindings.json',ROOT/'analysis/crt_symbols.json')
mods=vo.omf.parse_omf(obj)
names={p['name'] for m in mods for p in m.publics}
reports=[]
for name,item in bind['functions'].items():
    if name not in names: continue
    r=vo.verify_function(obj,ROOT/'original/SNAKE.EXE',name,item['address'],bind,item['length'])
    reports.append(r)
    print(name,r['compiled_size'],r['original_size'],'PASS' if r['passed'] else 'FAIL',
          'mismatch',len(r['mismatches']),'unresolved',r['unresolved'],
          'first',r['mismatches'][:3])
path=ROOT/'full/render/verification.json'
path.write_text(json.dumps({'functions':reports,'passed_functions':sum(r['passed'] for r in reports),
                           'matched_bytes':sum(r['original_size'] for r in reports if r['passed'])},indent=2)+'\n')
