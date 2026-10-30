#!/usr/bin/env python3
"""Verify complete integrated compiler contributions against the reference.

The reference EXE is used only by this verifier.  It is never a build input.
External modules may still be absent; this report distinguishes contribution
proof from a successful native link or a byte-exact complete executable.
"""
import argparse
import json
import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
FULL = HERE.parent
ROOT = FULL.parent
sys.path.insert(0, str(FULL / 'link'))
import verify_module as vm
import verify_object as vo


def verify(reference=None):
    reference = Path(reference or ROOT / 'original/SNAKE.EXE')
    specs = json.loads((HERE / 'modules.json').read_text())
    common = vo.load_bindings(HERE / 'bindings.json', ROOT / 'analysis/crt_symbols.json')
    output = HERE / 'proof'
    output.mkdir(exist_ok=True)
    reports, missing = [], []
    for spec in specs:
        path = HERE / 'linkobj' / (spec['name'] + '.OBJ')
        if spec.get('pending') or not path.exists():
            missing.append(spec['name'])
            continue
        module = vo.omf.parse_omf(path)[0]
        bind = {key: dict(value) for key, value in common.items()}
        for seg in module.segments:
            kind = ('code' if seg.class_name == 'CODE' else
                    'data' if seg.name == '_DATA' else
                    'bss' if seg.name == '_BSS' else None)
            if kind in spec:
                bind['segments'][str(seg.index)] = spec[kind]
        own = []
        for seg in module.segments:
            kind = ('code' if seg.class_name == 'CODE' else
                    'data' if seg.name == '_DATA' else
                    'bss' if seg.name == '_BSS' else None)
            if kind is None or not seg.size:
                continue
            expected = spec['size'] if kind == 'code' else spec[kind + '_size']
            if kind not in spec:
                raise ValueError(f'{spec["name"]} {kind} has no recovered origin')
            if kind != 'bss':
                result = vm.verify_segment(path, reference, seg.index, spec[kind],
                                           bind, expected, module.name)
            else:
                origin = vo.address(spec[kind])
                publics = []
                named = dict(bind['externals']); named.update(bind['functions'])
                for p in module.publics:
                    if p['segment'] != seg.index or p['name'] not in named:
                        continue
                    actual = origin.plus(p['offset'])
                    target = vo.address(named[p['name']])
                    publics.append(dict(name=p['name'], object_offset=p['offset'],
                                        actual=actual.as_dict(), expected=target.as_dict(),
                                        equal=actual == target))
                result = dict(module=module.name, segment_name=seg.name,
                              object_size=seg.size, expected_size=expected,
                              initialized_bytes=sum(seg.initialized),
                              target=origin.as_dict(), public_bindings=publics,
                              public_layout_exact=all(p['equal'] for p in publics),
                              note='BSS contributes allocation only; no bytes are present in the EXE.')
                result['passed'] = (seg.size == expected and not any(seg.initialized)
                                    and result['public_layout_exact'])
            result['storage'] = kind
            report_path = output / (spec['name'].lower() + '_' + kind + '.json')
            report_path.write_text(json.dumps(result, indent=2) + '\n')
            own.append(dict(storage=kind, passed=result['passed'],
                            size=seg.size, expected_size=expected,
                            byte_differences=len(result.get('mismatches', [])),
                            unresolved=result.get('unresolved', []),
                            report=str(report_path.relative_to(HERE))))
        reports.append(dict(module=spec['name'], contributions=own,
                            passed=all(x['passed'] for x in own)))
    result = dict(modules=reports, missing_modules=missing,
                  proven_modules=sum(m['passed'] for m in reports),
                  available_modules=len(reports),
                  proven_code_bytes=sum(c['size'] for m in reports for c in m['contributions']
                                        if c['passed'] and c['storage'] == 'code'),
                  proven_data_bytes=sum(c['size'] for m in reports for c in m['contributions']
                                        if c['passed'] and c['storage'] == 'data'),
                  proven_bss_bytes=sum(c['size'] for m in reports for c in m['contributions']
                                       if c['passed'] and c['storage'] == 'bss'),
                  all_available_contributions_exact=all(m['passed'] for m in reports),
                  all_modules_present=not missing,
                  complete_executable_proven=False,
                  reference_used_only_for_verification=True)
    (HERE / 'verification.json').write_text(json.dumps(result, indent=2) + '\n')
    return result


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--reference', type=Path)
    args = parser.parse_args()
    result = verify(args.reference)
    print(json.dumps(result, indent=2))
    raise SystemExit(0 if result['all_available_contributions_exact'] else 1)
