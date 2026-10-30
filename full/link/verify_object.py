#!/usr/bin/env python3
"""Apply actual OMF relocations at declared target addresses and compare a function.

This never takes replacement instruction bytes from the target EXE. All output
bytes originate in the OBJ plus explicit link addresses and TLINK transfer
relaxation. An unresolved relocation makes the comparison fail.

Bindings JSON sections: functions, externals, segments, groups. Address values
are SEG:OFF hexadecimal strings, or {segment, offset} integers. Segment keys may
be OMF names or one-based decimal indices. Optional functions entries may use
{address: '0729:1002', length: 86}. All files are read-only except the JSON report.
"""
from __future__ import annotations
import argparse
import hashlib
import json
import struct
import sys
from dataclasses import dataclass
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(ROOT / 'tools'))
import omf


def number(value):
    return int(value, 0) if isinstance(value, str) else int(value)


@dataclass(frozen=True)
class Address:
    segment: int
    offset: int

    @property
    def linear(self):
        return self.segment * 16 + self.offset

    def plus(self, delta):
        value = self.offset + delta
        if not 0 <= value <= 0xffff:
            raise ValueError('address leaves its 16-bit frame')
        return Address(self.segment, value)

    def offset_add16(self, delta):
        """OMF offset relocations use 16-bit modular addition, including -1."""
        return Address(self.segment, (self.offset + delta) & 0xffff)

    def as_dict(self):
        return dict(segment=self.segment, offset=self.offset, image_offset=self.linear,
                    address=f'{self.segment:04X}:{self.offset:04X}')


def address(value):
    if isinstance(value, Address):
        return value
    if isinstance(value, str):
        seg, off = value.split(':')
        return Address(int(seg, 16), int(off, 16))
    if 'address' in value:
        return address(value['address'])
    return Address(number(value['segment']), number(value.get('offset', 0)))


def load_bindings(path=None, crt_path=None):
    result = dict(functions={}, externals={}, segments={}, groups={'DGROUP': '1679:0000'})
    if crt_path:
        report = json.loads(Path(crt_path).read_text())
        candidate = report['candidates'][0]
        for symbol in candidate['symbols']:
            # All positively identified standard CRT CODE contributions share
            # the common _TEXT frame 0000. Do not adopt generic wrapper guesses.
            if 'identity_unproven' not in symbol['status'] and symbol['image_offset'] < 0x3ef3:
                result['externals'][symbol['name']] = Address(0, symbol['image_offset'])
        for symbol in candidate['inferred_link_labels']['labels']:
            name, linear = symbol['name'], symbol['image_offset']
            if 0x16790 <= linear <= 0x2678f:
                result['externals'][name] = Address(0x1679, linear-0x16790)
        result['externals']['_main'] = Address(0x03ef, 3)
    runtime = ROOT/'full/link/runtime/bindings.json'
    if runtime.exists() and crt_path:
        # Later, complete CRT layout verification supplies tiny thunks and data
        # vectors omitted by the initial minimum-signature-length scan.
        definitive=json.loads(runtime.read_text())
        for key in result:
            result[key].update(definitive.get(key,{}))
    if path:
        source = json.loads(Path(path).read_text())
        for key in result:
            result[key].update(source.get(key, {}))
    return result


class Unresolved(ValueError):
    pass


class Binder:
    def __init__(self, module, bindings, source_symbol, source_address):
        self.module = module
        self.bindings = bindings
        self.source_symbol = source_symbol
        self.source_address = address(source_address)
        self.named = dict(bindings.get('externals', {}))
        self.named.update(bindings.get('functions', {}))
        self.named[source_symbol['name']] = self.source_address
        self.pub_by_segment = {}
        for symbol in module.publics:
            self.pub_by_segment.setdefault(symbol['segment'], []).append(symbol)
        for symbols in self.pub_by_segment.values():
            symbols.sort(key=lambda x:x['offset'])

    def named_address(self, name):
        if name not in self.named:
            raise Unresolved(f'external/public address is unknown: {name}')
        return address(self.named[name])

    def segment_base(self, index):
        segment = self.module.segments[index-1]
        values = self.bindings.get('segments', {})
        for key in (str(index), segment.name):
            if key in values:
                return address(values[key])
        if index == self.source_symbol['segment']:
            off = self.source_address.offset - self.source_symbol['offset']
            if 0 <= off <= 0xffff:
                return Address(self.source_address.segment, off)
        raise Unresolved(f'OMF segment contribution has no binding: {index} {segment.name}')

    def group_base(self, index):
        name = self.module.groups[index-1]['name']
        values = self.bindings.get('groups', {})
        for key in (str(index), name):
            if key in values:
                return address(values[key])
        raise Unresolved(f'group frame is unknown: {name}')

    def object_address(self, index, offset):
        # Explicit PUBLIC addresses allow function-by-function verification even
        # before earlier functions have their final sizes. This is reported as
        # relocated function verification, not proof of complete module layout.
        segment = self.module.segments[index-1]
        choices = self.pub_by_segment.get(index, [])
        if offset <= segment.size:
            eligible = [s for s in choices if s['offset'] <= offset]
            if eligible:
                closest = max(s['offset'] for s in eligible)
                names = [s for s in eligible if s['offset'] == closest and s['name'] in self.named]
                if names:
                    return self.named_address(names[0]['name']).offset_add16(offset-closest)
                explicit = self.bindings.get('segments', {})
                if segment.class_name == 'CODE' and str(index) not in explicit and segment.name not in explicit:
                    raise Unresolved('internal CODE target has an unbound PUBDEF at '+hex(closest))
        return self.segment_base(index).offset_add16(offset)

    def target_address(self, f, addend):
        ref, displacement = f['target'], f['displacement']
        off = (addend + displacement) & 0xffff
        method = ref['method']
        if method == 0:
            return self.object_address(ref['datum'], off)
        if method == 1:
            return self.group_base(ref['datum']).offset_add16(off)
        if method == 2:
            return self.named_address(ref['name']).offset_add16(off)
        if method == 3:
            return Address(ref['datum'], off)
        raise Unresolved(f'unsupported target method {method}')

    def frame(self, f, target):
        ref = f['frame']
        method = ref['method']
        if method == 0:
            return self.segment_base(ref['datum']).segment
        if method == 1:
            return self.group_base(ref['datum']).segment
        if method == 2:
            return self.named_address(ref['name']).segment
        if method == 3:
            return ref['datum']
        if method == 4:
            return self.source_address.segment
        if method == 5:
            return target.segment
        if method == 6:
            return 0
        raise Unresolved(f'unsupported frame method {method}')

    def relocate_function(self, end, allow_relaxation=True):
        start = self.source_symbol['offset']
        segment = self.module.segments[self.source_symbol['segment']-1]
        code = bytearray(segment.data[start:end])
        trace, errors, relocations = [], [], []
        for f in segment.fixups:
            p, width, loc = f['offset'], f['width'], f['location_type']
            if not start <= p < end:
                continue
            item = dict(object_offset=p, function_offset=p-start, omf_fixup=f)
            if p + width > end:
                errors.append(f'fixup at {p:#x} crosses function boundary')
                continue
            if loc not in (0, 1, 2, 3, 4, 5):
                errors.append(f'16-bit verifier does not implement location type {loc}')
                continue
            raw = bytes(segment.data[p:p+width])
            if loc == 2:
                addend = 0
            elif loc in (0, 4):
                addend = int.from_bytes(raw, 'little') << (8 if loc == 4 else 0)
            else:
                addend = int.from_bytes(raw[:2], 'little')
            try:
                target = self.target_address(f, addend)
                frame = self.frame(f, target)
                source = self.source_address.plus(p-start)
                value = target.linear - frame*16
                output = None
                relaxation = None
                if loc == 3 and p > start and segment.data[p-1] in (0x9a, 0xea) and allow_relaxation and frame == source.segment:
                    opcode = segment.data[p-1]
                    displacement = (target.linear - (source.linear+4)) & 0xffff
                    output = (b'\x90\x0e\xe8' if opcode == 0x9a else b'\x90\x90\xe9') + struct.pack('<H', displacement)
                    code[p-start-1:p-start+4] = output
                    relaxation = 'CALL_FAR_to_PUSH_CS_CALL_NEAR' if opcode == 0x9a else 'JMP_FAR_to_JMP_NEAR'
                elif loc in (1, 5):
                    if f['mode'] == 'self_relative':
                        value = target.linear - (source.linear+2)
                    output = struct.pack('<H', value & 0xffff)
                    code[p-start:p-start+2] = output
                elif loc == 2:
                    # A BASE fixup relocates the paragraph frame; the inline
                    # word is a segment addend (normally zero in Borland OBJ).
                    output = struct.pack('<H', (frame + int.from_bytes(raw, 'little')) & 0xffff)
                    code[p-start:p-start+2] = output
                    relocations.append(source)
                elif loc == 3:
                    output = struct.pack('<HH', value & 0xffff, frame)
                    code[p-start:p-start+4] = output
                    relocations.append(source.plus(2))
                else:
                    shift = 8 if loc == 4 else 0
                    output = bytes([(value >> shift) & 255])
                    code[p-start] = output[0]
                item.update(target=target.as_dict(), frame=frame, before_hex=raw.hex(),
                            after_hex=output.hex(), relaxation=relaxation, resolved=True)
            except (ValueError, IndexError, KeyError) as exc:
                item.update(resolved=False, error=str(exc))
                errors.append(str(exc))
            trace.append(item)
        return bytes(code), trace, relocations, errors


def find_function(modules, name, module_name=None, explicit_end=None):
    candidates = [(m,s) for m in modules for s in m.publics
                  if s['name'] == name and s['segment']
                  and (module_name is None or m.name == module_name)]
    if len(candidates) != 1:
        raise ValueError(f'expected one definition of {name}; got {len(candidates)}')
    m, symbol = candidates[0]
    segment = m.segments[symbol['segment']-1]
    following = [s['offset'] for s in m.publics if s['segment'] == symbol['segment']
                 and s['offset'] > symbol['offset']]
    end = min(following) if following else segment.size
    if explicit_end is not None:
        end = explicit_end
    return m, symbol, end


def verify_function(obj_path, exe_path, name, target_address, bindings,
                    length=None, module_name=None, object_length=None, allow_relaxation=True,
                    structural_internal_calls=False):
    modules = omf.parse_omf(obj_path)
    module, symbol, end = find_function(modules, name, module_name)
    if object_length is not None:
        end = symbol['offset'] + object_length
    at = address(target_address)
    code, trace, relocations, errors = Binder(module, bindings, symbol, at).relocate_function(end, allow_relaxation)
    image, header_size, _ = omf.read_mz(exe_path)
    size = len(code) if length is None else length
    original = image[at.linear:at.linear+size]
    mismatches = [dict(offset=i, compiled=code[i] if i < len(code) else None,
                       original=original[i] if i < len(original) else None)
                  for i in range(max(len(code),len(original)))
                  if i >= len(code) or i >= len(original) or code[i] != original[i]]
    exe = Path(exe_path).read_bytes()
    count, table = struct.unpack_from('<H', exe, 6)[0], struct.unpack_from('<H', exe, 0x18)[0]
    original_relocations = []
    for i in range(count):
        off, seg = struct.unpack_from('<HH', exe, table+4*i)
        linear = seg*16+off
        if at.linear <= linear < at.linear+size:
            original_relocations.append(Address(seg,off))
    actual_linear = [r.linear for r in relocations]
    original_linear = [r.linear for r in original_relocations]
    report = dict(object=str(obj_path), object_sha256=hashlib.sha256(Path(obj_path).read_bytes()).hexdigest(),
        executable=str(exe_path), function=name, module=module.name,
        object_segment=symbol['segment'], object_start=symbol['offset'], object_end=end,
        target=at.as_dict(), file_offset=header_size+at.linear,
        compiled_size=len(code), original_size=len(original), unresolved=errors,
        relocations=[r.as_dict() for r in relocations],
        original_relocations=[r.as_dict() for r in original_relocations],
        relocation_sites_equal=sorted(actual_linear)==sorted(original_linear),
        relocation_order_equal=actual_linear==original_linear,
        relocation_representation_equal=relocations==original_relocations,
        fixups=trace, mismatches=mismatches,
        compiled_relocated_sha256=hashlib.sha256(code).hexdigest(),
        original_sha256=hashlib.sha256(original).hexdigest(),
        byte_exact=not errors and code==original,
        complete_module_layout_proven=False)
    report['passed'] = report['byte_exact'] and report['relocation_sites_equal']
    if structural_internal_calls:
        report['structural_internal_calls_rebased'] = rebase_internal_calls(
            module,symbol,end,at,bindings,code,original)
    return report


def rebase_internal_calls(module,symbol,end,at,bindings,relocated,original):
    """Optional diagnostic only; never changes raw byte_exact/passed status.

    Borland can fully resolve same-translation-unit relative CALL instructions,
    leaving no FIXUPP. When preceding functions still have different lengths,
    explicitly map only instruction-boundary calls to exact known PUBDEF entries.
    """
    try:
        from capstone import Cs,CS_ARCH_X86,CS_MODE_16
    except ImportError as exc:
        raise ValueError('structural internal-call diagnostics require capstone') from exc
    start=symbol['offset'];segment=module.segments[symbol['segment']-1]
    named=dict(bindings.get('externals',{}));named.update(bindings.get('functions',{}))
    public={}
    for p in module.publics:
        if p['segment']==symbol['segment'] and p['name'] in named:
            public.setdefault(p['offset'],[]).append(p)
    covered={i for f in segment.fixups for i in range(f['offset'],f['offset']+f['width'])}
    md=Cs(CS_ARCH_X86,CS_MODE_16)
    code=bytearray(relocated);changes=[]
    for ins in md.disasm(bytes(segment.data[start:end]),start):
        if len(ins.bytes)!=3 or ins.bytes[0]!=0xe8:
            continue
        if any(i in covered for i in range(ins.address+1,ins.address+3)):
            continue
        target_offset=(ins.address+3+int.from_bytes(ins.bytes[1:3],'little',signed=True))&0xffff
        candidates=public.get(target_offset,[])
        if not candidates:
            continue
        addresses={address(named[p['name']]) for p in candidates}
        if len(addresses)!=1:
            continue
        destination=next(iter(addresses))
        if destination.segment!=at.segment:
            continue
        index=ins.address-start+1
        displacement=(destination.linear-(at.linear+ins.address-start+3))&0xffff
        replacement=struct.pack('<H',displacement)
        if code[index:index+2]!=replacement:
            changes.append(dict(instruction_object_offset=ins.address,
                function_operand_offset=index,object_target_offset=target_offset,
                target_names=[p['name']for p in candidates],target=destination.as_dict(),
                before_hex=bytes(code[index:index+2]).hex(),after_hex=replacement.hex(),
                reason='known PUBDEF relative CALL with no OMF FIXUPP'))
            code[index:index+2]=replacement
    mismatch=[dict(offset=i,compiled=code[i]if i<len(code)else None,
                   original=original[i]if i<len(original)else None)
              for i in range(max(len(code),len(original)))
              if i>=len(code)or i>=len(original)or code[i]!=original[i]]
    return dict(changes=changes,mismatches=mismatch,
        byte_exact_after_structural_rebase=bytes(code)==original,
        diagnostic_sha256=hashlib.sha256(code).hexdigest(),
        modifies_object=False,counts_as_raw_exact=False,proves_complete_module_layout=False)


def main():
    p=argparse.ArgumentParser(description=__doc__)
    p.add_argument('object', type=Path)
    p.add_argument('--exe', type=Path, default=ROOT/'original/SNAKE.EXE')
    p.add_argument('--function', required=True)
    p.add_argument('--address', required=True)
    p.add_argument('--length', type=lambda s:int(s,0))
    p.add_argument('--object-length', type=lambda s:int(s,0))
    p.add_argument('--module')
    p.add_argument('--bindings', type=Path)
    p.add_argument('--crt', type=Path, default=ROOT/'analysis/crt_symbols.json')
    p.add_argument('--no-crt', action='store_true')
    p.add_argument('--no-relax', action='store_true')
    p.add_argument('--structural-internal-calls',action='store_true',
                   help='Separate Capstone diagnostic; does not change byte_exact/passed')
    p.add_argument('-o','--output',type=Path)
    args=p.parse_args()
    bindings=load_bindings(args.bindings, None if args.no_crt else args.crt)
    result=verify_function(args.object,args.exe,args.function,args.address,bindings,args.length,
                           args.module,args.object_length,not args.no_relax,args.structural_internal_calls)
    encoded=json.dumps(result,indent=2)+'\n'
    if args.output:
        args.output.parent.mkdir(parents=True,exist_ok=True)
        args.output.write_text(encoded)
        print(json.dumps({k:result[k] for k in ('function','compiled_size','original_size','byte_exact',
              'relocation_sites_equal','relocation_order_equal','unresolved','passed')},indent=2))
    else:
        print(encoded,end='')
    raise SystemExit(0 if result['passed'] else 1)


if __name__=='__main__':
    main()
