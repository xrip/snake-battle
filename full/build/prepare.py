#!/usr/bin/env python3
"""Stage recovered C with typed shared storage; never reads original EXE.

Original per-module sources remain unchanged. This staging step adds recovered
ordinary C definitions from globals/*.inc, whose fields and sizes are documented
in globals/manifest.json. All code still comes from the original C compilers.
"""
import hashlib,json,re,shutil
from pathlib import Path
HERE=Path(__file__).resolve().parent
FULL=HERE.parent

def prepare():
    modules=json.loads((HERE/'modules.json').read_text())
    aggregates=json.loads((HERE/'globals/manifest.json').read_text())
    output=HERE/'src';output.mkdir(exist_ok=True)
    hashes={};staged=[]
    for folder in ('ui','game','render','formats','graphics','low','gpf','hardware','sound'):
        for path in (FULL/folder).glob('*'):
            if path.suffix.lower()=='.h':
                target=output/path.name.upper();shutil.copyfile(path,target)
                hashes[str(path.relative_to(FULL))]=hashlib.sha256(path.read_bytes()).hexdigest()
    for module in modules:
        if module.get('pending'):continue
        path=FULL/module['source']
        if not path.exists():raise FileNotFoundError(path)
        source=path.read_text()
        hashes[module['source']]=hashlib.sha256(path.read_bytes()).hexdigest()
        own=[x for x in aggregates if x['module']==module['name'] and 'include'in x]
        def includes(section):
            return '\n'.join((HERE/'globals'/x['include']).read_text() for x in own if x['section']==section)
        if path.suffix.lower()=='.c':
            prefix=includes('prefix')+'\n'+includes('state')
            matches=list(re.finditer(r'^\s*#include[^\n]*\n',source,re.M))
            position=matches[-1].end() if matches else 0
            source=source[:position]+'\n'+prefix+'\n'+source[position:]
            source=includes('before_all')+'\n'+source+'\n'+includes('suffix')
        target=output/path.name.upper();target.write_text(source)
        staged.append(dict(name=module['name'],source=str(target.relative_to(HERE)),
                           sha256=hashlib.sha256(target.read_bytes()).hexdigest(),compiler=module['compiler']))
    result=dict(source_hashes=hashes,staged=staged,uses_original_executable_as_input=False,
                missing_modules=[m for m in modules if m.get('pending')])
    (HERE/'prepare.json').write_text(json.dumps(result,indent=2)+'\n')
    return result
if __name__=='__main__':
    result=prepare();print(json.dumps(dict(staged=len(result['staged']),missing=[m['name']for m in result['missing_modules']]),indent=2))
