#!/usr/bin/env python3
"""Extract the selected original CRT members without opening a game EXE.

The recovered layout is an explicit input manifest. Its member names, offsets
and original compiler-library hashes are checked against the supplied Borland
distribution. OMF records are copied intact; code and fixups are never edited.
"""
import argparse
import hashlib
import json
from pathlib import Path
import sys

HERE = Path(__file__).resolve().parent
ROOT = HERE.parent.parent
sys.path.insert(0, str(ROOT/'tools'))
import omf


def compiler_file(root, relative):
    """Resolve DOS names on a case-sensitive host filesystem."""
    path = Path(root).resolve()
    for part in Path(relative).parts:
        matches = [p for p in path.iterdir() if p.name.upper() == part.upper()]
        if len(matches) != 1:
            raise FileNotFoundError(f'Expected one compiler input {relative}: {path}/{part}')
        path = matches[0]
    return path


def extract(compiler, output, layout_path=HERE/'runtime/layout.json'):
    compiler, output, layout_path = [Path(p).resolve() for p in (compiler, output, layout_path)]
    layout_bytes = layout_path.read_bytes()
    layout = json.loads(layout_bytes)
    library = compiler_file(compiler, 'LIB/CL.LIB')
    startup = compiler_file(compiler, 'LIB/C0L.OBJ')
    sources = {'CL.LIB': library.read_bytes(), 'C0L.OBJ': startup.read_bytes()}
    hashes = {n: hashlib.sha256(b).hexdigest() for n, b in sources.items()}
    for name, expected in (('CL.LIB', layout['library_sha256']),
                           ('C0L.OBJ', layout['startup_sha256'])):
        if hashes[name] != expected:
            raise ValueError(f'{name} differs from the recovered original Borland input: '
                             f'{hashes[name]} != {expected}')
    library_modules = {m.file_offset:m for m in omf.parse_omf(library)}
    startup_modules = omf.parse_omf(startup)
    if len(startup_modules) != 1:
        raise ValueError('C0L.OBJ must contain one OMF module')
    objects = output/'OBJ'
    objects.mkdir(parents=True, exist_ok=True)
    reports = []
    for index, entry in enumerate(layout['inputs']):
        source_name = 'C0L.OBJ' if index == 0 else 'CL.LIB'
        module = startup_modules[0] if index == 0 else library_modules[entry['library_offset']]
        if module.name != entry['module'] or module.file_offset != entry['library_offset']:
            raise ValueError('Library-member identity differs from the layout: '+repr(entry))
        filename = entry['object']
        if Path(filename).name != filename or len(Path(filename).stem) > 8:
            raise ValueError('Expected a simple DOS 8.3 object name: '+filename)
        data = sources[source_name][module.file_offset:module.end_offset]
        target = objects/filename
        target.write_bytes(data)
        reports.append(dict(object=filename,module=module.name,source=source_name,
            source_offset=module.file_offset,source_end=module.end_offset,size=len(data),
            sha256=hashlib.sha256(data).hexdigest(),omf_records_unchanged=True))
    if len(reports) != 1 + layout['runtime_module_count']:
        raise ValueError('CRT member count differs from the recovered layout')
    (output/'layout.json').write_bytes(layout_bytes)
    bindings = dict(externals=layout['symbols'], groups={'DGROUP':'1679:0000'})
    (output/'bindings.json').write_text(json.dumps(bindings,indent=2)+'\n')
    report = dict(compiler=str(compiler),layout_manifest=str(layout_path),
        layout_manifest_sha256=hashlib.sha256(layout_bytes).hexdigest(),
        original_library=str(library),library_sha256=hashes['CL.LIB'],
        original_startup=str(startup),startup_sha256=hashes['C0L.OBJ'],
        library_member_count=len(reports)-1,object_count=len(reports),objects=reports,
        reads_reference_executable=False,reads_previously_extracted_objects=False,
        modifies_omf_records=False)
    (output/'extraction.json').write_text(json.dumps(report,indent=2)+'\n')
    return report


if __name__ == '__main__':
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument('--compiler',type=Path,required=True)
    p.add_argument('--layout',type=Path,default=HERE/'runtime/layout.json')
    p.add_argument('--output',type=Path,required=True)
    a = p.parse_args()
    r = extract(a.compiler,a.output,a.layout)
    print(json.dumps({k:r[k] for k in ('library_member_count','object_count',
        'library_sha256','startup_sha256','reads_reference_executable',
        'reads_previously_extracted_objects')},indent=2))
