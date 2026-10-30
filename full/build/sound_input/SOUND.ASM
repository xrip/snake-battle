;	Static Name Aliases
;
	TITLE   sound.c
	.286p
	.287
INCLUDELIB      SLIBCE
INCLUDELIB	OLDNAMES.LIB
_TEXT	SEGMENT  WORD PUBLIC 'CODE'
_TEXT	ENDS
_DATA	SEGMENT  WORD PUBLIC 'DATA'
_DATA	ENDS
CONST	SEGMENT  WORD PUBLIC 'CONST'
CONST	ENDS
_BSS	SEGMENT  WORD PUBLIC 'BSS'
_BSS	ENDS
DGROUP	GROUP	CONST, _BSS, _DATA
	ASSUME DS: DGROUP, SS: DGROUP
EXTRN	_snd_00B4:NEAR
EXTRN	_snd_00E7:NEAR
EXTRN	_snd_320A:NEAR
EXTRN	_snd_0DB9:NEAR
EXTRN	_snd_0E6A:NEAR
EXTRN	_snd_0E7C:NEAR
EXTRN	_snd_101E:NEAR
EXTRN	_snd_1041:NEAR
EXTRN	_snd_1086:NEAR
EXTRN	_snd_11F0:NEAR
EXTRN	_snd_1263:NEAR
EXTRN	_snd_12D8:NEAR
EXTRN	_snd_15DF:NEAR
EXTRN	_snd_162A:NEAR
EXTRN	_snd_167E:NEAR
EXTRN	_snd_1684:NEAR
EXTRN	_snd_16A5:NEAR
EXTRN	_snd_17FC:NEAR
EXTRN	_snd_183E:NEAR
EXTRN	_snd_1D6D:NEAR
EXTRN	_snd_1DDB:FAR
EXTRN	_snd_1E1A:NEAR
EXTRN	_snd_1FCC:NEAR
EXTRN	_snd_20E7:NEAR
EXTRN	_snd_21EF:NEAR
EXTRN	_snd_2209:NEAR
EXTRN	_snd_22F1:NEAR
EXTRN	_snd_235A:NEAR
EXTRN	_snd_23D1:NEAR
EXTRN	_snd_23D2:NEAR
EXTRN	_snd_247E:NEAR
EXTRN	_snd_261A:NEAR
EXTRN	__aNulmul:NEAR
EXTRN	_snd_tick_period:DWORD
EXTRN	_snd_parse_nesting:BYTE
EXTRN	_snd_parse_finished:BYTE
EXTRN	_snd_parse_cursor:DWORD
EXTRN	_snd_players:BYTE
EXTRN	_snd_sequences:BYTE
EXTRN	_snd_hooks:BYTE
EXTRN	_snd_held_notes:BYTE
EXTRN	_snd_held_active:WORD
EXTRN	_snd_held_free:WORD
EXTRN	_snd_held_cursor:WORD
EXTRN	_snd_fade_tick_scale:WORD
EXTRN	_snd_fade_state:BYTE
EXTRN	_snd_fades:BYTE
EXTRN	_snd_queue_read:WORD
EXTRN	_snd_queue_write:WORD
EXTRN	_snd_queue:BYTE
EXTRN	_snd_building_queue:BYTE
EXTRN	_snd_queued_marker:BYTE
EXTRN	_snd_queued_sound:WORD
EXTRN	_snd_trigger_count:WORD
EXTRN	_snd_scanning:WORD
EXTRN	_snd_parts:BYTE
EXTRN	_snd_part_instruments:BYTE
EXTRN	_snd_volume_products:BYTE
EXTRN	_snd_basic_commands:BYTE
EXTRN	_snd_extended_commands:BYTE
EXTRN	_snd_command_kinds:BYTE
EXTRN	_snd_midi_tags:QWORD
EXTRN	_snd_paused:WORD
EXTRN	_snd_disabled:WORD
EXTRN	_snd_master_volume:WORD
EXTRN	_snd_resources:DWORD
_TEXT      SEGMENT
	ASSUME	CS: _TEXT
	PUBLIC	_snd_000C
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
	PUBLIC	_snd_001E
_snd_001E	PROC FAR
; Line 9
	call	_snd_01A7
	ret	

_snd_001E	ENDP
	PUBLIC	_snd_0022
_snd_0022	PROC FAR
; Line 10
	call	_snd_01CB
	ret	

_snd_0022	ENDP
	PUBLIC	_snd_0026
_snd_0026	PROC FAR
; Line 11
	call	_snd_01D5
	ret	

_snd_0026	ENDP
	PUBLIC	_snd_002A
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
	PUBLIC	_snd_0039
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
	PUBLIC	_snd_0048
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
	PUBLIC	_snd_0057
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
	PUBLIC	_snd_00FE
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
	je	$SC284
	dec	ax
	je	$SC286
	jmp	SHORT $SB281
; Line 22
$SC284:
; Line 23
	cmp	dx,14	;000eH
	jge	$SB281
	mov	bx,dx
	shl	bx,1
	cmp	WORD PTR _snd_basic_commands[bx],0
	je	$SB281
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
$SC286:
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
	jmp	SHORT $L723
; Line 28
$SB281:
; Line 29
	mov	ax,-1	;ffffH
$L723:
	cwd	
; Line 30
	leave	
	ret	

_snd_00FE	ENDP
	PUBLIC	_snd_0158
_snd_0158	PROC NEAR
; Line 32
	push	bp
	mov	bp,sp
;	resources = 4
; Line 33
	call	_snd_320A
	or	ax,ax
	jne	$I290
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
$I290:
	mov	ax,-1	;ffffH
	cwd	
; Line 51
	leave	
	ret	

_snd_0158	ENDP
	PUBLIC	_snd_01A7
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
	PUBLIC	_snd_01CB
_snd_01CB	PROC NEAR
; Line 64
	mov	WORD PTR _snd_paused,1
	xor	ax,ax
	cwd	
	ret	

_snd_01CB	ENDP
	PUBLIC	_snd_01D5
_snd_01D5	PROC NEAR
; Line 65
	xor	ax,ax
	mov	WORD PTR _snd_paused,ax
	cwd	
	ret	
	nop	

_snd_01D5	ENDP
	PUBLIC	_snd_01DC
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
	jbe	$I299
	mov	BYTE PTR [bp+4],127	;007fH	;volume
; Line 71
$I299:
	mov	al,BYTE PTR [bp+4]	;volume
	cbw	
	mov	WORD PTR _snd_master_volume,ax
; Line 72
	mov	si,OFFSET _snd_players
; Line 73
	mov	di,2
; Line 74
$D300:
; Line 75
	cmp	BYTE PTR [si+6],0
	je	$I303
	mov	al,BYTE PTR [si+13]
	push	ax
	push	si
	call	_snd_075E
	add	sp,4
; Line 76
$I303:
	add	si,18	;0012H
; Line 77
	dec	di
	jne	$D300
; Line 78
	xor	ax,ax
	cwd	
; Line 79
	pop	si
	pop	di
	leave	
	ret	

_snd_01DC	ENDP
	PUBLIC	_snd_0217
_snd_0217	PROC NEAR
; Line 80
	mov	ax,WORD PTR _snd_master_volume
	cwd	
	ret	
	nop	

_snd_0217	ENDP
	PUBLIC	_snd_021C
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
	je	$I309
; Line 86
	push	128	;0080H
	call	_snd_05A6
	add	sp,2
	mov	si,ax
	or	si,si
	je	$I309
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
	je	$I309
	xor	ax,ax
	cwd	
	pop	si
	pop	di
	leave	
	ret	
; Line 91
$I309:
	mov	ax,-1	;ffffH
	cwd	
; Line 92
	pop	si
	pop	di
	leave	
	ret	

_snd_021C	ENDP
	PUBLIC	_snd_0269
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
$D317:
; Line 98
	cmp	BYTE PTR [si+6],1
	jne	$I320
	mov	ax,WORD PTR [bp+4]	;sound
	cmp	WORD PTR [si+8],ax
	jne	$I320
; Line 99
	push	si
	call	_snd_0643
	add	sp,2
; Line 100
	xor	di,di
; Line 102
$I320:
; Line 103
	add	si,18	;0012H
	cmp	si,OFFSET _snd_players+36
	jb	$D317
; Line 104
	mov	ax,di
	cwd	
; Line 105
	pop	si
	pop	di
	leave	
	ret	

_snd_0269	ENDP
	PUBLIC	_snd_029B
_snd_029B	PROC NEAR
; Line 107
	push	si
;	register si = player
; Line 109
	call	_snd_0DA8
; Line 110
	mov	si,OFFSET _snd_players
; Line 111
$D323:
; Line 112
	push	si
	call	_snd_0643
	add	sp,2
; Line 114
	add	si,18	;0012H
	cmp	si,OFFSET _snd_players+36
	jb	$D323
; Line 115
	xor	ax,ax
	cwd	
; Line 116
	pop	si
	ret	

_snd_029B	ENDP
	PUBLIC	_snd_02B7
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
$D331:
; Line 122
	cmp	BYTE PTR [bx+6],1
	jne	$I334
	cmp	WORD PTR [bx+8],cx
	je	$L684
; Line 123
$I334:
	add	bx,18	;0012H
; Line 124
	dec	dx
	jne	$D331
	jmp	SHORT $L685
	nop	
$L684:
; Line 122
	mov	ax,1
	cwd	
	leave	
	ret	
$L685:
; Line 125
	push	cx
	call	_snd_17FC
	cwd	
; Line 126
	leave	
	ret	
	nop	

_snd_02B7	ENDP
	PUBLIC	_snd_02E4
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
	jl	$JCC589
	jmp	$L731
$JCC589:
; Line 133
	mov	bx,si
	mov	ax,WORD PTR _snd_extended_commands[bx][si]
	mov	WORD PTR [bp-2],ax	;function
	or	ax,ax
	jne	$JCC605
	jmp	$L731
$JCC605:
; Line 134
	mov	al,BYTE PTR _snd_command_kinds[si]
	sub	ah,ah
; Line 164
	cmp	ax,6
	jbe	$JCC619
	jmp	$L731
$JCC619:
	shl	ax,1
	xchg	ax,bx
	jmp	WORD PTR cs:$L690[bx]
$L690:
		DW	$SC360
		DW	$SC365
		DW	$SC363
		DW	$SC365
		DW	$SC367
		DW	$L731
		DW	$L731
; Line 135
$SC360:
; Line 136
	push	WORD PTR [bp+18]	;g
	push	WORD PTR [bp+16]	;f
	push	WORD PTR [bp+14]	;e
	push	WORD PTR [bp+12]	;d
	push	WORD PTR [bp+10]	;c
	push	WORD PTR [bp+8]	;b
	push	WORD PTR [bp+6]	;a
$L732:
	call	WORD PTR [bp-2]	;function
	add	sp,14	;000eH
	pop	si
	leave	
	ret	
$SC363:
; Line 143
	push	WORD PTR [bp+6]	;a
	call	_snd_0574
	add	sp,2
	mov	si,ax
	or	si,si
	je	$L731
	push	WORD PTR [bp+18]	;g
	push	WORD PTR [bp+16]	;f
	push	WORD PTR [bp+14]	;e
	push	WORD PTR [bp+12]	;d
	push	WORD PTR [bp+10]	;c
	push	WORD PTR [bp+8]	;b
	push	WORD PTR [si]
	jmp	SHORT $L732
	nop	
; Line 145
$SC365:
	push	WORD PTR [bp+6]	;a
	call	_snd_0574
	add	sp,2
	mov	si,ax
	or	si,si
	je	$L731
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
$SC367:
; Line 151
	push	WORD PTR [bp+6]	;a
	call	_snd_0574
	add	sp,2
	mov	si,ax
	or	si,si
	jne	$I368
$L731:
	mov	ax,-1	;ffffH
	pop	si
	leave	
	ret	
	nop	
$I368:
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
	PUBLIC	_snd_0406
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
	je	$I381
	mov	es,WORD PTR [bp-2]
	cmp	WORD PTR es:[si],21581	;544dH
	jne	$I381
	cmp	WORD PTR es:[si+2],25704	;6468H
	jne	$I381
; Line 171
	cmp	WORD PTR [bp+8],25704	;6468H
	jne	$I382
$L734:
	lea	ax,WORD PTR [si+8]
	mov	dx,WORD PTR [bp-2]
	pop	si
	pop	di
	leave	
	ret	
	nop	
; Line 172
$I382:
	mov	di,WORD PTR [bp+10]	;index
; Line 173
	mov	ax,WORD PTR es:[si+10]
	mov	cx,ax
	mov	ah,al
	mov	dl,ch
	mov	dh,al
	cmp	dx,di
	ja	$L691
	xor	di,di
$L691:
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
	jns	$L691
; Line 178
	mov	ax,WORD PTR [bp+6]	;tag
	mov	dx,WORD PTR [bp+8]
	mov	es,WORD PTR [bp-2]
	cmp	WORD PTR es:[si],ax
	jne	$I381
	cmp	WORD PTR es:[si+2],dx
	je	$L734
; Line 180
$I381:
	xor	ax,ax
	cwd	
; Line 181
	pop	si
	pop	di
	leave	
	ret	
	nop	

_snd_0406	ENDP
	PUBLIC	_snd_04B8
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
	PUBLIC	_snd_04CC
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
	PUBLIC	_snd_04D9
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
	jg	$L735
	mov	bx,WORD PTR [bp+8]	;high
	cmp	bx,dx
	jge	$I406
$L735:
	mov	dx,bx
; Line 196
$I406:
	mov	ax,dx
; Line 197
	leave	
	ret	

_snd_04D9	ENDP
	PUBLIC	_snd_04F4
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
	jl	$I415
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
$I415:
	cmp	WORD PTR [bp+8],bx	;high
	jge	$I416
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
$I416:
	mov	ax,bx
; Line 202
	pop	di
	leave	
	ret	
	nop	

_snd_04F4	ENDP
	PUBLIC	_snd_055E
_snd_055E	PROC NEAR
; Line 205
; Line 206
	mov	ax,WORD PTR _snd_disabled
	or	ax,WORD PTR _snd_paused
	jne	$EX417
; Line 207
	call	_snd_0E7C
; Line 208
	call	_snd_1263
; Line 209
	call	_snd_1E1A
; Line 210
	call	_snd_16A5
; Line 212
$EX417:
	ret	

_snd_055E	ENDP
	PUBLIC	_snd_0574
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
$D426:
; Line 217
	cmp	BYTE PTR [bx+6],1
	jne	$I429
	mov	ax,WORD PTR [bp+4]	;sound
	cmp	WORD PTR [bx+8],ax
	jne	$I429
; Line 218
	mov	di,bx
; Line 219
	inc	cx
; Line 221
$I429:
	add	bx,18	;0012H
; Line 222
	dec	dx
	jne	$D426
; Line 223
	or	cx,cx
	je	$I430
	xor	ax,ax
	pop	di
	leave	
	ret	
	nop	
$I430:
	mov	ax,di
; Line 225
	pop	di
	leave	
	ret	
	nop	

_snd_0574	ENDP
	PUBLIC	_snd_05A6
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
$D438:
; Line 231
	cmp	BYTE PTR [si+6],0
	je	$L694
; Line 232
	cmp	BYTE PTR [si+6],1
	jne	$I442
	mov	al,BYTE PTR [bp-1]	;lowest
	cmp	BYTE PTR [si+12],al
	ja	$I442
; Line 233
	mov	al,BYTE PTR [si+12]
	mov	BYTE PTR [bp-1],al	;lowest
; Line 234
	mov	cx,si
; Line 236
$I442:
	add	si,18	;0012H
; Line 237
	inc	dx
	cmp	dx,2
	jl	$D438
; Line 238
	mov	al,BYTE PTR [bp+4]	;priority
	cmp	BYTE PTR [bp-1],al	;lowest
	ja	$I443
	mov	ax,cx
	pop	si
	leave	
	ret	
$L694:
; Line 231
	mov	ax,si
	pop	si
	leave	
	ret	
	nop	
$I443:
	xor	ax,ax
; Line 240
	pop	si
	leave	
	ret	
	nop	

_snd_05A6	ENDP
	PUBLIC	_snd_05E8
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
	jne	$I450
	mov	BYTE PTR [si+6],0
; Line 256
$I450:
; Line 257
	pop	si
	pop	di
	leave	
	ret	
	nop	

_snd_05E8	ENDP
	PUBLIC	_snd_0643
_snd_0643	PROC NEAR
; Line 258
	push	bp
	mov	bp,sp
	push	si
;	player = 4
	mov	si,WORD PTR [bp+4]	;player
; Line 259
	cmp	BYTE PTR [si+6],1
	jne	$EX453
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
$EX453:
	pop	si
	leave	
	ret	

_snd_0643	ENDP
	PUBLIC	_snd_066B
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
	ja	$SB463
	shl	ax,1
	xchg	ax,bx
	jmp	WORD PTR cs:$L697[bx]
	nop	
$L697:
		DW	$SC466
		DW	$SC467
		DW	$SC468
		DW	$SC469
		DW	$SC470
		DW	$SC471
		DW	$SC472
		DW	$SC473
		DW	$SC474
		DW	$SC475
		DW	$SC476
		DW	$SC477
		DW	$SC478
		DW	$SC479
		DW	$SC480
		DW	$SC480
		DW	$SC480
		DW	$SC480
		DW	$SC481
		DW	$SC481
		DW	$SC481
		DW	$SC481
		DW	$SC481
		DW	$SC481
$SB463:
; Line 288
	mov	ax,-1	;ffffH
	jmp	$EX461
; Line 269
$SC466:
	mov	bx,WORD PTR [bp+4]	;player
	mov	al,BYTE PTR [bx+12]
$L736:
	sub	ah,ah
	jmp	$EX461
	nop	
; Line 270
$SC467:
	mov	bx,WORD PTR [bp+4]	;player
	mov	al,BYTE PTR [bx+13]
	jmp	SHORT $L736
; Line 271
$SC468:
	mov	bx,WORD PTR [bp+4]	;player
	mov	al,BYTE PTR [bx+15]
	jmp	SHORT $L736
; Line 272
$SC469:
	mov	bx,WORD PTR [bp+4]	;player
	mov	al,BYTE PTR [bx+16]
	jmp	SHORT $L736
; Line 273
$SC470:
	mov	bx,WORD PTR [bp+4]	;player
	mov	al,BYTE PTR [bx+17]
	jmp	SHORT $L736
; Line 274
$SC471:
	mov	bx,WORD PTR [bp+4]	;player
	mov	bx,WORD PTR [bx]
	mov	al,BYTE PTR [bx+36]
	jmp	SHORT $L736
; Line 275
$SC472:
	mov	bx,WORD PTR [bp+4]	;player
	mov	bx,WORD PTR [bx]
	mov	ax,WORD PTR [bx+10]
	jmp	SHORT $EX461
; Line 276
$SC473:
	mov	bx,WORD PTR [bp+4]	;player
	mov	bx,WORD PTR [bx]
	mov	ax,WORD PTR [bx+12]
	jmp	SHORT $EX461
; Line 277
$SC474:
	mov	bx,WORD PTR [bp+4]	;player
	mov	bx,WORD PTR [bx]
	mov	ax,WORD PTR [bx+14]
	jmp	SHORT $EX461
; Line 278
$SC475:
	mov	bx,WORD PTR [bp+4]	;player
	mov	bx,WORD PTR [bx]
	mov	ax,WORD PTR [bx+42]
	leave	
	ret	
; Line 279
$SC476:
	mov	bx,WORD PTR [bp+4]	;player
	mov	bx,WORD PTR [bx]
	mov	ax,WORD PTR [bx+44]
	leave	
	ret	
; Line 280
$SC477:
	mov	bx,WORD PTR [bp+4]	;player
	mov	bx,WORD PTR [bx]
	mov	ax,WORD PTR [bx+46]
	leave	
	ret	
; Line 281
$SC478:
	mov	bx,WORD PTR [bp+4]	;player
	mov	bx,WORD PTR [bx]
	mov	ax,WORD PTR [bx+48]
	leave	
	ret	
; Line 282
$SC479:
	mov	bx,WORD PTR [bp+4]	;player
	mov	bx,WORD PTR [bx]
	mov	ax,WORD PTR [bx+50]
	leave	
	ret	
; Line 283
$SC480:
; Line 284
	mov	al,BYTE PTR [bp+8]	;channel
	push	ax
	push	dx
	push	WORD PTR [bp+4]	;player
	call	_snd_261A
	mov	sp,bp
	jmp	$L736
; Line 285
$SC481:
; Line 286
	mov	al,BYTE PTR [bp+8]	;channel
	push	ax
	push	dx
	mov	bx,WORD PTR [bp+4]	;player
	push	WORD PTR [bx+2]
	call	_snd_11F0
; Line 289
$EX461:
	leave	
	ret	

_snd_066B	ENDP
	PUBLIC	_snd_0743
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
	PUBLIC	_snd_075E
_snd_075E	PROC NEAR
; Line 295
	push	bp
	mov	bp,sp
;	player = 4
;	volume = 6
; Line 296
	cmp	BYTE PTR [bp+6],127	;007fH	;volume
	jbe	$I492
	mov	BYTE PTR [bp+6],127	;007fH	;volume
; Line 297
$I492:
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
	PUBLIC	_snd_078F
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
	PUBLIC	_snd_07AA
_snd_07AA	PROC NEAR
; Line 307
	push	bp
	mov	bp,sp
;	player = 4
;	relative = 6
;	transpose = 8
; Line 308
	cmp	BYTE PTR [bp+8],24	;0018H	;transpose
	jg	$I506
	cmp	BYTE PTR [bp+8],232	;00e8H	;transpose
	jl	$I506
	cmp	BYTE PTR [bp+6],1	;relative
	ja	$I506
; Line 309
	cmp	BYTE PTR [bp+6],0	;relative
	je	$I507
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
$I507:
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
$I506:
	mov	ax,-1	;ffffH
; Line 313
	leave	
	ret	
	nop	

_snd_07AA	ENDP
	PUBLIC	_snd_07F9
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
	PUBLIC	_snd_0814
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
	PUBLIC	_snd_0857
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
	jne	$I532
$L737:
	mov	ax,-1	;ffffH
	pop	si
	pop	di
	leave	
	ret	
; Line 329
$I532:
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
	je	$L737
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
	je	$L737
; Line 333
	inc	BYTE PTR _snd_parse_nesting
	mov	di,WORD PTR [bp+8]	;beat
; Line 334
	or	di,di
	jne	$I535
	mov	di,1
; Line 335
$I535:
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
	jne	$I536
	mov	ax,WORD PTR [bp-8]	;target
	cmp	WORD PTR [si+18],dx
	ja	$I536
	jb	$L701
	cmp	WORD PTR [si+16],ax
	ja	$I536
$L701:
; Line 337
	mov	ax,WORD PTR [si+6]
	add	ax,WORD PTR [bp-16]	;new_track
	mov	dx,WORD PTR [bp-14]
	mov	WORD PTR _snd_parse_cursor,ax
	mov	WORD PTR _snd_parse_cursor+2,dx
; Line 338
	mov	ax,WORD PTR [si+20]
	mov	dx,WORD PTR [si+22]
	jmp	SHORT $L738
$I536:
; Line 340
	mov	ax,WORD PTR [bp-16]	;new_track
	mov	dx,WORD PTR [bp-14]
	mov	WORD PTR _snd_parse_cursor,ax
	mov	WORD PTR _snd_parse_cursor+2,dx
; Line 341
	push	OFFSET _snd_parse_cursor
	call	_snd_101E
	add	sp,2
$L738:
	mov	WORD PTR [bp-4],ax	;next
	mov	WORD PTR [bp-2],dx
; Line 343
$FC539:
	mov	ax,WORD PTR [bp-8]	;target
	mov	dx,WORD PTR [bp-6]
	cmp	WORD PTR [bp-2],dx
	ja	$FB540
	jb	$L702
	cmp	WORD PTR [bp-4],ax	;next
	jae	$FB540
$L702:
; Line 344
	push	OFFSET _snd_parse_cursor
	call	_snd_1D6D
	add	sp,2
; Line 345
	mov	ax,WORD PTR _snd_parse_cursor+2
	or	ax,WORD PTR _snd_parse_cursor
	je	$L700
; Line 349
	push	OFFSET _snd_parse_cursor
	call	_snd_101E
	add	sp,2
	add	WORD PTR [bp-4],ax	;next
	adc	WORD PTR [bp-2],dx
; Line 350
	jmp	SHORT $FC539
	nop	
$L700:
; Line 346
	dec	BYTE PTR _snd_parse_nesting
	jmp	$L737
	nop	
; Line 350
$FB540:
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
	je	$I542
; Line 362
	mov	WORD PTR [si+10],di
; Line 363
	mov	WORD PTR [si+42],0
; Line 365
$I542:
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
	PUBLIC	_snd_09F4
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
	jne	$I556
$L739:
	mov	ax,-1	;ffffH
	pop	si
	pop	di
	leave	
	ret	
; Line 374
$I556:
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
	je	$L739
; Line 376
	inc	BYTE PTR _snd_parse_nesting
	mov	di,WORD PTR [bp+8]	;beat
; Line 377
	or	di,di
	jne	$I558
	mov	di,1
; Line 378
$I558:
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
$FC560:
	mov	ax,WORD PTR [bp-8]	;target
	mov	dx,WORD PTR [bp-6]
	cmp	WORD PTR [bp-2],dx
	ja	$FB561
	jb	$L707
	cmp	WORD PTR [bp-4],ax	;next
	jae	$FB561
$L707:
; Line 385
	push	OFFSET _snd_parse_cursor
	mov	bx,WORD PTR [bp+4]	;sequence
	push	WORD PTR [bx]
	call	_snd_183E
	add	sp,4
; Line 386
	mov	ax,WORD PTR _snd_parse_cursor+2
	or	ax,WORD PTR _snd_parse_cursor
	je	$L704
; Line 391
	push	OFFSET _snd_parse_cursor
	call	_snd_101E
	add	sp,2
	add	WORD PTR [bp-4],ax	;next
	adc	WORD PTR [bp-2],dx
; Line 392
	jmp	SHORT $FC560
$L704:
; Line 387
	dec	BYTE PTR _snd_parse_nesting
; Line 388
	mov	WORD PTR _snd_scanning,0
	jmp	$L739
	nop	
; Line 392
$FB561:
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
	je	$I563
	mov	WORD PTR [si+10],di
; Line 403
$I563:
	dec	BYTE PTR _snd_parse_nesting
; Line 404
	xor	ax,ax
; Line 405
	pop	si
	pop	di
	leave	
	ret	

_snd_09F4	ENDP
	PUBLIC	_snd_0B2E
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
	jb	$I577
	mov	ax,-1	;ffffH
	leave	
	ret	
	nop	
; Line 409
$I577:
	or	dx,dx
	jne	$I578
	inc	dx
; Line 410
$I578:
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
	PUBLIC	_snd_0B6E
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
	PUBLIC	_snd_0C3D
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
	jne	$I594
	mov	al,BYTE PTR [bp+6]	;target
	push	ax
	push	si
	call	_snd_075E
	add	sp,4
; Line 431
	jmp	SHORT $I595
	nop	
$I594:
; Line 432
	mov	BYTE PTR _snd_fade_state,1
; Line 433
	mov	cx,OFFSET _snd_fades
; Line 434
	mov	dx,2
	mov	si,cx
; Line 435
$D596:
; Line 436
	cmp	BYTE PTR [si],0
	je	$DB598
; Line 437
	add	si,16	;0010H
; Line 438
	dec	dx
	jne	$D596
$DB598:
; Line 439
	or	dx,dx
	jne	$I600
	mov	ax,-1	;ffffH
	pop	si
	pop	di
	leave	
	ret	
	nop	
; Line 440
$I600:
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
	jge	$I601
; Line 450
	neg	di
; Line 451
	mov	BYTE PTR [si+11],255	;00ffH
; Line 453
$I601:
	mov	ax,di
	mov	BYTE PTR [si+12],al
; Line 454
	mov	WORD PTR [si+14],0
; Line 455
$I595:
; Line 456
	xor	ax,ax
; Line 457
	pop	si
	pop	di
	leave	
	ret	

_snd_0C3D	ENDP
	PUBLIC	_snd_0CC3
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
	jl	$I608
	xor	dx,dx
; Line 464
$I608:
	cmp	WORD PTR _snd_queue_read,dx
	jne	$I609
; Line 465
	dec	dx
	mov	WORD PTR _snd_queue_write,dx
; Line 466
	or	dx,dx
	jge	$I610
	mov	WORD PTR _snd_queue_write,63	;003fH
; Line 467
$I610:
	mov	ax,-1	;ffffH
	leave	
	ret	
; Line 469
$I609:
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
	PUBLIC	_snd_0D1F
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
	jne	$I627
$L740:
	mov	ax,-1	;ffffH
	pop	si
	leave	
	ret	
; Line 478
$I627:
	mov	dx,WORD PTR [bp+4]	;command
	cmp	dx,-1	;ffffH
	jne	$I628
; Line 479
	mov	BYTE PTR _snd_building_queue,0
; Line 480
	inc	WORD PTR _snd_trigger_count
; Line 481
	jmp	SHORT $I629
	nop	
$I628:
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
	jl	$I630
	xor	bx,bx
; Line 491
$I630:
	cmp	WORD PTR _snd_queue_read,bx
	jne	$I631
; Line 492
	lea	ax,WORD PTR [bx-1]
	mov	WORD PTR _snd_queue_write,ax
; Line 493
	or	ax,ax
	jge	$L740
	mov	WORD PTR _snd_queue_write,63	;003fH
; Line 494
	jmp	SHORT $L740
	nop	
; Line 496
$I631:
	mov	WORD PTR _snd_queue_write,bx
; Line 497
$I629:
; Line 498
	xor	ax,ax
; Line 499
	pop	si
	leave	
	ret	
	nop	

_snd_0D1F	ENDP
	PUBLIC	_snd_0DA8
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
	PUBLIC	_snd_3283
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
$D637:
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
	jb	$D637
; Line 518
	pop	si
	leave	
	ret	

_snd_3283	ENDP
	PUBLIC	_snd_32AF
_snd_32AF	PROC NEAR
; Line 519
;	register bx = sequence
;	register dx = count
; Line 520
	mov	bx,OFFSET _snd_sequences
; Line 521
	mov	dx,2
; Line 522
$D643:
; Line 523
	mov	BYTE PTR [bx+2],0
; Line 524
	add	bx,52	;0034H
; Line 525
	dec	dx
	jne	$D643
; Line 526
	mov	WORD PTR _snd_tick_period,-29577	;8c77H
	mov	WORD PTR _snd_tick_period+2,36	;0024H
; Line 527
	mov	BYTE PTR _snd_parse_nesting,0
; Line 528
	ret	

_snd_32AF	ENDP
	PUBLIC	_snd_32CF
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
$D650:
; Line 534
	mov	WORD PTR [bx+2],dx
; Line 535
	mov	dx,bx
; Line 536
	add	bx,20	;0014H
; Line 537
	dec	cx
	jne	$D650
; Line 538
	mov	WORD PTR _snd_held_free,dx
; Line 539
	ret	

_snd_32CF	ENDP
	PUBLIC	_snd_32EB
_snd_32EB	PROC NEAR
; Line 540
;	register bx = fade
;	register dx = count
; Line 541
	mov	bx,OFFSET _snd_fades
; Line 542
	mov	dx,2
; Line 543
$D656:
	mov	BYTE PTR [bx],0
	add	bx,16	;0010H
	dec	dx
	jne	$D656
; Line 544
	mov	BYTE PTR _snd_fade_state,0
; Line 545
	mov	WORD PTR _snd_fade_tick_scale,1
; Line 546
	ret	
	nop	

_snd_32EB	ENDP
	PUBLIC	_snd_3303
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
$D662:
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
	jb	$D662
; Line 558
	call	FAR PTR _snd_1DDB
; Line 559
	pop	si
	leave	
	ret	

_snd_3303	ENDP
	PUBLIC	_snd_332F
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
$D670:
; Line 564
	xor	bx,bx
; Line 565
	mov	dx,cx
; Line 566
$D673:
; Line 567
	mov	ax,dx
	sar	ax,5
	mov	BYTE PTR [bx][di],al
; Line 568
	add	dx,cx
; Line 569
	inc	bx
	cmp	bx,32	;0020H
	jl	$D673
; Line 570
	inc	cx
; Line 572
	add	di,32	;0020H
	cmp	di,OFFSET _snd_volume_products+2048
	jb	$D670
; Line 573
	mov	bx,OFFSET _snd_volume_products
; Line 574
	mov	dx,64	;0040H
; Line 575
$D676:
	mov	BYTE PTR [bx],0
	add	bx,32	;0020H
	dec	dx
	jne	$D676
; Line 576
	pop	di
	ret	

_snd_332F	ENDP
	PUBLIC	_snd_3362
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
_TEXT	ENDS
END
