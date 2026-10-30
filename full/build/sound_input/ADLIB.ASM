;	Static Name Aliases
;
	TITLE   adlib.c
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
EXTRN	_snd_2FA0:NEAR
EXTRN	_snd_2FB1:NEAR
EXTRN	_snd_304C:NEAR
EXTRN	_snd_04D9:NEAR
EXTRN	_snd_04F4:NEAR
EXTRN	_snd_053D:NEAR
EXTRN	_snd_1DC6:NEAR
EXTRN	_snd_2E9B:NEAR
EXTRN	_snd_2F48:NEAR
EXTRN	_snd_2F6F:NEAR
EXTRN	_snd_2F94:NEAR
EXTRN	_snd_max_values:BYTE
EXTRN	_snd_step_counts:BYTE
EXTRN	_snd_channel_masks:BYTE
EXTRN	_snd_volume_products:BYTE
EXTRN	_snd_parts:BYTE
EXTRN	_snd_voices:BYTE
EXTRN	_snd_voice_tick:BYTE
EXTRN	_snd_voice_counter:WORD
EXTRN	_snd_random_seed:BYTE
EXTRN	_snd_default_instrument:BYTE
EXTRN	_snd_global_instruments:BYTE
EXTRN	_snd_instrument_fields:BYTE
EXTRN	_snd_parameter_map:BYTE
_TEXT      SEGMENT
	ASSUME	CS: _TEXT
	PUBLIC	_snd_1E1A
_snd_1E1A	PROC NEAR
; Line 8
	push	di
	push	si
;	register si = v
;	register di = count
; Line 12
	add	BYTE PTR _snd_voice_tick,3
	cmp	BYTE PTR _snd_voice_tick,10	;000aH
	jb	$EX195
; Line 13
	sub	BYTE PTR _snd_voice_tick,10	;000aH
; Line 14
	mov	si,OFFSET _snd_voices
; Line 15
	mov	di,9
; Line 16
$D199:
; Line 17
	cmp	WORD PTR [si],0
	je	$next_voice203
; Line 18
	cmp	WORD PTR [si+12],0
	je	$I204
; Line 20
	sub	WORD PTR [si+12],17	;0011H
	cmp	WORD PTR [si+12],0
	jle	$L753
; Line 25
$I204:
	cmp	BYTE PTR [si+14],0
	je	$I206
; Line 26
	lea	ax,WORD PTR [si+48]
	push	ax
	lea	ax,WORD PTR [si+14]
	push	ax
	push	si
	call	_snd_28FB
	add	sp,6
; Line 27
$I206:
	cmp	BYTE PTR [si+56],0
	je	$next_voice203
; Line 28
	lea	ax,WORD PTR [si+90]
	push	ax
	lea	ax,WORD PTR [si+56]
	push	ax
	push	si
	call	_snd_28FB
	add	sp,6
; Line 29
$next_voice203:
; Line 30
	add	si,98	;0062H
; Line 31
	dec	di
	jne	$D199
	pop	si
	pop	di
	ret	
	nop	
$L753:
; Line 21
	push	si
	call	_snd_2BC4
	add	sp,2
; Line 32
$EX195:
	pop	si
	pop	di
	ret	

_snd_1E1A	ENDP
	PUBLIC	_snd_1E83
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
	jne	$JCC157
	jmp	$EX212
$JCC157:
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
	jne	$L754
	mov	BYTE PTR [si+21],0
	jmp	SHORT $L755
	nop	
$L754:
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
$L755:
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
$EX212:
	pop	si
	pop	di
	leave	
	ret	

_snd_1E83	ENDP
	PUBLIC	_snd_1FA2
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
	je	$EX220
; Line 67
	mov	al,BYTE PTR [bp+6]	;channel
	push	ax
	push	WORD PTR [si+4]
	call	_snd_1FA2
	add	sp,4
; Line 68
	mov	al,BYTE PTR [bp+6]	;channel
	cmp	BYTE PTR [si+11],al
	jne	$EX220
	push	si
	call	_snd_20AA
	add	sp,2
; Line 70
$EX220:
	pop	si
	leave	
	ret	

_snd_1FA2	ENDP
	PUBLIC	_snd_1FCC
_snd_1FCC	PROC NEAR
; Line 73
	push	si
;	register si = p
; Line 75
	mov	si,OFFSET _snd_parts
	jmp	SHORT $L791
$F225:
	push	si
	call	_snd_20AA
	add	sp,2
	add	si,32	;0020H
$L791:
	cmp	si,OFFSET _snd_parts+1024
	jb	$F225
; Line 76
	call	_snd_1DC6
; Line 77
	pop	si
	ret	
	nop	

_snd_1FCC	ENDP
	PUBLIC	_snd_1FE4
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
	jmp	SHORT $L793
	nop	
$F235:
; Line 83
	mov	al,BYTE PTR [bp+6]	;channel
	cmp	BYTE PTR [si+11],al
	jne	$JCC494
	jmp	$L792
$JCC494:
; Line 82
	mov	si,WORD PTR [si+4]
$L793:
	or	si,si
	jne	$F235
; Line 85
	mov	al,BYTE PTR [di+12]
	push	ax
	call	_snd_2129
	add	sp,2
	mov	si,ax
	or	si,si
	jne	$I239
	xor	ax,ax
	pop	si
	pop	di
	leave	
	ret	
; Line 86
$I239:
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
	je	$I240
	mov	bx,ax
	mov	WORD PTR [bx+2],si
; Line 92
$I240:
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
$L792:
	mov	ax,si
; Line 112
	pop	si
	pop	di
	leave	
	ret	
	nop	

_snd_1FE4	ENDP
	PUBLIC	_snd_20AA
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
	je	$EX243
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
	je	$I247
	mov	WORD PTR [di+2],ax
; Line 122
$I247:
	cmp	WORD PTR [bp-2],0	;previous
	je	$I248
	mov	bx,WORD PTR [bp-2]	;previous
	jmp	SHORT $L794
$I248:
	mov	bx,WORD PTR [si]
$L794:
	mov	WORD PTR [bx+4],di
; Line 125
	xor	ax,ax
	mov	WORD PTR [si],ax
	mov	WORD PTR [si+2],ax
; Line 126
	mov	WORD PTR [si+4],ax
; Line 128
$EX243:
	pop	si
	pop	di
	leave	
	ret	
	nop	

_snd_20AA	ENDP
	PUBLIC	_snd_20E7
_snd_20E7	PROC NEAR
; Line 131
	push	bp
	mov	bp,sp
	push	si
;	player = 4
	mov	si,WORD PTR [bp+4]	;player
; Line 132
	jmp	SHORT $L795
	nop	
$FC254:
	push	WORD PTR [si+4]
	call	_snd_20AA
	add	sp,2
$L795:
	cmp	WORD PTR [si+4],0
	jne	$FC254
; Line 133
	pop	si
	leave	
	ret	

_snd_20E7	ENDP
	PUBLIC	_snd_2102
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
	je	$EX260
	mov	WORD PTR [di+2],bx
; Line 144
$EX260:
	pop	si
	pop	di
	leave	
	ret	

_snd_2102	ENDP
	PUBLIC	_snd_2129
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
$F269:
	cmp	dx,32	;0020H
	jge	$FB271
; Line 152
	cmp	WORD PTR [si],0
	je	$L761
; Line 153
	mov	al,BYTE PTR [bp+4]	;priority
	cmp	BYTE PTR [si+15],al
	ja	$FC270
; Line 154
	mov	al,BYTE PTR [si+15]
	mov	BYTE PTR [bp+4],al	;priority
; Line 155
	mov	di,si
; Line 151
$FC270:
	add	si,32	;0020H
	inc	dx
	jmp	SHORT $F269
$L761:
; Line 152
	mov	ax,si
	pop	si
	pop	di
	leave	
	ret	
; Line 157
$FB271:
; Line 158
	or	di,di
	je	$I274
	push	di
	call	_snd_20AA
	add	sp,2
; Line 159
$I274:
	mov	ax,di
; Line 160
	pop	si
	pop	di
	leave	
	ret	
	nop	

_snd_2129	ENDP
	PUBLIC	_snd_216C
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
	je	$EX283
	cmp	BYTE PTR [si+13],0
	je	$EX283
	cmp	BYTE PTR [si+12],0
	jne	$EX283
	mov	al,BYTE PTR [bp+10]	;velocity
	push	ax
	mov	al,BYTE PTR [bp+8]	;note
	push	ax
	push	si
	call	_snd_2709
	add	sp,6
; Line 166
$EX283:
	pop	si
	leave	
	ret	
	nop	

_snd_216C	ENDP
	PUBLIC	_snd_21A2
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
	jmp	SHORT $L797
$F294:
; Line 172
	mov	al,BYTE PTR [bp+6]	;channel
	cmp	BYTE PTR [si+11],al
	jne	$FC295
	cmp	BYTE PTR [si+13],0
	je	$FC295
	cmp	BYTE PTR [si+12],0
	jne	$FC295
; Line 173
	cmp	BYTE PTR [si+25],0
	je	$I298
	mov	al,BYTE PTR [bp+8]	;note
	push	ax
	push	WORD PTR [si+6]
	call	_snd_28BD
	jmp	SHORT $L796
$I298:
	mov	al,BYTE PTR [bp+8]	;note
	push	ax
	push	WORD PTR [si+6]
	call	_snd_2750
$L796:
	add	sp,4
; Line 171
$FC295:
	mov	si,WORD PTR [si+4]
$L797:
	or	si,si
	jne	$F294
; Line 177
	pop	si
	leave	
	ret	
	nop	

_snd_21A2	ENDP
	PUBLIC	_snd_21EF
_snd_21EF	PROC NEAR
; Line 180
	push	bp
	mov	bp,sp
	push	si
;	p = 4
	mov	si,WORD PTR [bp+4]	;p
; Line 181
	jmp	SHORT $L798
	nop	
$F303:
	push	si
	call	_snd_2772
	add	sp,2
	mov	si,WORD PTR [si+4]
$L798:
	or	si,si
	jne	$F303
; Line 182
	pop	si
	leave	
	ret	
	nop	

_snd_21EF	ENDP
	PUBLIC	_snd_2209
_snd_2209	PROC NEAR
; Line 185
	push	bp
	mov	bp,sp
	push	si
;	p = 4
	mov	si,WORD PTR [bp+4]	;p
; Line 186
	jmp	SHORT $L799
	nop	
$F309:
; Line 187
	cmp	BYTE PTR [si+25],0
	je	$FC310
; Line 188
	mov	BYTE PTR [si+25],0
; Line 189
	push	WORD PTR [si+6]
	call	_snd_28DB
	add	sp,2
; Line 186
$FC310:
	mov	si,WORD PTR [si+4]
$L799:
	or	si,si
	jne	$F309
; Line 191
	pop	si
	leave	
	ret	
	nop	

_snd_2209	ENDP
	PUBLIC	_snd_222F
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
	jmp	SHORT $L800
$F322:
; Line 199
	mov	bx,WORD PTR [bp+4]	;p
	mov	si,WORD PTR [bx+6]
	or	si,si
	je	$FC323
; Line 200
	mov	bl,BYTE PTR [bx+11]
	sub	bh,bh
	shl	bx,1
	mov	dx,WORD PTR _snd_channel_masks[bx]
; Line 201
$D326:
; Line 202
	mov	bl,BYTE PTR [si+8]
	sub	bh,bh
	shl	bx,1
	test	WORD PTR [bx][di],dx
	jne	$I329
; Line 203
	mov	bl,BYTE PTR [si+8]
	sub	bh,bh
	shl	bx,1
	or	WORD PTR [bx][di],dx
; Line 204
	mov	bx,cx
	inc	WORD PTR [bx]
; Line 206
$I329:
; Line 207
	mov	si,WORD PTR [si+4]
	or	si,si
	jne	$D326
; Line 197
$FC323:
	mov	bx,WORD PTR [bp+4]	;p
	mov	ax,WORD PTR [bx+4]
	mov	WORD PTR [bp+4],ax	;p
$L800:
	cmp	WORD PTR [bp+4],0	;p
	jne	$F322
; Line 210
	pop	si
	pop	di
	leave	
	ret	
	nop	

_snd_222F	ENDP
	PUBLIC	_snd_2277
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
	je	$EX336
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
$EX336:
	pop	si
	leave	
	ret	

_snd_2277	ENDP
	PUBLIC	_snd_22A4
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
	je	$EX345
; Line 226
	push	WORD PTR [bp+8]	;instrument
	push	si
	call	_snd_2665
	add	sp,4
; Line 227
	mov	BYTE PTR [si+12],0
; Line 229
$EX345:
	pop	si
	leave	
	ret	

_snd_22A4	ENDP
	PUBLIC	_snd_22CD
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
	je	$EX356
	push	WORD PTR [bp+10]	;value
	push	WORD PTR [bp+8]	;parameter
	push	ax
	call	_snd_26C3
; Line 235
$EX356:
	leave	
	ret	
	nop	

_snd_22CD	ENDP
	PUBLIC	_snd_22F1
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
	jne	$I367
; Line 241
	mov	bx,WORD PTR [bp+4]	;player
	mov	si,WORD PTR [bx+4]
$F368:
	or	si,si
	je	$EX365
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
	jmp	SHORT $F368
	nop	
; Line 243
$I367:
; Line 245
	mov	al,BYTE PTR [bp+6]	;channel
	push	ax
	push	WORD PTR [bp+4]	;player
	call	_snd_1FE4
	add	sp,4
	mov	si,ax
	or	si,si
	je	$EX365
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
$EX365:
	pop	si
	leave	
	ret	
	nop	

_snd_22F1	ENDP
	PUBLIC	_snd_235A
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
	jne	$I381
; Line 256
	mov	bx,WORD PTR [bp+4]	;player
	mov	si,WORD PTR [bx+4]
$F382:
	or	si,si
	je	$I385
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
	jmp	SHORT $F382
; Line 260
$I381:
; Line 262
	mov	al,BYTE PTR [bp+6]	;channel
	push	ax
	push	WORD PTR [bp+4]	;player
	call	_snd_1FE4
	add	sp,4
	mov	si,ax
	or	si,si
	jne	$I386
	mov	ax,-1	;ffffH
	pop	si
	leave	
	ret	
	nop	
; Line 263
$I386:
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
$I385:
; Line 267
	xor	ax,ax
; Line 268
	pop	si
	leave	
	ret	
	nop	

_snd_235A	ENDP
	PUBLIC	_snd_23D1
_snd_23D1	PROC NEAR
; Line 270
	ret	
	nop	

_snd_23D1	ENDP
	PUBLIC	_snd_23D2
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
	jl	$JCC1528
	jmp	$EX396
$JCC1528:
	cmp	BYTE PTR [bp+10],231	;00e7H	;transpose
	jg	$JCC1537
	jmp	$EX396
$JCC1537:
; Line 276
	cmp	BYTE PTR [bp+6],16	;0010H	;channel
	jne	$I399
; Line 277
	mov	bx,WORD PTR [bp+4]	;player
	mov	si,WORD PTR [bx+4]
$F400:
	or	si,si
	jne	$JCC1556
	jmp	$EX396
$JCC1556:
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
	jmp	SHORT $F400
; Line 281
$I399:
; Line 283
	mov	al,BYTE PTR [bp+6]	;channel
	push	ax
	push	WORD PTR [bp+4]	;player
	call	_snd_1FE4
	add	sp,4
	mov	si,ax
	or	si,si
	je	$EX396
; Line 284
	cmp	BYTE PTR [bp+8],0	;relative
	je	$I405
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
$I405:
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
$EX396:
	pop	si
	leave	
	ret	
	nop	

_snd_23D2	ENDP
	PUBLIC	_snd_247E
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
	jne	$I414
; Line 297
	mov	bx,WORD PTR [bp+4]	;player
	mov	si,WORD PTR [bx+4]
$F415:
	or	si,si
	je	$EX412
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
	jmp	SHORT $F415
; Line 302
$I414:
; Line 304
	mov	al,BYTE PTR [bp+6]	;channel
	push	ax
	push	WORD PTR [bp+4]	;player
	call	_snd_1FE4
	add	sp,4
	mov	si,ax
	or	si,si
	je	$EX412
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
$EX412:
	pop	si
	leave	
	ret	

_snd_247E	ENDP
	PUBLIC	_snd_2509
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
	jne	$I428
	mov	ax,-1	;ffffH
	pop	si
	leave	
	ret	
	nop	
; Line 317
$I428:
	mov	al,BYTE PTR [bp+8]	;enabled
	mov	BYTE PTR [si+13],al
; Line 318
	or	al,al
	jne	$I429
	push	si
	call	_snd_2772
	add	sp,2
; Line 319
$I429:
	xor	ax,ax
; Line 320
	pop	si
	leave	
	ret	

_snd_2509	ENDP
	PUBLIC	_snd_253C
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
	je	$EX436
; Line 326
	mov	al,BYTE PTR [bp+8]	;value
	mov	BYTE PTR [si+24],al
; Line 327
	push	ax
	push	WORD PTR [si+6]
	call	_snd_2B03
	add	sp,4
; Line 329
$EX436:
	pop	si
	leave	
	ret	

_snd_253C	ENDP
	PUBLIC	_snd_2567
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
	je	$EX445
; Line 335
	mov	al,BYTE PTR [bp+8]	;sustain
	mov	BYTE PTR [si+25],al
; Line 336
	or	al,al
	jne	$EX445
	push	WORD PTR [si+6]
	call	_snd_28DB
	add	sp,2
; Line 338
$EX445:
	pop	si
	leave	
	ret	
	nop	

_snd_2567	ENDP
	PUBLIC	_snd_2594
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
	je	$EX455
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
$EX455:
	pop	si
	leave	
	ret	
	nop	

_snd_2594	ENDP
	PUBLIC	_snd_25E7
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
	jae	$EX464
	mov	di,WORD PTR [bp+4]	;player
; Line 355
	mov	al,BYTE PTR [bp+6]	;channel
	push	ax
	push	di
	call	_snd_1FE4
	add	sp,4
	mov	si,ax
	or	si,si
	je	$EX464
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
$EX464:
	pop	si
	pop	di
	leave	
	ret	
	nop	

_snd_25E7	ENDP
	PUBLIC	_snd_261A
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
	jmp	SHORT $L801
$F476:
; Line 367
	mov	al,BYTE PTR [bp+8]	;channel
	cmp	BYTE PTR [si+11],al
	je	$FB478
; Line 366
	mov	si,WORD PTR [si+4]
$L801:
	or	si,si
	jne	$F476
; Line 368
$FB478:
	or	si,si
	jne	$I480
	mov	al,129	;0081H
	pop	si
	leave	
	ret	
; Line 369
$I480:
	mov	al,BYTE PTR [bp+6]	;parameter
	cbw	
; Line 374
	sub	ax,14	;000eH
	je	$SC485
	dec	ax
	je	$SC486
	dec	ax
	je	$SC487
	dec	ax
	je	$SC488
; Line 375
	mov	al,255	;00ffH
	pop	si
	leave	
	ret	
	nop	
; Line 370
$SC485:
	mov	al,BYTE PTR [si+13]
	pop	si
	leave	
	ret	
; Line 371
$SC486:
	mov	al,BYTE PTR [si+16]
	pop	si
	leave	
	ret	
; Line 372
$SC487:
	mov	al,BYTE PTR [si+10]
	pop	si
	leave	
	ret	
; Line 373
$SC488:
	mov	al,BYTE PTR [si+20]
; Line 376
	pop	si
	leave	
	ret	

_snd_261A	ENDP
	PUBLIC	_snd_2665
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
	PUBLIC	_snd_2679
_snd_2679	PROC NEAR
; Line 384
	push	bp
	mov	bp,sp
;	number = 4
;	instrument = 6
; Line 385
	cmp	BYTE PTR [bp+4],32	;0020H	;number
	jae	$EX498
	push	30	;001eH
	push	WORD PTR [bp+6]	;instrument
	mov	al,30	;001eH
	mul	BYTE PTR [bp+4]	;number
	add	ax,OFFSET _snd_global_instruments
	push	ax
	call	_snd_053D
; Line 386
$EX498:
	leave	
	ret	

_snd_2679	ENDP
	PUBLIC	_snd_269B
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
	jae	$I506
	mov	al,BYTE PTR [bp+6]	;number
	sub	ah,ah
	imul	di,ax,30	;001eH
	add	di,OFFSET _snd_global_instruments
	jmp	SHORT $I507
$I506:
	mov	di,OFFSET _snd_default_instrument
$I507:
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
	PUBLIC	_snd_26C3
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
	PUBLIC	_snd_2709
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
	je	$EX522
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
	je	$I526
	mov	ax,WORD PTR [bp-2]	;v
	mov	bx,dx
	mov	WORD PTR [bx+2],ax
; Line 416
$I526:
	mov	al,BYTE PTR [bp+8]	;velocity
	push	ax
	mov	al,BYTE PTR [bp+6]	;note
	push	ax
	push	WORD PTR [bp-2]	;v
	push	WORD PTR [bp+4]	;p
	call	_snd_278D
	add	sp,8
; Line 418
$EX522:
	pop	si
	leave	
	ret	
	nop	

_snd_2709	ENDP
	PUBLIC	_snd_2750
_snd_2750	PROC NEAR
; Line 421
	push	bp
	mov	bp,sp
	push	si
;	v = 4
;	note = 6
	mov	si,WORD PTR [bp+4]	;v
; Line 422
	jmp	SHORT $L802
	nop	
$F532:
	mov	al,BYTE PTR [bp+6]	;note
	cmp	BYTE PTR [si+8],al
	jne	$FC533
	push	si
	call	_snd_2BC4
	add	sp,2
$FC533:
	mov	si,WORD PTR [si+4]
$L802:
	or	si,si
	jne	$F532
; Line 423
	pop	si
	leave	
	ret	
	nop	

_snd_2750	ENDP
	PUBLIC	_snd_2772
_snd_2772	PROC NEAR
; Line 426
	push	bp
	mov	bp,sp
	push	si
;	p = 4
	mov	si,WORD PTR [bp+4]	;p
; Line 427
	jmp	SHORT $L803
	nop	
$FC540:
	push	WORD PTR [si+6]
	call	_snd_2BC4
	add	sp,2
$L803:
	cmp	WORD PTR [si+6],0
	jne	$FC540
; Line 428
	pop	si
	leave	
	ret	

_snd_2772	ENDP
	PUBLIC	_snd_278D
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
	je	$I557
	mov	ax,63	;003fH
	imul	WORD PTR [si+12]
	mov	WORD PTR [si+12],ax
; Line 441
$I557:
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
	jbe	$I558
	mov	BYTE PTR [bp-1],63	;003fH	;level
; Line 444
$I558:
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
	jbe	$I559
	mov	BYTE PTR [bp-1],63	;003fH	;level
; Line 447
$I559:
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
	jne	$I560
	mov	bl,al
	sub	bh,bh
	shl	bx,5
	add	bx,dx
	mov	al,BYTE PTR _snd_volume_products[bx]
	mov	BYTE PTR [bp-2],al	;modulator
; Line 452
$I560:
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
	je	$I561
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
	jmp	SHORT $I562
	nop	
$I561:
	mov	BYTE PTR [si+14],0
$I562:
; Line 457
	test	BYTE PTR [di+20],128	;0080H
	je	$I563
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
$I563:
	mov	BYTE PTR [si+56],0
; Line 460
	pop	si
	pop	di
	leave	
	ret	

_snd_278D	ENDP
	PUBLIC	_snd_28BD
_snd_28BD	PROC NEAR
; Line 463
	push	bp
	mov	bp,sp
	push	si
;	v = 4
;	note = 6
	mov	si,WORD PTR [bp+4]	;v
; Line 464
	jmp	SHORT $L804
	nop	
$F570:
	mov	al,BYTE PTR [bp+6]	;note
	cmp	BYTE PTR [si+8],al
	jne	$FC571
	mov	BYTE PTR [si+11],1
$FC571:
	mov	si,WORD PTR [si+4]
$L804:
	or	si,si
	jne	$F570
; Line 465
	pop	si
	leave	
	ret	

_snd_28BD	ENDP
	PUBLIC	_snd_28DB
_snd_28DB	PROC NEAR
; Line 468
	push	bp
	mov	bp,sp
	push	si
;	v = 4
	mov	si,WORD PTR [bp+4]	;v
; Line 469
	jmp	SHORT $L805
	nop	
$F577:
	cmp	BYTE PTR [si+11],0
	je	$FC578
	push	si
	call	_snd_2BC4
	add	sp,2
$FC578:
	mov	si,WORD PTR [si+4]
$L805:
	or	si,si
	jne	$F577
; Line 470
	pop	si
	leave	
	ret	
	nop	

_snd_28DB	ENDP
	PUBLIC	_snd_28FB
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
	jne	$JCC2906
	jmp	$I590
$JCC2906:
; Line 477
	mov	bx,WORD PTR [bp+8]	;w
	mov	al,BYTE PTR [bx+2]
	sub	ah,ah
	cmp	ax,31	;001fH
	jne	$JCC2922
	jmp	$SC600
$JCC2922:
	ja	$SD601
	or	al,al
	je	$SC595
	sub	al,13	;000dH
	je	$SC596
	sub	al,17	;0011H
	je	$SC598
$SD601:
; Line 495
	mov	bx,WORD PTR [bp+6]	;e
	mov	ax,WORD PTR [bx+8]
	mov	bx,WORD PTR [bp+8]	;w
	add	ax,WORD PTR [bx]
	jmp	SHORT $L806
; Line 478
$SC595:
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
$L807:
	mov	al,BYTE PTR _snd_volume_products[bx][si]
$L806:
	mov	WORD PTR [bp-4],ax	;value
; Line 481
	jmp	SHORT $SB592
; Line 482
$SC596:
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
	jne	$SB592
; Line 486
	mov	si,ax
	shl	si,5
	mov	bx,WORD PTR [bx]
	mov	bl,BYTE PTR [bx+17]
	shr	bl,2
	sub	bh,bh
	jmp	SHORT $L807
	nop	
; Line 488
$SC598:
; Line 489
	mov	al,BYTE PTR [bx]
	mov	bx,WORD PTR [bx+6]
	mov	BYTE PTR [bx+20],al
; Line 490
	jmp	SHORT $I590
; Line 491
$SC600:
; Line 492
	mov	al,BYTE PTR [bx]
	mov	bx,WORD PTR [bx+6]
	mov	BYTE PTR [bx+19],al
; Line 493
	jmp	SHORT $I590
; Line 494
$SB592:
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
$I590:
; Line 500
	test	BYTE PTR [bp-2],2	;changes
	je	$I602
	mov	bx,WORD PTR [bp+8]	;w
	cmp	BYTE PTR [bx+4],0
	je	$I602
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
$I602:
	pop	si
	leave	
	ret	

_snd_28FB	ENDP
	PUBLIC	_snd_29A1
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
	je	$L777
	mov	bx,WORD PTR [si]
	mov	al,BYTE PTR [bx+24]
	shr	al,2
	jmp	SHORT $L778
	nop	
$L777:
	mov	al,31	;001fH
$L778:
	mov	bx,WORD PTR [bp+6]	;e
	mov	BYTE PTR [bx+20],al
; Line 519
	mov	bx,di
	mov	al,BYTE PTR [bx+2]
	sub	ah,ah
; Line 525
	cmp	ax,31	;001fH
	je	$SC621
	ja	$SD622
	or	al,al
	je	$SC618
	sub	al,13	;000dH
	je	$SC619
	sub	al,17	;0011H
	je	$SC620
; Line 524
$SD622:
	mov	bx,dx
	mov	al,BYTE PTR [bx+2]
	push	ax
	mov	al,BYTE PTR [si+7]
	push	ax
	call	_snd_304C
	add	sp,4
$L808:
	mov	bx,WORD PTR [bp+6]	;e
	mov	WORD PTR [bx+8],ax
; Line 525
	jmp	SHORT $SB615
; Line 520
$SC618:
	mov	al,BYTE PTR [si+9]
$L809:
	sub	ah,ah
	jmp	SHORT $L808
	nop	
; Line 521
$SC619:
	mov	al,BYTE PTR [si+10]
	jmp	SHORT $L809
	nop	
; Line 522
$SC620:
	mov	bx,WORD PTR [bp+6]	;e
	mov	WORD PTR [bx+8],31	;001fH
	mov	bx,dx
	mov	bx,WORD PTR [bx+6]
	mov	BYTE PTR [bx+20],0
	jmp	SHORT $SB615
	nop	
; Line 523
$SC621:
	mov	bx,WORD PTR [bp+6]	;e
	mov	WORD PTR [bx+8],0
	mov	bx,dx
	mov	bx,WORD PTR [bx+6]
	mov	BYTE PTR [bx+19],0
; Line 525
$SB615:
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
	PUBLIC	_snd_2A5E
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
	jge	$EX629
	mov	si,WORD PTR [bp+4]	;v
; Line 532
$F631:
	or	si,si
	je	$EX629
	push	WORD PTR [bp+8]	;value
	mov	ax,di
	push	ax
	push	si
	call	_snd_2FB1
	add	sp,6
	mov	si,WORD PTR [si+4]
	jmp	SHORT $F631
; Line 533
$EX629:
	pop	si
	pop	di
	leave	
	ret	

_snd_2A5E	ENDP
	PUBLIC	_snd_2A87
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
	jmp	SHORT $L810
$F639:
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
	jne	$FC640
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
$FC640:
	mov	si,WORD PTR [si+4]
$L810:
	or	si,si
	jne	$F639
; Line 542
	pop	si
	pop	di
	leave	
	ret	
	nop	

_snd_2A87	ENDP
	PUBLIC	_snd_2AD9
_snd_2AD9	PROC NEAR
; Line 545
	push	bp
	mov	bp,sp
	push	si
;	v = 4
;	transpose = 6
	mov	si,WORD PTR [bp+4]	;v
; Line 546
	jmp	SHORT $L811
	nop	
$F648:
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
$L811:
	or	si,si
	jne	$F648
; Line 548
	pop	si
	leave	
	ret	

_snd_2AD9	ENDP
	PUBLIC	_snd_2B03
_snd_2B03	PROC NEAR
; Line 551
	push	bp
	mov	bp,sp
	push	si
;	v = 4
;	value = 6
	mov	si,WORD PTR [bp+4]	;v
; Line 552
	jmp	SHORT $L812
	nop	
$F656:
; Line 553
	cmp	BYTE PTR [si+14],0
	je	$I659
	cmp	BYTE PTR [si+51],0
	je	$I659
	mov	al,BYTE PTR [bp+6]	;value
	shr	al,2
	mov	BYTE PTR [si+34],al
; Line 554
$I659:
	cmp	BYTE PTR [si+56],0
	je	$FC657
	cmp	BYTE PTR [si+93],0
	je	$FC657
	mov	al,BYTE PTR [bp+6]	;value
	shr	al,2
	mov	BYTE PTR [si+76],al
; Line 552
$FC657:
	mov	si,WORD PTR [si+4]
$L812:
	or	si,si
	jne	$F656
; Line 556
	pop	si
	leave	
	ret	

_snd_2B03	ENDP
	PUBLIC	_snd_2B3F
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
	jmp	SHORT $L813
	nop	
$F666:
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
$L813:
	or	si,si
	jne	$F666
; Line 562
	pop	si
	pop	di
	leave	
	ret	
	nop	

_snd_2B3F	ENDP
	PUBLIC	_snd_2B6C
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
$D675:
; Line 569
	inc	WORD PTR _snd_voice_counter
	cmp	WORD PTR _snd_voice_counter,8
	jbe	$I678
	mov	WORD PTR _snd_voice_counter,0
; Line 570
$I678:
; Line 571
	imul	si,WORD PTR _snd_voice_counter,98	;0062H
	add	si,OFFSET _snd_voices
	cmp	WORD PTR [si],0
	je	$L785
; Line 572
	cmp	WORD PTR [si+4],0
	jne	$DC676
	mov	al,BYTE PTR [bp+4]	;priority
	mov	bx,WORD PTR [si]
	cmp	BYTE PTR [bx+15],al
	ja	$DC676
; Line 573
	mov	al,BYTE PTR [bx+15]
	mov	BYTE PTR [bp+4],al	;priority
; Line 574
	mov	WORD PTR [bp-2],si	;candidate
; Line 576
$DC676:
	dec	di
	jne	$D675
	jmp	SHORT $L786
	nop	
$L785:
; Line 571
	mov	ax,si
	pop	si
	pop	di
	leave	
	ret	
$L786:
	mov	di,WORD PTR [bp-2]	;candidate
; Line 577
	or	di,di
	je	$I681
	push	di
	call	_snd_2BC4
	add	sp,2
; Line 578
$I681:
	mov	ax,di
; Line 579
	pop	si
	pop	di
	leave	
	ret	

_snd_2B6C	ENDP
	PUBLIC	_snd_2BC4
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
	je	$I687
	mov	bx,cx
	mov	WORD PTR [bx+2],ax
; Line 592
$I687:
	cmp	WORD PTR [bp-2],0	;previous
	je	$I688
	mov	ax,WORD PTR [bp-4]	;next
	mov	bx,WORD PTR [bp-2]	;previous
	mov	WORD PTR [bx+4],ax
; Line 593
	jmp	SHORT $I689
$I688:
	mov	ax,WORD PTR [bp-4]	;next
	mov	bx,WORD PTR [bp+4]	;v
	mov	bx,WORD PTR [bx]
	mov	WORD PTR [bx+6],ax
$I689:
; Line 594
	mov	bx,WORD PTR [bp+4]	;v
	mov	WORD PTR [bx],0
; Line 595
	leave	
	ret	

_snd_2BC4	ENDP
	PUBLIC	_snd_2BF6
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
	je	$I695
	mov	ax,63	;003fH
	imul	WORD PTR [si+4]
	mov	WORD PTR [si+4],ax
; Line 604
$I695:
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
	PUBLIC	_snd_2C59
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
	je	$I707
	push	si
	call	_snd_2E7A
	add	sp,2
	mov	si,ax
; Line 624
$I707:
	mov	WORD PTR [bp-2],si	;ticks
	or	si,si
	jne	$I708
	mov	WORD PTR [bp-2],1	;ticks
; Line 625
$I708:
	mov	ax,WORD PTR [bp-2]	;ticks
	mov	WORD PTR [di+24],ax
	mov	WORD PTR [di+22],ax
; Line 626
	cmp	BYTE PTR [bp-9],2	;stage
	jne	$I709
	xor	si,si
; Line 627
	jmp	SHORT $I710
$I709:
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
	je	$I711
	push	ax
	call	_snd_2E7A
	add	sp,2
	mov	WORD PTR [bp-8],ax	;difference
; Line 633
$I711:
	mov	ax,WORD PTR [bp-6]	;base
	add	ax,WORD PTR [bp-8]	;difference
	cmp	ax,WORD PTR [bp-4]	;remainder
	jle	$I712
	mov	si,WORD PTR [bp-4]	;remainder
	sub	si,WORD PTR [bp-6]	;base
; Line 634
	jmp	SHORT $I713
	nop	
$I712:
	mov	si,WORD PTR [bp-8]	;difference
	mov	ax,WORD PTR [bp-6]	;base
	add	ax,si
	jns	$I713
	mov	si,WORD PTR [bp-6]	;base
	neg	si
; Line 635
$I713:
	sub	si,WORD PTR [di+2]
; Line 636
$I710:
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
	jge	$I715
; Line 641
	neg	WORD PTR [bp-4]	;remainder
; Line 642
	mov	BYTE PTR [bp-5],255	;00ffH	;direction
; Line 644
$I715:
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
	PUBLIC	_snd_2D33
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
	je	$I724
; Line 655
	sub	WORD PTR [bx+4],17	;0011H
	cmp	WORD PTR [bx+4],0
	jg	$I724
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
$I724:
	mov	bx,WORD PTR [bp+4]	;e
	mov	si,WORD PTR [bx+2]
	add	si,WORD PTR [bx+26]
; Line 661
	mov	dx,WORD PTR [bx+22]
; Line 663
	mov	ax,WORD PTR [bx+30]
	add	WORD PTR [bx+32],ax
	cmp	WORD PTR [bx+32],dx
	jb	$I726
; Line 664
	mov	bx,WORD PTR [bp+4]	;e
	sub	WORD PTR [bx+32],dx
; Line 665
	mov	al,BYTE PTR [bx+28]
	cbw	
	add	si,ax
; Line 667
$I726:
	mov	bx,WORD PTR [bp+4]	;e
	cmp	WORD PTR [bx+2],si
	jne	$I728
	mov	al,BYTE PTR [bx+21]
	cmp	BYTE PTR [bx+20],al
	je	$L787
$I728:
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
	je	$I727
; Line 672
	mov	WORD PTR [bx],si
; Line 673
	mov	di,1
; Line 676
$I727:
	mov	bx,WORD PTR [bp+4]	;e
	dec	WORD PTR [bx+24]
	jne	$I730
; Line 677
	mov	bx,WORD PTR [bp+4]	;e
	inc	BYTE PTR [bx]
	cmp	BYTE PTR [bx],4
	jbe	$I731
; Line 678
	mov	bx,WORD PTR [bp+4]	;e
	cmp	BYTE PTR [bx+10],0
	je	$I732
; Line 679
	mov	BYTE PTR [bx],1
; Line 680
	or	di,2
; Line 681
	jmp	SHORT $I731
	nop	
$L787:
	mov	di,WORD PTR [bp-2]	;changed
	jmp	SHORT $I727
	nop	
$I732:
; Line 682
	mov	BYTE PTR [bx],0
	jmp	SHORT $I730
	nop	
; Line 686
$I731:
	push	WORD PTR [bp+4]	;e
	call	_snd_2C59
	add	sp,2
; Line 688
$I730:
	mov	ax,di
; Line 689
	pop	si
	pop	di
	leave	
	ret	
	nop	

_snd_2D33	ENDP
	PUBLIC	_snd_2DD3
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
	jne	$I739
	xor	ax,ax
	pop	si
	pop	di
	leave	
	ret	
	nop	
; Line 694
$I739:
	cmp	BYTE PTR [bp+6],31	;001fH	;scale
	jne	$I740
	mov	ax,WORD PTR [bp+4]	;value
	pop	si
	pop	di
	leave	
	ret	
	nop	
; Line 695
$I740:
	mov	si,WORD PTR [bp+4]	;value
	cmp	si,63	;003fH
	jg	$I741
	cmp	si,-63	;ffc1H
	jl	$I741
; Line 696
	cmp	BYTE PTR [bp+6],0	;scale
	jge	$I742
	or	si,si
	jge	$I743
	mov	al,BYTE PTR [bp+6]	;scale
	cbw	
	mov	bx,OFFSET _snd_volume_products
	sub	bx,ax
	mov	ax,si
	shl	ax,5
	sub	bx,ax
	mov	al,BYTE PTR [bx]
$L815:
	sub	ah,ah
	pop	si
	pop	di
	leave	
	ret	
	nop	
$I743:
	mov	al,BYTE PTR [bp+6]	;scale
	cbw	
	mov	bx,si
	shl	bx,5
	jmp	SHORT $L814
	nop	
$I742:
	or	si,si
	jge	$I745
	mov	al,BYTE PTR [bp+6]	;scale
	cbw	
	mov	bx,ax
	mov	ax,si
	shl	ax,5
$L814:
	sub	bx,ax
	mov	al,BYTE PTR _snd_volume_products[bx]
	sub	ah,ah
	neg	ax
	pop	si
	pop	di
	leave	
	ret	
	nop	
$I745:
	mov	bx,si
	shl	bx,5
	mov	al,BYTE PTR [bp+6]	;scale
	cbw	
	mov	di,ax
	mov	al,BYTE PTR _snd_volume_products[bx][di]
	jmp	SHORT $L815
	nop	
; Line 704
$I741:
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
	PUBLIC	_snd_2E7A
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
	je	$I751
	xor	BYTE PTR [bp-1],184	;00b8H	;state
; Line 715
$I751:
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
_TEXT	ENDS
END
