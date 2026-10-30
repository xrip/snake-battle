; Built from original compiler /Fa output and recovered symbolic ASM.
; Compiler instructions and compiler-inserted NOPs are unmodified.
.286p
.287
jumps
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
extrn _snd_fade_tick_scale:WORD
extrn _snd_fades:BYTE
extrn _snd_frequencies:BYTE
extrn _snd_global_instruments:BYTE
extrn _snd_held_active:WORD
extrn _snd_held_cursor:WORD
extrn _snd_held_free:WORD
extrn _snd_held_notes:BYTE
extrn _snd_hooks:BYTE
extrn _snd_instrument_fields:BYTE
extrn _snd_master_volume:WORD
extrn _snd_max_values:BYTE
extrn _snd_midi_lengths:QWORD
extrn _snd_midi_tags:QWORD
extrn _snd_modulator_slots:BYTE
extrn _snd_note_channels:BYTE
extrn _snd_octaves:BYTE
extrn _snd_opl_cache:BYTE
extrn _snd_opl_data_delay:WORD
extrn _snd_opl_index_delay:WORD
extrn _snd_parameter_map:BYTE
extrn _snd_parse_cursor:DWORD
extrn _snd_parse_finished:BYTE
extrn _snd_parse_nesting:BYTE
extrn _snd_part_instruments:BYTE
extrn _snd_parts:BYTE
extrn _snd_paused:WORD
extrn _snd_players:BYTE
extrn _snd_queue:BYTE
extrn _snd_queue_read:WORD
extrn _snd_queue_write:WORD
extrn _snd_queued_marker:BYTE
extrn _snd_queued_sound:WORD
extrn _snd_random_seed:BYTE
extrn _snd_register_fields:BYTE
extrn _snd_resources:DWORD
extrn _snd_scan_end_tick:BYTE
extrn _snd_scan_note_count:BYTE
extrn _snd_scanning:BYTE
extrn _snd_semitones:BYTE
extrn _snd_sequences:BYTE
extrn _snd_step_counts:BYTE
extrn _snd_sysex_buffer:BYTE
extrn _snd_tick_period:DWORD
extrn _snd_timer_accumulator:WORD
extrn _snd_trigger_count:WORD
extrn _snd_voice_counter:WORD
extrn _snd_voice_tick:BYTE
extrn _snd_voices:BYTE
extrn _snd_volume_products:BYTE
_DATA ends
_BSS segment word public 'BSS'
_BSS ends
DGROUP group _DATA, _BSS
SOUND_TEXT segment word public 'CODE'
assume cs:SOUND_TEXT, ds:DGROUP, ss:DGROUP

; compiler-C _snd_000C (original order 000C)
PUBLIC _snd_000C
_snd_000C	PROC FAR
; Line 8
	push	bp
	mov	bp,sp
;	resources = 6
	push	WORD PTR [bp+8]
	push	WORD PTR [bp+6]	;resources
	call	_snd_0158
	leave	
	ret	

_snd_000C	ENDP

; compiler-C _snd_001E (original order 001E)
PUBLIC _snd_001E
_snd_001E	PROC FAR
; Line 9
	call	_snd_01A7
	ret	

_snd_001E	ENDP

; compiler-C _snd_0022 (original order 0022)
PUBLIC _snd_0022
_snd_0022	PROC FAR
; Line 10
	call	_snd_01CB
	ret	

_snd_0022	ENDP

; compiler-C _snd_0026 (original order 0026)
PUBLIC _snd_0026
_snd_0026	PROC FAR
; Line 11
	call	_snd_01D5
	ret	

_snd_0026	ENDP

; compiler-C _snd_002A (original order 002A)
PUBLIC _snd_002A
_snd_002A	PROC FAR
; Line 12
	push	bp
	mov	bp,sp
;	sound = 6
	push	WORD PTR [bp+6]	;sound
	call	_snd_021C
	leave	
	ret	
	nop	

_snd_002A	ENDP

; compiler-C _snd_0039 (original order 0039)
PUBLIC _snd_0039
_snd_0039	PROC FAR
; Line 13
	push	bp
	mov	bp,sp
;	sound = 6
	push	WORD PTR [bp+6]	;sound
	call	_snd_0269
	leave	
	ret	
	nop	

_snd_0039	ENDP

; compiler-C _snd_0048 (original order 0048)
PUBLIC _snd_0048
_snd_0048	PROC FAR
; Line 14
	push	bp
	mov	bp,sp
;	sound = 6
	push	WORD PTR [bp+6]	;sound
	call	_snd_02B7
	leave	
	ret	
	nop	

_snd_0048	ENDP

; compiler-C _snd_0057 (original order 0057)
PUBLIC _snd_0057
_snd_0057	PROC FAR
; Line 15
	push	bp
	mov	bp,sp
;	sound = 6
;	volume = 8
;	time = 10
; Line 16
	push	WORD PTR [bp+10]	;time
	push	WORD PTR [bp+8]	;volume
	push	WORD PTR [bp+6]	;sound
	push	13	;000dH
	call	_snd_02E4
; Line 17
	leave	
	ret	
	nop	

_snd_0057	ENDP

; register-ABI-ASM SNDIRQ (original order 006E)
public _snd_isr_count, _snd_old_int8, _snd_0074, _snd_00B4, _snd_00E7
_snd_isr_count dw 0
_snd_old_int8 dd 0
_snd_0074 label near
    pusha
    push ds
    push es
    inc word ptr cs:_snd_isr_count
    cmp word ptr cs:_snd_isr_count,1
    jne short A_SNDIRQ_nested_irq
    mov ax,DGROUP
    mov ds,ax
A_SNDIRQ_next_pending_tick:
    add word ptr _snd_timer_accumulator,0174dh
    jnc short A_SNDIRQ_acknowledge_pic
    pushf
    call dword ptr cs:_snd_old_int8
    jmp short A_SNDIRQ_run_tick
A_SNDIRQ_acknowledge_pic:
    mov al,020h
    out 020h,al
A_SNDIRQ_run_tick:
    sti
    call near ptr _snd_055E
    dec word ptr cs:_snd_isr_count
    jne short A_SNDIRQ_next_pending_tick
    pop es
    pop ds
    popa
    iret
A_SNDIRQ_nested_irq:
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

; compiler-C _snd_00FE (original order 00FE)
PUBLIC _snd_00FE
_snd_00FE	PROC FAR
; Line 19
	enter	2,0
;	command = 6
;	a = 8
;	b = 10
;	c = 12
;	d = 14
;	e = 16
;	f = 18
;	g = 20
;	index = -2
	mov	dx,WORD PTR [bp+6]	;command
; Line 20
	mov	ax,dx
	sub	dh,dh
; Line 21
	mov	al,ah
	sub	ah,ah
; Line 28
	or	ax,ax
	je	C_SOUND_$SC284
	dec	ax
	je	C_SOUND_$SC286
	jmp	SHORT C_SOUND_$SB281
; Line 22
C_SOUND_$SC284:
; Line 23
	cmp	dx,14	;000eH
	jge	C_SOUND_$SB281
	mov	bx,dx
	shl	bx,1
	cmp	WORD PTR _snd_basic_commands[bx],0
	je	C_SOUND_$SB281
; Line 24
	push	WORD PTR [bp+12]	;c
	push	WORD PTR [bp+10]	;b
	push	WORD PTR [bp+8]	;a
	mov	bx,dx
	shl	bx,1
	call	WORD PTR _snd_basic_commands[bx]
	add	sp,6
	leave	
	ret	
; Line 26
C_SOUND_$SC286:
; Line 27
	push	WORD PTR [bp+20]	;g
	push	WORD PTR [bp+18]	;f
	push	WORD PTR [bp+16]	;e
	push	WORD PTR [bp+14]	;d
	push	WORD PTR [bp+12]	;c
	push	WORD PTR [bp+10]	;b
	push	WORD PTR [bp+8]	;a
	push	dx
	call	_snd_02E4
	add	sp,16	;0010H
	jmp	SHORT C_SOUND_$L723
; Line 28
C_SOUND_$SB281:
; Line 29
	mov	ax,-1	;ffffH
C_SOUND_$L723:
	cwd	
; Line 30
	leave	
	ret	

_snd_00FE	ENDP

; compiler-C _snd_0158 (original order 0158)
PUBLIC _snd_0158
_snd_0158	PROC NEAR
; Line 32
	push	bp
	mov	bp,sp
;	resources = 4
; Line 33
	call	_snd_320A
	or	ax,ax
	jne	C_SOUND_$I290
; Line 34
	mov	ax,WORD PTR [bp+4]	;resources
	mov	dx,WORD PTR [bp+6]
	mov	WORD PTR _snd_resources,ax
	mov	WORD PTR _snd_resources+2,dx
; Line 35
	mov	WORD PTR _snd_master_volume,127	;007fH
; Line 36
	call	_snd_3283
; Line 37
	call	_snd_32AF
; Line 38
	call	_snd_3362
; Line 39
	call	_snd_32CF
; Line 40
	call	_snd_32EB
; Line 41
	call	_snd_3303
; Line 42
	call	_snd_332F
; Line 45
	xor	ax,ax
	mov	WORD PTR _snd_scanning,ax
	mov	WORD PTR _snd_paused,ax
	mov	WORD PTR _snd_disabled,ax
; Line 46
	call	_snd_00B4
; Line 47
	xor	ax,ax
	mov	WORD PTR _snd_basic_commands,ax
	cwd	
	leave	
	ret	
; Line 50
C_SOUND_$I290:
	mov	ax,-1	;ffffH
	cwd	
; Line 51
	leave	
	ret	

_snd_0158	ENDP

; compiler-C _snd_01A7 (original order 01A7)
PUBLIC _snd_01A7
_snd_01A7	PROC NEAR
; Line 53
; Line 55
	mov	ax,1
	mov	WORD PTR _snd_paused,ax
	mov	WORD PTR _snd_disabled,ax
; Line 56
	call	_snd_00E7
; Line 57
	call	_snd_1FCC
; Line 58
	call	_snd_167E
; Line 59
	mov	BYTE PTR _snd_parse_nesting,100	;0064H
; Line 60
	call	_snd_029B
; Line 61
	mov	WORD PTR _snd_basic_commands,OFFSET _snd_0158
; Line 62
	xor	ax,ax
	cwd	
; Line 63
	ret	

_snd_01A7	ENDP

; compiler-C _snd_01CB (original order 01CB)
PUBLIC _snd_01CB
_snd_01CB	PROC NEAR
; Line 64
	mov	WORD PTR _snd_paused,1
	xor	ax,ax
	cwd	
	ret	

_snd_01CB	ENDP

; compiler-C _snd_01D5 (original order 01D5)
PUBLIC _snd_01D5
_snd_01D5	PROC NEAR
; Line 65
	xor	ax,ax
	mov	WORD PTR _snd_paused,ax
	cwd	
	ret	
	nop	

_snd_01D5	ENDP

; compiler-C _snd_01DC (original order 01DC)
PUBLIC _snd_01DC
_snd_01DC	PROC NEAR
; Line 67
	push	bp
	mov	bp,sp
	push	di
	push	si
;	volume = 4
;	register si = player
;	register di = count
; Line 70
	cmp	BYTE PTR [bp+4],127	;007fH	;volume
	jbe	C_SOUND_$I299
	mov	BYTE PTR [bp+4],127	;007fH	;volume
; Line 71
C_SOUND_$I299:
	mov	al,BYTE PTR [bp+4]	;volume
	cbw	
	mov	WORD PTR _snd_master_volume,ax
; Line 72
	mov	si,OFFSET _snd_players
; Line 73
	mov	di,2
; Line 74
C_SOUND_$D300:
; Line 75
	cmp	BYTE PTR [si+6],0
	je	C_SOUND_$I303
	mov	al,BYTE PTR [si+13]
	push	ax
	push	si
	call	_snd_075E
	add	sp,4
; Line 76
C_SOUND_$I303:
	add	si,18	;0012H
; Line 77
	dec	di
	jne	C_SOUND_$D300
; Line 78
	xor	ax,ax
	cwd	
; Line 79
	pop	si
	pop	di
	leave	
	ret	

_snd_01DC	ENDP

; compiler-C _snd_0217 (original order 0217)
PUBLIC _snd_0217
_snd_0217	PROC NEAR
; Line 80
	mov	ax,WORD PTR _snd_master_volume
	cwd	
	ret	
	nop	

_snd_0217	ENDP

; compiler-C _snd_021C (original order 021C)
PUBLIC _snd_021C
_snd_021C	PROC NEAR
; Line 82
	push	bp
	mov	bp,sp
	push	di
	push	si
;	sound = 4
;	register si = player
	mov	di,WORD PTR [bp+4]	;sound
; Line 84
	push	0
	push	WORD PTR _snd_midi_tags+2
	push	WORD PTR _snd_midi_tags
	push	di
	call	_snd_0406
	add	sp,8
	or	dx,ax
	je	C_SOUND_$I309
; Line 86
	push	128	;0080H
	call	_snd_05A6
	add	sp,2
	mov	si,ax
	or	si,si
	je	C_SOUND_$I309
; Line 87
	push	si
	call	_snd_0643
	add	sp,2
; Line 88
	push	di
	push	si
	call	_snd_05E8
	add	sp,4
	or	ax,ax
	je	C_SOUND_$I309
	xor	ax,ax
	cwd	
	pop	si
	pop	di
	leave	
	ret	
; Line 91
C_SOUND_$I309:
	mov	ax,-1	;ffffH
	cwd	
; Line 92
	pop	si
	pop	di
	leave	
	ret	

_snd_021C	ENDP

; compiler-C _snd_0269 (original order 0269)
PUBLIC _snd_0269
_snd_0269	PROC NEAR
; Line 94
	push	bp
	mov	bp,sp
	push	di
	push	si
;	sound = 4
;	register si = player
;	register di = result
; Line 95
	mov	si,OFFSET _snd_players
; Line 96
	mov	di,-1	;ffffH
; Line 97
C_SOUND_$D317:
; Line 98
	cmp	BYTE PTR [si+6],1
	jne	C_SOUND_$I320
	mov	ax,WORD PTR [bp+4]	;sound
	cmp	WORD PTR [si+8],ax
	jne	C_SOUND_$I320
; Line 99
	push	si
	call	_snd_0643
	add	sp,2
; Line 100
	xor	di,di
; Line 102
C_SOUND_$I320:
; Line 103
	add	si,18	;0012H
	cmp	si,OFFSET _snd_players+36
	jb	C_SOUND_$D317
; Line 104
	mov	ax,di
	cwd	
; Line 105
	pop	si
	pop	di
	leave	
	ret	

_snd_0269	ENDP

; compiler-C _snd_029B (original order 029B)
PUBLIC _snd_029B
_snd_029B	PROC NEAR
; Line 107
	push	si
;	register si = player
; Line 109
	call	_snd_0DA8
; Line 110
	mov	si,OFFSET _snd_players
; Line 111
C_SOUND_$D323:
; Line 112
	push	si
	call	_snd_0643
	add	sp,2
; Line 114
	add	si,18	;0012H
	cmp	si,OFFSET _snd_players+36
	jb	C_SOUND_$D323
; Line 115
	xor	ax,ax
	cwd	
; Line 116
	pop	si
	ret	

_snd_029B	ENDP

; compiler-C _snd_02B7 (original order 02B7)
PUBLIC _snd_02B7
_snd_02B7	PROC NEAR
; Line 118
	push	bp
	mov	bp,sp
;	sound = 4
;	register bx = player
;	register dx = count
; Line 119
	mov	bx,OFFSET _snd_players
; Line 120
	mov	dx,2
	mov	cx,WORD PTR [bp+4]	;sound
; Line 121
C_SOUND_$D331:
; Line 122
	cmp	BYTE PTR [bx+6],1
	jne	C_SOUND_$I334
	cmp	WORD PTR [bx+8],cx
	je	C_SOUND_$L684
; Line 123
C_SOUND_$I334:
	add	bx,18	;0012H
; Line 124
	dec	dx
	jne	C_SOUND_$D331
	jmp	SHORT C_SOUND_$L685
	nop	
C_SOUND_$L684:
; Line 122
	mov	ax,1
	cwd	
	leave	
	ret	
C_SOUND_$L685:
; Line 125
	push	cx
	call	_snd_17FC
	cwd	
; Line 126
	leave	
	ret	
	nop	

_snd_02B7	ENDP

; compiler-C _snd_02E4 (original order 02E4)
PUBLIC _snd_02E4
_snd_02E4	PROC NEAR
; Line 128
	enter	2,0
	push	si
;	command = 4
;	a = 6
;	b = 8
;	c = 10
;	d = 12
;	e = 14
;	f = 16
;	g = 18
;	function = -2
;	register si = player
	mov	si,WORD PTR [bp+4]	;command
; Line 131
	cmp	si,24	;0018H
	jl	C_SOUND_$JCC589
	jmp	C_SOUND_$L731
C_SOUND_$JCC589:
; Line 133
	mov	bx,si
	mov	ax,WORD PTR _snd_extended_commands[bx][si]
	mov	WORD PTR [bp-2],ax	;function
	or	ax,ax
	jne	C_SOUND_$JCC605
	jmp	C_SOUND_$L731
C_SOUND_$JCC605:
; Line 134
	mov	al,BYTE PTR _snd_command_kinds[si]
	sub	ah,ah
; Line 164
	cmp	ax,6
	jbe	C_SOUND_$JCC619
	jmp	C_SOUND_$L731
C_SOUND_$JCC619:
	shl	ax,1
	xchg	ax,bx
	jmp	WORD PTR cs:C_SOUND_$L690[bx]
C_SOUND_$L690:
		DW	C_SOUND_$SC360
		DW	C_SOUND_$SC365
		DW	C_SOUND_$SC363
		DW	C_SOUND_$SC365
		DW	C_SOUND_$SC367
		DW	C_SOUND_$L731
		DW	C_SOUND_$L731
; Line 135
C_SOUND_$SC360:
; Line 136
	push	WORD PTR [bp+18]	;g
	push	WORD PTR [bp+16]	;f
	push	WORD PTR [bp+14]	;e
	push	WORD PTR [bp+12]	;d
	push	WORD PTR [bp+10]	;c
	push	WORD PTR [bp+8]	;b
	push	WORD PTR [bp+6]	;a
C_SOUND_$L732:
	call	WORD PTR [bp-2]	;function
	add	sp,14	;000eH
	pop	si
	leave	
	ret	
C_SOUND_$SC363:
; Line 143
	push	WORD PTR [bp+6]	;a
	call	_snd_0574
	add	sp,2
	mov	si,ax
	or	si,si
	je	C_SOUND_$L731
	push	WORD PTR [bp+18]	;g
	push	WORD PTR [bp+16]	;f
	push	WORD PTR [bp+14]	;e
	push	WORD PTR [bp+12]	;d
	push	WORD PTR [bp+10]	;c
	push	WORD PTR [bp+8]	;b
	push	WORD PTR [si]
	jmp	SHORT C_SOUND_$L732
	nop	
; Line 145
C_SOUND_$SC365:
	push	WORD PTR [bp+6]	;a
	call	_snd_0574
	add	sp,2
	mov	si,ax
	or	si,si
	je	C_SOUND_$L731
	push	WORD PTR [bp+10]	;c
	push	WORD PTR [bp+8]	;b
	push	si
	call	WORD PTR [bp-2]	;function
	add	sp,6
; Line 140
	pop	si
	leave	
	ret	
	nop	
; Line 149
C_SOUND_$SC367:
; Line 151
	push	WORD PTR [bp+6]	;a
	call	_snd_0574
	add	sp,2
	mov	si,ax
	or	si,si
	jne	C_SOUND_$I368
C_SOUND_$L731:
	mov	ax,-1	;ffffH
	pop	si
	leave	
	ret	
	nop	
C_SOUND_$I368:
	push	WORD PTR [bp+12]	;d
	push	WORD PTR [bp+10]	;c
	push	WORD PTR [bp+8]	;b
	push	WORD PTR [si+2]
	call	WORD PTR [bp-2]	;function
	add	sp,8
; Line 152
	pop	si
	leave	
	ret	
	nop	

_snd_02E4	ENDP

; compiler-C _snd_0406 (original order 0406)
PUBLIC _snd_0406
_snd_0406	PROC NEAR
; Line 168
	enter	4,0
	push	di
	push	si
;	sound = 4
;	tag = 6
;	index = 10
;	chunk = -4
	mov	bx,WORD PTR [bp+4]	;sound
; Line 169
	shl	bx,2
	les	di,DWORD PTR _snd_resources
	mov	ax,WORD PTR es:[bx][di]
	mov	dx,WORD PTR es:[bx+2][di]
	mov	si,ax
	mov	WORD PTR [bp-2],dx
; Line 170
	or	dx,ax
	je	C_SOUND_$I381
	mov	es,WORD PTR [bp-2]
	cmp	WORD PTR es:[si],21581	;544dH
	jne	C_SOUND_$I381
	cmp	WORD PTR es:[si+2],25704	;6468H
	jne	C_SOUND_$I381
; Line 171
	cmp	WORD PTR [bp+8],25704	;6468H
	jne	C_SOUND_$I382
C_SOUND_$L734:
	lea	ax,WORD PTR [si+8]
	mov	dx,WORD PTR [bp-2]
	pop	si
	pop	di
	leave	
	ret	
	nop	
; Line 172
C_SOUND_$I382:
	mov	di,WORD PTR [bp+10]	;index
; Line 173
	mov	ax,WORD PTR es:[si+10]
	mov	cx,ax
	mov	ah,al
	mov	dl,ch
	mov	dh,al
	cmp	dx,di
	ja	C_SOUND_$L691
	xor	di,di
C_SOUND_$L691:
; Line 176
	add	si,4
	push	WORD PTR [bp-2]
	push	si
	call	_snd_04B8
	add	sp,4
	add	ax,4
	add	si,ax
; Line 177
	dec	di
	jns	C_SOUND_$L691
; Line 178
	mov	ax,WORD PTR [bp+6]	;tag
	mov	dx,WORD PTR [bp+8]
	mov	es,WORD PTR [bp-2]
	cmp	WORD PTR es:[si],ax
	jne	C_SOUND_$I381
	cmp	WORD PTR es:[si+2],dx
	je	C_SOUND_$L734
; Line 180
C_SOUND_$I381:
	xor	ax,ax
	cwd	
; Line 181
	pop	si
	pop	di
	leave	
	ret	
	nop	

_snd_0406	ENDP

; register-ABI-ASM SNDWAIT (original order 0496)
public _snd_0496
_snd_0496 label near
    push ax
    push cx
A_SNDWAIT_next_wait:
    or bx,bx
    jz short A_SNDWAIT_wait_done
    mov cx,041h
    xor ax,ax
A_SNDWAIT_next_toggle:
    jmp short A_SNDWAIT_delay1
A_SNDWAIT_delay1:
    jmp short A_SNDWAIT_delay2
A_SNDWAIT_delay2:
    in al,061h
    and al,010h
    cmp al,ah
    je short A_SNDWAIT_next_toggle
    xor ah,010h
    loop A_SNDWAIT_next_toggle
    dec bx
    jmp short A_SNDWAIT_next_wait
A_SNDWAIT_wait_done:
    pop cx
    pop ax
    ret

; compiler-C _snd_04B8 (original order 04B8)
PUBLIC _snd_04B8
_snd_04B8	PROC NEAR
; Line 183
	push	bp
	mov	bp,sp
;	p = 4
;	words = -4
;	high = -6
;	low = -8
	mov	bx,WORD PTR [bp+4]	;p
; Line 187
	mov	es,WORD PTR [bp+6]
	mov	ax,WORD PTR es:[bx+2]
	mov	cx,ax
	mov	ah,al
	mov	dx,ax
	mov	al,ch
	mov	ah,dl
	mov	cx,WORD PTR es:[bx]
	mov	bx,cx
	mov	cl,ch
	sub	ch,ch
	mov	bh,bl
	sub	bl,bl
	or	cx,bx
	mov	dx,cx
; Line 188
	leave	
	ret	

_snd_04B8	ENDP

; compiler-C _snd_04CC (original order 04CC)
PUBLIC _snd_04CC
_snd_04CC	PROC NEAR
; Line 189
	push	bp
	mov	bp,sp
;	p = 4
;	word = -2
	mov	bx,WORD PTR [bp+4]	;p
; Line 191
	mov	ax,WORD PTR [bx]
	mov	cx,ax
	mov	ah,al
	mov	dx,ax
	mov	al,ch
	mov	ah,dl
; Line 192
	leave	
	ret	

_snd_04CC	ENDP

; compiler-C _snd_04D9 (original order 04D9)
PUBLIC _snd_04D9
_snd_04D9	PROC NEAR
; Line 193
	push	bp
	mov	bp,sp
;	value = 4
;	low = 6
;	high = 8
	mov	dx,WORD PTR [bp+4]	;value
	mov	bx,WORD PTR [bp+6]	;low
; Line 194
	cmp	bx,dx
	jg	C_SOUND_$L735
	mov	bx,WORD PTR [bp+8]	;high
	cmp	bx,dx
	jge	C_SOUND_$I406
C_SOUND_$L735:
	mov	dx,bx
; Line 196
C_SOUND_$I406:
	mov	ax,dx
; Line 197
	leave	
	ret	

_snd_04D9	ENDP

; compiler-C _snd_04F4 (original order 04F4)
PUBLIC _snd_04F4
_snd_04F4	PROC NEAR
; Line 198
	push	bp
	mov	bp,sp
	push	di
;	value = 4
;	low = 6
;	high = 8
	mov	di,WORD PTR [bp+6]	;low
	mov	bx,WORD PTR [bp+4]	;value
; Line 199
	cmp	di,bx
	jl	C_SOUND_$I415
	mov	ax,di
	sub	ax,bx
	add	ax,11	;000bH
	mov	cx,12	;000cH
	sub	dx,dx
	div	cx
	mov	dx,ax
	shl	ax,1
	add	ax,dx
	shl	ax,2
	add	bx,ax
; Line 200
C_SOUND_$I415:
	cmp	WORD PTR [bp+8],bx	;high
	jge	C_SOUND_$I416
	mov	ax,bx
	sub	ax,WORD PTR [bp+8]	;high
	add	ax,11	;000bH
	mov	cx,12	;000cH
	sub	dx,dx
	div	cx
	mov	dx,ax
	shl	ax,1
	add	ax,dx
	shl	ax,2
	sub	bx,ax
; Line 201
C_SOUND_$I416:
	mov	ax,bx
; Line 202
	pop	di
	leave	
	ret	
	nop	

_snd_04F4	ENDP

; register-ABI-ASM SNDMEM (original order 053D)
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

; compiler-C _snd_055E (original order 055E)
PUBLIC _snd_055E
_snd_055E	PROC NEAR
; Line 205
; Line 206
	mov	ax,WORD PTR _snd_disabled
	or	ax,WORD PTR _snd_paused
	jne	C_SOUND_$EX417
; Line 207
	call	_snd_0E7C
; Line 208
	call	_snd_1263
; Line 209
	call	_snd_1E1A
; Line 210
	call	_snd_16A5
; Line 212
C_SOUND_$EX417:
	ret	

_snd_055E	ENDP

; compiler-C _snd_0574 (original order 0574)
PUBLIC _snd_0574
_snd_0574	PROC NEAR
; Line 213
	enter	2,0
	push	di
;	sound = 4
;	register bx = player
;	found = -2
;	register dx = count
;	register cx = matches
; Line 214
	mov	bx,OFFSET _snd_players
; Line 215
	mov	dx,2
	mov	cx,-1	;ffffH
	mov	di,WORD PTR [bp-2]	;found
; Line 216
C_SOUND_$D426:
; Line 217
	cmp	BYTE PTR [bx+6],1
	jne	C_SOUND_$I429
	mov	ax,WORD PTR [bp+4]	;sound
	cmp	WORD PTR [bx+8],ax
	jne	C_SOUND_$I429
; Line 218
	mov	di,bx
; Line 219
	inc	cx
; Line 221
C_SOUND_$I429:
	add	bx,18	;0012H
; Line 222
	dec	dx
	jne	C_SOUND_$D426
; Line 223
	or	cx,cx
	je	C_SOUND_$I430
	xor	ax,ax
	pop	di
	leave	
	ret	
	nop	
C_SOUND_$I430:
	mov	ax,di
; Line 225
	pop	di
	leave	
	ret	
	nop	

_snd_0574	ENDP

; compiler-C _snd_05A6 (original order 05A6)
PUBLIC _snd_05A6
_snd_05A6	PROC NEAR
; Line 226
	enter	2,0
	push	si
;	priority = 4
;	register si = player
;	register cx = candidate
;	register dx = i
;	lowest = -1
; Line 227
	mov	si,OFFSET _snd_players
	xor	cx,cx
; Line 228
	xor	dx,dx
; Line 229
	mov	BYTE PTR [bp-1],255	;00ffH	;lowest
; Line 230
C_SOUND_$D438:
; Line 231
	cmp	BYTE PTR [si+6],0
	je	C_SOUND_$L694
; Line 232
	cmp	BYTE PTR [si+6],1
	jne	C_SOUND_$I442
	mov	al,BYTE PTR [bp-1]	;lowest
	cmp	BYTE PTR [si+12],al
	ja	C_SOUND_$I442
; Line 233
	mov	al,BYTE PTR [si+12]
	mov	BYTE PTR [bp-1],al	;lowest
; Line 234
	mov	cx,si
; Line 236
C_SOUND_$I442:
	add	si,18	;0012H
; Line 237
	inc	dx
	cmp	dx,2
	jl	C_SOUND_$D438
; Line 238
	mov	al,BYTE PTR [bp+4]	;priority
	cmp	BYTE PTR [bp-1],al	;lowest
	ja	C_SOUND_$I443
	mov	ax,cx
	pop	si
	leave	
	ret	
C_SOUND_$L694:
; Line 231
	mov	ax,si
	pop	si
	leave	
	ret	
	nop	
C_SOUND_$I443:
	xor	ax,ax
; Line 240
	pop	si
	leave	
	ret	
	nop	

_snd_05A6	ENDP

; compiler-C _snd_05E8 (original order 05E8)
PUBLIC _snd_05E8
_snd_05E8	PROC NEAR
; Line 241
	push	bp
	mov	bp,sp
	push	di
	push	si
;	register di = result
;	player = 4
;	sound = 6
	mov	si,WORD PTR [bp+4]	;player
; Line 243
	mov	WORD PTR [si+4],0
; Line 244
	mov	BYTE PTR [si+6],1
; Line 245
	mov	ax,WORD PTR [bp+6]	;sound
	mov	WORD PTR [si+8],ax
; Line 246
	mov	BYTE PTR [si+12],128	;0080H
; Line 247
	mov	BYTE PTR [si+13],127	;007fH
; Line 248
	mov	WORD PTR [si+10],-1	;ffffH
; Line 249
	mov	al,BYTE PTR [si+13]
	sub	ah,ah
	inc	ax
	imul	WORD PTR _snd_master_volume
	sar	ax,7
	mov	BYTE PTR [si+14],al
; Line 251
	xor	al,al
	mov	BYTE PTR [si+15],al
	mov	BYTE PTR [si+16],al
; Line 252
	mov	BYTE PTR [si+17],al
; Line 253
	push	WORD PTR [si+2]
	call	_snd_1086
	add	sp,2
; Line 255
	push	WORD PTR [bp+6]	;sound
	push	WORD PTR [si]
	call	_snd_0DB9
	add	sp,4
	mov	di,ax
	or	di,di
	jne	C_SOUND_$I450
	mov	BYTE PTR [si+6],0
; Line 256
C_SOUND_$I450:
; Line 257
	pop	si
	pop	di
	leave	
	ret	
	nop	

_snd_05E8	ENDP

; compiler-C _snd_0643 (original order 0643)
PUBLIC _snd_0643
_snd_0643	PROC NEAR
; Line 258
	push	bp
	mov	bp,sp
	push	si
;	player = 4
	mov	si,WORD PTR [bp+4]	;player
; Line 259
	cmp	BYTE PTR [si+6],1
	jne	C_SOUND_$EX453
; Line 260
	push	WORD PTR [si]
	call	_snd_0E6A
	add	sp,2
; Line 261
	push	si
	call	_snd_1684
	add	sp,2
; Line 262
	push	si
	call	_snd_20E7
	add	sp,2
; Line 263
	mov	BYTE PTR [si+6],0
; Line 265
C_SOUND_$EX453:
	pop	si
	leave	
	ret	

_snd_0643	ENDP

; compiler-C _snd_066B (original order 066B)
PUBLIC _snd_066B
_snd_066B	PROC NEAR
; Line 267
	push	bp
	mov	bp,sp
;	player = 4
;	parameter = 6
;	channel = 8
	mov	dx,WORD PTR [bp+6]	;parameter
; Line 268
	mov	ax,dx
; Line 287
	cmp	ax,23	;0017H
	ja	C_SOUND_$SB463
	shl	ax,1
	xchg	ax,bx
	jmp	WORD PTR cs:C_SOUND_$L697[bx]
	nop	
C_SOUND_$L697:
		DW	C_SOUND_$SC466
		DW	C_SOUND_$SC467
		DW	C_SOUND_$SC468
		DW	C_SOUND_$SC469
		DW	C_SOUND_$SC470
		DW	C_SOUND_$SC471
		DW	C_SOUND_$SC472
		DW	C_SOUND_$SC473
		DW	C_SOUND_$SC474
		DW	C_SOUND_$SC475
		DW	C_SOUND_$SC476
		DW	C_SOUND_$SC477
		DW	C_SOUND_$SC478
		DW	C_SOUND_$SC479
		DW	C_SOUND_$SC480
		DW	C_SOUND_$SC480
		DW	C_SOUND_$SC480
		DW	C_SOUND_$SC480
		DW	C_SOUND_$SC481
		DW	C_SOUND_$SC481
		DW	C_SOUND_$SC481
		DW	C_SOUND_$SC481
		DW	C_SOUND_$SC481
		DW	C_SOUND_$SC481
C_SOUND_$SB463:
; Line 288
	mov	ax,-1	;ffffH
	jmp	C_SOUND_$EX461
; Line 269
C_SOUND_$SC466:
	mov	bx,WORD PTR [bp+4]	;player
	mov	al,BYTE PTR [bx+12]
C_SOUND_$L736:
	sub	ah,ah
	jmp	C_SOUND_$EX461
	nop	
; Line 270
C_SOUND_$SC467:
	mov	bx,WORD PTR [bp+4]	;player
	mov	al,BYTE PTR [bx+13]
	jmp	SHORT C_SOUND_$L736
; Line 271
C_SOUND_$SC468:
	mov	bx,WORD PTR [bp+4]	;player
	mov	al,BYTE PTR [bx+15]
	jmp	SHORT C_SOUND_$L736
; Line 272
C_SOUND_$SC469:
	mov	bx,WORD PTR [bp+4]	;player
	mov	al,BYTE PTR [bx+16]
	jmp	SHORT C_SOUND_$L736
; Line 273
C_SOUND_$SC470:
	mov	bx,WORD PTR [bp+4]	;player
	mov	al,BYTE PTR [bx+17]
	jmp	SHORT C_SOUND_$L736
; Line 274
C_SOUND_$SC471:
	mov	bx,WORD PTR [bp+4]	;player
	mov	bx,WORD PTR [bx]
	mov	al,BYTE PTR [bx+36]
	jmp	SHORT C_SOUND_$L736
; Line 275
C_SOUND_$SC472:
	mov	bx,WORD PTR [bp+4]	;player
	mov	bx,WORD PTR [bx]
	mov	ax,WORD PTR [bx+10]
	jmp	SHORT C_SOUND_$EX461
; Line 276
C_SOUND_$SC473:
	mov	bx,WORD PTR [bp+4]	;player
	mov	bx,WORD PTR [bx]
	mov	ax,WORD PTR [bx+12]
	jmp	SHORT C_SOUND_$EX461
; Line 277
C_SOUND_$SC474:
	mov	bx,WORD PTR [bp+4]	;player
	mov	bx,WORD PTR [bx]
	mov	ax,WORD PTR [bx+14]
	jmp	SHORT C_SOUND_$EX461
; Line 278
C_SOUND_$SC475:
	mov	bx,WORD PTR [bp+4]	;player
	mov	bx,WORD PTR [bx]
	mov	ax,WORD PTR [bx+42]
	leave	
	ret	
; Line 279
C_SOUND_$SC476:
	mov	bx,WORD PTR [bp+4]	;player
	mov	bx,WORD PTR [bx]
	mov	ax,WORD PTR [bx+44]
	leave	
	ret	
; Line 280
C_SOUND_$SC477:
	mov	bx,WORD PTR [bp+4]	;player
	mov	bx,WORD PTR [bx]
	mov	ax,WORD PTR [bx+46]
	leave	
	ret	
; Line 281
C_SOUND_$SC478:
	mov	bx,WORD PTR [bp+4]	;player
	mov	bx,WORD PTR [bx]
	mov	ax,WORD PTR [bx+48]
	leave	
	ret	
; Line 282
C_SOUND_$SC479:
	mov	bx,WORD PTR [bp+4]	;player
	mov	bx,WORD PTR [bx]
	mov	ax,WORD PTR [bx+50]
	leave	
	ret	
; Line 283
C_SOUND_$SC480:
; Line 284
	mov	al,BYTE PTR [bp+8]	;channel
	push	ax
	push	dx
	push	WORD PTR [bp+4]	;player
	call	_snd_261A
	mov	sp,bp
	jmp	C_SOUND_$L736
; Line 285
C_SOUND_$SC481:
; Line 286
	mov	al,BYTE PTR [bp+8]	;channel
	push	ax
	push	dx
	mov	bx,WORD PTR [bp+4]	;player
	push	WORD PTR [bx+2]
	call	_snd_11F0
; Line 289
C_SOUND_$EX461:
	leave	
	ret	

_snd_066B	ENDP

; compiler-C _snd_0743 (original order 0743)
PUBLIC _snd_0743
_snd_0743	PROC NEAR
; Line 290
	push	bp
	mov	bp,sp
	push	si
;	player = 4
;	priority = 6
	mov	si,WORD PTR [bp+4]	;player
; Line 292
	mov	al,BYTE PTR [bp+6]	;priority
	mov	BYTE PTR [si+12],al
	push	ax
	push	16	;0010H
	push	si
	call	_snd_22F1
	add	sp,6
; Line 293
	xor	ax,ax
; Line 294
	pop	si
	leave	
	ret	

_snd_0743	ENDP

; compiler-C _snd_075E (original order 075E)
PUBLIC _snd_075E
_snd_075E	PROC NEAR
; Line 295
	push	bp
	mov	bp,sp
;	player = 4
;	volume = 6
; Line 296
	cmp	BYTE PTR [bp+6],127	;007fH	;volume
	jbe	C_SOUND_$I492
	mov	BYTE PTR [bp+6],127	;007fH	;volume
; Line 297
C_SOUND_$I492:
	mov	al,BYTE PTR [bp+6]	;volume
	mov	bx,WORD PTR [bp+4]	;player
	mov	BYTE PTR [bx+13],al
; Line 299
	cbw	
	inc	ax
	imul	WORD PTR _snd_master_volume
	sar	ax,7
	mov	BYTE PTR [bx+14],al
	push	ax
	push	16	;0010H
	push	bx
	call	_snd_235A
; Line 300
	xor	ax,ax
; Line 301
	leave	
	ret	
	nop	

_snd_075E	ENDP

; compiler-C _snd_078F (original order 078F)
PUBLIC _snd_078F
_snd_078F	PROC NEAR
; Line 302
	push	bp
	mov	bp,sp
	push	si
;	player = 4
;	pan = 6
	mov	si,WORD PTR [bp+4]	;player
; Line 304
	mov	al,BYTE PTR [bp+6]	;pan
	mov	BYTE PTR [si+15],al
	push	ax
	push	16	;0010H
	push	si
	call	_snd_23D1
	add	sp,6
; Line 305
	xor	ax,ax
; Line 306
	pop	si
	leave	
	ret	

_snd_078F	ENDP

; compiler-C _snd_07AA (original order 07AA)
PUBLIC _snd_07AA
_snd_07AA	PROC NEAR
; Line 307
	push	bp
	mov	bp,sp
;	player = 4
;	relative = 6
;	transpose = 8
; Line 308
	cmp	BYTE PTR [bp+8],24	;0018H	;transpose
	jg	C_SOUND_$I506
	cmp	BYTE PTR [bp+8],232	;00e8H	;transpose
	jl	C_SOUND_$I506
	cmp	BYTE PTR [bp+6],1	;relative
	ja	C_SOUND_$I506
; Line 309
	cmp	BYTE PTR [bp+6],0	;relative
	je	C_SOUND_$I507
	push	7
	push	-7	;fff9H
	mov	al,BYTE PTR [bp+8]	;transpose
	cbw	
	mov	bx,WORD PTR [bp+4]	;player
	mov	cx,ax
	mov	al,BYTE PTR [bx+16]
	cbw	
	add	cx,ax
	push	cx
	call	_snd_04F4
	mov	sp,bp
	mov	BYTE PTR [bp+8],al	;transpose
; Line 310
C_SOUND_$I507:
; Line 311
	mov	al,BYTE PTR [bp+8]	;transpose
	mov	bx,WORD PTR [bp+4]	;player
	mov	BYTE PTR [bx+16],al
	push	ax
	mov	al,BYTE PTR [bp+6]	;relative
	push	ax
	push	16	;0010H
	push	bx
	call	_snd_23D2
	mov	sp,bp
; Line 312
	xor	ax,ax
	leave	
	ret	
	nop	
; Line 308
C_SOUND_$I506:
	mov	ax,-1	;ffffH
; Line 313
	leave	
	ret	
	nop	

_snd_07AA	ENDP

; compiler-C _snd_07F9 (original order 07F9)
PUBLIC _snd_07F9
_snd_07F9	PROC NEAR
; Line 314
	push	bp
	mov	bp,sp
	push	si
;	player = 4
;	detune = 6
	mov	si,WORD PTR [bp+4]	;player
; Line 316
	mov	al,BYTE PTR [bp+6]	;detune
	mov	BYTE PTR [si+17],al
	push	ax
	push	16	;0010H
	push	si
	call	_snd_247E
	add	sp,6
; Line 317
	xor	ax,ax
; Line 318
	pop	si
	leave	
	ret	

_snd_07F9	ENDP

; compiler-C _snd_0814 (original order 0814)
PUBLIC _snd_0814
_snd_0814	PROC NEAR
; Line 319
	push	bp
	mov	bp,sp
	push	si
;	sequence = 4
;	speed = 6
	mov	si,WORD PTR [bp+4]	;sequence
; Line 320
	mov	al,BYTE PTR [bp+6]	;speed
	mov	BYTE PTR [si+36],al
; Line 321
	sub	ah,ah
	push	0
	push	ax
	push	WORD PTR [si+34]
	push	WORD PTR [si+32]
	call	__aNulmul
	shr	dx,1
	rcr	ax,1
	shr	dx,1
	rcr	ax,1
	shr	dx,1
	rcr	ax,1
	shr	dx,1
	rcr	ax,1
	shr	dx,1
	rcr	ax,1
	shr	dx,1
	rcr	ax,1
	shr	dx,1
	rcr	ax,1
	mov	WORD PTR [si+38],ax
	mov	WORD PTR [si+40],dx
; Line 322
	xor	ax,ax
; Line 323
	pop	si
	leave	
	ret	

_snd_0814	ENDP

; compiler-C _snd_0857 (original order 0857)
PUBLIC _snd_0857
_snd_0857	PROC NEAR
; Line 325
	enter	20,0
	push	di
	push	si
;	sequence = 4
;	track = 6
;	beat = 8
;	tick = 10
;	new_track = -16
;	old_track = -20
;	target = -8
;	next = -4
;	offset = -12
	mov	si,WORD PTR [bp+4]	;sequence
; Line 328
	cmp	BYTE PTR [si+2],0
	jne	C_SOUND_$I532
C_SOUND_$L737:
	mov	ax,-1	;ffffH
	pop	si
	pop	di
	leave	
	ret	
; Line 329
C_SOUND_$I532:
; Line 330
	push	WORD PTR [bp+6]	;track
	push	WORD PTR _snd_midi_tags+6
	push	WORD PTR _snd_midi_tags+4
	push	WORD PTR [si+4]
	call	_snd_0406
	add	sp,8
	mov	WORD PTR [bp-16],ax	;new_track
	mov	WORD PTR [bp-14],dx
	or	dx,ax
	je	C_SOUND_$L737
; Line 332
	push	WORD PTR [si+10]
	push	WORD PTR _snd_midi_tags+6
	push	WORD PTR _snd_midi_tags+4
	push	WORD PTR [si+4]
	call	_snd_0406
	add	sp,8
	mov	WORD PTR [bp-20],ax	;old_track
	mov	WORD PTR [bp-18],dx
	or	dx,ax
	je	C_SOUND_$L737
; Line 333
	inc	BYTE PTR _snd_parse_nesting
	mov	di,WORD PTR [bp+8]	;beat
; Line 334
	or	di,di
	jne	C_SOUND_$I535
	mov	di,1
; Line 335
C_SOUND_$I535:
	lea	ax,WORD PTR [di-1]
	mov	cx,480	;01e0H
	mul	cx
	add	ax,WORD PTR [bp+10]	;tick
	adc	dx,0
	mov	WORD PTR [bp-8],ax	;target
	mov	WORD PTR [bp-6],dx
	mov	WORD PTR [bp+8],di	;beat
; Line 336
	mov	ax,WORD PTR [bp+6]	;track
	cmp	WORD PTR [si+10],ax
	jne	C_SOUND_$I536
	mov	ax,WORD PTR [bp-8]	;target
	cmp	WORD PTR [si+18],dx
	ja	C_SOUND_$I536
	jb	C_SOUND_$L701
	cmp	WORD PTR [si+16],ax
	ja	C_SOUND_$I536
C_SOUND_$L701:
; Line 337
	mov	ax,WORD PTR [si+6]
	add	ax,WORD PTR [bp-16]	;new_track
	mov	dx,WORD PTR [bp-14]
	mov	WORD PTR _snd_parse_cursor,ax
	mov	WORD PTR _snd_parse_cursor+2,dx
; Line 338
	mov	ax,WORD PTR [si+20]
	mov	dx,WORD PTR [si+22]
	jmp	SHORT C_SOUND_$L738
C_SOUND_$I536:
; Line 340
	mov	ax,WORD PTR [bp-16]	;new_track
	mov	dx,WORD PTR [bp-14]
	mov	WORD PTR _snd_parse_cursor,ax
	mov	WORD PTR _snd_parse_cursor+2,dx
; Line 341
	push	OFFSET _snd_parse_cursor
	call	_snd_101E
	add	sp,2
C_SOUND_$L738:
	mov	WORD PTR [bp-4],ax	;next
	mov	WORD PTR [bp-2],dx
; Line 343
C_SOUND_$FC539:
	mov	ax,WORD PTR [bp-8]	;target
	mov	dx,WORD PTR [bp-6]
	cmp	WORD PTR [bp-2],dx
	ja	C_SOUND_$FB540
	jb	C_SOUND_$L702
	cmp	WORD PTR [bp-4],ax	;next
	jae	C_SOUND_$FB540
C_SOUND_$L702:
; Line 344
	push	OFFSET _snd_parse_cursor
	call	_snd_1D6D
	add	sp,2
; Line 345
	mov	ax,WORD PTR _snd_parse_cursor+2
	or	ax,WORD PTR _snd_parse_cursor
	je	C_SOUND_$L700
; Line 349
	push	OFFSET _snd_parse_cursor
	call	_snd_101E
	add	sp,2
	add	WORD PTR [bp-4],ax	;next
	adc	WORD PTR [bp-2],dx
; Line 350
	jmp	SHORT C_SOUND_$FC539
	nop	
C_SOUND_$L700:
; Line 346
	dec	BYTE PTR _snd_parse_nesting
	jmp	C_SOUND_$L737
	nop	
; Line 350
C_SOUND_$FB540:
	mov	di,WORD PTR [bp+6]	;track
	mov	si,WORD PTR [bp+4]	;sequence
; Line 351
	push	WORD PTR [bp-14]
	push	WORD PTR [bp-16]	;new_track
	push	WORD PTR _snd_parse_cursor+2
	push	WORD PTR _snd_parse_cursor
	call	_snd_1041
	add	sp,8
	mov	WORD PTR [bp-12],ax	;offset
	mov	WORD PTR [bp-10],dx
; Line 352
	mov	bx,WORD PTR [si]
	push	WORD PTR [bx+4]
	call	_snd_2209
	add	sp,2
; Line 354
	mov	ax,WORD PTR [bp-4]	;next
	mov	dx,WORD PTR [bp-2]
	sub	ax,WORD PTR [bp-8]	;target
	sbb	dx,WORD PTR [bp-6]
	push	dx
	push	ax
	mov	ax,WORD PTR [bp-12]	;offset
	add	ax,WORD PTR [bp-16]	;new_track
	mov	dx,WORD PTR [bp-14]
	push	dx
	push	ax
	mov	ax,WORD PTR [si+6]
	add	ax,WORD PTR [bp-20]	;old_track
	mov	dx,WORD PTR [bp-18]
	push	dx
	push	ax
	push	si
	call	_snd_12D8
	add	sp,14	;000eH
; Line 355
	mov	ax,WORD PTR [bp+8]	;beat
	mov	WORD PTR [si+12],ax
; Line 356
	mov	ax,WORD PTR [bp+10]	;tick
	mov	WORD PTR [si+14],ax
; Line 357
	mov	ax,WORD PTR [bp-8]	;target
	mov	dx,WORD PTR [bp-6]
	mov	WORD PTR [si+16],ax
	mov	WORD PTR [si+18],dx
; Line 358
	mov	ax,WORD PTR [bp-4]	;next
	mov	dx,WORD PTR [bp-2]
	mov	WORD PTR [si+20],ax
	mov	WORD PTR [si+22],dx
; Line 359
	sub	ax,ax
	mov	WORD PTR [si+26],ax
	mov	WORD PTR [si+24],ax
; Line 360
	mov	ax,WORD PTR [bp-12]	;offset
	mov	dx,WORD PTR [bp-10]
	mov	WORD PTR [si+6],ax
	mov	WORD PTR [si+8],dx
; Line 361
	cmp	WORD PTR [si+10],di
	je	C_SOUND_$I542
; Line 362
	mov	WORD PTR [si+10],di
; Line 363
	mov	WORD PTR [si+42],0
; Line 365
C_SOUND_$I542:
	mov	BYTE PTR _snd_parse_finished,1
; Line 366
	dec	BYTE PTR _snd_parse_nesting
; Line 367
	xor	ax,ax
; Line 368
	pop	si
	pop	di
	leave	
	ret	

_snd_0857	ENDP

; compiler-C _snd_09F4 (original order 09F4)
PUBLIC _snd_09F4
_snd_09F4	PROC NEAR
; Line 370
	enter	16,0
	push	di
	push	si
;	sequence = 4
;	track = 6
;	beat = 8
;	tick = 10
;	track_data = -16
;	target = -8
;	next = -4
;	offset = -12
	mov	si,WORD PTR [bp+4]	;sequence
; Line 373
	cmp	BYTE PTR [si+2],0
	jne	C_SOUND_$I556
C_SOUND_$L739:
	mov	ax,-1	;ffffH
	pop	si
	pop	di
	leave	
	ret	
; Line 374
C_SOUND_$I556:
; Line 375
	push	WORD PTR [bp+6]	;track
	push	WORD PTR _snd_midi_tags+6
	push	WORD PTR _snd_midi_tags+4
	push	WORD PTR [si+4]
	call	_snd_0406
	add	sp,8
	mov	WORD PTR [bp-16],ax	;track_data
	mov	WORD PTR [bp-14],dx
	or	dx,ax
	je	C_SOUND_$L739
; Line 376
	inc	BYTE PTR _snd_parse_nesting
	mov	di,WORD PTR [bp+8]	;beat
; Line 377
	or	di,di
	jne	C_SOUND_$I558
	mov	di,1
; Line 378
C_SOUND_$I558:
	lea	ax,WORD PTR [di-1]
	mov	cx,480	;01e0H
	mul	cx
	add	ax,WORD PTR [bp+10]	;tick
	adc	dx,0
	mov	WORD PTR [bp-8],ax	;target
	mov	WORD PTR [bp-6],dx
; Line 379
	mov	bx,WORD PTR [bp+4]	;sequence
	mov	bx,WORD PTR [bx]
	push	WORD PTR [bx+4]
	call	_snd_21EF
	add	sp,2
; Line 380
	call	_snd_15DF
; Line 381
	mov	WORD PTR _snd_scanning,1
; Line 382
	mov	ax,WORD PTR [bp-16]	;track_data
	mov	dx,WORD PTR [bp-14]
	mov	WORD PTR _snd_parse_cursor,ax
	mov	WORD PTR _snd_parse_cursor+2,dx
; Line 383
	push	OFFSET _snd_parse_cursor
	call	_snd_101E
	add	sp,2
	mov	WORD PTR [bp-4],ax	;next
	mov	WORD PTR [bp-2],dx
	mov	WORD PTR [bp+8],di	;beat
; Line 384
C_SOUND_$FC560:
	mov	ax,WORD PTR [bp-8]	;target
	mov	dx,WORD PTR [bp-6]
	cmp	WORD PTR [bp-2],dx
	ja	C_SOUND_$FB561
	jb	C_SOUND_$L707
	cmp	WORD PTR [bp-4],ax	;next
	jae	C_SOUND_$FB561
C_SOUND_$L707:
; Line 385
	push	OFFSET _snd_parse_cursor
	mov	bx,WORD PTR [bp+4]	;sequence
	push	WORD PTR [bx]
	call	_snd_183E
	add	sp,4
; Line 386
	mov	ax,WORD PTR _snd_parse_cursor+2
	or	ax,WORD PTR _snd_parse_cursor
	je	C_SOUND_$L704
; Line 391
	push	OFFSET _snd_parse_cursor
	call	_snd_101E
	add	sp,2
	add	WORD PTR [bp-4],ax	;next
	adc	WORD PTR [bp-2],dx
; Line 392
	jmp	SHORT C_SOUND_$FC560
C_SOUND_$L704:
; Line 387
	dec	BYTE PTR _snd_parse_nesting
; Line 388
	mov	WORD PTR _snd_scanning,0
	jmp	C_SOUND_$L739
	nop	
; Line 392
C_SOUND_$FB561:
	mov	di,WORD PTR [bp+6]	;track
	mov	si,WORD PTR [bp+4]	;sequence
; Line 393
	push	WORD PTR [bp-14]
	push	WORD PTR [bp-16]	;track_data
	push	WORD PTR _snd_parse_cursor+2
	push	WORD PTR _snd_parse_cursor
	call	_snd_1041
	add	sp,8
	mov	WORD PTR [bp-12],ax	;offset
	mov	WORD PTR [bp-10],dx
; Line 394
	mov	WORD PTR _snd_scanning,0
; Line 395
	push	WORD PTR [si]
	call	_snd_162A
	add	sp,2
; Line 396
	mov	ax,WORD PTR [bp+8]	;beat
	mov	WORD PTR [si+12],ax
; Line 397
	mov	ax,WORD PTR [bp+10]	;tick
	mov	WORD PTR [si+14],ax
; Line 398
	mov	ax,WORD PTR [bp-8]	;target
	mov	dx,WORD PTR [bp-6]
	mov	WORD PTR [si+16],ax
	mov	WORD PTR [si+18],dx
; Line 399
	mov	ax,WORD PTR [bp-4]	;next
	mov	dx,WORD PTR [bp-2]
	mov	WORD PTR [si+20],ax
	mov	WORD PTR [si+22],dx
; Line 400
	sub	ax,ax
	mov	WORD PTR [si+26],ax
	mov	WORD PTR [si+24],ax
; Line 401
	mov	ax,WORD PTR [bp-12]	;offset
	mov	dx,WORD PTR [bp-10]
	mov	WORD PTR [si+6],ax
	mov	WORD PTR [si+8],dx
; Line 402
	cmp	WORD PTR [si+10],di
	je	C_SOUND_$I563
	mov	WORD PTR [si+10],di
; Line 403
C_SOUND_$I563:
	dec	BYTE PTR _snd_parse_nesting
; Line 404
	xor	ax,ax
; Line 405
	pop	si
	pop	di
	leave	
	ret	

_snd_09F4	ENDP

; compiler-C _snd_0B2E (original order 0B2E)
PUBLIC _snd_0B2E
_snd_0B2E	PROC NEAR
; Line 407
	push	bp
	mov	bp,sp
;	sequence = 4
;	count = 6
;	beat1 = 8
;	tick1 = 10
;	beat2 = 12
;	tick2 = 14
	mov	dx,WORD PTR [bp+8]	;beat1
	mov	cx,WORD PTR [bp+12]	;beat2
; Line 408
	mov	ax,dx
	inc	ax
	cmp	ax,cx
	jb	C_SOUND_$I577
	mov	ax,-1	;ffffH
	leave	
	ret	
	nop	
; Line 409
C_SOUND_$I577:
	or	dx,dx
	jne	C_SOUND_$I578
	inc	dx
; Line 410
C_SOUND_$I578:
	mov	bx,WORD PTR [bp+4]	;sequence
	mov	WORD PTR [bx+42],0
; Line 411
	mov	WORD PTR [bx+44],dx
; Line 412
	mov	ax,WORD PTR [bp+10]	;tick1
	mov	WORD PTR [bx+46],ax
; Line 413
	mov	WORD PTR [bx+48],cx
; Line 414
	mov	ax,WORD PTR [bp+14]	;tick2
	mov	WORD PTR [bx+50],ax
; Line 415
	mov	ax,WORD PTR [bp+6]	;count
	mov	WORD PTR [bx+42],ax
; Line 416
	xor	ax,ax
; Line 417
	leave	
	ret	
	nop	

_snd_0B2E	ENDP

; compiler-C _snd_0B6E (original order 0B6E)
PUBLIC _snd_0B6E
_snd_0B6E	PROC NEAR
; Line 418
	push	bp
	mov	bp,sp
;	sequence = 4
; Line 419
	mov	bx,WORD PTR [bp+4]	;sequence
	xor	ax,ax
	mov	WORD PTR [bx+42],ax
; Line 421
	leave	
	ret	
	nop	

_snd_0B6E	ENDP

; compiler-C _snd_0C3D (original order 0C3D)
PUBLIC _snd_0C3D
_snd_0C3D	PROC NEAR
; Line 426
	enter	4,0
	push	di
	push	si
;	player = 4
;	target = 6
;	duration = 8
;	fade = -4
;	register dx = count
;	difference = -2
;	quotient = -8
;	register di = remainder
	mov	si,WORD PTR [bp+4]	;player
; Line 429
	push	si
	call	_snd_1684
	add	sp,2
; Line 430
	cmp	WORD PTR [bp+8],0	;duration
	jne	C_SOUND_$I594
	mov	al,BYTE PTR [bp+6]	;target
	push	ax
	push	si
	call	_snd_075E
	add	sp,4
; Line 431
	jmp	SHORT C_SOUND_$I595
	nop	
C_SOUND_$I594:
; Line 432
	mov	BYTE PTR _snd_fade_state,1
; Line 433
	mov	cx,OFFSET _snd_fades
; Line 434
	mov	dx,2
	mov	si,cx
; Line 435
C_SOUND_$D596:
; Line 436
	cmp	BYTE PTR [si],0
	je	C_SOUND_$DB598
; Line 437
	add	si,16	;0010H
; Line 438
	dec	dx
	jne	C_SOUND_$D596
C_SOUND_$DB598:
; Line 439
	or	dx,dx
	jne	C_SOUND_$I600
	mov	ax,-1	;ffffH
	pop	si
	pop	di
	leave	
	ret	
	nop	
; Line 440
C_SOUND_$I600:
	mov	ax,WORD PTR [bp+4]	;player
	mov	WORD PTR [si+2],ax
; Line 441
	mov	cx,WORD PTR [bp+8]	;duration
	mov	WORD PTR [si+6],cx
	mov	WORD PTR [si+8],cx
; Line 442
	mov	BYTE PTR [si],1
; Line 443
	push	1
	push	ax
	call	_snd_066B
	add	sp,4
	mov	BYTE PTR [si+4],al
; Line 444
	mov	al,BYTE PTR [bp+6]	;target
	sub	ah,ah
	mov	cl,BYTE PTR [si+4]
	sub	ch,ch
	sub	ax,cx
	mov	WORD PTR [bp-2],ax	;difference
; Line 446
	mov	cx,ax
	cwd	
	idiv	WORD PTR [bp+8]	;duration
	mov	di,dx
; Line 447
	mov	ax,cx
	cwd	
	idiv	WORD PTR [bp+8]	;duration
	mov	BYTE PTR [si+10],al
; Line 448
	mov	BYTE PTR [si+11],1
; Line 449
	cmp	WORD PTR [bp-2],0	;difference
	jge	C_SOUND_$I601
; Line 450
	neg	di
; Line 451
	mov	BYTE PTR [si+11],255	;00ffH
; Line 453
C_SOUND_$I601:
	mov	ax,di
	mov	BYTE PTR [si+12],al
; Line 454
	mov	WORD PTR [si+14],0
; Line 455
C_SOUND_$I595:
; Line 456
	xor	ax,ax
; Line 457
	pop	si
	pop	di
	leave	
	ret	

_snd_0C3D	ENDP

; compiler-C _snd_0CC3 (original order 0CC3)
PUBLIC _snd_0CC3
_snd_0CC3	PROC NEAR
; Line 458
	push	bp
	mov	bp,sp
;	sound = 4
;	marker = 6
;	register dx = write
	mov	cx,WORD PTR [bp+4]	;sound
; Line 460
	mov	bx,WORD PTR _snd_queue_write
	shl	bx,4
	mov	WORD PTR _snd_queue[bx],0
; Line 461
	mov	WORD PTR _snd_queue[bx+2],cx
; Line 462
	mov	al,BYTE PTR [bp+6]	;marker
	sub	ah,ah
	mov	WORD PTR _snd_queue[bx+4],ax
; Line 463
	mov	dx,WORD PTR _snd_queue_write
	inc	dx
	cmp	dx,64	;0040H
	jl	C_SOUND_$I608
	xor	dx,dx
; Line 464
C_SOUND_$I608:
	cmp	WORD PTR _snd_queue_read,dx
	jne	C_SOUND_$I609
; Line 465
	dec	dx
	mov	WORD PTR _snd_queue_write,dx
; Line 466
	or	dx,dx
	jge	C_SOUND_$I610
	mov	WORD PTR _snd_queue_write,63	;003fH
; Line 467
C_SOUND_$I610:
	mov	ax,-1	;ffffH
	leave	
	ret	
; Line 469
C_SOUND_$I609:
	mov	WORD PTR _snd_queue_write,dx
; Line 470
	mov	WORD PTR _snd_queued_sound,cx
; Line 471
	mov	al,BYTE PTR [bp+6]	;marker
	mov	BYTE PTR _snd_queued_marker,al
; Line 472
	mov	BYTE PTR _snd_building_queue,1
; Line 473
	xor	ax,ax
; Line 474
	leave	
	ret	
	nop	

_snd_0CC3	ENDP

; compiler-C _snd_0D1F (original order 0D1F)
PUBLIC _snd_0D1F
_snd_0D1F	PROC NEAR
; Line 475
	push	bp
	mov	bp,sp
	push	si
;	command = 4
;	a = 6
;	b = 8
;	c = 10
;	d = 12
;	e = 14
;	f = 16
;	register bx = write
; Line 477
	mov	bx,WORD PTR _snd_queue_write
	cmp	bx,WORD PTR _snd_queue_read
	jne	C_SOUND_$I627
C_SOUND_$L740:
	mov	ax,-1	;ffffH
	pop	si
	leave	
	ret	
; Line 478
C_SOUND_$I627:
	mov	dx,WORD PTR [bp+4]	;command
	cmp	dx,-1	;ffffH
	jne	C_SOUND_$I628
; Line 479
	mov	BYTE PTR _snd_building_queue,0
; Line 480
	inc	WORD PTR _snd_trigger_count
; Line 481
	jmp	SHORT C_SOUND_$I629
	nop	
C_SOUND_$I628:
; Line 482
	mov	si,bx
	shl	si,4
	mov	WORD PTR _snd_queue[si],1
; Line 483
	mov	WORD PTR _snd_queue[si+2],dx
; Line 484
	mov	ax,WORD PTR [bp+6]	;a
	mov	WORD PTR _snd_queue[si+4],ax
; Line 485
	mov	ax,WORD PTR [bp+8]	;b
	mov	WORD PTR _snd_queue[si+6],ax
; Line 486
	mov	ax,WORD PTR [bp+10]	;c
	mov	WORD PTR _snd_queue[si+8],ax
; Line 487
	mov	ax,WORD PTR [bp+12]	;d
	mov	WORD PTR _snd_queue[si+10],ax
; Line 488
	mov	ax,WORD PTR [bp+14]	;e
	mov	WORD PTR _snd_queue[si+12],ax
; Line 489
	mov	ax,WORD PTR [bp+16]	;f
	mov	WORD PTR _snd_queue[si+14],ax
; Line 490
	inc	bx
	cmp	bx,64	;0040H
	jl	C_SOUND_$I630
	xor	bx,bx
; Line 491
C_SOUND_$I630:
	cmp	WORD PTR _snd_queue_read,bx
	jne	C_SOUND_$I631
; Line 492
	lea	ax,WORD PTR [bx-1]
	mov	WORD PTR _snd_queue_write,ax
; Line 493
	or	ax,ax
	jge	C_SOUND_$L740
	mov	WORD PTR _snd_queue_write,63	;003fH
; Line 494
	jmp	SHORT C_SOUND_$L740
	nop	
; Line 496
C_SOUND_$I631:
	mov	WORD PTR _snd_queue_write,bx
; Line 497
C_SOUND_$I629:
; Line 498
	xor	ax,ax
; Line 499
	pop	si
	leave	
	ret	
	nop	

_snd_0D1F	ENDP

; compiler-C _snd_0DA8 (original order 0DA8)
PUBLIC _snd_0DA8
_snd_0DA8	PROC NEAR
; Line 500
; Line 501
	mov	BYTE PTR _snd_building_queue,0
; Line 504
	xor	ax,ax
	mov	WORD PTR _snd_trigger_count,ax
; Line 505
	mov	WORD PTR _snd_queue_write,ax
	mov	WORD PTR _snd_queue_read,ax
; Line 506
	ret	
	nop	

_snd_0DA8	ENDP

; compiler-C _snd_0DB9 (original order 0DB9)
PUBLIC _snd_0DB9
_snd_0DB9	PROC NEAR
; Line 12
	enter	4,0
	push	di
	push	si
;	seq = 4
;	sound = 6
;	base = -4
	mov	di,WORD PTR [bp+6]	;sound
	mov	si,WORD PTR [bp+4]	;seq
; Line 14
	mov	WORD PTR [si+4],di
; Line 15
	mov	WORD PTR [si+10],0
; Line 16
	sub	ax,ax
	mov	WORD PTR [si+26],ax
	mov	WORD PTR [si+24],ax
; Line 18
	mov	WORD PTR [si+42],ax
	mov	WORD PTR [si+46],ax
; Line 19
	mov	WORD PTR [si+50],ax
; Line 21
	mov	ax,1
	mov	WORD PTR [si+44],ax
	mov	WORD PTR [si+48],ax
; Line 22
	push	7
	push	-24288	;a120H
	push	si
	call	_snd_0FBE
	add	sp,6
; Line 23
	push	128	;0080H
	push	si
	call	_snd_0814
	add	sp,4
; Line 24
	push	WORD PTR [si+10]
	push	WORD PTR _snd_midi_tags+6
	push	WORD PTR _snd_midi_tags+4
	push	di
	call	_snd_0406
	add	sp,8
	mov	WORD PTR _snd_parse_cursor,ax
	mov	WORD PTR _snd_parse_cursor+2,dx
; Line 25
	mov	ax,dx
	or	ax,WORD PTR _snd_parse_cursor
	jne	C_MIDISND_$I200
	xor	ax,ax
	pop	si
	pop	di
	leave	
	ret	
	nop	
; Line 26
C_MIDISND_$I200:
	mov	ax,WORD PTR _snd_parse_cursor
	mov	di,ax
	mov	WORD PTR [bp-2],dx
; Line 27
	push	OFFSET _snd_parse_cursor
	call	_snd_101E
	add	sp,2
	mov	WORD PTR [si+20],ax
	mov	WORD PTR [si+22],dx
	mov	ax,WORD PTR [si+20]
	mov	WORD PTR [si+16],ax
	mov	WORD PTR [si+18],dx
; Line 28
	push	WORD PTR [bp-2]
	push	di
	push	WORD PTR _snd_parse_cursor+2
	push	WORD PTR _snd_parse_cursor
	call	_snd_1041
	add	sp,8
	mov	WORD PTR [si+6],ax
	mov	WORD PTR [si+8],dx
; Line 29
	mov	ax,WORD PTR [si+20]
	mov	cx,480	;01e0H
	sub	dx,dx
	div	cx
	inc	ax
	mov	WORD PTR [si+12],ax
; Line 30
	mov	ax,WORD PTR [si+20]
	sub	dx,dx
	div	cx
	mov	WORD PTR [si+14],dx
; Line 31
	mov	ax,1
	mov	BYTE PTR [si+2],al
; Line 32
	pop	si
	pop	di
	leave	
	ret	

_snd_0DB9	ENDP

; compiler-C _snd_0E6A (original order 0E6A)
PUBLIC _snd_0E6A
_snd_0E6A	PROC NEAR
; Line 35
	push	bp
	mov	bp,sp
;	seq = 4
; Line 36
	mov	bx,WORD PTR [bp+4]	;seq
	mov	BYTE PTR [bx+2],0
; Line 37
	mov	BYTE PTR _snd_parse_finished,1
; Line 38
	leave	
	ret	
	nop	

_snd_0E6A	ENDP

; compiler-C _snd_0E7C (original order 0E7C)
PUBLIC _snd_0E7C
_snd_0E7C	PROC NEAR
; Line 41
	enter	8,0
	push	di
	push	si
;	base = -6
;	seq = -2
;	count = -8
; Line 45
	cmp	BYTE PTR _snd_parse_nesting,0
	je	C_MIDISND_$JCC227
	jmp	C_MIDISND_$EX204
C_MIDISND_$JCC227:
; Line 46
	mov	si,OFFSET _snd_sequences
; Line 47
	mov	WORD PTR [bp-8],2	;count
; Line 48
C_MIDISND_$D209:
; Line 49
	cmp	BYTE PTR [si+2],1
	je	C_MIDISND_$JCC244
	jmp	C_MIDISND_$next_sequence222
C_MIDISND_$JCC244:
; Line 50
	mov	ax,WORD PTR [si+38]
	mov	dx,WORD PTR [si+40]
	add	WORD PTR [si+24],ax
	adc	WORD PTR [si+26],dx
; Line 51
	mov	ax,WORD PTR [si+26]
	sub	dx,dx
	add	WORD PTR [si+16],ax
	adc	WORD PTR [si+18],dx
; Line 52
	mov	ax,WORD PTR [si+26]
	add	WORD PTR [si+14],ax
; Line 53
	mov	WORD PTR [si+26],dx
; Line 54
	cmp	WORD PTR [si+14],480	;01e0H
	jb	C_MIDISND_$I213
; Line 55
	mov	ax,WORD PTR [si+14]
	mov	cx,480	;01e0H
	div	cx
	add	WORD PTR [si+12],ax
; Line 56
	mov	ax,WORD PTR [si+14]
	sub	dx,dx
	div	cx
	mov	WORD PTR [si+14],dx
; Line 58
C_MIDISND_$I213:
; Line 59
	cmp	WORD PTR [si+42],0
	je	C_MIDISND_$I214
	mov	ax,WORD PTR [si+48]
	cmp	WORD PTR [si+12],ax
	jb	C_MIDISND_$I214
	mov	ax,WORD PTR [si+14]
	cmp	WORD PTR [si+50],ax
	ja	C_MIDISND_$I214
; Line 60
	dec	WORD PTR [si+42]
; Line 61
	push	WORD PTR [si+46]
	push	WORD PTR [si+44]
	push	WORD PTR [si+10]
	push	si
	call	_snd_0857
	add	sp,8
; Line 63
C_MIDISND_$I214:
	mov	ax,WORD PTR [si+20]
	mov	dx,WORD PTR [si+22]
	cmp	WORD PTR [si+18],dx
	jae	C_MIDISND_$JCC359
	jmp	C_MIDISND_$next_sequence222
C_MIDISND_$JCC359:
	ja	C_MIDISND_$L476
	cmp	WORD PTR [si+16],ax
	jae	C_MIDISND_$JCC369
	jmp	C_MIDISND_$next_sequence222
C_MIDISND_$JCC369:
C_MIDISND_$L476:
; Line 65
	push	WORD PTR [si+10]
	push	WORD PTR _snd_midi_tags+6
	push	WORD PTR _snd_midi_tags+4
	push	WORD PTR [si+4]
	call	_snd_0406
	add	sp,8
	mov	di,ax
	mov	WORD PTR [bp-4],dx
	or	dx,ax
	jne	C_MIDISND_$I216
	push	WORD PTR [si]
	call	_snd_0643
	add	sp,2
; Line 66
C_MIDISND_$I216:
	mov	ax,WORD PTR [si+6]
	add	ax,di
	mov	cx,WORD PTR [bp-4]
	mov	WORD PTR _snd_parse_cursor,ax
	mov	WORD PTR _snd_parse_cursor+2,cx
; Line 67
	mov	BYTE PTR _snd_parse_finished,0
	mov	WORD PTR [bp-2],si	;seq
; Line 68
C_MIDISND_$FC218:
	mov	bx,WORD PTR [bp-2]	;seq
	mov	ax,WORD PTR [bx+20]
	mov	dx,WORD PTR [bx+22]
	cmp	WORD PTR [bx+18],dx
	jb	C_MIDISND_$FB219
	ja	C_MIDISND_$L479
	cmp	WORD PTR [bx+16],ax
	jb	C_MIDISND_$FB219
C_MIDISND_$L479:
; Line 69
	push	OFFSET _snd_parse_cursor
	push	WORD PTR [bx]
	call	_snd_183E
	add	sp,4
; Line 70
	mov	ax,WORD PTR _snd_parse_cursor+2
	or	ax,WORD PTR _snd_parse_cursor
	je	C_MIDISND_$L466
	cmp	BYTE PTR _snd_parse_finished,0
	jne	C_MIDISND_$L466
; Line 71
	push	OFFSET _snd_parse_cursor
	call	_snd_101E
	add	sp,2
	mov	bx,WORD PTR [bp-2]	;seq
	add	WORD PTR [bx+20],ax
	adc	WORD PTR [bx+22],dx
; Line 72
	jmp	SHORT C_MIDISND_$FC218
C_MIDISND_$L466:
	mov	si,WORD PTR [bp-2]	;seq
	jmp	SHORT C_MIDISND_$next_sequence222
	nop	
C_MIDISND_$FB219:
; Line 73
	mov	ax,WORD PTR _snd_parse_cursor+2
	or	ax,WORD PTR _snd_parse_cursor
	je	C_MIDISND_$L466
	mov	si,bx
	cmp	BYTE PTR _snd_parse_finished,0
	jne	C_MIDISND_$next_sequence222
; Line 74
	push	WORD PTR [bp-4]
	push	di
	push	WORD PTR _snd_parse_cursor+2
	push	WORD PTR _snd_parse_cursor
	call	_snd_1041
	add	sp,8
	mov	WORD PTR [si+6],ax
	mov	WORD PTR [si+8],dx
; Line 77
C_MIDISND_$next_sequence222:
; Line 78
	add	si,52	;0034H
; Line 79
	dec	WORD PTR [bp-8]	;count
	je	C_MIDISND_$JCC556
	jmp	C_MIDISND_$D209
C_MIDISND_$JCC556:
; Line 80
C_MIDISND_$EX204:
	pop	si
	pop	di
	leave	
	ret	
	nop	

_snd_0E7C	ENDP

; compiler-C _snd_0FBE (original order 0FBE)
PUBLIC _snd_0FBE
_snd_0FBE	PROC NEAR
; Line 83
	push	bp
	mov	bp,sp
	push	si
;	seq = 4
;	tempo = 6
	mov	si,WORD PTR [bp+4]	;seq
; Line 84
	mov	ax,WORD PTR [bp+6]	;tempo
	mov	dx,WORD PTR [bp+8]
	mov	WORD PTR [si+28],ax
	mov	WORD PTR [si+30],dx
; Line 85
	shr	dx,1
	rcr	ax,1
	shr	dx,1
	rcr	ax,1
	shr	dx,1
	rcr	ax,1
	shr	dx,1
	rcr	ax,1
	shr	dx,1
	rcr	ax,1
	shr	dx,1
	rcr	ax,1
	push	0
	push	ax
	mov	ax,WORD PTR _snd_tick_period
	mov	dx,WORD PTR _snd_tick_period+2
	mov	dh,dl
	mov	dl,ah
	mov	ah,al
	sub	al,al
	shl	ax,1
	rcl	dx,1
	shl	ax,1
	rcl	dx,1
	push	dx
	push	ax
	call	FAR PTR __aFuldiv
	mov	WORD PTR [si+32],ax
	mov	WORD PTR [si+34],dx
; Line 86
	mov	al,BYTE PTR [si+36]
	push	ax
	push	si
	call	_snd_0814
	add	sp,4
; Line 87
	pop	si
	leave	
	ret	

_snd_0FBE	ENDP

; register-ABI-ASM MR101E (original order 101E)
public _snd_101E
_snd_101E label near
    enter 0, 0 ; 101E
    push si ; 1022
    mov bx, word ptr [bp + 4] ; 1023
    les si, dword ptr [bx] ; 1026
    cld ; 1028
    xor ax, ax ; 1029
    cwd ; 102B
A_MR101E_midi_102C:
    mov dh, dl ; 102C
    mov dl, ah ; 102E
    mov ah, al ; 1030
    lods byte ptr es:[si] ; 1032
    rol al, 1 ; 1034
    shr dx, 1 ; 1036
    rcr ax, 1 ; 1038
    jb short A_MR101E_midi_102C ; 103A
    mov word ptr [bx], si ; 103C
    pop si ; 103E
    leave ; 103F
    ret ; 1040

; compiler-C _snd_1041 (original order 1041)
PUBLIC _snd_1041
_snd_1041	PROC NEAR
; Line 92
	push	bp
	mov	bp,sp
;	a = 4
;	b = 8
;	distance = -4
; Line 96
	mov	ax,WORD PTR [bp+6]
	sub	dx,dx
	sub	ax,WORD PTR [bp+10]
	sbb	dx,dx
	shl	ax,1
	rcl	dx,1
	shl	ax,1
	rcl	dx,1
	shl	ax,1
	rcl	dx,1
	shl	ax,1
	rcl	dx,1
	sub	ax,WORD PTR [bp+8]	;b
	sbb	dx,0
	add	ax,WORD PTR [bp+4]	;a
	adc	dx,0
	jns	C_MIDISND_$L481
	neg	ax
	adc	dx,0
	neg	dx
C_MIDISND_$L481:
; Line 97
	leave	
	ret	

_snd_1041	ENDP

; compiler-C _snd_1086 (original order 1086)
PUBLIC _snd_1086
_snd_1086	PROC NEAR
; Line 100
	push	bp
	mov	bp,sp
	push	di
;	hooks = 4
; Line 101
	xor	ax,ax
	mov	cx,66	;0042H
	push	ds
	pop	es
	mov	di,WORD PTR [bp+4]	;hooks
	rep	stosb
; Line 102
	pop	di
	leave	
	ret	
	nop	

_snd_1086	ENDP

; compiler-C _snd_109C (original order 109C)
PUBLIC _snd_109C
_snd_109C	PROC NEAR
; Line 105
	push	bp
	mov	bp,sp
	push	di
	push	si
;	player = 4
;	data = 6
	mov	si,WORD PTR [bp+6]	;data
	mov	di,WORD PTR [bp+4]	;player
; Line 106
	cmp	BYTE PTR [si],0
	je	C_MIDISND_$I243
; Line 107
	mov	al,BYTE PTR [si]
	mov	bx,WORD PTR [di+2]
	cmp	BYTE PTR [bx],al
	jne	C_MIDISND_$EX242
; Line 108
	mov	BYTE PTR [bx],0
; Line 110
C_MIDISND_$I243:
	lea	ax,WORD PTR [si+5]
	push	ax
	call	_snd_04CC
	add	sp,2
	push	ax
	lea	ax,WORD PTR [si+3]
	push	ax
	call	_snd_04CC
	add	sp,2
	push	ax
	lea	ax,WORD PTR [si+1]
	push	ax
	call	_snd_04CC
	add	sp,2
	push	ax
	push	WORD PTR [di]
	call	_snd_0857
	add	sp,8
; Line 111
C_MIDISND_$EX242:
	pop	si
	pop	di
	leave	
	ret	
	nop	

_snd_109C	ENDP

; compiler-C _snd_10E7 (original order 10E7)
PUBLIC _snd_10E7
_snd_10E7	PROC NEAR
; Line 114
	push	bp
	mov	bp,sp
	push	di
	push	si
;	player = 4
;	data = 6
	mov	si,WORD PTR [bp+6]	;data
	mov	di,WORD PTR [bp+4]	;player
; Line 115
	cmp	BYTE PTR [si],0
	je	C_MIDISND_$I250
; Line 116
	mov	al,BYTE PTR [si]
	mov	bx,WORD PTR [di+2]
	cmp	BYTE PTR [bx+1],al
	jne	C_MIDISND_$EX249
; Line 117
	mov	BYTE PTR [bx+1],0
; Line 119
C_MIDISND_$I250:
	mov	al,BYTE PTR [si+2]
	push	ax
	mov	al,BYTE PTR [si+1]
	push	ax
	push	di
	call	_snd_07AA
	add	sp,6
; Line 120
C_MIDISND_$EX249:
	pop	si
	pop	di
	leave	
	ret	
	nop	

_snd_10E7	ENDP

; compiler-C _snd_1118 (original order 1118)
PUBLIC _snd_1118
_snd_1118	PROC NEAR
; Line 123
	enter	2,0
	push	di
	push	si
;	channel = -1
;	register di = hooks
;	player = 4
;	data = 6
	mov	dx,WORD PTR [bp+4]	;player
	mov	si,WORD PTR [bp+6]	;data
; Line 124
	mov	al,BYTE PTR [si]
	mov	BYTE PTR [bp-1],al	;channel
; Line 125
	sub	ah,ah
	mov	di,ax
	mov	bx,dx
	add	di,WORD PTR [bx+2]
; Line 126
	cmp	BYTE PTR [si+1],ah
	je	C_MIDISND_$I259
; Line 127
	mov	al,BYTE PTR [di+2]
	cmp	BYTE PTR [si+1],al
	jne	C_MIDISND_$EX256
; Line 128
	mov	BYTE PTR [di+2],ah
; Line 130
C_MIDISND_$I259:
	mov	al,BYTE PTR [si+2]
	push	ax
	mov	al,BYTE PTR [bp-1]	;channel
	push	ax
	push	dx
	call	_snd_2509
	add	sp,6
; Line 131
C_MIDISND_$EX256:
	pop	si
	pop	di
	leave	
	ret	
	nop	

_snd_1118	ENDP

; compiler-C _snd_114D (original order 114D)
PUBLIC _snd_114D
_snd_114D	PROC NEAR
; Line 134
	enter	2,0
	push	di
	push	si
;	player = 4
;	data = 6
;	channel = -1
;	register di = hooks
	mov	dx,WORD PTR [bp+4]	;player
	mov	si,WORD PTR [bp+6]	;data
; Line 135
	mov	al,BYTE PTR [si]
	mov	BYTE PTR [bp-1],al	;channel
; Line 136
	sub	ah,ah
	mov	di,ax
	mov	bx,dx
	add	di,WORD PTR [bx+2]
; Line 137
	cmp	BYTE PTR [si+1],ah
	je	C_MIDISND_$I268
; Line 138
	mov	al,BYTE PTR [di+18]
	cmp	BYTE PTR [si+1],al
	jne	C_MIDISND_$EX265
; Line 139
	mov	BYTE PTR [di+18],ah
; Line 141
C_MIDISND_$I268:
	mov	al,BYTE PTR [si+2]
	push	ax
	mov	al,BYTE PTR [bp-1]	;channel
	push	ax
	push	dx
	call	_snd_235A
	add	sp,6
; Line 142
C_MIDISND_$EX265:
	pop	si
	pop	di
	leave	
	ret	
	nop	

_snd_114D	ENDP

; compiler-C _snd_1182 (original order 1182)
PUBLIC _snd_1182
_snd_1182	PROC NEAR
; Line 145
	enter	2,0
	push	di
	push	si
;	player = 4
;	data = 6
;	channel = -1
;	register di = hooks
	mov	dx,WORD PTR [bp+4]	;player
	mov	si,WORD PTR [bp+6]	;data
; Line 146
	mov	al,BYTE PTR [si]
	mov	BYTE PTR [bp-1],al	;channel
; Line 147
	sub	ah,ah
	mov	di,ax
	mov	bx,dx
	add	di,WORD PTR [bx+2]
; Line 148
	cmp	BYTE PTR [si+1],ah
	je	C_MIDISND_$I277
; Line 149
	mov	al,BYTE PTR [di+34]
	cmp	BYTE PTR [si+1],al
	jne	C_MIDISND_$EX274
; Line 150
	mov	BYTE PTR [di+34],ah
; Line 152
C_MIDISND_$I277:
	mov	al,BYTE PTR [si+2]
	push	ax
	mov	al,BYTE PTR [bp-1]	;channel
	push	ax
	push	dx
	call	_snd_2277
	add	sp,6
; Line 153
C_MIDISND_$EX274:
	pop	si
	pop	di
	leave	
	ret	
	nop	

_snd_1182	ENDP

; compiler-C _snd_11B7 (original order 11B7)
PUBLIC _snd_11B7
_snd_11B7	PROC NEAR
; Line 156
	enter	2,0
	push	di
	push	si
;	player = 4
;	data = 6
;	channel = -1
;	register di = hooks
	mov	dx,WORD PTR [bp+4]	;player
	mov	si,WORD PTR [bp+6]	;data
; Line 157
	mov	al,BYTE PTR [si]
	mov	BYTE PTR [bp-1],al	;channel
; Line 158
	sub	ah,ah
	mov	di,ax
	mov	bx,dx
	add	di,WORD PTR [bx+2]
; Line 159
	cmp	BYTE PTR [si+1],ah
	je	C_MIDISND_$I286
; Line 160
	mov	al,BYTE PTR [si+1]
	cmp	BYTE PTR [di+50],al
	jne	C_MIDISND_$EX283
; Line 161
	mov	BYTE PTR [di+50],ah
; Line 163
C_MIDISND_$I286:
	mov	al,BYTE PTR [si+3]
	push	ax
	mov	al,BYTE PTR [si+2]
	push	ax
	mov	al,BYTE PTR [bp-1]	;channel
	push	ax
	push	dx
	call	_snd_23D2
	add	sp,8
; Line 164
C_MIDISND_$EX283:
	pop	si
	pop	di
	leave	
	ret	
	nop	

_snd_11B7	ENDP

; compiler-C _snd_11F0 (original order 11F0)
PUBLIC _snd_11F0
_snd_11F0	PROC NEAR
; Line 167
	push	bp
	mov	bp,sp
	push	si
;	hooks = 4
;	kind = 6
;	channel = 8
; Line 168
	mov	al,BYTE PTR [bp+6]	;kind
	sub	ah,ah
; Line 176
	sub	ax,18	;0012H
	cmp	ax,5
	ja	C_MIDISND_$SD305
	shl	ax,1
	xchg	ax,bx
	jmp	WORD PTR cs:C_MIDISND_$L482[bx]
	nop	
C_MIDISND_$L482:
		DW	C_MIDISND_$SC299
		DW	C_MIDISND_$SC300
		DW	C_MIDISND_$SC301
		DW	C_MIDISND_$SC302
		DW	C_MIDISND_$SC303
		DW	C_MIDISND_$SC304
; Line 175
C_MIDISND_$SD305:
	mov	ax,-1	;ffffH
	pop	si
	leave	
	ret	
; Line 169
C_MIDISND_$SC299:
	mov	bx,WORD PTR [bp+4]	;hooks
	mov	al,BYTE PTR [bx]
	jmp	SHORT C_MIDISND_$L504
	nop	
; Line 170
C_MIDISND_$SC300:
	mov	bx,WORD PTR [bp+4]	;hooks
	mov	al,BYTE PTR [bx+1]
	jmp	SHORT C_MIDISND_$L504
; Line 171
C_MIDISND_$SC301:
	mov	si,WORD PTR [bp+8]	;channel
	and	si,255	;00ffH
	mov	bx,WORD PTR [bp+4]	;hooks
	mov	al,BYTE PTR [bx+2][si]
	jmp	SHORT C_MIDISND_$L504
	nop	
; Line 172
C_MIDISND_$SC302:
	mov	si,WORD PTR [bp+8]	;channel
	and	si,255	;00ffH
	mov	bx,WORD PTR [bp+4]	;hooks
	mov	al,BYTE PTR [bx+18][si]
	jmp	SHORT C_MIDISND_$L504
	nop	
; Line 173
C_MIDISND_$SC303:
	mov	si,WORD PTR [bp+8]	;channel
	and	si,255	;00ffH
	mov	bx,WORD PTR [bp+4]	;hooks
	mov	al,BYTE PTR [bx+34][si]
	jmp	SHORT C_MIDISND_$L504
	nop	
; Line 174
C_MIDISND_$SC304:
	mov	si,WORD PTR [bp+8]	;channel
	and	si,255	;00ffH
	mov	bx,WORD PTR [bp+4]	;hooks
	mov	al,BYTE PTR [bx+50][si]
C_MIDISND_$L504:
	sub	ah,ah
; Line 177
	pop	si
	leave	
	ret	

_snd_11F0	ENDP

; compiler-C _snd_1263 (original order 1263)
PUBLIC _snd_1263
_snd_1263	PROC NEAR
; Line 180
	enter	2,0
	push	di
	push	si
;	register si = note
;	next = -2
;	register di = seq
; Line 183
	mov	si,WORD PTR _snd_held_active
; Line 184
	jmp	SHORT C_MIDISND_$L505
	nop	
	nop	
C_MIDISND_$FC311:
; Line 185
	mov	ax,WORD PTR [si+2]
	mov	WORD PTR [bp-2],ax	;next
; Line 186
	mov	bx,WORD PTR [si+6]
	mov	di,bx
; Line 187
	mov	ax,WORD PTR [bx+38]
	mov	dx,WORD PTR [bx+40]
	add	WORD PTR [si+16],ax
	adc	WORD PTR [si+18],dx
; Line 188
	mov	ax,WORD PTR [si+18]
	sub	dx,dx
	add	WORD PTR [si+12],ax
	adc	WORD PTR [si+14],dx
; Line 189
	mov	WORD PTR [si+18],dx
; Line 190
	mov	ax,WORD PTR [si+12]
	mov	dx,WORD PTR [si+14]
	cmp	WORD PTR [si+10],dx
	ja	C_MIDISND_$I313
	jb	C_MIDISND_$L484
	cmp	WORD PTR [si+8],ax
	ja	C_MIDISND_$I313
C_MIDISND_$L484:
; Line 191
	mov	al,BYTE PTR [si+4]
	push	ax
	mov	al,BYTE PTR [si+5]
	push	ax
	push	WORD PTR [di]
	call	_snd_21A2
	add	sp,6
; Line 192
	cmp	WORD PTR [bp-2],0	;next
	je	C_MIDISND_$I314
	mov	ax,WORD PTR [si]
	mov	bx,WORD PTR [bp-2]	;next
	mov	WORD PTR [bx],ax
; Line 193
C_MIDISND_$I314:
	cmp	WORD PTR [si],0
	je	C_MIDISND_$I315
	mov	ax,WORD PTR [bp-2]	;next
	mov	bx,WORD PTR [si]
	mov	WORD PTR [bx+2],ax
; Line 194
	jmp	SHORT C_MIDISND_$I316
	nop	
C_MIDISND_$I315:
	mov	ax,WORD PTR [bp-2]	;next
	mov	WORD PTR _snd_held_active,ax
C_MIDISND_$I316:
; Line 195
	mov	ax,WORD PTR _snd_held_free
	mov	WORD PTR [si+2],ax
; Line 196
	mov	WORD PTR _snd_held_free,si
; Line 198
C_MIDISND_$I313:
	mov	si,WORD PTR [bp-2]	;next
; Line 199
C_MIDISND_$L505:
	or	si,si
	jne	C_MIDISND_$FC311
; Line 200
	pop	si
	pop	di
	leave	
	ret	
	nop	

_snd_1263	ENDP

; compiler-C _snd_12D8 (original order 12D8)
PUBLIC _snd_12D8
_snd_12D8	PROC NEAR
; Line 203
	enter	8,0
	push	di
	push	si
;	from = 6
;	to = 10
;	delta = 14
;	time = -8
;	mask = -4
;	bits = -2
;	register si = note
;	register dx = next
;	register bx = tail
;	seq = 4
	mov	di,WORD PTR [bp+4]	;seq
; Line 207
	call	_snd_15DF
; Line 208
	mov	WORD PTR _snd_scan_note_count,0
; Line 209
	push	OFFSET _snd_scan_note_count
	push	OFFSET _snd_note_channels
	mov	bx,WORD PTR [di]
	push	WORD PTR [bx+4]
	call	_snd_222F
	add	sp,6
; Line 210
	mov	ax,WORD PTR [bp+6]	;from
	mov	dx,WORD PTR [bp+8]
	mov	WORD PTR _snd_parse_cursor,ax
	mov	WORD PTR _snd_parse_cursor+2,dx
; Line 211
	mov	ax,WORD PTR [di+20]
	mov	dx,WORD PTR [di+22]
	sub	ax,WORD PTR [di+16]
	sbb	dx,WORD PTR [di+18]
	mov	WORD PTR [bp-8],ax	;time
	mov	WORD PTR [bp-6],dx
; Line 212
	or	dx,dx
	jl	C_MIDISND_$JCC1446
	jmp	C_MIDISND_$L506
C_MIDISND_$JCC1446:
	sub	ax,ax
	mov	WORD PTR [bp-6],ax
	mov	WORD PTR [bp-8],ax	;time
; Line 213
	jmp	C_MIDISND_$L506
C_MIDISND_$FC334:
; Line 214
	push	OFFSET _snd_parse_cursor
	call	_snd_1537
	add	sp,2
	dec	ax
	jne	C_MIDISND_$I336
; Line 215
	mov	bl,BYTE PTR _snd_event_channel
	sub	bh,bh
	shl	bx,1
	mov	si,WORD PTR _snd_channel_masks[bx]
; Line 216
	mov	al,BYTE PTR _snd_event_note
	sub	ah,ah
	shl	ax,1
	add	ax,OFFSET _snd_note_channels
	mov	dx,ax
; Line 217
	mov	cx,si
	mov	bx,dx
	test	WORD PTR [bx],cx
	je	C_MIDISND_$I336
; Line 218
	not	si
	and	WORD PTR [bx],si
; Line 219
	dec	WORD PTR _snd_scan_note_count
; Line 220
	mov	cx,WORD PTR _snd_held_free
; Line 221
	or	cx,cx
	jne	C_MIDISND_$JCC1520
	jmp	C_MIDISND_$EX325
C_MIDISND_$JCC1520:
; Line 222
	mov	bx,cx
	mov	ax,WORD PTR [bx+2]
	mov	WORD PTR _snd_held_free,ax
; Line 223
	mov	dx,WORD PTR _snd_held_cursor
	mov	WORD PTR [bx+2],dx
; Line 224
	mov	WORD PTR _snd_held_cursor,cx
; Line 225
	mov	WORD PTR [bx],0
; Line 226
	or	dx,dx
	je	C_MIDISND_$I339
	mov	bx,dx
	mov	WORD PTR [bx],cx
; Line 227
C_MIDISND_$I339:
	mov	al,BYTE PTR _snd_event_note
	mov	bx,cx
	mov	BYTE PTR [bx+4],al
; Line 228
	mov	al,BYTE PTR _snd_event_channel
	mov	BYTE PTR [bx+5],al
; Line 229
	mov	WORD PTR [bx+6],di
; Line 230
	mov	ax,WORD PTR [bp-8]	;time
	mov	dx,WORD PTR [bp-6]
	mov	WORD PTR [bx+8],ax
	mov	WORD PTR [bx+10],dx
; Line 231
	sub	ax,ax
	mov	WORD PTR [bx+14],ax
	mov	WORD PTR [bx+12],ax
; Line 232
	mov	WORD PTR [bx+18],ax
	mov	WORD PTR [bx+16],ax
; Line 235
C_MIDISND_$I336:
	push	OFFSET _snd_parse_cursor
	call	_snd_101E
	add	sp,2
	add	WORD PTR [bp-8],ax	;time
	adc	WORD PTR [bp-6],dx
; Line 236
C_MIDISND_$L506:
	cmp	WORD PTR _snd_scan_note_count,0
	je	C_MIDISND_$JCC1619
	jmp	C_MIDISND_$FC334
C_MIDISND_$JCC1619:
; Line 237
	sub	ax,ax
	mov	WORD PTR _snd_scan_end_tick+2,ax
	mov	WORD PTR _snd_scan_end_tick,ax
; Line 238
	mov	si,WORD PTR _snd_held_cursor
	jmp	SHORT C_MIDISND_$L507
	nop	
	nop	
C_MIDISND_$F340:
; Line 239
	mov	bl,BYTE PTR [si+5]
	sub	bh,bh
	shl	bx,1
	mov	ax,WORD PTR _snd_channel_masks[bx]
	mov	bl,BYTE PTR [si+4]
	sub	bh,bh
	shl	bx,1
	or	WORD PTR _snd_note_channels[bx],ax
; Line 240
	mov	ax,WORD PTR _snd_scan_end_tick
	mov	dx,WORD PTR _snd_scan_end_tick+2
	cmp	WORD PTR [si+10],dx
	jb	C_MIDISND_$FC341
	ja	C_MIDISND_$L492
	cmp	WORD PTR [si+8],ax
	jbe	C_MIDISND_$FC341
C_MIDISND_$L492:
	mov	ax,WORD PTR [si+8]
	mov	dx,WORD PTR [si+10]
	mov	WORD PTR _snd_scan_end_tick,ax
	mov	WORD PTR _snd_scan_end_tick+2,dx
; Line 238
C_MIDISND_$FC341:
	mov	si,WORD PTR [si+2]
C_MIDISND_$L507:
	or	si,si
	jne	C_MIDISND_$F340
; Line 242
	mov	ax,WORD PTR [bp+10]	;to
	mov	dx,WORD PTR [bp+12]
	mov	WORD PTR _snd_parse_cursor,ax
	mov	WORD PTR _snd_parse_cursor+2,dx
; Line 243
	mov	ax,WORD PTR [bp+14]	;delta
	mov	dx,WORD PTR [bp+16]
	mov	WORD PTR [bp-8],ax	;time
	mov	WORD PTR [bp-6],dx
; Line 244
C_MIDISND_$FC345:
	mov	ax,WORD PTR _snd_scan_end_tick
	mov	dx,WORD PTR _snd_scan_end_tick+2
	cmp	WORD PTR [bp-6],dx
	jbe	C_MIDISND_$JCC1736
	jmp	C_MIDISND_$FB346
C_MIDISND_$JCC1736:
	jb	C_MIDISND_$L493
	cmp	WORD PTR [bp-8],ax	;time
	jb	C_MIDISND_$JCC1746
	jmp	C_MIDISND_$FB346
C_MIDISND_$JCC1746:
C_MIDISND_$L493:
; Line 245
	push	OFFSET _snd_parse_cursor
	call	_snd_1537
	add	sp,2
	cmp	ax,2
	je	C_MIDISND_$JCC1763
	jmp	C_MIDISND_$I347
C_MIDISND_$JCC1763:
; Line 246
	mov	bl,BYTE PTR _snd_event_channel
	sub	bh,bh
	shl	bx,1
	mov	cx,WORD PTR _snd_channel_masks[bx]
; Line 247
	mov	al,BYTE PTR _snd_event_note
	sub	ah,ah
	shl	ax,1
	add	ax,OFFSET _snd_note_channels
	mov	WORD PTR [bp-2],ax	;bits
; Line 248
	mov	si,ax
	mov	ax,WORD PTR _snd_channel_masks[bx]
	test	WORD PTR [si],ax
	je	C_MIDISND_$I347
; Line 249
	mov	si,WORD PTR _snd_held_cursor
; Line 250
C_MIDISND_$FC350:
	or	si,si
	je	C_MIDISND_$I347
; Line 251
	mov	di,WORD PTR [si+2]
; Line 253
	mov	al,BYTE PTR _snd_event_note
	cmp	BYTE PTR [si+4],al
	jne	C_MIDISND_$I352
	mov	al,BYTE PTR _snd_event_channel
	cmp	BYTE PTR [si+5],al
	jne	C_MIDISND_$I352
	mov	ax,WORD PTR [bp-8]	;time
	mov	dx,WORD PTR [bp-6]
	cmp	WORD PTR [si+10],dx
	jb	C_MIDISND_$I352
	ja	C_MIDISND_$L494
	cmp	WORD PTR [si+8],ax
	jbe	C_MIDISND_$I352
C_MIDISND_$L494:
; Line 254
	mov	ax,cx
	not	ax
	mov	bx,WORD PTR [bp-2]	;bits
	and	WORD PTR [bx],ax
; Line 255
	or	di,di
	je	C_MIDISND_$I353
	mov	ax,WORD PTR [si]
	mov	WORD PTR [di],ax
; Line 256
C_MIDISND_$I353:
	cmp	WORD PTR [si],0
	je	C_MIDISND_$I354
	mov	bx,WORD PTR [si]
	mov	WORD PTR [bx+2],di
; Line 257
	jmp	SHORT C_MIDISND_$I355
	nop	
	nop	
	nop	
C_MIDISND_$I354:
	mov	WORD PTR _snd_held_cursor,di
C_MIDISND_$I355:
; Line 258
	mov	ax,WORD PTR _snd_held_free
	mov	WORD PTR [si+2],ax
; Line 259
	mov	WORD PTR _snd_held_free,si
; Line 261
C_MIDISND_$I352:
	mov	si,di
; Line 262
	jmp	SHORT C_MIDISND_$FC350
; Line 265
C_MIDISND_$I347:
	push	OFFSET _snd_parse_cursor
	call	_snd_101E
	add	sp,2
	add	WORD PTR [bp-8],ax	;time
	adc	WORD PTR [bp-6],dx
; Line 266
	jmp	C_MIDISND_$FC345
C_MIDISND_$FB346:
; Line 267
	cmp	WORD PTR _snd_held_active,0
	jne	C_MIDISND_$I356
; Line 268
	mov	ax,WORD PTR _snd_held_cursor
	mov	WORD PTR _snd_held_active,ax
; Line 269
	mov	WORD PTR _snd_held_cursor,0
; Line 270
	pop	si
	pop	di
	leave	
	ret	
	nop	
; Line 272
C_MIDISND_$I356:
	mov	bx,WORD PTR _snd_held_active
	jmp	SHORT C_MIDISND_$L508
C_MIDISND_$F357:
	mov	bx,WORD PTR [bx+2]
C_MIDISND_$L508:
	cmp	WORD PTR [bx+2],0
	jne	C_MIDISND_$F357
; Line 273
	mov	di,WORD PTR _snd_held_cursor
	mov	WORD PTR [bx+2],di
; Line 274
	mov	WORD PTR _snd_held_cursor,0
; Line 275
	or	di,di
	je	C_MIDISND_$EX325
	mov	WORD PTR [di],bx
; Line 276
C_MIDISND_$EX325:
	pop	si
	pop	di
	leave	
	ret	

_snd_12D8	ENDP

; register-ABI-ASM MR1537 (original order 1537)
public _snd_1537
_snd_1537 label near
    enter 0, 0 ; 1537
    push si ; 153B
    cld ; 153C
    mov bx, word ptr [bp + 4] ; 153D
    les si, dword ptr [bx] ; 1540
    lods byte ptr es:[si] ; 1542
    mov bl, al ; 1544
    cmp al, 080h ; 1546
    jb short A_MR1537_midi_1589 ; 1548
    cmp al, 0F0h ; 154A
    jae short A_MR1537_midi_15A4 ; 154C
    and ax, 070h ; 154E
    shr ax, 3 ; 1551
    xchg bx, ax ; 1554
    jmp word ptr cs:[bx + A_MR1537_midi_155A] ; 1555
A_MR1537_midi_155A:
    dw offset A_MR1537_midi_1568, offset A_MR1537_midi_1582, offset A_MR1537_midi_15A0, offset A_MR1537_midi_15A0, offset A_MR1537_midi_15A1, offset A_MR1537_midi_15A1, offset A_MR1537_midi_15A0 ; MIDI event dispatch
A_MR1537_midi_1568:
    and al, 0Fh ; 1568
    mov byte ptr [_snd_event_channel], al ; 156A
    lods byte ptr es:[si] ; 156D
    mov byte ptr [_snd_event_note], al ; 156F
    lods byte ptr es:[si] ; 1572
    mov byte ptr [_snd_event_velocity], al ; 1574
    mov bx, word ptr [bp + 4] ; 1577
    mov word ptr [bx], si ; 157A
A_MR1537_midi_157C:
    mov ax, 1 ; 157C
    pop si ; 157F
    leave ; 1580
    ret ; 1581
A_MR1537_midi_1582:
    and al, 0Fh ; 1582
    mov byte ptr [_snd_event_channel], al ; 1584
    lods byte ptr es:[si] ; 1587
A_MR1537_midi_1589:
    mov byte ptr [_snd_event_note], al ; 1589
    lods byte ptr es:[si] ; 158C
    mov byte ptr [_snd_event_velocity], al ; 158E
    mov bx, word ptr [bp + 4] ; 1591
    mov word ptr [bx], si ; 1594
    or al, al ; 1596
    je short A_MR1537_midi_157C ; 1598
    mov ax, 2 ; 159A
    pop si ; 159D
    leave ; 159E
    ret ; 159F
A_MR1537_midi_15A0:
    inc si ; 15A0
A_MR1537_midi_15A1:
    inc si ; 15A1
    jmp short A_MR1537_midi_15D5 ; 15A2
A_MR1537_midi_15A4:
    cmp al, 0F0h ; 15A4
    je short A_MR1537_midi_15B6 ; 15A6
    cmp al, 0F7h ; 15A8
    je short A_MR1537_midi_15B6 ; 15AA
    cmp al, 0FFh ; 15AC
    jne short A_MR1537_midi_15CA ; 15AE
    lods byte ptr es:[si] ; 15B0
    cmp al, 02Fh ; 15B2
    je short A_MR1537_midi_15CA ; 15B4
A_MR1537_midi_15B6:
    mov dx, si ; 15B6
    mov si, word ptr [bp + 4] ; 15B8
    mov word ptr [si], dx ; 15BB
    push si ; 15BD
    call near ptr _snd_101E ; 15BE
    inc sp ; 15C1
    inc sp ; 15C2
    add word ptr [si], ax ; 15C3
    xor ax, ax ; 15C5
    pop si ; 15C7
    leave ; 15C8
    ret ; 15C9
A_MR1537_midi_15CA:
    xor ax, ax ; 15CA
    mov word ptr [_snd_scan_note_count], ax ; 15CC
    mov word ptr [_snd_scan_end_tick+02h], ax ; 15CF
    mov word ptr [_snd_scan_end_tick], ax ; 15D2
A_MR1537_midi_15D5:
    mov bx, word ptr [bp + 4] ; 15D5
    mov word ptr [bx], si ; 15D8
    xor ax, ax ; 15DA
    pop si ; 15DC
    leave ; 15DD
    ret ; 15DE

; compiler-C _snd_15DF (original order 15DF)
PUBLIC _snd_15DF
_snd_15DF	PROC NEAR
; Line 281
	push	di
; Line 282
	xor	ax,ax
	mov	di,OFFSET _snd_note_channels
	mov	cx,256	;0100H
	push	ds
	pop	es
	rep	stosb
; Line 283
	pop	di
	ret	
	nop	

_snd_15DF	ENDP

; compiler-C _snd_15F0 (original order 15F0)
PUBLIC _snd_15F0
_snd_15F0	PROC NEAR
; Line 286
	push	bp
	mov	bp,sp
;	channel = 4
;	note = 6
; Line 287
	mov	bl,BYTE PTR [bp+4]	;channel
	sub	bh,bh
	shl	bx,1
	mov	ax,WORD PTR _snd_channel_masks[bx]
	mov	bl,BYTE PTR [bp+6]	;note
	sub	bh,bh
	shl	bx,1
	or	WORD PTR _snd_note_channels[bx],ax
; Line 288
	leave	
	ret	
	nop	

_snd_15F0	ENDP

; compiler-C _snd_160C (original order 160C)
PUBLIC _snd_160C
_snd_160C	PROC NEAR
; Line 291
	push	bp
	mov	bp,sp
;	channel = 4
;	note = 6
; Line 292
	mov	bl,BYTE PTR [bp+4]	;channel
	sub	bh,bh
	shl	bx,1
	mov	ax,WORD PTR _snd_channel_masks[bx]
	not	ax
	mov	bl,BYTE PTR [bp+6]	;note
	sub	bh,bh
	shl	bx,1
	and	WORD PTR _snd_note_channels[bx],ax
; Line 293
	leave	
	ret	
	nop	

_snd_160C	ENDP

; compiler-C _snd_162A (original order 162A)
PUBLIC _snd_162A
_snd_162A	PROC NEAR
; Line 296
	enter	4,0
	push	di
	push	si
;	player = 4
;	note = -2
;	channel = -1
;	bits = -4
; Line 299
	mov	BYTE PTR [bp-2],0	;note
	mov	si,WORD PTR [bp+4]	;player
	jmp	SHORT C_MIDISND_$L509
	nop	
C_MIDISND_$F378:
; Line 301
	mov	bl,BYTE PTR [bp-2]	;note
	sub	bh,bh
	shl	bx,1
	mov	di,WORD PTR _snd_note_channels[bx]
	or	di,di
	je	C_MIDISND_$FC379
; Line 302
	mov	BYTE PTR [bp-1],0	;channel
C_MIDISND_$F382:
	cmp	BYTE PTR [bp-1],16	;0010H	;channel
	jae	C_MIDISND_$FC379
; Line 303
	mov	bl,BYTE PTR [bp-1]	;channel
	sub	bh,bh
	shl	bx,1
	test	WORD PTR _snd_channel_masks[bx],di
	je	C_MIDISND_$FC383
; Line 304
	push	80	;0050H
	mov	al,BYTE PTR [bp-2]	;note
	push	ax
	mov	al,BYTE PTR [bp-1]	;channel
	push	ax
	push	si
	call	_snd_216C
	add	sp,8
; Line 302
C_MIDISND_$FC383:
	inc	BYTE PTR [bp-1]	;channel
	jmp	SHORT C_MIDISND_$F382
; Line 299
C_MIDISND_$FC379:
	inc	BYTE PTR [bp-2]	;note
C_MIDISND_$L509:
	cmp	BYTE PTR [bp-2],128	;0080H	;note
	jb	C_MIDISND_$F378
; Line 307
	pop	si
	pop	di
	leave	
	ret	
	nop	

_snd_162A	ENDP

; compiler-C _snd_167E (original order 167E)
PUBLIC _snd_167E
_snd_167E	PROC NEAR
; Line 310
; Line 311
	xor	ax,ax
	mov	BYTE PTR _snd_fade_state,al
; Line 312
	ret	

_snd_167E	ENDP

; compiler-C _snd_1684 (original order 1684)
PUBLIC _snd_1684
_snd_1684	PROC NEAR
; Line 315
	push	bp
	mov	bp,sp
;	player = 4
;	register bx = fade
;	register dx = count
; Line 316
	mov	bx,OFFSET _snd_fades
; Line 317
	mov	dx,2
	mov	cx,WORD PTR [bp+4]	;player
; Line 318
C_MIDISND_$D392:
; Line 319
	cmp	BYTE PTR [bx],0
	je	C_MIDISND_$I395
	cmp	WORD PTR [bx+2],cx
	jne	C_MIDISND_$I395
	mov	BYTE PTR [bx],0
; Line 320
C_MIDISND_$I395:
	add	bx,16	;0010H
; Line 321
	dec	dx
	jne	C_MIDISND_$D392
; Line 322
	leave	
	ret	
	nop	

_snd_1684	ENDP

; compiler-C _snd_16A5 (original order 16A5)
PUBLIC _snd_16A5
_snd_16A5	PROC NEAR
; Line 325
	enter	2,0
	push	di
	push	si
;	register si = fade
;	register di = count
;	volume = -1
; Line 329
	cmp	BYTE PTR _snd_fade_state,0
	je	C_MIDISND_$EX396
; Line 330
	inc	WORD PTR _snd_fade_tick_scale
; Line 332
	and	WORD PTR _snd_fade_tick_scale,3
	jne	C_MIDISND_$EX396
; Line 333
	mov	si,OFFSET _snd_fades
; Line 334
	mov	BYTE PTR _snd_fade_state,0
; Line 335
	mov	di,2
; Line 336
C_MIDISND_$D402:
; Line 337
	cmp	BYTE PTR [si],0
	je	C_MIDISND_$I405
; Line 338
	mov	BYTE PTR _snd_fade_state,1
; Line 339
	mov	al,BYTE PTR [si+4]
	add	al,BYTE PTR [si+10]
	mov	BYTE PTR [bp-1],al	;volume
; Line 340
	mov	al,BYTE PTR [si+12]
	cbw	
	add	WORD PTR [si+14],ax
; Line 341
	mov	ax,WORD PTR [si+14]
	cmp	WORD PTR [si+6],ax
	ja	C_MIDISND_$I406
; Line 342
	mov	ax,WORD PTR [si+6]
	sub	WORD PTR [si+14],ax
; Line 343
	mov	al,BYTE PTR [si+11]
	add	BYTE PTR [bp-1],al	;volume
; Line 345
C_MIDISND_$I406:
	mov	al,BYTE PTR [bp-1]	;volume
	cmp	BYTE PTR [si+4],al
	je	C_MIDISND_$I407
; Line 346
	or	al,al
	je	C_MIDISND_$I408
; Line 347
	mov	BYTE PTR [si+4],al
; Line 348
	push	ax
	push	WORD PTR [si+2]
	call	_snd_075E
	add	sp,4
; Line 349
	jmp	SHORT C_MIDISND_$I407
C_MIDISND_$I408:
; Line 350
	push	WORD PTR [si+2]
	call	_snd_0643
	add	sp,2
; Line 351
	mov	BYTE PTR [si],0
; Line 354
C_MIDISND_$I407:
	dec	WORD PTR [si+8]
	jne	C_MIDISND_$I405
	mov	BYTE PTR [si],0
; Line 356
C_MIDISND_$I405:
	add	si,16	;0010H
; Line 357
	dec	di
	jne	C_MIDISND_$D402
; Line 358
C_MIDISND_$EX396:
	pop	si
	pop	di
	leave	
	ret	

_snd_16A5	ENDP

; compiler-C _snd_171D (original order 171D)
PUBLIC _snd_171D
_snd_171D	PROC NEAR
; Line 361
	push	bp
	mov	bp,sp
	push	di
	push	si
;	player = 4
;	marker = 6
;	register di = index
;	register dx = sound
;	register bx = command
; Line 365
	mov	ax,WORD PTR _snd_queue_read
	cmp	WORD PTR _snd_queue_write,ax
	jne	C_MIDISND_$JCC2332
	jmp	C_MIDISND_$EX415
C_MIDISND_$JCC2332:
; Line 366
	mov	bx,WORD PTR [bp+4]	;player
	mov	dx,WORD PTR [bx+8]
; Line 367
	cmp	BYTE PTR _snd_building_queue,0
	je	C_MIDISND_$I420
	cmp	WORD PTR _snd_queued_sound,dx
	jne	C_MIDISND_$I420
	mov	al,BYTE PTR _snd_queued_marker
	cmp	BYTE PTR [bp+6],al	;marker
	je	C_MIDISND_$EX415
; Line 368
C_MIDISND_$I420:
; Line 369
	mov	bx,WORD PTR _snd_queue_read
	shl	bx,4
	add	bx,OFFSET _snd_queue
	cmp	WORD PTR [bx],0
	jne	C_MIDISND_$EX415
	cmp	WORD PTR [bx+2],dx
	jne	C_MIDISND_$EX415
	mov	al,BYTE PTR [bp+6]	;marker
	sub	ah,ah
	cmp	WORD PTR [bx+4],ax
	jne	C_MIDISND_$EX415
; Line 370
	dec	WORD PTR _snd_trigger_count
; Line 371
C_MIDISND_$FC424:
; Line 373
	mov	di,WORD PTR _snd_queue_read
	inc	di
	cmp	di,64	;0040H
	jl	C_MIDISND_$I426
	xor	di,di
; Line 374
C_MIDISND_$I426:
	cmp	WORD PTR _snd_queue_write,di
	je	C_MIDISND_$FB425
; Line 376
	mov	si,di
	shl	si,4
	add	si,OFFSET _snd_queue
	cmp	WORD PTR [si],1
	jne	C_MIDISND_$FB425
; Line 377
	mov	WORD PTR _snd_queue_read,di
; Line 379
	push	0
	push	WORD PTR [si+14]
	push	WORD PTR [si+12]
	push	WORD PTR [si+10]
	push	WORD PTR [si+8]
	push	WORD PTR [si+6]
	push	WORD PTR [si+4]
	push	WORD PTR [si+2]
	call	FAR PTR _snd_00FE
	add	sp,16	;0010H
; Line 380
	jmp	SHORT C_MIDISND_$FC424
C_MIDISND_$FB425:
; Line 381
	mov	WORD PTR _snd_queue_read,di
; Line 382
C_MIDISND_$EX415:
	pop	si
	pop	di
	leave	
	ret	

_snd_171D	ENDP

; compiler-C _snd_17BB (original order 17BB)
PUBLIC _snd_17BB
_snd_17BB	PROC NEAR
; Line 385
	push	bp
	mov	bp,sp
;	what = 4
; Line 386
	mov	ax,WORD PTR [bp+4]	;what
; Line 394
	or	ax,ax
	je	C_MIDISND_$SC436
	dec	ax
	je	C_MIDISND_$SC437
	dec	ax
	je	C_MIDISND_$SC439
	jmp	SHORT C_MIDISND_$SB433
; Line 387
C_MIDISND_$SC436:
	mov	ax,WORD PTR _snd_trigger_count
	leave	
	ret	
	nop	
; Line 388
C_MIDISND_$SC437:
; Line 389
	mov	ax,WORD PTR _snd_queue_read
	cmp	WORD PTR _snd_queue_write,ax
	je	C_MIDISND_$SB433
	mov	bx,ax
	shl	bx,4
	mov	ax,WORD PTR _snd_queue[bx+2]
	leave	
	ret	
; Line 391
C_MIDISND_$SC439:
; Line 392
	mov	ax,WORD PTR _snd_queue_read
	cmp	WORD PTR _snd_queue_write,ax
	je	C_MIDISND_$SB433
	mov	bx,ax
	shl	bx,4
	mov	ax,WORD PTR _snd_queue[bx+4]
	leave	
	ret	
; Line 394
C_MIDISND_$SB433:
; Line 395
	mov	ax,-1	;ffffH
; Line 396
	leave	
	ret	
	nop	

_snd_17BB	ENDP

; compiler-C _snd_17FC (original order 17FC)
PUBLIC _snd_17FC
_snd_17FC	PROC NEAR
; Line 399
	enter	2,0
	push	si
;	sound = 4
;	register bx = index
;	end = -2
; Line 400
	mov	bx,WORD PTR _snd_queue_read
; Line 401
	mov	cx,WORD PTR _snd_queue_write
	mov	dx,WORD PTR [bp+4]	;sound
; Line 402
C_MIDISND_$FC447:
	cmp	cx,bx
	je	C_MIDISND_$FB448
; Line 404
	mov	si,bx
	shl	si,4
	cmp	WORD PTR _snd_queue[si],1
	jne	C_MIDISND_$I449
	mov	si,bx
	shl	si,4
	cmp	WORD PTR _snd_queue[si+2],8
	jne	C_MIDISND_$I449
	mov	si,bx
	shl	si,4
	cmp	WORD PTR _snd_queue[si+4],dx
	je	C_MIDISND_$L502
; Line 405
C_MIDISND_$I449:
	inc	bx
	cmp	bx,64	;0040H
	jl	C_MIDISND_$FC447
	xor	bx,bx
; Line 406
	jmp	SHORT C_MIDISND_$FC447
	nop	
C_MIDISND_$L502:
; Line 404
	mov	ax,2
	pop	si
	leave	
	ret	
; Line 406
C_MIDISND_$FB448:
; Line 407
	xor	ax,ax
; Line 408
	pop	si
	leave	
	ret	
	nop	

_snd_17FC	ENDP

; register-ABI-ASM MR183E (original order 183E)
public _snd_183E
_snd_183E label near
    enter 0, 0 ; 183E
    push si ; 1842
    mov bx, word ptr [bp + 6] ; 1843
    les si, dword ptr [bx] ; 1846
    cld ; 1848
    lods byte ptr es:[si] ; 1849
    cmp al, 080h ; 184B
    jae short A_MR183E_midi_1857 ; 184D
    mov dx, ax ; 184F
    mov cl, byte ptr [_snd_event_channel] ; 1851
    jmp short A_MR183E_midi_18A8 ; 1855
A_MR183E_midi_1857:
    cmp al, 0F0h ; 1857
    jb short A_MR183E_midi_185E ; 1859
    jmp near ptr A_MR183E_midi_19AA-10000h ; 185B
A_MR183E_midi_185E:
    mov bx, ax ; 185E
    and al, 0Fh ; 1860
    cbw ; 1862
    mov cx, ax ; 1863
    and bx, 070h ; 1865
    shr bx, 3 ; 1868
    jmp word ptr cs:[bx + A_MR183E_midi_1870] ; 186B
A_MR183E_midi_1870:
    dw offset A_MR183E_midi_187E, offset A_MR183E_midi_18A0, offset A_MR183E_midi_18EA, offset A_MR183E_midi_18F0, offset A_MR183E_midi_197C, offset A_MR183E_midi_189C, offset A_MR183E_midi_18EA ; MIDI event dispatch
A_MR183E_midi_187E:
    lods byte ptr es:[si] ; 187E
    cmp word ptr [_snd_scanning], 0 ; 1880
    jne short A_MR183E_midi_1894 ; 1885
    push ax ; 1887
    push cx ; 1888
    push word ptr [bp + 4] ; 1889
    call near ptr _snd_21A2 ; 188C
    add sp, 6 ; 188F
    jmp short A_MR183E_midi_189C ; 1892
A_MR183E_midi_1894:
    push ax ; 1894
    push cx ; 1895
    call near ptr _snd_160C ; 1896
    add sp, 4 ; 1899
A_MR183E_midi_189C:
    inc si ; 189C
    jmp near ptr A_MR183E_midi_1A40-10000h ; 189D
A_MR183E_midi_18A0:
    mov byte ptr [_snd_event_channel], cl ; 18A0
    lods byte ptr es:[si] ; 18A4
    mov dl, al ; 18A6
A_MR183E_midi_18A8:
    lods byte ptr es:[si] ; 18A8
    cmp word ptr [_snd_scanning], 0 ; 18AA
    jne short A_MR183E_midi_18D2 ; 18AF
    or al, al ; 18B1
    je short A_MR183E_midi_18C4 ; 18B3
    push ax ; 18B5
    push dx ; 18B6
    push cx ; 18B7
    push word ptr [bp + 4] ; 18B8
    call near ptr _snd_216C ; 18BB
    add sp, 8 ; 18BE
    jmp near ptr A_MR183E_midi_1A40-10000h ; 18C1
A_MR183E_midi_18C4:
    push dx ; 18C4
    push cx ; 18C5
    push word ptr [bp + 4] ; 18C6
    call near ptr _snd_21A2 ; 18C9
    add sp, 6 ; 18CC
    jmp near ptr A_MR183E_midi_1A40-10000h ; 18CF
A_MR183E_midi_18D2:
    push dx ; 18D2
    push cx ; 18D3
    or al, al ; 18D4
    je short A_MR183E_midi_18E1 ; 18D6
    call near ptr _snd_15F0 ; 18D8
    add sp, 4 ; 18DB
    jmp near ptr A_MR183E_midi_1A40-10000h ; 18DE
A_MR183E_midi_18E1:
    call near ptr _snd_160C ; 18E1
    add sp, 4 ; 18E4
    jmp near ptr A_MR183E_midi_1A40-10000h ; 18E7
A_MR183E_midi_18EA:
    inc si ; 18EA
    inc si ; 18EB
    jmp near ptr A_MR183E_midi_1A40-10000h ; 18EC
    nop ; 18EF
A_MR183E_midi_18F0:
    lods byte ptr es:[si] ; 18F0
    mov bx, word ptr [bp + 4] ; 18F2
    cmp al, 1 ; 18F5
    je short A_MR183E_midi_1914 ; 18F7
    cmp al, 7 ; 18F9
    je short A_MR183E_midi_1922 ; 18FB
    cmp al, 0Ah ; 18FD
    je short A_MR183E_midi_1930 ; 18FF
    cmp al, 010h ; 1901
    je short A_MR183E_midi_1940 ; 1903
    cmp al, 011h ; 1905
    je short A_MR183E_midi_194E ; 1907
    cmp al, 012h ; 1909
    je short A_MR183E_midi_195E ; 190B
    cmp al, 040h ; 190D
    je short A_MR183E_midi_196E ; 190F
    jmp near ptr A_MR183E_midi_1A40-10000h ; 1911
A_MR183E_midi_1914:
    lods byte ptr es:[si] ; 1914
    push ax ; 1916
    push cx ; 1917
    push bx ; 1918
    call near ptr _snd_253C ; 1919
    add sp, 6 ; 191C
    jmp near ptr A_MR183E_midi_1A40-10000h ; 191F
A_MR183E_midi_1922:
    lods byte ptr es:[si] ; 1922
    push ax ; 1924
    push cx ; 1925
    push bx ; 1926
    call near ptr _snd_235A ; 1927
    add sp, 6 ; 192A
    jmp near ptr A_MR183E_midi_1A40-10000h ; 192D
A_MR183E_midi_1930:
    lods byte ptr es:[si] ; 1930
    sub al, 040h ; 1932
    push ax ; 1934
    push cx ; 1935
    push bx ; 1936
    call near ptr _snd_23D1 ; 1937
    add sp, 6 ; 193A
    jmp near ptr A_MR183E_midi_1A40-10000h ; 193D
A_MR183E_midi_1940:
    lods byte ptr es:[si] ; 1940
    push ax ; 1942
    push cx ; 1943
    push bx ; 1944
    call near ptr _snd_25E7 ; 1945
    add sp, 6 ; 1948
    jmp near ptr A_MR183E_midi_1A40-10000h ; 194B
A_MR183E_midi_194E:
    lods byte ptr es:[si] ; 194E
    sub al, 040h ; 1950
    push ax ; 1952
    push cx ; 1953
    push bx ; 1954
    call near ptr _snd_247E ; 1955
    add sp, 6 ; 1958
    jmp near ptr A_MR183E_midi_1A40-10000h ; 195B
A_MR183E_midi_195E:
    lods byte ptr es:[si] ; 195E
    sub al, 040h ; 1960
    push ax ; 1962
    push cx ; 1963
    push bx ; 1964
    call near ptr _snd_22F1 ; 1965
    add sp, 6 ; 1968
    jmp near ptr A_MR183E_midi_1A40-10000h ; 196B
A_MR183E_midi_196E:
    lods byte ptr es:[si] ; 196E
    push ax ; 1970
    push cx ; 1971
    push bx ; 1972
    call near ptr _snd_2567 ; 1973
    add sp, 6 ; 1976
    jmp near ptr A_MR183E_midi_1A40-10000h ; 1979
A_MR183E_midi_197C:
    lods byte ptr es:[si] ; 197C
    push ax ; 197E
    push cx ; 197F
    push word ptr [bp + 4] ; 1980
    call near ptr _snd_2277 ; 1983
    add sp, 6 ; 1986
    jmp near ptr A_MR183E_midi_1A40-10000h ; 1989
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
    jmp near ptr A_MR183E_midi_1A40-10000h ; 19A7
A_MR183E_midi_19AA:
    cmp al, 0FFh ; 19AA
    je short A_MR183E_midi_19EF ; 19AC
    cmp al, 0F7h ; 19AE
    je short A_MR183E_midi_1A15 ; 19B0
    cmp al, 0F0h ; 19B2
    jne short A_MR183E_midi_19F5 ; 19B4
    mov ax, si ; 19B6
    mov si, word ptr [bp + 6] ; 19B8
    mov word ptr [si], ax ; 19BB
    push si ; 19BD
    call near ptr _snd_101E ; 19BE
    add sp, 2 ; 19C1
    les bx, dword ptr [si] ; 19C4
    cmp byte ptr es:[bx], 07Dh ; 19C6
    jne short A_MR183E_midi_19EB ; 19CA
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
    call near ptr _snd_1A4A ; 19DF
    add sp, 8 ; 19E2
    dec word ptr [_snd_disabled] ; 19E5
    pop dx ; 19E9
    pop ax ; 19EA
A_MR183E_midi_19EB:
    add ax, word ptr [si] ; 19EB
    jmp short A_MR183E_midi_1A42 ; 19ED
A_MR183E_midi_19EF:
    lods byte ptr es:[si] ; 19EF
    cmp al, 02Fh ; 19F1
    jne short A_MR183E_midi_1A11 ; 19F3
A_MR183E_midi_19F5:
    cmp word ptr [_snd_scanning], 0 ; 19F5
    jne short A_MR183E_midi_1A04 ; 19FA
    push word ptr [bp + 4] ; 19FC
    call near ptr _snd_0643 ; 19FF
    inc sp ; 1A02
    inc sp ; 1A03
A_MR183E_midi_1A04:
    mov si, word ptr [bp + 6] ; 1A04
    xor ax, ax ; 1A07
    mov word ptr [si], ax ; 1A09
    mov word ptr [si + 2], ax ; 1A0B
    pop si ; 1A0E
    leave ; 1A0F
    ret ; 1A10
A_MR183E_midi_1A11:
    cmp al, 051h ; 1A11
    je short A_MR183E_midi_1A26 ; 1A13
A_MR183E_midi_1A15:
    mov ax, si ; 1A15
    mov si, word ptr [bp + 6] ; 1A17
    mov word ptr [si], ax ; 1A1A
    push si ; 1A1C
    call near ptr _snd_101E ; 1A1D
    inc sp ; 1A20
    inc sp ; 1A21
    add ax, word ptr [si] ; 1A22
    jmp short A_MR183E_midi_1A42 ; 1A24
A_MR183E_midi_1A26:
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
    call near ptr _snd_0FBE ; 1A3A
    add sp, 6 ; 1A3D
A_MR183E_midi_1A40:
    mov ax, si ; 1A40
A_MR183E_midi_1A42:
    mov si, word ptr [bp + 6] ; 1A42
    mov word ptr [si], ax ; 1A45
    pop si ; 1A47
    leave ; 1A48
    ret ; 1A49

; register-ABI-ASM MR1A4A (original order 1A4A)
public _snd_1A4A
_snd_1A4A label near
    enter 0, 0 ; 1A4A
    push di ; 1A4E
    push si ; 1A4F
    les si, dword ptr [bp + 6] ; 1A50
    lods byte ptr es:[si] ; 1A53
    cmp al, 0 ; 1A55
    je short A_MR1A4A_midi_1AC6 ; 1A57
    cmp al, 1 ; 1A59
    jne short A_MR1A4A_midi_1A60 ; 1A5B
    jmp near ptr A_MR1A4A_midi_1AEE-10000h ; 1A5D
A_MR1A4A_midi_1A60:
    cmp al, 2 ; 1A60
    jne short A_MR1A4A_midi_1A67 ; 1A62
    jmp near ptr A_MR1A4A_midi_1B03-10000h ; 1A64
A_MR1A4A_midi_1A67:
    cmp al, 010h ; 1A67
    jne short A_MR1A4A_midi_1A6E ; 1A69
    jmp near ptr A_MR1A4A_midi_1B0F-10000h ; 1A6B
A_MR1A4A_midi_1A6E:
    cmp al, 011h ; 1A6E
    jne short A_MR1A4A_midi_1A75 ; 1A70
    jmp near ptr A_MR1A4A_midi_1B41-10000h ; 1A72
A_MR1A4A_midi_1A75:
    cmp al, 021h ; 1A75
    jne short A_MR1A4A_midi_1A7C ; 1A77
    jmp near ptr A_MR1A4A_midi_1B6D-10000h ; 1A79
A_MR1A4A_midi_1A7C:
    cmp al, 030h ; 1A7C
    jne short A_MR1A4A_midi_1A83 ; 1A7E
    jmp near ptr A_MR1A4A_midi_1BAE-10000h ; 1A80
A_MR1A4A_midi_1A83:
    cmp al, 031h ; 1A83
    jne short A_MR1A4A_midi_1A8A ; 1A85
    jmp near ptr A_MR1A4A_midi_1BDA-10000h ; 1A87
A_MR1A4A_midi_1A8A:
    cmp al, 032h ; 1A8A
    jne short A_MR1A4A_midi_1A91 ; 1A8C
    jmp near ptr A_MR1A4A_midi_1BFC-10000h ; 1A8E
A_MR1A4A_midi_1A91:
    cmp al, 033h ; 1A91
    jne short A_MR1A4A_midi_1A98 ; 1A93
    jmp near ptr A_MR1A4A_midi_1C24-10000h ; 1A95
A_MR1A4A_midi_1A98:
    cmp al, 034h ; 1A98
    jne short A_MR1A4A_midi_1A9F ; 1A9A
    jmp near ptr A_MR1A4A_midi_1C4C-10000h ; 1A9C
A_MR1A4A_midi_1A9F:
    cmp al, 035h ; 1A9F
    jne short A_MR1A4A_midi_1AA6 ; 1AA1
    jmp near ptr A_MR1A4A_midi_1C74-10000h ; 1AA3
A_MR1A4A_midi_1AA6:
    cmp al, 040h ; 1AA6
    jne short A_MR1A4A_midi_1AAD ; 1AA8
    jmp near ptr A_MR1A4A_midi_1C9C-10000h ; 1AAA
A_MR1A4A_midi_1AAD:
    cmp al, 050h ; 1AAD
    jne short A_MR1A4A_midi_1AB4 ; 1AAF
    jmp near ptr A_MR1A4A_midi_1CB6-10000h ; 1AB1
A_MR1A4A_midi_1AB4:
    cmp al, 051h ; 1AB4
    jne short A_MR1A4A_midi_1ABB ; 1AB6
    jmp near ptr A_MR1A4A_midi_1D04-10000h ; 1AB8
A_MR1A4A_midi_1ABB:
    cmp al, 060h ; 1ABB
    jne short A_MR1A4A_midi_1AC2 ; 1ABD
    jmp near ptr A_MR1A4A_midi_1D12-10000h ; 1ABF
A_MR1A4A_midi_1AC2:
    pop si ; 1AC2
    pop di ; 1AC3
    leave ; 1AC4
    ret ; 1AC5
A_MR1A4A_midi_1AC6:
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
    call near ptr _snd_1D49 ; 1AD8
    add sp, 8 ; 1ADB
    push offset _snd_sysex_buffer ; 1ADE
    push word ptr [bp + 4] ; 1AE1
    call near ptr _snd_1E83 ; 1AE4
    add sp, 4 ; 1AE7
    pop si ; 1AEA
    pop di ; 1AEB
    leave ; 1AEC
    ret ; 1AED
A_MR1A4A_midi_1AEE:
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
A_MR1A4A_midi_1B03:
    push word ptr [bp + 4] ; 1B03
    call near ptr _snd_20E7 ; 1B06
    inc sp ; 1B09
    inc sp ; 1B0A
    pop si ; 1B0B
    pop di ; 1B0C
    leave ; 1B0D
    ret ; 1B0E
A_MR1A4A_midi_1B0F:
    lods byte ptr es:[si] ; 1B0F
    and al, 0Fh ; 1B11
    mov dl, al ; 1B13
    lods byte ptr es:[si] ; 1B15
    cmp al, 1 ; 1B17
    je short A_MR1A4A_midi_1B1E ; 1B19
    jmp near ptr A_MR1A4A_midi_1D45-10000h ; 1B1B
A_MR1A4A_midi_1B1E:
    push offset _snd_sysex_buffer ; 1B1E
    push dx ; 1B21
    mov ax, word ptr [bp + 0Ah] ; 1B22
    sub ax, 3 ; 1B25
    push ax ; 1B28
    push offset _snd_sysex_buffer ; 1B29
    push es ; 1B2C
    push si ; 1B2D
    call near ptr _snd_1D49 ; 1B2E
    add sp, 8 ; 1B31
    push word ptr [bp + 4] ; 1B34
    call near ptr _snd_22A4 ; 1B37
    add sp, 6 ; 1B3A
    pop si ; 1B3D
    pop di ; 1B3E
    leave ; 1B3F
    ret ; 1B40
A_MR1A4A_midi_1B41:
    inc si ; 1B41
    lods byte ptr es:[si] ; 1B42
    cmp al, 1 ; 1B44
    je short A_MR1A4A_midi_1B4B ; 1B46
    jmp near ptr A_MR1A4A_midi_1D45-10000h ; 1B48
A_MR1A4A_midi_1B4B:
    lods byte ptr es:[si] ; 1B4B
    push offset _snd_sysex_buffer ; 1B4D
    push ax ; 1B50
    mov ax, word ptr [bp + 0Ah] ; 1B51
    sub ax, 4 ; 1B54
    push ax ; 1B57
    push offset _snd_sysex_buffer ; 1B58
    push es ; 1B5B
    push si ; 1B5C
    call near ptr _snd_1D49 ; 1B5D
    add sp, 8 ; 1B60
    call near ptr _snd_2679 ; 1B63
    add sp, 4 ; 1B66
    pop si ; 1B69
    pop di ; 1B6A
    leave ; 1B6B
    ret ; 1B6C
A_MR1A4A_midi_1B6D:
    lods byte ptr es:[si] ; 1B6D
    and al, 0Fh ; 1B6F
    mov di, ax ; 1B71
    lods byte ptr es:[si] ; 1B73
    cmp al, 1 ; 1B75
    je short A_MR1A4A_midi_1B7C ; 1B77
    jmp near ptr A_MR1A4A_midi_1D45-10000h ; 1B79
A_MR1A4A_midi_1B7C:
    mov ax, word ptr [bp + 0Ah] ; 1B7C
    sub ax, 3 ; 1B7F
    push ax ; 1B82
    push offset _snd_sysex_buffer ; 1B83
    push es ; 1B86
    push si ; 1B87
    call near ptr _snd_1D49 ; 1B88
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
A_MR1A4A_midi_1BAE:
    cmp word ptr [_snd_scanning], 0 ; 1BAE
    je short A_MR1A4A_midi_1BB8 ; 1BB3
    jmp near ptr A_MR1A4A_midi_1D45-10000h ; 1BB5
A_MR1A4A_midi_1BB8:
    mov ax, word ptr [bp + 0Ah] ; 1BB8
    dec ax ; 1BBB
    dec ax ; 1BBC
    push ax ; 1BBD
    push offset _snd_sysex_buffer ; 1BBE
    inc si ; 1BC1
    push es ; 1BC2
    push si ; 1BC3
    call near ptr _snd_1D49 ; 1BC4
    add sp, 8 ; 1BC7
    push offset _snd_sysex_buffer ; 1BCA
    push word ptr [bp + 4] ; 1BCD
    call near ptr _snd_109C ; 1BD0
    add sp, 4 ; 1BD3
    pop si ; 1BD6
    pop di ; 1BD7
    leave ; 1BD8
    ret ; 1BD9
A_MR1A4A_midi_1BDA:
    mov ax, word ptr [bp + 0Ah] ; 1BDA
    dec ax ; 1BDD
    dec ax ; 1BDE
    push ax ; 1BDF
    push offset _snd_sysex_buffer ; 1BE0
    inc si ; 1BE3
    push es ; 1BE4
    push si ; 1BE5
    call near ptr _snd_1D49 ; 1BE6
    add sp, 8 ; 1BE9
    push offset _snd_sysex_buffer ; 1BEC
    push word ptr [bp + 4] ; 1BEF
    call near ptr _snd_10E7 ; 1BF2
    add sp, 4 ; 1BF5
    pop si ; 1BF8
    pop di ; 1BF9
    leave ; 1BFA
    ret ; 1BFB
A_MR1A4A_midi_1BFC:
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
    call near ptr _snd_1D49 ; 1C0E
    add sp, 8 ; 1C11
    push offset _snd_sysex_buffer ; 1C14
    push word ptr [bp + 4] ; 1C17
    call near ptr _snd_1118 ; 1C1A
    add sp, 4 ; 1C1D
    pop si ; 1C20
    pop di ; 1C21
    leave ; 1C22
    ret ; 1C23
A_MR1A4A_midi_1C24:
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
    call near ptr _snd_1D49 ; 1C36
    add sp, 8 ; 1C39
    push offset _snd_sysex_buffer ; 1C3C
    push word ptr [bp + 4] ; 1C3F
    call near ptr _snd_114D ; 1C42
    add sp, 4 ; 1C45
    pop si ; 1C48
    pop di ; 1C49
    leave ; 1C4A
    ret ; 1C4B
A_MR1A4A_midi_1C4C:
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
    call near ptr _snd_1D49 ; 1C5E
    add sp, 8 ; 1C61
    push offset _snd_sysex_buffer ; 1C64
    push word ptr [bp + 4] ; 1C67
    call near ptr _snd_1182 ; 1C6A
    add sp, 4 ; 1C6D
    pop si ; 1C70
    pop di ; 1C71
    leave ; 1C72
    ret ; 1C73
A_MR1A4A_midi_1C74:
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
    call near ptr _snd_1D49 ; 1C86
    add sp, 8 ; 1C89
    push offset _snd_sysex_buffer ; 1C8C
    push word ptr [bp + 4] ; 1C8F
    call near ptr _snd_11B7 ; 1C92
    add sp, 4 ; 1C95
    pop si ; 1C98
    pop di ; 1C99
    leave ; 1C9A
    ret ; 1C9B
A_MR1A4A_midi_1C9C:
    inc si ; 1C9C
    mov di, word ptr [bp + 0Ah] ; 1C9D
    dec di ; 1CA0
    dec di ; 1CA1
A_MR1A4A_midi_1CA2:
    dec di ; 1CA2
    jns short A_MR1A4A_midi_1CA8 ; 1CA3
    jmp near ptr A_MR1A4A_midi_1D45-10000h ; 1CA5
A_MR1A4A_midi_1CA8:
    lods byte ptr es:[si] ; 1CA8
    push ax ; 1CAA
    push word ptr [bp + 4] ; 1CAB
    call near ptr _snd_171D ; 1CAE
    add sp, 4 ; 1CB1
    jmp short A_MR1A4A_midi_1CA2 ; 1CB4
A_MR1A4A_midi_1CB6:
    mov ax, word ptr [bp + 0Ah] ; 1CB6
    dec ax ; 1CB9
    dec ax ; 1CBA
    push ax ; 1CBB
    push offset _snd_sysex_buffer ; 1CBC
    inc si ; 1CBF
    push es ; 1CC0
    push si ; 1CC1
    call near ptr _snd_1D49 ; 1CC2
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
A_MR1A4A_midi_1D04:
    mov bx, word ptr [bp + 4] ; 1D04
    push word ptr [bx] ; 1D07
    call near ptr _snd_0B6E ; 1D09
    inc sp ; 1D0C
    inc sp ; 1D0D
    pop si ; 1D0E
    pop di ; 1D0F
    leave ; 1D10
    ret ; 1D11
A_MR1A4A_midi_1D12:
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
A_MR1A4A_midi_1D45:
    pop si ; 1D45
    pop di ; 1D46
    leave ; 1D47
    ret ; 1D48

; register-ABI-ASM MR1D49 (original order 1D49)
public _snd_1D49
_snd_1D49 label near
    enter 0, 0 ; 1D49
    push si ; 1D4D
    mov cx, word ptr [bp + 0Ah] ; 1D4E
    jcxz short A_MR1D49_midi_1D6A ; 1D51
    inc cx ; 1D53
    inc cx ; 1D54
    shr cx, 1 ; 1D55
    cld ; 1D57
    mov bx, word ptr [bp + 8] ; 1D58
    les si, dword ptr [bp + 4] ; 1D5B
A_MR1D49_midi_1D5E:
    lods word ptr es:[si] ; 1D5E
    shl al, 4 ; 1D60
    or al, ah ; 1D63
    mov byte ptr [bx], al ; 1D65
    inc bx ; 1D67
    loop A_MR1D49_midi_1D5E ; 1D68
A_MR1D49_midi_1D6A:
    pop si ; 1D6A
    leave ; 1D6B
    ret ; 1D6C

; compiler-C _snd_1D6D (original order 1D6D)
PUBLIC _snd_1D6D
_snd_1D6D	PROC NEAR
; Line 415
	enter	2,0
	push	si
;	cursor = 4
;	code = -1
	mov	si,WORD PTR [bp+4]	;cursor
; Line 417
	mov	bx,WORD PTR [si]
	inc	WORD PTR [si]
	mov	es,WORD PTR [si+2]
	mov	al,BYTE PTR es:[bx]
	mov	BYTE PTR [bp-1],al	;code
	cmp	al,128	;0080H
	jae	C_MIDISND_$I455
; Line 418
	inc	WORD PTR [si]
; Line 419
	pop	si
	leave	
	ret	
C_MIDISND_$I455:
	cmp	BYTE PTR [bp-1],240	;00f0H	;code
	jae	C_MIDISND_$I457
; Line 420
	mov	bl,BYTE PTR [bp-1]	;code
	and	bl,112	;0070H
	shr	bl,4
	sub	bh,bh
	mov	al,BYTE PTR _snd_midi_lengths[bx]
	sub	ah,ah
	jmp	SHORT C_MIDISND_$L510
	nop	
C_MIDISND_$I457:
	cmp	BYTE PTR [bp-1],240	;00f0H	;code
	je	C_MIDISND_$I460
	cmp	BYTE PTR [bp-1],247	;00f7H	;code
	je	C_MIDISND_$I460
; Line 423
	cmp	BYTE PTR [bp-1],255	;00ffH	;code
	jne	C_MIDISND_$I462
	mov	bx,WORD PTR [si]
	inc	WORD PTR [si]
	mov	es,WORD PTR [si+2]
	cmp	BYTE PTR es:[bx],47	;002fH
	jne	C_MIDISND_$I460
C_MIDISND_$I462:
; Line 426
	sub	ax,ax
	mov	WORD PTR [si+2],ax
	mov	WORD PTR [si],ax
	pop	si
	leave	
	ret	
	nop	
; Line 421
C_MIDISND_$I460:
; Line 422
	push	si
	call	_snd_101E
	add	sp,2
C_MIDISND_$L510:
	add	WORD PTR [si],ax
; Line 428
	pop	si
	leave	
	ret	

_snd_1D6D	ENDP

; register-ABI-ASM MR1DC6 (original order 1DC6)
public _snd_1DC6
_snd_1DC6 label near
    xor ax, ax ; 1DC6
    mov cx, 0100h ; 1DC8
A_MR1DC6_midi_1DCB:
    dec ah ; 1DCB
    call near ptr _snd_3164 ; 1DCD
    mov bx, 1 ; 1DD0
    call near ptr _snd_0496 ; 1DD3
    loop A_MR1DC6_midi_1DCB ; 1DD6
    xor ax, ax ; 1DD8
    ret ; 1DDA

; register-ABI-ASM MR1DDB (original order 1DDB)
public _snd_1DDB
_snd_1DDB label far
    mov bx, offset _snd_voices ; 1DDB
    xor cx, cx ; 1DDE
A_MR1DDB_midi_1DE0:
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
    jl short A_MR1DDB_midi_1DE0 ; 1E00
    call near ptr _snd_1DC6 ; 1E02
    mov ax, 0120h ; 1E05
    call near ptr _snd_312B ; 1E08
    mov ax, 0840h ; 1E0B
    call near ptr _snd_312B ; 1E0E
    mov ax, 0BD00h ; 1E11
    call near ptr _snd_312B ; 1E14
    xor ax, ax ; 1E17
    retf ; 1E19

; compiler-C _snd_1E1A (original order 1E1A)
PUBLIC _snd_1E1A
_snd_1E1A	PROC NEAR
; Line 8
	push	di
	push	si
;	register si = v
;	register di = count
; Line 12
	add	BYTE PTR _snd_voice_tick,3
	cmp	BYTE PTR _snd_voice_tick,10	;000aH
	jb	C_ADLIB_$EX195
; Line 13
	sub	BYTE PTR _snd_voice_tick,10	;000aH
; Line 14
	mov	si,OFFSET _snd_voices
; Line 15
	mov	di,9
; Line 16
C_ADLIB_$D199:
; Line 17
	cmp	WORD PTR [si],0
	je	C_ADLIB_$next_voice203
; Line 18
	cmp	WORD PTR [si+12],0
	je	C_ADLIB_$I204
; Line 20
	sub	WORD PTR [si+12],17	;0011H
	cmp	WORD PTR [si+12],0
	jle	C_ADLIB_$L753
; Line 25
C_ADLIB_$I204:
	cmp	BYTE PTR [si+14],0
	je	C_ADLIB_$I206
; Line 26
	lea	ax,WORD PTR [si+48]
	push	ax
	lea	ax,WORD PTR [si+14]
	push	ax
	push	si
	call	_snd_28FB
	add	sp,6
; Line 27
C_ADLIB_$I206:
	cmp	BYTE PTR [si+56],0
	je	C_ADLIB_$next_voice203
; Line 28
	lea	ax,WORD PTR [si+90]
	push	ax
	lea	ax,WORD PTR [si+56]
	push	ax
	push	si
	call	_snd_28FB
	add	sp,6
; Line 29
C_ADLIB_$next_voice203:
; Line 30
	add	si,98	;0062H
; Line 31
	dec	di
	jne	C_ADLIB_$D199
	pop	si
	pop	di
	ret	
	nop	
C_ADLIB_$L753:
; Line 21
	push	si
	call	_snd_2BC4
	add	sp,2
; Line 32
C_ADLIB_$EX195:
	pop	si
	pop	di
	ret	

_snd_1E1A	ENDP

; compiler-C _snd_1E83 (original order 1E83)
PUBLIC _snd_1E83
_snd_1E83	PROC NEAR
; Line 35
	enter	2,0
	push	di
	push	si
;	player = 4
;	preset = 6
;	register si = p
;	priority = -1
	mov	di,WORD PTR [bp+6]	;preset
; Line 40
	push	255	;00ffH
	push	0
	mov	al,BYTE PTR [di+2]
	cbw	
	mov	bx,WORD PTR [bp+4]	;player
	mov	cl,BYTE PTR [bx+12]
	sub	ch,ch
	add	cx,ax
	push	cx
	call	_snd_04D9
	add	sp,6
	mov	BYTE PTR [bp-1],al	;priority
	push	ax
	call	_snd_2129
	add	sp,2
	mov	si,ax
	or	si,si
	jne	C_ADLIB_$JCC157
	jmp	C_ADLIB_$EX212
C_ADLIB_$JCC157:
; Line 41
	push	si
	push	WORD PTR [bp+4]	;player
	call	_snd_2102
	add	sp,4
; Line 42
	mov	al,BYTE PTR [di]
	mov	BYTE PTR [si+11],al
; Line 43
	mov	al,BYTE PTR [di+1]
	and	al,1
	mov	BYTE PTR [si+13],al
; Line 44
	mov	al,BYTE PTR [di+2]
	mov	BYTE PTR [si+14],al
; Line 45
	mov	al,BYTE PTR [bp-1]	;priority
	mov	BYTE PTR [si+15],al
; Line 46
	mov	al,BYTE PTR [di+3]
	mov	BYTE PTR [si+16],al
; Line 47
	sub	ah,ah
	inc	ax
	mov	bx,WORD PTR [bp+4]	;player
	mov	cl,BYTE PTR [bx+14]
	sub	ch,ch
	imul	cx
	sar	ax,7
	mov	BYTE PTR [si+17],al
; Line 48
	mov	al,BYTE PTR [di+4]
	mov	BYTE PTR [si+18],al
; Line 49
	push	63	;003fH
	push	-64	;ffc0H
	cbw	
	mov	cx,ax
	mov	al,BYTE PTR [bx+15]
	cbw	
	add	cx,ax
	push	cx
	call	_snd_04D9
	add	sp,6
	mov	BYTE PTR [si+19],al
; Line 52
	mov	al,BYTE PTR [di+5]
	mov	BYTE PTR [si+20],al
	cmp	al,128	;0080H
	jne	C_ADLIB_$L754
	mov	BYTE PTR [si+21],0
	jmp	SHORT C_ADLIB_$L755
	nop	
C_ADLIB_$L754:
	push	12	;000cH
	push	-12	;fff4H
	mov	al,BYTE PTR [si+20]
	cbw	
	mov	bx,WORD PTR [bp+4]	;player
	mov	cx,ax
	mov	al,BYTE PTR [bx+16]
	cbw	
	add	cx,ax
	push	cx
	call	_snd_04F4
	add	sp,6
	mov	BYTE PTR [si+21],al
C_ADLIB_$L755:
; Line 54
	xor	al,al
	mov	BYTE PTR [si+24],al
	mov	BYTE PTR [si+25],al
; Line 55
	mov	al,BYTE PTR [di+7]
	mov	BYTE PTR [si+26],al
; Line 56
	mov	WORD PTR [si+28],0
; Line 57
	mov	al,BYTE PTR [di+6]
	mov	BYTE PTR [si+22],al
; Line 58
	push	127	;007fH
	push	-128	;ff80H
	mov	bx,WORD PTR [bp+4]	;player
	mov	al,BYTE PTR [bx+17]
	cbw	
	mov	cx,ax
	mov	al,BYTE PTR [si+22]
	cbw	
	add	cx,ax
	push	cx
	call	_snd_04D9
	add	sp,6
	mov	BYTE PTR [si+23],al
; Line 59
	push	2047	;07ffH
	push	-2048	;f800H
	mov	cx,ax
	mov	al,BYTE PTR [si+21]
	cbw	
	shl	ax,7
	mov	dx,ax
	mov	al,cl
	cbw	
	add	dx,ax
	push	dx
	call	_snd_04D9
	add	sp,6
	mov	WORD PTR [si+30],ax
; Line 60
	mov	al,BYTE PTR [di+8]
	push	ax
	mov	al,BYTE PTR [si+11]
	push	ax
	push	WORD PTR [bp+4]	;player
	call	_snd_2277
	add	sp,6
; Line 62
C_ADLIB_$EX212:
	pop	si
	pop	di
	leave	
	ret	

_snd_1E83	ENDP

; compiler-C _snd_1FA2 (original order 1FA2)
PUBLIC _snd_1FA2
_snd_1FA2	PROC NEAR
; Line 65
	push	bp
	mov	bp,sp
	push	si
;	p = 4
;	channel = 6
	mov	si,WORD PTR [bp+4]	;p
; Line 66
	or	si,si
	je	C_ADLIB_$EX220
; Line 67
	mov	al,BYTE PTR [bp+6]	;channel
	push	ax
	push	WORD PTR [si+4]
	call	_snd_1FA2
	add	sp,4
; Line 68
	mov	al,BYTE PTR [bp+6]	;channel
	cmp	BYTE PTR [si+11],al
	jne	C_ADLIB_$EX220
	push	si
	call	_snd_20AA
	add	sp,2
; Line 70
C_ADLIB_$EX220:
	pop	si
	leave	
	ret	

_snd_1FA2	ENDP

; compiler-C _snd_1FCC (original order 1FCC)
PUBLIC _snd_1FCC
_snd_1FCC	PROC NEAR
; Line 73
	push	si
;	register si = p
; Line 75
	mov	si,OFFSET _snd_parts
	jmp	SHORT C_ADLIB_$L791
C_ADLIB_$F225:
	push	si
	call	_snd_20AA
	add	sp,2
	add	si,32	;0020H
C_ADLIB_$L791:
	cmp	si,OFFSET _snd_parts+1024
	jb	C_ADLIB_$F225
; Line 76
	call	_snd_1DC6
; Line 77
	pop	si
	ret	
	nop	

_snd_1FCC	ENDP

; compiler-C _snd_1FE4 (original order 1FE4)
PUBLIC _snd_1FE4
_snd_1FE4	PROC NEAR
; Line 80
	push	bp
	mov	bp,sp
	push	di
	push	si
;	player = 4
;	channel = 6
;	register si = p
;	register dx = old
	mov	di,WORD PTR [bp+4]	;player
; Line 82
	mov	si,WORD PTR [di+4]
	jmp	SHORT C_ADLIB_$L793
	nop	
C_ADLIB_$F235:
; Line 83
	mov	al,BYTE PTR [bp+6]	;channel
	cmp	BYTE PTR [si+11],al
	jne	C_ADLIB_$JCC494
	jmp	C_ADLIB_$L792
C_ADLIB_$JCC494:
; Line 82
	mov	si,WORD PTR [si+4]
C_ADLIB_$L793:
	or	si,si
	jne	C_ADLIB_$F235
; Line 85
	mov	al,BYTE PTR [di+12]
	push	ax
	call	_snd_2129
	add	sp,2
	mov	si,ax
	or	si,si
	jne	C_ADLIB_$I239
	xor	ax,ax
	pop	si
	pop	di
	leave	
	ret	
; Line 86
C_ADLIB_$I239:
	mov	WORD PTR [si],di
; Line 87
	mov	WORD PTR [si+2],0
; Line 88
	mov	ax,WORD PTR [di+4]
	mov	dx,ax
; Line 89
	mov	WORD PTR [si+4],ax
; Line 90
	mov	WORD PTR [di+4],si
; Line 91
	or	dx,dx
	je	C_ADLIB_$I240
	mov	bx,ax
	mov	WORD PTR [bx+2],si
; Line 92
C_ADLIB_$I240:
	mov	al,BYTE PTR [bp+6]	;channel
	mov	BYTE PTR [si+11],al
; Line 94
	mov	al,1
	mov	BYTE PTR [si+12],al
	mov	BYTE PTR [si+13],al
; Line 95
	mov	al,BYTE PTR [di+12]
	mov	BYTE PTR [si+15],al
; Line 96
	mov	BYTE PTR [si+16],127	;007fH
; Line 97
	mov	al,BYTE PTR [di+14]
	mov	BYTE PTR [si+17],al
; Line 98
	push	63	;003fH
	push	-64	;ffc0H
	mov	al,BYTE PTR [di+15]
	cbw	
	push	ax
	call	_snd_04D9
	add	sp,6
	mov	BYTE PTR [si+19],al
; Line 100
	xor	al,al
	mov	BYTE PTR [si+14],al
	xor	cl,cl
	mov	BYTE PTR [si+18],al
; Line 102
	mov	BYTE PTR [si+20],cl
	mov	BYTE PTR [si+22],al
; Line 103
	mov	BYTE PTR [si+26],2
; Line 104
	mov	WORD PTR [si+28],0
; Line 105
	mov	al,BYTE PTR [di+17]
	mov	BYTE PTR [si+23],al
; Line 106
	mov	al,BYTE PTR [di+16]
	mov	BYTE PTR [si+21],al
; Line 107
	push	2047	;07ffH
	push	-2048	;f800H
	cbw	
	shl	ax,7
	mov	cx,ax
	mov	al,BYTE PTR [si+23]
	cbw	
	add	cx,ax
	push	cx
	call	_snd_04D9
	add	sp,6
	mov	WORD PTR [si+30],ax
; Line 109
	xor	al,al
	mov	BYTE PTR [si+24],al
	mov	BYTE PTR [si+25],al
; Line 110
	mov	BYTE PTR [si+10],al
; Line 111
C_ADLIB_$L792:
	mov	ax,si
; Line 112
	pop	si
	pop	di
	leave	
	ret	
	nop	

_snd_1FE4	ENDP

; compiler-C _snd_20AA (original order 20AA)
PUBLIC _snd_20AA
_snd_20AA	PROC NEAR
; Line 115
	enter	2,0
	push	di
	push	si
;	p = 4
;	previous = -2
;	register di = next
	mov	si,WORD PTR [bp+4]	;p
; Line 117
	cmp	WORD PTR [si],0
	je	C_ADLIB_$EX243
; Line 118
	push	si
	call	_snd_2772
	add	sp,2
; Line 119
	mov	ax,WORD PTR [si+2]
	mov	WORD PTR [bp-2],ax	;previous
; Line 120
	mov	di,WORD PTR [si+4]
; Line 121
	or	di,di
	je	C_ADLIB_$I247
	mov	WORD PTR [di+2],ax
; Line 122
C_ADLIB_$I247:
	cmp	WORD PTR [bp-2],0	;previous
	je	C_ADLIB_$I248
	mov	bx,WORD PTR [bp-2]	;previous
	jmp	SHORT C_ADLIB_$L794
C_ADLIB_$I248:
	mov	bx,WORD PTR [si]
C_ADLIB_$L794:
	mov	WORD PTR [bx+4],di
; Line 125
	xor	ax,ax
	mov	WORD PTR [si],ax
	mov	WORD PTR [si+2],ax
; Line 126
	mov	WORD PTR [si+4],ax
; Line 128
C_ADLIB_$EX243:
	pop	si
	pop	di
	leave	
	ret	
	nop	

_snd_20AA	ENDP

; compiler-C _snd_20E7 (original order 20E7)
PUBLIC _snd_20E7
_snd_20E7	PROC NEAR
; Line 131
	push	bp
	mov	bp,sp
	push	si
;	player = 4
	mov	si,WORD PTR [bp+4]	;player
; Line 132
	jmp	SHORT C_ADLIB_$L795
	nop	
C_ADLIB_$FC254:
	push	WORD PTR [si+4]
	call	_snd_20AA
	add	sp,2
C_ADLIB_$L795:
	cmp	WORD PTR [si+4],0
	jne	C_ADLIB_$FC254
; Line 133
	pop	si
	leave	
	ret	

_snd_20E7	ENDP

; compiler-C _snd_2102 (original order 2102)
PUBLIC _snd_2102
_snd_2102	PROC NEAR
; Line 136
	push	bp
	mov	bp,sp
	push	di
	push	si
;	player = 4
;	p = 6
;	register di = old
	mov	dx,WORD PTR [bp+4]	;player
	mov	bx,WORD PTR [bp+6]	;p
; Line 138
	mov	WORD PTR [bx+2],0
; Line 139
	mov	WORD PTR [bx],dx
; Line 140
	mov	si,dx
	mov	ax,WORD PTR [si+4]
	mov	di,ax
; Line 141
	mov	WORD PTR [bx+4],ax
; Line 142
	mov	WORD PTR [si+4],bx
; Line 143
	or	di,di
	je	C_ADLIB_$EX260
	mov	WORD PTR [di+2],bx
; Line 144
C_ADLIB_$EX260:
	pop	si
	pop	di
	leave	
	ret	

_snd_2102	ENDP

; compiler-C _snd_2129 (original order 2129)
PUBLIC _snd_2129
_snd_2129	PROC NEAR
; Line 147
	push	bp
	mov	bp,sp
	push	di
	push	si
;	priority = 4
;	register si = p
;	register di = candidate
;	register dx = count
; Line 150
	xor	di,di
; Line 151
	mov	si,OFFSET _snd_parts
	xor	dx,dx
C_ADLIB_$F269:
	cmp	dx,32	;0020H
	jge	C_ADLIB_$FB271
; Line 152
	cmp	WORD PTR [si],0
	je	C_ADLIB_$L761
; Line 153
	mov	al,BYTE PTR [bp+4]	;priority
	cmp	BYTE PTR [si+15],al
	ja	C_ADLIB_$FC270
; Line 154
	mov	al,BYTE PTR [si+15]
	mov	BYTE PTR [bp+4],al	;priority
; Line 155
	mov	di,si
; Line 151
C_ADLIB_$FC270:
	add	si,32	;0020H
	inc	dx
	jmp	SHORT C_ADLIB_$F269
C_ADLIB_$L761:
; Line 152
	mov	ax,si
	pop	si
	pop	di
	leave	
	ret	
; Line 157
C_ADLIB_$FB271:
; Line 158
	or	di,di
	je	C_ADLIB_$I274
	push	di
	call	_snd_20AA
	add	sp,2
; Line 159
C_ADLIB_$I274:
	mov	ax,di
; Line 160
	pop	si
	pop	di
	leave	
	ret	
	nop	

_snd_2129	ENDP

; compiler-C _snd_216C (original order 216C)
PUBLIC _snd_216C
_snd_216C	PROC NEAR
; Line 163
	push	bp
	mov	bp,sp
	push	si
;	player = 4
;	channel = 6
;	note = 8
;	velocity = 10
;	register si = p
; Line 165
	mov	al,BYTE PTR [bp+6]	;channel
	push	ax
	push	WORD PTR [bp+4]	;player
	call	_snd_1FE4
	add	sp,4
	mov	si,ax
	or	si,si
	je	C_ADLIB_$EX283
	cmp	BYTE PTR [si+13],0
	je	C_ADLIB_$EX283
	cmp	BYTE PTR [si+12],0
	jne	C_ADLIB_$EX283
	mov	al,BYTE PTR [bp+10]	;velocity
	push	ax
	mov	al,BYTE PTR [bp+8]	;note
	push	ax
	push	si
	call	_snd_2709
	add	sp,6
; Line 166
C_ADLIB_$EX283:
	pop	si
	leave	
	ret	
	nop	

_snd_216C	ENDP

; compiler-C _snd_21A2 (original order 21A2)
PUBLIC _snd_21A2
_snd_21A2	PROC NEAR
; Line 169
	push	bp
	mov	bp,sp
	push	si
;	player = 4
;	channel = 6
;	note = 8
;	register si = p
; Line 171
	mov	bx,WORD PTR [bp+4]	;player
	mov	si,WORD PTR [bx+4]
	jmp	SHORT C_ADLIB_$L797
C_ADLIB_$F294:
; Line 172
	mov	al,BYTE PTR [bp+6]	;channel
	cmp	BYTE PTR [si+11],al
	jne	C_ADLIB_$FC295
	cmp	BYTE PTR [si+13],0
	je	C_ADLIB_$FC295
	cmp	BYTE PTR [si+12],0
	jne	C_ADLIB_$FC295
; Line 173
	cmp	BYTE PTR [si+25],0
	je	C_ADLIB_$I298
	mov	al,BYTE PTR [bp+8]	;note
	push	ax
	push	WORD PTR [si+6]
	call	_snd_28BD
	jmp	SHORT C_ADLIB_$L796
C_ADLIB_$I298:
	mov	al,BYTE PTR [bp+8]	;note
	push	ax
	push	WORD PTR [si+6]
	call	_snd_2750
C_ADLIB_$L796:
	add	sp,4
; Line 171
C_ADLIB_$FC295:
	mov	si,WORD PTR [si+4]
C_ADLIB_$L797:
	or	si,si
	jne	C_ADLIB_$F294
; Line 177
	pop	si
	leave	
	ret	
	nop	

_snd_21A2	ENDP

; compiler-C _snd_21EF (original order 21EF)
PUBLIC _snd_21EF
_snd_21EF	PROC NEAR
; Line 180
	push	bp
	mov	bp,sp
	push	si
;	p = 4
	mov	si,WORD PTR [bp+4]	;p
; Line 181
	jmp	SHORT C_ADLIB_$L798
	nop	
C_ADLIB_$F303:
	push	si
	call	_snd_2772
	add	sp,2
	mov	si,WORD PTR [si+4]
C_ADLIB_$L798:
	or	si,si
	jne	C_ADLIB_$F303
; Line 182
	pop	si
	leave	
	ret	
	nop	

_snd_21EF	ENDP

; compiler-C _snd_2209 (original order 2209)
PUBLIC _snd_2209
_snd_2209	PROC NEAR
; Line 185
	push	bp
	mov	bp,sp
	push	si
;	p = 4
	mov	si,WORD PTR [bp+4]	;p
; Line 186
	jmp	SHORT C_ADLIB_$L799
	nop	
C_ADLIB_$F309:
; Line 187
	cmp	BYTE PTR [si+25],0
	je	C_ADLIB_$FC310
; Line 188
	mov	BYTE PTR [si+25],0
; Line 189
	push	WORD PTR [si+6]
	call	_snd_28DB
	add	sp,2
; Line 186
C_ADLIB_$FC310:
	mov	si,WORD PTR [si+4]
C_ADLIB_$L799:
	or	si,si
	jne	C_ADLIB_$F309
; Line 191
	pop	si
	leave	
	ret	
	nop	

_snd_2209	ENDP

; compiler-C _snd_222F (original order 222F)
PUBLIC _snd_222F
_snd_222F	PROC NEAR
; Line 194
	enter	2,0
	push	di
	push	si
;	register si = v
;	mask = -2
;	p = 4
;	notes = 6
;	count = 8
	mov	di,WORD PTR [bp+6]	;notes
	mov	cx,WORD PTR [bp+8]	;count
; Line 197
	jmp	SHORT C_ADLIB_$L800
C_ADLIB_$F322:
; Line 199
	mov	bx,WORD PTR [bp+4]	;p
	mov	si,WORD PTR [bx+6]
	or	si,si
	je	C_ADLIB_$FC323
; Line 200
	mov	bl,BYTE PTR [bx+11]
	sub	bh,bh
	shl	bx,1
	mov	dx,WORD PTR _snd_channel_masks[bx]
; Line 201
C_ADLIB_$D326:
; Line 202
	mov	bl,BYTE PTR [si+8]
	sub	bh,bh
	shl	bx,1
	test	WORD PTR [bx][di],dx
	jne	C_ADLIB_$I329
; Line 203
	mov	bl,BYTE PTR [si+8]
	sub	bh,bh
	shl	bx,1
	or	WORD PTR [bx][di],dx
; Line 204
	mov	bx,cx
	inc	WORD PTR [bx]
; Line 206
C_ADLIB_$I329:
; Line 207
	mov	si,WORD PTR [si+4]
	or	si,si
	jne	C_ADLIB_$D326
; Line 197
C_ADLIB_$FC323:
	mov	bx,WORD PTR [bp+4]	;p
	mov	ax,WORD PTR [bx+4]
	mov	WORD PTR [bp+4],ax	;p
C_ADLIB_$L800:
	cmp	WORD PTR [bp+4],0	;p
	jne	C_ADLIB_$F322
; Line 210
	pop	si
	pop	di
	leave	
	ret	
	nop	

_snd_222F	ENDP

; compiler-C _snd_2277 (original order 2277)
PUBLIC _snd_2277
_snd_2277	PROC NEAR
; Line 213
	push	bp
	mov	bp,sp
	push	si
;	player = 4
;	channel = 6
;	program = 8
;	register si = p
; Line 215
	mov	al,BYTE PTR [bp+6]	;channel
	push	ax
	push	WORD PTR [bp+4]	;player
	call	_snd_1FE4
	add	sp,4
	mov	si,ax
	or	si,si
	je	C_ADLIB_$EX336
; Line 217
	mov	al,BYTE PTR [bp+8]	;program
	mov	BYTE PTR [si+10],al
	push	ax
	push	si
	call	_snd_269B
	add	sp,4
; Line 218
	mov	BYTE PTR [si+12],0
; Line 220
C_ADLIB_$EX336:
	pop	si
	leave	
	ret	

_snd_2277	ENDP

; compiler-C _snd_22A4 (original order 22A4)
PUBLIC _snd_22A4
_snd_22A4	PROC NEAR
; Line 223
	push	bp
	mov	bp,sp
	push	si
;	player = 4
;	channel = 6
;	instrument = 8
;	register si = p
; Line 225
	mov	al,BYTE PTR [bp+6]	;channel
	push	ax
	push	WORD PTR [bp+4]	;player
	call	_snd_1FE4
	add	sp,4
	mov	si,ax
	or	si,si
	je	C_ADLIB_$EX345
; Line 226
	push	WORD PTR [bp+8]	;instrument
	push	si
	call	_snd_2665
	add	sp,4
; Line 227
	mov	BYTE PTR [si+12],0
; Line 229
C_ADLIB_$EX345:
	pop	si
	leave	
	ret	

_snd_22A4	ENDP

; compiler-C _snd_22CD (original order 22CD)
PUBLIC _snd_22CD
_snd_22CD	PROC NEAR
; Line 232
	enter	2,0
;	player = 4
;	channel = 6
;	parameter = 8
;	value = 10
;	p = -2
; Line 234
	mov	al,BYTE PTR [bp+6]	;channel
	push	ax
	push	WORD PTR [bp+4]	;player
	call	_snd_1FE4
	add	sp,4
	or	ax,ax
	je	C_ADLIB_$EX356
	push	WORD PTR [bp+10]	;value
	push	WORD PTR [bp+8]	;parameter
	push	ax
	call	_snd_26C3
; Line 235
C_ADLIB_$EX356:
	leave	
	ret	
	nop	

_snd_22CD	ENDP

; compiler-C _snd_22F1 (original order 22F1)
PUBLIC _snd_22F1
_snd_22F1	PROC NEAR
; Line 238
	push	bp
	mov	bp,sp
	push	si
;	player = 4
;	channel = 6
;	priority = 8
;	register si = p
; Line 240
	cmp	BYTE PTR [bp+6],16	;0010H	;channel
	jne	C_ADLIB_$I367
; Line 241
	mov	bx,WORD PTR [bp+4]	;player
	mov	si,WORD PTR [bx+4]
C_ADLIB_$F368:
	or	si,si
	je	C_ADLIB_$EX365
; Line 242
	push	255	;00ffH
	push	0
	mov	al,BYTE PTR [si+14]
	cbw	
	mov	cl,BYTE PTR [bp+8]	;priority
	sub	ch,ch
	add	ax,cx
	push	ax
	call	_snd_04D9
	add	sp,6
	mov	BYTE PTR [si+15],al
; Line 241
	mov	si,WORD PTR [si+4]
	jmp	SHORT C_ADLIB_$F368
	nop	
; Line 243
C_ADLIB_$I367:
; Line 245
	mov	al,BYTE PTR [bp+6]	;channel
	push	ax
	push	WORD PTR [bp+4]	;player
	call	_snd_1FE4
	add	sp,4
	mov	si,ax
	or	si,si
	je	C_ADLIB_$EX365
; Line 246
	mov	al,BYTE PTR [bp+8]	;priority
	mov	BYTE PTR [si+14],al
; Line 247
	push	255	;00ffH
	push	0
	cbw	
	mov	bx,WORD PTR [si]
	mov	cl,BYTE PTR [bx+12]
	sub	ch,ch
	add	ax,cx
	push	ax
	call	_snd_04D9
	add	sp,6
	mov	BYTE PTR [si+15],al
; Line 250
C_ADLIB_$EX365:
	pop	si
	leave	
	ret	
	nop	

_snd_22F1	ENDP

; compiler-C _snd_235A (original order 235A)
PUBLIC _snd_235A
_snd_235A	PROC NEAR
; Line 253
	push	bp
	mov	bp,sp
	push	si
;	player = 4
;	channel = 6
;	volume = 8
;	register si = p
; Line 255
	cmp	BYTE PTR [bp+6],16	;0010H	;channel
	jne	C_ADLIB_$I381
; Line 256
	mov	bx,WORD PTR [bp+4]	;player
	mov	si,WORD PTR [bx+4]
C_ADLIB_$F382:
	or	si,si
	je	C_ADLIB_$I385
; Line 257
	mov	al,BYTE PTR [si+16]
	sub	ah,ah
	inc	ax
	mov	cl,BYTE PTR [bp+8]	;volume
	sub	ch,ch
	imul	cx
	sar	ax,7
	mov	BYTE PTR [si+17],al
; Line 258
	push	ax
	push	WORD PTR [si+6]
	call	_snd_2A87
	add	sp,4
; Line 256
	mov	si,WORD PTR [si+4]
	jmp	SHORT C_ADLIB_$F382
; Line 260
C_ADLIB_$I381:
; Line 262
	mov	al,BYTE PTR [bp+6]	;channel
	push	ax
	push	WORD PTR [bp+4]	;player
	call	_snd_1FE4
	add	sp,4
	mov	si,ax
	or	si,si
	jne	C_ADLIB_$I386
	mov	ax,-1	;ffffH
	pop	si
	leave	
	ret	
	nop	
; Line 263
C_ADLIB_$I386:
	mov	al,BYTE PTR [bp+8]	;volume
	mov	BYTE PTR [si+16],al
; Line 264
	sub	ah,ah
	inc	ax
	mov	bx,WORD PTR [si]
	mov	cl,BYTE PTR [bx+14]
	sub	ch,ch
	imul	cx
	sar	ax,7
	mov	BYTE PTR [si+17],al
; Line 265
	push	ax
	push	WORD PTR [si+6]
	call	_snd_2A87
	add	sp,4
; Line 266
C_ADLIB_$I385:
; Line 267
	xor	ax,ax
; Line 268
	pop	si
	leave	
	ret	
	nop	

_snd_235A	ENDP

; compiler-C _snd_23D1 (original order 23D1)
PUBLIC _snd_23D1
_snd_23D1	PROC NEAR
; Line 270
	ret	
	nop	

_snd_23D1	ENDP

; compiler-C _snd_23D2 (original order 23D2)
PUBLIC _snd_23D2
_snd_23D2	PROC NEAR
; Line 273
	push	bp
	mov	bp,sp
	push	si
;	player = 4
;	channel = 6
;	relative = 8
;	transpose = 10
;	register si = p
; Line 275
	cmp	BYTE PTR [bp+10],25	;0019H	;transpose
	jl	C_ADLIB_$JCC1528
	jmp	C_ADLIB_$EX396
C_ADLIB_$JCC1528:
	cmp	BYTE PTR [bp+10],231	;00e7H	;transpose
	jg	C_ADLIB_$JCC1537
	jmp	C_ADLIB_$EX396
C_ADLIB_$JCC1537:
; Line 276
	cmp	BYTE PTR [bp+6],16	;0010H	;channel
	jne	C_ADLIB_$I399
; Line 277
	mov	bx,WORD PTR [bp+4]	;player
	mov	si,WORD PTR [bx+4]
C_ADLIB_$F400:
	or	si,si
	jne	C_ADLIB_$JCC1556
	jmp	C_ADLIB_$EX396
C_ADLIB_$JCC1556:
; Line 278
	push	24	;0018H
	push	-24	;ffe8H
	mov	al,BYTE PTR [bp+10]	;transpose
	cbw	
	mov	cx,ax
	mov	al,BYTE PTR [si+20]
	cbw	
	add	cx,ax
	push	cx
	call	_snd_04F4
	add	sp,6
	mov	BYTE PTR [si+21],al
; Line 279
	push	ax
	push	WORD PTR [si+6]
	call	_snd_2AD9
	add	sp,4
; Line 277
	mov	si,WORD PTR [si+4]
	jmp	SHORT C_ADLIB_$F400
; Line 281
C_ADLIB_$I399:
; Line 283
	mov	al,BYTE PTR [bp+6]	;channel
	push	ax
	push	WORD PTR [bp+4]	;player
	call	_snd_1FE4
	add	sp,4
	mov	si,ax
	or	si,si
	je	C_ADLIB_$EX396
; Line 284
	cmp	BYTE PTR [bp+8],0	;relative
	je	C_ADLIB_$I405
	push	7
	push	-7	;fff9H
	mov	al,BYTE PTR [bp+10]	;transpose
	cbw	
	mov	cx,ax
	mov	al,BYTE PTR [si+20]
	cbw	
	add	cx,ax
	push	cx
	call	_snd_04F4
	add	sp,6
	mov	BYTE PTR [bp+10],al	;transpose
; Line 285
C_ADLIB_$I405:
	mov	al,BYTE PTR [bp+10]	;transpose
	mov	BYTE PTR [si+20],al
; Line 286
	push	24	;0018H
	push	-24	;ffe8H
	cbw	
	mov	bx,WORD PTR [si]
	mov	cx,ax
	mov	al,BYTE PTR [bx+16]
	cbw	
	add	cx,ax
	push	cx
	call	_snd_04F4
	add	sp,6
	mov	BYTE PTR [si+21],al
; Line 287
	push	ax
	push	WORD PTR [si+6]
	call	_snd_2AD9
	add	sp,4
; Line 291
C_ADLIB_$EX396:
	pop	si
	leave	
	ret	
	nop	

_snd_23D2	ENDP

; compiler-C _snd_247E (original order 247E)
PUBLIC _snd_247E
_snd_247E	PROC NEAR
; Line 294
	push	bp
	mov	bp,sp
	push	si
;	player = 4
;	channel = 6
;	detune = 8
;	register si = p
; Line 296
	cmp	BYTE PTR [bp+6],16	;0010H	;channel
	jne	C_ADLIB_$I414
; Line 297
	mov	bx,WORD PTR [bp+4]	;player
	mov	si,WORD PTR [bx+4]
C_ADLIB_$F415:
	or	si,si
	je	C_ADLIB_$EX412
; Line 298
	push	127	;007fH
	push	-128	;ff80H
	mov	al,BYTE PTR [bp+8]	;detune
	cbw	
	mov	cx,ax
	mov	al,BYTE PTR [si+22]
	cbw	
	add	cx,ax
	push	cx
	call	_snd_04D9
	add	sp,6
	mov	BYTE PTR [si+23],al
; Line 299
	cbw	
	add	ax,WORD PTR [si+28]
	mov	WORD PTR [si+30],ax
; Line 300
	push	ax
	push	WORD PTR [si+6]
	call	_snd_2B3F
	add	sp,4
; Line 297
	mov	si,WORD PTR [si+4]
	jmp	SHORT C_ADLIB_$F415
; Line 302
C_ADLIB_$I414:
; Line 304
	mov	al,BYTE PTR [bp+6]	;channel
	push	ax
	push	WORD PTR [bp+4]	;player
	call	_snd_1FE4
	add	sp,4
	mov	si,ax
	or	si,si
	je	C_ADLIB_$EX412
; Line 305
	mov	al,BYTE PTR [bp+8]	;detune
	mov	BYTE PTR [si+22],al
; Line 306
	push	127	;007fH
	push	-128	;ff80H
	cbw	
	mov	bx,WORD PTR [si]
	mov	cx,ax
	mov	al,BYTE PTR [bx+17]
	cbw	
	add	cx,ax
	push	cx
	call	_snd_04D9
	add	sp,6
	mov	BYTE PTR [si+23],al
; Line 307
	cbw	
	add	ax,WORD PTR [si+28]
	mov	WORD PTR [si+30],ax
; Line 308
	push	ax
	push	WORD PTR [si+6]
	call	_snd_2B3F
	add	sp,4
; Line 311
C_ADLIB_$EX412:
	pop	si
	leave	
	ret	

_snd_247E	ENDP

; compiler-C _snd_2509 (original order 2509)
PUBLIC _snd_2509
_snd_2509	PROC NEAR
; Line 314
	push	bp
	mov	bp,sp
	push	si
;	player = 4
;	channel = 6
;	enabled = 8
;	register si = p
; Line 316
	mov	al,BYTE PTR [bp+6]	;channel
	push	ax
	push	WORD PTR [bp+4]	;player
	call	_snd_1FE4
	add	sp,4
	mov	si,ax
	or	si,si
	jne	C_ADLIB_$I428
	mov	ax,-1	;ffffH
	pop	si
	leave	
	ret	
	nop	
; Line 317
C_ADLIB_$I428:
	mov	al,BYTE PTR [bp+8]	;enabled
	mov	BYTE PTR [si+13],al
; Line 318
	or	al,al
	jne	C_ADLIB_$I429
	push	si
	call	_snd_2772
	add	sp,2
; Line 319
C_ADLIB_$I429:
	xor	ax,ax
; Line 320
	pop	si
	leave	
	ret	

_snd_2509	ENDP

; compiler-C _snd_253C (original order 253C)
PUBLIC _snd_253C
_snd_253C	PROC NEAR
; Line 323
	push	bp
	mov	bp,sp
	push	si
;	player = 4
;	channel = 6
;	value = 8
;	register si = p
; Line 325
	mov	al,BYTE PTR [bp+6]	;channel
	push	ax
	push	WORD PTR [bp+4]	;player
	call	_snd_1FE4
	add	sp,4
	mov	si,ax
	or	si,si
	je	C_ADLIB_$EX436
; Line 326
	mov	al,BYTE PTR [bp+8]	;value
	mov	BYTE PTR [si+24],al
; Line 327
	push	ax
	push	WORD PTR [si+6]
	call	_snd_2B03
	add	sp,4
; Line 329
C_ADLIB_$EX436:
	pop	si
	leave	
	ret	

_snd_253C	ENDP

; compiler-C _snd_2567 (original order 2567)
PUBLIC _snd_2567
_snd_2567	PROC NEAR
; Line 332
	push	bp
	mov	bp,sp
	push	si
;	player = 4
;	channel = 6
;	sustain = 8
;	register si = p
; Line 334
	mov	al,BYTE PTR [bp+6]	;channel
	push	ax
	push	WORD PTR [bp+4]	;player
	call	_snd_1FE4
	add	sp,4
	mov	si,ax
	or	si,si
	je	C_ADLIB_$EX445
; Line 335
	mov	al,BYTE PTR [bp+8]	;sustain
	mov	BYTE PTR [si+25],al
; Line 336
	or	al,al
	jne	C_ADLIB_$EX445
	push	WORD PTR [si+6]
	call	_snd_28DB
	add	sp,2
; Line 338
C_ADLIB_$EX445:
	pop	si
	leave	
	ret	
	nop	

_snd_2567	ENDP

; compiler-C _snd_2594 (original order 2594)
PUBLIC _snd_2594
_snd_2594	PROC NEAR
; Line 341
	push	bp
	mov	bp,sp
	push	si
;	player = 4
;	channel = 6
;	bend = 8
;	register si = p
; Line 343
	mov	al,BYTE PTR [bp+6]	;channel
	push	ax
	push	WORD PTR [bp+4]	;player
	call	_snd_1FE4
	add	sp,4
	mov	si,ax
	or	si,si
	je	C_ADLIB_$EX455
; Line 344
	mov	al,BYTE PTR [si+26]
	sub	ah,ah
	imul	WORD PTR [bp+8]	;bend
	sar	dx,1
	rcr	ax,1
	sar	dx,1
	rcr	ax,1
	sar	dx,1
	rcr	ax,1
	sar	dx,1
	rcr	ax,1
	sar	dx,1
	rcr	ax,1
	sar	dx,1
	rcr	ax,1
	mov	WORD PTR [si+28],ax
; Line 345
	mov	al,BYTE PTR [si+23]
	cbw	
	add	ax,WORD PTR [si+28]
	mov	WORD PTR [si+30],ax
; Line 346
	push	ax
	push	WORD PTR [si+6]
	call	_snd_2B3F
	add	sp,4
; Line 348
C_ADLIB_$EX455:
	pop	si
	leave	
	ret	
	nop	

_snd_2594	ENDP

; compiler-C _snd_25E7 (original order 25E7)
PUBLIC _snd_25E7
_snd_25E7	PROC NEAR
; Line 351
	push	bp
	mov	bp,sp
	push	di
	push	si
;	player = 4
;	channel = 6
;	range = 8
;	register si = p
; Line 353
	cmp	BYTE PTR [bp+8],13	;000dH	;range
	jae	C_ADLIB_$EX464
	mov	di,WORD PTR [bp+4]	;player
; Line 355
	mov	al,BYTE PTR [bp+6]	;channel
	push	ax
	push	di
	call	_snd_1FE4
	add	sp,4
	mov	si,ax
	or	si,si
	je	C_ADLIB_$EX464
; Line 357
	push	0
	push	ax
	push	di
	call	_snd_2594
	add	sp,6
; Line 358
	mov	al,BYTE PTR [bp+8]	;range
	mov	BYTE PTR [si+26],al
; Line 361
C_ADLIB_$EX464:
	pop	si
	pop	di
	leave	
	ret	
	nop	

_snd_25E7	ENDP

; compiler-C _snd_261A (original order 261A)
PUBLIC _snd_261A
_snd_261A	PROC NEAR
; Line 364
	push	bp
	mov	bp,sp
	push	si
;	player = 4
;	parameter = 6
;	channel = 8
;	register si = p
; Line 366
	mov	bx,WORD PTR [bp+4]	;player
	mov	si,WORD PTR [bx+4]
	jmp	SHORT C_ADLIB_$L801
C_ADLIB_$F476:
; Line 367
	mov	al,BYTE PTR [bp+8]	;channel
	cmp	BYTE PTR [si+11],al
	je	C_ADLIB_$FB478
; Line 366
	mov	si,WORD PTR [si+4]
C_ADLIB_$L801:
	or	si,si
	jne	C_ADLIB_$F476
; Line 368
C_ADLIB_$FB478:
	or	si,si
	jne	C_ADLIB_$I480
	mov	al,129	;0081H
	pop	si
	leave	
	ret	
; Line 369
C_ADLIB_$I480:
	mov	al,BYTE PTR [bp+6]	;parameter
	cbw	
; Line 374
	sub	ax,14	;000eH
	je	C_ADLIB_$SC485
	dec	ax
	je	C_ADLIB_$SC486
	dec	ax
	je	C_ADLIB_$SC487
	dec	ax
	je	C_ADLIB_$SC488
; Line 375
	mov	al,255	;00ffH
	pop	si
	leave	
	ret	
	nop	
; Line 370
C_ADLIB_$SC485:
	mov	al,BYTE PTR [si+13]
	pop	si
	leave	
	ret	
; Line 371
C_ADLIB_$SC486:
	mov	al,BYTE PTR [si+16]
	pop	si
	leave	
	ret	
; Line 372
C_ADLIB_$SC487:
	mov	al,BYTE PTR [si+10]
	pop	si
	leave	
	ret	
; Line 373
C_ADLIB_$SC488:
	mov	al,BYTE PTR [si+20]
; Line 376
	pop	si
	leave	
	ret	

_snd_261A	ENDP

; compiler-C _snd_2665 (original order 2665)
PUBLIC _snd_2665
_snd_2665	PROC NEAR
; Line 379
	push	bp
	mov	bp,sp
;	p = 4
;	instrument = 6
; Line 380
	push	30	;001eH
	push	WORD PTR [bp+6]	;instrument
	mov	bx,WORD PTR [bp+4]	;p
	push	WORD PTR [bx+8]
	call	_snd_053D
; Line 381
	leave	
	ret	
	nop	

_snd_2665	ENDP

; compiler-C _snd_2679 (original order 2679)
PUBLIC _snd_2679
_snd_2679	PROC NEAR
; Line 384
	push	bp
	mov	bp,sp
;	number = 4
;	instrument = 6
; Line 385
	cmp	BYTE PTR [bp+4],32	;0020H	;number
	jae	C_ADLIB_$EX498
	push	30	;001eH
	push	WORD PTR [bp+6]	;instrument
	mov	al,30	;001eH
	mul	BYTE PTR [bp+4]	;number
	add	ax,OFFSET _snd_global_instruments
	push	ax
	call	_snd_053D
; Line 386
C_ADLIB_$EX498:
	leave	
	ret	

_snd_2679	ENDP

; compiler-C _snd_269B (original order 269B)
PUBLIC _snd_269B
_snd_269B	PROC NEAR
; Line 389
	push	bp
	mov	bp,sp
	push	di
;	p = 4
;	number = 6
;	register di = instrument
; Line 393
	push	30	;001eH
	cmp	BYTE PTR [bp+6],32	;0020H	;number
	jae	C_ADLIB_$I506
	mov	al,BYTE PTR [bp+6]	;number
	sub	ah,ah
	imul	di,ax,30	;001eH
	add	di,OFFSET _snd_global_instruments
	jmp	SHORT C_ADLIB_$I507
C_ADLIB_$I506:
	mov	di,OFFSET _snd_default_instrument
C_ADLIB_$I507:
	push	di
	mov	bx,WORD PTR [bp+4]	;p
	push	WORD PTR [bx+8]
	call	_snd_053D
	add	sp,6
; Line 394
	pop	di
	leave	
	ret	
	nop	

_snd_269B	ENDP

; compiler-C _snd_26C3 (original order 26C3)
PUBLIC _snd_26C3
_snd_26C3	PROC NEAR
; Line 397
	enter	2,0
	push	di
	push	si
;	value = 8
;	field = -2
;	p = 4
;	parameter = 6
	mov	dx,WORD PTR [bp+8]	;value
	mov	si,WORD PTR [bp+6]	;parameter
; Line 401
	mov	ax,si
	shl	si,2
	add	si,OFFSET _snd_instrument_fields
	mov	cl,BYTE PTR [si+2]
	mov	bl,BYTE PTR [si]
	sub	bh,bh
	mov	di,WORD PTR [bp+4]	;p
	mov	di,WORD PTR [di+8]
	not	cl
	and	cl,BYTE PTR [bx][di]
	mov	WORD PTR [bp-2],cx	;field
	mov	cl,BYTE PTR [si+1]
	mov	si,dx
	shl	dl,cl
	or	dl,BYTE PTR [bp-2]	;field
	mov	BYTE PTR [bx][di],dl
; Line 402
	push	si
	push	ax
	mov	bx,WORD PTR [bp+4]	;p
	push	WORD PTR [bx+6]
	call	_snd_2A5E
	add	sp,6
; Line 403
	pop	si
	pop	di
	leave	
	ret	
	nop	

_snd_26C3	ENDP

; compiler-C _snd_2709 (original order 2709)
PUBLIC _snd_2709
_snd_2709	PROC NEAR
; Line 406
	enter	2,0
	push	si
;	p = 4
;	note = 6
;	velocity = 8
;	v = -2
;	register dx = old
; Line 409
	mov	bx,WORD PTR [bp+4]	;p
	mov	al,BYTE PTR [bx+15]
	push	ax
	call	_snd_2B6C
	add	sp,2
	mov	WORD PTR [bp-2],ax	;v
	or	ax,ax
	je	C_ADLIB_$EX522
; Line 411
	mov	bx,WORD PTR [bp+4]	;p
	mov	si,ax
	mov	WORD PTR [si],bx
	mov	ax,WORD PTR [bx+6]
	mov	dx,ax
; Line 412
	mov	WORD PTR [si+4],ax
; Line 413
	mov	WORD PTR [si+2],0
; Line 414
	mov	WORD PTR [bx+6],si
; Line 415
	or	dx,dx
	je	C_ADLIB_$I526
	mov	ax,WORD PTR [bp-2]	;v
	mov	bx,dx
	mov	WORD PTR [bx+2],ax
; Line 416
C_ADLIB_$I526:
	mov	al,BYTE PTR [bp+8]	;velocity
	push	ax
	mov	al,BYTE PTR [bp+6]	;note
	push	ax
	push	WORD PTR [bp-2]	;v
	push	WORD PTR [bp+4]	;p
	call	_snd_278D
	add	sp,8
; Line 418
C_ADLIB_$EX522:
	pop	si
	leave	
	ret	
	nop	

_snd_2709	ENDP

; compiler-C _snd_2750 (original order 2750)
PUBLIC _snd_2750
_snd_2750	PROC NEAR
; Line 421
	push	bp
	mov	bp,sp
	push	si
;	v = 4
;	note = 6
	mov	si,WORD PTR [bp+4]	;v
; Line 422
	jmp	SHORT C_ADLIB_$L802
	nop	
C_ADLIB_$F532:
	mov	al,BYTE PTR [bp+6]	;note
	cmp	BYTE PTR [si+8],al
	jne	C_ADLIB_$FC533
	push	si
	call	_snd_2BC4
	add	sp,2
C_ADLIB_$FC533:
	mov	si,WORD PTR [si+4]
C_ADLIB_$L802:
	or	si,si
	jne	C_ADLIB_$F532
; Line 423
	pop	si
	leave	
	ret	
	nop	

_snd_2750	ENDP

; compiler-C _snd_2772 (original order 2772)
PUBLIC _snd_2772
_snd_2772	PROC NEAR
; Line 426
	push	bp
	mov	bp,sp
	push	si
;	p = 4
	mov	si,WORD PTR [bp+4]	;p
; Line 427
	jmp	SHORT C_ADLIB_$L803
	nop	
C_ADLIB_$FC540:
	push	WORD PTR [si+6]
	call	_snd_2BC4
	add	sp,2
C_ADLIB_$L803:
	cmp	WORD PTR [si+6],0
	jne	C_ADLIB_$FC540
; Line 428
	pop	si
	leave	
	ret	

_snd_2772	ENDP

; compiler-C _snd_278D (original order 278D)
PUBLIC _snd_278D
_snd_278D	PROC NEAR
; Line 431
	enter	4,0
	push	di
	push	si
;	p = 4
;	v = 6
;	note = 8
;	velocity = 10
;	register di = instrument
;	level = -1
;	carrier = -3
;	modulator = -2
;	register dx = volume_row
;	register dx = volume
	mov	si,WORD PTR [bp+6]	;v
; Line 436
	mov	bx,WORD PTR [bp+4]	;p
	mov	di,WORD PTR [bx+8]
	mov	al,BYTE PTR [di+10]
	and	al,1
	mov	BYTE PTR [si+6],al
; Line 437
	mov	al,BYTE PTR [bp+8]	;note
	mov	BYTE PTR [si+8],al
; Line 438
	mov	BYTE PTR [si+11],0
; Line 440
	mov	al,BYTE PTR [di+29]
	sub	ah,ah
	mov	WORD PTR [si+12],ax
	or	ax,ax
	je	C_ADLIB_$I557
	mov	ax,63	;003fH
	imul	WORD PTR [si+12]
	mov	WORD PTR [si+12],ax
; Line 441
C_ADLIB_$I557:
; Line 442
	mov	al,BYTE PTR [di+1]
	and	al,63	;003fH
	mov	bl,BYTE PTR [di+4]
	shr	bl,2
	sub	bh,bh
	mov	dl,BYTE PTR [bp+10]	;velocity
	and	dx,254	;00feH
	shl	dx,4
	add	dx,OFFSET _snd_volume_products
	add	bx,dx
	add	al,BYTE PTR [bx]
	mov	BYTE PTR [bp-1],al	;level
; Line 443
	cmp	al,63	;003fH
	jbe	C_ADLIB_$I558
	mov	BYTE PTR [bp-1],63	;003fH	;level
; Line 444
C_ADLIB_$I558:
	mov	al,BYTE PTR [bp-1]	;level
	mov	BYTE PTR [si+10],al
; Line 445
	mov	al,BYTE PTR [di+6]
	and	al,63	;003fH
	mov	bl,BYTE PTR [di+9]
	shr	bl,2
	sub	bh,bh
	add	bx,dx
	add	al,BYTE PTR [bx]
	mov	BYTE PTR [bp-1],al	;level
; Line 446
	cmp	al,63	;003fH
	jbe	C_ADLIB_$I559
	mov	BYTE PTR [bp-1],63	;003fH	;level
; Line 447
C_ADLIB_$I559:
	mov	al,BYTE PTR [bp-1]	;level
	mov	BYTE PTR [si+9],al
; Line 448
	mov	bx,WORD PTR [bp+4]	;p
	mov	cl,BYTE PTR [bx+17]
	shr	cl,2
	sub	ch,ch
	mov	dx,cx
; Line 449
	sub	ah,ah
	shl	ax,5
	mov	bx,dx
	add	bx,ax
	mov	al,BYTE PTR _snd_volume_products[bx]
	mov	BYTE PTR [bp-3],al	;carrier
; Line 450
	mov	al,BYTE PTR [si+10]
	mov	BYTE PTR [bp-2],al	;modulator
; Line 451
	cmp	BYTE PTR [si+6],1
	jne	C_ADLIB_$I560
	mov	bl,al
	sub	bh,bh
	shl	bx,5
	add	bx,dx
	mov	al,BYTE PTR _snd_volume_products[bx]
	mov	BYTE PTR [bp-2],al	;modulator
; Line 452
C_ADLIB_$I560:
	mov	al,BYTE PTR [bp-3]	;carrier
	push	ax
	mov	al,BYTE PTR [bp-2]	;modulator
	push	ax
	push	di
	push	si
	call	_snd_2E9B
	add	sp,8
; Line 453
	mov	bx,WORD PTR [bp+4]	;p
	push	WORD PTR [bx+30]
	mov	al,BYTE PTR [bx+21]
	add	al,BYTE PTR [bp+8]	;note
	push	ax
	mov	al,BYTE PTR [si+7]
	push	ax
	call	_snd_2F48
	add	sp,6
; Line 454
	test	BYTE PTR [di+11],128	;0080H
	je	C_ADLIB_$I561
; Line 455
	lea	ax,WORD PTR [di+12]
	push	ax
	mov	al,BYTE PTR [di+11]
	push	ax
	lea	ax,WORD PTR [si+48]
	push	ax
	lea	ax,WORD PTR [si+14]
	push	ax
	push	si
	call	_snd_29A1
	add	sp,10	;000aH
; Line 456
	jmp	SHORT C_ADLIB_$I562
	nop	
C_ADLIB_$I561:
	mov	BYTE PTR [si+14],0
C_ADLIB_$I562:
; Line 457
	test	BYTE PTR [di+20],128	;0080H
	je	C_ADLIB_$I563
; Line 458
	lea	ax,WORD PTR [di+21]
	push	ax
	mov	al,BYTE PTR [di+20]
	push	ax
	lea	ax,WORD PTR [si+90]
	push	ax
	lea	ax,WORD PTR [si+56]
	push	ax
	push	si
	call	_snd_29A1
	add	sp,10	;000aH
; Line 459
	pop	si
	pop	di
	leave	
	ret	
	nop	
C_ADLIB_$I563:
	mov	BYTE PTR [si+56],0
; Line 460
	pop	si
	pop	di
	leave	
	ret	

_snd_278D	ENDP

; compiler-C _snd_28BD (original order 28BD)
PUBLIC _snd_28BD
_snd_28BD	PROC NEAR
; Line 463
	push	bp
	mov	bp,sp
	push	si
;	v = 4
;	note = 6
	mov	si,WORD PTR [bp+4]	;v
; Line 464
	jmp	SHORT C_ADLIB_$L804
	nop	
C_ADLIB_$F570:
	mov	al,BYTE PTR [bp+6]	;note
	cmp	BYTE PTR [si+8],al
	jne	C_ADLIB_$FC571
	mov	BYTE PTR [si+11],1
C_ADLIB_$FC571:
	mov	si,WORD PTR [si+4]
C_ADLIB_$L804:
	or	si,si
	jne	C_ADLIB_$F570
; Line 465
	pop	si
	leave	
	ret	

_snd_28BD	ENDP

; compiler-C _snd_28DB (original order 28DB)
PUBLIC _snd_28DB
_snd_28DB	PROC NEAR
; Line 468
	push	bp
	mov	bp,sp
	push	si
;	v = 4
	mov	si,WORD PTR [bp+4]	;v
; Line 469
	jmp	SHORT C_ADLIB_$L805
	nop	
C_ADLIB_$F577:
	cmp	BYTE PTR [si+11],0
	je	C_ADLIB_$FC578
	push	si
	call	_snd_2BC4
	add	sp,2
C_ADLIB_$FC578:
	mov	si,WORD PTR [si+4]
C_ADLIB_$L805:
	or	si,si
	jne	C_ADLIB_$F577
; Line 470
	pop	si
	leave	
	ret	
	nop	

_snd_28DB	ENDP

; compiler-C _snd_28FB (original order 28FB)
PUBLIC _snd_28FB
_snd_28FB	PROC NEAR
; Line 473
	enter	4,0
	push	si
;	changes = -2
;	value = -4
;	w = 8
;	e = 6
;	v = 4
; Line 476
	push	WORD PTR [bp+8]	;w
	push	WORD PTR [bp+6]	;e
	call	_snd_2D33
	add	sp,4
	mov	BYTE PTR [bp-2],al	;changes
	test	al,1
	jne	C_ADLIB_$JCC2906
	jmp	C_ADLIB_$I590
C_ADLIB_$JCC2906:
; Line 477
	mov	bx,WORD PTR [bp+8]	;w
	mov	al,BYTE PTR [bx+2]
	sub	ah,ah
	cmp	ax,31	;001fH
	jne	C_ADLIB_$JCC2922
	jmp	C_ADLIB_$SC600
C_ADLIB_$JCC2922:
	ja	C_ADLIB_$SD601
	or	al,al
	je	C_ADLIB_$SC595
	sub	al,13	;000dH
	je	C_ADLIB_$SC596
	sub	al,17	;0011H
	je	C_ADLIB_$SC598
C_ADLIB_$SD601:
; Line 495
	mov	bx,WORD PTR [bp+6]	;e
	mov	ax,WORD PTR [bx+8]
	mov	bx,WORD PTR [bp+8]	;w
	add	ax,WORD PTR [bx]
	jmp	SHORT C_ADLIB_$L806
; Line 478
C_ADLIB_$SC595:
; Line 479
	mov	bx,WORD PTR [bp+6]	;e
	mov	al,BYTE PTR [bx+8]
	mov	bx,WORD PTR [bp+8]	;w
	add	al,BYTE PTR [bx]
	mov	bx,WORD PTR [bp+4]	;v
	mov	BYTE PTR [bx+9],al
; Line 480
	mov	si,WORD PTR [bx]
	mov	al,BYTE PTR [si+17]
	shr	al,2
	sub	ah,ah
	mov	si,ax
	mov	bl,BYTE PTR [bx+9]
	sub	bh,bh
	shl	bx,5
C_ADLIB_$L807:
	mov	al,BYTE PTR _snd_volume_products[bx][si]
C_ADLIB_$L806:
	mov	WORD PTR [bp-4],ax	;value
; Line 481
	jmp	SHORT C_ADLIB_$SB592
; Line 482
C_ADLIB_$SC596:
; Line 484
	mov	bx,WORD PTR [bp+6]	;e
	mov	al,BYTE PTR [bx+8]
	mov	bx,WORD PTR [bp+8]	;w
	add	al,BYTE PTR [bx]
	mov	bx,WORD PTR [bp+4]	;v
	mov	BYTE PTR [bx+10],al
	sub	ah,ah
	mov	WORD PTR [bp-4],ax	;value
; Line 485
	cmp	BYTE PTR [bx+6],1
	jne	C_ADLIB_$SB592
; Line 486
	mov	si,ax
	shl	si,5
	mov	bx,WORD PTR [bx]
	mov	bl,BYTE PTR [bx+17]
	shr	bl,2
	sub	bh,bh
	jmp	SHORT C_ADLIB_$L807
	nop	
; Line 488
C_ADLIB_$SC598:
; Line 489
	mov	al,BYTE PTR [bx]
	mov	bx,WORD PTR [bx+6]
	mov	BYTE PTR [bx+20],al
; Line 490
	jmp	SHORT C_ADLIB_$I590
; Line 491
C_ADLIB_$SC600:
; Line 492
	mov	al,BYTE PTR [bx]
	mov	bx,WORD PTR [bx+6]
	mov	BYTE PTR [bx+19],al
; Line 493
	jmp	SHORT C_ADLIB_$I590
; Line 494
C_ADLIB_$SB592:
; Line 497
	push	ax
	mov	bx,WORD PTR [bp+8]	;w
	mov	al,BYTE PTR [bx+2]
	push	ax
	push	WORD PTR [bp+4]	;v
	call	_snd_2FB1
	add	sp,6
; Line 498
; Line 499
C_ADLIB_$I590:
; Line 500
	test	BYTE PTR [bp-2],2	;changes
	je	C_ADLIB_$I602
	mov	bx,WORD PTR [bp+8]	;w
	cmp	BYTE PTR [bx+4],0
	je	C_ADLIB_$I602
; Line 501
; Line 502
	mov	bx,WORD PTR [bp+4]	;v
; Line 503
	mov	ah,BYTE PTR [bx+7]
; Line 504
	call	_snd_2FA0
; Line 505
; Line 506
; Line 507
C_ADLIB_$I602:
	pop	si
	leave	
	ret	

_snd_28FB	ENDP

; compiler-C _snd_29A1 (original order 29A1)
PUBLIC _snd_29A1
_snd_29A1	PROC NEAR
; Line 510
	push	bp
	mov	bp,sp
	push	di
	push	si
;	v = 4
;	e = 6
;	w = 8
;	flags = 10
;	data = 12
	mov	si,WORD PTR [bp+4]	;v
	mov	dx,WORD PTR [bp+8]	;w
; Line 511
	mov	bx,dx
	mov	WORD PTR [bx],0
; Line 512
	mov	al,BYTE PTR [bp+10]	;flags
	and	al,64	;0040H
	mov	BYTE PTR [bx+3],al
; Line 513
	mov	al,BYTE PTR [bp+10]	;flags
	and	al,32	;0020H
	mov	di,WORD PTR [bp+6]	;e
	mov	BYTE PTR [di+10],al
; Line 514
	mov	al,BYTE PTR [bp+10]	;flags
	and	al,16	;0010H
	mov	BYTE PTR [bx+4],al
; Line 515
	mov	bl,BYTE PTR [bp+10]	;flags
	and	bx,15	;000fH
	mov	al,BYTE PTR _snd_parameter_map[bx]
	mov	di,dx
	mov	BYTE PTR [di+2],al
; Line 516
	shl	bx,1
	mov	ax,WORD PTR _snd_max_values[bx]
	mov	bx,WORD PTR [bp+6]	;e
	mov	WORD PTR [bx+6],ax
; Line 517
	mov	BYTE PTR [bx+19],31	;001fH
; Line 518
	cmp	BYTE PTR [di+3],0
	je	C_ADLIB_$L777
	mov	bx,WORD PTR [si]
	mov	al,BYTE PTR [bx+24]
	shr	al,2
	jmp	SHORT C_ADLIB_$L778
	nop	
C_ADLIB_$L777:
	mov	al,31	;001fH
C_ADLIB_$L778:
	mov	bx,WORD PTR [bp+6]	;e
	mov	BYTE PTR [bx+20],al
; Line 519
	mov	bx,di
	mov	al,BYTE PTR [bx+2]
	sub	ah,ah
; Line 525
	cmp	ax,31	;001fH
	je	C_ADLIB_$SC621
	ja	C_ADLIB_$SD622
	or	al,al
	je	C_ADLIB_$SC618
	sub	al,13	;000dH
	je	C_ADLIB_$SC619
	sub	al,17	;0011H
	je	C_ADLIB_$SC620
; Line 524
C_ADLIB_$SD622:
	mov	bx,dx
	mov	al,BYTE PTR [bx+2]
	push	ax
	mov	al,BYTE PTR [si+7]
	push	ax
	call	_snd_304C
	add	sp,4
C_ADLIB_$L808:
	mov	bx,WORD PTR [bp+6]	;e
	mov	WORD PTR [bx+8],ax
; Line 525
	jmp	SHORT C_ADLIB_$SB615
; Line 520
C_ADLIB_$SC618:
	mov	al,BYTE PTR [si+9]
C_ADLIB_$L809:
	sub	ah,ah
	jmp	SHORT C_ADLIB_$L808
	nop	
; Line 521
C_ADLIB_$SC619:
	mov	al,BYTE PTR [si+10]
	jmp	SHORT C_ADLIB_$L809
	nop	
; Line 522
C_ADLIB_$SC620:
	mov	bx,WORD PTR [bp+6]	;e
	mov	WORD PTR [bx+8],31	;001fH
	mov	bx,dx
	mov	bx,WORD PTR [bx+6]
	mov	BYTE PTR [bx+20],0
	jmp	SHORT C_ADLIB_$SB615
	nop	
; Line 523
C_ADLIB_$SC621:
	mov	bx,WORD PTR [bp+6]	;e
	mov	WORD PTR [bx+8],0
	mov	bx,dx
	mov	bx,WORD PTR [bx+6]
	mov	BYTE PTR [bx+19],0
; Line 525
C_ADLIB_$SB615:
; Line 526
	push	WORD PTR [bp+12]	;data
	push	WORD PTR [bp+6]	;e
	call	_snd_2BF6
	add	sp,4
; Line 527
	pop	si
	pop	di
	leave	
	ret	
	nop	

_snd_29A1	ENDP

; compiler-C _snd_2A5E (original order 2A5E)
PUBLIC _snd_2A5E
_snd_2A5E	PROC NEAR
; Line 530
	push	bp
	mov	bp,sp
	push	di
	push	si
;	v = 4
;	parameter = 6
;	value = 8
	mov	di,WORD PTR [bp+6]	;parameter
; Line 531
	cmp	di,28	;001cH
	jge	C_ADLIB_$EX629
	mov	si,WORD PTR [bp+4]	;v
; Line 532
C_ADLIB_$F631:
	or	si,si
	je	C_ADLIB_$EX629
	push	WORD PTR [bp+8]	;value
	mov	ax,di
	push	ax
	push	si
	call	_snd_2FB1
	add	sp,6
	mov	si,WORD PTR [si+4]
	jmp	SHORT C_ADLIB_$F631
; Line 533
C_ADLIB_$EX629:
	pop	si
	pop	di
	leave	
	ret	

_snd_2A5E	ENDP

; compiler-C _snd_2A87 (original order 2A87)
PUBLIC _snd_2A87
_snd_2A87	PROC NEAR
; Line 536
	push	bp
	mov	bp,sp
	push	di
	push	si
;	v = 4
;	volume = 6
	mov	si,WORD PTR [bp+4]	;v
; Line 537
	jmp	SHORT C_ADLIB_$L810
C_ADLIB_$F639:
; Line 538
	mov	bl,BYTE PTR [bp+6]	;volume
	shr	bl,2
	sub	bh,bh
	mov	di,WORD PTR [si+9]
	and	di,255	;00ffH
	shl	di,5
	mov	al,BYTE PTR _snd_volume_products[bx][di]
	sub	ah,ah
	push	ax
	push	0
	push	si
	call	_snd_2FB1
	add	sp,6
; Line 539
	cmp	BYTE PTR [si+6],1
	jne	C_ADLIB_$FC640
; Line 540
	mov	bl,BYTE PTR [bp+6]	;volume
	shr	bl,2
	sub	bh,bh
	mov	di,WORD PTR [si+10]
	and	di,255	;00ffH
	shl	di,5
	mov	al,BYTE PTR _snd_volume_products[bx][di]
	sub	ah,ah
	push	ax
	push	13	;000dH
	push	si
	call	_snd_2FB1
	add	sp,6
; Line 537
C_ADLIB_$FC640:
	mov	si,WORD PTR [si+4]
C_ADLIB_$L810:
	or	si,si
	jne	C_ADLIB_$F639
; Line 542
	pop	si
	pop	di
	leave	
	ret	
	nop	

_snd_2A87	ENDP

; compiler-C _snd_2AD9 (original order 2AD9)
PUBLIC _snd_2AD9
_snd_2AD9	PROC NEAR
; Line 545
	push	bp
	mov	bp,sp
	push	si
;	v = 4
;	transpose = 6
	mov	si,WORD PTR [bp+4]	;v
; Line 546
	jmp	SHORT C_ADLIB_$L811
	nop	
C_ADLIB_$F648:
; Line 547
	mov	bx,WORD PTR [si]
	push	WORD PTR [bx+30]
	mov	al,BYTE PTR [si+8]
	add	al,BYTE PTR [bp+6]	;transpose
	push	ax
	mov	al,BYTE PTR [si+7]
	push	ax
	call	_snd_2F6F
	add	sp,6
; Line 546
	mov	si,WORD PTR [si+4]
C_ADLIB_$L811:
	or	si,si
	jne	C_ADLIB_$F648
; Line 548
	pop	si
	leave	
	ret	

_snd_2AD9	ENDP

; compiler-C _snd_2B03 (original order 2B03)
PUBLIC _snd_2B03
_snd_2B03	PROC NEAR
; Line 551
	push	bp
	mov	bp,sp
	push	si
;	v = 4
;	value = 6
	mov	si,WORD PTR [bp+4]	;v
; Line 552
	jmp	SHORT C_ADLIB_$L812
	nop	
C_ADLIB_$F656:
; Line 553
	cmp	BYTE PTR [si+14],0
	je	C_ADLIB_$I659
	cmp	BYTE PTR [si+51],0
	je	C_ADLIB_$I659
	mov	al,BYTE PTR [bp+6]	;value
	shr	al,2
	mov	BYTE PTR [si+34],al
; Line 554
C_ADLIB_$I659:
	cmp	BYTE PTR [si+56],0
	je	C_ADLIB_$FC657
	cmp	BYTE PTR [si+93],0
	je	C_ADLIB_$FC657
	mov	al,BYTE PTR [bp+6]	;value
	shr	al,2
	mov	BYTE PTR [si+76],al
; Line 552
C_ADLIB_$FC657:
	mov	si,WORD PTR [si+4]
C_ADLIB_$L812:
	or	si,si
	jne	C_ADLIB_$F656
; Line 556
	pop	si
	leave	
	ret	

_snd_2B03	ENDP

; compiler-C _snd_2B3F (original order 2B3F)
PUBLIC _snd_2B3F
_snd_2B3F	PROC NEAR
; Line 559
	push	bp
	mov	bp,sp
	push	di
	push	si
;	v = 4
;	pitch = 6
	mov	si,WORD PTR [bp+4]	;v
	mov	di,WORD PTR [bp+6]	;pitch
; Line 560
	jmp	SHORT C_ADLIB_$L813
	nop	
C_ADLIB_$F666:
; Line 561
	push	di
	mov	bx,WORD PTR [si]
	mov	al,BYTE PTR [bx+21]
	add	al,BYTE PTR [si+8]
	push	ax
	mov	al,BYTE PTR [si+7]
	push	ax
	call	_snd_2F6F
	add	sp,6
; Line 560
	mov	si,WORD PTR [si+4]
C_ADLIB_$L813:
	or	si,si
	jne	C_ADLIB_$F666
; Line 562
	pop	si
	pop	di
	leave	
	ret	
	nop	

_snd_2B3F	ENDP

; compiler-C _snd_2B6C (original order 2B6C)
PUBLIC _snd_2B6C
_snd_2B6C	PROC NEAR
; Line 565
	enter	2,0
	push	di
	push	si
;	priority = 4
;	register si = v
;	candidate = -2
;	register di = count
; Line 566
	mov	WORD PTR [bp-2],0	;candidate
; Line 567
	mov	di,9
; Line 568
C_ADLIB_$D675:
; Line 569
	inc	WORD PTR _snd_voice_counter
	cmp	WORD PTR _snd_voice_counter,8
	jbe	C_ADLIB_$I678
	mov	WORD PTR _snd_voice_counter,0
; Line 570
C_ADLIB_$I678:
; Line 571
	imul	si,WORD PTR _snd_voice_counter,98	;0062H
	add	si,OFFSET _snd_voices
	cmp	WORD PTR [si],0
	je	C_ADLIB_$L785
; Line 572
	cmp	WORD PTR [si+4],0
	jne	C_ADLIB_$DC676
	mov	al,BYTE PTR [bp+4]	;priority
	mov	bx,WORD PTR [si]
	cmp	BYTE PTR [bx+15],al
	ja	C_ADLIB_$DC676
; Line 573
	mov	al,BYTE PTR [bx+15]
	mov	BYTE PTR [bp+4],al	;priority
; Line 574
	mov	WORD PTR [bp-2],si	;candidate
; Line 576
C_ADLIB_$DC676:
	dec	di
	jne	C_ADLIB_$D675
	jmp	SHORT C_ADLIB_$L786
	nop	
C_ADLIB_$L785:
; Line 571
	mov	ax,si
	pop	si
	pop	di
	leave	
	ret	
C_ADLIB_$L786:
	mov	di,WORD PTR [bp-2]	;candidate
; Line 577
	or	di,di
	je	C_ADLIB_$I681
	push	di
	call	_snd_2BC4
	add	sp,2
; Line 578
C_ADLIB_$I681:
	mov	ax,di
; Line 579
	pop	si
	pop	di
	leave	
	ret	

_snd_2B6C	ENDP

; compiler-C _snd_2BC4 (original order 2BC4)
PUBLIC _snd_2BC4
_snd_2BC4	PROC NEAR
; Line 582
	enter	4,0
;	previous = -2
;	next = -4
;	v = 4
; Line 584
; Line 585
	mov	bx,WORD PTR [bp+4]	;v
; Line 586
	mov	ah,BYTE PTR [bx+7]
; Line 587
	call	_snd_2F94
; Line 588
; Line 589
	mov	bx,WORD PTR [bp+4]	;v
	mov	ax,WORD PTR [bx+2]
	mov	WORD PTR [bp-2],ax	;previous
; Line 590
	mov	cx,WORD PTR [bx+4]
	mov	WORD PTR [bp-4],cx	;next
; Line 591
	or	cx,cx
	je	C_ADLIB_$I687
	mov	bx,cx
	mov	WORD PTR [bx+2],ax
; Line 592
C_ADLIB_$I687:
	cmp	WORD PTR [bp-2],0	;previous
	je	C_ADLIB_$I688
	mov	ax,WORD PTR [bp-4]	;next
	mov	bx,WORD PTR [bp-2]	;previous
	mov	WORD PTR [bx+4],ax
; Line 593
	jmp	SHORT C_ADLIB_$I689
C_ADLIB_$I688:
	mov	ax,WORD PTR [bp-4]	;next
	mov	bx,WORD PTR [bp+4]	;v
	mov	bx,WORD PTR [bx]
	mov	WORD PTR [bx+6],ax
C_ADLIB_$I689:
; Line 594
	mov	bx,WORD PTR [bp+4]	;v
	mov	WORD PTR [bx],0
; Line 595
	leave	
	ret	

_snd_2BC4	ENDP

; compiler-C _snd_2BF6 (original order 2BF6)
PUBLIC _snd_2BF6
_snd_2BF6	PROC NEAR
; Line 598
	push	bp
	mov	bp,sp
	push	di
	push	si
;	e = 4
;	data = 6
	mov	di,WORD PTR [bp+6]	;data
	mov	si,WORD PTR [bp+4]	;e
; Line 599
	mov	BYTE PTR [si],1
; Line 600
	mov	WORD PTR [si+2],0
; Line 601
	mov	BYTE PTR [si+21],31	;001fH
; Line 603
	mov	al,BYTE PTR [di]
	sub	ah,ah
	mov	WORD PTR [si+4],ax
	or	ax,ax
	je	C_ADLIB_$I695
	mov	ax,63	;003fH
	imul	WORD PTR [si+4]
	mov	WORD PTR [si+4],ax
; Line 604
C_ADLIB_$I695:
	mov	al,BYTE PTR [di+1]
	mov	BYTE PTR [si+11],al
; Line 605
	mov	al,BYTE PTR [di+3]
	mov	BYTE PTR [si+12],al
; Line 606
	mov	al,BYTE PTR [di+5]
	mov	BYTE PTR [si+13],al
; Line 607
	mov	al,BYTE PTR [di+6]
	mov	BYTE PTR [si+14],al
; Line 608
	mov	al,BYTE PTR [di+2]
	mov	BYTE PTR [si+15],al
; Line 609
	mov	al,BYTE PTR [di+4]
	mov	BYTE PTR [si+16],al
; Line 610
	mov	BYTE PTR [si+17],0
; Line 611
	mov	al,BYTE PTR [di+7]
	mov	BYTE PTR [si+18],al
; Line 612
	push	si
	call	_snd_2C59
	add	sp,2
; Line 613
	pop	si
	pop	di
	leave	
	ret	

_snd_2BF6	ENDP

; compiler-C _snd_2C59 (original order 2C59)
PUBLIC _snd_2C59
_snd_2C59	PROC NEAR
; Line 616
	enter	12,0
	push	di
	push	si
;	level = -12
;	remainder = -4
;	direction = -5
;	e = 4
;	stage = -9
;	ticks = -2
;	difference = -8
;	maximum = -4
;	base = -6
	mov	di,WORD PTR [bp+4]	;e
; Line 617
	mov	al,BYTE PTR [di]
	dec	al
	mov	BYTE PTR [bp-9],al	;stage
; Line 622
	mov	cx,ax
	mov	al,BYTE PTR [di+19]
	cbw	
	mov	bl,cl
	sub	bh,bh
	mov	bl,BYTE PTR [bx+11][di]
	mov	cx,bx
	and	bx,127	;007fH
	shl	bx,5
	add	bx,ax
	mov	bl,BYTE PTR _snd_volume_products[bx]
	sub	bh,bh
	shl	bx,1
	mov	si,WORD PTR _snd_step_counts[bx]
; Line 623
	test	cl,128	;0080H
	je	C_ADLIB_$I707
	push	si
	call	_snd_2E7A
	add	sp,2
	mov	si,ax
; Line 624
C_ADLIB_$I707:
	mov	WORD PTR [bp-2],si	;ticks
	or	si,si
	jne	C_ADLIB_$I708
	mov	WORD PTR [bp-2],1	;ticks
; Line 625
C_ADLIB_$I708:
	mov	ax,WORD PTR [bp-2]	;ticks
	mov	WORD PTR [di+24],ax
	mov	WORD PTR [di+22],ax
; Line 626
	cmp	BYTE PTR [bp-9],2	;stage
	jne	C_ADLIB_$I709
	xor	si,si
; Line 627
	jmp	SHORT C_ADLIB_$I710
C_ADLIB_$I709:
; Line 628
	mov	ax,WORD PTR [di+6]
	mov	WORD PTR [bp-4],ax	;remainder
; Line 629
	mov	ax,WORD PTR [di+8]
	mov	WORD PTR [bp-6],ax	;base
; Line 631
	mov	bl,BYTE PTR [bp-9]	;stage
	sub	bh,bh
	mov	al,BYTE PTR [bx+15][di]
	mov	cx,ax
	and	al,127	;007fH
	sub	al,31	;001fH
	push	ax
	push	WORD PTR [bp-4]	;remainder
	mov	WORD PTR [bp-12],cx	;level
	call	_snd_2DD3
	add	sp,4
	mov	WORD PTR [bp-8],ax	;difference
; Line 632
	test	BYTE PTR [bp-12],128	;0080H	;level
	je	C_ADLIB_$I711
	push	ax
	call	_snd_2E7A
	add	sp,2
	mov	WORD PTR [bp-8],ax	;difference
; Line 633
C_ADLIB_$I711:
	mov	ax,WORD PTR [bp-6]	;base
	add	ax,WORD PTR [bp-8]	;difference
	cmp	ax,WORD PTR [bp-4]	;remainder
	jle	C_ADLIB_$I712
	mov	si,WORD PTR [bp-4]	;remainder
	sub	si,WORD PTR [bp-6]	;base
; Line 634
	jmp	SHORT C_ADLIB_$I713
	nop	
C_ADLIB_$I712:
	mov	si,WORD PTR [bp-8]	;difference
	mov	ax,WORD PTR [bp-6]	;base
	add	ax,si
	jns	C_ADLIB_$I713
	mov	si,WORD PTR [bp-6]	;base
	neg	si
; Line 635
C_ADLIB_$I713:
	sub	si,WORD PTR [di+2]
; Line 636
C_ADLIB_$I710:
; Line 637
	mov	ax,si
	mov	cx,si
	cwd	
	idiv	WORD PTR [bp-2]	;ticks
	mov	WORD PTR [di+26],ax
; Line 638
	mov	ax,cx
	cwd	
	idiv	WORD PTR [bp-2]	;ticks
	mov	WORD PTR [bp-4],dx	;remainder
; Line 639
	mov	BYTE PTR [bp-5],1	;direction
; Line 640
	or	cx,cx
	jge	C_ADLIB_$I715
; Line 641
	neg	WORD PTR [bp-4]	;remainder
; Line 642
	mov	BYTE PTR [bp-5],255	;00ffH	;direction
; Line 644
C_ADLIB_$I715:
	mov	al,BYTE PTR [bp-5]	;direction
	mov	BYTE PTR [di+28],al
; Line 645
	mov	ax,WORD PTR [bp-4]	;remainder
	mov	WORD PTR [di+30],ax
; Line 646
	mov	WORD PTR [di+32],0
; Line 647
	pop	si
	pop	di
	leave	
	ret	

_snd_2C59	ENDP

; compiler-C _snd_2D33 (original order 2D33)
PUBLIC _snd_2D33
_snd_2D33	PROC NEAR
; Line 650
	enter	2,0
	push	di
	push	si
;	e = 4
;	w = 6
;	changed = -2
;	register dx = total
;	register si = value
; Line 651
	mov	WORD PTR [bp-2],0	;changed
; Line 653
	mov	bx,WORD PTR [bp+4]	;e
	cmp	WORD PTR [bx+4],0
	je	C_ADLIB_$I724
; Line 655
	sub	WORD PTR [bx+4],17	;0011H
	cmp	WORD PTR [bx+4],0
	jg	C_ADLIB_$I724
; Line 656
	mov	bx,WORD PTR [bp+4]	;e
	xor	ax,ax
	mov	BYTE PTR [bx],al
; Line 657
	pop	si
	pop	di
	leave	
	ret	
	nop	
; Line 660
C_ADLIB_$I724:
	mov	bx,WORD PTR [bp+4]	;e
	mov	si,WORD PTR [bx+2]
	add	si,WORD PTR [bx+26]
; Line 661
	mov	dx,WORD PTR [bx+22]
; Line 663
	mov	ax,WORD PTR [bx+30]
	add	WORD PTR [bx+32],ax
	cmp	WORD PTR [bx+32],dx
	jb	C_ADLIB_$I726
; Line 664
	mov	bx,WORD PTR [bp+4]	;e
	sub	WORD PTR [bx+32],dx
; Line 665
	mov	al,BYTE PTR [bx+28]
	cbw	
	add	si,ax
; Line 667
C_ADLIB_$I726:
	mov	bx,WORD PTR [bp+4]	;e
	cmp	WORD PTR [bx+2],si
	jne	C_ADLIB_$I728
	mov	al,BYTE PTR [bx+21]
	cmp	BYTE PTR [bx+20],al
	je	C_ADLIB_$L787
C_ADLIB_$I728:
; Line 668
	mov	WORD PTR [bx+2],si
; Line 669
	mov	al,BYTE PTR [bx+20]
	mov	BYTE PTR [bx+21],al
; Line 670
	mov	al,BYTE PTR [bx+20]
	push	ax
	push	si
	call	_snd_2DD3
	add	sp,4
	mov	si,ax
	mov	di,WORD PTR [bp-2]	;changed
; Line 671
	mov	bx,WORD PTR [bp+6]	;w
	cmp	WORD PTR [bx],si
	je	C_ADLIB_$I727
; Line 672
	mov	WORD PTR [bx],si
; Line 673
	mov	di,1
; Line 676
C_ADLIB_$I727:
	mov	bx,WORD PTR [bp+4]	;e
	dec	WORD PTR [bx+24]
	jne	C_ADLIB_$I730
; Line 677
	mov	bx,WORD PTR [bp+4]	;e
	inc	BYTE PTR [bx]
	cmp	BYTE PTR [bx],4
	jbe	C_ADLIB_$I731
; Line 678
	mov	bx,WORD PTR [bp+4]	;e
	cmp	BYTE PTR [bx+10],0
	je	C_ADLIB_$I732
; Line 679
	mov	BYTE PTR [bx],1
; Line 680
	or	di,2
; Line 681
	jmp	SHORT C_ADLIB_$I731
	nop	
C_ADLIB_$L787:
	mov	di,WORD PTR [bp-2]	;changed
	jmp	SHORT C_ADLIB_$I727
	nop	
C_ADLIB_$I732:
; Line 682
	mov	BYTE PTR [bx],0
	jmp	SHORT C_ADLIB_$I730
	nop	
; Line 686
C_ADLIB_$I731:
	push	WORD PTR [bp+4]	;e
	call	_snd_2C59
	add	sp,2
; Line 688
C_ADLIB_$I730:
	mov	ax,di
; Line 689
	pop	si
	pop	di
	leave	
	ret	
	nop	

_snd_2D33	ENDP

; compiler-C _snd_2DD3 (original order 2DD3)
PUBLIC _snd_2DD3
_snd_2DD3	PROC NEAR
; Line 692
	push	bp
	mov	bp,sp
	push	di
	push	si
;	value = 4
;	scale = 6
; Line 693
	cmp	BYTE PTR [bp+6],0	;scale
	jne	C_ADLIB_$I739
	xor	ax,ax
	pop	si
	pop	di
	leave	
	ret	
	nop	
; Line 694
C_ADLIB_$I739:
	cmp	BYTE PTR [bp+6],31	;001fH	;scale
	jne	C_ADLIB_$I740
	mov	ax,WORD PTR [bp+4]	;value
	pop	si
	pop	di
	leave	
	ret	
	nop	
; Line 695
C_ADLIB_$I740:
	mov	si,WORD PTR [bp+4]	;value
	cmp	si,63	;003fH
	jg	C_ADLIB_$I741
	cmp	si,-63	;ffc1H
	jl	C_ADLIB_$I741
; Line 696
	cmp	BYTE PTR [bp+6],0	;scale
	jge	C_ADLIB_$I742
	or	si,si
	jge	C_ADLIB_$I743
	mov	al,BYTE PTR [bp+6]	;scale
	cbw	
	mov	bx,OFFSET _snd_volume_products
	sub	bx,ax
	mov	ax,si
	shl	ax,5
	sub	bx,ax
	mov	al,BYTE PTR [bx]
C_ADLIB_$L815:
	sub	ah,ah
	pop	si
	pop	di
	leave	
	ret	
	nop	
C_ADLIB_$I743:
	mov	al,BYTE PTR [bp+6]	;scale
	cbw	
	mov	bx,si
	shl	bx,5
	jmp	SHORT C_ADLIB_$L814
	nop	
C_ADLIB_$I742:
	or	si,si
	jge	C_ADLIB_$I745
	mov	al,BYTE PTR [bp+6]	;scale
	cbw	
	mov	bx,ax
	mov	ax,si
	shl	ax,5
C_ADLIB_$L814:
	sub	bx,ax
	mov	al,BYTE PTR _snd_volume_products[bx]
	sub	ah,ah
	neg	ax
	pop	si
	pop	di
	leave	
	ret	
	nop	
C_ADLIB_$I745:
	mov	bx,si
	shl	bx,5
	mov	al,BYTE PTR [bp+6]	;scale
	cbw	
	mov	di,ax
	mov	al,BYTE PTR _snd_volume_products[bx][di]
	jmp	SHORT C_ADLIB_$L815
	nop	
; Line 704
C_ADLIB_$I741:
	mov	al,BYTE PTR [bp+6]	;scale
	cbw	
	mov	cx,ax
	lea	ax,WORD PTR [si+1]
	imul	cx
	sar	dx,1
	rcr	ax,1
	sar	dx,1
	rcr	ax,1
	sar	dx,1
	rcr	ax,1
	sar	dx,1
	rcr	ax,1
	sar	dx,1
	rcr	ax,1
; Line 705
	pop	si
	pop	di
	leave	
	ret	
	nop	

_snd_2DD3	ENDP

; compiler-C _snd_2E7A (original order 2E7A)
PUBLIC _snd_2E7A
_snd_2E7A	PROC NEAR
; Line 708
	enter	2,0
;	value = 4
;	bit = -2
;	state = -1
; Line 713
	mov	al,BYTE PTR _snd_random_seed
	shr	al,1
	mov	BYTE PTR [bp-1],al	;state
; Line 714
	test	BYTE PTR _snd_random_seed,1
	je	C_ADLIB_$I751
	xor	BYTE PTR [bp-1],184	;00b8H	;state
; Line 715
C_ADLIB_$I751:
; Line 716
	mov	al,BYTE PTR [bp-1]	;state
	mov	BYTE PTR _snd_random_seed,al
	sub	ah,ah
	imul	WORD PTR [bp+4]	;value
	mov	al,ah
	mov	ah,dl
	mov	dl,dh
	shl	dh,1
	sbb	dh,dh
; Line 717
	leave	
	ret	

_snd_2E7A	ENDP

; register-ABI-ASM ADIO (original order 2E9B)

public _snd_2E9B
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

public _snd_2F48
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

public _snd_2F6F
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

public _snd_2F94
_snd_2F94 label near
    add ah, 0B0h ; 2F94
    call near ptr _snd_316E ; 2F97
    and al, 0DFh ; 2F9A
    call near ptr _snd_312B ; 2F9C
    ret  ; 2F9F

public _snd_2FA0
_snd_2FA0 label near
    add ah, 0B0h ; 2FA0
    call near ptr _snd_316E ; 2FA3
    and al, 0DFh ; 2FA6
    call near ptr _snd_312B ; 2FA8
    or al, 020h ; 2FAB
    call near ptr _snd_312B ; 2FAD
    ret  ; 2FB0

public _snd_2FB1
_snd_2FB1 label near
    enter 0, 0 ; 2FB1
    push si ; 2FB5
    mov si, word ptr [bp + 4] ; 2FB6
    mov al, byte ptr [bp + 6] ; 2FB9
    xor ah, ah ; 2FBC
    cmp al, 0Ch ; 2FBE
    jbe short A_ADIO_L2FD5 ; 2FC0
    cmp al, 019h ; 2FC2
    jbe short A_ADIO_L2FE0 ; 2FC4
    cmp al, 01Bh ; 2FC6
    jbe short A_ADIO_L2FED ; 2FC8
    cmp al, 01Ch ; 2FCA
    je short A_ADIO_L3024 ; 2FCC
    cmp al, 01Dh ; 2FCE
    je short A_ADIO_L302C ; 2FD0
    pop si ; 2FD2
    leave  ; 2FD3
    ret  ; 2FD4
A_ADIO_L2FD5:
    mov bl, byte ptr [si + 7] ; 2FD5
    xor bh, bh ; 2FD8
    mov dl, byte ptr [bx + _snd_carrier_slots] ; 2FDA
    jmp short A_ADIO_L2FF2 ; 2FDE
A_ADIO_L2FE0:
    sub al, 0Dh ; 2FE0
    mov bl, byte ptr [si + 7] ; 2FE2
    xor bh, bh ; 2FE5
    mov dl, byte ptr [bx + _snd_modulator_slots] ; 2FE7
    jmp short A_ADIO_L2FF2 ; 2FEB
A_ADIO_L2FED:
    sub al, 0Dh ; 2FED
    mov dl, byte ptr [si + 7] ; 2FEF
A_ADIO_L2FF2:
    mov dh, byte ptr [bp + 8] ; 2FF2
    mov bx, ax ; 2FF5
    shl bx, 2 ; 2FF7
    mov al, byte ptr [bx + _snd_register_fields+3] ; 2FFA
    or al, al ; 2FFE
    je short A_ADIO_L3006 ; 3000
    sub al, dh ; 3002
    mov dh, al ; 3004
A_ADIO_L3006:
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
    jmp short A_ADIO_L3049 ; 3022
A_ADIO_L3024:
    mov ax, word ptr [bp + 8] ; 3024
    sub ax, 0Fh ; 3027
    jmp short A_ADIO_L3032 ; 302A
A_ADIO_L302C:
    mov ax, word ptr [bp + 8] ; 302C
    sub ax, 017Fh ; 302F
A_ADIO_L3032:
    shl ax, 4 ; 3032
    mov bl, byte ptr [si + 7] ; 3035
    xor bh, bh ; 3038
    shl bx, 1 ; 303A
    mov word ptr [bx + _snd_channel_frequency+18], ax ; 303C
    add ax, word ptr [bx + _snd_channel_frequency] ; 3040
    shr bx, 1 ; 3044
    call near ptr _snd_30C4 ; 3046
A_ADIO_L3049:
    pop si ; 3049
    leave  ; 304A
    ret  ; 304B

public _snd_304C
_snd_304C label near
    enter 0, 0 ; 304C
    push di ; 3050
    push si ; 3051
    mov al, byte ptr [bp + 6] ; 3052
    xor ah, ah ; 3055
    cmp al, 0Ch ; 3057
    jbe short A_ADIO_L306F ; 3059
    cmp al, 019h ; 305B
    jbe short A_ADIO_L307A ; 305D
    cmp al, 01Bh ; 305F
    jbe short A_ADIO_L3087 ; 3061
    cmp al, 01Ch ; 3063
    je short A_ADIO_L30B8 ; 3065
    cmp al, 01Dh ; 3067
    je short A_ADIO_L30BD ; 3069
    xor ax, ax ; 306B
    jmp short A_ADIO_L30C0 ; 306D
A_ADIO_L306F:
    mov bl, byte ptr [bp + 4] ; 306F
    xor bh, bh ; 3072
    mov dl, byte ptr [bx + _snd_carrier_slots] ; 3074
    jmp short A_ADIO_L308E ; 3078
A_ADIO_L307A:
    sub al, 0Dh ; 307A
    mov bl, byte ptr [bp + 4] ; 307C
    xor bh, bh ; 307F
    mov dl, byte ptr [bx + _snd_modulator_slots] ; 3081
    jmp short A_ADIO_L308E ; 3085
A_ADIO_L3087:
    sub al, 0Dh ; 3087
    mov bl, byte ptr [bp + 4] ; 3089
    mov dl, bl ; 308C
A_ADIO_L308E:
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
    je short A_ADIO_L30C0 ; 30B0
    sub cl, al ; 30B2
    mov al, cl ; 30B4
    jmp short A_ADIO_L30C0 ; 30B6
A_ADIO_L30B8:
    mov ax, 0Fh ; 30B8
    jmp short A_ADIO_L30C0 ; 30BB
A_ADIO_L30BD:
    mov ax, 017Fh ; 30BD
A_ADIO_L30C0:
    pop si ; 30C0
    pop di ; 30C1
    leave  ; 30C2
    ret  ; 30C3

; register-ABI-ASM SNDTAIL (original order 30C4)
public _snd_30C4,_snd_312B,_snd_3164,_snd_316E
public _snd_3179,_snd_31AA,_snd_320A,__aNulmul,__aFuldiv

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
    jz short A_SNDTAIL_make_frequency
    and ch,0dfh
    cmp cl,ch
    ja short A_SNDTAIL_rising_octave
    jb short A_SNDTAIL_falling_octave
    jmp short A_SNDTAIL_make_frequency
A_SNDTAIL_rising_octave:
    cmp dh,6
    jae short A_SNDTAIL_make_frequency
    add dh,12
    sub cl,4
    jmp short A_SNDTAIL_make_frequency
A_SNDTAIL_falling_octave:
    cmp dh,11
    jbe short A_SNDTAIL_make_frequency
    sub dh,12
    add cl,4
A_SNDTAIL_make_frequency:
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
    je short A_SNDTAIL_opl_write_done
A_SNDTAIL_opl_write:
    mov byte ptr [bx+_snd_opl_cache],al
    xchg al,ah
    mov dx,0388h
    out dx,al
    mov cx,word ptr _snd_opl_index_delay
    nop
A_SNDTAIL_opl_index_wait:
    in al,dx
    and al,0
    cmp al,0ffh
    loopne A_SNDTAIL_opl_index_wait
    xchg al,ah
    inc dx
    out dx,al
    dec dx
    mov cx,word ptr _snd_opl_data_delay
A_SNDTAIL_opl_data_wait:
    in al,dx
    and al,0
    cmp al,0ffh
    loopne A_SNDTAIL_opl_data_wait
A_SNDTAIL_opl_write_done:
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
    jmp short A_SNDTAIL_opl_write
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
    jnz short A_SNDTAIL_multiply_wide
    mov ax,[bp+4]
    mul cx
    leave
    ret 8
A_SNDTAIL_multiply_wide:
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
    jnz short A_SNDTAIL_divide_wide
    mov cx,[bp+0ah]
    mov ax,[bp+8]
    xor dx,dx
    div cx
    mov bx,ax
    mov ax,[bp+6]
    div cx
    mov dx,bx
    jmp short A_SNDTAIL_divide_done
A_SNDTAIL_divide_wide:
    mov cx,ax
    mov bx,[bp+0ah]
    mov dx,[bp+8]
    mov ax,[bp+6]
A_SNDTAIL_divide_normalize:
    shr cx,1
    rcr bx,1
    shr dx,1
    rcr ax,1
    or cx,cx
    jnz short A_SNDTAIL_divide_normalize
    div bx
    mov si,ax
    mul word ptr [bp+0ch]
    xchg cx,ax
    mov ax,[bp+0ah]
    mul si
    add dx,cx
    jc short A_SNDTAIL_quotient_high
    cmp dx,[bp+8]
    ja short A_SNDTAIL_quotient_high
    jb short A_SNDTAIL_quotient_ready
    cmp ax,[bp+6]
    jbe short A_SNDTAIL_quotient_ready
A_SNDTAIL_quotient_high:
    dec si
A_SNDTAIL_quotient_ready:
    xor dx,dx
    xchg si,ax
A_SNDTAIL_divide_done:
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
    jnz short A_SNDTAIL_no_opl
    mov ax,02c0h
    call near ptr _snd_3164
    mov cx,20
    mov ax,02104h
    out dx,al
    nop
A_SNDTAIL_probe_initial_wait:
    in al,dx
    loop A_SNDTAIL_probe_initial_wait
    mov al,ah
    inc dx
    cli
    out dx,al
    dec dx
    nop
A_SNDTAIL_probe_timer_wait:
    in al,dx
    and al,0e0h
    cmp al,0c0h
    loopne A_SNDTAIL_probe_timer_wait
    sti
    jne short A_SNDTAIL_no_opl
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
    jz short A_SNDTAIL_round_data_up
    shl dx,1
    cmp dx,bx
    jb short A_SNDTAIL_store_data_wait
A_SNDTAIL_round_data_up:
    inc ax
A_SNDTAIL_store_data_wait:
    mov word ptr _snd_opl_data_delay,ax
    mov ax,cx
    xor dx,dx
    mov bx,1551
    div bx
    or ax,ax
    jz short A_SNDTAIL_round_index_up
    shl dx,1
    cmp dx,bx
    jb short A_SNDTAIL_store_index_wait
A_SNDTAIL_round_index_up:
    inc ax
A_SNDTAIL_store_index_wait:
    mov word ptr _snd_opl_index_delay,ax
    xor ax,ax
    ret
A_SNDTAIL_no_opl:
    mov ax,-1
    ret

; compiler-C _snd_3283 (original order 3283)
PUBLIC _snd_3283
_snd_3283	PROC NEAR
; Line 508
	enter	2,0
	push	si
;	register si = player
;	i = -1
; Line 509
	mov	si,OFFSET _snd_players
; Line 510
	mov	BYTE PTR [bp-1],0	;i
; Line 511
C_SOUND_$D637:
; Line 512
	mov	BYTE PTR [si+6],0
; Line 513
	mov	al,BYTE PTR [bp-1]	;i
	sub	ah,ah
	imul	cx,ax,52	;0034H
	add	cx,OFFSET _snd_sequences
	mov	WORD PTR [si],cx
; Line 514
	mov	bx,cx
	mov	WORD PTR [bx],si
; Line 515
	imul	ax,ax,66	;0042H
	add	ax,OFFSET _snd_hooks
	mov	WORD PTR [si+2],ax
; Line 516
	add	si,18	;0012H
; Line 517
	inc	BYTE PTR [bp-1]	;i
	cmp	BYTE PTR [bp-1],2	;i
	jb	C_SOUND_$D637
; Line 518
	pop	si
	leave	
	ret	

_snd_3283	ENDP

; compiler-C _snd_32AF (original order 32AF)
PUBLIC _snd_32AF
_snd_32AF	PROC NEAR
; Line 519
;	register bx = sequence
;	register dx = count
; Line 520
	mov	bx,OFFSET _snd_sequences
; Line 521
	mov	dx,2
; Line 522
C_SOUND_$D643:
; Line 523
	mov	BYTE PTR [bx+2],0
; Line 524
	add	bx,52	;0034H
; Line 525
	dec	dx
	jne	C_SOUND_$D643
; Line 526
	mov	WORD PTR _snd_tick_period,-29577	;8c77H
	mov	WORD PTR _snd_tick_period+2,36	;0024H
; Line 527
	mov	BYTE PTR _snd_parse_nesting,0
; Line 528
	ret	

_snd_32AF	ENDP

; compiler-C _snd_32CF (original order 32CF)
PUBLIC _snd_32CF
_snd_32CF	PROC NEAR
; Line 529
;	register bx = node
;	register dx = previous
;	register cx = count
; Line 530
	mov	bx,OFFSET _snd_held_notes
; Line 531
	mov	cx,24	;0018H
; Line 532
	xor	dx,dx
	mov	WORD PTR _snd_held_active,dx
	mov	WORD PTR _snd_held_cursor,dx
; Line 533
C_SOUND_$D650:
; Line 534
	mov	WORD PTR [bx+2],dx
; Line 535
	mov	dx,bx
; Line 536
	add	bx,20	;0014H
; Line 537
	dec	cx
	jne	C_SOUND_$D650
; Line 538
	mov	WORD PTR _snd_held_free,dx
; Line 539
	ret	

_snd_32CF	ENDP

; compiler-C _snd_32EB (original order 32EB)
PUBLIC _snd_32EB
_snd_32EB	PROC NEAR
; Line 540
;	register bx = fade
;	register dx = count
; Line 541
	mov	bx,OFFSET _snd_fades
; Line 542
	mov	dx,2
; Line 543
C_SOUND_$D656:
	mov	BYTE PTR [bx],0
	add	bx,16	;0010H
	dec	dx
	jne	C_SOUND_$D656
; Line 544
	mov	BYTE PTR _snd_fade_state,0
; Line 545
	mov	WORD PTR _snd_fade_tick_scale,1
; Line 546
	ret	
	nop	

_snd_32EB	ENDP

; compiler-C _snd_3303 (original order 3303)
PUBLIC _snd_3303
_snd_3303	PROC NEAR
; Line 547
	enter	2,0
	push	si
;	register si = part
;	i = -1
; Line 548
	mov	si,OFFSET _snd_parts
; Line 549
	mov	BYTE PTR [bp-1],0	;i
; Line 550
C_SOUND_$D662:
; Line 552
	xor	ax,ax
	mov	WORD PTR [si],ax
	mov	WORD PTR [si+2],ax
; Line 554
	mov	WORD PTR [si+4],ax
	mov	WORD PTR [si+6],ax
; Line 555
	mov	al,30	;001eH
	mul	BYTE PTR [bp-1]	;i
	add	ax,OFFSET _snd_part_instruments
	mov	WORD PTR [si+8],ax
; Line 556
	add	si,32	;0020H
; Line 557
	inc	BYTE PTR [bp-1]	;i
	cmp	BYTE PTR [bp-1],32	;0020H	;i
	jb	C_SOUND_$D662
; Line 558
	call	FAR PTR _snd_1DDB
; Line 559
	pop	si
	leave	
	ret	

_snd_3303	ENDP

; compiler-C _snd_332F (original order 332F)
PUBLIC _snd_332F
_snd_332F	PROC NEAR
; Line 560
	push	di
;	row = -4
;	x = -2
;	register bx = y
;	register dx = product
; Line 561
	mov	di,OFFSET _snd_volume_products
; Line 562
	xor	cx,cx
; Line 563
C_SOUND_$D670:
; Line 564
	xor	bx,bx
; Line 565
	mov	dx,cx
; Line 566
C_SOUND_$D673:
; Line 567
	mov	ax,dx
	sar	ax,5
	mov	BYTE PTR [bx][di],al
; Line 568
	add	dx,cx
; Line 569
	inc	bx
	cmp	bx,32	;0020H
	jl	C_SOUND_$D673
; Line 570
	inc	cx
; Line 572
	add	di,32	;0020H
	cmp	di,OFFSET _snd_volume_products+2048
	jb	C_SOUND_$D670
; Line 573
	mov	bx,OFFSET _snd_volume_products
; Line 574
	mov	dx,64	;0040H
; Line 575
C_SOUND_$D676:
	mov	BYTE PTR [bx],0
	add	bx,32	;0020H
	dec	dx
	jne	C_SOUND_$D676
; Line 576
	pop	di
	ret	

_snd_332F	ENDP

; compiler-C _snd_3362 (original order 3362)
PUBLIC _snd_3362
_snd_3362	PROC NEAR
; Line 577
; Line 578
	xor	ax,ax
	mov	BYTE PTR _snd_building_queue,al
; Line 580
	mov	WORD PTR _snd_queue_write,ax
	mov	WORD PTR _snd_queue_read,ax
; Line 581
	mov	WORD PTR _snd_trigger_count,ax
; Line 582
	ret	
	nop	

_snd_3362	ENDP
SOUND_TEXT ends
end
