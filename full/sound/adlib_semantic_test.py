"""Differential execution of one compiled C procedure against its reference.

This is a verification experiment, not an EXE builder. Original callees and
identical initialized state are used for both executions. C procedure code is
linked into a spare offset in the same 16-bit code frame; internal near calls
are rebound by exact OMF PUBDEF targets. No instruction is otherwise changed.
"""
from pathlib import Path
import sys,json,struct,random,hashlib,argparse
ROOT=Path(__file__).resolve().parents[2];BASE=ROOT.parent
sys.path.insert(0,str(ROOT/'full/link'));sys.path.insert(0,str(BASE/'work/python'))
import verify_object as vo
from capstone import Cs,CS_ARCH_X86,CS_MODE_16
from unicorn import Uc,UC_ARCH_X86,UC_MODE_16,UC_HOOK_CODE,UC_HOOK_INSN,UcError
from unicorn.x86_const import *

OBJ=OUT=vm=image=None
CS,DS,SS=0x1341,0x1679,0x9000
PATCH,STOP=0xF000,0xEFFF
DSBASE=DS*16
P,PLAYER,V,INSTR,E,W,PEER,DATA,NOTES,COUNT=0x7000,0x7100,0x7200,0x7300,0x7400,0x7450,0x7480,0x7500,0x7600,0x7700
FUNCS=[0x1E1A,0x1E83,0x1FA2,0x1FCC,0x1FE4,0x20AA,0x20E7,0x2102,0x2129,0x216C,0x21A2,0x21EF,0x2209,0x222F,0x2277,0x22A4,0x22CD,0x22F1,0x235A,0x23D1,0x23D2,0x247E,0x2509,0x253C,0x2567,0x2594,0x25E7,0x261A,0x2665,0x2679,0x269B,0x26C3,0x2709,0x2750,0x2772,0x278D,0x28BD,0x28DB,0x28FB,0x29A1,0x2A5E,0x2A87,0x2AD9,0x2B03,0x2B3F,0x2B6C,0x2BC4,0x2BF6,0x2C59,0x2D33,0x2DD3,0x2E7A]
RET16={0x1FE4,0x2129,0x235A,0x2509,0x2B6C,0x2D33,0x2DD3,0x2E7A}
def putw(b,off,value):struct.pack_into('<H',b,DSBASE+off,value&0xffff)
def putb(b,off,value):b[DSBASE+off]=value&255
def region(b,off,data):b[DSBASE+off:DSBASE+off+len(data)]=data
def rw(b,off):return struct.unpack_from('<H',b,DSBASE+off)[0]
def fixture():
 b=bytearray(0x100000);b[:len(image)]=image
 # These are valid initialized runtime tables, not assumptions about code.
 region(b,0x59F6,bytes((x*(y+1)>>5) if y else 0 for x in range(64) for y in range(32)))
 putw(b,0x1142,1);putw(b,0x1144,1)
 putb(b,0x1100,1)
 for n in range(32):putw(b,0x4A00+n*32+8,0x4E00+n*30)
 for n in range(9):putb(b,0x5580+n*98+7,n)
 putw(b,PLAYER+4,P);putb(b,PLAYER+12,128);putb(b,PLAYER+14,100)
 putw(b,P,PLAYER);putw(b,P+6,V);putw(b,P+8,INSTR)
 for o,v in {10:0,11:3,12:0,13:1,15:128,16:100,17:78,26:2}.items():putb(b,P+o,v)
 putw(b,V,P)
 for o,v in {6:1,7:3,8:60,9:31,10:20}.items():putb(b,V+o,v)
 region(b,INSTR,bytes(b[DSBASE+0xFA0:DSBASE+0xFBE]))
 region(b,DATA,bytes([3,1,0,100,0,0,0,2,0])+bytes(range(9,30)))
 putb(b,E,1);putw(b,E+2,20);putw(b,E+4,100);putw(b,E+6,63);putw(b,E+8,20)
 region(b,E+11,bytes([5,6,7,8]));region(b,E+15,bytes([15,30,0,25]))
 region(b,E+19,bytes([31,31,31]));putw(b,E+22,10);putw(b,E+24,7);putw(b,E+26,2)
 putb(b,E+28,1);putw(b,E+30,3)
 putw(b,W+6,PEER)
 return b

sys.path.insert(0,str(ROOT/'full/sound'))
from semantic_vm import ProcedureVM
def relocated(name):return vm.procedure(name)
def execute(entry,code,state,args,stubs):return vm.execute(entry,code,state,args,stubs)

default_args={
 0x1E1A:[],0x1E83:[PLAYER,DATA],0x1FA2:[P,3],0x1FCC:[],0x1FE4:[PLAYER,3],
 0x20AA:[P],0x20E7:[PLAYER],0x2102:[PLAYER,0x7080],0x2129:[128],
 0x216C:[PLAYER,3,60,100],0x21A2:[PLAYER,3,60],0x21EF:[P],0x2209:[P],
 0x222F:[P,NOTES,COUNT],0x2277:[PLAYER,3,0],0x22A4:[PLAYER,3,DATA],
 0x22CD:[PLAYER,3,4,12],0x22F1:[PLAYER,3,12],0x235A:[PLAYER,3,99],0x23D1:[],
 0x23D2:[PLAYER,3,0,7],0x247E:[PLAYER,3,35],0x2509:[PLAYER,3,0],
 0x253C:[PLAYER,3,80],0x2567:[PLAYER,3,0],0x2594:[PLAYER,3,1000],
 0x25E7:[PLAYER,3,7],0x261A:[PLAYER,15,3],0x2665:[P,DATA],0x2679:[4,DATA],
 0x269B:[P,3],0x26C3:[P,4,12],0x2709:[P,60,100],0x2750:[V,60],0x2772:[P],
 0x278D:[P,V,60,100],0x28BD:[V,60],0x28DB:[V],0x28FB:[V,E,W],
 0x29A1:[V,E,W,0,DATA],0x2A5E:[V,0,31],0x2A87:[V,100],0x2AD9:[V,3],
 0x2B03:[V,64],0x2B3F:[V,100],0x2B6C:[128],0x2BC4:[V],0x2BF6:[E,DATA],
 0x2C59:[E],0x2D33:[E,W],0x2DD3:[63,16],0x2E7A:[1000]}

def cases(fn):
 b=fixture()
 if fn==0x1E1A:putb(b,0x58F2,8)
 if fn in (0x28DB,0x2209):putb(b,V+11,1);putb(b,P+25,1)
 if fn==0x2BF6:region(b,DATA,bytes([3,5,20,7,45,3,8,10]))
 stubs={0x2A5E:(3,0)} if fn in (0x26C3,0x22CD) else {0x0496:(0,None)} if fn==0x1FCC else {}
 yield 'baseline',b,default_args[fn],stubs
 rng=random.Random(0xB16+fn)
 # Focused regression cases for unlink-through-owner aliases and the
 # original timer's early exit after releasing one voice.
 if fn==0x1E1A:
  b=fixture();putb(b,0x58F2,8);putw(b,P+6,0x5580)
  for n in range(2):
   v=0x5580+n*98;putw(b,v,P);putw(b,v+2,0x5580 if n else 0)
   putw(b,v+4,0 if n else 0x55E2);putw(b,v+12,5)
  yield 'two-expiring-voices-first-only',b,[],{}
 if fn in (0x1FA2,0x20E7,0x20AA):
  b=fixture()
  for n in range(3):
   p=P+n*32;putw(b,p,PLAYER);putw(b,p+2,p-32 if n else 0)
   putw(b,p+4,p+32 if n<2 else 0);putw(b,p+6,0);putb(b,p+11,3)
  args=[P,3] if fn==0x1FA2 else [PLAYER] if fn==0x20E7 else [P+32]
  yield 'three-parts-unlink',b,args,{}
 if fn in (0x2772,0x2BC4):
  b=fixture();putw(b,P+6,0x7800)
  for n in range(3):
   v=0x7800+n*98;putw(b,v,P);putw(b,v+2,v-98 if n else 0)
   putw(b,v+4,v+98 if n<2 else 0);putb(b,v+7,n)
  yield 'three-voices-unlink',b,[P] if fn==0x2772 else [0x7862],{}
 if fn==0x28FB:
  for parameter in (0,13,4,30,31):
   b=fixture();putb(b,W+2,parameter)
   yield f'parameter-branch={parameter}',b,[V,E,W],{}
  b=fixture();putb(b,E,4);putw(b,E+24,1);putb(b,E+10,1);putb(b,W+4,1)
  yield 'loop-retrigger-register-AH',b,[V,E,W],{}
 if fn==0x2B6C:
  for priority in (0,20,255):
   b=fixture();putb(b,0x58F4,8)
   for n in range(9):
    p=0x4A00+n*32;v=0x5580+n*98
    putw(b,p,PLAYER);putw(b,p+6,v);putb(b,p+15,16+n)
    putw(b,v,p)
   yield f'all-voices-active-priority={priority}',b,[priority],{}
 if fn==0x2E7A:
  for seed in range(256):
   b=fixture();putb(b,0x1100,seed)
   for value in (-4096,-63,0,31,4095):yield f'seed={seed},value={value}',b,[value],{}
 if fn==0x2DD3:
  for value in (-4096,-64,-63,-1,0,1,63,64,4095):
   for scale in range(-31,32):yield f'value={value},scale={scale}',fixture(),[value,scale],{}
 if fn in (0x2C59,0x2D33):
  for n in range(150):
   b=fixture();maximum=rng.choice([31,63,127,255,2047]);base=rng.randrange(maximum+1)
   putb(b,E,rng.randrange(1,5));putw(b,E+2,rng.randrange(-base,maximum-base+1))
   putw(b,E+4,rng.choice([0,1,17,18,100,2000]));putw(b,E+6,maximum);putw(b,E+8,base)
   putb(b,E+10,rng.randrange(2));region(b,E+11,bytes(rng.randrange(32)|(rng.randrange(2)<<7) for _ in range(4)))
   region(b,E+15,bytes(rng.randrange(64)|(rng.randrange(2)<<7) for _ in range(4)))
   region(b,E+19,bytes(rng.randrange(32) for _ in range(3)))
   total=rng.randrange(1,30);putw(b,E+22,total);putw(b,E+24,rng.randrange(1,total+1));putw(b,E+26,rng.randrange(-5,6))
   putb(b,E+28,rng.choice([-1,1]));putw(b,E+30,rng.randrange(total));putw(b,E+32,rng.randrange(total))
   yield f'envelope={n}',b,default_args[fn],{}
 if fn==0x26C3:
  for param in range(69):
   b=fixture();region(b,INSTR,bytes(rng.randrange(256) for _ in range(30)))
   yield f'parameter={param}',b,[P,param,rng.randrange(256)],{0x2A5E:(3,0)}
 if fn==0x2B6C:
  for tick in range(9):
   b=fixture();putb(b,0x58F4,tick);putb(b,0x58F5,0xA5)
   yield f'counter={tick},pad=A5',b,[128],{}
 if fn in (0x1FE4,0x216C,0x21A2,0x2277,0x22F1,0x235A,0x23D2,0x247E,0x2509,0x253C,0x2567,0x2594,0x25E7,0x261A):
  for n in range(8):
   b=fixture();args=list(default_args[fn]);putb(b,PLAYER+12,rng.randrange(256));putb(b,PLAYER+14,rng.randrange(128))
   region(b,PLAYER+15,bytes(rng.randrange(256) for _ in range(3)))
   putb(b,P+15,rng.randrange(256));putb(b,P+16,rng.randrange(128));region(b,P+18,bytes(rng.randrange(256) for _ in range(6)))
   args[1]=rng.choice([3,4,16]) if fn!=0x261A else rng.choice([14,15,16,17,18])
   yield f'part-state={n}',b,args,{}

def main():
 global OBJ,OUT,vm,image
 parser=argparse.ArgumentParser(description=__doc__)
 parser.add_argument('object',nargs='?',type=Path,default=ROOT/'full/sound/adlib_c_build/ADLIB.OBJ')
 parser.add_argument('--reference',type=Path,default=ROOT/'original/SNAKE.EXE')
 parser.add_argument('--bindings',type=Path,default=ROOT/'full/sound/bindings.json')
 parser.add_argument('--crt',type=Path,default=ROOT/'analysis/crt_symbols.json')
 parser.add_argument('-o','--output',type=Path)
 parser.add_argument('--function',action='append',help='Optional hexadecimal entry offset; repeat to select several procedures.')
 args=parser.parse_args()
 OBJ=args.object.resolve();OUT=(args.output or OBJ.parent/'semantic.json').resolve()
 OUT.parent.mkdir(parents=True,exist_ok=True)
 bind=vo.load_bindings(args.bindings,args.crt)
 vm=ProcedureVM(OBJ,args.reference,bind);image=vm.image
 chosen=FUNCS if not args.function else [int(x.removeprefix('_snd_'),16)for x in args.function]
 if any(x not in FUNCS for x in chosen):parser.error('Unknown ADLIB function offset')
 reports=[]
 for fn in chosen:
  name=f'_snd_{fn:04X}';code=relocated(name);success=0;failed=[];total=0
  for label,state,args,stubs in cases(fn):
   total+=1;a=execute(fn,code,state,args,stubs);b=execute(PATCH,code,state,args,stubs)
   errors=[]
   if not a['done'] or not b['done'] or a['error'] or b['error']:errors.append(dict(execution_original=[a['done'],a['error']],execution_compiled=[b['done'],b['error']]))
   diffs=[i for i,(x,y) in enumerate(zip(a['memory'],b['memory'])) if x!=y]
   if diffs:errors.append(dict(ds_differences=[dict(offset=f'{i:04X}',original=a['memory'][i],compiled=b['memory'][i]) for i in diffs[:32]],count=len(diffs)))
   if a['ports']!=b['ports']:errors.append(dict(port_writes_original=a['ports'][:20],port_writes_compiled=b['ports'][:20]))
   if a['calls']!=b['calls']:errors.append(dict(stub_calls_original=a['calls'],stub_calls_compiled=b['calls']))
   for r in ('sp','bp','si','di'):
    if a['registers'][r]!=b['registers'][r]:errors.append(dict(register=r,original=a['registers'][r],compiled=b['registers'][r]))
   mask=65535 if fn in RET16 else 255 if fn==0x261A else 0
   if a['registers']['ax']&mask!=b['registers']['ax']&mask:errors.append(dict(return_mask=mask,original=a['registers']['ax']&mask,compiled=b['registers']['ax']&mask))
   if errors:
    failed.append(dict(case=label,args=args,errors=errors))
    if len(failed)>=3:break
   else:success+=1
  item=dict(function=name,entry=f'1341:{fn:04X}',cases=total,passed=success,failed=failed,all_cases_equal=not failed)
  reports.append(item);print(name,total,success,'PASS' if not failed else 'FAIL',failed[:1],flush=True)
  report=dict(**vm.provenance(),
   canonical_source_sha256=hashlib.sha256((ROOT/'full/sound/ADLIB.C').read_bytes()).hexdigest(),
   canonical_header_sha256=hashlib.sha256((ROOT/'full/sound/ADLIB.H').read_bytes()).hexdigest(),
   harness_sha256=hashlib.sha256(Path(__file__).read_bytes()).hexdigest(),
   engine_sha256=hashlib.sha256((ROOT/'full/sound/semantic_vm.py').read_bytes()).hexdigest(),
   experiment='One compiled procedure with original callees, deterministic DOS data fixtures, Unicorn x86-16',
   limitations=['No full gameplay run or compiler-matching claim.','Inputs and branches are sampled, not exhaustive. Recursive calls also use reference callees.','Functions 26C3/22CD stub 2A5E to compare its exact three arguments safely.','Function 1FCC stubs hardware timer delay0496, retaining OPL reset writes.'],functions=reports)
  OUT.write_text(json.dumps(report,indent=2)+'\n')
 return 0 if all(x['all_cases_equal'] for x in reports) else 1

if __name__=='__main__':raise SystemExit(main())
