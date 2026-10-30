#!/usr/bin/env python3
"""Compare all five CONTROL.ASM contributions after actual OMF fixup binding.

This is a separate, read-only reference check. The assembler build itself has
no dependency on SNAKE.EXE. A passing result establishes executable bytes and
layout, not the historical source language or compiler-matched C.
"""
import argparse
import json
from pathlib import Path
import sys

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[2]
sys.path.insert(0, str(ROOT/'full/link'))
import verify_object as vo
from verify_module import verify_segment


def verify(obj, exe, output):
    manifest = json.loads((HERE/'control_manifest.json').read_text())
    bindings = vo.load_bindings(HERE.parent/'bindings.json')
    bindings['groups']['CGROUP'] = '1341:0000'
    for item in manifest:
        bindings['segments'][item['segment']] = item['address']
    checks = []
    for item in manifest:
        result = verify_segment(obj, exe, item['segment'], item['address'],
                                bindings, item['length'], allow_relaxation=False)
        checks.append(result)
    report = dict(
        scope='Mnemonic executable specification, not compiler-matched C',
        expected_functions=sum(len(item['functions']) for item in manifest),
        expected_bytes=sum(item['length'] for item in manifest),
        instruction_bytes=3454, jump_table_words=37, jump_table_bytes=74,
        passed=all(item['passed'] for item in checks),
        complete_executable_proven=False,
        contributions=checks)
    Path(output).write_text(json.dumps(report, indent=2)+'\n')
    return report


if __name__ == '__main__':
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument('--object', type=Path, default=HERE/'control_build/CONTROL.OBJ')
    p.add_argument('--exe', type=Path, default=ROOT/'original/SNAKE.EXE')
    p.add_argument('--output', type=Path, default=HERE/'module_control.json')
    a = p.parse_args()
    report = verify(a.object, a.exe, a.output)
    print(json.dumps(dict(passed=report['passed'], expected_functions=report['expected_functions'],
        expected_bytes=report['expected_bytes'], contributions=[dict(
            segment=x['segment_name'], size=x['object_size'], expected=x['expected_size'],
            passed=x['passed'], differences=len(x['mismatches']), unresolved=x['unresolved'])
            for x in report['contributions']]), indent=2))
    raise SystemExit(0 if report['passed'] else 1)
