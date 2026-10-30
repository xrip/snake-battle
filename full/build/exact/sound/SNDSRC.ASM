; Symbolic SOUND specification; not a historical-source claim.
; Recovered ordinary C is retained separately; compiler matching is pending.
.286p
.287
_DATA segment word public 'DATA'
extrn _snd_basic_commands:BYTE
extrn _snd_building_queue:BYTE
extrn _snd_carrier_slots:BYTE
extrn _snd_channel_frequency:WORD
extrn _snd_channel_masks:BYTE
extrn _snd_command_kinds:BYTE
extrn _snd_default_instrument:BYTE
extrn _snd_disabled:BYTE
extrn _snd_event_channel:BYTE
extrn _snd_event_note:BYTE
extrn _snd_event_velocity:BYTE
extrn _snd_extended_commands:BYTE
extrn _snd_fade_state:BYTE
extrn _snd_fade_tick_scale:BYTE
extrn _snd_fades:BYTE
extrn _snd_frequencies:BYTE
extrn _snd_global_instruments:BYTE
extrn _snd_held_active:BYTE
extrn _snd_held_cursor:BYTE
extrn _snd_held_free:BYTE
extrn _snd_held_notes:BYTE
extrn _snd_hooks:BYTE
extrn _snd_instrument_fields:BYTE
extrn _snd_master_volume:BYTE
extrn _snd_max_values:BYTE
extrn _snd_midi_lengths:BYTE
extrn _snd_midi_tags:BYTE
extrn _snd_modulator_slots:BYTE
extrn _snd_note_channels:BYTE
extrn _snd_octaves:BYTE
extrn _snd_opl_cache:BYTE
extrn _snd_opl_data_delay:WORD
extrn _snd_opl_index_delay:WORD
extrn _snd_parameter_map:BYTE
extrn _snd_parse_cursor:BYTE
extrn _snd_parse_finished:BYTE
extrn _snd_parse_nesting:BYTE
extrn _snd_part_instruments:BYTE
extrn _snd_parts:BYTE
extrn _snd_paused:BYTE
extrn _snd_players:BYTE
extrn _snd_queue:BYTE
extrn _snd_queue_read:BYTE
extrn _snd_queue_write:BYTE
extrn _snd_queued_marker:BYTE
extrn _snd_queued_sound:BYTE
extrn _snd_random_seed:BYTE
extrn _snd_register_fields:BYTE
extrn _snd_resources:BYTE
extrn _snd_scan_end_tick:BYTE
extrn _snd_scan_note_count:BYTE
extrn _snd_scanning:BYTE
extrn _snd_semitones:BYTE
extrn _snd_sequences:BYTE
extrn _snd_step_counts:BYTE
extrn _snd_sysex_buffer:BYTE
extrn _snd_tick_period:BYTE
extrn _snd_timer_accumulator:WORD
extrn _snd_trigger_count:BYTE
extrn _snd_voice_counter:BYTE
extrn _snd_voice_tick:BYTE
extrn _snd_voices:BYTE
extrn _snd_volume_products:BYTE
_DATA ends
_BSS segment word public 'BSS'
_BSS ends
DGROUP group _DATA, _BSS
SOUND_TEXT segment word public 'CODE'
assume cs:SOUND_TEXT, ds:DGROUP, ss:DGROUP

; exact/CONTROL.ASM SC000C 000C..006E
public _snd_000C
public _snd_001E
public _snd_0022
public _snd_0026
public _snd_002A
public _snd_0039
public _snd_0048
public _snd_0057

; far initialize wrapper; original CS:000C
_snd_000C label far
X_000C_control_000C:
    enter 0, 0 ; 000C
    push word ptr [bp + 8] ; 0010
    push word ptr [bp + 6] ; 0013
    call near ptr _snd_0158 ; 0016
    add sp, 4 ; 0019
    leave ; 001C
    retf ; 001D

; far shutdown wrapper; original CS:001E
_snd_001E label far
X_000C_control_001E:
    call near ptr _snd_01A7 ; 001E
    retf ; 0021

; far pause wrapper; original CS:0022
_snd_0022 label far
X_000C_control_0022:
    call near ptr _snd_01CB ; 0022
    retf ; 0025

; far resume wrapper; original CS:0026
_snd_0026 label far
X_000C_control_0026:
    call near ptr _snd_01D5 ; 0026
    retf ; 0029

; far start-sound wrapper; original CS:002A
_snd_002A label far
X_000C_control_002A:
    enter 0, 0 ; 002A
    push word ptr [bp + 6] ; 002E
    call near ptr _snd_021C ; 0031
    add sp, 2 ; 0034
    leave ; 0037
    retf ; 0038

; far stop-sound wrapper; original CS:0039
_snd_0039 label far
X_000C_control_0039:
    enter 0, 0 ; 0039
    push word ptr [bp + 6] ; 003D
    call near ptr _snd_0269 ; 0040
    add sp, 2 ; 0043
    leave ; 0046
    retf ; 0047

; far sound-status wrapper; original CS:0048
_snd_0048 label far
X_000C_control_0048:
    enter 0, 0 ; 0048
    push word ptr [bp + 6] ; 004C
    call near ptr _snd_02B7 ; 004F
    add sp, 2 ; 0052
    leave ; 0055
    retf ; 0056

; far fade wrapper; original CS:0057
_snd_0057 label far
X_000C_control_0057:
    enter 0, 0 ; 0057
    push word ptr [bp + 0Ah] ; 005B
    push word ptr [bp + 8] ; 005E
    push word ptr [bp + 6] ; 0061
    push 0Dh ; 0064
    call near ptr _snd_02E4 ; 0066
    add sp, 8 ; 0069
    leave ; 006C
    retf ; 006D

; SNDIRQ.ASM _TEXT 006E..00FE
public _snd_isr_count
public _snd_old_int8
public _snd_0074
public _snd_00B4
public _snd_00E7
_snd_isr_count dw 0
_snd_old_int8 dd 0
_snd_0074 label near
    pusha
    push ds
    push es
    inc word ptr cs:_snd_isr_count
    cmp word ptr cs:_snd_isr_count,1
    jne short X_006E_nested_irq
    mov ax,DGROUP
    mov ds,ax
X_006E_next_pending_tick:
    add word ptr _snd_timer_accumulator,0174dh
    jnc short X_006E_acknowledge_pic
    pushf
    call dword ptr cs:_snd_old_int8
    jmp short X_006E_run_tick
X_006E_acknowledge_pic:
    mov al,020h
    out 020h,al
X_006E_run_tick:
    sti
    call near ptr _snd_055E
    dec word ptr cs:_snd_isr_count
    jne short X_006E_next_pending_tick
    pop es
    pop ds
    popa
    iret
X_006E_nested_irq:
    mov al,020h
    out 020h,al
    pop es
    pop ds
    popa
    iret
_snd_00B4 label near
    push ds
    push es
    mov ax,03508h
    int 021h
    mov word ptr cs:_snd_old_int8,bx
    mov word ptr cs:_snd_old_int8+2,es
    mov ax,cs
    mov ds,ax
    mov dx,offset _snd_0074
    mov ax,02508h
    int 021h
    mov al,034h
    out 043h,al
    mov ax,0174dh
    out 040h,al
    mov al,ah
    out 040h,al
    xor ax,ax
    mov word ptr cs:_snd_isr_count,ax
    pop es
    pop ds
    ret
_snd_00E7 label near
    push ds
    xor ax,ax
    out 040h,al
    mov al,ah
    out 040h,al
    lds dx,dword ptr cs:_snd_old_int8
    mov ax,02508h
    int 021h
    xor ax,ax
    pop ds
    ret

; exact/CONTROL.ASM SC00FE 00FE..0496
public _snd_00FE
public _snd_0158
public _snd_01A7
public _snd_01CB
public _snd_01D5
public _snd_01DC
public _snd_0217
public _snd_021C
public _snd_0269
public _snd_029B
public _snd_02B7
public _snd_02E4
public _snd_0406

; command dispatcher; original CS:00FE
_snd_00FE label far
X_00FE_control_00FE:
    enter 0, 0 ; 00FE
    push si ; 0102
    mov al, byte ptr [bp + 7] ; 0103
    mov si, word ptr [bp + 6] ; 0106
    and si, 0FFh ; 0109
    cmp al, 1 ; 010D
    ja short X_00FE_control_0132 ; 010F
    je short X_00FE_control_0138 ; 0111
    cmp si, 0Eh ; 0113
    jae short X_00FE_control_0132 ; 0116
    shl si, 1 ; 0118
    mov ax, word ptr [si + _snd_basic_commands] ; 011A
    or ax, ax ; 011E
    je short X_00FE_control_0132 ; 0120
    push word ptr [bp + 0Ch] ; 0122
    push word ptr [bp + 0Ah] ; 0125
    push word ptr [bp + 8] ; 0128
    call ax ; 012B
    add sp, 6 ; 012D
    jmp short X_00FE_control_0155 ; 0130
X_00FE_control_0132:
    mov ax, 0FFFFh ; 0132
    cwd ; 0135
    jmp short X_00FE_control_0155 ; 0136
X_00FE_control_0138:
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
X_00FE_control_0155:
    pop si ; 0155
    leave ; 0156
    retf ; 0157

; initialize sound system; original CS:0158
_snd_0158 label near
X_00FE_control_0158:
    enter 0, 0 ; 0158
    call near ptr _snd_320A ; 015C
    or ax, ax ; 015F
    jne short X_00FE_control_01A1 ; 0161
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
X_00FE_control_01A1:
    mov ax, 0FFFFh ; 01A1
    cwd ; 01A4
    leave ; 01A5
    ret ; 01A6

; shutdown sound system; original CS:01A7
_snd_01A7 label near
X_00FE_control_01A7:
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
_snd_01CB label near
X_00FE_control_01CB:
    mov word ptr [_snd_paused], 1 ; 01CB
    xor ax, ax ; 01D1
    cwd ; 01D3
    ret ; 01D4

; resume sequence advancement; original CS:01D5
_snd_01D5 label near
X_00FE_control_01D5:
    xor ax, ax ; 01D5
    mov word ptr [_snd_paused], ax ; 01D7
    cwd ; 01DA
    ret ; 01DB

; set master volume; original CS:01DC
_snd_01DC label near
X_00FE_control_01DC:
    enter 0, 0 ; 01DC
    push di ; 01E0
    push si ; 01E1
    cmp byte ptr [bp + 4], 07Fh ; 01E2
    jbe short X_00FE_control_01EC ; 01E6
    mov byte ptr [bp + 4], 07Fh ; 01E8
X_00FE_control_01EC:
    mov al, byte ptr [bp + 4] ; 01EC
    cbw ; 01EF
    mov word ptr [_snd_master_volume], ax ; 01F0
    mov si, offset _snd_players ; 01F3
    mov di, 2 ; 01F6
X_00FE_control_01F9:
    cmp byte ptr [si + 6], 0 ; 01F9
    je short X_00FE_control_020A ; 01FD
    mov al, byte ptr [si + 0Dh] ; 01FF
    push ax ; 0202
    push si ; 0203
    call near ptr _snd_075E ; 0204
    add sp, 4 ; 0207
X_00FE_control_020A:
    add si, 012h ; 020A
    dec di ; 020D
    jne short X_00FE_control_01F9 ; 020E
    xor ax, ax ; 0210
    cwd ; 0212
    pop si ; 0213
    pop di ; 0214
    leave ; 0215
    ret ; 0216

; get master volume; original CS:0217
_snd_0217 label near
X_00FE_control_0217:
    mov ax, word ptr [_snd_master_volume] ; 0217
    cwd ; 021A
    ret ; 021B

; start sound; original CS:021C
_snd_021C label near
X_00FE_control_021C:
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
    je short X_00FE_control_0261 ; 0238
    push 080h ; 023A
    call near ptr _snd_05A6 ; 023D
    inc sp ; 0240
    inc sp ; 0241
    or ax, ax ; 0242
    je short X_00FE_control_0261 ; 0244
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
    je short X_00FE_control_0261 ; 0258
    xor ax, ax ; 025A
    cwd ; 025C
    pop si ; 025D
    pop di ; 025E
    leave ; 025F
    ret ; 0260
X_00FE_control_0261:
    mov ax, 0FFFFh ; 0261
    cwd ; 0264
    pop si ; 0265
    pop di ; 0266
    leave ; 0267
    ret ; 0268

; stop matching sound; original CS:0269
_snd_0269 label near
X_00FE_control_0269:
    enter 0, 0 ; 0269
    push di ; 026D
    push si ; 026E
    mov si, offset _snd_players ; 026F
    mov di, 0FFFFh ; 0272
X_00FE_control_0275:
    cmp byte ptr [si + 6], 1 ; 0275
    jne short X_00FE_control_028B ; 0279
    mov ax, word ptr [bp + 4] ; 027B
    cmp ax, word ptr [si + 8] ; 027E
    jne short X_00FE_control_028B ; 0281
    push si ; 0283
    call near ptr _snd_0643 ; 0284
    inc sp ; 0287
    inc sp ; 0288
    xor di, di ; 0289
X_00FE_control_028B:
    add si, 012h ; 028B
    cmp si, offset _snd_players+36 ; 028E
    jb short X_00FE_control_0275 ; 0292
    mov ax, di ; 0294
    cwd ; 0296
    pop si ; 0297
    pop di ; 0298
    leave ; 0299
    ret ; 029A

; stop all sounds; original CS:029B
_snd_029B label near
X_00FE_control_029B:
    push si ; 029B
    call near ptr _snd_0DA8 ; 029C
    mov si, offset _snd_players ; 029F
X_00FE_control_02A2:
    push si ; 02A2
    call near ptr _snd_0643 ; 02A3
    add sp, 2 ; 02A6
    add si, 012h ; 02A9
    cmp si, offset _snd_players+36 ; 02AC
    jb short X_00FE_control_02A2 ; 02B0
    xor ax, ax ; 02B2
    cwd ; 02B4
    pop si ; 02B5
    ret ; 02B6

; test sound activity; original CS:02B7
_snd_02B7 label near
X_00FE_control_02B7:
    enter 0, 0 ; 02B7
    mov bx, offset _snd_players ; 02BB
    mov dx, word ptr [bp + 4] ; 02BE
    mov cx, 2 ; 02C1
X_00FE_control_02C4:
    cmp byte ptr [bx + 6], 1 ; 02C4
    jne short X_00FE_control_02CF ; 02C8
    cmp word ptr [bx + 8], dx ; 02CA
    je short X_00FE_control_02DE ; 02CD
X_00FE_control_02CF:
    add bx, 012h ; 02CF
    loop X_00FE_control_02C4 ; 02D2
    push dx ; 02D4
    call near ptr _snd_17FC ; 02D5
    add sp, 2 ; 02D8
    cwd ; 02DB
    leave ; 02DC
    ret ; 02DD
X_00FE_control_02DE:
    mov ax, 1 ; 02DE
    cwd ; 02E1
    leave ; 02E2
    ret ; 02E3

; dispatch extended command by argument kind; original CS:02E4
_snd_02E4 label near
X_00FE_control_02E4:
    enter 0, 0 ; 02E4
    push si ; 02E8
    mov dx, word ptr [bp + 4] ; 02E9
    cmp dx, 018h ; 02EC
    jl short X_00FE_control_02F4 ; 02EF
    jmp near ptr X_00FE_control_0400 ; 02F1
X_00FE_control_02F4:
    mov bx, dx ; 02F4
    shl bx, 1 ; 02F6
    mov si, word ptr [bx + _snd_extended_commands] ; 02F8
    or si, si ; 02FC
    jne short X_00FE_control_0303 ; 02FE
    jmp near ptr X_00FE_control_0400 ; 0300
X_00FE_control_0303:
    mov bx, dx ; 0303
    mov al, byte ptr [bx + _snd_command_kinds] ; 0305
    xor ah, ah ; 0309
    shl ax, 1 ; 030B
    xchg bx, ax ; 030D
    jmp word ptr cs:[bx + X_00FE_control_0314] ; 030E
    nop ; 0313
X_00FE_control_0314:
    ; 7 near destinations, indexed by twice the selector
    dw offset X_00FE_control_0322, offset X_00FE_control_0340, offset X_00FE_control_0360, offset X_00FE_control_038E
    dw offset X_00FE_control_03AA, offset X_00FE_control_03CE, offset X_00FE_control_03E4
X_00FE_control_0322:
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
X_00FE_control_0340:
    push word ptr [bp + 6] ; 0340
    call near ptr _snd_0574 ; 0343
    add sp, 2 ; 0346
    or ax, ax ; 0349
    jne short X_00FE_control_0350 ; 034B
    jmp near ptr X_00FE_control_0400 ; 034D
X_00FE_control_0350:
    push word ptr [bp + 0Ah] ; 0350
    push word ptr [bp + 8] ; 0353
    push ax ; 0356
    call si ; 0357
    add sp, 6 ; 0359
    pop si ; 035C
    leave ; 035D
    ret ; 035E
    nop ; 035F
X_00FE_control_0360:
    push word ptr [bp + 6] ; 0360
    call near ptr _snd_0574 ; 0363
    add sp, 2 ; 0366
    or ax, ax ; 0369
    jne short X_00FE_control_0370 ; 036B
    jmp near ptr X_00FE_control_0400 ; 036D
X_00FE_control_0370:
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
X_00FE_control_038E:
    push word ptr [bp + 6] ; 038E
    call near ptr _snd_0574 ; 0391
    add sp, 2 ; 0394
    or ax, ax ; 0397
    je short X_00FE_control_0400 ; 0399
    push word ptr [bp + 0Ah] ; 039B
    push word ptr [bp + 8] ; 039E
    push ax ; 03A1
    call si ; 03A2
    add sp, 6 ; 03A4
    pop si ; 03A7
    leave ; 03A8
    ret ; 03A9
X_00FE_control_03AA:
    push word ptr [bp + 6] ; 03AA
    call near ptr _snd_0574 ; 03AD
    add sp, 2 ; 03B0
    or ax, ax ; 03B3
    je short X_00FE_control_0400 ; 03B5
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
X_00FE_control_03CE:
    xor ax, ax ; 03CE
    or ax, ax ; 03D0
    je short X_00FE_control_0400 ; 03D2
    push word ptr [bp + 8] ; 03D4
    push word ptr [bp + 6] ; 03D7
    push ax ; 03DA
    call si ; 03DB
    add sp, 6 ; 03DD
    pop si ; 03E0
    leave ; 03E1
    ret ; 03E2
    nop ; 03E3
X_00FE_control_03E4:
    xor ax, ax ; 03E4
    or ax, ax ; 03E6
    je short X_00FE_control_0400 ; 03E8
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
X_00FE_control_0400:
    mov ax, 0FFFFh ; 0400
    pop si ; 0403
    leave ; 0404
    ret ; 0405

; locate MIDI chunk in resource; original CS:0406
_snd_0406 label near
X_00FE_control_0406:
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
    je short X_00FE_control_0447 ; 0425
    les bx, dword ptr [bp - 4] ; 0427
    cmp word ptr es:[bx], 0544Dh ; 042A
    jne short X_00FE_control_0447 ; 042F
    cmp word ptr es:[bx + 2], 06468h ; 0431
    jne short X_00FE_control_0447 ; 0437
    add bx, 8 ; 0439
    cmp word ptr [bp + 8], 06468h ; 043C
    jne short X_00FE_control_044C ; 0441
    mov ax, bx ; 0443
    leave ; 0445
    ret ; 0446
X_00FE_control_0447:
    xor ax, ax ; 0447
    cwd ; 0449
    leave ; 044A
    ret ; 044B
X_00FE_control_044C:
    mov ax, word ptr es:[bx + 2] ; 044C
    xchg al, ah ; 0450
    cmp ax, word ptr [bp + 0Ah] ; 0452
    ja short X_00FE_control_045C ; 0455
    mov word ptr [bp + 0Ah], 0 ; 0457
X_00FE_control_045C:
    add word ptr [bp - 4], 4 ; 045C
    push word ptr [bp - 2] ; 0460
    push word ptr [bp - 4] ; 0463
    call near ptr _snd_04B8 ; 0466
    add sp, 4 ; 0469
    add ax, 4 ; 046C
    add word ptr [bp - 4], ax ; 046F
    les bx, dword ptr [bp - 4] ; 0472
    dec word ptr [bp + 0Ah] ; 0475
    jns short X_00FE_control_045C ; 0478
    mov ax, word ptr es:[bx] ; 047A
    mov dx, word ptr es:[bx + 2] ; 047D
    cmp ax, word ptr [bp + 6] ; 0481
    jne short X_00FE_control_0447 ; 0484
    cmp dx, word ptr [bp + 8] ; 0486
    jne short X_00FE_control_0447 ; 0489
    mov ax, word ptr [bp - 4] ; 048B
    mov dx, word ptr [bp - 2] ; 048E
    add ax, 8 ; 0491
    leave ; 0494
    ret ; 0495

; SNDWAIT.ASM _TEXT 0496..04B8
public _snd_0496
_snd_0496 label near
    push ax
    push cx
X_0496_next_wait:
    or bx,bx
    jz short X_0496_wait_done
    mov cx,041h
    xor ax,ax
X_0496_next_toggle:
    jmp short X_0496_delay1
X_0496_delay1:
    jmp short X_0496_delay2
X_0496_delay2:
    in al,061h
    and al,010h
    cmp al,ah
    je short X_0496_next_toggle
    xor ah,010h
    loop X_0496_next_toggle
    dec bx
    jmp short X_0496_next_wait
X_0496_wait_done:
    pop cx
    pop ax
    ret

; exact/CONTROL.ASM SC04B8 04B8..053D
public _snd_04B8
public _snd_04CC
public _snd_04D9
public _snd_04F4

; read big-endian far dword; original CS:04B8
_snd_04B8 label near
X_04B8_control_04B8:
    enter 0, 0 ; 04B8
    les bx, dword ptr [bp + 4] ; 04BC
    mov dx, word ptr es:[bx] ; 04BF
    mov ax, word ptr es:[bx + 2] ; 04C2
    xchg dl, dh ; 04C6
    xchg al, ah ; 04C8
    leave ; 04CA
    ret ; 04CB

; read big-endian near word; original CS:04CC
_snd_04CC label near
X_04B8_control_04CC:
    enter 0, 0 ; 04CC
    mov bx, word ptr [bp + 4] ; 04D0
    mov ax, word ptr [bx] ; 04D3
    xchg al, ah ; 04D5
    leave ; 04D7
    ret ; 04D8

; clamp signed value; original CS:04D9
_snd_04D9 label near
X_04B8_control_04D9:
    enter 0, 0 ; 04D9
    mov dx, word ptr [bp + 4] ; 04DD
    mov bx, word ptr [bp + 6] ; 04E0
    cmp bx, dx ; 04E3
    jg short X_04B8_control_04EE ; 04E5
    mov bx, word ptr [bp + 8] ; 04E7
    cmp bx, dx ; 04EA
    jge short X_04B8_control_04F0 ; 04EC
X_04B8_control_04EE:
    mov dx, bx ; 04EE
X_04B8_control_04F0:
    mov ax, dx ; 04F0
    leave ; 04F2
    ret ; 04F3

; wrap note value in octaves; original CS:04F4
_snd_04F4 label near
X_04B8_control_04F4:
    enter 0, 0 ; 04F4
    mov bx, word ptr [bp + 4] ; 04F8
    cmp bx, word ptr [bp + 6] ; 04FB
    jg short X_04B8_control_051A ; 04FE
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
X_04B8_control_051A:
    cmp word ptr [bp + 8], bx ; 051A
    jge short X_04B8_control_0539 ; 051D
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
X_04B8_control_0539:
    mov ax, bx ; 0539
    leave ; 053B
    ret ; 053C

; SNDMEM.ASM _TEXT 053D..055E
public _snd_053D
_snd_053D label near
    enter 0,0
    push di
    push si
    mov si,[bp+6]
    mov di,[bp+4]
    mov cx,[bp+8]
    mov ax,ds
    mov es,ax
    shr cx,1
    rep movsw
    adc cx,cx
    rep movsb
    mov ax,cx
    pop si
    pop di
    leave
    ret

; exact/CONTROL.ASM SC055E 055E..0DB9
public _snd_055E
public _snd_0574
public _snd_05A6
public _snd_05E8
public _snd_0643
public _snd_066B
public _snd_0743
public _snd_075E
public _snd_078F
public _snd_07AA
public _snd_07F9
public _snd_0814
public _snd_0857
public _snd_09F4
public _snd_0B2E
public _snd_0B6E
public _snd_0B7E
public _snd_0C3D
public _snd_0CC3
public _snd_0D1F
public _snd_0DA8

; timer work dispatcher; original CS:055E
_snd_055E label near
X_055E_control_055E:
    mov ax, word ptr [_snd_disabled] ; 055E
    or ax, word ptr [_snd_paused] ; 0561
    jne short X_055E_control_0573 ; 0565
    call near ptr _snd_0E7C ; 0567
    call near ptr _snd_1263 ; 056A
    call near ptr _snd_1E1A ; 056D
    call near ptr _snd_16A5 ; 0570
X_055E_control_0573:
    ret ; 0573

; find unique matching player; original CS:0574
_snd_0574 label near
X_055E_control_0574:
    enter 0, 0 ; 0574
    push di ; 0578
    mov ax, word ptr [bp + 4] ; 0579
    mov dx, 0FFFFh ; 057C
    mov bx, offset _snd_players ; 057F
    mov cx, 2 ; 0582
X_055E_control_0585:
    cmp byte ptr [bx + 6], 1 ; 0585
    jne short X_055E_control_0593 ; 0589
    cmp ax, word ptr [bx + 8] ; 058B
    jne short X_055E_control_0593 ; 058E
    mov di, bx ; 0590
    inc dx ; 0592
X_055E_control_0593:
    add bx, 012h ; 0593
    loop X_055E_control_0585 ; 0596
    or dx, dx ; 0598
    je short X_055E_control_05A1 ; 059A
    xor ax, ax ; 059C
    pop di ; 059E
    leave ; 059F
    ret ; 05A0
X_055E_control_05A1:
    mov ax, di ; 05A1
    pop di ; 05A3
    leave ; 05A4
    ret ; 05A5

; choose idle or lower-priority player; original CS:05A6
_snd_05A6 label near
X_055E_control_05A6:
    enter 0, 0 ; 05A6
    push si ; 05AA
    mov si, offset _snd_players ; 05AB
    xor cx, cx ; 05AE
    xor dx, dx ; 05B0
    mov ah, 0FFh ; 05B2
X_055E_control_05B4:
    cmp byte ptr [si + 6], 0 ; 05B4
    je short X_055E_control_05DE ; 05B8
    cmp byte ptr [si + 6], 1 ; 05BA
    jne short X_055E_control_05CB ; 05BE
    mov al, byte ptr [si + 0Ch] ; 05C0
    cmp al, ah ; 05C3
    ja short X_055E_control_05CB ; 05C5
    mov ah, al ; 05C7
    mov cx, si ; 05C9
X_055E_control_05CB:
    add si, 012h ; 05CB
    inc dx ; 05CE
    cmp dx, 2 ; 05CF
    jl short X_055E_control_05B4 ; 05D2
    cmp byte ptr [bp + 4], ah ; 05D4
    jb short X_055E_control_05E3 ; 05D7
    mov ax, cx ; 05D9
    pop si ; 05DB
    leave ; 05DC
    ret ; 05DD
X_055E_control_05DE:
    mov ax, si ; 05DE
    pop si ; 05E0
    leave ; 05E1
    ret ; 05E2
X_055E_control_05E3:
    xor ax, ax ; 05E3
    pop si ; 05E5
    leave ; 05E6
    ret ; 05E7

; initialize selected player; original CS:05E8
_snd_05E8 label near
X_055E_control_05E8:
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
    jne short X_055E_control_063F ; 0638
    xor ax, ax ; 063A
    mov byte ptr [si + 6], al ; 063C
X_055E_control_063F:
    pop si ; 063F
    pop di ; 0640
    leave ; 0641
    ret ; 0642

; release selected player; original CS:0643
_snd_0643 label near
X_055E_control_0643:
    enter 0, 0 ; 0643
    push si ; 0647
    mov si, word ptr [bp + 4] ; 0648
    cmp byte ptr [si + 6], 1 ; 064B
    jne short X_055E_control_0668 ; 064F
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
X_055E_control_0668:
    pop si ; 0668
    leave ; 0669
    ret ; 066A

; query player or sequence property; original CS:066B
_snd_066B label near
X_055E_control_066B:
    enter 0, 0 ; 066B
    mov bx, word ptr [bp + 6] ; 066F
    cmp bx, 017h ; 0672
    ja short X_055E_control_06B6 ; 0675
    shl bx, 1 ; 0677
    mov dx, word ptr cs:[bx + X_055E_control_0686] ; 0679
    xor ax, ax ; 067E
    mov bx, word ptr [bp + 4] ; 0680
    jmp dx ; 0683
    nop ; 0685
X_055E_control_0686:
    ; 24 near destinations, indexed by twice the selector
    dw offset X_055E_control_06BC, offset X_055E_control_06C2, offset X_055E_control_06C8, offset X_055E_control_06CE
    dw offset X_055E_control_06D4, offset X_055E_control_06DA, offset X_055E_control_06E2, offset X_055E_control_06EA
    dw offset X_055E_control_06F2, offset X_055E_control_06FA, offset X_055E_control_0702, offset X_055E_control_070A
    dw offset X_055E_control_0712, offset X_055E_control_071A, offset X_055E_control_0722, offset X_055E_control_0722
    dw offset X_055E_control_0722, offset X_055E_control_0722, offset X_055E_control_0732, offset X_055E_control_0732
    dw offset X_055E_control_0732, offset X_055E_control_0732, offset X_055E_control_0732, offset X_055E_control_0732
X_055E_control_06B6:
    mov ax, 0FFFFh ; 06B6
    leave ; 06B9
    ret ; 06BA
    nop ; 06BB
X_055E_control_06BC:
    mov al, byte ptr [bx + 0Ch] ; 06BC
    leave ; 06BF
    ret ; 06C0
    nop ; 06C1
X_055E_control_06C2:
    mov al, byte ptr [bx + 0Dh] ; 06C2
    leave ; 06C5
    ret ; 06C6
    nop ; 06C7
X_055E_control_06C8:
    mov al, byte ptr [bx + 0Fh] ; 06C8
    leave ; 06CB
    ret ; 06CC
    nop ; 06CD
X_055E_control_06CE:
    mov al, byte ptr [bx + 010h] ; 06CE
    leave ; 06D1
    ret ; 06D2
    nop ; 06D3
X_055E_control_06D4:
    mov al, byte ptr [bx + 011h] ; 06D4
    leave ; 06D7
    ret ; 06D8
    nop ; 06D9
X_055E_control_06DA:
    mov bx, word ptr [bx] ; 06DA
    mov al, byte ptr [bx + 024h] ; 06DC
    leave ; 06DF
    ret ; 06E0
    nop ; 06E1
X_055E_control_06E2:
    mov bx, word ptr [bx] ; 06E2
    mov ax, word ptr [bx + 0Ah] ; 06E4
    leave ; 06E7
    ret ; 06E8
    nop ; 06E9
X_055E_control_06EA:
    mov bx, word ptr [bx] ; 06EA
    mov ax, word ptr [bx + 0Ch] ; 06EC
    leave ; 06EF
    ret ; 06F0
    nop ; 06F1
X_055E_control_06F2:
    mov bx, word ptr [bx] ; 06F2
    mov ax, word ptr [bx + 0Eh] ; 06F4
    leave ; 06F7
    ret ; 06F8
    nop ; 06F9
X_055E_control_06FA:
    mov bx, word ptr [bx] ; 06FA
    mov ax, word ptr [bx + 02Ah] ; 06FC
    leave ; 06FF
    ret ; 0700
    nop ; 0701
X_055E_control_0702:
    mov bx, word ptr [bx] ; 0702
    mov ax, word ptr [bx + 02Ch] ; 0704
    leave ; 0707
    ret ; 0708
    nop ; 0709
X_055E_control_070A:
    mov bx, word ptr [bx] ; 070A
    mov ax, word ptr [bx + 02Eh] ; 070C
    leave ; 070F
    ret ; 0710
    nop ; 0711
X_055E_control_0712:
    mov bx, word ptr [bx] ; 0712
    mov ax, word ptr [bx + 030h] ; 0714
    leave ; 0717
    ret ; 0718
    nop ; 0719
X_055E_control_071A:
    mov bx, word ptr [bx] ; 071A
    mov ax, word ptr [bx + 032h] ; 071C
    leave ; 071F
    ret ; 0720
    nop ; 0721
X_055E_control_0722:
    push word ptr [bp + 8] ; 0722
    push word ptr [bp + 6] ; 0725
    push bx ; 0728
    call near ptr _snd_261A ; 0729
    add sp, 6 ; 072C
    leave ; 072F
    ret ; 0730
    nop ; 0731
X_055E_control_0732:
    push word ptr [bp + 8] ; 0732
    push word ptr [bp + 6] ; 0735
    push word ptr [bx + 2] ; 0738
    call near ptr _snd_11F0 ; 073B
    add sp, 6 ; 073E
    leave ; 0741
    ret ; 0742

; set player priority; original CS:0743
_snd_0743 label near
X_055E_control_0743:
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
_snd_075E label near
X_055E_control_075E:
    enter 0, 0 ; 075E
    cmp byte ptr [bp + 6], 07Fh ; 0762
    jbe short X_055E_control_076C ; 0766
    mov byte ptr [bp + 6], 07Fh ; 0768
X_055E_control_076C:
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
_snd_078F label near
X_055E_control_078F:
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
_snd_07AA label near
X_055E_control_07AA:
    enter 0, 0 ; 07AA
    push si ; 07AE
    cmp byte ptr [bp + 8], 018h ; 07AF
    jg short X_055E_control_07F3 ; 07B3
    cmp byte ptr [bp + 8], 0E8h ; 07B5
    jl short X_055E_control_07F3 ; 07B9
    mov si, word ptr [bp + 4] ; 07BB
    mov al, byte ptr [bp + 8] ; 07BE
    cmp byte ptr [bp + 6], 1 ; 07C1
    ja short X_055E_control_07F3 ; 07C5
    jb short X_055E_control_07DD ; 07C7
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
X_055E_control_07DD:
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
X_055E_control_07F3:
    mov ax, 0FFFFh ; 07F3
    pop si ; 07F6
    leave ; 07F7
    ret ; 07F8

; set player detune; original CS:07F9
_snd_07F9 label near
X_055E_control_07F9:
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
_snd_0814 label near
X_055E_control_0814:
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
_snd_0857 label near
X_055E_control_0857:
    enter 014h, 0 ; 0857
    push si ; 085B
    mov si, word ptr [bp + 4] ; 085C
    cmp byte ptr [si + 2], 0 ; 085F
    jne short X_055E_control_086B ; 0863
X_055E_control_0865:
    mov ax, 0FFFFh ; 0865
    pop si ; 0868
    leave ; 0869
    ret ; 086A
X_055E_control_086B:
    push word ptr [bp + 6] ; 086B
    push word ptr [_snd_midi_tags+6] ; 086E
    push word ptr [_snd_midi_tags+4] ; 0872
    push word ptr [si + 4] ; 0876
    call near ptr _snd_0406 ; 0879
    add sp, 8 ; 087C
    mov word ptr [bp - 4], ax ; 087F
    mov word ptr [bp - 2], dx ; 0882
    or dx, ax ; 0885
    je short X_055E_control_0865 ; 0887
    push word ptr [si + 0Ah] ; 0889
    push word ptr [_snd_midi_tags+6] ; 088C
    push word ptr [_snd_midi_tags+4] ; 0890
    push word ptr [si + 4] ; 0894
    call near ptr _snd_0406 ; 0897
    add sp, 8 ; 089A
    mov word ptr [bp - 8], ax ; 089D
    mov word ptr [bp - 6], dx ; 08A0
    or dx, ax ; 08A3
    je short X_055E_control_0865 ; 08A5
    inc byte ptr [_snd_parse_nesting] ; 08A7
    cmp word ptr [bp + 8], 0 ; 08AB
    jne short X_055E_control_08B6 ; 08AF
    mov word ptr [bp + 8], 1 ; 08B1
X_055E_control_08B6:
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
    jne short X_055E_control_08FA ; 08D1
    mov ax, word ptr [bp - 0Ch] ; 08D3
    cmp word ptr [si + 012h], dx ; 08D6
    ja short X_055E_control_08FA ; 08D9
    jb short X_055E_control_08E2 ; 08DB
    cmp word ptr [si + 010h], ax ; 08DD
    ja short X_055E_control_08FA ; 08E0
X_055E_control_08E2:
    mov ax, word ptr [si + 6] ; 08E2
    add ax, word ptr [bp - 4] ; 08E5
    mov dx, word ptr [bp - 2] ; 08E8
    mov word ptr [_snd_parse_cursor], ax ; 08EB
    mov word ptr [_snd_parse_cursor+2], dx ; 08EE
    mov ax, word ptr [si + 014h] ; 08F2
    mov dx, word ptr [si + 016h] ; 08F5
    jmp short X_055E_control_090F ; 08F8
X_055E_control_08FA:
    mov ax, word ptr [bp - 4] ; 08FA
    mov dx, word ptr [bp - 2] ; 08FD
    mov word ptr [_snd_parse_cursor], ax ; 0900
    mov word ptr [_snd_parse_cursor+2], dx ; 0903
    push offset _snd_parse_cursor ; 0907
    call near ptr _snd_101E ; 090A
    inc sp ; 090D
    inc sp ; 090E
X_055E_control_090F:
    mov word ptr [bp - 010h], ax ; 090F
    mov word ptr [bp - 0Eh], dx ; 0912
X_055E_control_0915:
    mov ax, word ptr [bp - 0Ch] ; 0915
    mov dx, word ptr [bp - 0Ah] ; 0918
    cmp word ptr [bp - 0Eh], dx ; 091B
    ja short X_055E_control_094F ; 091E
    jb short X_055E_control_0927 ; 0920
    cmp word ptr [bp - 010h], ax ; 0922
    jae short X_055E_control_094F ; 0925
X_055E_control_0927:
    push offset _snd_parse_cursor ; 0927
    call near ptr _snd_1D6D ; 092A
    inc sp ; 092D
    inc sp ; 092E
    mov ax, word ptr [_snd_parse_cursor+2] ; 092F
    or ax, word ptr [_snd_parse_cursor] ; 0932
    je short X_055E_control_0948 ; 0936
    push offset _snd_parse_cursor ; 0938
    call near ptr _snd_101E ; 093B
    inc sp ; 093E
    inc sp ; 093F
    add word ptr [bp - 010h], ax ; 0940
    adc word ptr [bp - 0Eh], dx ; 0943
    jmp short X_055E_control_0915 ; 0946
X_055E_control_0948:
    dec byte ptr [_snd_parse_nesting] ; 0948
    jmp near ptr X_055E_control_0865 ; 094C
X_055E_control_094F:
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
    je short X_055E_control_09E6 ; 09DC
    mov word ptr [si + 0Ah], ax ; 09DE
    mov word ptr [si + 02Ah], 0 ; 09E1
X_055E_control_09E6:
    mov byte ptr [_snd_parse_finished], 1 ; 09E6
    dec byte ptr [_snd_parse_nesting] ; 09EB
    xor ax, ax ; 09EF
    pop si ; 09F1
    leave ; 09F2
    ret ; 09F3

; scan sequence with held-note preservation; original CS:09F4
_snd_09F4 label near
X_055E_control_09F4:
    enter 010h, 0 ; 09F4
    push si ; 09F8
    mov si, word ptr [bp + 4] ; 09F9
    cmp byte ptr [si + 2], 0 ; 09FC
    jne short X_055E_control_0A08 ; 0A00
X_055E_control_0A02:
    xor ax, 0FFFFh ; 0A02
    pop si ; 0A05
    leave ; 0A06
    ret ; 0A07
X_055E_control_0A08:
    push word ptr [bp + 6] ; 0A08
    push word ptr [_snd_midi_tags+6] ; 0A0B
    push word ptr [_snd_midi_tags+4] ; 0A0F
    push word ptr [si + 4] ; 0A13
    call near ptr _snd_0406 ; 0A16
    add sp, 8 ; 0A19
    mov word ptr [bp - 4], ax ; 0A1C
    mov word ptr [bp - 2], dx ; 0A1F
    or dx, ax ; 0A22
    je short X_055E_control_0A02 ; 0A24
    inc byte ptr [_snd_parse_nesting] ; 0A26
    cmp word ptr [bp + 8], 0 ; 0A2A
    jne short X_055E_control_0A35 ; 0A2E
    mov word ptr [bp + 8], 1 ; 0A30
X_055E_control_0A35:
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
X_055E_control_0A78:
    mov ax, word ptr [bp - 8] ; 0A78
    mov dx, word ptr [bp - 6] ; 0A7B
    cmp dx, word ptr [bp - 0Ah] ; 0A7E
    ja short X_055E_control_0A8A ; 0A81
    jb short X_055E_control_0ABB ; 0A83
    cmp ax, word ptr [bp - 0Ch] ; 0A85
    jbe short X_055E_control_0ABB ; 0A88
X_055E_control_0A8A:
    push offset _snd_parse_cursor ; 0A8A
    push word ptr [si] ; 0A8D
    call near ptr _snd_183E ; 0A8F
    add sp, 4 ; 0A92
    mov ax, word ptr [_snd_parse_cursor+2] ; 0A95
    or ax, word ptr [_snd_parse_cursor] ; 0A98
    je short X_055E_control_0AAE ; 0A9C
    push offset _snd_parse_cursor ; 0A9E
    call near ptr _snd_101E ; 0AA1
    inc sp ; 0AA4
    inc sp ; 0AA5
    add word ptr [bp - 0Ch], ax ; 0AA6
    adc word ptr [bp - 0Ah], dx ; 0AA9
    jmp short X_055E_control_0A78 ; 0AAC
X_055E_control_0AAE:
    dec byte ptr [_snd_parse_nesting] ; 0AAE
    mov word ptr [_snd_scanning], 0 ; 0AB2
    jmp near ptr X_055E_control_0A02 ; 0AB8
X_055E_control_0ABB:
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
    je short X_055E_control_0B25 ; 0B20
    mov word ptr [si + 0Ah], ax ; 0B22
X_055E_control_0B25:
    dec byte ptr [_snd_parse_nesting] ; 0B25
    xor ax, ax ; 0B29
    pop si ; 0B2B
    leave ; 0B2C
    ret ; 0B2D

; set sequence loop count and start/end beat/tick; original CS:0B2E
_snd_0B2E label near
X_055E_control_0B2E:
    enter 0, 0 ; 0B2E
    mov dx, word ptr [bp + 8] ; 0B32
    mov ax, dx ; 0B35
    inc ax ; 0B37
    cmp ax, word ptr [bp + 0Ch] ; 0B38
    jb short X_055E_control_0B42 ; 0B3B
    mov ax, 0FFFFh ; 0B3D
    leave ; 0B40
    ret ; 0B41
X_055E_control_0B42:
    or dx, dx ; 0B42
    jne short X_055E_control_0B47 ; 0B44
    inc dx ; 0B46
X_055E_control_0B47:
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
_snd_0B6E label near
X_055E_control_0B6E:
    enter 0, 0 ; 0B6E
    xor ax, ax ; 0B72
    mov bx, word ptr [bp + 4] ; 0B74
    mov word ptr [bx + 02Ah], ax ; 0B77
    xor ax, ax ; 0B7A
    leave ; 0B7C
    ret ; 0B7D

; set global or per-channel hook; original CS:0B7E
_snd_0B7E label near
X_055E_control_0B7E:
    enter 0, 0 ; 0B7E
    push di ; 0B82
    mov bl, byte ptr [bp + 6] ; 0B83
    xor bh, bh ; 0B86
    cmp bx, 5 ; 0B88
    ja short X_055E_control_0BAA ; 0B8B
    shl bx, 1 ; 0B8D
    mov dx, word ptr cs:[bx + X_055E_control_0B9E] ; 0B8F
    mov al, byte ptr [bp + 8] ; 0B94
    xor ah, ah ; 0B97
    mov bx, word ptr [bp + 4] ; 0B99
    jmp dx ; 0B9C
X_055E_control_0B9E:
    ; 6 near destinations, indexed by twice the selector
    dw offset X_055E_control_0BB0, offset X_055E_control_0BB6, offset X_055E_control_0BBC, offset X_055E_control_0BDA
    dw offset X_055E_control_0BF8, offset X_055E_control_0C16
X_055E_control_0BAA:
    mov ax, 0FFFFh ; 0BAA
    pop di ; 0BAD
    leave ; 0BAE
    ret ; 0BAF
X_055E_control_0BB0:
    mov byte ptr [bx], al ; 0BB0
    jmp near ptr X_055E_control_0C38 ; 0BB2
    nop ; 0BB5
X_055E_control_0BB6:
    mov byte ptr [bx + 1], al ; 0BB6
    jmp short X_055E_control_0C38 ; 0BB9
    nop ; 0BBB
X_055E_control_0BBC:
    cmp byte ptr [bp + 0Ah], 010h ; 0BBC
    ja short X_055E_control_0BAA ; 0BC0
    je short X_055E_control_0BD0 ; 0BC2
    mov cl, byte ptr [bp + 0Ah] ; 0BC4
    xor ch, ch ; 0BC7
    add bx, cx ; 0BC9
    mov byte ptr [bx + 2], al ; 0BCB
    jmp short X_055E_control_0C38 ; 0BCE
X_055E_control_0BD0:
    mov ah, al ; 0BD0
    mov cx, 8 ; 0BD2
    lea di, [bx + 2] ; 0BD5
    jmp short X_055E_control_0C32 ; 0BD8
X_055E_control_0BDA:
    cmp byte ptr [bp + 0Ah], 010h ; 0BDA
    ja short X_055E_control_0BAA ; 0BDE
    je short X_055E_control_0BEE ; 0BE0
    mov cl, byte ptr [bp + 0Ah] ; 0BE2
    xor ch, ch ; 0BE5
    add bx, cx ; 0BE7
    mov byte ptr [bx + 012h], al ; 0BE9
    jmp short X_055E_control_0C38 ; 0BEC
X_055E_control_0BEE:
    mov ah, al ; 0BEE
    mov cx, 8 ; 0BF0
    lea di, [bx + 012h] ; 0BF3
    jmp short X_055E_control_0C32 ; 0BF6
X_055E_control_0BF8:
    cmp byte ptr [bp + 0Ah], 010h ; 0BF8
    ja short X_055E_control_0BAA ; 0BFC
    je short X_055E_control_0C0C ; 0BFE
    mov cl, byte ptr [bp + 0Ah] ; 0C00
    xor ch, ch ; 0C03
    add bx, cx ; 0C05
    mov byte ptr [bx + 022h], al ; 0C07
    jmp short X_055E_control_0C38 ; 0C0A
X_055E_control_0C0C:
    mov ah, al ; 0C0C
    mov cx, 8 ; 0C0E
    lea di, [bx + 022h] ; 0C11
    jmp short X_055E_control_0C32 ; 0C14
X_055E_control_0C16:
    cmp byte ptr [bp + 0Ah], 010h ; 0C16
    ja short X_055E_control_0BAA ; 0C1A
    je short X_055E_control_0C2A ; 0C1C
    mov cl, byte ptr [bp + 0Ah] ; 0C1E
    xor ch, ch ; 0C21
    add bx, cx ; 0C23
    mov byte ptr [bx + 032h], al ; 0C25
    jmp short X_055E_control_0C38 ; 0C28
X_055E_control_0C2A:
    mov ah, al ; 0C2A
    mov cx, 8 ; 0C2C
    lea di, [bx + 032h] ; 0C2F
X_055E_control_0C32:
    mov ax, ds ; 0C32
    mov es, ax ; 0C34
    rep stosw ; 0C36
X_055E_control_0C38:
    xor ax, ax ; 0C38
    pop di ; 0C3A
    leave ; 0C3B
    ret ; 0C3C

; allocate timed volume fade; original CS:0C3D
_snd_0C3D label near
X_055E_control_0C3D:
    enter 0, 0 ; 0C3D
    push si ; 0C41
    mov si, word ptr [bp + 4] ; 0C42
    push si ; 0C45
    call near ptr _snd_1684 ; 0C46
    inc sp ; 0C49
    inc sp ; 0C4A
    cmp word ptr [bp + 8], 0 ; 0C4B
    jne short X_055E_control_0C5E ; 0C4F
    mov al, byte ptr [bp + 6] ; 0C51
    push ax ; 0C54
    push si ; 0C55
    call near ptr _snd_075E ; 0C56
    add sp, 4 ; 0C59
    jmp short X_055E_control_0CBE ; 0C5C
X_055E_control_0C5E:
    mov byte ptr [_snd_fade_state], 1 ; 0C5E
    mov si, offset _snd_fades ; 0C63
    mov cx, 2 ; 0C66
X_055E_control_0C69:
    cmp byte ptr [si], ch ; 0C69
    je short X_055E_control_0C78 ; 0C6B
    add si, 010h ; 0C6D
    loop X_055E_control_0C69 ; 0C70
    mov ax, 0FFFFh ; 0C72
    pop si ; 0C75
    leave ; 0C76
    ret ; 0C77
X_055E_control_0C78:
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
    jge short X_055E_control_0CB3 ; 0CAD
    neg dx ; 0CAF
    neg al ; 0CB1
X_055E_control_0CB3:
    mov byte ptr [si + 0Bh], al ; 0CB3
    mov byte ptr [si + 0Ch], dl ; 0CB6
    mov word ptr [si + 0Eh], 0 ; 0CB9
X_055E_control_0CBE:
    xor ax, ax ; 0CBE
    pop si ; 0CC0
    leave ; 0CC1
    ret ; 0CC2

; begin queued command list; original CS:0CC3
_snd_0CC3 label near
X_055E_control_0CC3:
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
    jl short X_055E_control_0CEF ; 0CEB
    xor si, si ; 0CED
X_055E_control_0CEF:
    cmp word ptr [_snd_queue_read], si ; 0CEF
    jne short X_055E_control_0D0A ; 0CF3
    dec si ; 0CF5
    mov word ptr [_snd_queue_write], si ; 0CF6
    or si, si ; 0CFA
    jge short X_055E_control_0D04 ; 0CFC
    mov word ptr [_snd_queue_write], 03Fh ; 0CFE
X_055E_control_0D04:
    mov ax, 0FFFFh ; 0D04
    pop si ; 0D07
    leave ; 0D08
    ret ; 0D09
X_055E_control_0D0A:
    mov word ptr [_snd_queue_write], si ; 0D0A
    mov word ptr [_snd_queued_sound], dx ; 0D0E
    mov byte ptr [_snd_queued_marker], al ; 0D12
    mov byte ptr [_snd_building_queue], 1 ; 0D15
    xor ax, ax ; 0D1A
    pop si ; 0D1C
    leave ; 0D1D
    ret ; 0D1E

; append queued command or close list; original CS:0D1F
_snd_0D1F label near
X_055E_control_0D1F:
    enter 0, 0 ; 0D1F
    push si ; 0D23
    mov si, word ptr [_snd_queue_write] ; 0D24
    cmp si, word ptr [_snd_queue_read] ; 0D28
    jne short X_055E_control_0D34 ; 0D2C
X_055E_control_0D2E:
    mov ax, 0FFFFh ; 0D2E
    pop si ; 0D31
    leave ; 0D32
    ret ; 0D33
X_055E_control_0D34:
    mov dx, word ptr [bp + 4] ; 0D34
    cmp dx, -1 ; 0D37
    jne short X_055E_control_0D47 ; 0D3A
    mov byte ptr [_snd_building_queue], 0 ; 0D3C
    inc word ptr [_snd_trigger_count] ; 0D41
    jmp short X_055E_control_0DA3 ; 0D45
X_055E_control_0D47:
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
    jl short X_055E_control_0D88 ; 0D84
    xor si, si ; 0D86
X_055E_control_0D88:
    cmp si, word ptr [_snd_queue_read] ; 0D88
    jne short X_055E_control_0D9F ; 0D8C
    dec si ; 0D8E
    mov word ptr [_snd_queue_write], si ; 0D8F
    or si, si ; 0D93
    jge short X_055E_control_0D2E ; 0D95
    mov word ptr [_snd_queue_write], 03Fh ; 0D97
    jmp short X_055E_control_0D2E ; 0D9D
X_055E_control_0D9F:
    mov word ptr [_snd_queue_write], si ; 0D9F
X_055E_control_0DA3:
    xor ax, ax ; 0DA3
    pop si ; 0DA5
    leave ; 0DA6
    ret ; 0DA7

; clear queued command state; original CS:0DA8
_snd_0DA8 label near
X_055E_control_0DA8:
    xor ax, ax ; 0DA8
    mov byte ptr [_snd_building_queue], al ; 0DAA
    mov word ptr [_snd_queue_write], ax ; 0DAD
    mov word ptr [_snd_queue_read], ax ; 0DB0
    mov word ptr [_snd_trigger_count], ax ; 0DB3
    xor ax, ax ; 0DB6
    ret ; 0DB8

; exact/MIDI.ASM _TEXT 0DB9..1E1A
public _snd_0DB9
public _snd_0E6A
public _snd_0E7C
public _snd_0FBE
public _snd_101E
public _snd_1041
public _snd_1086
public _snd_109C
public _snd_10E7
public _snd_1118
public _snd_114D
public _snd_1182
public _snd_11B7
public _snd_11F0
public _snd_1263
public _snd_12D8
public _snd_1537
public _snd_15DF
public _snd_15F0
public _snd_160C
public _snd_162A
public _snd_167E
public _snd_1684
public _snd_16A5
public _snd_171D
public _snd_17BB
public _snd_17FC
public _snd_183E
public _snd_1A4A
public _snd_1D49
public _snd_1D6D
public _snd_1DC6
public _snd_1DDB

; initialize sequence; original CS:0DB9
_snd_0DB9 label near
X_0DB9_midi_0DB9:
    enter 4, 0 ; 0DB9
    push di ; 0DBD
    push si ; 0DBE
    mov di, word ptr [bp + 6] ; 0DBF
    mov si, word ptr [bp + 4] ; 0DC2
    mov word ptr [si + 4], di ; 0DC5
    xor ax, ax ; 0DC8
    mov word ptr [si + 0Ah], ax ; 0DCA
    mov word ptr [si + 018h], ax ; 0DCD
    mov word ptr [si + 01Ah], ax ; 0DD0
    mov word ptr [si + 02Ah], ax ; 0DD3
    mov word ptr [si + 02Eh], ax ; 0DD6
    mov word ptr [si + 032h], ax ; 0DD9
    inc ax ; 0DDC
    mov word ptr [si + 02Ch], ax ; 0DDD
    mov word ptr [si + 030h], ax ; 0DE0
    push 7 ; 0DE3
    push 0A120h ; 0DE5
    push si ; 0DE8
    call near ptr X_0DB9_midi_0FBE ; 0DE9
    add sp, 6 ; 0DEC
    mov al, byte ptr [bp + 6] ; 0DEF
    push 080h ; 0DF2
    push si ; 0DF5
    call near ptr _snd_0814 ; 0DF6
    add sp, 4 ; 0DF9
    push word ptr [si + 0Ah] ; 0DFC
    push word ptr [_snd_midi_tags+06h] ; 0DFF
    push word ptr [_snd_midi_tags+04h] ; 0E03
    push di ; 0E07
    call near ptr _snd_0406 ; 0E08
    add sp, 8 ; 0E0B
    mov word ptr [_snd_parse_cursor], ax ; 0E0E
    mov word ptr [_snd_parse_cursor+02h], dx ; 0E11
    mov cx, dx ; 0E15
    or cx, ax ; 0E17
    je short X_0DB9_midi_0E66 ; 0E19
    mov word ptr [bp - 4], ax ; 0E1B
    mov word ptr [bp - 2], dx ; 0E1E
    push offset _snd_parse_cursor ; 0E21
    call near ptr X_0DB9_midi_101E ; 0E24
    inc sp ; 0E27
    inc sp ; 0E28
    mov word ptr [si + 014h], ax ; 0E29
    mov word ptr [si + 016h], dx ; 0E2C
    mov word ptr [si + 010h], ax ; 0E2F
    mov word ptr [si + 012h], dx ; 0E32
    push word ptr [bp - 2] ; 0E35
    push word ptr [bp - 4] ; 0E38
    push word ptr [_snd_parse_cursor+02h] ; 0E3B
    push word ptr [_snd_parse_cursor] ; 0E3F
    call near ptr X_0DB9_midi_1041 ; 0E43
    add sp, 8 ; 0E46
    mov word ptr [si + 6], ax ; 0E49
    mov word ptr [si + 8], dx ; 0E4C
    mov ax, word ptr [si + 014h] ; 0E4F
    xor dx, dx ; 0E52
    mov cx, 01E0h ; 0E54
    div cx ; 0E57
    inc ax ; 0E59
    mov word ptr [si + 0Ch], ax ; 0E5A
    mov word ptr [si + 0Eh], dx ; 0E5D
    mov ax, 1 ; 0E60
    mov byte ptr [si + 2], al ; 0E63
X_0DB9_midi_0E66:
    pop si ; 0E66
    pop di ; 0E67
    leave ; 0E68
    ret ; 0E69

; stop sequence; original CS:0E6A
_snd_0E6A label near
X_0DB9_midi_0E6A:
    enter 0, 0 ; 0E6A
    mov bx, word ptr [bp + 4] ; 0E6E
    mov byte ptr [bx + 2], 0 ; 0E71
    mov byte ptr [_snd_parse_finished], 1 ; 0E75
    leave ; 0E7A
    ret ; 0E7B

; advance sequences on timer; original CS:0E7C
_snd_0E7C label near
X_0DB9_midi_0E7C:
    enter 4, 0 ; 0E7C
    push di ; 0E80
    push si ; 0E81
    cmp byte ptr [_snd_parse_nesting], 0 ; 0E82
    je short X_0DB9_midi_0E8C ; 0E87
    jmp near ptr X_0DB9_midi_0FBA ; 0E89
X_0DB9_midi_0E8C:
    mov si, offset _snd_sequences ; 0E8C
    mov di, 2 ; 0E8F
X_0DB9_midi_0E92:
    cmp byte ptr [si + 2], 1 ; 0E92
    je short X_0DB9_midi_0E9B ; 0E96
    jmp near ptr X_0DB9_midi_0FB1 ; 0E98
X_0DB9_midi_0E9B:
    mov ax, word ptr [si + 026h] ; 0E9B
    mov dx, word ptr [si + 028h] ; 0E9E
    add word ptr [si + 018h], ax ; 0EA1
    adc word ptr [si + 01Ah], dx ; 0EA4
    mov dx, word ptr [si + 01Ah] ; 0EA7
    xor cx, cx ; 0EAA
    add word ptr [si + 010h], dx ; 0EAC
    adc word ptr [si + 012h], cx ; 0EAF
    add word ptr [si + 0Eh], dx ; 0EB2
    mov word ptr [si + 01Ah], cx ; 0EB5
    cmp word ptr [si + 0Eh], 01E0h ; 0EB8
    jb short X_0DB9_midi_0ECF ; 0EBD
    mov ax, word ptr [si + 0Eh] ; 0EBF
    xor dx, dx ; 0EC2
    mov cx, 01E0h ; 0EC4
    div cx ; 0EC7
    add word ptr [si + 0Ch], ax ; 0EC9
    mov word ptr [si + 0Eh], dx ; 0ECC
X_0DB9_midi_0ECF:
    cmp word ptr [si + 02Ah], 0 ; 0ECF
    je short X_0DB9_midi_0EF8 ; 0ED3
    mov ax, word ptr [si + 030h] ; 0ED5
    cmp word ptr [si + 0Ch], ax ; 0ED8
    jb short X_0DB9_midi_0EF8 ; 0EDB
    mov ax, word ptr [si + 032h] ; 0EDD
    cmp word ptr [si + 0Eh], ax ; 0EE0
    jb short X_0DB9_midi_0EF8 ; 0EE3
    dec word ptr [si + 02Ah] ; 0EE5
    push word ptr [si + 02Eh] ; 0EE8
    push word ptr [si + 02Ch] ; 0EEB
    push word ptr [si + 0Ah] ; 0EEE
    push si ; 0EF1
    call near ptr _snd_0857 ; 0EF2
    add sp, 8 ; 0EF5
X_0DB9_midi_0EF8:
    mov ax, word ptr [si + 010h] ; 0EF8
    mov dx, word ptr [si + 012h] ; 0EFB
    cmp word ptr [si + 016h], dx ; 0EFE
    jbe short X_0DB9_midi_0F06 ; 0F01
    jmp near ptr X_0DB9_midi_0FB1 ; 0F03
X_0DB9_midi_0F06:
    jb short X_0DB9_midi_0F10 ; 0F06
    cmp word ptr [si + 014h], ax ; 0F08
    jbe short X_0DB9_midi_0F10 ; 0F0B
    jmp near ptr X_0DB9_midi_0FB1 ; 0F0D
X_0DB9_midi_0F10:
    push word ptr [si + 0Ah] ; 0F10
    push word ptr [_snd_midi_tags+06h] ; 0F13
    push word ptr [_snd_midi_tags+04h] ; 0F17
    push word ptr [si + 4] ; 0F1B
    call near ptr _snd_0406 ; 0F1E
    add sp, 8 ; 0F21
    mov word ptr [bp - 4], ax ; 0F24
    mov word ptr [bp - 2], dx ; 0F27
    or dx, ax ; 0F2A
    jne short X_0DB9_midi_0F35 ; 0F2C
    push word ptr [si] ; 0F2E
    call near ptr _snd_0643 ; 0F30
    inc sp ; 0F33
    inc sp ; 0F34
X_0DB9_midi_0F35:
    mov ax, word ptr [si + 6] ; 0F35
    add ax, word ptr [bp - 4] ; 0F38
    mov dx, word ptr [bp - 2] ; 0F3B
    mov word ptr [_snd_parse_cursor], ax ; 0F3E
    mov word ptr [_snd_parse_cursor+02h], dx ; 0F41
    mov byte ptr [_snd_parse_finished], 0 ; 0F45
X_0DB9_midi_0F4A:
    mov ax, word ptr [si + 010h] ; 0F4A
    mov dx, word ptr [si + 012h] ; 0F4D
    cmp word ptr [si + 016h], dx ; 0F50
    ja short X_0DB9_midi_0F87 ; 0F53
    jb short X_0DB9_midi_0F5C ; 0F55
    cmp word ptr [si + 014h], ax ; 0F57
    ja short X_0DB9_midi_0F87 ; 0F5A
X_0DB9_midi_0F5C:
    push offset _snd_parse_cursor ; 0F5C
    push word ptr [si] ; 0F5F
    call near ptr X_0DB9_midi_183E ; 0F61
    add sp, 4 ; 0F64
    mov ax, word ptr [_snd_parse_cursor+02h] ; 0F67
    or ax, word ptr [_snd_parse_cursor] ; 0F6A
    je short X_0DB9_midi_0FB1 ; 0F6E
    cmp byte ptr [_snd_parse_finished], 0 ; 0F70
    jne short X_0DB9_midi_0FB1 ; 0F75
    push offset _snd_parse_cursor ; 0F77
    call near ptr X_0DB9_midi_101E ; 0F7A
    inc sp ; 0F7D
    inc sp ; 0F7E
    add word ptr [si + 014h], ax ; 0F7F
    adc word ptr [si + 016h], dx ; 0F82
    jmp short X_0DB9_midi_0F4A ; 0F85
X_0DB9_midi_0F87:
    mov ax, word ptr [_snd_parse_cursor+02h] ; 0F87
    or ax, word ptr [_snd_parse_cursor] ; 0F8A
    je short X_0DB9_midi_0FB1 ; 0F8E
    cmp byte ptr [_snd_parse_finished], 0 ; 0F90
    jne short X_0DB9_midi_0FB1 ; 0F95
    push word ptr [bp - 2] ; 0F97
    push word ptr [bp - 4] ; 0F9A
    push word ptr [_snd_parse_cursor+02h] ; 0F9D
    push word ptr [_snd_parse_cursor] ; 0FA1
    call near ptr X_0DB9_midi_1041 ; 0FA5
    add sp, 8 ; 0FA8
    mov word ptr [si + 6], ax ; 0FAB
    mov word ptr [si + 8], dx ; 0FAE
X_0DB9_midi_0FB1:
    add si, 034h ; 0FB1
    dec di ; 0FB4
    je short X_0DB9_midi_0FBA ; 0FB5
    jmp near ptr X_0DB9_midi_0E92 ; 0FB7
X_0DB9_midi_0FBA:
    pop si ; 0FBA
    pop di ; 0FBB
    leave ; 0FBC
    ret ; 0FBD

; set tempo; original CS:0FBE
_snd_0FBE label near
X_0DB9_midi_0FBE:
    enter 0, 0 ; 0FBE
    push si ; 0FC2
    mov si, word ptr [bp + 4] ; 0FC3
    mov ax, word ptr [bp + 6] ; 0FC6
    mov dx, word ptr [bp + 8] ; 0FC9
    mov word ptr [si + 01Ch], ax ; 0FCC
    mov word ptr [si + 01Eh], dx ; 0FCF
    shr dx, 1 ; 0FD2
    rcr ax, 1 ; 0FD4
    shr dx, 1 ; 0FD6
    rcr ax, 1 ; 0FD8
    shr dx, 1 ; 0FDA
    rcr ax, 1 ; 0FDC
    shr dx, 1 ; 0FDE
    rcr ax, 1 ; 0FE0
    shr dx, 1 ; 0FE2
    rcr ax, 1 ; 0FE4
    shr dx, 1 ; 0FE6
    rcr ax, 1 ; 0FE8
    push 0 ; 0FEA
    push ax ; 0FEC
    mov ax, word ptr [_snd_tick_period] ; 0FED
    mov dx, word ptr [_snd_tick_period+02h] ; 0FF0
    mov dh, dl ; 0FF4
    mov dl, ah ; 0FF6
    mov ah, al ; 0FF8
    xor al, al ; 0FFA
    shl ax, 1 ; 0FFC
    rcl dx, 1 ; 0FFE
    shl ax, 1 ; 1000
    rcl dx, 1 ; 1002
    push dx ; 1004
    push ax ; 1005
    push cs ; 1006
    call near ptr _snd_31AA ; 1007
    mov word ptr [si + 020h], ax ; 100A
    mov word ptr [si + 022h], dx ; 100D
    mov al, byte ptr [si + 024h] ; 1010
    push ax ; 1013
    push si ; 1014
    call near ptr _snd_0814 ; 1015
    add sp, 4 ; 1018
    pop si ; 101B
    leave ; 101C
    ret ; 101D

; read variable-length quantity; original CS:101E
_snd_101E label near
X_0DB9_midi_101E:
    enter 0, 0 ; 101E
    push si ; 1022
    mov bx, word ptr [bp + 4] ; 1023
    les si, dword ptr [bx] ; 1026
    cld ; 1028
    xor ax, ax ; 1029
    cwd ; 102B
X_0DB9_midi_102C:
    mov dh, dl ; 102C
    mov dl, ah ; 102E
    mov ah, al ; 1030
    lods byte ptr es:[si] ; 1032
    rol al, 1 ; 1034
    shr dx, 1 ; 1036
    rcr ax, 1 ; 1038
    jb short X_0DB9_midi_102C ; 103A
    mov word ptr [bx], si ; 103C
    pop si ; 103E
    leave ; 103F
    ret ; 1040

; absolute physical far-pointer distance; original CS:1041
_snd_1041 label near
X_0DB9_midi_1041:
    enter 0, 0 ; 1041
    push si ; 1045
    mov ax, word ptr [bp + 8] ; 1046
    mov dx, word ptr [bp + 0Ah] ; 1049
    rol dx, 4 ; 104C
    mov cx, dx ; 104F
    and dx, 0Fh ; 1051
    and cx, 0FFF0h ; 1054
    add ax, cx ; 1057
    adc dx, 0 ; 1059
    mov bx, ax ; 105C
    mov si, dx ; 105E
    mov ax, word ptr [bp + 4] ; 1060
    mov dx, word ptr [bp + 6] ; 1063
    rol dx, 4 ; 1066
    mov cx, dx ; 1069
    and dx, 0Fh ; 106B
    and cx, 0FFF0h ; 106E
    add ax, cx ; 1071
    adc dx, 0 ; 1073
    sub ax, bx ; 1076
    sbb dx, si ; 1078
    jns short X_0DB9_midi_1083 ; 107A
    neg dx ; 107C
    neg ax ; 107E
    sbb dx, 0 ; 1080
X_0DB9_midi_1083:
    pop si ; 1083
    leave ; 1084
    ret ; 1085

; clear player hooks; original CS:1086
_snd_1086 label near
X_0DB9_midi_1086:
    enter 0, 0 ; 1086
    push di ; 108A
    mov di, word ptr [bp + 4] ; 108B
    mov cx, 021h ; 108E
    mov ax, ds ; 1091
    mov es, ax ; 1093
    xor ax, ax ; 1095
    rep stosw ; 1097
    pop di ; 1099
    leave ; 109A
    ret ; 109B

; jump hook; original CS:109C
_snd_109C label near
X_0DB9_midi_109C:
    enter 0, 0 ; 109C
    push si ; 10A0
    mov si, word ptr [bp + 4] ; 10A1
    mov bx, word ptr [bp + 6] ; 10A4
    mov al, byte ptr [bx] ; 10A7
    mov bx, word ptr [si + 2] ; 10A9
    or al, al ; 10AC
    je short X_0DB9_midi_10B7 ; 10AE
    cmp byte ptr [bx], al ; 10B0
    jne short X_0DB9_midi_10E4 ; 10B2
    mov byte ptr [bx], 0 ; 10B4
X_0DB9_midi_10B7:
    mov ax, word ptr [bp + 6] ; 10B7
    add ax, 5 ; 10BA
    push ax ; 10BD
    call near ptr _snd_04CC ; 10BE
    inc sp ; 10C1
    inc sp ; 10C2
    push ax ; 10C3
    mov ax, word ptr [bp + 6] ; 10C4
    add ax, 3 ; 10C7
    push ax ; 10CA
    call near ptr _snd_04CC ; 10CB
    inc sp ; 10CE
    inc sp ; 10CF
    push ax ; 10D0
    mov ax, word ptr [bp + 6] ; 10D1
    inc ax ; 10D4
    push ax ; 10D5
    call near ptr _snd_04CC ; 10D6
    inc sp ; 10D9
    inc sp ; 10DA
    push ax ; 10DB
    push word ptr [si] ; 10DC
    call near ptr _snd_0857 ; 10DE
    add sp, 8 ; 10E1
X_0DB9_midi_10E4:
    pop si ; 10E4
    leave ; 10E5
    ret ; 10E6

; transpose hook; original CS:10E7
_snd_10E7 label near
X_0DB9_midi_10E7:
    enter 0, 0 ; 10E7
    push si ; 10EB
    push di ; 10EC
    mov di, word ptr [bp + 4] ; 10ED
    mov si, word ptr [bp + 6] ; 10F0
    mov bx, word ptr [di + 2] ; 10F3
    mov al, byte ptr [si] ; 10F6
    or al, al ; 10F8
    je short X_0DB9_midi_1105 ; 10FA
    cmp byte ptr [bx + 1], al ; 10FC
    jne short X_0DB9_midi_1114 ; 10FF
    mov byte ptr [bx + 1], 0 ; 1101
X_0DB9_midi_1105:
    mov al, byte ptr [si + 2] ; 1105
    push ax ; 1108
    mov al, byte ptr [si + 1] ; 1109
    push ax ; 110C
    push di ; 110D
    call near ptr _snd_07AA ; 110E
    add sp, 6 ; 1111
X_0DB9_midi_1114:
    pop di ; 1114
    pop si ; 1115
    leave ; 1116
    ret ; 1117

; part enable hook; original CS:1118
_snd_1118 label near
X_0DB9_midi_1118:
    enter 0, 0 ; 1118
    push si ; 111C
    push di ; 111D
    mov bx, word ptr [bp + 4] ; 111E
    mov di, word ptr [bp + 6] ; 1121
    mov si, word ptr [bx + 2] ; 1124
    mov cl, byte ptr [di] ; 1127
    xor ch, ch ; 1129
    add si, cx ; 112B
    mov al, byte ptr [di + 1] ; 112D
    or al, al ; 1130
    je short X_0DB9_midi_113D ; 1132
    cmp byte ptr [si + 2], al ; 1134
    jne short X_0DB9_midi_1149 ; 1137
    mov byte ptr [si + 2], 0 ; 1139
X_0DB9_midi_113D:
    mov al, byte ptr [di + 2] ; 113D
    push ax ; 1140
    push cx ; 1141
    push bx ; 1142
    call near ptr _snd_2509 ; 1143
    add sp, 6 ; 1146
X_0DB9_midi_1149:
    pop di ; 1149
    pop si ; 114A
    leave ; 114B
    ret ; 114C

; part volume hook; original CS:114D
_snd_114D label near
X_0DB9_midi_114D:
    enter 0, 0 ; 114D
    push si ; 1151
    push di ; 1152
    mov bx, word ptr [bp + 4] ; 1153
    mov di, word ptr [bp + 6] ; 1156
    mov si, word ptr [bx + 2] ; 1159
    mov cl, byte ptr [di] ; 115C
    xor ch, ch ; 115E
    add si, cx ; 1160
    mov al, byte ptr [di + 1] ; 1162
    or al, al ; 1165
    je short X_0DB9_midi_1172 ; 1167
    cmp byte ptr [si + 012h], al ; 1169
    jne short X_0DB9_midi_117E ; 116C
    mov byte ptr [si + 012h], 0 ; 116E
X_0DB9_midi_1172:
    mov al, byte ptr [di + 2] ; 1172
    push ax ; 1175
    push cx ; 1176
    push bx ; 1177
    call near ptr _snd_235A ; 1178
    add sp, 6 ; 117B
X_0DB9_midi_117E:
    pop di ; 117E
    pop si ; 117F
    leave ; 1180
    ret ; 1181

; part instrument hook; original CS:1182
_snd_1182 label near
X_0DB9_midi_1182:
    enter 0, 0 ; 1182
    push si ; 1186
    push di ; 1187
    mov bx, word ptr [bp + 4] ; 1188
    mov di, word ptr [bp + 6] ; 118B
    mov si, word ptr [bx + 2] ; 118E
    mov cl, byte ptr [di] ; 1191
    xor ch, ch ; 1193
    add si, cx ; 1195
    mov al, byte ptr [di + 1] ; 1197
    or al, al ; 119A
    je short X_0DB9_midi_11A7 ; 119C
    cmp byte ptr [si + 022h], al ; 119E
    jne short X_0DB9_midi_11B3 ; 11A1
    mov byte ptr [si + 022h], 0 ; 11A3
X_0DB9_midi_11A7:
    mov al, byte ptr [di + 2] ; 11A7
    push ax ; 11AA
    push cx ; 11AB
    push bx ; 11AC
    call near ptr _snd_2277 ; 11AD
    add sp, 6 ; 11B0
X_0DB9_midi_11B3:
    pop di ; 11B3
    pop si ; 11B4
    leave ; 11B5
    ret ; 11B6

; part transpose hook; original CS:11B7
_snd_11B7 label near
X_0DB9_midi_11B7:
    enter 0, 0 ; 11B7
    push si ; 11BB
    push di ; 11BC
    mov bx, word ptr [bp + 4] ; 11BD
    mov di, word ptr [bp + 6] ; 11C0
    mov si, word ptr [bx + 2] ; 11C3
    mov cl, byte ptr [di] ; 11C6
    xor ch, ch ; 11C8
    add si, cx ; 11CA
    mov al, byte ptr [di + 1] ; 11CC
    or al, al ; 11CF
    je short X_0DB9_midi_11DC ; 11D1
    cmp byte ptr [si + 032h], al ; 11D3
    jne short X_0DB9_midi_11EC ; 11D6
    mov byte ptr [si + 032h], 0 ; 11D8
X_0DB9_midi_11DC:
    mov al, byte ptr [di + 3] ; 11DC
    push ax ; 11DF
    mov al, byte ptr [di + 2] ; 11E0
    push ax ; 11E3
    push cx ; 11E4
    push bx ; 11E5
    call near ptr _snd_23D2 ; 11E6
    add sp, 8 ; 11E9
X_0DB9_midi_11EC:
    pop di ; 11EC
    pop si ; 11ED
    leave ; 11EE
    ret ; 11EF

; read hook value; original CS:11F0
_snd_11F0 label near
X_0DB9_midi_11F0:
    enter 0, 0 ; 11F0
    mov bl, byte ptr [bp + 6] ; 11F4
    xor bh, bh ; 11F7
    sub bx, 012h ; 11F9
    cmp bx, 5 ; 11FC
    ja short X_0DB9_midi_1216 ; 11FF
    shl bx, 1 ; 1201
    xor ax, ax ; 1203
    jmp word ptr cs:[bx + X_0DB9_midi_120A] ; 1205
X_0DB9_midi_120A:
    dw offset X_0DB9_midi_121C, offset X_0DB9_midi_1224, offset X_0DB9_midi_122C, offset X_0DB9_midi_123A, offset X_0DB9_midi_1248, offset X_0DB9_midi_1256 ; MIDI event dispatch
X_0DB9_midi_1216:
    mov ax, 0FFFFh ; 1216
    leave ; 1219
    ret ; 121A
    nop ; 121B
X_0DB9_midi_121C:
    mov bx, word ptr [bp + 4] ; 121C
    mov al, byte ptr [bx] ; 121F
    leave ; 1221
    ret ; 1222
    nop ; 1223
X_0DB9_midi_1224:
    mov bx, word ptr [bp + 4] ; 1224
    mov al, byte ptr [bx + 1] ; 1227
    leave ; 122A
    ret ; 122B
X_0DB9_midi_122C:
    mov bx, word ptr [bp + 4] ; 122C
    mov al, byte ptr [bp + 8] ; 122F
    add bx, ax ; 1232
    mov al, byte ptr [bx + 2] ; 1234
    leave ; 1237
    ret ; 1238
    nop ; 1239
X_0DB9_midi_123A:
    mov bx, word ptr [bp + 4] ; 123A
    mov al, byte ptr [bp + 8] ; 123D
    add bx, ax ; 1240
    mov al, byte ptr [bx + 012h] ; 1242
    leave ; 1245
    ret ; 1246
    nop ; 1247
X_0DB9_midi_1248:
    mov bx, word ptr [bp + 4] ; 1248
    mov al, byte ptr [bp + 8] ; 124B
    add bx, ax ; 124E
    mov al, byte ptr [bx + 022h] ; 1250
    leave ; 1253
    ret ; 1254
    nop ; 1255
X_0DB9_midi_1256:
    mov bx, word ptr [bp + 4] ; 1256
    mov al, byte ptr [bp + 8] ; 1259
    add bx, ax ; 125C
    mov al, byte ptr [bx + 032h] ; 125E
    leave ; 1261
    ret ; 1262

; advance held notes; original CS:1263
_snd_1263 label near
X_0DB9_midi_1263:
    push di ; 1263
    push si ; 1264
    mov si, word ptr [_snd_held_active] ; 1265
X_0DB9_midi_1269:
    or si, si ; 1269
    je short X_0DB9_midi_12D5 ; 126B
    mov di, word ptr [si + 2] ; 126D
    mov bx, word ptr [si + 6] ; 1270
    mov ax, word ptr [bx + 026h] ; 1273
    mov dx, word ptr [bx + 028h] ; 1276
    add word ptr [si + 010h], ax ; 1279
    adc word ptr [si + 012h], dx ; 127C
    mov dx, word ptr [si + 012h] ; 127F
    xor cx, cx ; 1282
    add word ptr [si + 0Ch], dx ; 1284
    adc word ptr [si + 0Eh], cx ; 1287
    mov word ptr [si + 012h], cx ; 128A
    mov ax, word ptr [si + 0Ch] ; 128D
    mov dx, word ptr [si + 0Eh] ; 1290
    cmp word ptr [si + 0Ah], dx ; 1293
    ja short X_0DB9_midi_12D1 ; 1296
    jb short X_0DB9_midi_129F ; 1298
    cmp word ptr [si + 8], ax ; 129A
    ja short X_0DB9_midi_12D1 ; 129D
X_0DB9_midi_129F:
    mov al, byte ptr [si + 4] ; 129F
    push ax ; 12A2
    mov al, byte ptr [si + 5] ; 12A3
    push ax ; 12A6
    push word ptr [bx] ; 12A7
    call near ptr _snd_21A2 ; 12A9
    add sp, 6 ; 12AC
    or di, di ; 12AF
    je short X_0DB9_midi_12B7 ; 12B1
    mov ax, word ptr [si] ; 12B3
    mov word ptr [di], ax ; 12B5
X_0DB9_midi_12B7:
    cmp word ptr [si], 0 ; 12B7
    je short X_0DB9_midi_12C3 ; 12BA
    mov bx, word ptr [si] ; 12BC
    mov word ptr [bx + 2], di ; 12BE
    jmp short X_0DB9_midi_12C7 ; 12C1
X_0DB9_midi_12C3:
    mov word ptr [_snd_held_active], di ; 12C3
X_0DB9_midi_12C7:
    mov ax, word ptr [_snd_held_free] ; 12C7
    mov word ptr [si + 2], ax ; 12CA
    mov word ptr [_snd_held_free], si ; 12CD
X_0DB9_midi_12D1:
    mov si, di ; 12D1
    jmp short X_0DB9_midi_1269 ; 12D3
X_0DB9_midi_12D5:
    pop si ; 12D5
    pop di ; 12D6
    ret ; 12D7

; retain notes across a jump; original CS:12D8
_snd_12D8 label near
X_0DB9_midi_12D8:
    enter 8, 0 ; 12D8
    push si ; 12DC
    push di ; 12DD
    call near ptr X_0DB9_midi_15DF ; 12DE
    mov di, word ptr [bp + 4] ; 12E1
    mov word ptr [_snd_scan_note_count], 0 ; 12E4
    push offset _snd_scan_note_count ; 12EA
    push offset _snd_note_channels ; 12ED
    mov bx, word ptr [di] ; 12F0
    push word ptr [bx + 4] ; 12F2
    call near ptr _snd_222F ; 12F5
    add sp, 6 ; 12F8
    mov ax, word ptr [bp + 6] ; 12FB
    mov dx, word ptr [bp + 8] ; 12FE
    mov word ptr [_snd_parse_cursor], ax ; 1301
    mov word ptr [_snd_parse_cursor+02h], dx ; 1304
    mov ax, word ptr [di + 014h] ; 1308
    mov dx, word ptr [di + 016h] ; 130B
    sub ax, word ptr [di + 010h] ; 130E
    sbb dx, word ptr [di + 012h] ; 1311
    mov word ptr [bp - 4], ax ; 1314
    mov word ptr [bp - 2], dx ; 1317
    or dx, dx ; 131A
    jge short X_0DB9_midi_1326 ; 131C
    xor ax, ax ; 131E
    mov word ptr [bp - 4], ax ; 1320
    mov word ptr [bp - 2], ax ; 1323
X_0DB9_midi_1326:
    cmp word ptr [_snd_scan_note_count], 0 ; 1326
    jne short X_0DB9_midi_1330 ; 132B
    jmp near ptr X_0DB9_midi_13C7 ; 132D
X_0DB9_midi_1330:
    push offset _snd_parse_cursor ; 1330
    call near ptr X_0DB9_midi_1537 ; 1333
    inc sp ; 1336
    inc sp ; 1337
    dec ax ; 1338
    jne short X_0DB9_midi_13AF ; 1339
    mov bl, byte ptr [_snd_event_channel] ; 133B
    xor bh, bh ; 133F
    shl bx, 1 ; 1341
    mov ax, word ptr [bx + _snd_channel_masks] ; 1343
    mov bl, byte ptr [_snd_event_note] ; 1347
    xor bh, bh ; 134B
    shl bx, 1 ; 134D
    add bx, 0415Ah ; 134F
    test word ptr [bx], ax ; 1353
    je short X_0DB9_midi_13AF ; 1355
    not ax ; 1357
    and word ptr [bx], ax ; 1359
    dec word ptr [_snd_scan_note_count] ; 135B
    mov si, word ptr [_snd_held_free] ; 135F
    or si, si ; 1363
    jne short X_0DB9_midi_136A ; 1365
    jmp near ptr X_0DB9_midi_1533 ; 1367
X_0DB9_midi_136A:
    mov ax, word ptr [si + 2] ; 136A
    mov word ptr [_snd_held_free], ax ; 136D
    mov ax, word ptr [_snd_held_cursor] ; 1370
    mov word ptr [si + 2], ax ; 1373
    mov word ptr [_snd_held_cursor], si ; 1376
    mov word ptr [si], 0 ; 137A
    or ax, ax ; 137E
    je short X_0DB9_midi_1386 ; 1380
    mov bx, ax ; 1382
    mov word ptr [bx], si ; 1384
X_0DB9_midi_1386:
    mov al, byte ptr [_snd_event_note] ; 1386
    mov byte ptr [si + 4], al ; 1389
    mov al, byte ptr [_snd_event_channel] ; 138C
    mov byte ptr [si + 5], al ; 138F
    mov word ptr [si + 6], di ; 1392
    mov ax, word ptr [bp - 4] ; 1395
    mov dx, word ptr [bp - 2] ; 1398
    mov word ptr [si + 8], ax ; 139B
    mov word ptr [si + 0Ah], dx ; 139E
    xor ax, ax ; 13A1
    mov word ptr [si + 0Eh], ax ; 13A3
    mov word ptr [si + 0Ch], ax ; 13A6
    mov word ptr [si + 012h], ax ; 13A9
    mov word ptr [si + 010h], ax ; 13AC
X_0DB9_midi_13AF:
    push offset _snd_parse_cursor ; 13AF
    call near ptr X_0DB9_midi_101E ; 13B2
    inc sp ; 13B5
    inc sp ; 13B6
    add word ptr [bp - 4], ax ; 13B7
    adc word ptr [bp - 2], dx ; 13BA
    cmp word ptr [_snd_scan_note_count], 0 ; 13BD
    je short X_0DB9_midi_13C7 ; 13C2
    jmp near ptr X_0DB9_midi_1330 ; 13C4
X_0DB9_midi_13C7:
    xor ax, ax ; 13C7
    mov word ptr [_snd_scan_end_tick+02h], ax ; 13C9
    mov word ptr [_snd_scan_end_tick], ax ; 13CC
    mov si, word ptr [_snd_held_cursor] ; 13CF
X_0DB9_midi_13D3:
    or si, si ; 13D3
    je short X_0DB9_midi_1412 ; 13D5
    mov bl, byte ptr [si + 5] ; 13D7
    xor bh, bh ; 13DA
    shl bx, 1 ; 13DC
    mov ax, word ptr [bx + _snd_channel_masks] ; 13DE
    mov bl, byte ptr [si + 4] ; 13E2
    xor bh, bh ; 13E5
    shl bx, 1 ; 13E7
    or word ptr [bx + _snd_note_channels], ax ; 13E9
    mov ax, word ptr [_snd_scan_end_tick] ; 13ED
    mov dx, word ptr [_snd_scan_end_tick+02h] ; 13F0
    cmp word ptr [si + 0Ah], dx ; 13F4
    jb short X_0DB9_midi_140D ; 13F7
    ja short X_0DB9_midi_1400 ; 13F9
    cmp word ptr [si + 8], ax ; 13FB
    jbe short X_0DB9_midi_140D ; 13FE
X_0DB9_midi_1400:
    mov ax, word ptr [si + 8] ; 1400
    mov dx, word ptr [si + 0Ah] ; 1403
    mov word ptr [_snd_scan_end_tick], ax ; 1406
    mov word ptr [_snd_scan_end_tick+02h], dx ; 1409
X_0DB9_midi_140D:
    mov si, word ptr [si + 2] ; 140D
    jmp short X_0DB9_midi_13D3 ; 1410
X_0DB9_midi_1412:
    mov ax, word ptr [bp + 0Ah] ; 1412
    mov dx, word ptr [bp + 0Ch] ; 1415
    mov word ptr [_snd_parse_cursor], ax ; 1418
    mov word ptr [_snd_parse_cursor+02h], dx ; 141B
    mov ax, word ptr [bp + 0Eh] ; 141F
    mov dx, word ptr [bp + 010h] ; 1422
    mov word ptr [bp - 4], ax ; 1425
    mov word ptr [bp - 2], dx ; 1428
    cmp dx, word ptr [_snd_scan_end_tick+02h] ; 142B
    jbe short X_0DB9_midi_1434 ; 142F
    jmp near ptr X_0DB9_midi_14F5 ; 1431
X_0DB9_midi_1434:
    jb short X_0DB9_midi_143F ; 1434
    cmp ax, word ptr [_snd_scan_end_tick] ; 1436
    jb short X_0DB9_midi_143F ; 143A
    jmp near ptr X_0DB9_midi_14F5 ; 143C
X_0DB9_midi_143F:
    push offset _snd_parse_cursor ; 143F
    call near ptr X_0DB9_midi_1537 ; 1442
    inc sp ; 1445
    inc sp ; 1446
    cmp ax, 2 ; 1447
    je short X_0DB9_midi_144F ; 144A
    jmp near ptr X_0DB9_midi_14CE-10000h ; 144C
X_0DB9_midi_144F:
    mov bl, byte ptr [_snd_event_channel] ; 144F
    xor bh, bh ; 1453
    shl bx, 1 ; 1455
    mov ax, word ptr [bx + _snd_channel_masks] ; 1457
    mov word ptr [bp - 6], ax ; 145B
    mov bl, byte ptr [_snd_event_note] ; 145E
    xor bh, bh ; 1462
    shl bx, 1 ; 1464
    add bx, 0415Ah ; 1466
    mov word ptr [bp - 8], bx ; 146A
    test word ptr [bx], ax ; 146D
    je short X_0DB9_midi_14CE ; 146F
    mov si, word ptr [_snd_held_cursor] ; 1471
X_0DB9_midi_1475:
    or si, si ; 1475
    je short X_0DB9_midi_14CE ; 1477
    mov di, word ptr [si + 2] ; 1479
    mov al, byte ptr [_snd_event_note] ; 147C
    cmp byte ptr [si + 4], al ; 147F
    jne short X_0DB9_midi_14CA ; 1482
    mov al, byte ptr [_snd_event_channel] ; 1484
    cmp byte ptr [si + 5], al ; 1487
    jne short X_0DB9_midi_14CA ; 148A
    mov ax, word ptr [bp - 4] ; 148C
    mov dx, word ptr [bp - 2] ; 148F
    cmp word ptr [si + 0Ah], dx ; 1492
    jb short X_0DB9_midi_14CA ; 1495
    ja short X_0DB9_midi_149E ; 1497
    cmp word ptr [si + 8], ax ; 1499
    jbe short X_0DB9_midi_14CA ; 149C
X_0DB9_midi_149E:
    mov ax, word ptr [bp - 6] ; 149E
    not ax ; 14A1
    mov bx, word ptr [bp - 8] ; 14A3
    and word ptr [bx], ax ; 14A6
    or di, di ; 14A8
    je short X_0DB9_midi_14B0 ; 14AA
    mov ax, word ptr [si] ; 14AC
    mov word ptr [di], ax ; 14AE
X_0DB9_midi_14B0:
    cmp word ptr [si], 0 ; 14B0
    je short X_0DB9_midi_14BC ; 14B3
    mov bx, word ptr [si] ; 14B5
    mov word ptr [bx + 2], di ; 14B7
    jmp short X_0DB9_midi_14C0 ; 14BA
X_0DB9_midi_14BC:
    mov word ptr [_snd_held_cursor], di ; 14BC
X_0DB9_midi_14C0:
    mov ax, word ptr [_snd_held_free] ; 14C0
    mov word ptr [si + 2], ax ; 14C3
    mov word ptr [_snd_held_free], si ; 14C6
X_0DB9_midi_14CA:
    mov si, di ; 14CA
    jmp short X_0DB9_midi_1475 ; 14CC
X_0DB9_midi_14CE:
    push offset _snd_parse_cursor ; 14CE
    call near ptr X_0DB9_midi_101E ; 14D1
    inc sp ; 14D4
    inc sp ; 14D5
    add word ptr [bp - 4], ax ; 14D6
    adc word ptr [bp - 2], dx ; 14D9
    mov ax, word ptr [_snd_scan_end_tick] ; 14DC
    mov dx, word ptr [_snd_scan_end_tick+02h] ; 14DF
    cmp word ptr [bp - 2], dx ; 14E3
    jae short X_0DB9_midi_14EB ; 14E6
    jmp near ptr X_0DB9_midi_143F ; 14E8
X_0DB9_midi_14EB:
    ja short X_0DB9_midi_14F5 ; 14EB
    cmp word ptr [bp - 4], ax ; 14ED
    jae short X_0DB9_midi_14F5 ; 14F0
    jmp near ptr X_0DB9_midi_143F ; 14F2
X_0DB9_midi_14F5:
    cmp word ptr [_snd_held_active], 0 ; 14F5
    jne short X_0DB9_midi_150C ; 14FA
    mov ax, word ptr [_snd_held_cursor] ; 14FC
    mov word ptr [_snd_held_active], ax ; 14FF
    mov word ptr [_snd_held_cursor], 0 ; 1502
    pop di ; 1508
    pop si ; 1509
    leave ; 150A
    ret ; 150B
X_0DB9_midi_150C:
    mov bx, word ptr [_snd_held_active] ; 150C
    cmp word ptr [bx + 2], 0 ; 1510
    je short X_0DB9_midi_151F ; 1514
X_0DB9_midi_1516:
    mov bx, word ptr [bx + 2] ; 1516
    cmp word ptr [bx + 2], 0 ; 1519
    jne short X_0DB9_midi_1516 ; 151D
X_0DB9_midi_151F:
    mov ax, word ptr [_snd_held_cursor] ; 151F
    mov word ptr [bx + 2], ax ; 1522
    mov word ptr [_snd_held_cursor], 0 ; 1525
    or ax, ax ; 152B
    je short X_0DB9_midi_1533 ; 152D
    mov si, ax ; 152F
    mov word ptr [si], bx ; 1531
X_0DB9_midi_1533:
    pop di ; 1533
    pop si ; 1534
    leave ; 1535
    ret ; 1536

; scan note events; original CS:1537
_snd_1537 label near
X_0DB9_midi_1537:
    enter 0, 0 ; 1537
    push si ; 153B
    cld ; 153C
    mov bx, word ptr [bp + 4] ; 153D
    les si, dword ptr [bx] ; 1540
    lods byte ptr es:[si] ; 1542
    mov bl, al ; 1544
    cmp al, 080h ; 1546
    jb short X_0DB9_midi_1589 ; 1548
    cmp al, 0F0h ; 154A
    jae short X_0DB9_midi_15A4 ; 154C
    and ax, 070h ; 154E
    shr ax, 3 ; 1551
    xchg bx, ax ; 1554
    jmp word ptr cs:[bx + X_0DB9_midi_155A] ; 1555
X_0DB9_midi_155A:
    dw offset X_0DB9_midi_1568, offset X_0DB9_midi_1582, offset X_0DB9_midi_15A0, offset X_0DB9_midi_15A0, offset X_0DB9_midi_15A1, offset X_0DB9_midi_15A1, offset X_0DB9_midi_15A0 ; MIDI event dispatch
X_0DB9_midi_1568:
    and al, 0Fh ; 1568
    mov byte ptr [_snd_event_channel], al ; 156A
    lods byte ptr es:[si] ; 156D
    mov byte ptr [_snd_event_note], al ; 156F
    lods byte ptr es:[si] ; 1572
    mov byte ptr [_snd_event_velocity], al ; 1574
    mov bx, word ptr [bp + 4] ; 1577
    mov word ptr [bx], si ; 157A
X_0DB9_midi_157C:
    mov ax, 1 ; 157C
    pop si ; 157F
    leave ; 1580
    ret ; 1581
X_0DB9_midi_1582:
    and al, 0Fh ; 1582
    mov byte ptr [_snd_event_channel], al ; 1584
    lods byte ptr es:[si] ; 1587
X_0DB9_midi_1589:
    mov byte ptr [_snd_event_note], al ; 1589
    lods byte ptr es:[si] ; 158C
    mov byte ptr [_snd_event_velocity], al ; 158E
    mov bx, word ptr [bp + 4] ; 1591
    mov word ptr [bx], si ; 1594
    or al, al ; 1596
    je short X_0DB9_midi_157C ; 1598
    mov ax, 2 ; 159A
    pop si ; 159D
    leave ; 159E
    ret ; 159F
X_0DB9_midi_15A0:
    inc si ; 15A0
X_0DB9_midi_15A1:
    inc si ; 15A1
    jmp short X_0DB9_midi_15D5 ; 15A2
X_0DB9_midi_15A4:
    cmp al, 0F0h ; 15A4
    je short X_0DB9_midi_15B6 ; 15A6
    cmp al, 0F7h ; 15A8
    je short X_0DB9_midi_15B6 ; 15AA
    cmp al, 0FFh ; 15AC
    jne short X_0DB9_midi_15CA ; 15AE
    lods byte ptr es:[si] ; 15B0
    cmp al, 02Fh ; 15B2
    je short X_0DB9_midi_15CA ; 15B4
X_0DB9_midi_15B6:
    mov dx, si ; 15B6
    mov si, word ptr [bp + 4] ; 15B8
    mov word ptr [si], dx ; 15BB
    push si ; 15BD
    call near ptr X_0DB9_midi_101E ; 15BE
    inc sp ; 15C1
    inc sp ; 15C2
    add word ptr [si], ax ; 15C3
    xor ax, ax ; 15C5
    pop si ; 15C7
    leave ; 15C8
    ret ; 15C9
X_0DB9_midi_15CA:
    xor ax, ax ; 15CA
    mov word ptr [_snd_scan_note_count], ax ; 15CC
    mov word ptr [_snd_scan_end_tick+02h], ax ; 15CF
    mov word ptr [_snd_scan_end_tick], ax ; 15D2
X_0DB9_midi_15D5:
    mov bx, word ptr [bp + 4] ; 15D5
    mov word ptr [bx], si ; 15D8
    xor ax, ax ; 15DA
    pop si ; 15DC
    leave ; 15DD
    ret ; 15DE

; clear note/channel bitset; original CS:15DF
_snd_15DF label near
X_0DB9_midi_15DF:
    push di ; 15DF
    mov di, offset _snd_note_channels ; 15E0
    mov cx, 080h ; 15E3
    mov ax, ds ; 15E6
    mov es, ax ; 15E8
    xor ax, ax ; 15EA
    rep stosw ; 15EC
    pop di ; 15EE
    ret ; 15EF

; set channel bit; original CS:15F0
_snd_15F0 label near
X_0DB9_midi_15F0:
    enter 0, 0 ; 15F0
    mov bl, byte ptr [bp + 4] ; 15F4
    xor bh, bh ; 15F7
    shl bx, 1 ; 15F9
    mov ax, word ptr [bx + _snd_channel_masks] ; 15FB
    mov bl, byte ptr [bp + 6] ; 15FF
    xor bh, bh ; 1602
    shl bx, 1 ; 1604
    or word ptr [bx + _snd_note_channels], ax ; 1606
    leave ; 160A
    ret ; 160B

; clear channel bit; original CS:160C
_snd_160C label near
X_0DB9_midi_160C:
    enter 0, 0 ; 160C
    mov bl, byte ptr [bp + 4] ; 1610
    xor bh, bh ; 1613
    shl bx, 1 ; 1615
    mov ax, word ptr [bx + _snd_channel_masks] ; 1617
    not ax ; 161B
    mov bl, byte ptr [bp + 6] ; 161D
    xor bh, bh ; 1620
    shl bx, 1 ; 1622
    and word ptr [bx + _snd_note_channels], ax ; 1624
    leave ; 1628
    ret ; 1629

; retrigger all tracked notes at velocity 80; original CS:162A
_snd_162A label near
X_0DB9_midi_162A:
    enter 4, 0 ; 162A
    push si ; 162E
    push di ; 162F
    mov byte ptr [bp - 2], 0 ; 1630
    mov si, word ptr [bp + 4] ; 1634
X_0DB9_midi_1637:
    mov bl, byte ptr [bp - 2] ; 1637
    xor bh, bh ; 163A
    shl bx, 1 ; 163C
    mov di, word ptr [bx + _snd_note_channels] ; 163E
    or di, di ; 1642
    je short X_0DB9_midi_1671 ; 1644
    mov byte ptr [bp - 4], 0 ; 1646
X_0DB9_midi_164A:
    mov bl, byte ptr [bp - 4] ; 164A
    xor bh, bh ; 164D
    shl bx, 1 ; 164F
    test word ptr [bx + _snd_channel_masks], di ; 1651
    je short X_0DB9_midi_1668 ; 1655
    push 050h ; 1657
    mov al, byte ptr [bp - 2] ; 1659
    push ax ; 165C
    mov al, byte ptr [bp - 4] ; 165D
    push ax ; 1660
    push si ; 1661
    call near ptr _snd_216C ; 1662
    add sp, 8 ; 1665
X_0DB9_midi_1668:
    inc byte ptr [bp - 4] ; 1668
    cmp byte ptr [bp - 4], 010h ; 166B
    jb short X_0DB9_midi_164A ; 166F
X_0DB9_midi_1671:
    inc byte ptr [bp - 2] ; 1671
    cmp byte ptr [bp - 2], 080h ; 1674
    jb short X_0DB9_midi_1637 ; 1678
    pop di ; 167A
    pop si ; 167B
    leave ; 167C
    ret ; 167D

; clear fade state; original CS:167E
_snd_167E label near
X_0DB9_midi_167E:
    xor ax, ax ; 167E
    mov byte ptr [_snd_fade_state], al ; 1680
    ret ; 1683

; cancel player fade; original CS:1684
_snd_1684 label near
X_0DB9_midi_1684:
    enter 0, 0 ; 1684
    mov bx, offset _snd_fades ; 1688
    mov cx, 2 ; 168B
    mov dx, word ptr [bp + 4] ; 168E
X_0DB9_midi_1691:
    cmp byte ptr [bx], 0 ; 1691
    je short X_0DB9_midi_169E ; 1694
    cmp word ptr [bx + 2], dx ; 1696
    jne short X_0DB9_midi_169E ; 1699
    mov byte ptr [bx], 0 ; 169B
X_0DB9_midi_169E:
    add bx, 010h ; 169E
    loop X_0DB9_midi_1691 ; 16A1
    leave ; 16A3
    ret ; 16A4

; advance volume fades; original CS:16A5
_snd_16A5 label near
X_0DB9_midi_16A5:
    push di ; 16A5
    push si ; 16A6
    cmp byte ptr [_snd_fade_state], 0 ; 16A7
    je short X_0DB9_midi_171A ; 16AC
    inc word ptr [_snd_fade_tick_scale] ; 16AE
    and word ptr [_snd_fade_tick_scale], 3 ; 16B2
    jne short X_0DB9_midi_171A ; 16B7
    mov si, offset _snd_fades ; 16B9
    mov byte ptr [_snd_fade_state], 0 ; 16BC
    mov di, 2 ; 16C1
X_0DB9_midi_16C4:
    cmp byte ptr [si], 0 ; 16C4
    je short X_0DB9_midi_1714 ; 16C7
    mov byte ptr [_snd_fade_state], 1 ; 16C9
    mov cl, byte ptr [si + 4] ; 16CE
    add cl, byte ptr [si + 0Ah] ; 16D1
    mov al, byte ptr [si + 0Ch] ; 16D4
    cbw ; 16D7
    add word ptr [si + 0Eh], ax ; 16D8
    mov ax, word ptr [si + 6] ; 16DB
    cmp word ptr [si + 0Eh], ax ; 16DE
    jb short X_0DB9_midi_16E9 ; 16E1
    sub word ptr [si + 0Eh], ax ; 16E3
    add cl, byte ptr [si + 0Bh] ; 16E6
X_0DB9_midi_16E9:
    cmp cl, byte ptr [si + 4] ; 16E9
    je short X_0DB9_midi_170C ; 16EC
    or cl, cl ; 16EE
    je short X_0DB9_midi_1701 ; 16F0
    mov byte ptr [si + 4], cl ; 16F2
    push cx ; 16F5
    push word ptr [si + 2] ; 16F6
    call near ptr _snd_075E ; 16F9
    add sp, 4 ; 16FC
    jmp short X_0DB9_midi_170C ; 16FF
X_0DB9_midi_1701:
    push word ptr [si + 2] ; 1701
    call near ptr _snd_0643 ; 1704
    inc sp ; 1707
    inc sp ; 1708
    mov byte ptr [si], 0 ; 1709
X_0DB9_midi_170C:
    dec word ptr [si + 8] ; 170C
    jne short X_0DB9_midi_1714 ; 170F
    mov byte ptr [si], 0 ; 1711
X_0DB9_midi_1714:
    add si, 010h ; 1714
    dec di ; 1717
    jne short X_0DB9_midi_16C4 ; 1718
X_0DB9_midi_171A:
    pop si ; 171A
    pop di ; 171B
    ret ; 171C

; execute marker command queue; original CS:171D
_snd_171D label near
X_0DB9_midi_171D:
    enter 0, 0 ; 171D
    push si ; 1721
    mov bx, word ptr [_snd_queue_read] ; 1722
    cmp bx, word ptr [_snd_queue_write] ; 1726
    jne short X_0DB9_midi_172F ; 172A
    jmp near ptr X_0DB9_midi_17B8 ; 172C
X_0DB9_midi_172F:
    mov si, word ptr [bp + 4] ; 172F
    mov si, word ptr [si + 8] ; 1732
    cmp byte ptr [_snd_building_queue], 0 ; 1735
    je short X_0DB9_midi_174C ; 173A
    cmp word ptr [_snd_queued_sound], si ; 173C
    jne short X_0DB9_midi_174C ; 1740
    mov al, byte ptr [_snd_queued_marker] ; 1742
    cmp byte ptr [bp + 6], al ; 1745
    jne short X_0DB9_midi_174C ; 1748
    jmp short X_0DB9_midi_17B8 ; 174A
X_0DB9_midi_174C:
    shl bx, 4 ; 174C
    cmp word ptr [bx + _snd_queue], 0 ; 174F
    jne short X_0DB9_midi_17B8 ; 1754
    cmp word ptr [bx + _snd_queue+02h], si ; 1756
    jne short X_0DB9_midi_17B8 ; 175A
    mov al, byte ptr [bp + 6] ; 175C
    xor ah, ah ; 175F
    cmp word ptr [bx + _snd_queue+04h], ax ; 1761
    jne short X_0DB9_midi_17B8 ; 1765
    dec word ptr [_snd_trigger_count] ; 1767
X_0DB9_midi_176B:
    mov si, word ptr [_snd_queue_read] ; 176B
    inc si ; 176F
    cmp si, 040h ; 1770
    jl short X_0DB9_midi_1777 ; 1773
    xor si, si ; 1775
X_0DB9_midi_1777:
    cmp word ptr [_snd_queue_write], si ; 1777
    je short X_0DB9_midi_17B4 ; 177B
    mov bx, si ; 177D
    shl bx, 4 ; 177F
    cmp word ptr [bx + _snd_queue], 1 ; 1782
    jne short X_0DB9_midi_17B4 ; 1787
    mov word ptr [_snd_queue_read], si ; 1789
    push 0 ; 178D
    push word ptr [bx + _snd_queue+0Eh] ; 178F
    push word ptr [bx + _snd_queue+0Ch] ; 1793
    push word ptr [bx + _snd_queue+0Ah] ; 1797
    push word ptr [bx + _snd_queue+08h] ; 179B
    push word ptr [bx + _snd_queue+06h] ; 179F
    push word ptr [bx + _snd_queue+04h] ; 17A3
    push word ptr [bx + _snd_queue+02h] ; 17A7
    push cs ; 17AB
    call near ptr _snd_00FE ; 17AC
    add sp, 010h ; 17AF
    jmp short X_0DB9_midi_176B ; 17B2
X_0DB9_midi_17B4:
    mov word ptr [_snd_queue_read], si ; 17B4
X_0DB9_midi_17B8:
    pop si ; 17B8
    leave ; 17B9
    ret ; 17BA

; read queue state; original CS:17BB
_snd_17BB label near
X_0DB9_midi_17BB:
    enter 0, 0 ; 17BB
    mov ax, word ptr [bp + 4] ; 17BF
    or ax, ax ; 17C2
    je short X_0DB9_midi_17D1 ; 17C4
    dec ax ; 17C6
    je short X_0DB9_midi_17D6 ; 17C7
    dec ax ; 17C9
    je short X_0DB9_midi_17E9 ; 17CA
X_0DB9_midi_17CC:
    mov ax, 0FFFFh ; 17CC
    leave ; 17CF
    ret ; 17D0
X_0DB9_midi_17D1:
    mov ax, word ptr [_snd_trigger_count] ; 17D1
    leave ; 17D4
    ret ; 17D5
X_0DB9_midi_17D6:
    mov bx, word ptr [_snd_queue_read] ; 17D6
    cmp word ptr [_snd_queue_write], bx ; 17DA
    je short X_0DB9_midi_17CC ; 17DE
    shl bx, 4 ; 17E0
    mov ax, word ptr [bx + _snd_queue+02h] ; 17E3
    leave ; 17E7
    ret ; 17E8
X_0DB9_midi_17E9:
    mov bx, word ptr [_snd_queue_read] ; 17E9
    cmp word ptr [_snd_queue_write], bx ; 17ED
    je short X_0DB9_midi_17CC ; 17F1
    shl bx, 4 ; 17F3
    mov ax, word ptr [bx + _snd_queue+04h] ; 17F6
    leave ; 17FA
    ret ; 17FB

; find queued sound; original CS:17FC
_snd_17FC label near
X_0DB9_midi_17FC:
    enter 0, 0 ; 17FC
    push si ; 1800
    mov cx, word ptr [bp + 4] ; 1801
    mov dx, word ptr [_snd_queue_write] ; 1804
    mov si, word ptr [_snd_queue_read] ; 1808
X_0DB9_midi_180C:
    cmp si, dx ; 180C
    je short X_0DB9_midi_1839 ; 180E
    mov bx, si ; 1810
    shl bx, 4 ; 1812
    cmp word ptr [bx + _snd_queue], 1 ; 1815
    jne short X_0DB9_midi_182F ; 181A
    cmp word ptr [bx + _snd_queue+02h], 8 ; 181C
    jne short X_0DB9_midi_182F ; 1821
    cmp word ptr [bx + _snd_queue+04h], cx ; 1823
    jne short X_0DB9_midi_182F ; 1827
    mov ax, 2 ; 1829
    pop si ; 182C
    leave ; 182D
    ret ; 182E
X_0DB9_midi_182F:
    inc si ; 182F
    cmp si, 040h ; 1830
    jl short X_0DB9_midi_180C ; 1833
    xor si, si ; 1835
    jmp short X_0DB9_midi_180C ; 1837
X_0DB9_midi_1839:
    xor ax, ax ; 1839
    pop si ; 183B
    leave ; 183C
    ret ; 183D

; dispatch MIDI event; original CS:183E
_snd_183E label near
X_0DB9_midi_183E:
    enter 0, 0 ; 183E
    push si ; 1842
    mov bx, word ptr [bp + 6] ; 1843
    les si, dword ptr [bx] ; 1846
    cld ; 1848
    lods byte ptr es:[si] ; 1849
    cmp al, 080h ; 184B
    jae short X_0DB9_midi_1857 ; 184D
    mov dx, ax ; 184F
    mov cl, byte ptr [_snd_event_channel] ; 1851
    jmp short X_0DB9_midi_18A8 ; 1855
X_0DB9_midi_1857:
    cmp al, 0F0h ; 1857
    jb short X_0DB9_midi_185E ; 1859
    jmp near ptr X_0DB9_midi_19AA ; 185B
X_0DB9_midi_185E:
    mov bx, ax ; 185E
    and al, 0Fh ; 1860
    cbw ; 1862
    mov cx, ax ; 1863
    and bx, 070h ; 1865
    shr bx, 3 ; 1868
    jmp word ptr cs:[bx + X_0DB9_midi_1870] ; 186B
X_0DB9_midi_1870:
    dw offset X_0DB9_midi_187E, offset X_0DB9_midi_18A0, offset X_0DB9_midi_18EA, offset X_0DB9_midi_18F0, offset X_0DB9_midi_197C, offset X_0DB9_midi_189C, offset X_0DB9_midi_18EA ; MIDI event dispatch
X_0DB9_midi_187E:
    lods byte ptr es:[si] ; 187E
    cmp word ptr [_snd_scanning], 0 ; 1880
    jne short X_0DB9_midi_1894 ; 1885
    push ax ; 1887
    push cx ; 1888
    push word ptr [bp + 4] ; 1889
    call near ptr _snd_21A2 ; 188C
    add sp, 6 ; 188F
    jmp short X_0DB9_midi_189C ; 1892
X_0DB9_midi_1894:
    push ax ; 1894
    push cx ; 1895
    call near ptr X_0DB9_midi_160C ; 1896
    add sp, 4 ; 1899
X_0DB9_midi_189C:
    inc si ; 189C
    jmp near ptr X_0DB9_midi_1A40 ; 189D
X_0DB9_midi_18A0:
    mov byte ptr [_snd_event_channel], cl ; 18A0
    lods byte ptr es:[si] ; 18A4
    mov dl, al ; 18A6
X_0DB9_midi_18A8:
    lods byte ptr es:[si] ; 18A8
    cmp word ptr [_snd_scanning], 0 ; 18AA
    jne short X_0DB9_midi_18D2 ; 18AF
    or al, al ; 18B1
    je short X_0DB9_midi_18C4 ; 18B3
    push ax ; 18B5
    push dx ; 18B6
    push cx ; 18B7
    push word ptr [bp + 4] ; 18B8
    call near ptr _snd_216C ; 18BB
    add sp, 8 ; 18BE
    jmp near ptr X_0DB9_midi_1A40 ; 18C1
X_0DB9_midi_18C4:
    push dx ; 18C4
    push cx ; 18C5
    push word ptr [bp + 4] ; 18C6
    call near ptr _snd_21A2 ; 18C9
    add sp, 6 ; 18CC
    jmp near ptr X_0DB9_midi_1A40 ; 18CF
X_0DB9_midi_18D2:
    push dx ; 18D2
    push cx ; 18D3
    or al, al ; 18D4
    je short X_0DB9_midi_18E1 ; 18D6
    call near ptr X_0DB9_midi_15F0 ; 18D8
    add sp, 4 ; 18DB
    jmp near ptr X_0DB9_midi_1A40 ; 18DE
X_0DB9_midi_18E1:
    call near ptr X_0DB9_midi_160C ; 18E1
    add sp, 4 ; 18E4
    jmp near ptr X_0DB9_midi_1A40 ; 18E7
X_0DB9_midi_18EA:
    inc si ; 18EA
    inc si ; 18EB
    jmp near ptr X_0DB9_midi_1A40 ; 18EC
    nop ; 18EF
X_0DB9_midi_18F0:
    lods byte ptr es:[si] ; 18F0
    mov bx, word ptr [bp + 4] ; 18F2
    cmp al, 1 ; 18F5
    je short X_0DB9_midi_1914 ; 18F7
    cmp al, 7 ; 18F9
    je short X_0DB9_midi_1922 ; 18FB
    cmp al, 0Ah ; 18FD
    je short X_0DB9_midi_1930 ; 18FF
    cmp al, 010h ; 1901
    je short X_0DB9_midi_1940 ; 1903
    cmp al, 011h ; 1905
    je short X_0DB9_midi_194E ; 1907
    cmp al, 012h ; 1909
    je short X_0DB9_midi_195E ; 190B
    cmp al, 040h ; 190D
    je short X_0DB9_midi_196E ; 190F
    jmp near ptr X_0DB9_midi_1A40 ; 1911
X_0DB9_midi_1914:
    lods byte ptr es:[si] ; 1914
    push ax ; 1916
    push cx ; 1917
    push bx ; 1918
    call near ptr _snd_253C ; 1919
    add sp, 6 ; 191C
    jmp near ptr X_0DB9_midi_1A40 ; 191F
X_0DB9_midi_1922:
    lods byte ptr es:[si] ; 1922
    push ax ; 1924
    push cx ; 1925
    push bx ; 1926
    call near ptr _snd_235A ; 1927
    add sp, 6 ; 192A
    jmp near ptr X_0DB9_midi_1A40 ; 192D
X_0DB9_midi_1930:
    lods byte ptr es:[si] ; 1930
    sub al, 040h ; 1932
    push ax ; 1934
    push cx ; 1935
    push bx ; 1936
    call near ptr _snd_23D1 ; 1937
    add sp, 6 ; 193A
    jmp near ptr X_0DB9_midi_1A40 ; 193D
X_0DB9_midi_1940:
    lods byte ptr es:[si] ; 1940
    push ax ; 1942
    push cx ; 1943
    push bx ; 1944
    call near ptr _snd_25E7 ; 1945
    add sp, 6 ; 1948
    jmp near ptr X_0DB9_midi_1A40 ; 194B
X_0DB9_midi_194E:
    lods byte ptr es:[si] ; 194E
    sub al, 040h ; 1950
    push ax ; 1952
    push cx ; 1953
    push bx ; 1954
    call near ptr _snd_247E ; 1955
    add sp, 6 ; 1958
    jmp near ptr X_0DB9_midi_1A40 ; 195B
X_0DB9_midi_195E:
    lods byte ptr es:[si] ; 195E
    sub al, 040h ; 1960
    push ax ; 1962
    push cx ; 1963
    push bx ; 1964
    call near ptr _snd_22F1 ; 1965
    add sp, 6 ; 1968
    jmp near ptr X_0DB9_midi_1A40 ; 196B
X_0DB9_midi_196E:
    lods byte ptr es:[si] ; 196E
    push ax ; 1970
    push cx ; 1971
    push bx ; 1972
    call near ptr _snd_2567 ; 1973
    add sp, 6 ; 1976
    jmp near ptr X_0DB9_midi_1A40 ; 1979
X_0DB9_midi_197C:
    lods byte ptr es:[si] ; 197C
    push ax ; 197E
    push cx ; 197F
    push word ptr [bp + 4] ; 1980
    call near ptr _snd_2277 ; 1983
    add sp, 6 ; 1986
    jmp near ptr X_0DB9_midi_1A40 ; 1989
    xor ah, ah ; 198C
    lods byte ptr es:[si] ; 198E
    mov dx, ax ; 1990
    lods byte ptr es:[si] ; 1992
    sub ax, 040h ; 1994
    shl ax, 7 ; 1997
    add ax, dx ; 199A
    push ax ; 199C
    push cx ; 199D
    push word ptr [bp + 4] ; 199E
    call near ptr _snd_2594 ; 19A1
    add sp, 6 ; 19A4
    jmp near ptr X_0DB9_midi_1A40 ; 19A7
X_0DB9_midi_19AA:
    cmp al, 0FFh ; 19AA
    je short X_0DB9_midi_19EF ; 19AC
    cmp al, 0F7h ; 19AE
    je short X_0DB9_midi_1A15 ; 19B0
    cmp al, 0F0h ; 19B2
    jne short X_0DB9_midi_19F5 ; 19B4
    mov ax, si ; 19B6
    mov si, word ptr [bp + 6] ; 19B8
    mov word ptr [si], ax ; 19BB
    push si ; 19BD
    call near ptr X_0DB9_midi_101E ; 19BE
    add sp, 2 ; 19C1
    les bx, dword ptr [si] ; 19C4
    cmp byte ptr es:[bx], 07Dh ; 19C6
    jne short X_0DB9_midi_19EB ; 19CA
    push ax ; 19CC
    push dx ; 19CD
    inc bx ; 19CE
    inc word ptr [_snd_disabled] ; 19CF
    sub ax, 2 ; 19D3
    sbb dx, 0 ; 19D6
    push ax ; 19D9
    push es ; 19DA
    push bx ; 19DB
    push word ptr [bp + 4] ; 19DC
    call near ptr X_0DB9_midi_1A4A ; 19DF
    add sp, 8 ; 19E2
    dec word ptr [_snd_disabled] ; 19E5
    pop dx ; 19E9
    pop ax ; 19EA
X_0DB9_midi_19EB:
    add ax, word ptr [si] ; 19EB
    jmp short X_0DB9_midi_1A42 ; 19ED
X_0DB9_midi_19EF:
    lods byte ptr es:[si] ; 19EF
    cmp al, 02Fh ; 19F1
    jne short X_0DB9_midi_1A11 ; 19F3
X_0DB9_midi_19F5:
    cmp word ptr [_snd_scanning], 0 ; 19F5
    jne short X_0DB9_midi_1A04 ; 19FA
    push word ptr [bp + 4] ; 19FC
    call near ptr _snd_0643 ; 19FF
    inc sp ; 1A02
    inc sp ; 1A03
X_0DB9_midi_1A04:
    mov si, word ptr [bp + 6] ; 1A04
    xor ax, ax ; 1A07
    mov word ptr [si], ax ; 1A09
    mov word ptr [si + 2], ax ; 1A0B
    pop si ; 1A0E
    leave ; 1A0F
    ret ; 1A10
X_0DB9_midi_1A11:
    cmp al, 051h ; 1A11
    je short X_0DB9_midi_1A26 ; 1A13
X_0DB9_midi_1A15:
    mov ax, si ; 1A15
    mov si, word ptr [bp + 6] ; 1A17
    mov word ptr [si], ax ; 1A1A
    push si ; 1A1C
    call near ptr X_0DB9_midi_101E ; 1A1D
    inc sp ; 1A20
    inc sp ; 1A21
    add ax, word ptr [si] ; 1A22
    jmp short X_0DB9_midi_1A42 ; 1A24
X_0DB9_midi_1A26:
    inc si ; 1A26
    xor dh, dh ; 1A27
    lods byte ptr es:[si] ; 1A29
    mov dl, al ; 1A2B
    lods byte ptr es:[si] ; 1A2D
    mov ah, al ; 1A2F
    lods byte ptr es:[si] ; 1A31
    mov bx, word ptr [bp + 4] ; 1A33
    push dx ; 1A36
    push ax ; 1A37
    push word ptr [bx] ; 1A38
    call near ptr X_0DB9_midi_0FBE ; 1A3A
    add sp, 6 ; 1A3D
X_0DB9_midi_1A40:
    mov ax, si ; 1A40
X_0DB9_midi_1A42:
    mov si, word ptr [bp + 6] ; 1A42
    mov word ptr [si], ax ; 1A45
    pop si ; 1A47
    leave ; 1A48
    ret ; 1A49

; dispatch manufacturer 7D SysEx; original CS:1A4A
_snd_1A4A label near
X_0DB9_midi_1A4A:
    enter 0, 0 ; 1A4A
    push di ; 1A4E
    push si ; 1A4F
    les si, dword ptr [bp + 6] ; 1A50
    lods byte ptr es:[si] ; 1A53
    cmp al, 0 ; 1A55
    je short X_0DB9_midi_1AC6 ; 1A57
    cmp al, 1 ; 1A59
    jne short X_0DB9_midi_1A60 ; 1A5B
    jmp near ptr X_0DB9_midi_1AEE ; 1A5D
X_0DB9_midi_1A60:
    cmp al, 2 ; 1A60
    jne short X_0DB9_midi_1A67 ; 1A62
    jmp near ptr X_0DB9_midi_1B03 ; 1A64
X_0DB9_midi_1A67:
    cmp al, 010h ; 1A67
    jne short X_0DB9_midi_1A6E ; 1A69
    jmp near ptr X_0DB9_midi_1B0F ; 1A6B
X_0DB9_midi_1A6E:
    cmp al, 011h ; 1A6E
    jne short X_0DB9_midi_1A75 ; 1A70
    jmp near ptr X_0DB9_midi_1B41 ; 1A72
X_0DB9_midi_1A75:
    cmp al, 021h ; 1A75
    jne short X_0DB9_midi_1A7C ; 1A77
    jmp near ptr X_0DB9_midi_1B6D ; 1A79
X_0DB9_midi_1A7C:
    cmp al, 030h ; 1A7C
    jne short X_0DB9_midi_1A83 ; 1A7E
    jmp near ptr X_0DB9_midi_1BAE ; 1A80
X_0DB9_midi_1A83:
    cmp al, 031h ; 1A83
    jne short X_0DB9_midi_1A8A ; 1A85
    jmp near ptr X_0DB9_midi_1BDA ; 1A87
X_0DB9_midi_1A8A:
    cmp al, 032h ; 1A8A
    jne short X_0DB9_midi_1A91 ; 1A8C
    jmp near ptr X_0DB9_midi_1BFC ; 1A8E
X_0DB9_midi_1A91:
    cmp al, 033h ; 1A91
    jne short X_0DB9_midi_1A98 ; 1A93
    jmp near ptr X_0DB9_midi_1C24 ; 1A95
X_0DB9_midi_1A98:
    cmp al, 034h ; 1A98
    jne short X_0DB9_midi_1A9F ; 1A9A
    jmp near ptr X_0DB9_midi_1C4C ; 1A9C
X_0DB9_midi_1A9F:
    cmp al, 035h ; 1A9F
    jne short X_0DB9_midi_1AA6 ; 1AA1
    jmp near ptr X_0DB9_midi_1C74 ; 1AA3
X_0DB9_midi_1AA6:
    cmp al, 040h ; 1AA6
    jne short X_0DB9_midi_1AAD ; 1AA8
    jmp near ptr X_0DB9_midi_1C9C ; 1AAA
X_0DB9_midi_1AAD:
    cmp al, 050h ; 1AAD
    jne short X_0DB9_midi_1AB4 ; 1AAF
    jmp near ptr X_0DB9_midi_1CB6 ; 1AB1
X_0DB9_midi_1AB4:
    cmp al, 051h ; 1AB4
    jne short X_0DB9_midi_1ABB ; 1AB6
    jmp near ptr X_0DB9_midi_1D04 ; 1AB8
X_0DB9_midi_1ABB:
    cmp al, 060h ; 1ABB
    jne short X_0DB9_midi_1AC2 ; 1ABD
    jmp near ptr X_0DB9_midi_1D12 ; 1ABF
X_0DB9_midi_1AC2:
    pop si ; 1AC2
    pop di ; 1AC3
    leave ; 1AC4
    ret ; 1AC5
X_0DB9_midi_1AC6:
    lods byte ptr es:[si] ; 1AC6
    and al, 0Fh ; 1AC8
    mov byte ptr [_snd_sysex_buffer], al ; 1ACA
    mov ax, word ptr [bp + 0Ah] ; 1ACD
    dec ax ; 1AD0
    dec ax ; 1AD1
    push ax ; 1AD2
    push offset _snd_sysex_buffer+01h ; 1AD3
    push es ; 1AD6
    push si ; 1AD7
    call near ptr X_0DB9_midi_1D49 ; 1AD8
    add sp, 8 ; 1ADB
    push offset _snd_sysex_buffer ; 1ADE
    push word ptr [bp + 4] ; 1AE1
    call near ptr _snd_1E83 ; 1AE4
    add sp, 4 ; 1AE7
    pop si ; 1AEA
    pop di ; 1AEB
    leave ; 1AEC
    ret ; 1AED
X_0DB9_midi_1AEE:
    lods byte ptr es:[si] ; 1AEE
    and al, 0Fh ; 1AF0
    mov bx, word ptr [bp + 4] ; 1AF2
    push ax ; 1AF5
    push word ptr [bx + 4] ; 1AF6
    call near ptr _snd_1FA2 ; 1AF9
    add sp, 4 ; 1AFC
    pop si ; 1AFF
    pop di ; 1B00
    leave ; 1B01
    ret ; 1B02
X_0DB9_midi_1B03:
    push word ptr [bp + 4] ; 1B03
    call near ptr _snd_20E7 ; 1B06
    inc sp ; 1B09
    inc sp ; 1B0A
    pop si ; 1B0B
    pop di ; 1B0C
    leave ; 1B0D
    ret ; 1B0E
X_0DB9_midi_1B0F:
    lods byte ptr es:[si] ; 1B0F
    and al, 0Fh ; 1B11
    mov dl, al ; 1B13
    lods byte ptr es:[si] ; 1B15
    cmp al, 1 ; 1B17
    je short X_0DB9_midi_1B1E ; 1B19
    jmp near ptr X_0DB9_midi_1D45 ; 1B1B
X_0DB9_midi_1B1E:
    push offset _snd_sysex_buffer ; 1B1E
    push dx ; 1B21
    mov ax, word ptr [bp + 0Ah] ; 1B22
    sub ax, 3 ; 1B25
    push ax ; 1B28
    push offset _snd_sysex_buffer ; 1B29
    push es ; 1B2C
    push si ; 1B2D
    call near ptr X_0DB9_midi_1D49 ; 1B2E
    add sp, 8 ; 1B31
    push word ptr [bp + 4] ; 1B34
    call near ptr _snd_22A4 ; 1B37
    add sp, 6 ; 1B3A
    pop si ; 1B3D
    pop di ; 1B3E
    leave ; 1B3F
    ret ; 1B40
X_0DB9_midi_1B41:
    inc si ; 1B41
    lods byte ptr es:[si] ; 1B42
    cmp al, 1 ; 1B44
    je short X_0DB9_midi_1B4B ; 1B46
    jmp near ptr X_0DB9_midi_1D45 ; 1B48
X_0DB9_midi_1B4B:
    lods byte ptr es:[si] ; 1B4B
    push offset _snd_sysex_buffer ; 1B4D
    push ax ; 1B50
    mov ax, word ptr [bp + 0Ah] ; 1B51
    sub ax, 4 ; 1B54
    push ax ; 1B57
    push offset _snd_sysex_buffer ; 1B58
    push es ; 1B5B
    push si ; 1B5C
    call near ptr X_0DB9_midi_1D49 ; 1B5D
    add sp, 8 ; 1B60
    call near ptr _snd_2679 ; 1B63
    add sp, 4 ; 1B66
    pop si ; 1B69
    pop di ; 1B6A
    leave ; 1B6B
    ret ; 1B6C
X_0DB9_midi_1B6D:
    lods byte ptr es:[si] ; 1B6D
    and al, 0Fh ; 1B6F
    mov di, ax ; 1B71
    lods byte ptr es:[si] ; 1B73
    cmp al, 1 ; 1B75
    je short X_0DB9_midi_1B7C ; 1B77
    jmp near ptr X_0DB9_midi_1D45 ; 1B79
X_0DB9_midi_1B7C:
    mov ax, word ptr [bp + 0Ah] ; 1B7C
    sub ax, 3 ; 1B7F
    push ax ; 1B82
    push offset _snd_sysex_buffer ; 1B83
    push es ; 1B86
    push si ; 1B87
    call near ptr X_0DB9_midi_1D49 ; 1B88
    add sp, 8 ; 1B8B
    push offset _snd_sysex_buffer+02h ; 1B8E
    call near ptr _snd_04CC ; 1B91
    inc sp ; 1B94
    inc sp ; 1B95
    push ax ; 1B96
    push offset _snd_sysex_buffer ; 1B97
    call near ptr _snd_04CC ; 1B9A
    inc sp ; 1B9D
    inc sp ; 1B9E
    push ax ; 1B9F
    push di ; 1BA0
    push word ptr [bp + 4] ; 1BA1
    call near ptr _snd_22CD ; 1BA4
    add sp, 8 ; 1BA7
    pop si ; 1BAA
    pop di ; 1BAB
    leave ; 1BAC
    ret ; 1BAD
X_0DB9_midi_1BAE:
    cmp word ptr [_snd_scanning], 0 ; 1BAE
    je short X_0DB9_midi_1BB8 ; 1BB3
    jmp near ptr X_0DB9_midi_1D45 ; 1BB5
X_0DB9_midi_1BB8:
    mov ax, word ptr [bp + 0Ah] ; 1BB8
    dec ax ; 1BBB
    dec ax ; 1BBC
    push ax ; 1BBD
    push offset _snd_sysex_buffer ; 1BBE
    inc si ; 1BC1
    push es ; 1BC2
    push si ; 1BC3
    call near ptr X_0DB9_midi_1D49 ; 1BC4
    add sp, 8 ; 1BC7
    push offset _snd_sysex_buffer ; 1BCA
    push word ptr [bp + 4] ; 1BCD
    call near ptr X_0DB9_midi_109C ; 1BD0
    add sp, 4 ; 1BD3
    pop si ; 1BD6
    pop di ; 1BD7
    leave ; 1BD8
    ret ; 1BD9
X_0DB9_midi_1BDA:
    mov ax, word ptr [bp + 0Ah] ; 1BDA
    dec ax ; 1BDD
    dec ax ; 1BDE
    push ax ; 1BDF
    push offset _snd_sysex_buffer ; 1BE0
    inc si ; 1BE3
    push es ; 1BE4
    push si ; 1BE5
    call near ptr X_0DB9_midi_1D49 ; 1BE6
    add sp, 8 ; 1BE9
    push offset _snd_sysex_buffer ; 1BEC
    push word ptr [bp + 4] ; 1BEF
    call near ptr X_0DB9_midi_10E7 ; 1BF2
    add sp, 4 ; 1BF5
    pop si ; 1BF8
    pop di ; 1BF9
    leave ; 1BFA
    ret ; 1BFB
X_0DB9_midi_1BFC:
    lods byte ptr es:[si] ; 1BFC
    and al, 0Fh ; 1BFE
    mov byte ptr [_snd_sysex_buffer], al ; 1C00
    mov ax, word ptr [bp + 0Ah] ; 1C03
    dec ax ; 1C06
    dec ax ; 1C07
    push ax ; 1C08
    push offset _snd_sysex_buffer+01h ; 1C09
    push es ; 1C0C
    push si ; 1C0D
    call near ptr X_0DB9_midi_1D49 ; 1C0E
    add sp, 8 ; 1C11
    push offset _snd_sysex_buffer ; 1C14
    push word ptr [bp + 4] ; 1C17
    call near ptr X_0DB9_midi_1118 ; 1C1A
    add sp, 4 ; 1C1D
    pop si ; 1C20
    pop di ; 1C21
    leave ; 1C22
    ret ; 1C23
X_0DB9_midi_1C24:
    lods byte ptr es:[si] ; 1C24
    and al, 0Fh ; 1C26
    mov byte ptr [_snd_sysex_buffer], al ; 1C28
    mov ax, word ptr [bp + 0Ah] ; 1C2B
    dec ax ; 1C2E
    dec ax ; 1C2F
    push ax ; 1C30
    push offset _snd_sysex_buffer+01h ; 1C31
    push es ; 1C34
    push si ; 1C35
    call near ptr X_0DB9_midi_1D49 ; 1C36
    add sp, 8 ; 1C39
    push offset _snd_sysex_buffer ; 1C3C
    push word ptr [bp + 4] ; 1C3F
    call near ptr X_0DB9_midi_114D ; 1C42
    add sp, 4 ; 1C45
    pop si ; 1C48
    pop di ; 1C49
    leave ; 1C4A
    ret ; 1C4B
X_0DB9_midi_1C4C:
    lods byte ptr es:[si] ; 1C4C
    and al, 0Fh ; 1C4E
    mov byte ptr [_snd_sysex_buffer], al ; 1C50
    mov ax, word ptr [bp + 0Ah] ; 1C53
    dec ax ; 1C56
    dec ax ; 1C57
    push ax ; 1C58
    push offset _snd_sysex_buffer+01h ; 1C59
    push es ; 1C5C
    push si ; 1C5D
    call near ptr X_0DB9_midi_1D49 ; 1C5E
    add sp, 8 ; 1C61
    push offset _snd_sysex_buffer ; 1C64
    push word ptr [bp + 4] ; 1C67
    call near ptr X_0DB9_midi_1182 ; 1C6A
    add sp, 4 ; 1C6D
    pop si ; 1C70
    pop di ; 1C71
    leave ; 1C72
    ret ; 1C73
X_0DB9_midi_1C74:
    lods byte ptr es:[si] ; 1C74
    and al, 0Fh ; 1C76
    mov byte ptr [_snd_sysex_buffer], al ; 1C78
    mov ax, word ptr [bp + 0Ah] ; 1C7B
    dec ax ; 1C7E
    dec ax ; 1C7F
    push ax ; 1C80
    push offset _snd_sysex_buffer+01h ; 1C81
    push es ; 1C84
    push si ; 1C85
    call near ptr X_0DB9_midi_1D49 ; 1C86
    add sp, 8 ; 1C89
    push offset _snd_sysex_buffer ; 1C8C
    push word ptr [bp + 4] ; 1C8F
    call near ptr X_0DB9_midi_11B7 ; 1C92
    add sp, 4 ; 1C95
    pop si ; 1C98
    pop di ; 1C99
    leave ; 1C9A
    ret ; 1C9B
X_0DB9_midi_1C9C:
    inc si ; 1C9C
    mov di, word ptr [bp + 0Ah] ; 1C9D
    dec di ; 1CA0
    dec di ; 1CA1
X_0DB9_midi_1CA2:
    dec di ; 1CA2
    jns short X_0DB9_midi_1CA8 ; 1CA3
    jmp near ptr X_0DB9_midi_1D45 ; 1CA5
X_0DB9_midi_1CA8:
    lods byte ptr es:[si] ; 1CA8
    push ax ; 1CAA
    push word ptr [bp + 4] ; 1CAB
    call near ptr X_0DB9_midi_171D ; 1CAE
    add sp, 4 ; 1CB1
    jmp short X_0DB9_midi_1CA2 ; 1CB4
X_0DB9_midi_1CB6:
    mov ax, word ptr [bp + 0Ah] ; 1CB6
    dec ax ; 1CB9
    dec ax ; 1CBA
    push ax ; 1CBB
    push offset _snd_sysex_buffer ; 1CBC
    inc si ; 1CBF
    push es ; 1CC0
    push si ; 1CC1
    call near ptr X_0DB9_midi_1D49 ; 1CC2
    add sp, 8 ; 1CC5
    push offset _snd_sysex_buffer+08h ; 1CC8
    call near ptr _snd_04CC ; 1CCB
    inc sp ; 1CCE
    inc sp ; 1CCF
    push ax ; 1CD0
    push offset _snd_sysex_buffer+06h ; 1CD1
    call near ptr _snd_04CC ; 1CD4
    inc sp ; 1CD7
    inc sp ; 1CD8
    push ax ; 1CD9
    push offset _snd_sysex_buffer+04h ; 1CDA
    call near ptr _snd_04CC ; 1CDD
    inc sp ; 1CE0
    inc sp ; 1CE1
    push ax ; 1CE2
    push offset _snd_sysex_buffer+02h ; 1CE3
    call near ptr _snd_04CC ; 1CE6
    inc sp ; 1CE9
    inc sp ; 1CEA
    push ax ; 1CEB
    push offset _snd_sysex_buffer ; 1CEC
    call near ptr _snd_04CC ; 1CEF
    inc sp ; 1CF2
    inc sp ; 1CF3
    push ax ; 1CF4
    mov bx, word ptr [bp + 4] ; 1CF5
    push word ptr [bx] ; 1CF8
    call near ptr _snd_0B2E ; 1CFA
    add sp, 0Ch ; 1CFD
    pop si ; 1D00
    pop di ; 1D01
    leave ; 1D02
    ret ; 1D03
X_0DB9_midi_1D04:
    mov bx, word ptr [bp + 4] ; 1D04
    push word ptr [bx] ; 1D07
    call near ptr _snd_0B6E ; 1D09
    inc sp ; 1D0C
    inc sp ; 1D0D
    pop si ; 1D0E
    pop di ; 1D0F
    leave ; 1D10
    ret ; 1D11
X_0DB9_midi_1D12:
    lods byte ptr es:[si] ; 1D12
    and ax, 0Fh ; 1D14
    mov cx, ax ; 1D17
    lods byte ptr es:[si] ; 1D19
    and al, 0Fh ; 1D1B
    mov si, ax ; 1D1D
    shl si, 4 ; 1D1F
    lods byte ptr es:[si] ; 1D22
    and al, 0Fh ; 1D24
    or si, ax ; 1D26
    shl si, 4 ; 1D28
    lods byte ptr es:[si] ; 1D2B
    and al, 0Fh ; 1D2D
    or si, ax ; 1D2F
    shl si, 4 ; 1D31
    lods byte ptr es:[si] ; 1D34
    and al, 0Fh ; 1D36
    or ax, si ; 1D38
    push ax ; 1D3A
    push cx ; 1D3B
    push word ptr [bp + 4] ; 1D3C
    call near ptr _snd_2277 ; 1D3F
    add sp, 6 ; 1D42
X_0DB9_midi_1D45:
    pop si ; 1D45
    pop di ; 1D46
    leave ; 1D47
    ret ; 1D48

; unpack paired nibbles; original CS:1D49
_snd_1D49 label near
X_0DB9_midi_1D49:
    enter 0, 0 ; 1D49
    push si ; 1D4D
    mov cx, word ptr [bp + 0Ah] ; 1D4E
    jcxz short X_0DB9_midi_1D6A ; 1D51
    inc cx ; 1D53
    inc cx ; 1D54
    shr cx, 1 ; 1D55
    cld ; 1D57
    mov bx, word ptr [bp + 8] ; 1D58
    les si, dword ptr [bp + 4] ; 1D5B
X_0DB9_midi_1D5E:
    lods word ptr es:[si] ; 1D5E
    shl al, 4 ; 1D60
    or al, ah ; 1D63
    mov byte ptr [bx], al ; 1D65
    inc bx ; 1D67
    loop X_0DB9_midi_1D5E ; 1D68
X_0DB9_midi_1D6A:
    pop si ; 1D6A
    leave ; 1D6B
    ret ; 1D6C

; skip one MIDI event; original CS:1D6D
_snd_1D6D label near
X_0DB9_midi_1D6D:
    enter 0, 0 ; 1D6D
    push si ; 1D71
    mov si, word ptr [bp + 4] ; 1D72
    les bx, dword ptr [si] ; 1D75
    inc word ptr [si] ; 1D77
    mov al, byte ptr es:[bx] ; 1D79
    cmp al, 080h ; 1D7C
    jae short X_0DB9_midi_1D85 ; 1D7E
    mov ax, 1 ; 1D80
    jmp short X_0DB9_midi_1DB7 ; 1D83
X_0DB9_midi_1D85:
    cmp al, 0F0h ; 1D85
    jae short X_0DB9_midi_1D9B ; 1D87
    mov bl, al ; 1D89
    and bl, 070h ; 1D8B
    shr bl, 4 ; 1D8E
    xor bh, bh ; 1D91
    mov al, byte ptr [bx + _snd_midi_lengths] ; 1D93
    xor ah, ah ; 1D97
    jmp short X_0DB9_midi_1DB7 ; 1D99
X_0DB9_midi_1D9B:
    cmp al, 0F0h ; 1D9B
    je short X_0DB9_midi_1DB0 ; 1D9D
    cmp al, 0F7h ; 1D9F
    je short X_0DB9_midi_1DB0 ; 1DA1
    cmp al, 0FFh ; 1DA3
    jne short X_0DB9_midi_1DBC ; 1DA5
    inc word ptr [si] ; 1DA7
    cmp byte ptr es:[bx + 1], 02Fh ; 1DA9
    je short X_0DB9_midi_1DBC ; 1DAE
X_0DB9_midi_1DB0:
    push si ; 1DB0
    call near ptr X_0DB9_midi_101E ; 1DB1
    add sp, 2 ; 1DB4
X_0DB9_midi_1DB7:
    add word ptr [si], ax ; 1DB7
    pop si ; 1DB9
    leave ; 1DBA
    ret ; 1DBB
X_0DB9_midi_1DBC:
    xor ax, ax ; 1DBC
    mov word ptr [si], ax ; 1DBE
    mov word ptr [si + 2], ax ; 1DC0
    pop si ; 1DC3
    leave ; 1DC4
    ret ; 1DC5

; reset OPL; original CS:1DC6
_snd_1DC6 label near
X_0DB9_midi_1DC6:
    xor ax, ax ; 1DC6
    mov cx, 0100h ; 1DC8
X_0DB9_midi_1DCB:
    dec ah ; 1DCB
    call near ptr _snd_3164 ; 1DCD
    mov bx, 1 ; 1DD0
    call near ptr _snd_0496 ; 1DD3
    loop X_0DB9_midi_1DCB ; 1DD6
    xor ax, ax ; 1DD8
    ret ; 1DDA

; initialize OPL voices; original CS:1DDB
_snd_1DDB label far
X_0DB9_midi_1DDB:
    mov bx, offset _snd_voices ; 1DDB
    xor cx, cx ; 1DDE
X_0DB9_midi_1DE0:
    xor ax, ax ; 1DE0
    mov word ptr [bx], ax ; 1DE2
    mov word ptr [bx + 2], ax ; 1DE4
    mov word ptr [bx + 4], ax ; 1DE7
    mov byte ptr [bx + 7], cl ; 1DEA
    lea ax, [bx + 038h] ; 1DED
    mov word ptr [bx + 036h], ax ; 1DF0
    lea ax, [bx + 0Eh] ; 1DF3
    mov word ptr [bx + 060h], ax ; 1DF6
    add bx, 062h ; 1DF9
    inc cx ; 1DFC
    cmp cx, 9 ; 1DFD
    jl short X_0DB9_midi_1DE0 ; 1E00
    call near ptr X_0DB9_midi_1DC6 ; 1E02
    mov ax, 0120h ; 1E05
    call near ptr _snd_312B ; 1E08
    mov ax, 0840h ; 1E0B
    call near ptr _snd_312B ; 1E0E
    mov ax, 0BD00h ; 1E11
    call near ptr _snd_312B ; 1E14
    xor ax, ax ; 1E17
    retf ; 1E19

; exact/ADLIB.ASM _TEXT 1E1A..2E9B
public _snd_1E1A
public _snd_1E83
public _snd_1FA2
public _snd_1FCC
public _snd_1FE4
public _snd_20AA
public _snd_20E7
public _snd_2102
public _snd_2129
public _snd_216C
public _snd_21A2
public _snd_21EF
public _snd_2209
public _snd_222F
public _snd_2277
public _snd_22A4
public _snd_22CD
public _snd_22F1
public _snd_235A
public _snd_23D1
public _snd_23D2
public _snd_247E
public _snd_2509
public _snd_253C
public _snd_2567
public _snd_2594
public _snd_25E7
public _snd_261A
public _snd_2665
public _snd_2679
public _snd_269B
public _snd_26C3
public _snd_2709
public _snd_2750
public _snd_2772
public _snd_278D
public _snd_28BD
public _snd_28DB
public _snd_28FB
public _snd_29A1
public _snd_2A5E
public _snd_2A87
public _snd_2AD9
public _snd_2B03
public _snd_2B3F
public _snd_2B6C
public _snd_2BC4
public _snd_2BF6
public _snd_2C59
public _snd_2D33
public _snd_2DD3
public _snd_2E7A


; Advance voice and envelope timers
_snd_1E1A label near
    push di ; 1E1A
    push si ; 1E1B
    add byte ptr [_snd_voice_tick], 3 ; 1E1C
    cmp byte ptr [_snd_voice_tick], 0Ah ; 1E21
    jb X_1E1A_L1E80 ; 1E26
    sub byte ptr [_snd_voice_tick], 0Ah ; 1E28
    mov si, offset _snd_voices ; 1E2D
    mov di, 9 ; 1E30
X_1E1A_L1E33:
    cmp word ptr [si], 0 ; 1E33
    je X_1E1A_L1E72 ; 1E36
    cmp word ptr [si + 0Ch], 0 ; 1E38
    je X_1E1A_L1E48 ; 1E3C
    sub word ptr [si + 0Ch], 011h ; 1E3E
    cmp word ptr [si + 0Ch], 0 ; 1E42
    jle X_1E1A_L1E7A ; 1E46
X_1E1A_L1E48:
    cmp byte ptr [si + 0Eh], 0 ; 1E48
    je X_1E1A_L1E5D ; 1E4C
    lea ax, [si + 030h] ; 1E4E
    push ax ; 1E51
    lea ax, [si + 0Eh] ; 1E52
    push ax ; 1E55
    push si ; 1E56
    call near ptr _snd_28FB ; 1E57
    add sp, 6 ; 1E5A
X_1E1A_L1E5D:
    cmp byte ptr [si + 038h], 0 ; 1E5D
    je X_1E1A_L1E72 ; 1E61
    lea ax, [si + 05Ah] ; 1E63
    push ax ; 1E66
    lea ax, [si + 038h] ; 1E67
    push ax ; 1E6A
    push si ; 1E6B
    call near ptr _snd_28FB ; 1E6C
    add sp, 6 ; 1E6F
X_1E1A_L1E72:
    add si, 062h ; 1E72
    dec di ; 1E75
    je X_1E1A_L1E80 ; 1E76
    jmp short X_1E1A_L1E33 ; 1E78
X_1E1A_L1E7A:
    push si ; 1E7A
    call near ptr _snd_2BC4 ; 1E7B
    inc sp ; 1E7E
    inc sp ; 1E7F
X_1E1A_L1E80:
    pop si ; 1E80
    pop di ; 1E81
    ret ; 1E82

; Allocate and initialize an instrument part from a preset
_snd_1E83 label near
    enter 2, 0 ; 1E83
    push di ; 1E87
    push si ; 1E88
    mov di, word ptr [bp + 6] ; 1E89
    mov al, byte ptr [di + 2] ; 1E8C
    cbw ; 1E8F
    mov bx, word ptr [bp + 4] ; 1E90
    mov cl, byte ptr [bx + 0Ch] ; 1E93
    xor ch, ch ; 1E96
    add ax, cx ; 1E98
    push 0FFh ; 1E9A
    push 0 ; 1E9D
    push ax ; 1E9F
    call near ptr _snd_04D9 ; 1EA0
    add sp, 6 ; 1EA3
    mov byte ptr [bp - 2], al ; 1EA6
    push ax ; 1EA9
    call near ptr _snd_2129 ; 1EAA
    inc sp ; 1EAD
    inc sp ; 1EAE
    or ax, ax ; 1EAF
    jne X_1E1A_L1EB6 ; 1EB1
    jmp near ptr X_1E1A_L1F9E ; 1EB3
X_1E1A_L1EB6:
    mov si, ax ; 1EB6
    push si ; 1EB8
    push word ptr [bp + 4] ; 1EB9
    call near ptr _snd_2102 ; 1EBC
    add sp, 4 ; 1EBF
    mov al, byte ptr [di] ; 1EC2
    mov byte ptr [si + 0Bh], al ; 1EC4
    mov al, byte ptr [di + 1] ; 1EC7
    and al, 1 ; 1ECA
    mov byte ptr [si + 0Dh], al ; 1ECC
    mov al, byte ptr [di + 2] ; 1ECF
    mov byte ptr [si + 0Eh], al ; 1ED2
    mov al, byte ptr [bp - 2] ; 1ED5
    mov byte ptr [si + 0Fh], al ; 1ED8
    mov al, byte ptr [di + 3] ; 1EDB
    mov byte ptr [si + 010h], al ; 1EDE
    xor ah, ah ; 1EE1
    inc ax ; 1EE3
    mov bx, word ptr [bp + 4] ; 1EE4
    mov cl, byte ptr [bx + 0Eh] ; 1EE7
    xor ch, ch ; 1EEA
    imul cx ; 1EEC
    sar ax, 7 ; 1EEE
    mov byte ptr [si + 011h], al ; 1EF1
    mov al, byte ptr [di + 4] ; 1EF4
    mov byte ptr [si + 012h], al ; 1EF7
    cbw ; 1EFA
    mov cx, ax ; 1EFB
    mov al, byte ptr [bx + 0Fh] ; 1EFD
    cbw ; 1F00
    add cx, ax ; 1F01
    push 03Fh ; 1F03
    push -040h ; 1F05
    push cx ; 1F07
    call near ptr _snd_04D9 ; 1F08
    add sp, 6 ; 1F0B
    mov byte ptr [si + 013h], al ; 1F0E
    mov al, byte ptr [di + 5] ; 1F11
    mov byte ptr [si + 014h], al ; 1F14
    cmp al, 080h ; 1F17
    mov al, 0 ; 1F19
    je X_1E1A_L1F37 ; 1F1B
    mov bx, word ptr [bp + 4] ; 1F1D
    mov al, byte ptr [bx + 010h] ; 1F20
    cbw ; 1F23
    mov cx, ax ; 1F24
    mov al, byte ptr [si + 014h] ; 1F26
    cbw ; 1F29
    add cx, ax ; 1F2A
    push 0Ch ; 1F2C
    push -0Ch ; 1F2E
    push cx ; 1F30
    call near ptr _snd_04F4 ; 1F31
    add sp, 6 ; 1F34
X_1E1A_L1F37:
    mov byte ptr [si + 015h], al ; 1F37
    xor al, al ; 1F3A
    mov byte ptr [si + 018h], al ; 1F3C
    mov byte ptr [si + 019h], al ; 1F3F
    mov al, byte ptr [di + 7] ; 1F42
    mov byte ptr [si + 01Ah], al ; 1F45
    mov word ptr [si + 01Ch], 0 ; 1F48
    mov bx, word ptr [bp + 4] ; 1F4D
    mov al, byte ptr [bx + 011h] ; 1F50
    cbw ; 1F53
    mov cx, ax ; 1F54
    mov al, byte ptr [di + 6] ; 1F56
    mov byte ptr [si + 016h], al ; 1F59
    cbw ; 1F5C
    add cx, ax ; 1F5D
    push 07Fh ; 1F5F
    push -080h ; 1F61
    push cx ; 1F63
    call near ptr _snd_04D9 ; 1F64
    add sp, 6 ; 1F67
    mov byte ptr [si + 017h], al ; 1F6A
    mov cx, ax ; 1F6D
    mov al, byte ptr [si + 015h] ; 1F6F
    cbw ; 1F72
    shl ax, 7 ; 1F73
    mov dx, ax ; 1F76
    mov al, cl ; 1F78
    cbw ; 1F7A
    add dx, ax ; 1F7B
    push 07FFh ; 1F7D
    push 0F800h ; 1F80
    push dx ; 1F83
    call near ptr _snd_04D9 ; 1F84
    add sp, 6 ; 1F87
    mov word ptr [si + 01Eh], ax ; 1F8A
    mov al, byte ptr [di + 8] ; 1F8D
    push ax ; 1F90
    mov al, byte ptr [si + 0Bh] ; 1F91
    push ax ; 1F94
    push word ptr [bp + 4] ; 1F95
    call near ptr _snd_2277 ; 1F98
    add sp, 6 ; 1F9B
X_1E1A_L1F9E:
    pop si ; 1F9E
    pop di ; 1F9F
    leave ; 1FA0
    ret ; 1FA1

; Recursively release parts belonging to a channel
_snd_1FA2 label near
    enter 0, 0 ; 1FA2
    push si ; 1FA6
    mov si, word ptr [bp + 4] ; 1FA7
    or si, si ; 1FAA
    je X_1E1A_L1FC9 ; 1FAC
    mov al, byte ptr [bp + 6] ; 1FAE
    push ax ; 1FB1
    push word ptr [si + 4] ; 1FB2
    call near ptr _snd_1FA2 ; 1FB5
    add sp, 4 ; 1FB8
    mov al, byte ptr [bp + 6] ; 1FBB
    cmp byte ptr [si + 0Bh], al ; 1FBE
    jne X_1E1A_L1FC9 ; 1FC1
    push si ; 1FC3
    call near ptr _snd_20AA ; 1FC4
    inc sp ; 1FC7
    inc sp ; 1FC8
X_1E1A_L1FC9:
    pop si ; 1FC9
    leave ; 1FCA
    ret ; 1FCB

; Release all parts and reset held notes
_snd_1FCC label near
    push si ; 1FCC
    mov si, offset _snd_parts ; 1FCD
X_1E1A_L1FD0:
    push si ; 1FD0
    call near ptr _snd_20AA ; 1FD1
    inc sp ; 1FD4
    inc sp ; 1FD5
    add si, 020h ; 1FD6
    cmp si, offset _snd_parts+1024 ; 1FD9
    jb X_1E1A_L1FD0 ; 1FDD
    call near ptr _snd_1DC6 ; 1FDF
    pop si ; 1FE2
    ret ; 1FE3

; Find or allocate a player channel part
_snd_1FE4 label near
    enter 0, 0 ; 1FE4
    push si ; 1FE8
    push di ; 1FE9
    mov di, word ptr [bp + 4] ; 1FEA
    mov si, word ptr [di + 4] ; 1FED
X_1E1A_L1FF0:
    or si, si ; 1FF0
    je X_1E1A_L2004 ; 1FF2
    mov al, byte ptr [bp + 6] ; 1FF4
    cmp byte ptr [si + 0Bh], al ; 1FF7
    jne X_1E1A_L1FFF ; 1FFA
    jmp near ptr X_1E1A_L20A4 ; 1FFC
X_1E1A_L1FFF:
    mov si, word ptr [si + 4] ; 1FFF
    jmp short X_1E1A_L1FF0 ; 2002
X_1E1A_L2004:
    mov al, byte ptr [di + 0Ch] ; 2004
    push ax ; 2007
    call near ptr _snd_2129 ; 2008
    inc sp ; 200B
    inc sp ; 200C
    or ax, ax ; 200D
    jne X_1E1A_L2015 ; 200F
    pop di ; 2011
    pop si ; 2012
    leave ; 2013
    ret ; 2014
X_1E1A_L2015:
    mov si, ax ; 2015
    mov word ptr [si], di ; 2017
    mov word ptr [si + 2], 0 ; 2019
    mov bx, word ptr [di + 4] ; 201E
    mov word ptr [si + 4], bx ; 2021
    mov word ptr [di + 4], si ; 2024
    or bx, bx ; 2027
    je X_1E1A_L202E ; 2029
    mov word ptr [bx + 2], si ; 202B
X_1E1A_L202E:
    mov al, byte ptr [bp + 6] ; 202E
    mov byte ptr [si + 0Bh], al ; 2031
    mov al, 1 ; 2034
    mov byte ptr [si + 0Ch], al ; 2036
    mov byte ptr [si + 0Dh], al ; 2039
    mov al, byte ptr [di + 0Ch] ; 203C
    mov byte ptr [si + 0Fh], al ; 203F
    mov byte ptr [si + 010h], 07Fh ; 2042
    mov al, byte ptr [di + 0Eh] ; 2046
    mov byte ptr [si + 011h], al ; 2049
    mov al, byte ptr [di + 0Fh] ; 204C
    cbw ; 204F
    push 03Fh ; 2050
    push -040h ; 2052
    push ax ; 2054
    call near ptr _snd_04D9 ; 2055
    add sp, 6 ; 2058
    mov byte ptr [si + 013h], al ; 205B
    xor al, al ; 205E
    mov byte ptr [si + 0Eh], al ; 2060
    mov byte ptr [si + 012h], al ; 2063
    mov byte ptr [si + 014h], al ; 2066
    mov byte ptr [si + 016h], al ; 2069
    mov byte ptr [si + 01Ah], 2 ; 206C
    mov word ptr [si + 01Ch], 0 ; 2070
    mov cl, byte ptr [di + 011h] ; 2075
    mov byte ptr [si + 017h], cl ; 2078
    mov al, byte ptr [di + 010h] ; 207B
    mov byte ptr [si + 015h], al ; 207E
    cbw ; 2081
    shl ax, 7 ; 2082
    xchg cx, ax ; 2085
    cbw ; 2086
    add ax, cx ; 2087
    push 07FFh ; 2089
    push 0F800h ; 208C
    push ax ; 208F
    call near ptr _snd_04D9 ; 2090
    add sp, 6 ; 2093
    mov word ptr [si + 01Eh], ax ; 2096
    xor al, al ; 2099
    mov byte ptr [si + 018h], al ; 209B
    mov byte ptr [si + 019h], al ; 209E
    mov byte ptr [si + 0Ah], al ; 20A1
X_1E1A_L20A4:
    mov ax, si ; 20A4
    pop di ; 20A6
    pop si ; 20A7
    leave ; 20A8
    ret ; 20A9

; Unlink and release a part and its voices
_snd_20AA label near
    enter 0, 0 ; 20AA
    push si ; 20AE
    mov si, word ptr [bp + 4] ; 20AF
    cmp word ptr [si], 0 ; 20B2
    je X_1E1A_L20E4 ; 20B5
    push si ; 20B7
    call near ptr _snd_2772 ; 20B8
    inc sp ; 20BB
    inc sp ; 20BC
    mov ax, word ptr [si + 2] ; 20BD
    mov bx, word ptr [si + 4] ; 20C0
    or bx, bx ; 20C3
    je X_1E1A_L20CA ; 20C5
    mov word ptr [bx + 2], ax ; 20C7
X_1E1A_L20CA:
    or ax, ax ; 20CA
    je X_1E1A_L20D4 ; 20CC
    xchg bx, ax ; 20CE
    mov word ptr [bx + 4], ax ; 20CF
    jmp short X_1E1A_L20DA ; 20D2
X_1E1A_L20D4:
    mov ax, word ptr [si] ; 20D4
    xchg bx, ax ; 20D6
    mov word ptr [bx + 4], ax ; 20D7
X_1E1A_L20DA:
    xor ax, ax ; 20DA
    mov word ptr [si], ax ; 20DC
    mov word ptr [si + 2], ax ; 20DE
    mov word ptr [si + 4], ax ; 20E1
X_1E1A_L20E4:
    pop si ; 20E4
    leave ; 20E5
    ret ; 20E6

; Release every part owned by a player
_snd_20E7 label near
    enter 0, 0 ; 20E7
    push si ; 20EB
    mov si, word ptr [bp + 4] ; 20EC
    jmp short X_1E1A_L20F9 ; 20EF
X_1E1A_L20F1:
    push word ptr [si + 4] ; 20F1
    call near ptr _snd_20AA ; 20F4
    inc sp ; 20F7
    inc sp ; 20F8
X_1E1A_L20F9:
    cmp word ptr [si + 4], 0 ; 20F9
    jne X_1E1A_L20F1 ; 20FD
    pop si ; 20FF
    leave ; 2100
    ret ; 2101

; Link a part into its player list
_snd_2102 label near
    enter 0, 0 ; 2102
    push si ; 2106
    mov bx, word ptr [bp + 6] ; 2107
    mov word ptr [bx + 2], 0 ; 210A
    mov si, word ptr [bp + 4] ; 210F
    mov word ptr [bx], si ; 2112
    mov ax, word ptr [si + 4] ; 2114
    mov word ptr [bx + 4], ax ; 2117
    mov word ptr [si + 4], bx ; 211A
    or ax, ax ; 211D
    je X_1E1A_L2126 ; 211F
    mov si, ax ; 2121
    mov word ptr [si + 2], bx ; 2123
X_1E1A_L2126:
    pop si ; 2126
    leave ; 2127
    ret ; 2128

; Allocate a free part or steal one by priority
_snd_2129 label near
    enter 0, 0 ; 2129
    push si ; 212D
    push di ; 212E
    mov si, offset _snd_parts ; 212F
    xor di, di ; 2132
    xor dx, dx ; 2134
X_1E1A_L2136:
    cmp word ptr [si], 0 ; 2136
    je X_1E1A_L2156 ; 2139
    mov al, byte ptr [bp + 4] ; 213B
    cmp byte ptr [si + 0Fh], al ; 213E
    ja X_1E1A_L214B ; 2141
    mov al, byte ptr [si + 0Fh] ; 2143
    mov byte ptr [bp + 4], al ; 2146
    mov di, si ; 2149
X_1E1A_L214B:
    add si, 020h ; 214B
    inc dx ; 214E
    cmp dx, 020h ; 214F
    jl X_1E1A_L2136 ; 2152
    jmp short X_1E1A_L215C ; 2154
X_1E1A_L2156:
    mov ax, si ; 2156
    pop di ; 2158
    pop si ; 2159
    leave ; 215A
    ret ; 215B
X_1E1A_L215C:
    or di, di ; 215C
    je X_1E1A_L2166 ; 215E
    push di ; 2160
    call near ptr _snd_20AA ; 2161
    inc sp ; 2164
    inc sp ; 2165
X_1E1A_L2166:
    mov ax, di ; 2166
    pop di ; 2168
    pop si ; 2169
    leave ; 216A
    ret ; 216B

; Start a note on a player channel
_snd_216C label near
    enter 0, 0 ; 216C
    push si ; 2170
    mov al, byte ptr [bp + 6] ; 2171
    push ax ; 2174
    push word ptr [bp + 4] ; 2175
    call near ptr _snd_1FE4 ; 2178
    add sp, 4 ; 217B
    or ax, ax ; 217E
    je X_1E1A_L219F ; 2180
    mov si, ax ; 2182
    cmp byte ptr [si + 0Dh], 0 ; 2184
    je X_1E1A_L219F ; 2188
    cmp byte ptr [si + 0Ch], 0 ; 218A
    jne X_1E1A_L219F ; 218E
    mov al, byte ptr [bp + 0Ah] ; 2190
    push ax ; 2193
    mov al, byte ptr [bp + 8] ; 2194
    push ax ; 2197
    push si ; 2198
    call near ptr _snd_2709 ; 2199
    add sp, 6 ; 219C
X_1E1A_L219F:
    pop si ; 219F
    leave ; 21A0
    ret ; 21A1

; Stop or sustain a note on a player channel
_snd_21A2 label near
    enter 0, 0 ; 21A2
    push si ; 21A6
    mov bx, word ptr [bp + 4] ; 21A7
    mov si, word ptr [bx + 4] ; 21AA
X_1E1A_L21AD:
    or si, si ; 21AD
    je X_1E1A_L21EC ; 21AF
    mov al, byte ptr [bp + 6] ; 21B1
    cmp byte ptr [si + 0Bh], al ; 21B4
    jne X_1E1A_L21E7 ; 21B7
    cmp byte ptr [si + 0Dh], 0 ; 21B9
    je X_1E1A_L21E7 ; 21BD
    cmp byte ptr [si + 0Ch], 0 ; 21BF
    jne X_1E1A_L21E7 ; 21C3
    cmp byte ptr [si + 019h], 0 ; 21C5
    je X_1E1A_L21DA ; 21C9
    mov al, byte ptr [bp + 8] ; 21CB
    push ax ; 21CE
    push word ptr [si + 6] ; 21CF
    call near ptr _snd_28BD ; 21D2
    add sp, 4 ; 21D5
    jmp short X_1E1A_L21E7 ; 21D8
X_1E1A_L21DA:
    mov al, byte ptr [bp + 8] ; 21DA
    push ax ; 21DD
    push word ptr [si + 6] ; 21DE
    call near ptr _snd_2750 ; 21E1
    add sp, 4 ; 21E4
X_1E1A_L21E7:
    mov si, word ptr [si + 4] ; 21E7
    jmp short X_1E1A_L21AD ; 21EA
X_1E1A_L21EC:
    pop si ; 21EC
    leave ; 21ED
    ret ; 21EE

; Stop voices on a list of parts
_snd_21EF label near
    enter 0, 0 ; 21EF
    push si ; 21F3
    mov si, word ptr [bp + 4] ; 21F4
X_1E1A_L21F7:
    or si, si ; 21F7
    je X_1E1A_L2206 ; 21F9
    push si ; 21FB
    call near ptr _snd_2772 ; 21FC
    inc sp ; 21FF
    inc sp ; 2200
    mov si, word ptr [si + 4] ; 2201
    jmp short X_1E1A_L21F7 ; 2204
X_1E1A_L2206:
    pop si ; 2206
    leave ; 2207
    ret ; 2208

; Release sustained voices on a list of parts
_snd_2209 label near
    enter 0, 0 ; 2209
    push si ; 220D
    mov si, word ptr [bp + 4] ; 220E
X_1E1A_L2211:
    or si, si ; 2211
    je X_1E1A_L222C ; 2213
    cmp byte ptr [si + 019h], 0 ; 2215
    je X_1E1A_L2227 ; 2219
    mov byte ptr [si + 019h], 0 ; 221B
    push word ptr [si + 6] ; 221F
    call near ptr _snd_28DB ; 2222
    inc sp ; 2225
    inc sp ; 2226
X_1E1A_L2227:
    mov si, word ptr [si + 4] ; 2227
    jmp short X_1E1A_L2211 ; 222A
X_1E1A_L222C:
    pop si ; 222C
    leave ; 222D
    ret ; 222E

; Collect note/channel masks from active voices
_snd_222F label near
    enter 0, 0 ; 222F
    push di ; 2233
    push si ; 2234
    mov dx, word ptr [bp + 6] ; 2235
    mov cx, word ptr [bp + 8] ; 2238
    mov si, word ptr [bp + 4] ; 223B
X_1E1A_L223E:
    or si, si ; 223E
    je X_1E1A_L2273 ; 2240
    mov di, word ptr [si + 6] ; 2242
    or di, di ; 2245
    je X_1E1A_L226E ; 2247
    mov bl, byte ptr [si + 0Bh] ; 2249
    xor bh, bh ; 224C
    shl bx, 1 ; 224E
    mov ax, word ptr [bx + _snd_channel_masks] ; 2250
X_1E1A_L2254:
    mov bl, byte ptr [di + 8] ; 2254
    xor bh, bh ; 2257
    shl bx, 1 ; 2259
    add bx, dx ; 225B
    test word ptr [bx], ax ; 225D
    jne X_1E1A_L2267 ; 225F
    or word ptr [bx], ax ; 2261
    mov bx, cx ; 2263
    inc word ptr [bx] ; 2265
X_1E1A_L2267:
    mov di, word ptr [di + 4] ; 2267
    or di, di ; 226A
    jne X_1E1A_L2254 ; 226C
X_1E1A_L226E:
    mov si, word ptr [si + 4] ; 226E
    jmp short X_1E1A_L223E ; 2271
X_1E1A_L2273:
    pop si ; 2273
    pop di ; 2274
    leave ; 2275
    ret ; 2276

; Set instrument program
_snd_2277 label near
    enter 0, 0 ; 2277
    push si ; 227B
    mov al, byte ptr [bp + 6] ; 227C
    push ax ; 227F
    push word ptr [bp + 4] ; 2280
    call near ptr _snd_1FE4 ; 2283
    add sp, 4 ; 2286
    or ax, ax ; 2289
    je X_1E1A_L22A1 ; 228B
    mov si, ax ; 228D
    mov al, byte ptr [bp + 8] ; 228F
    mov byte ptr [si + 0Ah], al ; 2292
    push ax ; 2295
    push si ; 2296
    call near ptr _snd_269B ; 2297
    add sp, 4 ; 229A
    mov byte ptr [si + 0Ch], 0 ; 229D
X_1E1A_L22A1:
    pop si ; 22A1
    leave ; 22A2
    ret ; 22A3

; Set a custom instrument
_snd_22A4 label near
    enter 0, 0 ; 22A4
    push si ; 22A8
    mov al, byte ptr [bp + 6] ; 22A9
    push ax ; 22AC
    push word ptr [bp + 4] ; 22AD
    call near ptr _snd_1FE4 ; 22B0
    add sp, 4 ; 22B3
    or ax, ax ; 22B6
    je X_1E1A_L22CA ; 22B8
    mov si, ax ; 22BA
    push word ptr [bp + 8] ; 22BC
    push si ; 22BF
    call near ptr _snd_2665 ; 22C0
    add sp, 4 ; 22C3
    mov byte ptr [si + 0Ch], 0 ; 22C6
X_1E1A_L22CA:
    pop si ; 22CA
    leave ; 22CB
    ret ; 22CC

; Set an instrument parameter
_snd_22CD label near
    enter 0, 0 ; 22CD
    mov al, byte ptr [bp + 6] ; 22D1
    push ax ; 22D4
    push word ptr [bp + 4] ; 22D5
    call near ptr _snd_1FE4 ; 22D8
    add sp, 4 ; 22DB
    or ax, ax ; 22DE
    je X_1E1A_L22EF ; 22E0
    push word ptr [bp + 0Ah] ; 22E2
    push word ptr [bp + 8] ; 22E5
    push ax ; 22E8
    call near ptr _snd_26C3 ; 22E9
    add sp, 6 ; 22EC
X_1E1A_L22EF:
    leave ; 22EF
    ret ; 22F0

; Set effective part priority
_snd_22F1 label near
    enter 0, 0 ; 22F1
    push si ; 22F5
    cmp byte ptr [bp + 6], 010h ; 22F6
    jne X_1E1A_L2325 ; 22FA
    mov bx, word ptr [bp + 4] ; 22FC
    mov si, word ptr [bx + 4] ; 22FF
X_1E1A_L2302:
    or si, si ; 2302
    je X_1E1A_L2357 ; 2304
    mov al, byte ptr [si + 0Eh] ; 2306
    cbw ; 2309
    mov cl, byte ptr [bp + 8] ; 230A
    xor ch, ch ; 230D
    add ax, cx ; 230F
    push 0FFh ; 2311
    push 0 ; 2314
    push ax ; 2316
    call near ptr _snd_04D9 ; 2317
    add sp, 6 ; 231A
    mov byte ptr [si + 0Fh], al ; 231D
    mov si, word ptr [si + 4] ; 2320
    jmp short X_1E1A_L2302 ; 2323
X_1E1A_L2325:
    mov al, byte ptr [bp + 6] ; 2325
    push ax ; 2328
    push word ptr [bp + 4] ; 2329
    call near ptr _snd_1FE4 ; 232C
    add sp, 4 ; 232F
    or ax, ax ; 2332
    je X_1E1A_L2357 ; 2334
    mov si, ax ; 2336
    mov al, byte ptr [bp + 8] ; 2338
    mov byte ptr [si + 0Eh], al ; 233B
    cbw ; 233E
    mov bx, word ptr [si] ; 233F
    mov cl, byte ptr [bx + 0Ch] ; 2341
    xor ch, ch ; 2344
    add ax, cx ; 2346
    push 0FFh ; 2348
    push 0 ; 234B
    push ax ; 234D
    call near ptr _snd_04D9 ; 234E
    add sp, 6 ; 2351
    mov byte ptr [si + 0Fh], al ; 2354
X_1E1A_L2357:
    pop si ; 2357
    leave ; 2358
    ret ; 2359

; Set part volume and update its voices
_snd_235A label near
    enter 0, 0 ; 235A
    push si ; 235E
    cmp byte ptr [bp + 6], 010h ; 235F
    jne X_1E1A_L2391 ; 2363
    mov bx, word ptr [bp + 4] ; 2365
    mov si, word ptr [bx + 4] ; 2368
X_1E1A_L236B:
    or si, si ; 236B
    je X_1E1A_L23C6 ; 236D
    mov al, byte ptr [si + 010h] ; 236F
    xor ah, ah ; 2372
    inc ax ; 2374
    mov cl, byte ptr [bp + 8] ; 2375
    xor ch, ch ; 2378
    imul cx ; 237A
    sar ax, 7 ; 237C
    mov byte ptr [si + 011h], al ; 237F
    push ax ; 2382
    push word ptr [si + 6] ; 2383
    call near ptr _snd_2A87 ; 2386
    add sp, 4 ; 2389
    mov si, word ptr [si + 4] ; 238C
    jmp short X_1E1A_L236B ; 238F
X_1E1A_L2391:
    mov al, byte ptr [bp + 6] ; 2391
    push ax ; 2394
    push word ptr [bp + 4] ; 2395
    call near ptr _snd_1FE4 ; 2398
    add sp, 4 ; 239B
    or ax, ax ; 239E
    je X_1E1A_L23CB ; 23A0
    mov si, ax ; 23A2
    mov al, byte ptr [bp + 8] ; 23A4
    mov byte ptr [si + 010h], al ; 23A7
    xor ah, ah ; 23AA
    inc ax ; 23AC
    mov bx, word ptr [si] ; 23AD
    mov cl, byte ptr [bx + 0Eh] ; 23AF
    xor ch, ch ; 23B2
    imul cx ; 23B4
    sar ax, 7 ; 23B6
    mov byte ptr [si + 011h], al ; 23B9
    push ax ; 23BC
    push word ptr [si + 6] ; 23BD
    call near ptr _snd_2A87 ; 23C0
    add sp, 4 ; 23C3
X_1E1A_L23C6:
    xor ax, ax ; 23C6
    pop si ; 23C8
    leave ; 23C9
    ret ; 23CA
X_1E1A_L23CB:
    mov ax, 0FFFFh ; 23CB
    pop si ; 23CE
    leave ; 23CF
    ret ; 23D0

; Empty reserved procedure
_snd_23D1 label near
    ret ; 23D1

; Set part transposition
_snd_23D2 label near
    enter 0, 0 ; 23D2
    push si ; 23D6
    cmp byte ptr [bp + 0Ah], 018h ; 23D7
    jle X_1E1A_L23E0 ; 23DB
    jmp near ptr X_1E1A_L247B ; 23DD
X_1E1A_L23E0:
    cmp byte ptr [bp + 0Ah], 0E8h ; 23E0
    jge X_1E1A_L23E9 ; 23E4
    jmp near ptr X_1E1A_L247B ; 23E6
X_1E1A_L23E9:
    cmp byte ptr [bp + 6], 010h ; 23E9
    jne X_1E1A_L2425 ; 23ED
    mov bx, word ptr [bp + 4] ; 23EF
    mov si, word ptr [bx + 4] ; 23F2
X_1E1A_L23F5:
    or si, si ; 23F5
    jne X_1E1A_L23FC ; 23F7
    jmp near ptr X_1E1A_L247B ; 23F9
X_1E1A_L23FC:
    mov al, byte ptr [bp + 0Ah] ; 23FC
    cbw ; 23FF
    mov cx, ax ; 2400
    mov al, byte ptr [si + 014h] ; 2402
    cbw ; 2405
    add cx, ax ; 2406
    push 018h ; 2408
    push -018h ; 240A
    push cx ; 240C
    call near ptr _snd_04F4 ; 240D
    add sp, 6 ; 2410
    mov byte ptr [si + 015h], al ; 2413
    push ax ; 2416
    push word ptr [si + 6] ; 2417
    call near ptr _snd_2AD9 ; 241A
    add sp, 4 ; 241D
    mov si, word ptr [si + 4] ; 2420
    jmp short X_1E1A_L23F5 ; 2423
X_1E1A_L2425:
    mov al, byte ptr [bp + 6] ; 2425
    push ax ; 2428
    push word ptr [bp + 4] ; 2429
    call near ptr _snd_1FE4 ; 242C
    add sp, 4 ; 242F
    or ax, ax ; 2432
    je X_1E1A_L247B ; 2434
    mov si, ax ; 2436
    mov al, byte ptr [bp + 0Ah] ; 2438
    cmp byte ptr [bp + 8], 0 ; 243B
    je X_1E1A_L2455 ; 243F
    cbw ; 2441
    mov cx, ax ; 2442
    mov al, byte ptr [si + 014h] ; 2444
    cbw ; 2447
    add cx, ax ; 2448
    push 7 ; 244A
    push -7 ; 244C
    push cx ; 244E
    call near ptr _snd_04F4 ; 244F
    add sp, 6 ; 2452
X_1E1A_L2455:
    mov byte ptr [si + 014h], al ; 2455
    cbw ; 2458
    mov cx, ax ; 2459
    mov bx, word ptr [si] ; 245B
    mov al, byte ptr [bx + 010h] ; 245D
    cbw ; 2460
    add cx, ax ; 2461
    push 018h ; 2463
    push -018h ; 2465
    push cx ; 2467
    call near ptr _snd_04F4 ; 2468
    add sp, 6 ; 246B
    mov byte ptr [si + 015h], al ; 246E
    push ax ; 2471
    push word ptr [si + 6] ; 2472
    call near ptr _snd_2AD9 ; 2475
    add sp, 4 ; 2478
X_1E1A_L247B:
    pop si ; 247B
    leave ; 247C
    ret ; 247D

; Set part detune
_snd_247E label near
    enter 0, 0 ; 247E
    push si ; 2482
    cmp byte ptr [bp + 6], 010h ; 2483
    jne X_1E1A_L24C3 ; 2487
    mov bx, word ptr [bp + 4] ; 2489
    mov si, word ptr [bx + 4] ; 248C
X_1E1A_L248F:
    or si, si ; 248F
    je X_1E1A_L2506 ; 2491
    mov al, byte ptr [bp + 8] ; 2493
    cbw ; 2496
    mov cx, ax ; 2497
    mov al, byte ptr [si + 016h] ; 2499
    cbw ; 249C
    add cx, ax ; 249D
    push 07Fh ; 249F
    push -080h ; 24A1
    push cx ; 24A3
    call near ptr _snd_04D9 ; 24A4
    add sp, 6 ; 24A7
    mov byte ptr [si + 017h], al ; 24AA
    cbw ; 24AD
    add ax, word ptr [si + 01Ch] ; 24AE
    mov word ptr [si + 01Eh], ax ; 24B1
    push ax ; 24B4
    push word ptr [si + 6] ; 24B5
    call near ptr _snd_2B3F ; 24B8
    add sp, 4 ; 24BB
    mov si, word ptr [si + 4] ; 24BE
    jmp short X_1E1A_L248F ; 24C1
X_1E1A_L24C3:
    mov al, byte ptr [bp + 6] ; 24C3
    push ax ; 24C6
    push word ptr [bp + 4] ; 24C7
    call near ptr _snd_1FE4 ; 24CA
    add sp, 4 ; 24CD
    or ax, ax ; 24D0
    je X_1E1A_L2506 ; 24D2
    mov si, ax ; 24D4
    mov bx, word ptr [si] ; 24D6
    mov al, byte ptr [bx + 011h] ; 24D8
    cbw ; 24DB
    mov cx, ax ; 24DC
    mov al, byte ptr [bp + 8] ; 24DE
    mov byte ptr [si + 016h], al ; 24E1
    cbw ; 24E4
    add cx, ax ; 24E5
    push 07Fh ; 24E7
    push -080h ; 24E9
    push cx ; 24EB
    call near ptr _snd_04D9 ; 24EC
    add sp, 6 ; 24EF
    mov byte ptr [si + 017h], al ; 24F2
    cbw ; 24F5
    add ax, word ptr [si + 01Ch] ; 24F6
    mov word ptr [si + 01Eh], ax ; 24F9
    push ax ; 24FC
    push word ptr [si + 6] ; 24FD
    call near ptr _snd_2B3F ; 2500
    add sp, 4 ; 2503
X_1E1A_L2506:
    pop si ; 2506
    leave ; 2507
    ret ; 2508

; Set part enable state
_snd_2509 label near
    enter 0, 0 ; 2509
    push si ; 250D
    mov al, byte ptr [bp + 6] ; 250E
    push ax ; 2511
    push word ptr [bp + 4] ; 2512
    call near ptr _snd_1FE4 ; 2515
    add sp, 4 ; 2518
    or ax, ax ; 251B
    je X_1E1A_L2536 ; 251D
    mov si, ax ; 251F
    mov al, byte ptr [bp + 8] ; 2521
    mov byte ptr [si + 0Dh], al ; 2524
    or al, al ; 2527
    jne X_1E1A_L2531 ; 2529
    push si ; 252B
    call near ptr _snd_2772 ; 252C
    inc sp ; 252F
    inc sp ; 2530
X_1E1A_L2531:
    xor ax, ax ; 2531
    pop si ; 2533
    leave ; 2534
    ret ; 2535
X_1E1A_L2536:
    mov ax, 0FFFFh ; 2536
    pop si ; 2539
    leave ; 253A
    ret ; 253B

; Set part modulation
_snd_253C label near
    enter 0, 0 ; 253C
    push si ; 2540
    mov al, byte ptr [bp + 6] ; 2541
    push ax ; 2544
    push word ptr [bp + 4] ; 2545
    call near ptr _snd_1FE4 ; 2548
    add sp, 4 ; 254B
    or ax, ax ; 254E
    je X_1E1A_L2564 ; 2550
    mov si, ax ; 2552
    mov al, byte ptr [bp + 8] ; 2554
    mov byte ptr [si + 018h], al ; 2557
    push ax ; 255A
    push word ptr [si + 6] ; 255B
    call near ptr _snd_2B03 ; 255E
    add sp, 4 ; 2561
X_1E1A_L2564:
    pop si ; 2564
    leave ; 2565
    ret ; 2566

; Set sustain-pedal state
_snd_2567 label near
    enter 0, 0 ; 2567
    push si ; 256B
    mov al, byte ptr [bp + 6] ; 256C
    push ax ; 256F
    push word ptr [bp + 4] ; 2570
    call near ptr _snd_1FE4 ; 2573
    add sp, 4 ; 2576
    or ax, ax ; 2579
    je X_1E1A_L2591 ; 257B
    mov si, ax ; 257D
    mov al, byte ptr [bp + 8] ; 257F
    mov byte ptr [si + 019h], al ; 2582
    or al, al ; 2585
    jne X_1E1A_L2591 ; 2587
    push word ptr [si + 6] ; 2589
    call near ptr _snd_28DB ; 258C
    inc sp ; 258F
    inc sp ; 2590
X_1E1A_L2591:
    pop si ; 2591
    leave ; 2592
    ret ; 2593

; Set pitch bend
_snd_2594 label near
    enter 0, 0 ; 2594
    push si ; 2598
    mov al, byte ptr [bp + 6] ; 2599
    push ax ; 259C
    push word ptr [bp + 4] ; 259D
    call near ptr _snd_1FE4 ; 25A0
    add sp, 4 ; 25A3
    or ax, ax ; 25A6
    je X_1E1A_L25E4 ; 25A8
    mov si, ax ; 25AA
    mov al, byte ptr [si + 01Ah] ; 25AC
    xor ah, ah ; 25AF
    imul word ptr [bp + 8] ; 25B1
    sar dx, 1 ; 25B4
    rcr ax, 1 ; 25B6
    sar dx, 1 ; 25B8
    rcr ax, 1 ; 25BA
    sar dx, 1 ; 25BC
    rcr ax, 1 ; 25BE
    sar dx, 1 ; 25C0
    rcr ax, 1 ; 25C2
    sar dx, 1 ; 25C4
    rcr ax, 1 ; 25C6
    sar dx, 1 ; 25C8
    rcr ax, 1 ; 25CA
    mov word ptr [si + 01Ch], ax ; 25CC
    mov cx, ax ; 25CF
    mov al, byte ptr [si + 017h] ; 25D1
    cbw ; 25D4
    add cx, ax ; 25D5
    mov word ptr [si + 01Eh], cx ; 25D7
    push cx ; 25DA
    push word ptr [si + 6] ; 25DB
    call near ptr _snd_2B3F ; 25DE
    add sp, 4 ; 25E1
X_1E1A_L25E4:
    pop si ; 25E4
    leave ; 25E5
    ret ; 25E6

; Set pitch-bend range; preserves original pointer/channel anomaly
_snd_25E7 label near
    enter 0, 0 ; 25E7
    push si ; 25EB
    cmp byte ptr [bp + 8], 0Ch ; 25EC
    ja X_1E1A_L2617 ; 25F0
    mov al, byte ptr [bp + 6] ; 25F2
    push ax ; 25F5
    push word ptr [bp + 4] ; 25F6
    call near ptr _snd_1FE4 ; 25F9
    add sp, 4 ; 25FC
    or ax, ax ; 25FF
    je X_1E1A_L2617 ; 2601
    mov si, ax ; 2603
    push 0 ; 2605
    push ax ; 2607
    push word ptr [bp + 4] ; 2608
    call near ptr _snd_2594 ; 260B
    add sp, 6 ; 260E
    mov al, byte ptr [bp + 8] ; 2611
    mov byte ptr [si + 01Ah], al ; 2614
X_1E1A_L2617:
    pop si ; 2617
    leave ; 2618
    ret ; 2619

; Read a part parameter
_snd_261A label near
    enter 0, 0 ; 261A
    mov bx, word ptr [bp + 4] ; 261E
    mov bx, word ptr [bx + 4] ; 2621
    mov al, byte ptr [bp + 8] ; 2624
X_1E1A_L2627:
    or bx, bx ; 2627
    je X_1E1A_L2661 ; 2629
    cmp byte ptr [bx + 0Bh], al ; 262B
    je X_1E1A_L2635 ; 262E
    mov bx, word ptr [bx + 4] ; 2630
    jmp short X_1E1A_L2627 ; 2633
X_1E1A_L2635:
    mov al, byte ptr [bp + 6] ; 2635
    xor ah, ah ; 2638
    sub ax, 0Eh ; 263A
    je X_1E1A_L264D ; 263D
    dec ax ; 263F
    je X_1E1A_L2652 ; 2640
    dec ax ; 2642
    je X_1E1A_L2657 ; 2643
    dec ax ; 2645
    je X_1E1A_L265C ; 2646
    mov ax, 0FFFFh ; 2648
    leave ; 264B
    ret ; 264C
X_1E1A_L264D:
    mov al, byte ptr [bx + 0Dh] ; 264D
    leave ; 2650
    ret ; 2651
X_1E1A_L2652:
    mov al, byte ptr [bx + 010h] ; 2652
    leave ; 2655
    ret ; 2656
X_1E1A_L2657:
    mov al, byte ptr [bx + 0Ah] ; 2657
    leave ; 265A
    ret ; 265B
X_1E1A_L265C:
    mov al, byte ptr [bx + 014h] ; 265C
    leave ; 265F
    ret ; 2660
X_1E1A_L2661:
    mov al, 081h ; 2661
    leave ; 2663
    ret ; 2664

; Copy custom instrument to a part
_snd_2665 label near
    enter 0, 0 ; 2665
    push 01Eh ; 2669
    push word ptr [bp + 6] ; 266B
    mov bx, word ptr [bp + 4] ; 266E
    push word ptr [bx + 8] ; 2671
    call near ptr _snd_053D ; 2674
    leave ; 2677
    ret ; 2678

; Copy a global instrument
_snd_2679 label near
    enter 0, 0 ; 2679
    push si ; 267D
    mov al, byte ptr [bp + 4] ; 267E
    cmp al, 020h ; 2681
    jae X_1E1A_L2698 ; 2683
    mov cx, 01Eh ; 2685
    mul cl ; 2688
    add ax, offset _snd_global_instruments ; 268A
    push cx ; 268D
    push word ptr [bp + 6] ; 268E
    push ax ; 2691
    call near ptr _snd_053D ; 2692
    add sp, 6 ; 2695
X_1E1A_L2698:
    pop si ; 2698
    leave ; 2699
    ret ; 269A

; Select a global or default instrument
_snd_269B label near
    enter 0, 0 ; 269B
    mov al, byte ptr [bp + 6] ; 269F
    mov cx, 01Eh ; 26A2
    cmp al, 020h ; 26A5
    jae X_1E1A_L26B0 ; 26A7
    mul cl ; 26A9
    add ax, offset _snd_global_instruments ; 26AB
    jmp short X_1E1A_L26B3 ; 26AE
X_1E1A_L26B0:
    mov ax, offset _snd_default_instrument ; 26B0
X_1E1A_L26B3:
    mov bx, word ptr [bp + 4] ; 26B3
    push cx ; 26B6
    push ax ; 26B7
    push word ptr [bx + 8] ; 26B8
    call near ptr _snd_053D ; 26BB
    add sp, 6 ; 26BE
    leave ; 26C1
    ret ; 26C2

; Modify instrument field; preserves original DI-clobber anomaly
_snd_26C3 label near
    enter 0, 0 ; 26C3
    push di ; 26C7
    push si ; 26C8
    mov di, word ptr [bp + 4] ; 26C9
    mov si, word ptr [bp + 6] ; 26CC
    shl si, 2 ; 26CF
    add si, offset _snd_instrument_fields ; 26D2
    lea bx, [si + 1] ; 26D6
    mov al, byte ptr [bx + 1] ; 26D9
    not al ; 26DC
    mov cx, bx ; 26DE
    mov bl, byte ptr [si] ; 26E0
    xor bh, bh ; 26E2
    mov si, word ptr [di + 8] ; 26E4
    and al, byte ptr [bx + si] ; 26E7
    mov di, cx ; 26E9
    mov cl, byte ptr [di] ; 26EB
    mov dl, byte ptr [bp + 8] ; 26ED
    shl dl, cl ; 26F0
    or al, dl ; 26F2
    mov byte ptr [bx + si], al ; 26F4
    push word ptr [bp + 8] ; 26F6
    push word ptr [bp + 6] ; 26F9
    push word ptr [di + 6] ; 26FC
    call near ptr _snd_2A5E ; 26FF
    add sp, 6 ; 2702
    pop si ; 2705
    pop di ; 2706
    leave ; 2707
    ret ; 2708

; Allocate and link a voice, then start the note
_snd_2709 label near
    enter 0, 0 ; 2709
    push di ; 270D
    push si ; 270E
    mov di, word ptr [bp + 4] ; 270F
    mov al, byte ptr [di + 0Fh] ; 2712
    xor ah, ah ; 2715
    push ax ; 2717
    call near ptr _snd_2B6C ; 2718
    inc sp ; 271B
    inc sp ; 271C
    or ax, ax ; 271D
    je X_1E1A_L274C ; 271F
    mov si, ax ; 2721
    mov word ptr [si], di ; 2723
    mov bx, word ptr [di + 6] ; 2725
    mov word ptr [si + 4], bx ; 2728
    mov word ptr [si + 2], 0 ; 272B
    mov word ptr [di + 6], si ; 2730
    or bx, bx ; 2733
    je X_1E1A_L273A ; 2735
    mov word ptr [bx + 2], si ; 2737
X_1E1A_L273A:
    mov al, byte ptr [bp + 8] ; 273A
    xor ah, ah ; 273D
    push ax ; 273F
    mov al, byte ptr [bp + 6] ; 2740
    push ax ; 2743
    push si ; 2744
    push di ; 2745
    call near ptr _snd_278D ; 2746
    add sp, 8 ; 2749
X_1E1A_L274C:
    pop si ; 274C
    pop di ; 274D
    leave ; 274E
    ret ; 274F

; Stop a matching note in a voice list
_snd_2750 label near
    enter 0, 0 ; 2750
    push si ; 2754
    mov si, word ptr [bp + 4] ; 2755
X_1E1A_L2758:
    or si, si ; 2758
    je X_1E1A_L276F ; 275A
    mov al, byte ptr [bp + 6] ; 275C
    cmp byte ptr [si + 8], al ; 275F
    jne X_1E1A_L276A ; 2762
    push si ; 2764
    call near ptr _snd_2BC4 ; 2765
    inc sp ; 2768
    inc sp ; 2769
X_1E1A_L276A:
    mov si, word ptr [si + 4] ; 276A
    jmp short X_1E1A_L2758 ; 276D
X_1E1A_L276F:
    pop si ; 276F
    leave ; 2770
    ret ; 2771

; Stop every voice belonging to a part
_snd_2772 label near
    enter 0, 0 ; 2772
    push si ; 2776
    mov si, word ptr [bp + 4] ; 2777
X_1E1A_L277A:
    cmp word ptr [si + 6], 0 ; 277A
    je X_1E1A_L278A ; 277E
    push word ptr [si + 6] ; 2780
    call near ptr _snd_2BC4 ; 2783
    inc sp ; 2786
    inc sp ; 2787
    jmp short X_1E1A_L277A ; 2788
X_1E1A_L278A:
    pop si ; 278A
    leave ; 278B
    ret ; 278C

; Program a new voice and initialize its two envelopes
_snd_278D label near
    enter 4, 0 ; 278D
    push di ; 2791
    push si ; 2792
    mov di, word ptr [bp + 4] ; 2793
    mov si, word ptr [bp + 6] ; 2796
    mov bx, word ptr [di + 8] ; 2799
    mov word ptr [bp - 2], bx ; 279C
    mov al, byte ptr [bx + 0Ah] ; 279F
    and al, 1 ; 27A2
    mov byte ptr [si + 6], al ; 27A4
    mov al, byte ptr [bp + 8] ; 27A7
    mov byte ptr [si + 8], al ; 27AA
    mov byte ptr [si + 0Bh], 0 ; 27AD
    mov al, byte ptr [bx + 01Dh] ; 27B1
    xor ah, ah ; 27B4
    mov word ptr [si + 0Ch], ax ; 27B6
    or ax, ax ; 27B9
    je X_1E1A_L27C6 ; 27BB
    mov ax, 03Fh ; 27BD
    imul word ptr [si + 0Ch] ; 27C0
    mov word ptr [si + 0Ch], ax ; 27C3
X_1E1A_L27C6:
    mov bx, word ptr [bp - 2] ; 27C6
    mov bl, byte ptr [bx + 4] ; 27C9
    shr bl, 2 ; 27CC
    xor bh, bh ; 27CF
    mov al, byte ptr [bp + 0Ah] ; 27D1
    and ax, 0FEh ; 27D4
    shl ax, 4 ; 27D7
    mov word ptr [bp - 4], ax ; 27DA
    add bx, ax ; 27DD
    mov al, byte ptr [bx + _snd_volume_products] ; 27DF
    mov bx, word ptr [bp - 2] ; 27E3
    mov cl, byte ptr [bx + 1] ; 27E6
    and cl, 03Fh ; 27E9
    add al, cl ; 27EC
    cmp al, 03Fh ; 27EE
    jbe X_1E1A_L27F4 ; 27F0
    mov al, 03Fh ; 27F2
X_1E1A_L27F4:
    mov byte ptr [si + 0Ah], al ; 27F4
    mov bl, byte ptr [bx + 9] ; 27F7
    shr bl, 2 ; 27FA
    xor bh, bh ; 27FD
    add bx, word ptr [bp - 4] ; 27FF
    mov al, byte ptr [bx + _snd_volume_products] ; 2802
    mov bx, word ptr [bp - 2] ; 2806
    mov cl, byte ptr [bx + 6] ; 2809
    and cl, 03Fh ; 280C
    add al, cl ; 280F
    cmp al, 03Fh ; 2811
    jbe X_1E1A_L2817 ; 2813
    mov al, 03Fh ; 2815
X_1E1A_L2817:
    mov byte ptr [si + 9], al ; 2817
    xor ah, ah ; 281A
    shl ax, 5 ; 281C
    mov bx, ax ; 281F
    mov al, byte ptr [di + 011h] ; 2821
    shr al, 2 ; 2824
    xor ah, ah ; 2827
    add bx, ax ; 2829
    mov cl, byte ptr [bx + _snd_volume_products] ; 282B
    mov bl, byte ptr [si + 0Ah] ; 282F
    cmp byte ptr [si + 6], 1 ; 2832
    jne X_1E1A_L2843 ; 2836
    xor bh, bh ; 2838
    shl bx, 5 ; 283A
    add bx, ax ; 283D
    mov bl, byte ptr [bx + _snd_volume_products] ; 283F
X_1E1A_L2843:
    push cx ; 2843
    push bx ; 2844
    push word ptr [bp - 2] ; 2845
    push si ; 2848
    call near ptr _snd_2E9B ; 2849
    add sp, 8 ; 284C
    push word ptr [di + 01Eh] ; 284F
    mov al, byte ptr [di + 015h] ; 2852
    add al, byte ptr [bp + 8] ; 2855
    push ax ; 2858
    mov al, byte ptr [si + 7] ; 2859
    push ax ; 285C
    call near ptr _snd_2F48 ; 285D
    add sp, 6 ; 2860
    mov bx, word ptr [bp - 2] ; 2863
    test byte ptr [bx + 0Bh], 080h ; 2866
    je X_1E1A_L2889 ; 286A
    mov ax, bx ; 286C
    add ax, 0Ch ; 286E
    push ax ; 2871
    mov al, byte ptr [bx + 0Bh] ; 2872
    xor ah, ah ; 2875
    push ax ; 2877
    lea ax, [si + 030h] ; 2878
    push ax ; 287B
    lea ax, [si + 0Eh] ; 287C
    push ax ; 287F
    push si ; 2880
    call near ptr _snd_29A1 ; 2881
    add sp, 0Ah ; 2884
    jmp short X_1E1A_L288D ; 2887
X_1E1A_L2889:
    mov byte ptr [si + 0Eh], 0 ; 2889
X_1E1A_L288D:
    mov bx, word ptr [bp - 2] ; 288D
    test byte ptr [bx + 014h], 080h ; 2890
    je X_1E1A_L28B5 ; 2894
    mov ax, bx ; 2896
    add ax, 015h ; 2898
    push ax ; 289B
    mov al, byte ptr [bx + 014h] ; 289C
    xor ah, ah ; 289F
    push ax ; 28A1
    lea ax, [si + 05Ah] ; 28A2
    push ax ; 28A5
    lea ax, [si + 038h] ; 28A6
    push ax ; 28A9
    push si ; 28AA
    call near ptr _snd_29A1 ; 28AB
    add sp, 0Ah ; 28AE
    pop si ; 28B1
    pop di ; 28B2
    leave ; 28B3
    ret ; 28B4
X_1E1A_L28B5:
    mov byte ptr [si + 038h], 0 ; 28B5
    pop si ; 28B9
    pop di ; 28BA
    leave ; 28BB
    ret ; 28BC

; Mark a note as sustained
_snd_28BD label near
    enter 0, 0 ; 28BD
    mov bx, word ptr [bp + 4] ; 28C1
X_1E1A_L28C4:
    or bx, bx ; 28C4
    je X_1E1A_L28D9 ; 28C6
    mov al, byte ptr [bp + 6] ; 28C8
    cmp byte ptr [bx + 8], al ; 28CB
    jne X_1E1A_L28D4 ; 28CE
    mov byte ptr [bx + 0Bh], 1 ; 28D0
X_1E1A_L28D4:
    mov bx, word ptr [bx + 4] ; 28D4
    jmp short X_1E1A_L28C4 ; 28D7
X_1E1A_L28D9:
    leave ; 28D9
    ret ; 28DA

; Release sustained voices
_snd_28DB label near
    enter 0, 0 ; 28DB
    push si ; 28DF
    mov si, word ptr [bp + 4] ; 28E0
X_1E1A_L28E3:
    or si, si ; 28E3
    je X_1E1A_L28F8 ; 28E5
    cmp byte ptr [si + 0Bh], 0 ; 28E7
    je X_1E1A_L28F3 ; 28EB
    push si ; 28ED
    call near ptr _snd_2BC4 ; 28EE
    inc sp ; 28F1
    inc sp ; 28F2
X_1E1A_L28F3:
    mov si, word ptr [si + 4] ; 28F3
    jmp short X_1E1A_L28E3 ; 28F6
X_1E1A_L28F8:
    pop si ; 28F8
    leave ; 28F9
    ret ; 28FA

; Advance one envelope and apply its parameter change
_snd_28FB label near
    enter 2, 0 ; 28FB
    push di ; 28FF
    push si ; 2900
    mov di, word ptr [bp + 4] ; 2901
    mov si, word ptr [bp + 8] ; 2904
    push si ; 2907
    push word ptr [bp + 6] ; 2908
    call near ptr _snd_2D33 ; 290B
    add sp, 4 ; 290E
    mov byte ptr [bp - 2], al ; 2911
    test al, 1 ; 2914
    je X_1E1A_L298B ; 2916
    mov cl, byte ptr [si + 2] ; 2918
    xor ch, ch ; 291B
    cmp cl, 0 ; 291D
    je X_1E1A_L293B ; 2920
    cmp cl, 0Dh ; 2922
    je X_1E1A_L2948 ; 2925
    cmp cl, 01Eh ; 2927
    je X_1E1A_L2979 ; 292A
    cmp cl, 01Fh ; 292C
    je X_1E1A_L2983 ; 292F
    mov bx, word ptr [bp + 6] ; 2931
    mov ax, word ptr [bx + 8] ; 2934
    add ax, word ptr [si] ; 2937
    jmp short X_1E1A_L296E ; 2939
X_1E1A_L293B:
    mov bx, word ptr [bp + 6] ; 293B
    mov al, byte ptr [bx + 8] ; 293E
    add al, byte ptr [si] ; 2941
    mov byte ptr [di + 9], al ; 2943
    jmp short X_1E1A_L2959 ; 2946
X_1E1A_L2948:
    mov bx, word ptr [bp + 6] ; 2948
    mov al, byte ptr [bx + 8] ; 294B
    add al, byte ptr [si] ; 294E
    mov byte ptr [di + 0Ah], al ; 2950
    cmp byte ptr [di + 6], 1 ; 2953
    jne X_1E1A_L296E ; 2957
X_1E1A_L2959:
    xor ah, ah ; 2959
    shl ax, 5 ; 295B
    mov bx, word ptr [di] ; 295E
    mov bl, byte ptr [bx + 011h] ; 2960
    shr bl, 2 ; 2963
    xor bh, bh ; 2966
    add bx, ax ; 2968
    mov al, byte ptr [bx + _snd_volume_products] ; 296A
X_1E1A_L296E:
    push ax ; 296E
    push cx ; 296F
    push di ; 2970
    call near ptr _snd_2FB1 ; 2971
    add sp, 6 ; 2974
    jmp short X_1E1A_L298B ; 2977
X_1E1A_L2979:
    mov al, byte ptr [si] ; 2979
    mov bx, word ptr [si + 6] ; 297B
    mov byte ptr [bx + 014h], al ; 297E
    jmp short X_1E1A_L298B ; 2981
X_1E1A_L2983:
    mov al, byte ptr [si] ; 2983
    mov bx, word ptr [si + 6] ; 2985
    mov byte ptr [bx + 013h], al ; 2988
X_1E1A_L298B:
    test byte ptr [bp - 2], 2 ; 298B
    je X_1E1A_L299D ; 298F
    cmp byte ptr [si + 4], 0 ; 2991
    je X_1E1A_L299D ; 2995
    mov ah, byte ptr [di + 7] ; 2997
    call near ptr _snd_2FA0 ; 299A
X_1E1A_L299D:
    pop si ; 299D
    pop di ; 299E
    leave ; 299F
    ret ; 29A0

; Initialize an envelope and its companion work record
_snd_29A1 label near
    enter 0, 0 ; 29A1
    push di ; 29A5
    push si ; 29A6
    mov dx, word ptr [bp + 8] ; 29A7
    mov si, word ptr [bp + 6] ; 29AA
    mov bx, dx ; 29AD
    mov word ptr [bx], 0 ; 29AF
    mov al, byte ptr [bp + 0Ah] ; 29B3
    and al, 040h ; 29B6
    mov byte ptr [bx + 3], al ; 29B8
    mov cl, byte ptr [bp + 0Ah] ; 29BB
    and cl, 020h ; 29BE
    mov byte ptr [si + 0Ah], cl ; 29C1
    mov cl, byte ptr [bp + 0Ah] ; 29C4
    and cl, 010h ; 29C7
    mov byte ptr [bx + 4], cl ; 29CA
    mov bl, byte ptr [bp + 0Ah] ; 29CD
    and bx, 0Fh ; 29D0
    mov cl, byte ptr [bx + _snd_parameter_map] ; 29D3
    mov di, dx ; 29D7
    mov byte ptr [di + 2], cl ; 29D9
    shl bx, 1 ; 29DC
    mov cx, word ptr [bx + _snd_max_values] ; 29DE
    mov word ptr [si + 6], cx ; 29E2
    mov di, word ptr [bp + 4] ; 29E5
    or al, al ; 29E8
    mov al, 01Fh ; 29EA
    mov byte ptr [si + 013h], al ; 29EC
    je X_1E1A_L29F9 ; 29EF
    mov bx, word ptr [di] ; 29F1
    mov al, byte ptr [bx + 018h] ; 29F3
    shr al, 2 ; 29F6
X_1E1A_L29F9:
    mov byte ptr [si + 014h], al ; 29F9
    mov bx, dx ; 29FC
    mov al, byte ptr [bx + 2] ; 29FE
    xor ah, ah ; 2A01
    or al, al ; 2A03
    je X_1E1A_L2A26 ; 2A05
    cmp al, 0Dh ; 2A07
    je X_1E1A_L2A2E ; 2A09
    cmp al, 01Eh ; 2A0B
    je X_1E1A_L2A36 ; 2A0D
    cmp al, 01Fh ; 2A0F
    je X_1E1A_L2A44 ; 2A11
    mov al, byte ptr [bx + 2] ; 2A13
    push ax ; 2A16
    mov al, byte ptr [di + 7] ; 2A17
    push ax ; 2A1A
    call near ptr _snd_304C ; 2A1B
    add sp, 4 ; 2A1E
    mov word ptr [si + 8], ax ; 2A21
    jmp short X_1E1A_L2A50 ; 2A24
X_1E1A_L2A26:
    mov al, byte ptr [di + 9] ; 2A26
    mov word ptr [si + 8], ax ; 2A29
    jmp short X_1E1A_L2A50 ; 2A2C
X_1E1A_L2A2E:
    mov al, byte ptr [di + 0Ah] ; 2A2E
    mov word ptr [si + 8], ax ; 2A31
    jmp short X_1E1A_L2A50 ; 2A34
X_1E1A_L2A36:
    mov word ptr [si + 8], 01Fh ; 2A36
    mov bx, word ptr [bx + 6] ; 2A3B
    mov byte ptr [bx + 014h], 0 ; 2A3E
    jmp short X_1E1A_L2A50 ; 2A42
X_1E1A_L2A44:
    mov word ptr [si + 8], 0 ; 2A44
    mov bx, word ptr [bx + 6] ; 2A49
    mov byte ptr [bx + 013h], 0 ; 2A4C
X_1E1A_L2A50:
    push word ptr [bp + 0Ch] ; 2A50
    push si ; 2A53
    call near ptr _snd_2BF6 ; 2A54
    add sp, 4 ; 2A57
    pop si ; 2A5A
    pop di ; 2A5B
    leave ; 2A5C
    ret ; 2A5D

; Set a parameter across a voice list
_snd_2A5E label near
    enter 0, 0 ; 2A5E
    push di ; 2A62
    push si ; 2A63
    mov si, word ptr [bp + 6] ; 2A64
    cmp si, 01Ch ; 2A67
    jge X_1E1A_L2A83 ; 2A6A
    mov di, word ptr [bp + 4] ; 2A6C
X_1E1A_L2A6F:
    or di, di ; 2A6F
    je X_1E1A_L2A83 ; 2A71
    push word ptr [bp + 8] ; 2A73
    push si ; 2A76
    push di ; 2A77
    call near ptr _snd_2FB1 ; 2A78
    add sp, 6 ; 2A7B
    mov di, word ptr [di + 4] ; 2A7E
    jmp short X_1E1A_L2A6F ; 2A81
X_1E1A_L2A83:
    pop si ; 2A83
    pop di ; 2A84
    leave ; 2A85
    ret ; 2A86

; Recompute voice output levels
_snd_2A87 label near
    enter 0, 0 ; 2A87
    push di ; 2A8B
    push si ; 2A8C
    mov al, byte ptr [bp + 6] ; 2A8D
    shr al, 2 ; 2A90
    xor ah, ah ; 2A93
    mov di, ax ; 2A95
    mov si, word ptr [bp + 4] ; 2A97
X_1E1A_L2A9A:
    or si, si ; 2A9A
    je X_1E1A_L2AD5 ; 2A9C
    mov bl, byte ptr [si + 9] ; 2A9E
    xor bh, bh ; 2AA1
    shl bx, 5 ; 2AA3
    mov al, byte ptr [bx + di + _snd_volume_products] ; 2AA6
    push ax ; 2AAA
    push 0 ; 2AAB
    push si ; 2AAD
    call near ptr _snd_2FB1 ; 2AAE
    add sp, 6 ; 2AB1
    cmp byte ptr [si + 6], 1 ; 2AB4
    jne X_1E1A_L2AD0 ; 2AB8
    mov bl, byte ptr [si + 0Ah] ; 2ABA
    xor bh, bh ; 2ABD
    shl bx, 5 ; 2ABF
    mov al, byte ptr [bx + di + _snd_volume_products] ; 2AC2
    push ax ; 2AC6
    push 0Dh ; 2AC7
    push si ; 2AC9
    call near ptr _snd_2FB1 ; 2ACA
    add sp, 6 ; 2ACD
X_1E1A_L2AD0:
    mov si, word ptr [si + 4] ; 2AD0
    jmp short X_1E1A_L2A9A ; 2AD3
X_1E1A_L2AD5:
    pop si ; 2AD5
    pop di ; 2AD6
    leave ; 2AD7
    ret ; 2AD8

; Transpose a list of voices
_snd_2AD9 label near
    enter 0, 0 ; 2AD9
    push si ; 2ADD
    mov si, word ptr [bp + 4] ; 2ADE
X_1E1A_L2AE1:
    or si, si ; 2AE1
    je X_1E1A_L2B00 ; 2AE3
    mov bx, word ptr [si] ; 2AE5
    push word ptr [bx + 01Eh] ; 2AE7
    mov al, byte ptr [si + 8] ; 2AEA
    add al, byte ptr [bp + 6] ; 2AED
    push ax ; 2AF0
    mov al, byte ptr [si + 7] ; 2AF1
    push ax ; 2AF4
    call near ptr _snd_2F6F ; 2AF5
    add sp, 6 ; 2AF8
    mov si, word ptr [si + 4] ; 2AFB
    jmp short X_1E1A_L2AE1 ; 2AFE
X_1E1A_L2B00:
    pop si ; 2B00
    leave ; 2B01
    ret ; 2B02

; Update modulation envelope scaling
_snd_2B03 label near
    enter 0, 0 ; 2B03
    mov bx, word ptr [bp + 4] ; 2B07
X_1E1A_L2B0A:
    or bx, bx ; 2B0A
    je X_1E1A_L2B3D ; 2B0C
    cmp byte ptr [bx + 0Eh], 0 ; 2B0E
    je X_1E1A_L2B23 ; 2B12
    cmp byte ptr [bx + 033h], 0 ; 2B14
    je X_1E1A_L2B23 ; 2B18
    mov al, byte ptr [bp + 6] ; 2B1A
    shr al, 2 ; 2B1D
    mov byte ptr [bx + 022h], al ; 2B20
X_1E1A_L2B23:
    cmp byte ptr [bx + 038h], 0 ; 2B23
    je X_1E1A_L2B38 ; 2B27
    cmp byte ptr [bx + 05Dh], 0 ; 2B29
    je X_1E1A_L2B38 ; 2B2D
    mov al, byte ptr [bp + 6] ; 2B2F
    shr al, 2 ; 2B32
    mov byte ptr [bx + 04Ch], al ; 2B35
X_1E1A_L2B38:
    mov bx, word ptr [bx + 4] ; 2B38
    jmp short X_1E1A_L2B0A ; 2B3B
X_1E1A_L2B3D:
    leave ; 2B3D
    ret ; 2B3E

; Retune a list of voices
_snd_2B3F label near
    enter 0, 0 ; 2B3F
    push di ; 2B43
    push si ; 2B44
    mov di, word ptr [bp + 6] ; 2B45
    mov si, word ptr [bp + 4] ; 2B48
X_1E1A_L2B4B:
    or si, si ; 2B4B
    je X_1E1A_L2B68 ; 2B4D
    push di ; 2B4F
    mov bx, word ptr [si] ; 2B50
    mov al, byte ptr [bx + 015h] ; 2B52
    add al, byte ptr [si + 8] ; 2B55
    push ax ; 2B58
    mov al, byte ptr [si + 7] ; 2B59
    push ax ; 2B5C
    call near ptr _snd_2F6F ; 2B5D
    add sp, 6 ; 2B60
    mov si, word ptr [si + 4] ; 2B63
    jmp short X_1E1A_L2B4B ; 2B66
X_1E1A_L2B68:
    pop si ; 2B68
    pop di ; 2B69
    leave ; 2B6A
    ret ; 2B6B

; Allocate a free voice or steal a lower-priority voice
_snd_2B6C label near
    enter 0, 0 ; 2B6C
    push di ; 2B70
    push si ; 2B71
    mov dl, byte ptr [bp + 4] ; 2B72
    xor di, di ; 2B75
    mov cx, 9 ; 2B77
X_1E1A_L2B7A:
    inc byte ptr [_snd_voice_counter] ; 2B7A
    cmp byte ptr [_snd_voice_counter], 9 ; 2B7E
    jb X_1E1A_L2B8A ; 2B83
    mov byte ptr [_snd_voice_counter], 0 ; 2B85
X_1E1A_L2B8A:
    mov al, 062h ; 2B8A
    mul byte ptr [_snd_voice_counter] ; 2B8C
    add ax, offset _snd_voices ; 2B90
    mov si, ax ; 2B93
    cmp word ptr [si], 0 ; 2B95
    je X_1E1A_L2BBE ; 2B98
    cmp word ptr [si + 4], 0 ; 2B9A
    jne X_1E1A_L2BAC ; 2B9E
    mov bx, word ptr [si] ; 2BA0
    cmp dl, byte ptr [bx + 0Fh] ; 2BA2
    jb X_1E1A_L2BAC ; 2BA5
    mov dl, byte ptr [bx + 0Fh] ; 2BA7
    mov di, si ; 2BAA
X_1E1A_L2BAC:
    loop X_1E1A_L2B7A ; 2BAC
    or di, di ; 2BAE
    je X_1E1A_L2BB8 ; 2BB0
    push di ; 2BB2
    call near ptr _snd_2BC4 ; 2BB3
    inc sp ; 2BB6
    inc sp ; 2BB7
X_1E1A_L2BB8:
    mov ax, di ; 2BB8
    pop si ; 2BBA
    pop di ; 2BBB
    leave ; 2BBC
    ret ; 2BBD
X_1E1A_L2BBE:
    mov ax, si ; 2BBE
    pop si ; 2BC0
    pop di ; 2BC1
    leave ; 2BC2
    ret ; 2BC3

; Stop and unlink one voice
_snd_2BC4 label near
    enter 0, 0 ; 2BC4
    push di ; 2BC8
    push si ; 2BC9
    mov di, word ptr [bp + 4] ; 2BCA
    mov ah, byte ptr [di + 7] ; 2BCD
    call near ptr _snd_2F94 ; 2BD0
    mov bx, word ptr [di + 2] ; 2BD3
    mov si, word ptr [di + 4] ; 2BD6
    or si, si ; 2BD9
    je X_1E1A_L2BE0 ; 2BDB
    mov word ptr [si + 2], bx ; 2BDD
X_1E1A_L2BE0:
    or bx, bx ; 2BE0
    je X_1E1A_L2BE9 ; 2BE2
    mov word ptr [bx + 4], si ; 2BE4
    jmp short X_1E1A_L2BEE ; 2BE7
X_1E1A_L2BE9:
    mov bx, word ptr [di] ; 2BE9
    mov word ptr [bx + 6], si ; 2BEB
X_1E1A_L2BEE:
    mov word ptr [di], 0 ; 2BEE
    pop si ; 2BF2
    pop di ; 2BF3
    leave ; 2BF4
    ret ; 2BF5

; Load envelope state from instrument bytes
_snd_2BF6 label near
    enter 0, 0 ; 2BF6
    push si ; 2BFA
    mov bx, word ptr [bp + 6] ; 2BFB
    mov si, word ptr [bp + 4] ; 2BFE
    mov byte ptr [si], 1 ; 2C01
    mov word ptr [si + 2], 0 ; 2C04
    mov byte ptr [si + 015h], 01Fh ; 2C09
    mov al, byte ptr [bx] ; 2C0D
    xor ah, ah ; 2C0F
    mov word ptr [si + 4], ax ; 2C11
    or ax, ax ; 2C14
    je X_1E1A_L2C21 ; 2C16
    mov ax, 03Fh ; 2C18
    imul word ptr [si + 4] ; 2C1B
    mov word ptr [si + 4], ax ; 2C1E
X_1E1A_L2C21:
    mov al, byte ptr [bx + 1] ; 2C21
    mov byte ptr [si + 0Bh], al ; 2C24
    mov al, byte ptr [bx + 3] ; 2C27
    mov byte ptr [si + 0Ch], al ; 2C2A
    mov al, byte ptr [bx + 5] ; 2C2D
    mov byte ptr [si + 0Dh], al ; 2C30
    mov al, byte ptr [bx + 6] ; 2C33
    mov byte ptr [si + 0Eh], al ; 2C36
    mov al, byte ptr [bx + 2] ; 2C39
    mov byte ptr [si + 0Fh], al ; 2C3C
    mov al, byte ptr [bx + 4] ; 2C3F
    mov byte ptr [si + 010h], al ; 2C42
    xor al, al ; 2C45
    mov byte ptr [si + 011h], al ; 2C47
    mov al, byte ptr [bx + 7] ; 2C4A
    mov byte ptr [si + 012h], al ; 2C4D
    push si ; 2C50
    call near ptr _snd_2C59 ; 2C51
    inc sp ; 2C54
    inc sp ; 2C55
    pop si ; 2C56
    leave ; 2C57
    ret ; 2C58

; Initialize one envelope stage
_snd_2C59 label near
    enter 0Ch, 0 ; 2C59
    push di ; 2C5D
    push si ; 2C5E
    mov di, word ptr [bp + 4] ; 2C5F
    mov al, byte ptr [di + 013h] ; 2C62
    cbw ; 2C65
    mov word ptr [bp - 0Ah], ax ; 2C66
    mov bl, byte ptr [di] ; 2C69
    dec bl ; 2C6B
    xor bh, bh ; 2C6D
    mov byte ptr [bp - 2], bl ; 2C6F
    mov al, byte ptr [bx + di + 0Bh] ; 2C72
    mov cx, ax ; 2C75
    and ax, 07Fh ; 2C77
    mov si, ax ; 2C7A
    shl si, 5 ; 2C7C
    mov bx, word ptr [bp - 0Ah] ; 2C7F
    mov bl, byte ptr [bx + si + _snd_volume_products] ; 2C82
    xor bh, bh ; 2C86
    shl bx, 1 ; 2C88
    mov ax, word ptr [bx + _snd_step_counts] ; 2C8A
    mov word ptr [bp - 4], ax ; 2C8E
    test cl, 080h ; 2C91
    je X_1E1A_L2C9F ; 2C94
    push ax ; 2C96
    call near ptr _snd_2E7A ; 2C97
    inc sp ; 2C9A
    inc sp ; 2C9B
    mov word ptr [bp - 4], ax ; 2C9C
X_1E1A_L2C9F:
    cmp word ptr [bp - 4], 0 ; 2C9F
    jne X_1E1A_L2CA8 ; 2CA3
    inc word ptr [bp - 4] ; 2CA5
X_1E1A_L2CA8:
    mov ax, word ptr [bp - 4] ; 2CA8
    mov word ptr [di + 016h], ax ; 2CAB
    mov word ptr [di + 018h], ax ; 2CAE
    cmp byte ptr [bp - 2], 2 ; 2CB1
    je X_1E1A_L2D0F ; 2CB5
    mov ax, word ptr [di + 6] ; 2CB7
    mov word ptr [bp - 8], ax ; 2CBA
    mov si, word ptr [di + 8] ; 2CBD
    mov bl, byte ptr [bp - 2] ; 2CC0
    xor bh, bh ; 2CC3
    mov cl, byte ptr [bx + di + 0Fh] ; 2CC5
    mov dx, cx ; 2CC8
    and cx, 07Fh ; 2CCA
    sub cx, 01Fh ; 2CCD
    mov word ptr [bp - 0Ch], dx ; 2CD0
    push cx ; 2CD3
    push ax ; 2CD4
    call near ptr _snd_2DD3 ; 2CD5
    add sp, 4 ; 2CD8
    mov word ptr [bp - 6], ax ; 2CDB
    test byte ptr [bp - 0Ch], 080h ; 2CDE
    je X_1E1A_L2CED ; 2CE2
    push ax ; 2CE4
    call near ptr _snd_2E7A ; 2CE5
    inc sp ; 2CE8
    inc sp ; 2CE9
    mov word ptr [bp - 6], ax ; 2CEA
X_1E1A_L2CED:
    add ax, si ; 2CED
    cmp ax, word ptr [bp - 8] ; 2CEF
    jle X_1E1A_L2CFB ; 2CF2
    mov dx, word ptr [bp - 8] ; 2CF4
    sub dx, si ; 2CF7
    jmp short X_1E1A_L2D08 ; 2CF9
X_1E1A_L2CFB:
    mov dx, word ptr [bp - 6] ; 2CFB
    mov ax, dx ; 2CFE
    add ax, si ; 2D00
    jns X_1E1A_L2D08 ; 2D02
    mov dx, si ; 2D04
    neg dx ; 2D06
X_1E1A_L2D08:
    mov bx, dx ; 2D08
    sub bx, word ptr [di + 2] ; 2D0A
    jmp short X_1E1A_L2D11 ; 2D0D
X_1E1A_L2D0F:
    xor bx, bx ; 2D0F
X_1E1A_L2D11:
    mov ax, bx ; 2D11
    cwd ; 2D13
    idiv word ptr [bp - 4] ; 2D14
    mov word ptr [di + 01Ah], ax ; 2D17
    mov al, 1 ; 2D1A
    or bx, bx ; 2D1C
    jge X_1E1A_L2D24 ; 2D1E
    neg dx ; 2D20
    neg al ; 2D22
X_1E1A_L2D24:
    mov byte ptr [di + 01Ch], al ; 2D24
    mov word ptr [di + 01Eh], dx ; 2D27
    mov word ptr [di + 020h], 0 ; 2D2A
    pop si ; 2D2F
    pop di ; 2D30
    leave ; 2D31
    ret ; 2D32

; Advance envelope interpolation and stage transitions
_snd_2D33 label near
    enter 2, 0 ; 2D33
    push di ; 2D37
    push si ; 2D38
    mov si, word ptr [bp + 4] ; 2D39
    mov word ptr [bp - 2], 0 ; 2D3C
    cmp word ptr [si + 4], 0 ; 2D41
    je X_1E1A_L2D5A ; 2D45
    sub word ptr [si + 4], 011h ; 2D47
    cmp word ptr [si + 4], 0 ; 2D4B
    jg X_1E1A_L2D5A ; 2D4F
    mov byte ptr [si], 0 ; 2D51
    xor ax, ax ; 2D54
    pop si ; 2D56
    pop di ; 2D57
    leave ; 2D58
    ret ; 2D59
X_1E1A_L2D5A:
    mov di, word ptr [si + 2] ; 2D5A
    add di, word ptr [si + 01Ah] ; 2D5D
    mov ax, word ptr [si + 016h] ; 2D60
    mov cx, word ptr [si + 01Eh] ; 2D63
    add word ptr [si + 020h], cx ; 2D66
    cmp word ptr [si + 020h], ax ; 2D69
    jb X_1E1A_L2D77 ; 2D6C
    sub word ptr [si + 020h], ax ; 2D6E
    mov al, byte ptr [si + 01Ch] ; 2D71
    cbw ; 2D74
    add di, ax ; 2D75
X_1E1A_L2D77:
    cmp word ptr [si + 2], di ; 2D77
    jne X_1E1A_L2D84 ; 2D7A
    mov al, byte ptr [si + 015h] ; 2D7C
    cmp byte ptr [si + 014h], al ; 2D7F
    je X_1E1A_L2DA6 ; 2D82
X_1E1A_L2D84:
    mov word ptr [si + 2], di ; 2D84
    mov al, byte ptr [si + 014h] ; 2D87
    mov byte ptr [si + 015h], al ; 2D8A
    cbw ; 2D8D
    push ax ; 2D8E
    push di ; 2D8F
    call near ptr _snd_2DD3 ; 2D90
    add sp, 4 ; 2D93
    mov di, ax ; 2D96
    mov bx, word ptr [bp + 6] ; 2D98
    cmp di, word ptr [bx] ; 2D9B
    je X_1E1A_L2DA6 ; 2D9D
    mov word ptr [bx], di ; 2D9F
    mov word ptr [bp - 2], 1 ; 2DA1
X_1E1A_L2DA6:
    dec word ptr [si + 018h] ; 2DA6
    jne X_1E1A_L2DCC ; 2DA9
    inc byte ptr [si] ; 2DAB
    cmp byte ptr [si], 4 ; 2DAD
    jbe X_1E1A_L2DC6 ; 2DB0
    cmp byte ptr [si + 0Ah], 0 ; 2DB2
    je X_1E1A_L2DC1 ; 2DB6
    mov byte ptr [si], 1 ; 2DB8
    or word ptr [bp - 2], 2 ; 2DBB
    jmp short X_1E1A_L2DC6 ; 2DBF
X_1E1A_L2DC1:
    mov byte ptr [si], 0 ; 2DC1
    jmp short X_1E1A_L2DCC ; 2DC4
X_1E1A_L2DC6:
    push si ; 2DC6
    call near ptr _snd_2C59 ; 2DC7
    inc sp ; 2DCA
    inc sp ; 2DCB
X_1E1A_L2DCC:
    mov ax, word ptr [bp - 2] ; 2DCC
    pop si ; 2DCF
    pop di ; 2DD0
    leave ; 2DD1
    ret ; 2DD2

; Scale an envelope amplitude
_snd_2DD3 label near
    enter 0, 0 ; 2DD3
    push si ; 2DD7
    cmp byte ptr [bp + 6], 0 ; 2DD8
    jne X_1E1A_L2DE3 ; 2DDC
    xor ax, ax ; 2DDE
    pop si ; 2DE0
    leave ; 2DE1
    ret ; 2DE2
X_1E1A_L2DE3:
    cmp byte ptr [bp + 6], 01Fh ; 2DE3
    jne X_1E1A_L2DEF ; 2DE7
    mov ax, word ptr [bp + 4] ; 2DE9
    pop si ; 2DEC
    leave ; 2DED
    ret ; 2DEE
X_1E1A_L2DEF:
    mov si, word ptr [bp + 4] ; 2DEF
    cmp si, 03Fh ; 2DF2
    jg X_1E1A_L2E58 ; 2DF5
    cmp si, -03Fh ; 2DF7
    jl X_1E1A_L2E58 ; 2DFA
    cmp byte ptr [bp + 6], 0 ; 2DFC
    jge X_1E1A_L2E33 ; 2E00
    or si, si ; 2E02
    jge X_1E1A_L2E1D ; 2E04
    mov al, byte ptr [bp + 6] ; 2E06
    cbw ; 2E09
    mov bx, offset _snd_volume_products ; 2E0A
    mov cx, si ; 2E0D
    shl cx, 5 ; 2E0F
    sub bx, cx ; 2E12
    sub bx, ax ; 2E14
    mov al, byte ptr [bx] ; 2E16
    xor ah, ah ; 2E18
    pop si ; 2E1A
    leave ; 2E1B
    ret ; 2E1C
X_1E1A_L2E1D:
    mov al, byte ptr [bp + 6] ; 2E1D
    cbw ; 2E20
    mov bx, si ; 2E21
    shl bx, 5 ; 2E23
X_1E1A_L2E26:
    sub bx, ax ; 2E26
    mov al, byte ptr [bx + _snd_volume_products] ; 2E28
    xor ah, ah ; 2E2C
    neg ax ; 2E2E
    pop si ; 2E30
    leave ; 2E31
    ret ; 2E32
X_1E1A_L2E33:
    or si, si ; 2E33
    jge X_1E1A_L2E44 ; 2E35
    mov al, byte ptr [bp + 6] ; 2E37
    cbw ; 2E3A
    mov bx, ax ; 2E3B
    mov ax, si ; 2E3D
    shl ax, 5 ; 2E3F
    jmp short X_1E1A_L2E26 ; 2E42
X_1E1A_L2E44:
    mov bx, si ; 2E44
    shl bx, 5 ; 2E46
    mov al, byte ptr [bp + 6] ; 2E49
    cbw ; 2E4C
    add bx, ax ; 2E4D
    mov al, byte ptr [bx + _snd_volume_products] ; 2E4F
    xor ah, ah ; 2E53
    pop si ; 2E55
    leave ; 2E56
    ret ; 2E57
X_1E1A_L2E58:
    mov al, byte ptr [bp + 6] ; 2E58
    cbw ; 2E5B
    mov cx, ax ; 2E5C
    lea ax, [si + 1] ; 2E5E
    imul cx ; 2E61
    sar dx, 1 ; 2E63
    rcr ax, 1 ; 2E65
    sar dx, 1 ; 2E67
    rcr ax, 1 ; 2E69
    sar dx, 1 ; 2E6B
    rcr ax, 1 ; 2E6D
    sar dx, 1 ; 2E6F
    rcr ax, 1 ; 2E71
    sar dx, 1 ; 2E73
    rcr ax, 1 ; 2E75
    pop si ; 2E77
    leave ; 2E78
    ret ; 2E79

; Advance byte LFSR and scale its result
_snd_2E7A label near
    enter 0, 0 ; 2E7A
    mov al, byte ptr [_snd_random_seed] ; 2E7E
    shr al, 1 ; 2E81
    jae X_1E1A_L2E87 ; 2E83
    xor al, 0B8h ; 2E85
X_1E1A_L2E87:
    mov byte ptr [_snd_random_seed], al ; 2E87
    xor ah, ah ; 2E8A
    imul word ptr [bp + 4] ; 2E8C
    mov al, ah ; 2E8F
    mov ah, dl ; 2E91
    mov dl, dh ; 2E93
    shl dh, 1 ; 2E95
    sbb dh, dh ; 2E97
    leave ; 2E99
    ret ; 2E9A

; ADIO.ASM _TEXT 2E9B..30C4
public _snd_2E9B
public _snd_2F48
public _snd_2F6F
public _snd_2F94
public _snd_2FA0
public _snd_2FB1
public _snd_304C

_snd_2E9B label near
    enter 0, 0 ; 2E9B
    mov bx, word ptr [bp + 4] ; 2E9F
    mov bl, byte ptr [bx + 7] ; 2EA2
    xor bh, bh ; 2EA5
    mov dl, byte ptr [bx + _snd_modulator_slots] ; 2EA7
    mov cx, bx ; 2EAB
    mov bx, word ptr [bp + 6] ; 2EAD
    mov al, byte ptr [bx] ; 2EB0
    mov ah, dl ; 2EB2
    add ah, 020h ; 2EB4
    call near ptr _snd_312B ; 2EB7
    inc bx ; 2EBA
    mov ah, byte ptr [bp + 8] ; 2EBB
    mov al, byte ptr [bx] ; 2EBE
    or al, 03Fh ; 2EC0
    sub al, ah ; 2EC2
    mov ah, dl ; 2EC4
    add ah, 040h ; 2EC6
    call near ptr _snd_312B ; 2EC9
    inc bx ; 2ECC
    mov al, byte ptr [bx] ; 2ECD
    not al ; 2ECF
    mov ah, dl ; 2ED1
    add ah, 060h ; 2ED3
    call near ptr _snd_312B ; 2ED6
    inc bx ; 2ED9
    mov al, byte ptr [bx] ; 2EDA
    not al ; 2EDC
    mov ah, dl ; 2EDE
    add ah, 080h ; 2EE0
    call near ptr _snd_312B ; 2EE3
    inc bx ; 2EE6
    mov al, byte ptr [bx] ; 2EE7
    mov ah, dl ; 2EE9
    add ah, 0E0h ; 2EEB
    call near ptr _snd_312B ; 2EEE
    inc bx ; 2EF1
    xchg bx, cx ; 2EF2
    mov dl, byte ptr [bx + _snd_carrier_slots] ; 2EF4
    xchg bx, cx ; 2EF8
    mov al, byte ptr [bx] ; 2EFA
    mov ah, dl ; 2EFC
    add ah, 020h ; 2EFE
    call near ptr _snd_312B ; 2F01
    inc bx ; 2F04
    mov ah, byte ptr [bp + 0Ah] ; 2F05
    mov al, byte ptr [bx] ; 2F08
    or al, 03Fh ; 2F0A
    sub al, ah ; 2F0C
    mov ah, dl ; 2F0E
    add ah, 040h ; 2F10
    call near ptr _snd_312B ; 2F13
    inc bx ; 2F16
    mov al, byte ptr [bx] ; 2F17
    not al ; 2F19
    mov ah, dl ; 2F1B
    add ah, 060h ; 2F1D
    call near ptr _snd_312B ; 2F20
    inc bx ; 2F23
    mov al, byte ptr [bx] ; 2F24
    not al ; 2F26
    mov ah, dl ; 2F28
    add ah, 080h ; 2F2A
    call near ptr _snd_312B ; 2F2D
    inc bx ; 2F30
    mov al, byte ptr [bx] ; 2F31
    mov ah, dl ; 2F33
    add ah, 0E0h ; 2F35
    call near ptr _snd_312B ; 2F38
    inc bx ; 2F3B
    mov al, byte ptr [bx] ; 2F3C
    mov ah, cl ; 2F3E
    add ah, 0C0h ; 2F40
    call near ptr _snd_312B ; 2F43
    leave  ; 2F46
    ret  ; 2F47

_snd_2F48 label near
    enter 0, 0 ; 2F48
    mov al, byte ptr [bp + 6] ; 2F4C
    xor ah, ah ; 2F4F
    shl ax, 7 ; 2F51
    add ax, word ptr [bp + 8] ; 2F54
    mov bl, byte ptr [bp + 4] ; 2F57
    xor bh, bh ; 2F5A
    shl bx, 1 ; 2F5C
    mov word ptr [bx + _snd_channel_frequency], ax ; 2F5E
    mov word ptr [bx + _snd_channel_frequency+18], 0 ; 2F62
    shr bx, 1 ; 2F68
    call near ptr _snd_30C4 ; 2F6A
    leave  ; 2F6D
    ret  ; 2F6E

_snd_2F6F label near
    enter 0, 0 ; 2F6F
    mov al, byte ptr [bp + 6] ; 2F73
    xor ah, ah ; 2F76
    shl ax, 7 ; 2F78
    add ax, word ptr [bp + 8] ; 2F7B
    mov bl, byte ptr [bp + 4] ; 2F7E
    xor bh, bh ; 2F81
    shl bx, 1 ; 2F83
    mov word ptr [bx + _snd_channel_frequency], ax ; 2F85
    add ax, word ptr [bx + _snd_channel_frequency+18] ; 2F89
    shr bx, 1 ; 2F8D
    call near ptr _snd_30C4 ; 2F8F
    leave  ; 2F92
    ret  ; 2F93

_snd_2F94 label near
    add ah, 0B0h ; 2F94
    call near ptr _snd_316E ; 2F97
    and al, 0DFh ; 2F9A
    call near ptr _snd_312B ; 2F9C
    ret  ; 2F9F

_snd_2FA0 label near
    add ah, 0B0h ; 2FA0
    call near ptr _snd_316E ; 2FA3
    and al, 0DFh ; 2FA6
    call near ptr _snd_312B ; 2FA8
    or al, 020h ; 2FAB
    call near ptr _snd_312B ; 2FAD
    ret  ; 2FB0

_snd_2FB1 label near
    enter 0, 0 ; 2FB1
    push si ; 2FB5
    mov si, word ptr [bp + 4] ; 2FB6
    mov al, byte ptr [bp + 6] ; 2FB9
    xor ah, ah ; 2FBC
    cmp al, 0Ch ; 2FBE
    jbe short X_2E9B_L2FD5 ; 2FC0
    cmp al, 019h ; 2FC2
    jbe short X_2E9B_L2FE0 ; 2FC4
    cmp al, 01Bh ; 2FC6
    jbe short X_2E9B_L2FED ; 2FC8
    cmp al, 01Ch ; 2FCA
    je short X_2E9B_L3024 ; 2FCC
    cmp al, 01Dh ; 2FCE
    je short X_2E9B_L302C ; 2FD0
    pop si ; 2FD2
    leave  ; 2FD3
    ret  ; 2FD4
X_2E9B_L2FD5:
    mov bl, byte ptr [si + 7] ; 2FD5
    xor bh, bh ; 2FD8
    mov dl, byte ptr [bx + _snd_carrier_slots] ; 2FDA
    jmp short X_2E9B_L2FF2 ; 2FDE
X_2E9B_L2FE0:
    sub al, 0Dh ; 2FE0
    mov bl, byte ptr [si + 7] ; 2FE2
    xor bh, bh ; 2FE5
    mov dl, byte ptr [bx + _snd_modulator_slots] ; 2FE7
    jmp short X_2E9B_L2FF2 ; 2FEB
X_2E9B_L2FED:
    sub al, 0Dh ; 2FED
    mov dl, byte ptr [si + 7] ; 2FEF
X_2E9B_L2FF2:
    mov dh, byte ptr [bp + 8] ; 2FF2
    mov bx, ax ; 2FF5
    shl bx, 2 ; 2FF7
    mov al, byte ptr [bx + _snd_register_fields+3] ; 2FFA
    or al, al ; 2FFE
    je short X_2E9B_L3006 ; 3000
    sub al, dh ; 3002
    mov dh, al ; 3004
X_2E9B_L3006:
    mov cl, byte ptr [bx + _snd_register_fields+1] ; 3006
    shl dh, cl ; 300A
    mov ah, byte ptr [bx + _snd_register_fields] ; 300C
    add ah, dl ; 3010
    call near ptr _snd_316E ; 3012
    mov cl, byte ptr [bx + _snd_register_fields+2] ; 3015
    not cl ; 3019
    and al, cl ; 301B
    or al, dh ; 301D
    call near ptr _snd_312B ; 301F
    jmp short X_2E9B_L3049 ; 3022
X_2E9B_L3024:
    mov ax, word ptr [bp + 8] ; 3024
    sub ax, 0Fh ; 3027
    jmp short X_2E9B_L3032 ; 302A
X_2E9B_L302C:
    mov ax, word ptr [bp + 8] ; 302C
    sub ax, 017Fh ; 302F
X_2E9B_L3032:
    shl ax, 4 ; 3032
    mov bl, byte ptr [si + 7] ; 3035
    xor bh, bh ; 3038
    shl bx, 1 ; 303A
    mov word ptr [bx + _snd_channel_frequency+18], ax ; 303C
    add ax, word ptr [bx + _snd_channel_frequency] ; 3040
    shr bx, 1 ; 3044
    call near ptr _snd_30C4 ; 3046
X_2E9B_L3049:
    pop si ; 3049
    leave  ; 304A
    ret  ; 304B

_snd_304C label near
    enter 0, 0 ; 304C
    push di ; 3050
    push si ; 3051
    mov al, byte ptr [bp + 6] ; 3052
    xor ah, ah ; 3055
    cmp al, 0Ch ; 3057
    jbe short X_2E9B_L306F ; 3059
    cmp al, 019h ; 305B
    jbe short X_2E9B_L307A ; 305D
    cmp al, 01Bh ; 305F
    jbe short X_2E9B_L3087 ; 3061
    cmp al, 01Ch ; 3063
    je short X_2E9B_L30B8 ; 3065
    cmp al, 01Dh ; 3067
    je short X_2E9B_L30BD ; 3069
    xor ax, ax ; 306B
    jmp short X_2E9B_L30C0 ; 306D
X_2E9B_L306F:
    mov bl, byte ptr [bp + 4] ; 306F
    xor bh, bh ; 3072
    mov dl, byte ptr [bx + _snd_carrier_slots] ; 3074
    jmp short X_2E9B_L308E ; 3078
X_2E9B_L307A:
    sub al, 0Dh ; 307A
    mov bl, byte ptr [bp + 4] ; 307C
    xor bh, bh ; 307F
    mov dl, byte ptr [bx + _snd_modulator_slots] ; 3081
    jmp short X_2E9B_L308E ; 3085
X_2E9B_L3087:
    sub al, 0Dh ; 3087
    mov bl, byte ptr [bp + 4] ; 3089
    mov dl, bl ; 308C
X_2E9B_L308E:
    mov bx, ax ; 308E
    shl bx, 2 ; 3090
    mov ah, byte ptr [bx + _snd_register_fields] ; 3093
    add ah, dl ; 3097
    call near ptr _snd_316E ; 3099
    xor ah, ah ; 309C
    mov cl, byte ptr [bx + _snd_register_fields+2] ; 309E
    and al, cl ; 30A2
    mov cl, byte ptr [bx + _snd_register_fields+1] ; 30A4
    shr al, cl ; 30A8
    mov cl, byte ptr [bx + _snd_register_fields+3] ; 30AA
    or cl, cl ; 30AE
    je short X_2E9B_L30C0 ; 30B0
    sub cl, al ; 30B2
    mov al, cl ; 30B4
    jmp short X_2E9B_L30C0 ; 30B6
X_2E9B_L30B8:
    mov ax, 0Fh ; 30B8
    jmp short X_2E9B_L30C0 ; 30BB
X_2E9B_L30BD:
    mov ax, 017Fh ; 30BD
X_2E9B_L30C0:
    pop si ; 30C0
    pop di ; 30C1
    leave  ; 30C2
    ret  ; 30C3

; SNDTAIL.ASM _TEXT 30C4..3283
public _snd_30C4
public _snd_312B
public _snd_3164
public _snd_316E
public _snd_3179
public _snd_31AA
public _snd_320A
public __aNulmul
public __aFuldiv

; AX=pitch in 1/128 semitones, BL=OPL voice.
_snd_30C4 label near
    mov ch,bl
    shl ax,1
    sub ah,4
    mov bl,ah
    xor bh,bh
    shr al,5
    mov dl,al
    mov cl,byte ptr [bx+_snd_octaves]
    shl cl,2
    mov dh,byte ptr [bx+_snd_semitones]
    mov ah,0b0h
    add ah,ch
    call near ptr _snd_316E
    mov ch,al
    and al,020h
    jz short X_30C4_make_frequency
    and ch,0dfh
    cmp cl,ch
    ja short X_30C4_rising_octave
    jb short X_30C4_falling_octave
    jmp short X_30C4_make_frequency
X_30C4_rising_octave:
    cmp dh,6
    jae short X_30C4_make_frequency
    add dh,12
    sub cl,4
    jmp short X_30C4_make_frequency
X_30C4_falling_octave:
    cmp dh,11
    jbe short X_30C4_make_frequency
    sub dh,12
    add cl,4
X_30C4_make_frequency:
    shl dh,3
    add dh,dl
    mov bl,dh
    mov al,byte ptr [bx+_snd_frequencies]
    sub ah,010h
    call near ptr _snd_312B
    mov al,cl
    or al,020h
    add ah,010h
    call near ptr _snd_312B
    ret

; Cached write: skip identical values. Preserve AX/BX/CX/DX.
_snd_312B label near
    push ax
    push bx
    push cx
    push dx
    xor bh,bh
    mov bl,ah
    cmp al,byte ptr [bx+_snd_opl_cache]
    je short X_30C4_opl_write_done
X_30C4_opl_write:
    mov byte ptr [bx+_snd_opl_cache],al
    xchg al,ah
    mov dx,0388h
    out dx,al
    mov cx,word ptr _snd_opl_index_delay
    nop
X_30C4_opl_index_wait:
    in al,dx
    and al,0
    cmp al,0ffh
    loopne X_30C4_opl_index_wait
    xchg al,ah
    inc dx
    out dx,al
    dec dx
    mov cx,word ptr _snd_opl_data_delay
X_30C4_opl_data_wait:
    in al,dx
    and al,0
    cmp al,0ffh
    loopne X_30C4_opl_data_wait
X_30C4_opl_write_done:
    pop dx
    pop cx
    pop bx
    pop ax
    ret

; Uncached write shares the same timing and cache-update path.
_snd_3164 label near
    push ax
    push bx
    push cx
    push dx
    xor bh,bh
    mov bl,ah
    jmp short X_30C4_opl_write
_snd_316E label near
    push bx
    xor bh,bh
    mov bl,ah
    mov al,byte ptr [bx+_snd_opl_cache]
    pop bx
    ret

; Low 32 bits of an unsigned 32x32 multiplication, RET 8.
__aNulmul label near
_snd_3179 label near
    enter 0,0
    mov ax,[bp+6]
    mov cx,[bp+0ah]
    or cx,ax
    mov cx,[bp+8]
    jnz short X_30C4_multiply_wide
    mov ax,[bp+4]
    mul cx
    leave
    ret 8
X_30C4_multiply_wide:
    mul cx
    mov bx,ax
    mov ax,[bp+4]
    mul word ptr [bp+0ah]
    add bx,ax
    mov ax,[bp+4]
    mul cx
    add dx,bx
    leave
    ret 8

; Original unsigned division helper with far return, RETF 8.
__aFuldiv label far
_snd_31AA label far
    enter 0,0
    push bx
    push si
    mov ax,[bp+0ch]
    or ax,ax
    jnz short X_30C4_divide_wide
    mov cx,[bp+0ah]
    mov ax,[bp+8]
    xor dx,dx
    div cx
    mov bx,ax
    mov ax,[bp+6]
    div cx
    mov dx,bx
    jmp short X_30C4_divide_done
X_30C4_divide_wide:
    mov cx,ax
    mov bx,[bp+0ah]
    mov dx,[bp+8]
    mov ax,[bp+6]
X_30C4_divide_normalize:
    shr cx,1
    rcr bx,1
    shr dx,1
    rcr ax,1
    or cx,cx
    jnz short X_30C4_divide_normalize
    div bx
    mov si,ax
    mul word ptr [bp+0ch]
    xchg cx,ax
    mov ax,[bp+0ah]
    mul si
    add dx,cx
    jc short X_30C4_quotient_high
    cmp dx,[bp+8]
    ja short X_30C4_quotient_high
    jb short X_30C4_quotient_ready
    cmp ax,[bp+6]
    jbe short X_30C4_quotient_ready
X_30C4_quotient_high:
    dec si
X_30C4_quotient_ready:
    xor dx,dx
    xchg si,ax
X_30C4_divide_done:
    pop si
    pop bx
    leave
    retf 8

; Probe AdLib timer status and calibrate the register/data I/O waits.
_snd_320A label near
    mov ax,0460h
    call near ptr _snd_3164
    mov ax,0480h
    call near ptr _snd_3164
    mov dx,0388h
    in al,dx
    and al,0e0h
    jnz short X_30C4_no_opl
    mov ax,02c0h
    call near ptr _snd_3164
    mov cx,20
    mov ax,02104h
    out dx,al
    nop
X_30C4_probe_initial_wait:
    in al,dx
    loop X_30C4_probe_initial_wait
    mov al,ah
    inc dx
    cli
    out dx,al
    dec dx
    nop
X_30C4_probe_timer_wait:
    in al,dx
    and al,0e0h
    cmp al,0c0h
    loopne X_30C4_probe_timer_wait
    sti
    jne short X_30C4_no_opl
    mov ax,0460h
    call near ptr _snd_3164
    mov ax,0480h
    call near ptr _snd_3164
    neg cx
    mov ax,cx
    xor dx,dx
    mov bx,228
    div bx
    or ax,ax
    jz short X_30C4_round_data_up
    shl dx,1
    cmp dx,bx
    jb short X_30C4_store_data_wait
X_30C4_round_data_up:
    inc ax
X_30C4_store_data_wait:
    mov word ptr _snd_opl_data_delay,ax
    mov ax,cx
    xor dx,dx
    mov bx,1551
    div bx
    or ax,ax
    jz short X_30C4_round_index_up
    shl dx,1
    cmp dx,bx
    jb short X_30C4_store_index_wait
X_30C4_round_index_up:
    inc ax
X_30C4_store_index_wait:
    mov word ptr _snd_opl_index_delay,ax
    xor ax,ax
    ret
X_30C4_no_opl:
    mov ax,-1
    ret

; exact/CONTROL.ASM SC3283 3283..3371
public _snd_3283
public _snd_32AF
public _snd_32CF
public _snd_32EB
public _snd_3303
public _snd_332F
public _snd_3362

; bind player, sequence and hook storage; original CS:3283
_snd_3283 label near
X_3283_control_3283:
    push si ; 3283
    mov si, offset _snd_players ; 3284
    xor cx, cx ; 3287
X_3283_control_3289:
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
    jb short X_3283_control_3289 ; 32AB
    pop si ; 32AD
    ret ; 32AE

; initialize sequences and timer period; original CS:32AF
_snd_32AF label near
X_3283_control_32AF:
    mov bx, offset _snd_sequences ; 32AF
    mov cx, 2 ; 32B2
    xor ax, ax ; 32B5
X_3283_control_32B7:
    mov byte ptr [bx + 2], al ; 32B7
    add bx, 034h ; 32BA
    loop X_3283_control_32B7 ; 32BD
    mov word ptr [_snd_tick_period], 08C77h ; 32BF
    mov word ptr [_snd_tick_period+2], 024h ; 32C5
    mov byte ptr [_snd_parse_nesting], al ; 32CB
    ret ; 32CE

; initialize held-note free list; original CS:32CF
_snd_32CF label near
X_3283_control_32CF:
    xor ax, ax ; 32CF
    mov word ptr [_snd_held_cursor], ax ; 32D1
    mov word ptr [_snd_held_active], ax ; 32D4
    mov bx, offset _snd_held_notes ; 32D7
    mov cx, 018h ; 32DA
X_3283_control_32DD:
    mov word ptr [bx + 2], ax ; 32DD
    mov ax, bx ; 32E0
    add bx, 014h ; 32E2
    loop X_3283_control_32DD ; 32E5
    mov word ptr [_snd_held_free], ax ; 32E7
    ret ; 32EA

; initialize fade slots; original CS:32EB
_snd_32EB label near
X_3283_control_32EB:
    mov bx, offset _snd_fades ; 32EB
    mov cx, 2 ; 32EE
X_3283_control_32F1:
    mov byte ptr [bx], ch ; 32F1
    add bx, 010h ; 32F3
    loop X_3283_control_32F1 ; 32F6
    mov byte ptr [_snd_fade_state], cl ; 32F8
    mov word ptr [_snd_fade_tick_scale], 1 ; 32FC
    ret ; 3302

; initialize part/instrument links and voices; original CS:3303
_snd_3303 label near
X_3283_control_3303:
    push si ; 3303
    mov si, offset _snd_parts ; 3304
    xor cx, cx ; 3307
X_3283_control_3309:
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
    jb short X_3283_control_3309 ; 3327
    push cs ; 3329
    call near ptr _snd_1DDB ; 332A
    pop si ; 332D
    ret ; 332E

; build volume-product lookup table; original CS:332F
_snd_332F label near
X_3283_control_332F:
    push si ; 332F
    xor si, si ; 3330
    xor cx, cx ; 3332
X_3283_control_3334:
    xor bx, bx ; 3334
    mov dx, cx ; 3336
X_3283_control_3338:
    mov ax, dx ; 3338
    sar ax, 5 ; 333A
    mov byte ptr [bx + si + _snd_volume_products], al ; 333D
    add dx, cx ; 3341
    inc bx ; 3343
    cmp bx, 020h ; 3344
    jl short X_3283_control_3338 ; 3347
    inc cx ; 3349
    add si, 020h ; 334A
    cmp si, 0800h ; 334D
    jl short X_3283_control_3334 ; 3351
    mov bx, offset _snd_volume_products ; 3353
    mov cx, 040h ; 3356
X_3283_control_3359:
    mov byte ptr [bx], ch ; 3359
    add bx, 020h ; 335B
    loop X_3283_control_3359 ; 335E
    pop si ; 3360
    ret ; 3361

; initialize command queue; original CS:3362
_snd_3362 label near
X_3283_control_3362:
    xor ax, ax ; 3362
    mov byte ptr [_snd_building_queue], al ; 3364
    mov word ptr [_snd_queue_write], ax ; 3367
    mov word ptr [_snd_queue_read], ax ; 336A
    mov word ptr [_snd_trigger_count], ax ; 336D
    ret ; 3370
SOUND_TEXT ends
end
