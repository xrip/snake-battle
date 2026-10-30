#!/usr/bin/env python3
"""Package assembler-produced SPEGAVGA code in its original encoded OMF form.

This is the library's build-time encoding step. It consumes a fresh TASM OBJ,
resolves only its ordinary offset fixups, and encodes the bounded payload.
It does not read an EXE, decoded binary, or binary template.
"""
import argparse,hashlib,json,struct,sys
from pathlib import Path
BASE=Path(__file__).resolve().parent;ROOT=BASE.parents[1]
sys.path.insert(0,str(ROOT/'full/link'));import verify_object as vo

def record(kind,payload):
    data=bytes([kind])+struct.pack('<H',len(payload)+1)+payload
    return data+bytes([(-sum(data))&255])
def counted(s):
    s=s.encode('ascii');return bytes([len(s)])+s

def encode(data):
    out=bytearray();state=0
    for value in data:
        state=((state<<1)|(state>>7))&255
        out.append(value^state);state=(state+value)&255
    return bytes(out)

def pack(source,destination):
    modules=vo.omf.parse_omf(source)
    if len(modules)!=1:raise ValueError('one recovered driver module required')
    m=modules[0];segs=[s for s in m.segments if s.size]
    if len(segs)!=1:raise ValueError('driver must contain one CODE contribution')
    s=segs[0]
    synthetic=dict(name='__driver_origin',segment=s.index,offset=0)
    bind=dict(functions={},externals={},segments={str(s.index):'0000:0000'},groups={})
    raw,trace,relocs,errors=vo.Binder(m,bind,synthetic,'0000:0000').relocate_function(s.size,False)
    if errors or relocs:raise ValueError('driver needs no runtime relocation: '+repr(errors or relocs))
    if len(raw)!=12374:raise ValueError('recovered driver contribution length mismatch')
    start,end=6+0xb0,6+0x2fd0
    coded=raw[:start]+encode(raw[start:end])+raw[end:]
    # Native OMF 16: paragraph-aligned PUBLIC CODE segment, two public entries.
    records=[record(0x80,counted('SPEGAVGA')),
             record(0x96,counted('')+counted('EGA_TEXT')+counted('CODE')),
             record(0x98,bytes([0x68])+struct.pack('<H',len(coded))+bytes([2,3,1])),
             record(0x90,bytes([0,1])+counted('_ega_dispatch')+struct.pack('<H',0)+bytes([0])+counted('_ega_header')+struct.pack('<H',6)+bytes([0]))]
    for at in range(0,len(coded),1024):records.append(record(0xa0,bytes([1])+struct.pack('<H',at)+coded[at:at+1024]))
    records.append(record(0x8a,b'\0'))
    result=b''.join(records);destination=Path(destination);destination.parent.mkdir(parents=True,exist_ok=True);destination.write_bytes(result)
    return dict(passed=True,assembly_object_sha256=hashlib.sha256(Path(source).read_bytes()).hexdigest(),plaintext_size=len(raw),plaintext_sha256=hashlib.sha256(raw).hexdigest(),encoded_payload_range=[start,end],encoded_size=len(coded),encoded_sha256=hashlib.sha256(coded).hexdigest(),output_object_sha256=hashlib.sha256(result).hexdigest(),runtime_relocations=0,ordinary_offset_fixups=len(trace),reference_executable_used_as_build_input=False)

if __name__=='__main__':
    ap=argparse.ArgumentParser(description=__doc__);ap.add_argument('source',type=Path);ap.add_argument('destination',type=Path);ap.add_argument('--report',type=Path);a=ap.parse_args();r=pack(a.source,a.destination);t=json.dumps(r,indent=2)+'\n';print(t,end='');
    if a.report:a.report.write_text(t)
