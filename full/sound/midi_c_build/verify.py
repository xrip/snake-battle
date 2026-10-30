#!/usr/bin/env python3
"""Bounded differential checks of the compiled MIDI C candidate.

Run from any directory with capstone and unicorn importable. The original
EXE is used only as a verification reference; no executable is produced.
DS and SS deliberately differ. Byte arguments are compared only in their
low eight bits, as specified by the original callee accesses and C ABI.
"""
import argparse
import hashlib
import json
from pathlib import Path
import random
import struct
import sys

HERE=Path(__file__).resolve().parent
ROOT=HERE.parents[2]
SOUND=HERE.parent
sys.path.insert(0,str(SOUND))
from semantic_vm import ProcedureVM
import verify_object as vo

DSBASE=0x16790
PLAYER,HOOKS,SEQ,DATA=0x7000,0x7040,0x7100,0x7200
HELD,FREE,PEER=0x7400,0x7480,0x7500
FUNCS=[0x0E6A,0x1041,0x1086,0x109C,0x10E7,0x1118,0x114D,0x1182,0x11B7,
       0x11F0,0x15DF,0x15F0,0x160C,0x167E,0x1684,0x16A5,0x171D,
       0x1263,0x17BB,0x17FC,0x1D6D]
RETURN_WORD={0x11F0,0x167E,0x17BB,0x17FC}
CALL_MASKS={
    0x0857:[0xFFFF]*4,
    0x07AA:[0xFFFF,0xFF,0xFF],
    0x2509:[0xFFFF,0xFF,0xFF],
    0x235A:[0xFFFF,0xFF,0xFF],
    0x2277:[0xFFFF,0xFF,0xFF],
    0x23D2:[0xFFFF,0xFF,0xFF,0xFF],
    0x075E:[0xFFFF,0xFF],0x0643:[0xFFFF],
    0x21A2:[0xFFFF,0xFF,0xFF],
    0x01CB:[],0x01D5:[],0x01DC:[0xFF],
}

def w(b,off,n):struct.pack_into('<H',b,DSBASE+off,n&0xffff)
def d(b,off,n):struct.pack_into('<I',b,DSBASE+off,n&0xffffffff)
def byte(b,off,n):b[DSBASE+off]=n&255
def region(b,off,data):b[DSBASE+off:DSBASE+off+len(data)]=bytes(data)
def far_region(b,seg,off,data):
    for i,value in enumerate(data):b[(seg<<4)+((off+i)&0xffff)]=value

def fixture(vm):
    b=vm.fresh_image()
    region(b,PLAYER,bytes([0xA5])*18)
    w(b,PLAYER,SEQ);w(b,PLAYER+2,HOOKS);w(b,PLAYER+4,0)
    byte(b,PLAYER+6,1);w(b,PLAYER+8,0x25)
    region(b,HOOKS-4,bytes([0xC3])*74)
    region(b,HOOKS,bytes((i*37+11)&255 for i in range(66)))
    region(b,SEQ,bytes([0xA6])*52);w(b,SEQ,PLAYER);byte(b,SEQ+2,1)
    d(b,SEQ+0x26,0x18000)
    region(b,DATA,bytes([7,1,3,5,0,10,0,20])+bytes(24))
    region(b,0x45D4,bytes([0xA5])*32)
    for i in range(2):byte(b,0x45D4+i*16,0)
    w(b,0x45CA,0);w(b,0x45CC,FREE);w(b,0x45CE,0)
    region(b,FREE,bytes(20))
    w(b,0x45F4,0);w(b,0x49F6,0)
    byte(b,0x49F8,0);byte(b,0x49F9,7);w(b,0x49FA,0x25);w(b,0x49FC,3)
    w(b,0x45D0,3);byte(b,0x45D2,1);byte(b,0x45D3,0xA5)
    return b

def command(b,index,kind,args):
    off=0x45F6+16*index;w(b,off,kind)
    for i in range(7):w(b,off+2+2*i,args[i] if i<len(args) else 0)

def queue_fixture(vm,start=0,matching=True):
    b=fixture(vm);w(b,0x45F4,start);w(b,0x49F6,(start+4)%64)
    command(b,start,0,[0x25 if matching else 0x26,7])
    command(b,(start+1)%64,1,[2])
    command(b,(start+2)%64,1,[6,0xA537])
    command(b,(start+3)%64,1,[3])
    return b

def cases(vm,fn):
    if fn==0x0E6A:
        for active in [0,1,255]:
            b=fixture(vm);byte(b,SEQ+2,active);yield f'active={active}',b,[SEQ],{}
    elif fn==0x1041:
        for a,b in [((0x1234,0x1000),(0x78,0x1100)),((0,0),(0,0)),
                    ((0,0x1000),(0x10,0xfff)),((0xFF00,0x1234),(1,0x8000)),
                    ((0xffff,0xffff),(0,0)),((1,0x8000),(0xFF00,0x1234))]:
            yield f'a={a},b={b}',fixture(vm),[*a,*b],{}
    elif fn==0x1086:
        yield '66-byte-hooks-with-canaries',fixture(vm),[HOOKS],{}
    elif fn in (0x109C,0x10E7,0x1118,0x114D,0x1182,0x11B7):
        params={0x109C:(0,0x0857,4),0x10E7:(1,0x07AA,3),
                0x1118:(2,0x2509,3),0x114D:(18,0x235A,3),
                0x1182:(34,0x2277,3),0x11B7:(50,0x23D2,4)}
        offset,target,nargs=params[fn]
        for channel in ([0] if fn in (0x109C,0x10E7) else [0,7,15]):
            for mode in ['unconditional','matching','nonmatching']:
                b=fixture(vm);hook=0 if mode=='unconditional' else 0x5A
                byte(b,HOOKS+offset+channel,0x5A if mode!='nonmatching' else 0x59)
                if fn==0x109C:region(b,DATA,[hook,0,1,0,7,1,0xC0])
                elif fn==0x10E7:region(b,DATA,[hook,1,0xF9])
                else:region(b,DATA,[channel,hook,0xF9,0xF8])
                yield f'{mode},channel={channel}',b,[PLAYER,DATA],{target:(nargs,0)}
    elif fn==0x11F0:
        for kind in range(17,25):
            for channel in [0,15,16,255]:
                yield f'kind={kind},channel={channel}',fixture(vm),[HOOKS,0xA500|kind,0xB600|channel],{}
    elif fn==0x15DF:
        b=fixture(vm);region(b,0x4156,bytes([0xA5])*264)
        yield '128-word-note-table-with-canaries',b,[],{}
    elif fn in (0x15F0,0x160C):
        for channel in [0,7,15]:
            for note in [0,60,127]:
                b=fixture(vm);w(b,0x415A+2*note,0xA55A)
                yield f'channel={channel},note={note}',b,[0xC300|channel,0xD400|note],{}
    elif fn==0x167E:
        for state in [0,1,255]:
            b=fixture(vm);byte(b,0x45D2,state);yield f'state={state},pad=A5',b,[],{}
    elif fn==0x1684:
        for active0,active1 in [(0,0),(1,0),(0,1),(1,1)]:
            for owner1 in [PLAYER,PEER]:
                b=fixture(vm)
                for i,active in enumerate([active0,active1]):
                    off=0x45D4+i*16;byte(b,off,active);w(b,off+2,PLAYER if i==0 else owner1)
                yield f'active={active0}{active1},owner1={owner1:04X}',b,[PLAYER],{}
    elif fn==0x16A5:
        for state in [0,1]:
            for scale in range(4):
                b=fixture(vm);byte(b,0x45D2,state);w(b,0x45D0,scale)
                yield f'no-active-fades,state={state},scale={scale}',b,[],{}
        for volume,step,direction,remainder,accum,total,remaining in [
                (8,3,1,0,0,10,3),(8,-3,-1,0,0,10,3),(1,-1,-1,0,0,10,2),
                (8,0,1,3,9,10,1),(8,0,-1,3,9,10,3),(127,1,1,0,0,10,1),
                (0,0,1,0,0,10,3),(8,0,1,-1,0,10,3)]:
            b=fixture(vm);off=0x45D4;byte(b,off,1);w(b,off+2,PLAYER)
            for delta,value in [(4,volume),(10,step),(11,direction),(12,remainder)]:byte(b,off+delta,value)
            w(b,off+6,total);w(b,off+8,remaining);w(b,off+14,accum)
            yield f'fade={volume,step,direction,remainder,accum,total,remaining}',b,[],{0x075E:(2,0),0x0643:(1,0)}
    elif fn==0x171D:
        stubs={0x01CB:(0,0),0x01D5:(0,0),0x01DC:(1,0)}
        yield 'empty',fixture(vm),[PLAYER,7],stubs
        for start in [0,62,63]:
            b=queue_fixture(vm,start);yield f'matching-3-commands,start={start}',b,[PLAYER,0xA507],stubs
        b=queue_fixture(vm);yield 'marker-mismatch',b,[PLAYER,8],stubs
        b=queue_fixture(vm,matching=False);yield 'sound-mismatch',b,[PLAYER,7],stubs
        b=queue_fixture(vm);byte(b,0x49F8,1);yield 'matching-list-still-building',b,[PLAYER,7],stubs
        b=queue_fixture(vm);command(b,2,0,[0x25,8]);yield 'stop-at-next-header',b,[PLAYER,7],stubs
    elif fn==0x1263:
        yield 'no-held-notes',fixture(vm),[],{}
        for durations,times,fractions,rate in [([2,10],[1,3],[0,0],0x10000),
                ([2,3],[1,3],[0xFFFF,0x8000],0x10000),
                ([10,2],[1,1],[0,0],0x10000),([10,20],[1,1],[0xFFFF,0x8000],0x8000)]:
            b=fixture(vm);w(b,0x45CA,HELD);d(b,SEQ+0x26,rate)
            for i in range(2):
                off=HELD+20*i;region(b,off,bytes([0xA5])*20)
                w(b,off,HELD if i else 0);w(b,off+2,0 if i else HELD+20)
                byte(b,off+4,60+i);byte(b,off+5,3+i);w(b,off+6,SEQ)
                d(b,off+8,durations[i]);d(b,off+12,times[i]);d(b,off+16,fractions[i])
            yield f'held={durations,times,fractions,rate}',b,[],{0x21A2:(3,0)}
    elif fn==0x17BB:
        for empty in [False,True]:
            for what in [0,1,2,3,0xFFFF]:
                b=fixture(vm) if empty else queue_fixture(vm,63)
                yield f'empty={empty},what={what}',b,[what],{}
    elif fn==0x17FC:
        for start in [0,62,63]:
            for match in [False,True]:
                b=queue_fixture(vm,start);command(b,(start+2)%64,1,[8,0x25 if match else 0x26])
                yield f'start={start},match={match}',b,[0x25],{}
        yield 'empty',fixture(vm),[0x25],{}
    elif fn==0x1D6D:
        events=[('running-note',[60,100]),('note-on',[0x90,60,100]),('program',[0xC0,3]),
                ('pitch',[0xE0,1,2]),('sysex',[0xF0,3,0x7D,0,0xF7]),
                ('sysex-multibyte-length',[0xF0,0x81,0]+[0]*128),
                ('escape',[0xF7,2,1,2]),('meta',[0xFF,1,3,1,2,3]),
                ('tempo',[0xFF,0x51,3,7,0xA1,0x20]),('end-track',[0xFF,0x2F,0]),
                ('unknown-system',[0xF8]),('sysex-offset-wrap',[0xF0,1,0x7F])]
        for label,event in events:
            b=fixture(vm);offset=0xFFFE if label.endswith('wrap') else 0x100
            far_region(b,0x5000,offset,event);w(b,0x414A,offset);w(b,0x414C,0x5000)
            yield label,b,[0x414A],{}


def normalized_calls(calls):
    out=[]
    for target,args in calls:
        masks=CALL_MASKS[target]
        if len(args)!=len(masks):raise ValueError('stub ABI length mismatch')
        out.append([f'{target:04X}',[value&mask for value,mask in zip(args,masks)]])
    return out

def compare(fn,a,b):
    errors=[]
    if not a['done'] or not b['done'] or a['error'] or b['error']:
        errors.append(dict(execution_original=[a['done'],a['error']],execution_compiled=[b['done'],b['error']],
                           last_addresses=[a['last_image_address'],b['last_image_address']]))
    diffs=[i for i,(x,y) in enumerate(zip(a['memory'],b['memory'])) if x!=y]
    if diffs:errors.append(dict(ds_differences=[dict(offset=f'{i:04X}',original=a['memory'][i],compiled=b['memory'][i]) for i in diffs[:24]],count=len(diffs)))
    ac,bc=normalized_calls(a['calls']),normalized_calls(b['calls'])
    if ac!=bc:errors.append(dict(typed_stub_calls_original=ac,typed_stub_calls_compiled=bc,
                              raw_calls_original=a['calls'],raw_calls_compiled=b['calls']))
    if a['ports']!=b['ports']:errors.append(dict(port_writes_original=a['ports'],port_writes_compiled=b['ports']))
    for r in ('sp','bp','si','di','ds','ss','cs'):
        if a['registers'][r]!=b['registers'][r]:errors.append(dict(register=r,original=a['registers'][r],compiled=b['registers'][r]))
    for r in (('ax','dx') if fn==0x1041 else ('ax',) if fn in RETURN_WORD else ()):
        if a['registers'][r]!=b['registers'][r]:errors.append(dict(return_register=r,original=a['registers'][r],compiled=b['registers'][r]))
    return errors

def sha(path):return hashlib.sha256(path.read_bytes()).hexdigest()
def main():
    p=argparse.ArgumentParser(description=__doc__)
    p.add_argument('--object',type=Path,default=HERE/'MIDISND.OBJ')
    p.add_argument('--reference',type=Path,default=ROOT/'original/SNAKE.EXE')
    p.add_argument('--output',type=Path,default=HERE/'semantic.json')
    p.add_argument('--functions',help='Optional comma-separated hexadecimal entries')
    args=p.parse_args()
    expected_reference='c4e064a1cf15e438017d4d6443817424f816ce4b749fcc279f2d97dc7bd86821'
    if sha(args.reference)!=expected_reference:
        raise ValueError('Reference SNAKE.EXE SHA-256 does not match the verified build')
    compilation=json.loads((HERE/'compile.json').read_text())
    for name in ('MIDISND.C','MIDISND.H'):
        if sha(HERE/name)!=compilation['source_hashes'][name]:
            raise ValueError('Archived source differs from the recorded compilation: '+name)
    bind=vo.load_bindings(SOUND/'bindings.json',ROOT/'analysis/crt_symbols.json')
    vm=ProcedureVM(args.object,args.reference,bind,ss=0x9000)
    records=[]
    functions=[int(x,16)for x in args.functions.split(',')]if args.functions else FUNCS
    for fn in functions:
        name=f'_snd_{fn:04X}'
        try:code=vm.procedure(name)
        except Exception as ex:
            records.append(dict(function=name,all_cases_equal=False,error=str(ex)));print(name,'LINK ERROR',str(ex),flush=True);continue
        passed=0;failures=[];total=0
        for label,state,call_args,stubs in cases(vm,fn):
            total+=1
            a=vm.execute(fn,code,state,call_args,stubs,instruction_limit=50000)
            b=vm.execute(vm.patch,code,state,call_args,stubs,instruction_limit=50000)
            errors=compare(fn,a,b)
            if errors:failures.append(dict(case=label,args=call_args,errors=errors))
            else:passed+=1
        item=dict(function=name,address=f'1341:{fn:04X}',cases=total,passed=passed,
                  all_cases_equal=not failures,failures=failures)
        records.append(item)
        print(name,f'{passed}/{total}','PASS'if not failures else'FAIL',json.dumps(failures[:1]),flush=True)
    report=dict(**vm.provenance(),stack_segment='9000',data_segment='1679',
        scope='Bounded differential semantic checks of selected ordinary MIDI C procedures; no full semantic or compiler-byte proof',
        compiler_profile=compilation['flags'],
        input_hashes={name:sha(HERE/name)for name in ['MIDISND.C','MIDISND.H','MIDISND.OBJ','MIDISND.COD']},
        verifier_sha256=sha(Path(__file__)),vm_sha256=sha(SOUND/'semantic_vm.py'),
        bindings_sha256=sha(SOUND/'bindings.json'),
        crt_symbol_bindings_sha256=sha(ROOT/'analysis/crt_symbols.json'),
        stub_parameter_masks={f'{k:04X}':[f'{m:04X}'for m in v]for k,v in CALL_MASKS.items()},
        limitations=['Selected deterministic cases, not exhaustive branches or valid input space.',
            'Each C procedure runs with original callees; called procedures are not recursively replaced with C.',
            'Selected side-effect callees are stubbed and typed call arguments compared; byte arguments ignore unspecified AH.',
            'Queue tests retain the real far dispatcher but stub pause/resume/master-volume leaves.',
            'Comparison covers the full DS window, ABI-preserved registers, declared return values, calls and port logs; scratch stack bytes are excluded.',
            'No hardware playback, full gameplay run or compiler byte-match claim.'],
        functions=records)
    report['summary']=dict(functions=len(records),passed_functions=sum(r.get('all_cases_equal',False)for r in records),
        cases=sum(r.get('cases',0)for r in records),passed_cases=sum(r.get('passed',0)for r in records),
        all_selected_cases_equal=all(r.get('all_cases_equal',False)for r in records),
        complete_module_semantics_proven=False,compiler_byte_exact_proven=False)
    args.output.write_text(json.dumps(report,indent=2)+'\n')
    print(json.dumps(report['summary'],indent=2))
    return 0 if report['summary']['all_selected_cases_equal']else 1
if __name__=='__main__':raise SystemExit(main())
