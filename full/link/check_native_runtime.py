#!/usr/bin/env python3
"""Check the actual TLINK runtime witness, including data and relocation order."""
import argparse
import hashlib
import json
import struct
from pathlib import Path
import verify_object as vo


def relocation_pairs(path):
    raw=Path(path).read_bytes();n=struct.unpack_from('<H',raw,6)[0];p=struct.unpack_from('<H',raw,0x18)[0]
    return [vo.Address(seg,off)for off,seg in (struct.unpack_from('<HH',raw,p+4*i)for i in range(n))]


def main():
    p=argparse.ArgumentParser(description=__doc__)
    p.add_argument('--runtime',type=Path,default=vo.ROOT/'full/link/runtime')
    p.add_argument('--original',type=Path,default=vo.ROOT/'original/SNAKE.EXE')
    a=p.parse_args();layout=json.loads((a.runtime/'layout.json').read_text())
    compiled=a.runtime/'PROBE.EXE';native,nh,nrels=vo.omf.read_mz(compiled);original,oh,orels=vo.omf.read_mz(a.original)
    native_ds=struct.unpack_from('<H',native,1)[0];target_ds=layout['dgroup_segment']
    rebased=bytearray(native);changes=[]
    for pos in nrels:
        word=struct.unpack_from('<H',native,pos)[0]
        if word==native_ds:
            struct.pack_into('<H',rebased,pos,target_ds)
            changes.append(dict(native_image_offset=pos,old_segment=word,new_segment=target_ds))
    spans=[];target_intervals=[]
    for row in layout['inputs']:
        path=a.runtime/'OBJ'/row['object'];module=vo.omf.parse_omf(path)[0]
        for segment in module.segments:
            if not segment.size or segment.class_name in ('BSS','BSSEND','STACK'):continue
            binding=vo.address(row['segments'][str(segment.index)])
            if segment.class_name=='CODE':native_start=binding.linear
            elif binding.segment==target_ds:native_start=native_ds*16+binding.offset
            else:continue
            wanted=original[binding.linear:binding.linear+segment.size]
            got=bytes(rebased[native_start:native_start+segment.size])
            diff=[i for i in range(min(len(got),len(wanted)))if got[i]!=wanted[i]]
            equal=got==wanted
            spans.append(dict(module=row['module'],segment=segment.name,size=segment.size,
                original_image_start=binding.linear,native_image_start=native_start,
                exact_after_declared_dgroup_relocation=equal,mismatch_offsets=diff,
                sha256=hashlib.sha256(got).hexdigest()))
            target_intervals.append((binding.linear,binding.linear+segment.size))
    opairs=[r for r in relocation_pairs(a.original)if any(x<=r.linear<y for x,y in target_intervals)]
    npairs=[vo.Address(target_ds if r.segment==native_ds else r.segment,r.offset)for r in relocation_pairs(compiled)]
    potential=0
    for path in [*(a.runtime/'OBJ').glob('*.OBJ'),a.runtime/'PROBE.OBJ']:
        for module in vo.omf.parse_omf(path):
            for segment in module.segments:
                potential+=sum(f['location_type']in (2,3)for f in segment.fixups)
    predicted_header=(62+4*potential+511)//512*512
    report=dict(scope='Native TLINK witness of the complete original CRT and all its initialized data; data spans reserved for game are NOT reconstructed by this witness.',
        native_exe_sha256=hashlib.sha256(compiled.read_bytes()).hexdigest(),
        native_dgroup=native_ds,original_dgroup=target_ds,explicit_segment_relocations=changes,
        code_bytes=sum(s['size']for s in spans if s['segment']=='_TEXT'),
        initialized_runtime_data_bytes=sum(s['size']for s in spans if s['segment']!='_TEXT'),
        spans=spans,all_runtime_bytes_exact=all(s['exact_after_declared_dgroup_relocation']for s in spans),
        original_runtime_relocations=[x.as_dict()for x in opairs],
        native_relocations_at_original_dgroup=[x.as_dict()for x in npairs],
        relocation_order_and_representation_equal=opairs==npairs,
        pre_relaxation_segment_fixups=potential,actual_mz_relocations=len(nrels),
        predicted_header_size=predicted_header,actual_header_size=nh,
        header_reservation_prediction_exact=predicted_header==nh,
        proves_full_game=False)
    report['passed']=report['all_runtime_bytes_exact']and report['relocation_order_and_representation_equal']and report['header_reservation_prediction_exact']
    (a.runtime/'native_verification.json').write_text(json.dumps(report,indent=2)+'\n')
    print(json.dumps({k:report[k]for k in ('passed','code_bytes','initialized_runtime_data_bytes',
        'pre_relaxation_segment_fixups','actual_mz_relocations','actual_header_size',
        'relocation_order_and_representation_equal')},indent=2))
    if not report['passed']:
        print([s for s in spans if not s['exact_after_declared_dgroup_relocation']]);raise SystemExit(1)


if __name__=='__main__':main()
