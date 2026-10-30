#!/usr/bin/env python3
"""Resolve recovered names using OMF public aliases, without changing any bytes.

Only PUBDEF records are added. LEDATA/LIDATA, FIXUPP, segment attributes, code,
initialized data, BSS sizes and symbol definitions produced by BCC are unchanged.
Aliases into aggregates expose actual C fields; function aliases share the
compiler's existing function offset, even when that function is still drifting.
"""
from pathlib import Path
import hashlib,json,struct,sys
HERE=Path(__file__).resolve().parent
FULL=HERE.parent
ROOT=FULL.parent
sys.path.insert(0,str(ROOT/'tools'))
import omf

def addr(value):
    if isinstance(value,dict):value=value['address']
    if not isinstance(value,str):return None
    a,b=(int(x,16)for x in value.split(':'));return(a,b)
def astr(a):return '%04X:%04X'%a

def bindings():
    out={};conflicts=[]
    paths=[FULL/'link/runtime/bindings.json']
    paths += [FULL/d/f for d,f in [('ui','ui_symbols.json'),('game','bindings.json'),('render','bindings.json'),('formats','bindings.json'),('graphics','bindings.json'),('low','bindings.json'),('gpf','bindings.json'),('hardware','bindings.json'),('ega','retrace_bindings.json')]]
    paths += [FULL/'sound/data_bindings.json', FULL/'sound/bindings.json']
    for path in paths:
        if not path.exists():continue
        j=json.loads(path.read_text())
        for section in ('externals','functions'):
            for name,value in j.get(section,{}).items():
                a=addr(value)
                if a is None:continue
                if name in out and out[name]!=a:conflicts.append(dict(name=name,old=astr(out[name]),new=astr(a),source=str(path)))
                out[name]=a
    for a in json.loads((HERE/'globals/manifest.json').read_text()):
        out[a['anchor']]=addr(a['address'])
        for s in a['aliases']:out[s['name']]=addr(s['address'])
    if conflicts:raise ValueError('Conflicting original bindings: '+repr(conflicts))
    out['_ega_dispatch']=(0x0ed6,0)
    out['_ega_header']=(0x0ed6,6)
    return out

def index(n):
    if n<128:return bytes([n])
    return bytes([(n>>8)|128,n&255])
def record(kind,payload):
    header=bytes([kind])+struct.pack('<H',len(payload)+1)
    return header+payload+bytes([(-sum(header+payload))&255])
def records(data):
    p=0
    while p<len(data):
        n=struct.unpack_from('<H',data,p+1)[0];end=p+3+n
        raw=data[p:end]
        if len(raw)!=3+n or sum(raw)&255:raise ValueError('bad OMF checksum or truncated record')
        yield data[p],raw
        p=end

def pubdef(group,segment,symbols):
    payload=index(group)+index(segment)
    for name,offset in symbols:
        raw=name.encode('ascii')
        if len(raw)>255:raise ValueError(name)
        payload+=bytes([len(raw)])+raw+struct.pack('<H',offset)+index(0)
    return record(0x90,payload)

def pubdefs(group,segment,symbols):
    """Keep records within the 1024-byte limit accepted by the native linker."""
    chunk=[];size=len(index(group))+len(index(segment))
    for name,offset in symbols:
        n=1+len(name.encode('ascii'))+2+len(index(0))
        if size+n+4>1024:
            yield pubdef(group,segment,chunk)
            chunk=[];size=len(index(group))+len(index(segment))
        chunk.append((name,offset));size+=n
    if chunk:yield pubdef(group,segment,chunk)

def run(include_pending=False, input_dir=None, output_dir=None, report_dir=None, runtime=None):
    input_dir=Path(input_dir or HERE/'obj').resolve()
    output_dir=Path(output_dir or HERE/'linkobj').resolve()
    report_dir=Path(report_dir or HERE).resolve();report_dir.mkdir(parents=True,exist_ok=True)
    runtime=Path(runtime or FULL/'link/runtime').resolve()
    originals=bindings();module_specs=json.loads((HERE/'modules.json').read_text())
    agg=json.loads((HERE/'globals/manifest.json').read_text())
    objects={};providers={};problems=[];layout=[]
    for spec in module_specs:
        if spec.get('pending') and not include_pending:continue
        path=input_dir/(spec['name']+'.OBJ')
        if not path.exists():continue
        modules=omf.parse_omf(path)
        if len(modules)!=1:raise ValueError('one input module per object required')
        m=modules[0];objects[spec['name']]=(path,m,spec)
        segment_bases={}
        for seg in m.segments:
            key='code'if seg.class_name=='CODE'else 'data'if seg.name=='_DATA'else'bss'if seg.name=='_BSS'else None
            if key and key in spec:segment_bases[seg.index]=addr(spec[key])
        # The aliases use actual compiler PUBDEF offsets, never guessed code sizes.
        for public in m.publics:
            base=segment_bases.get(public['segment'])
            if base is None:continue
            actual=(base[0],base[1]+public['offset'])
            want=originals.get(public['name'])
            if want and want!=actual:problems.append(dict(module=spec['name'],symbol=public['name'],expected=astr(want),actual=astr(actual)))
            # Code alias mapping is by the canonical binding, but its emitted
            # offset remains the compiler's offset. Thus drift cannot be hidden.
            key=want if want else actual
            providers.setdefault(key,[]).append((spec['name'],public['segment'],public['offset'],public['name'],public['group']))
        for storage in ('data','bss'):
            if storage not in spec:continue
            seg=next((s for s in m.segments if s.name==('_DATA'if storage=='data'else'_BSS')),None)
            if seg is not None:layout.append(dict(module=spec['name'],storage=storage,address=spec[storage],size=seg.size))
    # Add typed aggregate ranges. Addressed fields are linked within those C objects.
    ranges=[]
    for a in agg:
        if a['module']not in objects:continue
        path,m,spec=objects[a['module']]
        p=next((p for p in m.publics if p['name']==a['anchor']),None)
        if p is None:raise ValueError('C aggregate not found: '+a['anchor'])
        ranges.append((a,p))
    existing={p['name']for _,m,_ in objects.values()for p in m.publics}
    additions={name:[]for name in objects}
    resolution={}
    for name,target in originals.items():
        if name in existing:continue
        exact=providers.get(target,[])
        if exact:
            module,segment,offset,anchor,group=exact[0]
            additions[module].append((name,segment,offset,group,anchor,0))
            resolution[name]=dict(module=module,anchor=anchor,offset=0,address=astr(target))
            continue
        if target[0]==0x1679:
            candidates=[(a,p)for a,p in ranges if addr(a['address'])[1]<=target[1]<addr(a['address'])[1]+a['size']]
            if candidates:
                a,p=min(candidates,key=lambda x:x[0]['size'])
                delta=target[1]-addr(a['address'])[1]
                additions[a['module']].append((name,p['segment'],p['offset']+delta,p['group'],a['anchor'],delta))
                resolution[name]=dict(module=a['module'],anchor=a['anchor'],offset=delta,address=astr(target))
    output=output_dir;output.mkdir(parents=True,exist_ok=True)
    reports=[]
    for name,(path,m,spec)in objects.items():
        added=additions[name];grouped={}
        for symbol,segment,offset,group,anchor,delta in added:
            grouped.setdefault((group or 0,segment),[]).append((symbol,offset))
        new_records=b''.join(rec for(group,segment),items in grouped.items()
                             for rec in pubdefs(group,segment,items))
        raw=path.read_bytes();out=bytearray();inserted=False
        original_payload=[];new_payload=[]
        for kind,rec in records(raw):
            if kind in (0x8a,0x8b)and not inserted:out+=new_records;inserted=True
            out+=rec
            if kind in (0xa0,0xa1,0xa2,0xa3,0x9c,0x9d,0x98,0x99):original_payload.append(rec)
        if not inserted:raise ValueError('MODEND not found')
        for kind,rec in records(out):
            if kind in (0xa0,0xa1,0xa2,0xa3,0x9c,0x9d,0x98,0x99):new_payload.append(rec)
        assert original_payload==new_payload
        dest=output/path.name;dest.write_bytes(out)
        reports.append(dict(module=name,input=str(path.relative_to(HERE)),output=str(dest.relative_to(HERE)),
            aliases=len(added),code_data_fixups_unchanged=True,input_sha256=hashlib.sha256(raw).hexdigest(),output_sha256=hashlib.sha256(out).hexdigest()))
    supplied=existing|set(resolution)
    crt=set()
    for p in(runtime/'OBJ').glob('*.OBJ'):
        for m in omf.parse_omf(p):crt.update(s['name']for s in m.publics)
    missing=[]
    for name,(path,m,spec)in objects.items():
        for e in m.externals:
            s=e['name']
            if s not in supplied and s not in crt:
                missing.append(dict(module=name,symbol=s,address=astr(originals[s])if s in originals else None))
    all_bindings={'externals':{n:astr(a)for n,a in originals.items()},'groups':{'DGROUP':'1679:0000'}}
    (report_dir/'bindings.json').write_text(json.dumps(all_bindings,indent=2)+'\n')
    result=dict(objects=reports,aliases=resolution,public_layout_mismatches=problems,missing_externals=missing,storage_layout=layout,
        code_data_fixups_unchanged=True,uses_original_executable_as_build_input=False)
    (report_dir/'aliases.json').write_text(json.dumps(result,indent=2)+'\n')
    return result
if __name__=='__main__':
    r=run();print(json.dumps(dict(objects=len(r['objects']),aliases=len(r['aliases']),public_drift=len(r['public_layout_mismatches']),missing=r['missing_externals']),indent=2))
