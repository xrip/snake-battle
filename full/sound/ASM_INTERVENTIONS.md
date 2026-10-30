# Sound driver: observed assembly interventions

All addresses below use the **original load-image CS=1341**, without the
1000h REA analysis bias. Convert `1341:offset` to the original file offset as
`14410h + offset`. These observations do not establish the historical source
language of every procedure. They identify exact constraints that a faithful
reconstruction must preserve.

## Hook-table fill (1341:0B7E)

The switch accepts hook kind 0 through 5. Kinds 0 and 1 store a byte in the
global jump/transpose slots. Kinds 2 through 5 address one of the four
16-byte per-channel arrays. Channel 16 requests all entries; larger values
return −1.

The all-channel branches prepare `AH=AL=value`, `CX=8` and `DI=array`. The
shared tail at **1341:0C32**, file **15042h**, is:

```asm
mov ax,ds
mov es,ax
rep stosw
```

The first instruction overwrites the repeated fill byte. Therefore the
original stores **eight words containing DS**, regardless of the requested
value. This is an observable behavior, not merely an unusual instruction
choice. `SOUND.C` expresses the same behavior by reading DS and writing eight
typed words. Its current compiler output is not claimed to match the native
instruction sequence.

## Stubbed extended-command cases (1341:02E4)

Cases 5 and 6 in the seven-entry command-kind switch begin at **03CEh** and
**03E4h**. Both set AX to zero, test AX and branch unconditionally in practice
to the common error result at 0400h:

```asm
xor ax,ax
or ax,ax
jz error
```

The original keeps the subsequent call sequence, although it is unreachable.
Ordinary optimizing C removes that sequence when given a constant-null
lookup. The current C source preserves the logical control flow and marks
this mismatch; the verifier does not treat omitted dead instructions as an
exact match.

## Scan error return (1341:09F4)

The error path at **1341:0A02**, file **14E12h**, executes `xor ax,0FFFFh`,
then restores SI, executes LEAVE and returns. In particular, the first entry
to this path comes from comparing `sequence->active` with zero without
initializing AX. A literal C `return -1` does not describe all observable
register states of that path. The typed C candidate currently uses the
logical error value −1 and is therefore explicitly **not** an exact semantic
or byte-level reconstruction for an inactive sequence entering with a
nonzero AX. The raw checker retains this discrepancy.

## Unused load before the default speed argument (1341:0DB9)

At **1341:0DEF**, file **151FFh**, the initializer executes `mov al,[bp+6]`.
The subsequent instructions push the constant 128, push SI, and call 0814h;
the loaded AL is not used before that call. One possible explanation is that
an earlier register argument was replaced by a constant while its load was
left in place. That history is not established by the instructions alone.
The exact sequence is preserved in `exact/MIDI.ASM`.

## Independently verified assembler contributions

The following sources have genuine register/hardware interfaces, and are
built directly from mnemonic instructions by original Borland TASM 3.1:

| Source | Original interval | Bytes | Interface |
|---|---|---:|---|
| `SNDIRQ.ASM` | 006E..00FE | 144 | IRQ0, saved vector, PIT/PIC ports |
| `SNDWAIT.ASM` | 0496..04B8 | 34 | BX count, port61 refresh-toggle wait |
| `SNDMEM.ASM` | 053D..055E | 33 | near CDECL copy, REP MOVSW/MOVSB |
| `SNDTAIL.ASM` | 30C4..3283 | 447 | register OPL interface, math ABI, chip detection |

`assemble_control.py` builds all four sources. The separate reference checks
in `control_asm/*_check.json` prove all **658 bytes**, complete PUBLIC layouts,
MZ relocation sites, order and representation. This total excludes C
candidates, padding assumptions and diagnostic normalizations.

The unsigned multiply entry 3179h consumes eight stack bytes and returns
near; the unsigned divide entry 31AAh consumes eight bytes and returns far.
Their exported Microsoft helper aliases are `__aNulmul` and `__aFuldiv`.
The aliases add link symbols only, without changing an instruction.

## Compiler comparisons

The probe results establish that selected leaf bodies also occur in genuine
Microsoft C output. They do not establish that the entire driver was linked
directly from that compiler's unmodified OMF output. Microsoft C 7 and 8
currently reproduce several complete leaf procedures, while other entries
differ in frame creation, cleanup, allocation of registers, or alignment.
The unresolved differences remain visible in the function comparison reports.
No executable body is supplied as a data array, and no output instruction is
copied from the reference executable during a build.

## Forensic assessment of a combined assembly stage

`entry_profile.json` records 157 known native entry points, including small
stubs and register-ABI helpers. Of these, 76 start at odd offsets. There are
120 ENTER prologues (108 allocate zero local bytes), and no entry starts with
the PUSH BP / MOV BP,SP pair. Thus the procedure-frame convention is unusually
uniform even where the routines themselves have different interfaces. These
counts describe observed native entries, not the number of historical source
files or exported symbols.

Additional evidence favors assembly participation beyond ordinary separate
runtime objects. The far divide call at 1006h uses the four-byte PUSH CS / CALL
NEAR representation. A normal unresolved far call in a separate Microsoft
OMF object occupies five bytes; TLINK's relaxation retains that size by adding
a NOP. A far procedure known within the same assembler segment can use the
four-byte representation directly. The recovered multiply helper uses the
register arrangement of the Microsoft C 6 helper but omits its BX save and
restore, while its frame convention also differs from that library object.

These are strong clues for a combined or manually adapted assembly stage.
They do **not** prove that every procedure was originally authored in assembly.
The ordinary CDECL interfaces, local variable frames, structured loops and
switches, and complete matching C leaf functions support a C-derived layer.
An as-yet unidentified compiler combined with assembly helpers, or compiler
output edited before assembly, remain possible. Lack of procedure alignment
alone is weak evidence because some historical compilers omit it in their
size-optimization modes.

The defensible conclusion is therefore: **a mixed driver with demonstrated
assembly participation and observed anomalies, and a likely combined assembly
stage; the historical source language of the complete module is not
established.** The full mnemonic reconstruction now supplied in `exact/` is
an executable specification of this binary, not proof that an original
assembly source file was recovered. Likewise, the current C candidates must
not be described as a fully matching C rebuild. See
[exact/PROVENANCE.md](exact/PROVENANCE.md) for the complete byte-exact mixed
build result and its explicit C/ASM boundary.
