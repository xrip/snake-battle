#!/usr/bin/env python3
"""Differential 16-bit procedure execution for sound C reconstruction.

This is a verifier, not a source build step.  The reference executable supplies
the unchanged callees and initial image.  One OMF procedure is linked at a spare
offset, with its ordinary direct calls bound to their reference entry points.
The original and compiled procedure then run from identical memory snapshots.

No result from this experiment counts as a compiler-byte match.  Call rebinding
is an explicit test-link operation; no executable is emitted.  Device reads
return zero; callers must document any narrow timer/callee stubs they select.

Requires capstone and unicorn, plus the project's OMF/link verification tools.
"""
from pathlib import Path
import hashlib
import struct
import sys

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / 'link'))
import verify_object as vo
from unicorn import Uc, UC_ARCH_X86, UC_MODE_16, UC_HOOK_CODE, UC_HOOK_INSN, UcError
from unicorn.x86_const import *


REGISTERS = {
    'ax': UC_X86_REG_AX, 'bx': UC_X86_REG_BX,
    'cx': UC_X86_REG_CX, 'dx': UC_X86_REG_DX,
    'sp': UC_X86_REG_SP, 'bp': UC_X86_REG_BP,
    'si': UC_X86_REG_SI, 'di': UC_X86_REG_DI,
    'cs': UC_X86_REG_CS, 'ds': UC_X86_REG_DS,
    'es': UC_X86_REG_ES, 'ss': UC_X86_REG_SS,
    'ip': UC_X86_REG_IP,
}


class ProcedureVM:
    def __init__(self, obj, reference, bindings, cs=0x1341, ds=0x1679,
                 ss=0x9000, patch=0xF000, stop=0xEFFF):
        self.obj = Path(obj)
        self.reference = Path(reference)
        self.modules = vo.omf.parse_omf(self.obj)
        self.bindings = bindings
        self.image, _, _ = vo.omf.read_mz(self.reference)
        self.cs, self.ds, self.ss = cs, ds, ss
        self.patch, self.stop = patch, stop

    def fresh_image(self):
        memory = bytearray(0x100000)
        memory[:len(self.image)] = self.image
        return memory

    def procedure(self, name):
        module, start, end = vo.find_function(self.modules, name)
        address = vo.Address(self.cs, self.patch)
        code, fixups, relocations, errors = vo.Binder(
            module, self.bindings, start, address).relocate_function(end)
        if errors:
            raise ValueError(errors)
        direct = vo.rebase_internal_calls(module, start, end, address,
                                         self.bindings, code, b'')
        result = bytearray(code)
        for change in direct['changes']:
            p = change['function_operand_offset']
            result[p:p + 2] = bytes.fromhex(change['after_hex'])
        return bytes(result)

    def execute(self, entry, code, state, args=(), stubs=None,
                instruction_limit=400000):
        """Run near cdecl function; return state, ABI registers and device log.

        A stub mapping is {entry_offset: (stack_word_count, return_ax)}.
        return_ax=None preserves AX.  Use stubs only for independently known
        effects such as a hardware timer delay, or when comparing exact call
        arguments to a callee which deliberately is not part of this test.
        """
        stubs = stubs or {}
        u = Uc(UC_ARCH_X86, UC_MODE_16)
        u.mem_map(0, 0x100000)
        u.mem_write(0, bytes(state))
        # Install the same inert test code in BOTH executions, including when
        # calling the original, so the complete DS window remains comparable.
        u.mem_write(self.cs * 16 + self.patch, code)
        initial = dict(cs=self.cs, ds=self.ds, es=self.ds, ss=self.ss,
                       sp=0xFF00, bp=0xF122, ax=0xA55A, bx=0xB446,
                       cx=0xC379, dx=0xD298, si=0xE145, di=0xE267)
        for name, value in initial.items():
            u.reg_write(REGISTERS[name], value)
        u.reg_write(UC_X86_REG_EFLAGS, 0x202)
        stack = struct.pack('<' + 'H' * (len(args) + 1), self.stop,
                            *[arg & 0xFFFF for arg in args])
        u.mem_write(self.ss * 16 + 0xFF00, stack)
        calls, ports = [], []
        done = False
        executed = 0
        last_address = None

        def hook(uc, address, size, user):
            nonlocal done, executed, last_address
            executed += 1
            last_address = address
            if address == self.cs * 16 + self.stop:
                done = True
                uc.emu_stop()
                return
            off = address - self.cs * 16
            if off in stubs:
                nargs, ret = stubs[off]
                sp = uc.reg_read(UC_X86_REG_SP)
                words = struct.unpack('<' + 'H' * (nargs + 1),
                    uc.mem_read(self.ss * 16 + sp, (nargs + 1) * 2))
                calls.append([off, list(words[1:])])
                uc.reg_write(UC_X86_REG_SP, (sp + 2) & 0xFFFF)
                if ret is not None:
                    uc.reg_write(UC_X86_REG_AX, ret & 0xFFFF)
                uc.reg_write(UC_X86_REG_IP, words[0])

        def output(uc, port, size, value, user):
            ports.append([port, size, value])

        def input_(uc, port, size, user):
            return 0

        u.hook_add(UC_HOOK_CODE, hook)
        u.hook_add(UC_HOOK_INSN, output, None, 1, 0, UC_X86_INS_OUT)
        u.hook_add(UC_HOOK_INSN, input_, None, 1, 0, UC_X86_INS_IN)
        error = None
        try:
            u.emu_start(self.cs * 16 + entry, 0, count=instruction_limit)
        except UcError as ex:
            error = str(ex)
        return dict(done=done, error=error,
                    memory=bytes(u.mem_read(self.ds * 16, 65536)),
                    registers={name: u.reg_read(reg)
                               for name, reg in REGISTERS.items()},
                    calls=calls, ports=ports, instructions=executed,
                    last_image_address=last_address)

    def provenance(self):
        return dict(object=str(self.obj),
                    object_sha256=hashlib.sha256(self.obj.read_bytes()).hexdigest(),
                    reference_sha256=hashlib.sha256(self.reference.read_bytes()).hexdigest(),
                    cs=f'{self.cs:04X}', ds=f'{self.ds:04X}',
                    patch_offset=f'{self.patch:04X}',
                    result_kind='differential procedure semantics; not compiler byte matching')
