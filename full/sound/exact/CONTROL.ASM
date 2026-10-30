; Executable mnemonic specification of the sound control/init ranges.
; 53 procedures, 3528 bytes: 3454 instruction bytes and 37 jump-table words.
; SOUND.C remains the separate C reconstruction. This file does not establish
; historical ASM authorship and is not counted as compiler-matched C.
; See PROVENANCE.md. Builds read source only, never the reference executable.
; SCxxxx contributions are combined in native order with the other sound
; fragments. They share one CS frame in the final executable.
; Every jump-table entry is a symbolic near pointer.
.286
extrn _snd_00B4:near
extrn _snd_00E7:near
extrn _snd_0DB9:near
extrn _snd_0E6A:near
extrn _snd_0E7C:near
extrn _snd_101E:near
extrn _snd_1041:near
extrn _snd_1086:near
extrn _snd_11F0:near
extrn _snd_1263:near
extrn _snd_12D8:near
extrn _snd_15DF:near
extrn _snd_162A:near
extrn _snd_167E:near
extrn _snd_1684:near
extrn _snd_16A5:near
extrn _snd_17FC:near
extrn _snd_183E:near
extrn _snd_1D6D:near
extrn _snd_1DDB:near
extrn _snd_1E1A:near
extrn _snd_1FCC:near
extrn _snd_20E7:near
extrn _snd_21EF:near
extrn _snd_2209:near
extrn _snd_22F1:near
extrn _snd_235A:near
extrn _snd_23D1:near
extrn _snd_23D2:near
extrn _snd_247E:near
extrn _snd_261A:near
extrn _snd_3179:near
extrn _snd_320A:near

SC000C segment byte public 'CODE'
assume cs:CGROUP, ds:DGROUP

; far initialize wrapper; original CS:000C
public _snd_000C
_snd_000C label far
control_000C:
    enter 0, 0 ; 000C
    push word ptr [bp + 8] ; 0010
    push word ptr [bp + 6] ; 0013
    call near ptr _snd_0158 ; 0016
    add sp, 4 ; 0019
    leave ; 001C
    retf ; 001D

; far shutdown wrapper; original CS:001E
public _snd_001E
_snd_001E label far
control_001E:
    call near ptr _snd_01A7 ; 001E
    retf ; 0021

; far pause wrapper; original CS:0022
public _snd_0022
_snd_0022 label far
control_0022:
    call near ptr _snd_01CB ; 0022
    retf ; 0025

; far resume wrapper; original CS:0026
public _snd_0026
_snd_0026 label far
control_0026:
    call near ptr _snd_01D5 ; 0026
    retf ; 0029

; far start-sound wrapper; original CS:002A
public _snd_002A
_snd_002A label far
control_002A:
    enter 0, 0 ; 002A
    push word ptr [bp + 6] ; 002E
    call near ptr _snd_021C ; 0031
    add sp, 2 ; 0034
    leave ; 0037
    retf ; 0038

; far stop-sound wrapper; original CS:0039
public _snd_0039
_snd_0039 label far
control_0039:
    enter 0, 0 ; 0039
    push word ptr [bp + 6] ; 003D
    call near ptr _snd_0269 ; 0040
    add sp, 2 ; 0043
    leave ; 0046
    retf ; 0047

; far sound-status wrapper; original CS:0048
public _snd_0048
_snd_0048 label far
control_0048:
    enter 0, 0 ; 0048
    push word ptr [bp + 6] ; 004C
    call near ptr _snd_02B7 ; 004F
    add sp, 2 ; 0052
    leave ; 0055
    retf ; 0056

; far fade wrapper; original CS:0057
public _snd_0057
_snd_0057 label far
control_0057:
    enter 0, 0 ; 0057
    push word ptr [bp + 0Ah] ; 005B
    push word ptr [bp + 8] ; 005E
    push word ptr [bp + 6] ; 0061
    push 0Dh ; 0064
    call near ptr _snd_02E4 ; 0066
    add sp, 8 ; 0069
    leave ; 006C
    retf ; 006D
SC000C ends

SC00FE segment byte public 'CODE'
assume cs:CGROUP, ds:DGROUP

; command dispatcher; original CS:00FE
public _snd_00FE
_snd_00FE label far
control_00FE:
    enter 0, 0 ; 00FE
    push si ; 0102
    mov al, byte ptr [bp + 7] ; 0103
    mov si, word ptr [bp + 6] ; 0106
    and si, 0FFh ; 0109
    cmp al, 1 ; 010D
    ja short control_0132 ; 010F
    je short control_0138 ; 0111
    cmp si, 0Eh ; 0113
    jae short control_0132 ; 0116
    shl si, 1 ; 0118
    mov ax, word ptr [si + _snd_basic_commands] ; 011A
    or ax, ax ; 011E
    je short control_0132 ; 0120
    push word ptr [bp + 0Ch] ; 0122
    push word ptr [bp + 0Ah] ; 0125
    push word ptr [bp + 8] ; 0128
    call ax ; 012B
    add sp, 6 ; 012D
    jmp short control_0155 ; 0130
control_0132:
    mov ax, 0FFFFh ; 0132
    cwd ; 0135
    jmp short control_0155 ; 0136
control_0138:
    push word ptr [bp + 014h] ; 0138
    push word ptr [bp + 012h] ; 013B
    push word ptr [bp + 010h] ; 013E
    push word ptr [bp + 0Eh] ; 0141
    push word ptr [bp + 0Ch] ; 0144
    push word ptr [bp + 0Ah] ; 0147
    push word ptr [bp + 8] ; 014A
    push si ; 014D
    call near ptr _snd_02E4 ; 014E
    add sp, 010h ; 0151
    cwd ; 0154
control_0155:
    pop si ; 0155
    leave ; 0156
    retf ; 0157

; initialize sound system; original CS:0158
public _snd_0158
_snd_0158 label near
control_0158:
    enter 0, 0 ; 0158
    call near ptr _snd_320A ; 015C
    or ax, ax ; 015F
    jne short control_01A1 ; 0161
    mov ax, word ptr [bp + 4] ; 0163
    mov dx, word ptr [bp + 6] ; 0166
    mov word ptr [_snd_resources], ax ; 0169
    mov word ptr [_snd_resources+2], dx ; 016C
    mov word ptr [_snd_master_volume], 07Fh ; 0170
    call near ptr _snd_3283 ; 0176
    call near ptr _snd_32AF ; 0179
    call near ptr _snd_3362 ; 017C
    call near ptr _snd_32CF ; 017F
    call near ptr _snd_32EB ; 0182
    call near ptr _snd_3303 ; 0185
    call near ptr _snd_332F ; 0188
    xor ax, ax ; 018B
    mov word ptr [_snd_scanning], ax ; 018D
    mov word ptr [_snd_paused], ax ; 0190
    mov word ptr [_snd_disabled], ax ; 0193
    call near ptr _snd_00B4 ; 0196
    xor ax, ax ; 0199
    mov word ptr [_snd_basic_commands], ax ; 019B
    cwd ; 019E
    leave ; 019F
    ret ; 01A0
control_01A1:
    mov ax, 0FFFFh ; 01A1
    cwd ; 01A4
    leave ; 01A5
    ret ; 01A6

; shutdown sound system; original CS:01A7
public _snd_01A7
_snd_01A7 label near
control_01A7:
    mov ax, 1 ; 01A7
    mov word ptr [_snd_paused], ax ; 01AA
    mov word ptr [_snd_disabled], ax ; 01AD
    call near ptr _snd_00E7 ; 01B0
    call near ptr _snd_1FCC ; 01B3
    call near ptr _snd_167E ; 01B6
    mov byte ptr [_snd_parse_nesting], 064h ; 01B9
    call near ptr _snd_029B ; 01BE
    mov word ptr [_snd_basic_commands], offset _snd_0158 ; 01C1
    xor ax, ax ; 01C7
    cwd ; 01C9
    ret ; 01CA

; pause sequence advancement; original CS:01CB
public _snd_01CB
_snd_01CB label near
control_01CB:
    mov word ptr [_snd_paused], 1 ; 01CB
    xor ax, ax ; 01D1
    cwd ; 01D3
    ret ; 01D4

; resume sequence advancement; original CS:01D5
public _snd_01D5
_snd_01D5 label near
control_01D5:
    xor ax, ax ; 01D5
    mov word ptr [_snd_paused], ax ; 01D7
    cwd ; 01DA
    ret ; 01DB

; set master volume; original CS:01DC
public _snd_01DC
_snd_01DC label near
control_01DC:
    enter 0, 0 ; 01DC
    push di ; 01E0
    push si ; 01E1
    cmp byte ptr [bp + 4], 07Fh ; 01E2
    jbe short control_01EC ; 01E6
    mov byte ptr [bp + 4], 07Fh ; 01E8
control_01EC:
    mov al, byte ptr [bp + 4] ; 01EC
    cbw ; 01EF
    mov word ptr [_snd_master_volume], ax ; 01F0
    mov si, offset _snd_players ; 01F3
    mov di, 2 ; 01F6
control_01F9:
    cmp byte ptr [si + 6], 0 ; 01F9
    je short control_020A ; 01FD
    mov al, byte ptr [si + 0Dh] ; 01FF
    push ax ; 0202
    push si ; 0203
    call near ptr _snd_075E ; 0204
    add sp, 4 ; 0207
control_020A:
    add si, 012h ; 020A
    dec di ; 020D
    jne short control_01F9 ; 020E
    xor ax, ax ; 0210
    cwd ; 0212
    pop si ; 0213
    pop di ; 0214
    leave ; 0215
    ret ; 0216

; get master volume; original CS:0217
public _snd_0217
_snd_0217 label near
control_0217:
    mov ax, word ptr [_snd_master_volume] ; 0217
    cwd ; 021A
    ret ; 021B

; start sound; original CS:021C
public _snd_021C
_snd_021C label near
control_021C:
    enter 0, 0 ; 021C
    push di ; 0220
    push si ; 0221
    mov di, word ptr [bp + 4] ; 0222
    push 0 ; 0225
    push word ptr [_snd_midi_tags+2] ; 0227
    push word ptr [_snd_midi_tags] ; 022B
    push di ; 022F
    call near ptr _snd_0406 ; 0230
    add sp, 8 ; 0233
    or ax, dx ; 0236
    je short control_0261 ; 0238
    push 080h ; 023A
    call near ptr _snd_05A6 ; 023D
    inc sp ; 0240
    inc sp ; 0241
    or ax, ax ; 0242
    je short control_0261 ; 0244
    mov si, ax ; 0246
    push si ; 0248
    call near ptr _snd_0643 ; 0249
    inc sp ; 024C
    inc sp ; 024D
    push di ; 024E
    push si ; 024F
    call near ptr _snd_05E8 ; 0250
    add sp, 4 ; 0253
    or ax, ax ; 0256
    je short control_0261 ; 0258
    xor ax, ax ; 025A
    cwd ; 025C
    pop si ; 025D
    pop di ; 025E
    leave ; 025F
    ret ; 0260
control_0261:
    mov ax, 0FFFFh ; 0261
    cwd ; 0264
    pop si ; 0265
    pop di ; 0266
    leave ; 0267
    ret ; 0268

; stop matching sound; original CS:0269
public _snd_0269
_snd_0269 label near
control_0269:
    enter 0, 0 ; 0269
    push di ; 026D
    push si ; 026E
    mov si, offset _snd_players ; 026F
    mov di, 0FFFFh ; 0272
control_0275:
    cmp byte ptr [si + 6], 1 ; 0275
    jne short control_028B ; 0279
    mov ax, word ptr [bp + 4] ; 027B
    cmp ax, word ptr [si + 8] ; 027E
    jne short control_028B ; 0281
    push si ; 0283
    call near ptr _snd_0643 ; 0284
    inc sp ; 0287
    inc sp ; 0288
    xor di, di ; 0289
control_028B:
    add si, 012h ; 028B
    cmp si, offset _snd_players+36 ; 028E
    jb short control_0275 ; 0292
    mov ax, di ; 0294
    cwd ; 0296
    pop si ; 0297
    pop di ; 0298
    leave ; 0299
    ret ; 029A

; stop all sounds; original CS:029B
public _snd_029B
_snd_029B label near
control_029B:
    push si ; 029B
    call near ptr _snd_0DA8 ; 029C
    mov si, offset _snd_players ; 029F
control_02A2:
    push si ; 02A2
    call near ptr _snd_0643 ; 02A3
    add sp, 2 ; 02A6
    add si, 012h ; 02A9
    cmp si, offset _snd_players+36 ; 02AC
    jb short control_02A2 ; 02B0
    xor ax, ax ; 02B2
    cwd ; 02B4
    pop si ; 02B5
    ret ; 02B6

; test sound activity; original CS:02B7
public _snd_02B7
_snd_02B7 label near
control_02B7:
    enter 0, 0 ; 02B7
    mov bx, offset _snd_players ; 02BB
    mov dx, word ptr [bp + 4] ; 02BE
    mov cx, 2 ; 02C1
control_02C4:
    cmp byte ptr [bx + 6], 1 ; 02C4
    jne short control_02CF ; 02C8
    cmp word ptr [bx + 8], dx ; 02CA
    je short control_02DE ; 02CD
control_02CF:
    add bx, 012h ; 02CF
    loop control_02C4 ; 02D2
    push dx ; 02D4
    call near ptr _snd_17FC ; 02D5
    add sp, 2 ; 02D8
    cwd ; 02DB
    leave ; 02DC
    ret ; 02DD
control_02DE:
    mov ax, 1 ; 02DE
    cwd ; 02E1
    leave ; 02E2
    ret ; 02E3

; dispatch extended command by argument kind; original CS:02E4
public _snd_02E4
_snd_02E4 label near
control_02E4:
    enter 0, 0 ; 02E4
    push si ; 02E8
    mov dx, word ptr [bp + 4] ; 02E9
    cmp dx, 018h ; 02EC
    jl short control_02F4 ; 02EF
    jmp near ptr control_0400 ; 02F1
control_02F4:
    mov bx, dx ; 02F4
    shl bx, 1 ; 02F6
    mov si, word ptr [bx + _snd_extended_commands] ; 02F8
    or si, si ; 02FC
    jne short control_0303 ; 02FE
    jmp near ptr control_0400 ; 0300
control_0303:
    mov bx, dx ; 0303
    mov al, byte ptr [bx + _snd_command_kinds] ; 0305
    xor ah, ah ; 0309
    shl ax, 1 ; 030B
    xchg bx, ax ; 030D
    jmp word ptr cs:[bx + control_0314] ; 030E
    nop ; 0313
control_0314:
    ; 7 near destinations, indexed by twice the selector
    dw offset control_0322, offset control_0340, offset control_0360, offset control_038E
    dw offset control_03AA, offset control_03CE, offset control_03E4
control_0322:
    push word ptr [bp + 012h] ; 0322
    push word ptr [bp + 010h] ; 0325
    push word ptr [bp + 0Eh] ; 0328
    push word ptr [bp + 0Ch] ; 032B
    push word ptr [bp + 0Ah] ; 032E
    push word ptr [bp + 8] ; 0331
    push word ptr [bp + 6] ; 0334
    call si ; 0337
    add sp, 0Eh ; 0339
    pop si ; 033C
    leave ; 033D
    ret ; 033E
    nop ; 033F
control_0340:
    push word ptr [bp + 6] ; 0340
    call near ptr _snd_0574 ; 0343
    add sp, 2 ; 0346
    or ax, ax ; 0349
    jne short control_0350 ; 034B
    jmp near ptr control_0400 ; 034D
control_0350:
    push word ptr [bp + 0Ah] ; 0350
    push word ptr [bp + 8] ; 0353
    push ax ; 0356
    call si ; 0357
    add sp, 6 ; 0359
    pop si ; 035C
    leave ; 035D
    ret ; 035E
    nop ; 035F
control_0360:
    push word ptr [bp + 6] ; 0360
    call near ptr _snd_0574 ; 0363
    add sp, 2 ; 0366
    or ax, ax ; 0369
    jne short control_0370 ; 036B
    jmp near ptr control_0400 ; 036D
control_0370:
    mov bx, ax ; 0370
    push word ptr [bp + 012h] ; 0372
    push word ptr [bp + 010h] ; 0375
    push word ptr [bp + 0Eh] ; 0378
    push word ptr [bp + 0Ch] ; 037B
    push word ptr [bp + 0Ah] ; 037E
    push word ptr [bp + 8] ; 0381
    push word ptr [bx] ; 0384
    call si ; 0386
    add sp, 0Eh ; 0388
    pop si ; 038B
    leave ; 038C
    ret ; 038D
control_038E:
    push word ptr [bp + 6] ; 038E
    call near ptr _snd_0574 ; 0391
    add sp, 2 ; 0394
    or ax, ax ; 0397
    je short control_0400 ; 0399
    push word ptr [bp + 0Ah] ; 039B
    push word ptr [bp + 8] ; 039E
    push ax ; 03A1
    call si ; 03A2
    add sp, 6 ; 03A4
    pop si ; 03A7
    leave ; 03A8
    ret ; 03A9
control_03AA:
    push word ptr [bp + 6] ; 03AA
    call near ptr _snd_0574 ; 03AD
    add sp, 2 ; 03B0
    or ax, ax ; 03B3
    je short control_0400 ; 03B5
    mov bx, ax ; 03B7
    push word ptr [bp + 0Ch] ; 03B9
    push word ptr [bp + 0Ah] ; 03BC
    push word ptr [bp + 8] ; 03BF
    push word ptr [bx + 2] ; 03C2
    call si ; 03C5
    add sp, 8 ; 03C7
    pop si ; 03CA
    leave ; 03CB
    ret ; 03CC
    nop ; 03CD
control_03CE:
    xor ax, ax ; 03CE
    or ax, ax ; 03D0
    je short control_0400 ; 03D2
    push word ptr [bp + 8] ; 03D4
    push word ptr [bp + 6] ; 03D7
    push ax ; 03DA
    call si ; 03DB
    add sp, 6 ; 03DD
    pop si ; 03E0
    leave ; 03E1
    ret ; 03E2
    nop ; 03E3
control_03E4:
    xor ax, ax ; 03E4
    or ax, ax ; 03E6
    je short control_0400 ; 03E8
    mov bx, ax ; 03EA
    push word ptr [bp + 0Ah] ; 03EC
    push word ptr [bp + 8] ; 03EF
    push word ptr [bp + 6] ; 03F2
    push word ptr [bx + 2] ; 03F5
    call si ; 03F8
    add sp, 8 ; 03FA
    pop si ; 03FD
    leave ; 03FE
    ret ; 03FF
control_0400:
    mov ax, 0FFFFh ; 0400
    pop si ; 0403
    leave ; 0404
    ret ; 0405

; locate MIDI chunk in resource; original CS:0406
public _snd_0406
_snd_0406 label near
control_0406:
    enter 4, 0 ; 0406
    mov ax, word ptr [bp + 4] ; 040A
    shl ax, 2 ; 040D
    les bx, dword ptr [_snd_resources] ; 0410
    add bx, ax ; 0414
    mov ax, word ptr es:[bx] ; 0416
    mov dx, word ptr es:[bx + 2] ; 0419
    mov word ptr [bp - 4], ax ; 041D
    mov word ptr [bp - 2], dx ; 0420
    or ax, dx ; 0423
    je short control_0447 ; 0425
    les bx, dword ptr [bp - 4] ; 0427
    cmp word ptr es:[bx], 0544Dh ; 042A
    jne short control_0447 ; 042F
    cmp word ptr es:[bx + 2], 06468h ; 0431
    jne short control_0447 ; 0437
    add bx, 8 ; 0439
    cmp word ptr [bp + 8], 06468h ; 043C
    jne short control_044C ; 0441
    mov ax, bx ; 0443
    leave ; 0445
    ret ; 0446
control_0447:
    xor ax, ax ; 0447
    cwd ; 0449
    leave ; 044A
    ret ; 044B
control_044C:
    mov ax, word ptr es:[bx + 2] ; 044C
    xchg al, ah ; 0450
    cmp ax, word ptr [bp + 0Ah] ; 0452
    ja short control_045C ; 0455
    mov word ptr [bp + 0Ah], 0 ; 0457
control_045C:
    add word ptr [bp - 4], 4 ; 045C
    push word ptr [bp - 2] ; 0460
    push word ptr [bp - 4] ; 0463
    call near ptr _snd_04B8 ; 0466
    add sp, 4 ; 0469
    add ax, 4 ; 046C
    add word ptr [bp - 4], ax ; 046F
    les bx, dword ptr [bp - 4] ; 0472
    dec word ptr [bp + 0Ah] ; 0475
    jns short control_045C ; 0478
    mov ax, word ptr es:[bx] ; 047A
    mov dx, word ptr es:[bx + 2] ; 047D
    cmp ax, word ptr [bp + 6] ; 0481
    jne short control_0447 ; 0484
    cmp dx, word ptr [bp + 8] ; 0486
    jne short control_0447 ; 0489
    mov ax, word ptr [bp - 4] ; 048B
    mov dx, word ptr [bp - 2] ; 048E
    add ax, 8 ; 0491
    leave ; 0494
    ret ; 0495
SC00FE ends

SC04B8 segment byte public 'CODE'
assume cs:CGROUP, ds:DGROUP

; read big-endian far dword; original CS:04B8
public _snd_04B8
_snd_04B8 label near
control_04B8:
    enter 0, 0 ; 04B8
    les bx, dword ptr [bp + 4] ; 04BC
    mov dx, word ptr es:[bx] ; 04BF
    mov ax, word ptr es:[bx + 2] ; 04C2
    xchg dl, dh ; 04C6
    xchg al, ah ; 04C8
    leave ; 04CA
    ret ; 04CB

; read big-endian near word; original CS:04CC
public _snd_04CC
_snd_04CC label near
control_04CC:
    enter 0, 0 ; 04CC
    mov bx, word ptr [bp + 4] ; 04D0
    mov ax, word ptr [bx] ; 04D3
    xchg al, ah ; 04D5
    leave ; 04D7
    ret ; 04D8

; clamp signed value; original CS:04D9
public _snd_04D9
_snd_04D9 label near
control_04D9:
    enter 0, 0 ; 04D9
    mov dx, word ptr [bp + 4] ; 04DD
    mov bx, word ptr [bp + 6] ; 04E0
    cmp bx, dx ; 04E3
    jg short control_04EE ; 04E5
    mov bx, word ptr [bp + 8] ; 04E7
    cmp bx, dx ; 04EA
    jge short control_04F0 ; 04EC
control_04EE:
    mov dx, bx ; 04EE
control_04F0:
    mov ax, dx ; 04F0
    leave ; 04F2
    ret ; 04F3

; wrap note value in octaves; original CS:04F4
public _snd_04F4
_snd_04F4 label near
control_04F4:
    enter 0, 0 ; 04F4
    mov bx, word ptr [bp + 4] ; 04F8
    cmp bx, word ptr [bp + 6] ; 04FB
    jg short control_051A ; 04FE
    mov ax, word ptr [bp + 6] ; 0500
    sub ax, bx ; 0503
    add ax, 0Bh ; 0505
    mov cx, 0Ch ; 0508
    xor dx, dx ; 050B
    div cx ; 050D
    mov dx, ax ; 050F
    shl ax, 1 ; 0511
    add ax, dx ; 0513
    shl ax, 2 ; 0515
    add bx, ax ; 0518
control_051A:
    cmp word ptr [bp + 8], bx ; 051A
    jge short control_0539 ; 051D
    mov ax, bx ; 051F
    sub ax, word ptr [bp + 8] ; 0521
    add ax, 0Bh ; 0524
    mov cx, 0Ch ; 0527
    xor dx, dx ; 052A
    div cx ; 052C
    mov dx, ax ; 052E
    shl ax, 1 ; 0530
    add ax, dx ; 0532
    shl ax, 2 ; 0534
    sub bx, ax ; 0537
control_0539:
    mov ax, bx ; 0539
    leave ; 053B
    ret ; 053C
SC04B8 ends

SC055E segment byte public 'CODE'
assume cs:CGROUP, ds:DGROUP

; timer work dispatcher; original CS:055E
public _snd_055E
_snd_055E label near
control_055E:
    mov ax, word ptr [_snd_disabled] ; 055E
    or ax, word ptr [_snd_paused] ; 0561
    jne short control_0573 ; 0565
    call near ptr _snd_0E7C ; 0567
    call near ptr _snd_1263 ; 056A
    call near ptr _snd_1E1A ; 056D
    call near ptr _snd_16A5 ; 0570
control_0573:
    ret ; 0573

; find unique matching player; original CS:0574
public _snd_0574
_snd_0574 label near
control_0574:
    enter 0, 0 ; 0574
    push di ; 0578
    mov ax, word ptr [bp + 4] ; 0579
    mov dx, 0FFFFh ; 057C
    mov bx, offset _snd_players ; 057F
    mov cx, 2 ; 0582
control_0585:
    cmp byte ptr [bx + 6], 1 ; 0585
    jne short control_0593 ; 0589
    cmp ax, word ptr [bx + 8] ; 058B
    jne short control_0593 ; 058E
    mov di, bx ; 0590
    inc dx ; 0592
control_0593:
    add bx, 012h ; 0593
    loop control_0585 ; 0596
    or dx, dx ; 0598
    je short control_05A1 ; 059A
    xor ax, ax ; 059C
    pop di ; 059E
    leave ; 059F
    ret ; 05A0
control_05A1:
    mov ax, di ; 05A1
    pop di ; 05A3
    leave ; 05A4
    ret ; 05A5

; choose idle or lower-priority player; original CS:05A6
public _snd_05A6
_snd_05A6 label near
control_05A6:
    enter 0, 0 ; 05A6
    push si ; 05AA
    mov si, offset _snd_players ; 05AB
    xor cx, cx ; 05AE
    xor dx, dx ; 05B0
    mov ah, 0FFh ; 05B2
control_05B4:
    cmp byte ptr [si + 6], 0 ; 05B4
    je short control_05DE ; 05B8
    cmp byte ptr [si + 6], 1 ; 05BA
    jne short control_05CB ; 05BE
    mov al, byte ptr [si + 0Ch] ; 05C0
    cmp al, ah ; 05C3
    ja short control_05CB ; 05C5
    mov ah, al ; 05C7
    mov cx, si ; 05C9
control_05CB:
    add si, 012h ; 05CB
    inc dx ; 05CE
    cmp dx, 2 ; 05CF
    jl short control_05B4 ; 05D2
    cmp byte ptr [bp + 4], ah ; 05D4
    jb short control_05E3 ; 05D7
    mov ax, cx ; 05D9
    pop si ; 05DB
    leave ; 05DC
    ret ; 05DD
control_05DE:
    mov ax, si ; 05DE
    pop si ; 05E0
    leave ; 05E1
    ret ; 05E2
control_05E3:
    xor ax, ax ; 05E3
    pop si ; 05E5
    leave ; 05E6
    ret ; 05E7

; initialize selected player; original CS:05E8
public _snd_05E8
_snd_05E8 label near
control_05E8:
    enter 0, 0 ; 05E8
    push di ; 05EC
    push si ; 05ED
    mov di, word ptr [bp + 6] ; 05EE
    mov si, word ptr [bp + 4] ; 05F1
    mov word ptr [si + 4], 0 ; 05F4
    mov byte ptr [si + 6], 1 ; 05F9
    mov word ptr [si + 8], di ; 05FD
    mov byte ptr [si + 0Ch], 080h ; 0600
    mov byte ptr [si + 0Dh], 07Fh ; 0604
    mov word ptr [si + 0Ah], 0FFFFh ; 0608
    mov ax, word ptr [_snd_master_volume] ; 060D
    shl ax, 7 ; 0610
    sar ax, 7 ; 0613
    mov byte ptr [si + 0Eh], al ; 0616
    mov byte ptr [si + 0Fh], 0 ; 0619
    mov byte ptr [si + 010h], 0 ; 061D
    mov byte ptr [si + 011h], 0 ; 0621
    push word ptr [si + 2] ; 0625
    call near ptr _snd_1086 ; 0628
    inc sp ; 062B
    inc sp ; 062C
    push di ; 062D
    push word ptr [si] ; 062E
    call near ptr _snd_0DB9 ; 0630
    add sp, 4 ; 0633
    or ax, ax ; 0636
    jne short control_063F ; 0638
    xor ax, ax ; 063A
    mov byte ptr [si + 6], al ; 063C
control_063F:
    pop si ; 063F
    pop di ; 0640
    leave ; 0641
    ret ; 0642

; release selected player; original CS:0643
public _snd_0643
_snd_0643 label near
control_0643:
    enter 0, 0 ; 0643
    push si ; 0647
    mov si, word ptr [bp + 4] ; 0648
    cmp byte ptr [si + 6], 1 ; 064B
    jne short control_0668 ; 064F
    push word ptr [si] ; 0651
    call near ptr _snd_0E6A ; 0653
    inc sp ; 0656
    inc sp ; 0657
    push si ; 0658
    call near ptr _snd_1684 ; 0659
    inc sp ; 065C
    inc sp ; 065D
    push si ; 065E
    call near ptr _snd_20E7 ; 065F
    inc sp ; 0662
    inc sp ; 0663
    mov byte ptr [si + 6], 0 ; 0664
control_0668:
    pop si ; 0668
    leave ; 0669
    ret ; 066A

; query player or sequence property; original CS:066B
public _snd_066B
_snd_066B label near
control_066B:
    enter 0, 0 ; 066B
    mov bx, word ptr [bp + 6] ; 066F
    cmp bx, 017h ; 0672
    ja short control_06B6 ; 0675
    shl bx, 1 ; 0677
    mov dx, word ptr cs:[bx + control_0686] ; 0679
    xor ax, ax ; 067E
    mov bx, word ptr [bp + 4] ; 0680
    jmp dx ; 0683
    nop ; 0685
control_0686:
    ; 24 near destinations, indexed by twice the selector
    dw offset control_06BC, offset control_06C2, offset control_06C8, offset control_06CE
    dw offset control_06D4, offset control_06DA, offset control_06E2, offset control_06EA
    dw offset control_06F2, offset control_06FA, offset control_0702, offset control_070A
    dw offset control_0712, offset control_071A, offset control_0722, offset control_0722
    dw offset control_0722, offset control_0722, offset control_0732, offset control_0732
    dw offset control_0732, offset control_0732, offset control_0732, offset control_0732
control_06B6:
    mov ax, 0FFFFh ; 06B6
    leave ; 06B9
    ret ; 06BA
    nop ; 06BB
control_06BC:
    mov al, byte ptr [bx + 0Ch] ; 06BC
    leave ; 06BF
    ret ; 06C0
    nop ; 06C1
control_06C2:
    mov al, byte ptr [bx + 0Dh] ; 06C2
    leave ; 06C5
    ret ; 06C6
    nop ; 06C7
control_06C8:
    mov al, byte ptr [bx + 0Fh] ; 06C8
    leave ; 06CB
    ret ; 06CC
    nop ; 06CD
control_06CE:
    mov al, byte ptr [bx + 010h] ; 06CE
    leave ; 06D1
    ret ; 06D2
    nop ; 06D3
control_06D4:
    mov al, byte ptr [bx + 011h] ; 06D4
    leave ; 06D7
    ret ; 06D8
    nop ; 06D9
control_06DA:
    mov bx, word ptr [bx] ; 06DA
    mov al, byte ptr [bx + 024h] ; 06DC
    leave ; 06DF
    ret ; 06E0
    nop ; 06E1
control_06E2:
    mov bx, word ptr [bx] ; 06E2
    mov ax, word ptr [bx + 0Ah] ; 06E4
    leave ; 06E7
    ret ; 06E8
    nop ; 06E9
control_06EA:
    mov bx, word ptr [bx] ; 06EA
    mov ax, word ptr [bx + 0Ch] ; 06EC
    leave ; 06EF
    ret ; 06F0
    nop ; 06F1
control_06F2:
    mov bx, word ptr [bx] ; 06F2
    mov ax, word ptr [bx + 0Eh] ; 06F4
    leave ; 06F7
    ret ; 06F8
    nop ; 06F9
control_06FA:
    mov bx, word ptr [bx] ; 06FA
    mov ax, word ptr [bx + 02Ah] ; 06FC
    leave ; 06FF
    ret ; 0700
    nop ; 0701
control_0702:
    mov bx, word ptr [bx] ; 0702
    mov ax, word ptr [bx + 02Ch] ; 0704
    leave ; 0707
    ret ; 0708
    nop ; 0709
control_070A:
    mov bx, word ptr [bx] ; 070A
    mov ax, word ptr [bx + 02Eh] ; 070C
    leave ; 070F
    ret ; 0710
    nop ; 0711
control_0712:
    mov bx, word ptr [bx] ; 0712
    mov ax, word ptr [bx + 030h] ; 0714
    leave ; 0717
    ret ; 0718
    nop ; 0719
control_071A:
    mov bx, word ptr [bx] ; 071A
    mov ax, word ptr [bx + 032h] ; 071C
    leave ; 071F
    ret ; 0720
    nop ; 0721
control_0722:
    push word ptr [bp + 8] ; 0722
    push word ptr [bp + 6] ; 0725
    push bx ; 0728
    call near ptr _snd_261A ; 0729
    add sp, 6 ; 072C
    leave ; 072F
    ret ; 0730
    nop ; 0731
control_0732:
    push word ptr [bp + 8] ; 0732
    push word ptr [bp + 6] ; 0735
    push word ptr [bx + 2] ; 0738
    call near ptr _snd_11F0 ; 073B
    add sp, 6 ; 073E
    leave ; 0741
    ret ; 0742

; set player priority; original CS:0743
public _snd_0743
_snd_0743 label near
control_0743:
    enter 0, 0 ; 0743
    mov bx, word ptr [bp + 4] ; 0747
    mov al, byte ptr [bp + 6] ; 074A
    mov byte ptr [bx + 0Ch], al ; 074D
    push ax ; 0750
    push 010h ; 0751
    push bx ; 0753
    call near ptr _snd_22F1 ; 0754
    add sp, 6 ; 0757
    xor ax, ax ; 075A
    leave ; 075C
    ret ; 075D

; set player volume; original CS:075E
public _snd_075E
_snd_075E label near
control_075E:
    enter 0, 0 ; 075E
    cmp byte ptr [bp + 6], 07Fh ; 0762
    jbe short control_076C ; 0766
    mov byte ptr [bp + 6], 07Fh ; 0768
control_076C:
    mov bx, word ptr [bp + 4] ; 076C
    mov al, byte ptr [bp + 6] ; 076F
    cbw ; 0772
    mov byte ptr [bx + 0Dh], al ; 0773
    inc ax ; 0776
    imul word ptr [_snd_master_volume] ; 0777
    sar ax, 7 ; 077B
    mov byte ptr [bx + 0Eh], al ; 077E
    push ax ; 0781
    push 010h ; 0782
    push bx ; 0784
    call near ptr _snd_235A ; 0785
    add sp, 6 ; 0788
    xor ax, ax ; 078B
    leave ; 078D
    ret ; 078E

; set player pan; original CS:078F
public _snd_078F
_snd_078F label near
control_078F:
    enter 0, 0 ; 078F
    mov bx, word ptr [bp + 4] ; 0793
    mov al, byte ptr [bp + 6] ; 0796
    mov byte ptr [bx + 0Fh], al ; 0799
    push ax ; 079C
    push 010h ; 079D
    push bx ; 079F
    call near ptr _snd_23D1 ; 07A0
    add sp, 6 ; 07A3
    xor ax, ax ; 07A6
    leave ; 07A8
    ret ; 07A9

; set player transpose; original CS:07AA
public _snd_07AA
_snd_07AA label near
control_07AA:
    enter 0, 0 ; 07AA
    push si ; 07AE
    cmp byte ptr [bp + 8], 018h ; 07AF
    jg short control_07F3 ; 07B3
    cmp byte ptr [bp + 8], 0E8h ; 07B5
    jl short control_07F3 ; 07B9
    mov si, word ptr [bp + 4] ; 07BB
    mov al, byte ptr [bp + 8] ; 07BE
    cmp byte ptr [bp + 6], 1 ; 07C1
    ja short control_07F3 ; 07C5
    jb short control_07DD ; 07C7
    cbw ; 07C9
    mov cx, ax ; 07CA
    mov al, byte ptr [si + 010h] ; 07CC
    cbw ; 07CF
    add cx, ax ; 07D0
    push 7 ; 07D2
    push -7 ; 07D4
    push cx ; 07D6
    call near ptr _snd_04F4 ; 07D7
    add sp, 6 ; 07DA
control_07DD:
    mov byte ptr [si + 010h], al ; 07DD
    push ax ; 07E0
    mov al, byte ptr [bp + 6] ; 07E1
    push ax ; 07E4
    push 010h ; 07E5
    push si ; 07E7
    call near ptr _snd_23D2 ; 07E8
    add sp, 8 ; 07EB
    xor ax, ax ; 07EE
    pop si ; 07F0
    leave ; 07F1
    ret ; 07F2
control_07F3:
    mov ax, 0FFFFh ; 07F3
    pop si ; 07F6
    leave ; 07F7
    ret ; 07F8

; set player detune; original CS:07F9
public _snd_07F9
_snd_07F9 label near
control_07F9:
    enter 0, 0 ; 07F9
    mov bx, word ptr [bp + 4] ; 07FD
    mov al, byte ptr [bp + 6] ; 0800
    mov byte ptr [bx + 011h], al ; 0803
    push ax ; 0806
    push 010h ; 0807
    push bx ; 0809
    call near ptr _snd_247E ; 080A
    add sp, 6 ; 080D
    xor ax, ax ; 0810
    leave ; 0812
    ret ; 0813

; set sequence speed and tick rate; original CS:0814
public _snd_0814
_snd_0814 label near
control_0814:
    enter 0, 0 ; 0814
    push si ; 0818
    mov si, word ptr [bp + 4] ; 0819
    mov al, byte ptr [bp + 6] ; 081C
    mov byte ptr [si + 024h], al ; 081F
    xor ah, ah ; 0822
    push 0 ; 0824
    push ax ; 0826
    push word ptr [si + 022h] ; 0827
    push word ptr [si + 020h] ; 082A
    call near ptr _snd_3179 ; 082D
    shr dx, 1 ; 0830
    rcr ax, 1 ; 0832
    shr dx, 1 ; 0834
    rcr ax, 1 ; 0836
    shr dx, 1 ; 0838
    rcr ax, 1 ; 083A
    shr dx, 1 ; 083C
    rcr ax, 1 ; 083E
    shr dx, 1 ; 0840
    rcr ax, 1 ; 0842
    shr dx, 1 ; 0844
    rcr ax, 1 ; 0846
    shr dx, 1 ; 0848
    rcr ax, 1 ; 084A
    mov word ptr [si + 026h], ax ; 084C
    mov word ptr [si + 028h], dx ; 084F
    xor ax, ax ; 0852
    pop si ; 0854
    leave ; 0855
    ret ; 0856

; seek sequence to track/beat/tick; original CS:0857
public _snd_0857
_snd_0857 label near
control_0857:
    enter 014h, 0 ; 0857
    push si ; 085B
    mov si, word ptr [bp + 4] ; 085C
    cmp byte ptr [si + 2], 0 ; 085F
    jne short control_086B ; 0863
control_0865:
    mov ax, 0FFFFh ; 0865
    pop si ; 0868
    leave ; 0869
    ret ; 086A
control_086B:
    push word ptr [bp + 6] ; 086B
    push word ptr [_snd_midi_tags+6] ; 086E
    push word ptr [_snd_midi_tags+4] ; 0872
    push word ptr [si + 4] ; 0876
    call near ptr _snd_0406 ; 0879
    add sp, 8 ; 087C
    mov word ptr [bp - 4], ax ; 087F
    mov word ptr [bp - 2], dx ; 0882
    or dx, ax ; 0885
    je short control_0865 ; 0887
    push word ptr [si + 0Ah] ; 0889
    push word ptr [_snd_midi_tags+6] ; 088C
    push word ptr [_snd_midi_tags+4] ; 0890
    push word ptr [si + 4] ; 0894
    call near ptr _snd_0406 ; 0897
    add sp, 8 ; 089A
    mov word ptr [bp - 8], ax ; 089D
    mov word ptr [bp - 6], dx ; 08A0
    or dx, ax ; 08A3
    je short control_0865 ; 08A5
    inc byte ptr [_snd_parse_nesting] ; 08A7
    cmp word ptr [bp + 8], 0 ; 08AB
    jne short control_08B6 ; 08AF
    mov word ptr [bp + 8], 1 ; 08B1
control_08B6:
    mov ax, word ptr [bp + 8] ; 08B6
    dec ax ; 08B9
    mov cx, 01E0h ; 08BA
    mul cx ; 08BD
    add ax, word ptr [bp + 0Ah] ; 08BF
    adc dx, 0 ; 08C2
    mov word ptr [bp - 0Ch], ax ; 08C5
    mov word ptr [bp - 0Ah], dx ; 08C8
    mov ax, word ptr [bp + 6] ; 08CB
    cmp word ptr [si + 0Ah], ax ; 08CE
    jne short control_08FA ; 08D1
    mov ax, word ptr [bp - 0Ch] ; 08D3
    cmp word ptr [si + 012h], dx ; 08D6
    ja short control_08FA ; 08D9
    jb short control_08E2 ; 08DB
    cmp word ptr [si + 010h], ax ; 08DD
    ja short control_08FA ; 08E0
control_08E2:
    mov ax, word ptr [si + 6] ; 08E2
    add ax, word ptr [bp - 4] ; 08E5
    mov dx, word ptr [bp - 2] ; 08E8
    mov word ptr [_snd_parse_cursor], ax ; 08EB
    mov word ptr [_snd_parse_cursor+2], dx ; 08EE
    mov ax, word ptr [si + 014h] ; 08F2
    mov dx, word ptr [si + 016h] ; 08F5
    jmp short control_090F ; 08F8
control_08FA:
    mov ax, word ptr [bp - 4] ; 08FA
    mov dx, word ptr [bp - 2] ; 08FD
    mov word ptr [_snd_parse_cursor], ax ; 0900
    mov word ptr [_snd_parse_cursor+2], dx ; 0903
    push offset _snd_parse_cursor ; 0907
    call near ptr _snd_101E ; 090A
    inc sp ; 090D
    inc sp ; 090E
control_090F:
    mov word ptr [bp - 010h], ax ; 090F
    mov word ptr [bp - 0Eh], dx ; 0912
control_0915:
    mov ax, word ptr [bp - 0Ch] ; 0915
    mov dx, word ptr [bp - 0Ah] ; 0918
    cmp word ptr [bp - 0Eh], dx ; 091B
    ja short control_094F ; 091E
    jb short control_0927 ; 0920
    cmp word ptr [bp - 010h], ax ; 0922
    jae short control_094F ; 0925
control_0927:
    push offset _snd_parse_cursor ; 0927
    call near ptr _snd_1D6D ; 092A
    inc sp ; 092D
    inc sp ; 092E
    mov ax, word ptr [_snd_parse_cursor+2] ; 092F
    or ax, word ptr [_snd_parse_cursor] ; 0932
    je short control_0948 ; 0936
    push offset _snd_parse_cursor ; 0938
    call near ptr _snd_101E ; 093B
    inc sp ; 093E
    inc sp ; 093F
    add word ptr [bp - 010h], ax ; 0940
    adc word ptr [bp - 0Eh], dx ; 0943
    jmp short control_0915 ; 0946
control_0948:
    dec byte ptr [_snd_parse_nesting] ; 0948
    jmp near ptr control_0865 ; 094C
control_094F:
    push word ptr [bp - 2] ; 094F
    push word ptr [bp - 4] ; 0952
    push word ptr [_snd_parse_cursor+2] ; 0955
    push word ptr [_snd_parse_cursor] ; 0959
    call near ptr _snd_1041 ; 095D
    add sp, 8 ; 0960
    mov word ptr [bp - 014h], ax ; 0963
    mov word ptr [bp - 012h], dx ; 0966
    mov bx, word ptr [si] ; 0969
    push word ptr [bx + 4] ; 096B
    call near ptr _snd_2209 ; 096E
    inc sp ; 0971
    inc sp ; 0972
    mov ax, word ptr [bp - 010h] ; 0973
    mov dx, word ptr [bp - 0Eh] ; 0976
    sub ax, word ptr [bp - 0Ch] ; 0979
    sbb dx, word ptr [bp - 0Ah] ; 097C
    push dx ; 097F
    push ax ; 0980
    mov ax, word ptr [bp - 014h] ; 0981
    add ax, word ptr [bp - 4] ; 0984
    mov dx, word ptr [bp - 2] ; 0987
    push dx ; 098A
    push ax ; 098B
    mov ax, word ptr [si + 6] ; 098C
    add ax, word ptr [bp - 8] ; 098F
    mov dx, word ptr [bp - 6] ; 0992
    push dx ; 0995
    push ax ; 0996
    push si ; 0997
    call near ptr _snd_12D8 ; 0998
    add sp, 0Eh ; 099B
    mov ax, word ptr [bp + 8] ; 099E
    mov word ptr [si + 0Ch], ax ; 09A1
    mov ax, word ptr [bp + 0Ah] ; 09A4
    mov word ptr [si + 0Eh], ax ; 09A7
    mov ax, word ptr [bp - 0Ch] ; 09AA
    mov dx, word ptr [bp - 0Ah] ; 09AD
    mov word ptr [si + 010h], ax ; 09B0
    mov word ptr [si + 012h], dx ; 09B3
    mov ax, word ptr [bp - 010h] ; 09B6
    mov dx, word ptr [bp - 0Eh] ; 09B9
    mov word ptr [si + 014h], ax ; 09BC
    mov word ptr [si + 016h], dx ; 09BF
    xor ax, ax ; 09C2
    mov word ptr [si + 01Ah], ax ; 09C4
    mov word ptr [si + 018h], ax ; 09C7
    mov ax, word ptr [bp - 014h] ; 09CA
    mov dx, word ptr [bp - 012h] ; 09CD
    mov word ptr [si + 6], ax ; 09D0
    mov word ptr [si + 8], dx ; 09D3
    mov ax, word ptr [bp + 6] ; 09D6
    cmp word ptr [si + 0Ah], ax ; 09D9
    je short control_09E6 ; 09DC
    mov word ptr [si + 0Ah], ax ; 09DE
    mov word ptr [si + 02Ah], 0 ; 09E1
control_09E6:
    mov byte ptr [_snd_parse_finished], 1 ; 09E6
    dec byte ptr [_snd_parse_nesting] ; 09EB
    xor ax, ax ; 09EF
    pop si ; 09F1
    leave ; 09F2
    ret ; 09F3

; scan sequence with held-note preservation; original CS:09F4
public _snd_09F4
_snd_09F4 label near
control_09F4:
    enter 010h, 0 ; 09F4
    push si ; 09F8
    mov si, word ptr [bp + 4] ; 09F9
    cmp byte ptr [si + 2], 0 ; 09FC
    jne short control_0A08 ; 0A00
control_0A02:
    xor ax, 0FFFFh ; 0A02
    pop si ; 0A05
    leave ; 0A06
    ret ; 0A07
control_0A08:
    push word ptr [bp + 6] ; 0A08
    push word ptr [_snd_midi_tags+6] ; 0A0B
    push word ptr [_snd_midi_tags+4] ; 0A0F
    push word ptr [si + 4] ; 0A13
    call near ptr _snd_0406 ; 0A16
    add sp, 8 ; 0A19
    mov word ptr [bp - 4], ax ; 0A1C
    mov word ptr [bp - 2], dx ; 0A1F
    or dx, ax ; 0A22
    je short control_0A02 ; 0A24
    inc byte ptr [_snd_parse_nesting] ; 0A26
    cmp word ptr [bp + 8], 0 ; 0A2A
    jne short control_0A35 ; 0A2E
    mov word ptr [bp + 8], 1 ; 0A30
control_0A35:
    mov ax, word ptr [bp + 8] ; 0A35
    dec ax ; 0A38
    mov cx, 01E0h ; 0A39
    mul cx ; 0A3C
    add ax, word ptr [bp + 0Ah] ; 0A3E
    adc dx, 0 ; 0A41
    mov word ptr [bp - 8], ax ; 0A44
    mov word ptr [bp - 6], dx ; 0A47
    mov bx, word ptr [si] ; 0A4A
    push word ptr [bx + 4] ; 0A4C
    call near ptr _snd_21EF ; 0A4F
    inc sp ; 0A52
    inc sp ; 0A53
    call near ptr _snd_15DF ; 0A54
    mov word ptr [_snd_scanning], 1 ; 0A57
    mov ax, word ptr [bp - 4] ; 0A5D
    mov dx, word ptr [bp - 2] ; 0A60
    mov word ptr [_snd_parse_cursor], ax ; 0A63
    mov word ptr [_snd_parse_cursor+2], dx ; 0A66
    push offset _snd_parse_cursor ; 0A6A
    call near ptr _snd_101E ; 0A6D
    inc sp ; 0A70
    inc sp ; 0A71
    mov word ptr [bp - 0Ch], ax ; 0A72
    mov word ptr [bp - 0Ah], dx ; 0A75
control_0A78:
    mov ax, word ptr [bp - 8] ; 0A78
    mov dx, word ptr [bp - 6] ; 0A7B
    cmp dx, word ptr [bp - 0Ah] ; 0A7E
    ja short control_0A8A ; 0A81
    jb short control_0ABB ; 0A83
    cmp ax, word ptr [bp - 0Ch] ; 0A85
    jbe short control_0ABB ; 0A88
control_0A8A:
    push offset _snd_parse_cursor ; 0A8A
    push word ptr [si] ; 0A8D
    call near ptr _snd_183E ; 0A8F
    add sp, 4 ; 0A92
    mov ax, word ptr [_snd_parse_cursor+2] ; 0A95
    or ax, word ptr [_snd_parse_cursor] ; 0A98
    je short control_0AAE ; 0A9C
    push offset _snd_parse_cursor ; 0A9E
    call near ptr _snd_101E ; 0AA1
    inc sp ; 0AA4
    inc sp ; 0AA5
    add word ptr [bp - 0Ch], ax ; 0AA6
    adc word ptr [bp - 0Ah], dx ; 0AA9
    jmp short control_0A78 ; 0AAC
control_0AAE:
    dec byte ptr [_snd_parse_nesting] ; 0AAE
    mov word ptr [_snd_scanning], 0 ; 0AB2
    jmp near ptr control_0A02 ; 0AB8
control_0ABB:
    push word ptr [bp - 2] ; 0ABB
    push word ptr [bp - 4] ; 0ABE
    push word ptr [_snd_parse_cursor+2] ; 0AC1
    push word ptr [_snd_parse_cursor] ; 0AC5
    call near ptr _snd_1041 ; 0AC9
    add sp, 8 ; 0ACC
    mov word ptr [bp - 010h], ax ; 0ACF
    mov word ptr [bp - 0Eh], dx ; 0AD2
    mov word ptr [_snd_scanning], 0 ; 0AD5
    push word ptr [si] ; 0ADB
    call near ptr _snd_162A ; 0ADD
    inc sp ; 0AE0
    inc sp ; 0AE1
    mov ax, word ptr [bp + 8] ; 0AE2
    mov word ptr [si + 0Ch], ax ; 0AE5
    mov ax, word ptr [bp + 0Ah] ; 0AE8
    mov word ptr [si + 0Eh], ax ; 0AEB
    mov ax, word ptr [bp - 8] ; 0AEE
    mov dx, word ptr [bp - 6] ; 0AF1
    mov word ptr [si + 010h], ax ; 0AF4
    mov word ptr [si + 012h], dx ; 0AF7
    mov ax, word ptr [bp - 0Ch] ; 0AFA
    mov dx, word ptr [bp - 0Ah] ; 0AFD
    mov word ptr [si + 014h], ax ; 0B00
    mov word ptr [si + 016h], dx ; 0B03
    xor ax, ax ; 0B06
    mov word ptr [si + 01Ah], ax ; 0B08
    mov word ptr [si + 018h], ax ; 0B0B
    mov ax, word ptr [bp - 010h] ; 0B0E
    mov dx, word ptr [bp - 0Eh] ; 0B11
    mov word ptr [si + 6], ax ; 0B14
    mov word ptr [si + 8], dx ; 0B17
    mov ax, word ptr [bp + 6] ; 0B1A
    cmp word ptr [si + 0Ah], ax ; 0B1D
    je short control_0B25 ; 0B20
    mov word ptr [si + 0Ah], ax ; 0B22
control_0B25:
    dec byte ptr [_snd_parse_nesting] ; 0B25
    xor ax, ax ; 0B29
    pop si ; 0B2B
    leave ; 0B2C
    ret ; 0B2D

; set sequence loop count and start/end beat/tick; original CS:0B2E
public _snd_0B2E
_snd_0B2E label near
control_0B2E:
    enter 0, 0 ; 0B2E
    mov dx, word ptr [bp + 8] ; 0B32
    mov ax, dx ; 0B35
    inc ax ; 0B37
    cmp ax, word ptr [bp + 0Ch] ; 0B38
    jb short control_0B42 ; 0B3B
    mov ax, 0FFFFh ; 0B3D
    leave ; 0B40
    ret ; 0B41
control_0B42:
    or dx, dx ; 0B42
    jne short control_0B47 ; 0B44
    inc dx ; 0B46
control_0B47:
    mov bx, word ptr [bp + 4] ; 0B47
    mov word ptr [bx + 02Ah], 0 ; 0B4A
    mov word ptr [bx + 02Ch], dx ; 0B4F
    mov ax, word ptr [bp + 0Ah] ; 0B52
    mov word ptr [bx + 02Eh], ax ; 0B55
    mov ax, word ptr [bp + 0Ch] ; 0B58
    mov word ptr [bx + 030h], ax ; 0B5B
    mov ax, word ptr [bp + 0Eh] ; 0B5E
    mov word ptr [bx + 032h], ax ; 0B61
    mov ax, word ptr [bp + 6] ; 0B64
    mov word ptr [bx + 02Ah], ax ; 0B67
    xor ax, ax ; 0B6A
    leave ; 0B6C
    ret ; 0B6D

; clear sequence loop count; original CS:0B6E
public _snd_0B6E
_snd_0B6E label near
control_0B6E:
    enter 0, 0 ; 0B6E
    xor ax, ax ; 0B72
    mov bx, word ptr [bp + 4] ; 0B74
    mov word ptr [bx + 02Ah], ax ; 0B77
    xor ax, ax ; 0B7A
    leave ; 0B7C
    ret ; 0B7D

; set global or per-channel hook; original CS:0B7E
public _snd_0B7E
_snd_0B7E label near
control_0B7E:
    enter 0, 0 ; 0B7E
    push di ; 0B82
    mov bl, byte ptr [bp + 6] ; 0B83
    xor bh, bh ; 0B86
    cmp bx, 5 ; 0B88
    ja short control_0BAA ; 0B8B
    shl bx, 1 ; 0B8D
    mov dx, word ptr cs:[bx + control_0B9E] ; 0B8F
    mov al, byte ptr [bp + 8] ; 0B94
    xor ah, ah ; 0B97
    mov bx, word ptr [bp + 4] ; 0B99
    jmp dx ; 0B9C
control_0B9E:
    ; 6 near destinations, indexed by twice the selector
    dw offset control_0BB0, offset control_0BB6, offset control_0BBC, offset control_0BDA
    dw offset control_0BF8, offset control_0C16
control_0BAA:
    mov ax, 0FFFFh ; 0BAA
    pop di ; 0BAD
    leave ; 0BAE
    ret ; 0BAF
control_0BB0:
    mov byte ptr [bx], al ; 0BB0
    jmp near ptr control_0C38 ; 0BB2
    nop ; 0BB5
control_0BB6:
    mov byte ptr [bx + 1], al ; 0BB6
    jmp short control_0C38 ; 0BB9
    nop ; 0BBB
control_0BBC:
    cmp byte ptr [bp + 0Ah], 010h ; 0BBC
    ja short control_0BAA ; 0BC0
    je short control_0BD0 ; 0BC2
    mov cl, byte ptr [bp + 0Ah] ; 0BC4
    xor ch, ch ; 0BC7
    add bx, cx ; 0BC9
    mov byte ptr [bx + 2], al ; 0BCB
    jmp short control_0C38 ; 0BCE
control_0BD0:
    mov ah, al ; 0BD0
    mov cx, 8 ; 0BD2
    lea di, [bx + 2] ; 0BD5
    jmp short control_0C32 ; 0BD8
control_0BDA:
    cmp byte ptr [bp + 0Ah], 010h ; 0BDA
    ja short control_0BAA ; 0BDE
    je short control_0BEE ; 0BE0
    mov cl, byte ptr [bp + 0Ah] ; 0BE2
    xor ch, ch ; 0BE5
    add bx, cx ; 0BE7
    mov byte ptr [bx + 012h], al ; 0BE9
    jmp short control_0C38 ; 0BEC
control_0BEE:
    mov ah, al ; 0BEE
    mov cx, 8 ; 0BF0
    lea di, [bx + 012h] ; 0BF3
    jmp short control_0C32 ; 0BF6
control_0BF8:
    cmp byte ptr [bp + 0Ah], 010h ; 0BF8
    ja short control_0BAA ; 0BFC
    je short control_0C0C ; 0BFE
    mov cl, byte ptr [bp + 0Ah] ; 0C00
    xor ch, ch ; 0C03
    add bx, cx ; 0C05
    mov byte ptr [bx + 022h], al ; 0C07
    jmp short control_0C38 ; 0C0A
control_0C0C:
    mov ah, al ; 0C0C
    mov cx, 8 ; 0C0E
    lea di, [bx + 022h] ; 0C11
    jmp short control_0C32 ; 0C14
control_0C16:
    cmp byte ptr [bp + 0Ah], 010h ; 0C16
    ja short control_0BAA ; 0C1A
    je short control_0C2A ; 0C1C
    mov cl, byte ptr [bp + 0Ah] ; 0C1E
    xor ch, ch ; 0C21
    add bx, cx ; 0C23
    mov byte ptr [bx + 032h], al ; 0C25
    jmp short control_0C38 ; 0C28
control_0C2A:
    mov ah, al ; 0C2A
    mov cx, 8 ; 0C2C
    lea di, [bx + 032h] ; 0C2F
control_0C32:
    mov ax, ds ; 0C32
    mov es, ax ; 0C34
    rep stosw ; 0C36
control_0C38:
    xor ax, ax ; 0C38
    pop di ; 0C3A
    leave ; 0C3B
    ret ; 0C3C

; allocate timed volume fade; original CS:0C3D
public _snd_0C3D
_snd_0C3D label near
control_0C3D:
    enter 0, 0 ; 0C3D
    push si ; 0C41
    mov si, word ptr [bp + 4] ; 0C42
    push si ; 0C45
    call near ptr _snd_1684 ; 0C46
    inc sp ; 0C49
    inc sp ; 0C4A
    cmp word ptr [bp + 8], 0 ; 0C4B
    jne short control_0C5E ; 0C4F
    mov al, byte ptr [bp + 6] ; 0C51
    push ax ; 0C54
    push si ; 0C55
    call near ptr _snd_075E ; 0C56
    add sp, 4 ; 0C59
    jmp short control_0CBE ; 0C5C
control_0C5E:
    mov byte ptr [_snd_fade_state], 1 ; 0C5E
    mov si, offset _snd_fades ; 0C63
    mov cx, 2 ; 0C66
control_0C69:
    cmp byte ptr [si], ch ; 0C69
    je short control_0C78 ; 0C6B
    add si, 010h ; 0C6D
    loop control_0C69 ; 0C70
    mov ax, 0FFFFh ; 0C72
    pop si ; 0C75
    leave ; 0C76
    ret ; 0C77
control_0C78:
    mov ax, word ptr [bp + 4] ; 0C78
    mov word ptr [si + 2], ax ; 0C7B
    mov cx, word ptr [bp + 8] ; 0C7E
    mov word ptr [si + 6], cx ; 0C81
    mov word ptr [si + 8], cx ; 0C84
    mov cx, 1 ; 0C87
    mov byte ptr [si], cl ; 0C8A
    push cx ; 0C8C
    push ax ; 0C8D
    call near ptr _snd_066B ; 0C8E
    add sp, 4 ; 0C91
    mov byte ptr [si + 4], al ; 0C94
    xor ah, ah ; 0C97
    mov bl, byte ptr [bp + 6] ; 0C99
    xor bh, bh ; 0C9C
    sub bx, ax ; 0C9E
    mov ax, bx ; 0CA0
    cwd ; 0CA2
    idiv word ptr [bp + 8] ; 0CA3
    mov byte ptr [si + 0Ah], al ; 0CA6
    mov al, 1 ; 0CA9
    or bx, bx ; 0CAB
    jge short control_0CB3 ; 0CAD
    neg dx ; 0CAF
    neg al ; 0CB1
control_0CB3:
    mov byte ptr [si + 0Bh], al ; 0CB3
    mov byte ptr [si + 0Ch], dl ; 0CB6
    mov word ptr [si + 0Eh], 0 ; 0CB9
control_0CBE:
    xor ax, ax ; 0CBE
    pop si ; 0CC0
    leave ; 0CC1
    ret ; 0CC2

; begin queued command list; original CS:0CC3
public _snd_0CC3
_snd_0CC3 label near
control_0CC3:
    enter 0, 0 ; 0CC3
    push si ; 0CC7
    mov al, byte ptr [bp + 6] ; 0CC8
    xor ah, ah ; 0CCB
    mov dx, word ptr [bp + 4] ; 0CCD
    mov si, word ptr [_snd_queue_write] ; 0CD0
    mov bx, si ; 0CD4
    shl bx, 4 ; 0CD6
    mov word ptr [bx + _snd_queue], 0 ; 0CD9
    mov word ptr [bx + _snd_queue+2], dx ; 0CDF
    mov word ptr [bx + _snd_queue+4], ax ; 0CE3
    inc si ; 0CE7
    cmp si, 040h ; 0CE8
    jl short control_0CEF ; 0CEB
    xor si, si ; 0CED
control_0CEF:
    cmp word ptr [_snd_queue_read], si ; 0CEF
    jne short control_0D0A ; 0CF3
    dec si ; 0CF5
    mov word ptr [_snd_queue_write], si ; 0CF6
    or si, si ; 0CFA
    jge short control_0D04 ; 0CFC
    mov word ptr [_snd_queue_write], 03Fh ; 0CFE
control_0D04:
    mov ax, 0FFFFh ; 0D04
    pop si ; 0D07
    leave ; 0D08
    ret ; 0D09
control_0D0A:
    mov word ptr [_snd_queue_write], si ; 0D0A
    mov word ptr [_snd_queued_sound], dx ; 0D0E
    mov byte ptr [_snd_queued_marker], al ; 0D12
    mov byte ptr [_snd_building_queue], 1 ; 0D15
    xor ax, ax ; 0D1A
    pop si ; 0D1C
    leave ; 0D1D
    ret ; 0D1E

; append queued command or close list; original CS:0D1F
public _snd_0D1F
_snd_0D1F label near
control_0D1F:
    enter 0, 0 ; 0D1F
    push si ; 0D23
    mov si, word ptr [_snd_queue_write] ; 0D24
    cmp si, word ptr [_snd_queue_read] ; 0D28
    jne short control_0D34 ; 0D2C
control_0D2E:
    mov ax, 0FFFFh ; 0D2E
    pop si ; 0D31
    leave ; 0D32
    ret ; 0D33
control_0D34:
    mov dx, word ptr [bp + 4] ; 0D34
    cmp dx, -1 ; 0D37
    jne short control_0D47 ; 0D3A
    mov byte ptr [_snd_building_queue], 0 ; 0D3C
    inc word ptr [_snd_trigger_count] ; 0D41
    jmp short control_0DA3 ; 0D45
control_0D47:
    mov bx, si ; 0D47
    shl bx, 4 ; 0D49
    mov word ptr [bx + _snd_queue], 1 ; 0D4C
    mov word ptr [bx + _snd_queue+2], dx ; 0D52
    mov ax, word ptr [bp + 6] ; 0D56
    mov word ptr [bx + _snd_queue+4], ax ; 0D59
    mov ax, word ptr [bp + 8] ; 0D5D
    mov word ptr [bx + _snd_queue+6], ax ; 0D60
    mov ax, word ptr [bp + 0Ah] ; 0D64
    mov word ptr [bx + _snd_queue+8], ax ; 0D67
    mov ax, word ptr [bp + 0Ch] ; 0D6B
    mov word ptr [bx + _snd_queue+0Ah], ax ; 0D6E
    mov ax, word ptr [bp + 0Eh] ; 0D72
    mov word ptr [bx + _snd_queue+0Ch], ax ; 0D75
    mov ax, word ptr [bp + 010h] ; 0D79
    mov word ptr [bx + _snd_queue+0Eh], ax ; 0D7C
    inc si ; 0D80
    cmp si, 040h ; 0D81
    jl short control_0D88 ; 0D84
    xor si, si ; 0D86
control_0D88:
    cmp si, word ptr [_snd_queue_read] ; 0D88
    jne short control_0D9F ; 0D8C
    dec si ; 0D8E
    mov word ptr [_snd_queue_write], si ; 0D8F
    or si, si ; 0D93
    jge short control_0D2E ; 0D95
    mov word ptr [_snd_queue_write], 03Fh ; 0D97
    jmp short control_0D2E ; 0D9D
control_0D9F:
    mov word ptr [_snd_queue_write], si ; 0D9F
control_0DA3:
    xor ax, ax ; 0DA3
    pop si ; 0DA5
    leave ; 0DA6
    ret ; 0DA7

; clear queued command state; original CS:0DA8
public _snd_0DA8
_snd_0DA8 label near
control_0DA8:
    xor ax, ax ; 0DA8
    mov byte ptr [_snd_building_queue], al ; 0DAA
    mov word ptr [_snd_queue_write], ax ; 0DAD
    mov word ptr [_snd_queue_read], ax ; 0DB0
    mov word ptr [_snd_trigger_count], ax ; 0DB3
    xor ax, ax ; 0DB6
    ret ; 0DB8
SC055E ends

SC3283 segment byte public 'CODE'
assume cs:CGROUP, ds:DGROUP

; bind player, sequence and hook storage; original CS:3283
public _snd_3283
_snd_3283 label near
control_3283:
    push si ; 3283
    mov si, offset _snd_players ; 3284
    xor cx, cx ; 3287
control_3289:
    mov byte ptr [si + 6], 0 ; 3289
    mov al, 034h ; 328D
    mul cl ; 328F
    add ax, offset _snd_sequences ; 3291
    mov word ptr [si], ax ; 3294
    mov bx, ax ; 3296
    mov word ptr [bx], si ; 3298
    mov al, 042h ; 329A
    mul cl ; 329C
    add ax, offset _snd_hooks ; 329E
    mov word ptr [si + 2], ax ; 32A1
    add si, 012h ; 32A4
    inc cx ; 32A7
    cmp cx, 2 ; 32A8
    jb short control_3289 ; 32AB
    pop si ; 32AD
    ret ; 32AE

; initialize sequences and timer period; original CS:32AF
public _snd_32AF
_snd_32AF label near
control_32AF:
    mov bx, offset _snd_sequences ; 32AF
    mov cx, 2 ; 32B2
    xor ax, ax ; 32B5
control_32B7:
    mov byte ptr [bx + 2], al ; 32B7
    add bx, 034h ; 32BA
    loop control_32B7 ; 32BD
    mov word ptr [_snd_tick_period], 08C77h ; 32BF
    mov word ptr [_snd_tick_period+2], 024h ; 32C5
    mov byte ptr [_snd_parse_nesting], al ; 32CB
    ret ; 32CE

; initialize held-note free list; original CS:32CF
public _snd_32CF
_snd_32CF label near
control_32CF:
    xor ax, ax ; 32CF
    mov word ptr [_snd_held_cursor], ax ; 32D1
    mov word ptr [_snd_held_active], ax ; 32D4
    mov bx, offset _snd_held_notes ; 32D7
    mov cx, 018h ; 32DA
control_32DD:
    mov word ptr [bx + 2], ax ; 32DD
    mov ax, bx ; 32E0
    add bx, 014h ; 32E2
    loop control_32DD ; 32E5
    mov word ptr [_snd_held_free], ax ; 32E7
    ret ; 32EA

; initialize fade slots; original CS:32EB
public _snd_32EB
_snd_32EB label near
control_32EB:
    mov bx, offset _snd_fades ; 32EB
    mov cx, 2 ; 32EE
control_32F1:
    mov byte ptr [bx], ch ; 32F1
    add bx, 010h ; 32F3
    loop control_32F1 ; 32F6
    mov byte ptr [_snd_fade_state], cl ; 32F8
    mov word ptr [_snd_fade_tick_scale], 1 ; 32FC
    ret ; 3302

; initialize part/instrument links and voices; original CS:3303
public _snd_3303
_snd_3303 label near
control_3303:
    push si ; 3303
    mov si, offset _snd_parts ; 3304
    xor cx, cx ; 3307
control_3309:
    xor ax, ax ; 3309
    mov word ptr [si], ax ; 330B
    mov word ptr [si + 2], ax ; 330D
    mov word ptr [si + 4], ax ; 3310
    mov word ptr [si + 6], ax ; 3313
    mov al, 01Eh ; 3316
    mul cl ; 3318
    add ax, offset _snd_part_instruments ; 331A
    mov word ptr [si + 8], ax ; 331D
    add si, 020h ; 3320
    inc cx ; 3323
    cmp cx, 020h ; 3324
    jb short control_3309 ; 3327
    push cs ; 3329
    call near ptr _snd_1DDB ; 332A
    pop si ; 332D
    ret ; 332E

; build volume-product lookup table; original CS:332F
public _snd_332F
_snd_332F label near
control_332F:
    push si ; 332F
    xor si, si ; 3330
    xor cx, cx ; 3332
control_3334:
    xor bx, bx ; 3334
    mov dx, cx ; 3336
control_3338:
    mov ax, dx ; 3338
    sar ax, 5 ; 333A
    mov byte ptr [bx + si + _snd_volume_products], al ; 333D
    add dx, cx ; 3341
    inc bx ; 3343
    cmp bx, 020h ; 3344
    jl short control_3338 ; 3347
    inc cx ; 3349
    add si, 020h ; 334A
    cmp si, 0800h ; 334D
    jl short control_3334 ; 3351
    mov bx, offset _snd_volume_products ; 3353
    mov cx, 040h ; 3356
control_3359:
    mov byte ptr [bx], ch ; 3359
    add bx, 020h ; 335B
    loop control_3359 ; 335E
    pop si ; 3360
    ret ; 3361

; initialize command queue; original CS:3362
public _snd_3362
_snd_3362 label near
control_3362:
    xor ax, ax ; 3362
    mov byte ptr [_snd_building_queue], al ; 3364
    mov word ptr [_snd_queue_write], ax ; 3367
    mov word ptr [_snd_queue_read], ax ; 336A
    mov word ptr [_snd_trigger_count], ax ; 336D
    ret ; 3370
SC3283 ends

_DATA segment word public 'DATA'
extrn _snd_basic_commands:byte
extrn _snd_building_queue:byte
extrn _snd_command_kinds:byte
extrn _snd_disabled:byte
extrn _snd_extended_commands:byte
extrn _snd_fade_state:byte
extrn _snd_fade_tick_scale:byte
extrn _snd_fades:byte
extrn _snd_held_active:byte
extrn _snd_held_cursor:byte
extrn _snd_held_free:byte
extrn _snd_held_notes:byte
extrn _snd_hooks:byte
extrn _snd_master_volume:byte
extrn _snd_midi_tags:byte
extrn _snd_parse_cursor:byte
extrn _snd_parse_finished:byte
extrn _snd_parse_nesting:byte
extrn _snd_part_instruments:byte
extrn _snd_parts:byte
extrn _snd_paused:byte
extrn _snd_players:byte
extrn _snd_queue:byte
extrn _snd_queue_read:byte
extrn _snd_queue_write:byte
extrn _snd_queued_marker:byte
extrn _snd_queued_sound:byte
extrn _snd_resources:byte
extrn _snd_scanning:byte
extrn _snd_sequences:byte
extrn _snd_tick_period:byte
extrn _snd_trigger_count:byte
extrn _snd_volume_products:byte
_DATA ends
_BSS segment word public 'BSS'
_BSS ends
DGROUP group _DATA, _BSS
CGROUP group SC000C, SC00FE, SC04B8, SC055E, SC3283
end
