#!/usr/bin/env python3
"""Compile/diff results for recovered file modules, using actual OMF fixups."""
import argparse
import json
import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
sys.path.insert(0, str(HERE.parent / 'link'))
import verify_object

def check(build):
    bindings = verify_object.load_bindings(HERE/'bindings.json', ROOT/'analysis/crt_symbols.json')
    module_segments = json.loads((HERE/'bindings.json').read_text()).get('module_segments', {})
    reports = []
    for path in sorted(Path(build).glob('*.OBJ')):
        modules = verify_object.omf.parse_omf(path)
        for module in modules:
            module_bindings = dict(bindings)
            module_bindings['segments'] = dict(bindings['segments'])
            module_bindings['segments'].update(module_segments.get(module.name.lower(), {}))
            for symbol in module.publics:
                target = bindings['functions'].get(symbol['name'])
                if not target or not isinstance(target, dict) or 'length' not in target:
                    continue
                reports.append(verify_object.verify_function(path, ROOT/'original/SNAKE.EXE',
                    symbol['name'], target, module_bindings, target['length'], module.name))
    output = Path(build)/'match.json'
    output.write_text(json.dumps(reports, indent=2)+'\n')
    for report in reports:
        print(report['function'], report['compiled_size'], report['original_size'],
              'MATCH' if report['passed'] else 'DIFF',
              len(report['mismatches']), report['unresolved'])
    print('Matched', sum(r['passed'] for r in reports), '/',len(reports),
          'functions;',sum(r['compiled_size'] for r in reports if r['passed']), 'bytes')
    return all(r['passed'] for r in reports)

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('build', type=Path)
    args = parser.parse_args()
    raise SystemExit(0 if check(args.build) else 1)
