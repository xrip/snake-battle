#!/usr/bin/env python3
"""Check native Borland GPF output against the declared original entries."""
import json
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(ROOT / 'full/link'))
import verify_object as vo
import verify_module as vm

OBJECT = Path(sys.argv[1]) if len(sys.argv) > 1 else ROOT / 'full/gpf/build/GPF.OBJ'
BINDINGS = vo.load_bindings(ROOT / 'full/gpf/bindings.json', ROOT / 'analysis/crt_symbols.json')
LENGTHS = (76, 27, 136, 261, 212, 471, 85, 161, 66)
reports = []
for (name, target), length in zip(BINDINGS['functions'].items(), LENGTHS):
    if not name.startswith('_gpf_'):
        continue
    report = vo.verify_function(OBJECT, ROOT / 'original/SNAKE.EXE', name,
                                target, BINDINGS, length,
                                structural_internal_calls=True)
    reports.append(report)
    print(name, report['compiled_size'], length,
          'PASS' if report['passed'] else 'FAIL',
          'differences', len(report['mismatches']), report['mismatches'][:3],
          report['unresolved'])
result = {'functions': reports,
          'passed_functions': sum(r['passed'] for r in reports),
          'matched_bytes': sum(r['original_size'] for r in reports if r['passed'])}
(ROOT / 'full/gpf/verification.json').write_text(json.dumps(result, indent=2) + '\n')
module = vm.verify_segment(OBJECT, ROOT / 'original/SNAKE.EXE', 1, '11DB:0006',
                           BINDINGS, 1495)
(ROOT / 'full/gpf/module_code.json').write_text(json.dumps(module, indent=2) + '\n')
print('Complete contribution', module['passed'], 'length', module['object_size'],
      'public layout', module['public_layout_exact'])
data = vm.verify_segment(OBJECT, ROOT / 'original/SNAKE.EXE', 2, '1679:0F06',
                         BINDINGS, 2)
(ROOT / 'full/gpf/module_data.json').write_text(json.dumps(data, indent=2) + '\n')
mod = vo.omf.parse_omf(OBJECT)[0]
bss = mod.segments[2]
bss_origin = vo.address('1679:4104')
publics = [dict(name=p['name'], offset=p['offset'],
                address=bss_origin.plus(p['offset']).as_dict(),
                matches_binding=bss_origin.plus(p['offset']) ==
                                vo.address(BINDINGS['externals'][p['name']]))
           for p in mod.publics if p['segment'] == bss.index]
bss_report = dict(segment=bss.name, object_size=bss.size, expected_size=56,
                  initialized_bytes=sum(bss.initialized), publics=publics,
                  layout_exact=bss.size == 56 and all(p['matches_binding'] for p in publics),
                  note='BSS allocation/layout check only: uninitialized data has no bytes in the EXE.')
(ROOT / 'full/gpf/module_bss.json').write_text(json.dumps(bss_report, indent=2) + '\n')
asm_object = OBJECT.with_name('LZSS.OBJ')
if asm_object.exists():
    lzss = vm.verify_segment(asm_object, ROOT / 'original/SNAKE.EXE', 1, '1238:000D',
                            BINDINGS, 4238)
    (ROOT / 'full/gpf/module_lzss.json').write_text(json.dumps(lzss, indent=2) + '\n')
    print('ASM dictionary and decoder', lzss['passed'], 'length', lzss['object_size'])
