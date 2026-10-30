;	Static Name Aliases
;
	TITLE   midisnd.c
	.286p
	.287
INCLUDELIB      MLIBCE
INCLUDELIB	OLDNAMES.LIB
MIDISND_TEXT	SEGMENT  WORD PUBLIC 'CODE'
MIDISND_TEXT	ENDS
_DATA	SEGMENT  WORD PUBLIC 'DATA'
_DATA	ENDS
CONST	SEGMENT  WORD PUBLIC 'CONST'
CONST	ENDS
_BSS	SEGMENT  WORD PUBLIC 'BSS'
_BSS	ENDS
DGROUP	GROUP	CONST, _BSS, _DATA
	ASSUME DS: DGROUP, SS: DGROUP
EXTRN	_snd_0406:NEAR
EXTRN	_snd_04CC:NEAR
EXTRN	_snd_0643:NEAR
EXTRN	_snd_075E:NEAR
EXTRN	_snd_07AA:NEAR
EXTRN	_snd_0814:NEAR
EXTRN	_snd_0857:NEAR
EXTRN	_snd_216C:NEAR
EXTRN	_snd_21A2:NEAR
EXTRN	_snd_222F:NEAR
EXTRN	_snd_2277:NEAR
EXTRN	_snd_235A:NEAR
EXTRN	_snd_23D2:NEAR
EXTRN	_snd_2509:NEAR
EXTRN	_snd_00FE:FAR
EXTRN	__aFuldiv:FAR
EXTRN	_snd_101E:NEAR
EXTRN	_snd_1537:NEAR
EXTRN	_snd_183E:NEAR
EXTRN	_snd_sequences:BYTE
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
EXTRN	_snd_midi_tags:QWORD
EXTRN	_snd_midi_lengths:QWORD
EXTRN	_snd_channel_masks:BYTE
EXTRN	_snd_tick_period:DWORD
EXTRN	_snd_parse_nesting:BYTE
EXTRN	_snd_parse_finished:BYTE
EXTRN	_snd_parse_cursor:DWORD
EXTRN	_snd_event_channel:BYTE
EXTRN	_snd_event_note:BYTE
EXTRN	_snd_scan_note_count:WORD
EXTRN	_snd_note_channels:BYTE
EXTRN	_snd_scan_end_tick:DWORD
MIDISND_TEXT      SEGMENT
	ASSUME	CS: MIDISND_TEXT
	PUBLIC	_snd_0DB9
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
	jne	$I200
	xor	ax,ax
	pop	si
	pop	di
	leave	
	ret	
	nop	
; Line 26
$I200:
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
	PUBLIC	_snd_0E6A
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
	PUBLIC	_snd_0E7C
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
	je	$JCC227
	jmp	$EX204
$JCC227:
; Line 46
	mov	si,OFFSET _snd_sequences
; Line 47
	mov	WORD PTR [bp-8],2	;count
; Line 48
$D209:
; Line 49
	cmp	BYTE PTR [si+2],1
	je	$JCC244
	jmp	$next_sequence222
$JCC244:
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
	jb	$I213
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
$I213:
; Line 59
	cmp	WORD PTR [si+42],0
	je	$I214
	mov	ax,WORD PTR [si+48]
	cmp	WORD PTR [si+12],ax
	jb	$I214
	mov	ax,WORD PTR [si+14]
	cmp	WORD PTR [si+50],ax
	ja	$I214
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
$I214:
	mov	ax,WORD PTR [si+20]
	mov	dx,WORD PTR [si+22]
	cmp	WORD PTR [si+18],dx
	jae	$JCC359
	jmp	$next_sequence222
$JCC359:
	ja	$L476
	cmp	WORD PTR [si+16],ax
	jae	$JCC369
	jmp	$next_sequence222
$JCC369:
$L476:
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
	jne	$I216
	push	WORD PTR [si]
	call	_snd_0643
	add	sp,2
; Line 66
$I216:
	mov	ax,WORD PTR [si+6]
	add	ax,di
	mov	cx,WORD PTR [bp-4]
	mov	WORD PTR _snd_parse_cursor,ax
	mov	WORD PTR _snd_parse_cursor+2,cx
; Line 67
	mov	BYTE PTR _snd_parse_finished,0
	mov	WORD PTR [bp-2],si	;seq
; Line 68
$FC218:
	mov	bx,WORD PTR [bp-2]	;seq
	mov	ax,WORD PTR [bx+20]
	mov	dx,WORD PTR [bx+22]
	cmp	WORD PTR [bx+18],dx
	jb	$FB219
	ja	$L479
	cmp	WORD PTR [bx+16],ax
	jb	$FB219
$L479:
; Line 69
	push	OFFSET _snd_parse_cursor
	push	WORD PTR [bx]
	call	_snd_183E
	add	sp,4
; Line 70
	mov	ax,WORD PTR _snd_parse_cursor+2
	or	ax,WORD PTR _snd_parse_cursor
	je	$L466
	cmp	BYTE PTR _snd_parse_finished,0
	jne	$L466
; Line 71
	push	OFFSET _snd_parse_cursor
	call	_snd_101E
	add	sp,2
	mov	bx,WORD PTR [bp-2]	;seq
	add	WORD PTR [bx+20],ax
	adc	WORD PTR [bx+22],dx
; Line 72
	jmp	SHORT $FC218
$L466:
	mov	si,WORD PTR [bp-2]	;seq
	jmp	SHORT $next_sequence222
	nop	
$FB219:
; Line 73
	mov	ax,WORD PTR _snd_parse_cursor+2
	or	ax,WORD PTR _snd_parse_cursor
	je	$L466
	mov	si,bx
	cmp	BYTE PTR _snd_parse_finished,0
	jne	$next_sequence222
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
$next_sequence222:
; Line 78
	add	si,52	;0034H
; Line 79
	dec	WORD PTR [bp-8]	;count
	je	$JCC556
	jmp	$D209
$JCC556:
; Line 80
$EX204:
	pop	si
	pop	di
	leave	
	ret	
	nop	

_snd_0E7C	ENDP
	PUBLIC	_snd_0FBE
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
	PUBLIC	_snd_1041
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
	jns	$L481
	neg	ax
	adc	dx,0
	neg	dx
$L481:
; Line 97
	leave	
	ret	

_snd_1041	ENDP
	PUBLIC	_snd_1086
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
	PUBLIC	_snd_109C
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
	je	$I243
; Line 107
	mov	al,BYTE PTR [si]
	mov	bx,WORD PTR [di+2]
	cmp	BYTE PTR [bx],al
	jne	$EX242
; Line 108
	mov	BYTE PTR [bx],0
; Line 110
$I243:
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
$EX242:
	pop	si
	pop	di
	leave	
	ret	
	nop	

_snd_109C	ENDP
	PUBLIC	_snd_10E7
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
	je	$I250
; Line 116
	mov	al,BYTE PTR [si]
	mov	bx,WORD PTR [di+2]
	cmp	BYTE PTR [bx+1],al
	jne	$EX249
; Line 117
	mov	BYTE PTR [bx+1],0
; Line 119
$I250:
	mov	al,BYTE PTR [si+2]
	push	ax
	mov	al,BYTE PTR [si+1]
	push	ax
	push	di
	call	_snd_07AA
	add	sp,6
; Line 120
$EX249:
	pop	si
	pop	di
	leave	
	ret	
	nop	

_snd_10E7	ENDP
	PUBLIC	_snd_1118
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
	je	$I259
; Line 127
	mov	al,BYTE PTR [di+2]
	cmp	BYTE PTR [si+1],al
	jne	$EX256
; Line 128
	mov	BYTE PTR [di+2],ah
; Line 130
$I259:
	mov	al,BYTE PTR [si+2]
	push	ax
	mov	al,BYTE PTR [bp-1]	;channel
	push	ax
	push	dx
	call	_snd_2509
	add	sp,6
; Line 131
$EX256:
	pop	si
	pop	di
	leave	
	ret	
	nop	

_snd_1118	ENDP
	PUBLIC	_snd_114D
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
	je	$I268
; Line 138
	mov	al,BYTE PTR [di+18]
	cmp	BYTE PTR [si+1],al
	jne	$EX265
; Line 139
	mov	BYTE PTR [di+18],ah
; Line 141
$I268:
	mov	al,BYTE PTR [si+2]
	push	ax
	mov	al,BYTE PTR [bp-1]	;channel
	push	ax
	push	dx
	call	_snd_235A
	add	sp,6
; Line 142
$EX265:
	pop	si
	pop	di
	leave	
	ret	
	nop	

_snd_114D	ENDP
	PUBLIC	_snd_1182
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
	je	$I277
; Line 149
	mov	al,BYTE PTR [di+34]
	cmp	BYTE PTR [si+1],al
	jne	$EX274
; Line 150
	mov	BYTE PTR [di+34],ah
; Line 152
$I277:
	mov	al,BYTE PTR [si+2]
	push	ax
	mov	al,BYTE PTR [bp-1]	;channel
	push	ax
	push	dx
	call	_snd_2277
	add	sp,6
; Line 153
$EX274:
	pop	si
	pop	di
	leave	
	ret	
	nop	

_snd_1182	ENDP
	PUBLIC	_snd_11B7
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
	je	$I286
; Line 160
	mov	al,BYTE PTR [si+1]
	cmp	BYTE PTR [di+50],al
	jne	$EX283
; Line 161
	mov	BYTE PTR [di+50],ah
; Line 163
$I286:
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
$EX283:
	pop	si
	pop	di
	leave	
	ret	
	nop	

_snd_11B7	ENDP
	PUBLIC	_snd_11F0
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
	ja	$SD305
	shl	ax,1
	xchg	ax,bx
	jmp	WORD PTR cs:$L482[bx]
	nop	
$L482:
		DW	$SC299
		DW	$SC300
		DW	$SC301
		DW	$SC302
		DW	$SC303
		DW	$SC304
; Line 175
$SD305:
	mov	ax,-1	;ffffH
	pop	si
	leave	
	ret	
; Line 169
$SC299:
	mov	bx,WORD PTR [bp+4]	;hooks
	mov	al,BYTE PTR [bx]
	jmp	SHORT $L504
	nop	
; Line 170
$SC300:
	mov	bx,WORD PTR [bp+4]	;hooks
	mov	al,BYTE PTR [bx+1]
	jmp	SHORT $L504
; Line 171
$SC301:
	mov	si,WORD PTR [bp+8]	;channel
	and	si,255	;00ffH
	mov	bx,WORD PTR [bp+4]	;hooks
	mov	al,BYTE PTR [bx+2][si]
	jmp	SHORT $L504
	nop	
; Line 172
$SC302:
	mov	si,WORD PTR [bp+8]	;channel
	and	si,255	;00ffH
	mov	bx,WORD PTR [bp+4]	;hooks
	mov	al,BYTE PTR [bx+18][si]
	jmp	SHORT $L504
	nop	
; Line 173
$SC303:
	mov	si,WORD PTR [bp+8]	;channel
	and	si,255	;00ffH
	mov	bx,WORD PTR [bp+4]	;hooks
	mov	al,BYTE PTR [bx+34][si]
	jmp	SHORT $L504
	nop	
; Line 174
$SC304:
	mov	si,WORD PTR [bp+8]	;channel
	and	si,255	;00ffH
	mov	bx,WORD PTR [bp+4]	;hooks
	mov	al,BYTE PTR [bx+50][si]
$L504:
	sub	ah,ah
; Line 177
	pop	si
	leave	
	ret	

_snd_11F0	ENDP
	PUBLIC	_snd_1263
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
	jmp	SHORT $L505
	nop	
	nop	
$FC311:
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
	ja	$I313
	jb	$L484
	cmp	WORD PTR [si+8],ax
	ja	$I313
$L484:
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
	je	$I314
	mov	ax,WORD PTR [si]
	mov	bx,WORD PTR [bp-2]	;next
	mov	WORD PTR [bx],ax
; Line 193
$I314:
	cmp	WORD PTR [si],0
	je	$I315
	mov	ax,WORD PTR [bp-2]	;next
	mov	bx,WORD PTR [si]
	mov	WORD PTR [bx+2],ax
; Line 194
	jmp	SHORT $I316
	nop	
$I315:
	mov	ax,WORD PTR [bp-2]	;next
	mov	WORD PTR _snd_held_active,ax
$I316:
; Line 195
	mov	ax,WORD PTR _snd_held_free
	mov	WORD PTR [si+2],ax
; Line 196
	mov	WORD PTR _snd_held_free,si
; Line 198
$I313:
	mov	si,WORD PTR [bp-2]	;next
; Line 199
$L505:
	or	si,si
	jne	$FC311
; Line 200
	pop	si
	pop	di
	leave	
	ret	
	nop	

_snd_1263	ENDP
	PUBLIC	_snd_12D8
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
	jl	$JCC1446
	jmp	$L506
$JCC1446:
	sub	ax,ax
	mov	WORD PTR [bp-6],ax
	mov	WORD PTR [bp-8],ax	;time
; Line 213
	jmp	$L506
$FC334:
; Line 214
	push	OFFSET _snd_parse_cursor
	call	_snd_1537
	add	sp,2
	dec	ax
	jne	$I336
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
	je	$I336
; Line 218
	not	si
	and	WORD PTR [bx],si
; Line 219
	dec	WORD PTR _snd_scan_note_count
; Line 220
	mov	cx,WORD PTR _snd_held_free
; Line 221
	or	cx,cx
	jne	$JCC1520
	jmp	$EX325
$JCC1520:
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
	je	$I339
	mov	bx,dx
	mov	WORD PTR [bx],cx
; Line 227
$I339:
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
$I336:
	push	OFFSET _snd_parse_cursor
	call	_snd_101E
	add	sp,2
	add	WORD PTR [bp-8],ax	;time
	adc	WORD PTR [bp-6],dx
; Line 236
$L506:
	cmp	WORD PTR _snd_scan_note_count,0
	je	$JCC1619
	jmp	$FC334
$JCC1619:
; Line 237
	sub	ax,ax
	mov	WORD PTR _snd_scan_end_tick+2,ax
	mov	WORD PTR _snd_scan_end_tick,ax
; Line 238
	mov	si,WORD PTR _snd_held_cursor
	jmp	SHORT $L507
	nop	
	nop	
$F340:
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
	jb	$FC341
	ja	$L492
	cmp	WORD PTR [si+8],ax
	jbe	$FC341
$L492:
	mov	ax,WORD PTR [si+8]
	mov	dx,WORD PTR [si+10]
	mov	WORD PTR _snd_scan_end_tick,ax
	mov	WORD PTR _snd_scan_end_tick+2,dx
; Line 238
$FC341:
	mov	si,WORD PTR [si+2]
$L507:
	or	si,si
	jne	$F340
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
$FC345:
	mov	ax,WORD PTR _snd_scan_end_tick
	mov	dx,WORD PTR _snd_scan_end_tick+2
	cmp	WORD PTR [bp-6],dx
	jbe	$JCC1736
	jmp	$FB346
$JCC1736:
	jb	$L493
	cmp	WORD PTR [bp-8],ax	;time
	jb	$JCC1746
	jmp	$FB346
$JCC1746:
$L493:
; Line 245
	push	OFFSET _snd_parse_cursor
	call	_snd_1537
	add	sp,2
	cmp	ax,2
	je	$JCC1763
	jmp	$I347
$JCC1763:
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
	je	$I347
; Line 249
	mov	si,WORD PTR _snd_held_cursor
; Line 250
$FC350:
	or	si,si
	je	$I347
; Line 251
	mov	di,WORD PTR [si+2]
; Line 253
	mov	al,BYTE PTR _snd_event_note
	cmp	BYTE PTR [si+4],al
	jne	$I352
	mov	al,BYTE PTR _snd_event_channel
	cmp	BYTE PTR [si+5],al
	jne	$I352
	mov	ax,WORD PTR [bp-8]	;time
	mov	dx,WORD PTR [bp-6]
	cmp	WORD PTR [si+10],dx
	jb	$I352
	ja	$L494
	cmp	WORD PTR [si+8],ax
	jbe	$I352
$L494:
; Line 254
	mov	ax,cx
	not	ax
	mov	bx,WORD PTR [bp-2]	;bits
	and	WORD PTR [bx],ax
; Line 255
	or	di,di
	je	$I353
	mov	ax,WORD PTR [si]
	mov	WORD PTR [di],ax
; Line 256
$I353:
	cmp	WORD PTR [si],0
	je	$I354
	mov	bx,WORD PTR [si]
	mov	WORD PTR [bx+2],di
; Line 257
	jmp	SHORT $I355
	nop	
	nop	
	nop	
$I354:
	mov	WORD PTR _snd_held_cursor,di
$I355:
; Line 258
	mov	ax,WORD PTR _snd_held_free
	mov	WORD PTR [si+2],ax
; Line 259
	mov	WORD PTR _snd_held_free,si
; Line 261
$I352:
	mov	si,di
; Line 262
	jmp	SHORT $FC350
; Line 265
$I347:
	push	OFFSET _snd_parse_cursor
	call	_snd_101E
	add	sp,2
	add	WORD PTR [bp-8],ax	;time
	adc	WORD PTR [bp-6],dx
; Line 266
	jmp	$FC345
$FB346:
; Line 267
	cmp	WORD PTR _snd_held_active,0
	jne	$I356
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
$I356:
	mov	bx,WORD PTR _snd_held_active
	jmp	SHORT $L508
$F357:
	mov	bx,WORD PTR [bx+2]
$L508:
	cmp	WORD PTR [bx+2],0
	jne	$F357
; Line 273
	mov	di,WORD PTR _snd_held_cursor
	mov	WORD PTR [bx+2],di
; Line 274
	mov	WORD PTR _snd_held_cursor,0
; Line 275
	or	di,di
	je	$EX325
	mov	WORD PTR [di],bx
; Line 276
$EX325:
	pop	si
	pop	di
	leave	
	ret	

_snd_12D8	ENDP
	PUBLIC	_snd_15DF
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
	PUBLIC	_snd_15F0
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
	PUBLIC	_snd_160C
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
	PUBLIC	_snd_162A
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
	jmp	SHORT $L509
	nop	
$F378:
; Line 301
	mov	bl,BYTE PTR [bp-2]	;note
	sub	bh,bh
	shl	bx,1
	mov	di,WORD PTR _snd_note_channels[bx]
	or	di,di
	je	$FC379
; Line 302
	mov	BYTE PTR [bp-1],0	;channel
$F382:
	cmp	BYTE PTR [bp-1],16	;0010H	;channel
	jae	$FC379
; Line 303
	mov	bl,BYTE PTR [bp-1]	;channel
	sub	bh,bh
	shl	bx,1
	test	WORD PTR _snd_channel_masks[bx],di
	je	$FC383
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
$FC383:
	inc	BYTE PTR [bp-1]	;channel
	jmp	SHORT $F382
; Line 299
$FC379:
	inc	BYTE PTR [bp-2]	;note
$L509:
	cmp	BYTE PTR [bp-2],128	;0080H	;note
	jb	$F378
; Line 307
	pop	si
	pop	di
	leave	
	ret	
	nop	

_snd_162A	ENDP
	PUBLIC	_snd_167E
_snd_167E	PROC NEAR
; Line 310
; Line 311
	xor	ax,ax
	mov	BYTE PTR _snd_fade_state,al
; Line 312
	ret	

_snd_167E	ENDP
	PUBLIC	_snd_1684
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
$D392:
; Line 319
	cmp	BYTE PTR [bx],0
	je	$I395
	cmp	WORD PTR [bx+2],cx
	jne	$I395
	mov	BYTE PTR [bx],0
; Line 320
$I395:
	add	bx,16	;0010H
; Line 321
	dec	dx
	jne	$D392
; Line 322
	leave	
	ret	
	nop	

_snd_1684	ENDP
	PUBLIC	_snd_16A5
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
	je	$EX396
; Line 330
	inc	WORD PTR _snd_fade_tick_scale
; Line 332
	and	WORD PTR _snd_fade_tick_scale,3
	jne	$EX396
; Line 333
	mov	si,OFFSET _snd_fades
; Line 334
	mov	BYTE PTR _snd_fade_state,0
; Line 335
	mov	di,2
; Line 336
$D402:
; Line 337
	cmp	BYTE PTR [si],0
	je	$I405
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
	ja	$I406
; Line 342
	mov	ax,WORD PTR [si+6]
	sub	WORD PTR [si+14],ax
; Line 343
	mov	al,BYTE PTR [si+11]
	add	BYTE PTR [bp-1],al	;volume
; Line 345
$I406:
	mov	al,BYTE PTR [bp-1]	;volume
	cmp	BYTE PTR [si+4],al
	je	$I407
; Line 346
	or	al,al
	je	$I408
; Line 347
	mov	BYTE PTR [si+4],al
; Line 348
	push	ax
	push	WORD PTR [si+2]
	call	_snd_075E
	add	sp,4
; Line 349
	jmp	SHORT $I407
$I408:
; Line 350
	push	WORD PTR [si+2]
	call	_snd_0643
	add	sp,2
; Line 351
	mov	BYTE PTR [si],0
; Line 354
$I407:
	dec	WORD PTR [si+8]
	jne	$I405
	mov	BYTE PTR [si],0
; Line 356
$I405:
	add	si,16	;0010H
; Line 357
	dec	di
	jne	$D402
; Line 358
$EX396:
	pop	si
	pop	di
	leave	
	ret	

_snd_16A5	ENDP
	PUBLIC	_snd_171D
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
	jne	$JCC2332
	jmp	$EX415
$JCC2332:
; Line 366
	mov	bx,WORD PTR [bp+4]	;player
	mov	dx,WORD PTR [bx+8]
; Line 367
	cmp	BYTE PTR _snd_building_queue,0
	je	$I420
	cmp	WORD PTR _snd_queued_sound,dx
	jne	$I420
	mov	al,BYTE PTR _snd_queued_marker
	cmp	BYTE PTR [bp+6],al	;marker
	je	$EX415
; Line 368
$I420:
; Line 369
	mov	bx,WORD PTR _snd_queue_read
	shl	bx,4
	add	bx,OFFSET _snd_queue
	cmp	WORD PTR [bx],0
	jne	$EX415
	cmp	WORD PTR [bx+2],dx
	jne	$EX415
	mov	al,BYTE PTR [bp+6]	;marker
	sub	ah,ah
	cmp	WORD PTR [bx+4],ax
	jne	$EX415
; Line 370
	dec	WORD PTR _snd_trigger_count
; Line 371
$FC424:
; Line 373
	mov	di,WORD PTR _snd_queue_read
	inc	di
	cmp	di,64	;0040H
	jl	$I426
	xor	di,di
; Line 374
$I426:
	cmp	WORD PTR _snd_queue_write,di
	je	$FB425
; Line 376
	mov	si,di
	shl	si,4
	add	si,OFFSET _snd_queue
	cmp	WORD PTR [si],1
	jne	$FB425
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
	jmp	SHORT $FC424
$FB425:
; Line 381
	mov	WORD PTR _snd_queue_read,di
; Line 382
$EX415:
	pop	si
	pop	di
	leave	
	ret	

_snd_171D	ENDP
	PUBLIC	_snd_17BB
_snd_17BB	PROC NEAR
; Line 385
	push	bp
	mov	bp,sp
;	what = 4
; Line 386
	mov	ax,WORD PTR [bp+4]	;what
; Line 394
	or	ax,ax
	je	$SC436
	dec	ax
	je	$SC437
	dec	ax
	je	$SC439
	jmp	SHORT $SB433
; Line 387
$SC436:
	mov	ax,WORD PTR _snd_trigger_count
	leave	
	ret	
	nop	
; Line 388
$SC437:
; Line 389
	mov	ax,WORD PTR _snd_queue_read
	cmp	WORD PTR _snd_queue_write,ax
	je	$SB433
	mov	bx,ax
	shl	bx,4
	mov	ax,WORD PTR _snd_queue[bx+2]
	leave	
	ret	
; Line 391
$SC439:
; Line 392
	mov	ax,WORD PTR _snd_queue_read
	cmp	WORD PTR _snd_queue_write,ax
	je	$SB433
	mov	bx,ax
	shl	bx,4
	mov	ax,WORD PTR _snd_queue[bx+4]
	leave	
	ret	
; Line 394
$SB433:
; Line 395
	mov	ax,-1	;ffffH
; Line 396
	leave	
	ret	
	nop	

_snd_17BB	ENDP
	PUBLIC	_snd_17FC
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
$FC447:
	cmp	cx,bx
	je	$FB448
; Line 404
	mov	si,bx
	shl	si,4
	cmp	WORD PTR _snd_queue[si],1
	jne	$I449
	mov	si,bx
	shl	si,4
	cmp	WORD PTR _snd_queue[si+2],8
	jne	$I449
	mov	si,bx
	shl	si,4
	cmp	WORD PTR _snd_queue[si+4],dx
	je	$L502
; Line 405
$I449:
	inc	bx
	cmp	bx,64	;0040H
	jl	$FC447
	xor	bx,bx
; Line 406
	jmp	SHORT $FC447
	nop	
$L502:
; Line 404
	mov	ax,2
	pop	si
	leave	
	ret	
; Line 406
$FB448:
; Line 407
	xor	ax,ax
; Line 408
	pop	si
	leave	
	ret	
	nop	

_snd_17FC	ENDP
	PUBLIC	_snd_1D6D
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
	jae	$I455
; Line 418
	inc	WORD PTR [si]
; Line 419
	pop	si
	leave	
	ret	
$I455:
	cmp	BYTE PTR [bp-1],240	;00f0H	;code
	jae	$I457
; Line 420
	mov	bl,BYTE PTR [bp-1]	;code
	and	bl,112	;0070H
	shr	bl,4
	sub	bh,bh
	mov	al,BYTE PTR _snd_midi_lengths[bx]
	sub	ah,ah
	jmp	SHORT $L510
	nop	
$I457:
	cmp	BYTE PTR [bp-1],240	;00f0H	;code
	je	$I460
	cmp	BYTE PTR [bp-1],247	;00f7H	;code
	je	$I460
; Line 423
	cmp	BYTE PTR [bp-1],255	;00ffH	;code
	jne	$I462
	mov	bx,WORD PTR [si]
	inc	WORD PTR [si]
	mov	es,WORD PTR [si+2]
	cmp	BYTE PTR es:[bx],47	;002fH
	jne	$I460
$I462:
; Line 426
	sub	ax,ax
	mov	WORD PTR [si+2],ax
	mov	WORD PTR [si],ax
	pop	si
	leave	
	ret	
	nop	
; Line 421
$I460:
; Line 422
	push	si
	call	_snd_101E
	add	sp,2
$L510:
	add	WORD PTR [si],ax
; Line 428
	pop	si
	leave	
	ret	

_snd_1D6D	ENDP
MIDISND_TEXT	ENDS
END
