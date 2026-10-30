#!/usr/bin/env python3
"""Audit a native link's complete layout and explain differences outside SOUND.

This verifier only reads executables. It never emits a modified executable.
Address differences are accepted only at a real MZ/OMF fixup and only when
the actual native MAP proves the destination's changed address.
"""
import argparse
from collections import Counter
import hashlib
import json
from pathlib import Path
import re
import struct
import sys

HERE = Path(__file__).resolve().parent
ROOT = HERE.parent.parent
sys.path.insert(0, str(ROOT/'tools'))
import omf
import aliases
import compare


def address(text):
    segment, offset = [int(x, 16) for x in text.split(':')]
    return segment, offset


def linear(pair):
    return 16*pair[0]+pair[1]


def mapfile(path):
    segments, publics = {}, {}
    contributions = []
    for line in path.read_text(errors='replace').splitlines():
        m = re.match(r'^\s+([0-9A-F]+)H\s+([0-9A-F]+)H\s+([0-9A-F]+)H\s+(\S+)\s+(\S+)\s*$', line)
        if m:
            start, stop, size = [int(m[i], 16) for i in (1, 2, 3)]
            segments[m[4]] = dict(start=start, end=start+size, size=size, class_name=m[5])
        m = re.match(r'^\s+([0-9A-F]+:[0-9A-F]+)\s+(?:idle\s+)?([A-Za-z_$][\w$@]*)\s*$', line)
        if m:
            value = address(m[1]); key = m[2].upper()
            if key in publics and publics[key] != value:
                raise ValueError('Inconsistent public MAP: '+key)
            publics[key] = value
        m = re.match(r'^\s+([0-9A-F]+:[0-9A-F]+)\s+([0-9A-F]+)\s+C=(\S+)\s+S=(\S+)\s+G=(\S+)\s+M=(\S+)\s+ACBP=([0-9A-F]+)', line)
        if m:
            contributions.append(dict(address=m[1], image_start=linear(address(m[1])),
                size=int(m[2],16), class_name=m[3], segment=m[4], group=m[5],
                module=m[6], acbp=int(m[7],16)))
    return segments, publics, contributions


def audit(built, reference, native_map, output):
    built, reference, native_map, output = [Path(x).resolve() for x in (built, reference, native_map, output)]
    output.mkdir(parents=True, exist_ok=True)
    original, actual = compare.describe(reference), compare.describe(built)
    old = original['raw'][original['header_size']:]
    new = actual['raw'][actual['header_size']:]
    segments, publics, contributions = mapfile(native_map)
    original_symbols = aliases.bindings()
    old_ds = 0x1679
    new_ds = segments['_DATA']['start']//16
    data_delta = (new_ds-old_ds)*16
    sound_old_start, sound_old_code_end, sound_old_end = 0x1341c, 0x16781, 0x16790
    sound = segments['SOUND_TEXT']
    def built_position(p):
        return p+data_delta if p >= old_ds*16 else p
    evidence = []
    allowed = {}
    def word_rule(p, old_value, new_value, kind, **extra):
        q = built_position(p)
        actual_old = struct.unpack_from('<H', old, p)[0]
        actual_new = struct.unpack_from('<H', new, q)[0]
        if (actual_old, actual_new) != (old_value, new_value):
            raise ValueError('Fixup rule disagrees with native bytes at %05X: '%p+
                             repr((actual_old,actual_new,old_value,new_value)))
        row = dict(kind=kind, original_image_offset=p, built_image_offset=q,
                   original_word=old_value, built_word=new_value, **extra)
        evidence.append(row)
        for i in range(2):
            if old[p+i] != new[q+i]:
                if p+i in allowed and allowed[p+i] != kind:
                    raise ValueError('Conflicting difference classifications')
                allowed[p+i] = kind
    # MZ relocation sites are an independently stored list of segment words.
    # A target change is classified only if the original target was DGROUP.
    for index, (offset, segment) in enumerate(original['relocations']):
        p = segment*16+offset
        if sound_old_start <= p < sound_old_end:
            continue
        value = struct.unpack_from('<H', old, p)[0]
        if value == old_ds:
            word_rule(p, old_ds, new_ds, 'DGROUP segment relocation', relocation_index=index)
        elif value == 0x1341:
            target_offset = struct.unpack_from('<H', old, p-2)[0]
            matches = [(n, publics[n.upper()]) for n, a in original_symbols.items()
                       if a == (0x1341, target_offset) and n.upper() in publics]
            targets = {a for _, a in matches}
            if len(targets) != 1:
                raise ValueError('No unique native SOUND symbol for far pointer %04X'%target_offset)
            target = targets.pop()
            word_rule(p-2, target_offset, target[1], 'SOUND far code pointer',
                      symbols=[n for n,_ in matches], relocation_index=index)
            word_rule(p, 0x1341, target[0], 'SOUND far code segment',
                      symbols=[n for n,_ in matches], relocation_index=index)
    # Near dispatch tables have no DOS loader relocation. The actual BCC OMF
    # records prove which words are addresses, so no broad data mask is used.
    data_object = omf.parse_omf(HERE/'obj/SNDATA.OBJ')[0]
    data_segment = next(s for s in data_object.segments if s.name == '_DATA')
    for fixup in data_segment.fixups:
        if fixup['target']['method_name'] != 'external' or fixup['width'] != 2:
            raise ValueError('Unexpected SNDATA fixup shape')
        name = fixup['target']['name']
        old_target, new_target = original_symbols[name], publics[name.upper()]
        if old_target[0] != 0x1341 or new_target[0] != 0x1341:
            raise ValueError('Dispatch table target is outside SOUND')
        word_rule(old_ds*16+0xf08+fixup['offset'], old_target[1], new_target[1],
                  'SOUND near dispatch pointer', symbol=name,
                  omf_record_offset=fixup['record_offset'],
                  omf_subrecord_offset=fixup['subrecord_offset'])
    unmatched = []
    unchanged = 0
    classified = Counter()
    for p in list(range(sound_old_start))+list(range(sound_old_end,len(old))):
        q = built_position(p)
        if old[p] == new[q]:
            unchanged += 1
        elif p in allowed:
            classified[allowed[p]] += 1
        else:
            unmatched.append(dict(original_image_offset=p,built_image_offset=q,
                                  original_byte=old[p],built_byte=new[q]))
    def span(name, kind, start, size, expected_built=None):
        q = built_position(start) if expected_built is None else expected_built
        unknown = [r for r in unmatched if start <= r['original_image_offset'] < start+size]
        different = sum(old[start+i] != new[q+i] for i in range(size))
        return dict(name=name, kind=kind, original_image_start=start, original_image_end=start+size,
                    built_image_start=q, built_image_end=q+size, size=size,
                    raw_byte_exact=different==0, differing_bytes=different,
                    only_proven_address_fixups_differ=not unknown,
                    unexplained_difference_count=len(unknown))
    specs = json.loads((HERE/'modules.json').read_text())
    game = []
    for spec in specs:
        if spec['name'] == 'SOUND':
            continue
        if 'code' in spec:
            game.append(span(spec['name'],'CODE',linear(address(spec['code'])),spec['size']))
        if spec.get('data_size',0):
            game.append(span(spec['name'],'DATA',linear(address(spec['data'])),spec['data_size']))
    crt_witness = json.loads((ROOT/'full/link/runtime/native_verification.json').read_text())
    crt = [span(s['module'],s['segment'],s['original_image_start'],s['size']) for s in crt_witness['spans']]
    layout_errors = []
    bss_layout = []
    for spec in specs:
        if spec.get('code') and spec['name'] != 'SOUND':
            name = spec['name']+'_TEXT'
            expected = linear(address(spec['code']))
            actual_span = segments[name]
            if (actual_span['start'],actual_span['size']) != (expected,spec['size']):
                layout_errors.append(dict(name=name,expected_start=expected,expected_size=spec['size'],actual=actual_span))
        if spec.get('bss_size',0):
            filename = Path(spec['source']).name.upper()
            candidates = [c for c in contributions if c['segment']=='_BSS' and
                          c['module'].upper()==filename and c['size']==spec['bss_size']]
            expected = address(spec['bss'])[1]
            good = len(candidates)==1 and candidates[0]['image_start']-new_ds*16==expected
            bss_layout.append(dict(module=spec['name'],dgroup_start=expected,
                                   dgroup_end=expected+spec['bss_size'],size=spec['bss_size'],
                                   native_map_matches=good))
            if not good:
                layout_errors.append(dict(module=spec['name'],expected_bss=spec['bss'],candidates=candidates))
    runtime_layout = json.loads((ROOT/'full/link/runtime/layout.json').read_text())
    shared = []
    for row in runtime_layout['shared_segments']:
        name = row['name']; observed = segments[name]
        actual_offset = observed['start']-new_ds*16
        matches = (actual_offset,observed['size']) == (row['dgroup_start'],row['size'])
        shared.append(dict(name=name, original_dgroup_start=row['dgroup_start'],
                           actual_dgroup_start=actual_offset,size=observed['size'],layout_exact=matches))
        if not matches:
            layout_errors.append(dict(name=name,expected=row,actual=observed))
    relocations = []
    for i, (a, b) in enumerate(zip(original['relocations'], actual['relocations'])):
        if a != b:
            relocations.append(dict(index=i, original=list(a), built=list(b),
                original_image_site=a[1]*16+a[0],built_image_site=b[1]*16+b[0],
                kind='relocated DATA site' if a[1]*16+a[0]>=old_ds*16 else 'SOUND code site'))
    whole = compare.compare(built, reference)
    report = dict(scope='Native executable audit; no executable is patched or normalized on disk',
        original_sha256=original['sha256'],built_sha256=actual['sha256'],
        original_size=original['size'],built_size=actual['size'],
        complete_executable_byte_exact=whole['file_byte_exact'],
        original_dgroup=old_ds,built_dgroup=new_ds,data_image_shift=data_delta,
        sound_original_start=sound_old_start,sound_original_end=sound_old_code_end,
        sound_original_area_end=sound_old_end,
        sound_built_start=sound['start'],sound_built_end=sound['end'],
        sound_original_size=sound_old_code_end-sound_old_start,sound_built_size=sound['size'],
        sound_original_area_size=sound_old_end-sound_old_start,
        sound_original_trailing_alignment_bytes=sound_old_end-sound_old_code_end,
        sound_trailing_alignment_bytes=new_ds*16-sound['end'],
        outside_sound_bytes_compared=len(old)-(sound_old_end-sound_old_start),
        outside_sound_raw_equal_bytes=unchanged,outside_sound_classified_difference_bytes=dict(classified),
        outside_sound_unexplained_differences=unmatched,
        outside_sound_verified_except_proven_link_addresses=not unmatched and not layout_errors,
        address_rules=evidence,game_contributions=game,crt_contributions=crt,
        native_map_contributions=contributions,layout_errors=layout_errors,shared_dgroup_layout=shared,
        game_bss_layout=bss_layout,
        original_relocation_count=len(original['relocations']),built_relocation_count=len(actual['relocations']),
        relocation_order_entries_equal=sum(a==b for a,b in zip(original['relocations'],actual['relocations'])),
        changed_relocation_entries=relocations,
        mz_field_differences=whole['mz_field_differences'],
        header_bytes_1c_to_3e_equal=original['raw'][0x1c:0x3e]==actual['raw'][0x1c:0x3e],
        header_padding_equal=original['raw'][0x3e+4*879:0x1000]==actual['raw'][0x3e+4*879:0x1000],
        modifies_executables=False)
    (output/'layout_evidence.json').write_text(json.dumps(report,indent=2)+'\n')
    write_markdown(report, output/'LAYOUT_EVIDENCE.md')
    return report


def write_markdown(r, path):
    lines = ['# Аудит полной диагностической сборки', '',
        '**Это ещё не byte-exact EXE.** Проверка сравнивает действительно собранный TLINK файл с оригиналом; '+
        'она не меняет ни один исполняемый файл.', '',
        f"Оригинал: {r['original_size']} байт, SHA-256 `{r['original_sha256']}`.  ",
        f"Сборка: {r['built_size']} байт, SHA-256 `{r['built_sha256']}`.", '',
        '## Остаток различий', '',
        f"Код SOUND занимает {r['sound_built_size']} байт вместо {r['sound_original_size']}. "+
        f"После него линкер добавил {r['sound_trailing_alignment_bytes']} байт выравнивания "+
        f"вместо исходных {r['sound_original_trailing_alignment_bytes']}. "+
        f"Поэтому DGROUP переместилась с `{r['original_dgroup']:04X}:0000` на `{r['built_dgroup']:04X}:0000` "+
        f"на {r['data_image_shift']} байт; размер и все внутренние смещения DATA/BSS/STACK сохранены.", '',
        f"Вне области SOUND вместе с её завершающим выравниванием сопоставлены все "+
        f"{r['outside_sound_bytes_compared']} байт загружаемого образа: "+
        f"{r['outside_sound_raw_equal_bytes']} совпадают непосредственно. "+
        f"Необъяснённых отличий: {len(r['outside_sound_unexplained_differences'])}. "+
        'Остальные отличия проверены по конкретным MZ/OMF fixup и реально полученным адресам из MAP:', '']
    for name, count in r['outside_sound_classified_difference_bytes'].items():
        lines.append(f'- {name}: {count} отличающихся байт.')
    lines += ['', 'Это сопоставление адресов служит только доказательством причины отличий. '+
              'Оно не превращает несовпадающий файл в точную сборку и не применяется к его байтам.', '',
              '## Заголовок MZ', '',
              f"В обоих файлах {r['original_relocation_count']} релокаций и заголовок 4096 байт. "+
              f"{r['relocation_order_entries_equal']} записей совпадают вместе с позицией в таблице; "+
              f"изменились {len(r['changed_relocation_entries'])} записей. "+
              'Точная таблица приведена в JSON. Байты 0x1C..0x3D и всё заполнение после таблицы совпадают.', '',
              '| Поле | Оригинал | Сборка |', '|---|---:|---:|']
    for x in r['mz_field_differences']:
        lines.append(f"| {x['field']} | {x['reference']} | {x['built']} |")
    lines += ['', '## Прикладные CODE и DATA', '',
        'Границы указаны относительно загружаемого образа, конец не включён; file offset равен image offset + 0x1000. '+
        '«Адреса» означает, что отличаются только перечисленные выше проверенные fixup.', '',
        '| Модуль | Раздел | Оригинал | Сборка | Байт | Сравнение |',
        '|---|---|---|---|---:|---|']
    for x in r['game_contributions']:
        state='точно' if x['raw_byte_exact'] else 'только адреса' if x['only_proven_address_fixups_differ'] else 'ЕСТЬ ОТЛИЧИЯ'
        lines.append(f"| {x['name']} | {x['kind']} | {x['original_image_start']:05X}..{x['original_image_end']:05X} | "+
                     f"{x['built_image_start']:05X}..{x['built_image_end']:05X} | {x['size']} | {state} |")
    lines += ['', '## Каждый вклад исходной CRT', '',
        '| Объект | Раздел | Оригинал | Сборка | Байт | Сравнение |',
        '|---|---|---|---|---:|---|']
    for x in r['crt_contributions']:
        state='точно' if x['raw_byte_exact'] else 'только адреса' if x['only_proven_address_fixups_differ'] else 'ЕСТЬ ОТЛИЧИЯ'
        lines.append(f"| {x['name']} | {x['kind']} | {x['original_image_start']:05X}..{x['original_image_end']:05X} | "+
                     f"{x['built_image_start']:05X}..{x['built_image_end']:05X} | {x['size']} | {state} |")
    lines += ['', '## Воспроизведение проверки', '',
        '```sh', 'python full/build/audit_layout.py full/build/diagnostic/SNAKE.EXE '+
        '--map full/build/diagnostic/SNAKE.MAP --output full/build/diagnostic', '```', '',
        'JSON сохраняет все границы, реальные вкладки MAP, каждое адресное правило и каждое необъяснённое отличие. '+
        'Конечное условие задачи остаётся полным равенством файла, включая SOUND и MZ.', '']
    path.write_text('\n'.join(lines))


if __name__ == '__main__':
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument('built',type=Path)
    p.add_argument('--reference',type=Path,default=ROOT/'original/SNAKE.EXE')
    p.add_argument('--map',type=Path,required=True)
    p.add_argument('--output',type=Path,default=HERE/'diagnostic')
    a = p.parse_args(); r = audit(a.built,a.reference,a.map,a.output)
    print(json.dumps({k:r[k] for k in ('complete_executable_byte_exact','outside_sound_bytes_compared',
        'outside_sound_raw_equal_bytes','outside_sound_classified_difference_bytes',
        'outside_sound_verified_except_proven_link_addresses','layout_errors')},indent=2))
    raise SystemExit(0 if r['outside_sound_verified_except_proven_link_addresses'] else 1)
