import sys,json
from pathlib import Path
ROOT=Path(__file__).resolve().parents[2]; BASE=Path(__file__).resolve().parent
sys.path.insert(0,str(ROOT/'full/link'));import verify_object as v
b=json.loads((BASE/'bindings.json').read_text());bindings=v.load_bindings(BASE/'bindings.json',ROOT/'analysis/crt_symbols.json')
obj=Path(sys.argv[1]) if len(sys.argv)>1 else ROOT.parent/'work/hardware-tasm/HW.OBJ'
ends=sorted(int(x.split(':')[1],16)for x in b['functions'].values())+[0x9c8]
reports=[]
for n,a in b['functions'].items():
 off=int(a.split(':')[1],16);size=ends[ends.index(off)+1]-off
 r=v.verify_function(obj,ROOT/'original/SNAKE.EXE',n,a,bindings,size);reports.append(r)
 print(n,r['compiled_size'],size,r['passed'],len(r['mismatches']),r['unresolved'][:2],r['mismatches'][:4])
(BASE/'verification.json').write_text(json.dumps(reports,indent=2)+'\n')
