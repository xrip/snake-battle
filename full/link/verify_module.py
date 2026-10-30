#!/usr/bin/env python3
"""Verify a complete OMF segment contribution, its public layout and relocations.

Unlike per-function relocation, this additionally requires every supplied PUBLIC
binding in the selected segment to agree with one fixed contribution origin.
No binary instruction bytes are read from the original as reconstruction input.
"""
import argparse
import hashlib
import json
import struct
from pathlib import Path
import verify_object as vo


def verify_segment(obj_path, exe_path, segment_key, origin, bindings, expected_length=None,
                   module_name=None, allow_relaxation=True):
    modules=vo.omf.parse_omf(obj_path)
    candidates=[(m,s) for m in modules for s in m.segments
                if (str(s.index)==str(segment_key) or s.name==str(segment_key))
                and (module_name is None or m.name==module_name)]
    if len(candidates)!=1:
        raise ValueError(f'expected one segment {segment_key}; got {len(candidates)}')
    m,s=candidates[0]
    at=vo.address(origin)
    bind={k:dict(v) for k,v in bindings.items()}
    bind.setdefault('segments',{})[str(s.index)]=at
    named=dict(bind.get('externals',{}));named.update(bind.get('functions',{}))
    public_checks=[]
    for p in m.publics:
        if p['segment']==s.index and p['name'] in named:
            declared=vo.address(named[p['name']])
            expected=at.plus(p['offset'])
            public_checks.append(dict(name=p['name'],object_offset=p['offset'],
                expected=expected.as_dict(),binding=declared.as_dict(),equal=declared==expected))
    synthetic=dict(name='__whole_segment_check__',segment=s.index,offset=0)
    code,fixups,relocations,errors=vo.Binder(m,bind,synthetic,at).relocate_function(s.size,allow_relaxation)
    image,header,_=vo.omf.read_mz(exe_path)
    length=s.size if expected_length is None else expected_length
    original=image[at.linear:at.linear+length]
    raw=Path(exe_path).read_bytes()
    n,table=struct.unpack_from('<H',raw,6)[0],struct.unpack_from('<H',raw,0x18)[0]
    expected_relocs=[]
    for i in range(n):
        off,seg=struct.unpack_from('<HH',raw,table+4*i)
        address=vo.Address(seg,off)
        if at.linear<=address.linear<at.linear+length:
            expected_relocs.append(address)
    mismatch=[dict(offset=i,compiled=code[i] if i<len(code)else None,
                    original=original[i]if i<len(original)else None)
              for i in range(max(len(code),len(original)))
              if i>=len(code) or i>=len(original) or code[i]!=original[i]]
    actual_linear=[r.linear for r in relocations]
    expected_linear=[r.linear for r in expected_relocs]
    report=dict(object=str(obj_path),object_sha256=hashlib.sha256(Path(obj_path).read_bytes()).hexdigest(),
        module=m.name,segment_index=s.index,segment_name=s.name,segment_class=s.class_name,
        target=at.as_dict(),file_offset=header+at.linear,object_size=s.size,expected_size=length,
        public_bindings=public_checks,public_layout_exact=all(p['equal']for p in public_checks),
        initialized_ranges=vo.omf.ranges(s.initialized),unresolved=errors,fixups=fixups,
        relocations=[r.as_dict()for r in relocations],
        original_relocations=[r.as_dict()for r in expected_relocs],
        relocation_sites_equal=sorted(actual_linear)==sorted(expected_linear),
        relocation_order_equal=actual_linear==expected_linear,
        relocation_representation_equal=relocations==expected_relocs,
        mismatches=mismatch,byte_exact=not errors and code==original,
        relocated_sha256=hashlib.sha256(code).hexdigest(),original_sha256=hashlib.sha256(original).hexdigest())
    report['passed']=report['byte_exact']and report['public_layout_exact']and report['relocation_representation_equal']
    report['complete_segment_contribution_proven']=report['passed']
    report['complete_executable_proven']=False
    return report


def main():
    p=argparse.ArgumentParser(description=__doc__)
    p.add_argument('object',type=Path)
    p.add_argument('--exe',type=Path,default=vo.ROOT/'original/SNAKE.EXE')
    p.add_argument('--segment',default='1')
    p.add_argument('--address',required=True)
    p.add_argument('--length',type=lambda x:int(x,0))
    p.add_argument('--module')
    p.add_argument('--bindings',type=Path)
    p.add_argument('--crt',type=Path,default=vo.ROOT/'analysis/crt_symbols.json')
    p.add_argument('--no-relax',action='store_true')
    p.add_argument('-o','--output',type=Path)
    a=p.parse_args()
    report=verify_segment(a.object,a.exe,a.segment,a.address,vo.load_bindings(a.bindings,a.crt),a.length,a.module,not a.no_relax)
    out=json.dumps(report,indent=2)+'\n'
    if a.output:
        a.output.parent.mkdir(parents=True,exist_ok=True);a.output.write_text(out)
        print(json.dumps({k:report[k] for k in ('module','segment_name','object_size','expected_size','byte_exact',
              'public_layout_exact','relocation_representation_equal','passed','unresolved')},indent=2))
    else: print(out,end='')
    raise SystemExit(0 if report['passed']else 1)


if __name__=='__main__':main()
