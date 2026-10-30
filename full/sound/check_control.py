#!/usr/bin/env python3
"""Compare all 53 reconstructed sound control/init C procedures independently.

Only the compiler's OMF fixups and declared symbol bindings are applied.
No prologue, register, padding or instruction normalization counts as exact.
The expected ranges are native function boundaries, not generated sizes.
"""
import argparse
import json
from pathlib import Path
import sys

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
sys.path.insert(0, str(ROOT/'full/link'))
import verify_object as vo

RANGES = [
    (0x000c,18),(0x001e,4),(0x0022,4),(0x0026,4),(0x002a,15),
    (0x0039,15),(0x0048,15),(0x0057,23),(0x00fe,90),(0x0158,79),
    (0x01a7,36),(0x01cb,10),(0x01d5,7),(0x01dc,59),(0x0217,5),
    (0x021c,77),(0x0269,50),(0x029b,28),(0x02b7,45),(0x02e4,290),
    (0x0406,144),(0x04b8,20),(0x04cc,13),(0x04d9,27),(0x04f4,73),
    (0x055e,22),(0x0574,50),(0x05a6,66),(0x05e8,91),(0x0643,40),
    (0x066b,216),(0x0743,27),(0x075e,49),(0x078f,27),(0x07aa,79),
    (0x07f9,27),(0x0814,67),(0x0857,413),(0x09f4,314),(0x0b2e,64),
    (0x0b6e,16),(0x0b7e,191),(0x0c3d,134),(0x0cc3,92),(0x0d1f,137),
    (0x0da8,17),(0x3283,44),(0x32af,32),(0x32cf,28),(0x32eb,24),
    (0x3303,44),(0x332f,51),(0x3362,15),
]


def check(obj, output):
    bindings = vo.load_bindings(HERE/'bindings.json')
    records = []
    for origin, length in RANGES:
        name = f'_snd_{origin:04X}'
        try:
            item = vo.verify_function(obj, ROOT/'original/SNAKE.EXE', name,
                                      f'1341:{origin:04X}', bindings, length)
        except (ValueError, vo.omf.OMFError) as error:
            item = dict(function=name, passed=False, unresolved=[str(error)])
        records.append(item)
    summary = dict(total_functions=len(records), expected_bytes=sum(n for _,n in RANGES),
                   exact_functions=sum(bool(r['passed']) for r in records),
                   exact_bytes=sum(r.get('original_size',0) for r in records if r['passed']),
                   all_functions_exact=all(r['passed'] for r in records),
                   complete_module_layout_proven=False,
                   complete_executable_proven=False)
    result = dict(summary=summary, functions=records)
    Path(output).write_text(json.dumps(result,indent=2)+'\n')
    return summary


if __name__ == '__main__':
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument('object', type=Path)
    p.add_argument('--output', type=Path, default=HERE/'control_verification.json')
    a = p.parse_args()
    result = check(a.object, a.output)
    print(json.dumps(result,indent=2))
    raise SystemExit(0 if result['all_functions_exact'] else 1)
