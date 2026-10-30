#!/usr/bin/env python3
"""Verify reconstructed sound DATA bytes and declared BSS layout."""
from pathlib import Path
import json,sys
HERE=Path(__file__).resolve().parent
ROOT=HERE.parents[1]
sys.path.insert(0,str(ROOT/'full/link'))
import verify_object as vo
from verify_module import verify_segment
bindings=vo.load_bindings(HERE/'data_bindings.json')
obj=HERE/'data_build/SNDATA.OBJ'
report=verify_segment(obj,ROOT/'original/SNAKE.EXE','_DATA','1679:0F08',bindings,1092)
(HERE/'module_data.json').write_text(json.dumps(report,indent=2)+'\n')
m=vo.omf.parse_omf(obj)[0]
s=next(s for s in m.segments if s.name=='_BSS')
publics=[]
for p in m.publics:
    if p['segment']!=s.index: continue
    at=vo.Address(0x1679,0x413c+p['offset'])
    declared=vo.address(bindings['externals'][p['name']])
    publics.append(dict(name=p['name'],offset=p['offset'],address=at.as_dict(),matches_binding=at==declared))
bss=dict(segment='_BSS',object_size=s.size,expected_size=8378,initialized_bytes=sum(s.initialized),
    publics=publics,layout_exact=s.size==8378 and not any(s.initialized) and all(p['matches_binding'] for p in publics),
    note='BSS allocation/layout check only: uninitialized data has no bytes in the EXE.')
(HERE/'module_bss.json').write_text(json.dumps(bss,indent=2)+'\n')
print(json.dumps(dict(data_byte_exact=report['passed'],data_size=report['object_size'],bss_layout_exact=bss['layout_exact'],bss_size=s.size),indent=2))
raise SystemExit(0 if report['passed'] and bss['layout_exact'] else 1)
