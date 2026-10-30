#!/usr/bin/env python3
"""Compare an actually linked EXE with the reference, without writing either.

This verification is deliberately separate from compilation and linking.
It checks the complete file, including MZ header, relocation order and padding.
"""
import argparse
import hashlib
import json
import struct
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = HERE.parent.parent
MZ_FIELDS = ('signature', 'last_page_bytes', 'pages', 'relocations',
             'header_paragraphs', 'minimum_extra_paragraphs',
             'maximum_extra_paragraphs', 'initial_ss', 'initial_sp',
             'checksum', 'initial_ip', 'initial_cs',
             'relocation_table_offset', 'overlay_number')


def spans(a, b):
    result, start = [], None
    for i in range(max(len(a), len(b))):
        unequal = i >= len(a) or i >= len(b) or a[i] != b[i]
        if unequal and start is None:
            start = i
        if not unequal and start is not None:
            result.append(dict(start=start, end=i, length=i-start)); start = None
    if start is not None:
        result.append(dict(start=start, end=max(len(a),len(b)),
                           length=max(len(a),len(b))-start))
    return result


def describe(path):
    raw = path.read_bytes()
    if len(raw) < 28 or raw[:2] != b'MZ':
        raise ValueError(str(path) + ' is not a complete DOS MZ executable')
    fields = dict(zip(MZ_FIELDS, struct.unpack_from('<14H', raw)))
    header_size = fields['header_paragraphs'] * 16
    offset, count = fields['relocation_table_offset'], fields['relocations']
    if offset + count*4 > header_size or header_size > len(raw):
        raise ValueError(str(path) + ' has an invalid MZ relocation/header extent')
    relocations = [struct.unpack_from('<HH', raw, offset + i*4) for i in range(count)]
    return dict(path=str(path), sha256=hashlib.sha256(raw).hexdigest(), size=len(raw),
                fields=fields, header_size=header_size, image_size=len(raw)-header_size,
                relocations=relocations, raw=raw)


def compare(built, reference):
    a, b = describe(Path(built)), describe(Path(reference))
    image_a, image_b = a['raw'][a['header_size']:], b['raw'][b['header_size']:]
    file_spans = spans(a['raw'], b['raw'])
    image_spans = spans(image_a, image_b)
    fields = [dict(field=name, built=a['fields'][name], reference=b['fields'][name])
              for name in MZ_FIELDS if a['fields'][name] != b['fields'][name]]
    first = file_spans[0]['start'] if file_spans else None
    result = dict(built={k:v for k,v in a.items() if k not in ('raw','relocations')},
                  reference={k:v for k,v in b.items() if k not in ('raw','relocations')},
                  complete_executable_proven=a['raw'] == b['raw'],
                  file_byte_exact=a['raw'] == b['raw'], image_byte_exact=image_a == image_b,
                  mz_header_exact=a['raw'][:a['header_size']] == b['raw'][:b['header_size']],
                  mz_field_differences=fields,
                  relocation_representation_and_order_exact=a['relocations'] == b['relocations'],
                  relocation_sites_equal=sorted(s*16+o for o,s in a['relocations']) ==
                                         sorted(s*16+o for o,s in b['relocations']),
                  differing_file_bytes=sum(s['length'] for s in file_spans),
                  differing_image_bytes=sum(s['length'] for s in image_spans),
                  first_differing_file_offset=first,
                  file_difference_spans=file_spans, image_difference_spans=image_spans,
                  modifies_executable=False)
    return result


if __name__ == '__main__':
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument('built', type=Path, nargs='?', default=HERE/'native/SNAKE.EXE')
    p.add_argument('--reference', type=Path, default=ROOT/'original/SNAKE.EXE')
    p.add_argument('-o', '--output', type=Path, default=HERE/'executable_comparison.json')
    a = p.parse_args()
    result = compare(a.built, a.reference)
    a.output.write_text(json.dumps(result, indent=2)+'\n')
    print(json.dumps({k:v for k,v in result.items()
                     if k not in ('file_difference_spans','image_difference_spans')}, indent=2))
    raise SystemExit(0 if result['complete_executable_proven'] else 1)
