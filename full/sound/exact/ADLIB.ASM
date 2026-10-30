; Executable specification transcribed from SNAKE.EXE segment 1341.
; Scope: 1E1A..2E9B, 52 AdLib part/voice/envelope procedures.
; This is a symbolic disassembly reconstruction, NOT a recovered historical
; assembler source and NOT evidence of a byte-exact C recompilation.
; The independently recovered typed C remains in ../ADLIB.C and ADLIB.H.
; The build assembles these mnemonics and symbolic references only.
.286
_TEXT segment word public 'CODE'
assume cs:_TEXT, ds:DGROUP
extrn _snd_04D9:near
extrn _snd_04F4:near
extrn _snd_053D:near
extrn _snd_1DC6:near
extrn _snd_2E9B:near
extrn _snd_2F48:near
extrn _snd_2F6F:near
extrn _snd_2F94:near
extrn _snd_2FA0:near
extrn _snd_2FB1:near
extrn _snd_304C:near


; Advance voice and envelope timers
public _snd_1E1A
_snd_1E1A label near
    push di ; 1E1A
    push si ; 1E1B
    add byte ptr [_snd_voice_tick], 3 ; 1E1C
    cmp byte ptr [_snd_voice_tick], 0Ah ; 1E21
    jb L1E80 ; 1E26
    sub byte ptr [_snd_voice_tick], 0Ah ; 1E28
    mov si, offset _snd_voices ; 1E2D
    mov di, 9 ; 1E30
L1E33:
    cmp word ptr [si], 0 ; 1E33
    je L1E72 ; 1E36
    cmp word ptr [si + 0Ch], 0 ; 1E38
    je L1E48 ; 1E3C
    sub word ptr [si + 0Ch], 011h ; 1E3E
    cmp word ptr [si + 0Ch], 0 ; 1E42
    jle L1E7A ; 1E46
L1E48:
    cmp byte ptr [si + 0Eh], 0 ; 1E48
    je L1E5D ; 1E4C
    lea ax, [si + 030h] ; 1E4E
    push ax ; 1E51
    lea ax, [si + 0Eh] ; 1E52
    push ax ; 1E55
    push si ; 1E56
    call near ptr _snd_28FB ; 1E57
    add sp, 6 ; 1E5A
L1E5D:
    cmp byte ptr [si + 038h], 0 ; 1E5D
    je L1E72 ; 1E61
    lea ax, [si + 05Ah] ; 1E63
    push ax ; 1E66
    lea ax, [si + 038h] ; 1E67
    push ax ; 1E6A
    push si ; 1E6B
    call near ptr _snd_28FB ; 1E6C
    add sp, 6 ; 1E6F
L1E72:
    add si, 062h ; 1E72
    dec di ; 1E75
    je L1E80 ; 1E76
    jmp short L1E33 ; 1E78
L1E7A:
    push si ; 1E7A
    call near ptr _snd_2BC4 ; 1E7B
    inc sp ; 1E7E
    inc sp ; 1E7F
L1E80:
    pop si ; 1E80
    pop di ; 1E81
    ret ; 1E82

; Allocate and initialize an instrument part from a preset
public _snd_1E83
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
    jne L1EB6 ; 1EB1
    jmp near ptr L1F9E ; 1EB3
L1EB6:
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
    je L1F37 ; 1F1B
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
L1F37:
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
L1F9E:
    pop si ; 1F9E
    pop di ; 1F9F
    leave ; 1FA0
    ret ; 1FA1

; Recursively release parts belonging to a channel
public _snd_1FA2
_snd_1FA2 label near
    enter 0, 0 ; 1FA2
    push si ; 1FA6
    mov si, word ptr [bp + 4] ; 1FA7
    or si, si ; 1FAA
    je L1FC9 ; 1FAC
    mov al, byte ptr [bp + 6] ; 1FAE
    push ax ; 1FB1
    push word ptr [si + 4] ; 1FB2
    call near ptr _snd_1FA2 ; 1FB5
    add sp, 4 ; 1FB8
    mov al, byte ptr [bp + 6] ; 1FBB
    cmp byte ptr [si + 0Bh], al ; 1FBE
    jne L1FC9 ; 1FC1
    push si ; 1FC3
    call near ptr _snd_20AA ; 1FC4
    inc sp ; 1FC7
    inc sp ; 1FC8
L1FC9:
    pop si ; 1FC9
    leave ; 1FCA
    ret ; 1FCB

; Release all parts and reset held notes
public _snd_1FCC
_snd_1FCC label near
    push si ; 1FCC
    mov si, offset _snd_parts ; 1FCD
L1FD0:
    push si ; 1FD0
    call near ptr _snd_20AA ; 1FD1
    inc sp ; 1FD4
    inc sp ; 1FD5
    add si, 020h ; 1FD6
    cmp si, offset _snd_parts+1024 ; 1FD9
    jb L1FD0 ; 1FDD
    call near ptr _snd_1DC6 ; 1FDF
    pop si ; 1FE2
    ret ; 1FE3

; Find or allocate a player channel part
public _snd_1FE4
_snd_1FE4 label near
    enter 0, 0 ; 1FE4
    push si ; 1FE8
    push di ; 1FE9
    mov di, word ptr [bp + 4] ; 1FEA
    mov si, word ptr [di + 4] ; 1FED
L1FF0:
    or si, si ; 1FF0
    je L2004 ; 1FF2
    mov al, byte ptr [bp + 6] ; 1FF4
    cmp byte ptr [si + 0Bh], al ; 1FF7
    jne L1FFF ; 1FFA
    jmp near ptr L20A4 ; 1FFC
L1FFF:
    mov si, word ptr [si + 4] ; 1FFF
    jmp short L1FF0 ; 2002
L2004:
    mov al, byte ptr [di + 0Ch] ; 2004
    push ax ; 2007
    call near ptr _snd_2129 ; 2008
    inc sp ; 200B
    inc sp ; 200C
    or ax, ax ; 200D
    jne L2015 ; 200F
    pop di ; 2011
    pop si ; 2012
    leave ; 2013
    ret ; 2014
L2015:
    mov si, ax ; 2015
    mov word ptr [si], di ; 2017
    mov word ptr [si + 2], 0 ; 2019
    mov bx, word ptr [di + 4] ; 201E
    mov word ptr [si + 4], bx ; 2021
    mov word ptr [di + 4], si ; 2024
    or bx, bx ; 2027
    je L202E ; 2029
    mov word ptr [bx + 2], si ; 202B
L202E:
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
L20A4:
    mov ax, si ; 20A4
    pop di ; 20A6
    pop si ; 20A7
    leave ; 20A8
    ret ; 20A9

; Unlink and release a part and its voices
public _snd_20AA
_snd_20AA label near
    enter 0, 0 ; 20AA
    push si ; 20AE
    mov si, word ptr [bp + 4] ; 20AF
    cmp word ptr [si], 0 ; 20B2
    je L20E4 ; 20B5
    push si ; 20B7
    call near ptr _snd_2772 ; 20B8
    inc sp ; 20BB
    inc sp ; 20BC
    mov ax, word ptr [si + 2] ; 20BD
    mov bx, word ptr [si + 4] ; 20C0
    or bx, bx ; 20C3
    je L20CA ; 20C5
    mov word ptr [bx + 2], ax ; 20C7
L20CA:
    or ax, ax ; 20CA
    je L20D4 ; 20CC
    xchg bx, ax ; 20CE
    mov word ptr [bx + 4], ax ; 20CF
    jmp short L20DA ; 20D2
L20D4:
    mov ax, word ptr [si] ; 20D4
    xchg bx, ax ; 20D6
    mov word ptr [bx + 4], ax ; 20D7
L20DA:
    xor ax, ax ; 20DA
    mov word ptr [si], ax ; 20DC
    mov word ptr [si + 2], ax ; 20DE
    mov word ptr [si + 4], ax ; 20E1
L20E4:
    pop si ; 20E4
    leave ; 20E5
    ret ; 20E6

; Release every part owned by a player
public _snd_20E7
_snd_20E7 label near
    enter 0, 0 ; 20E7
    push si ; 20EB
    mov si, word ptr [bp + 4] ; 20EC
    jmp short L20F9 ; 20EF
L20F1:
    push word ptr [si + 4] ; 20F1
    call near ptr _snd_20AA ; 20F4
    inc sp ; 20F7
    inc sp ; 20F8
L20F9:
    cmp word ptr [si + 4], 0 ; 20F9
    jne L20F1 ; 20FD
    pop si ; 20FF
    leave ; 2100
    ret ; 2101

; Link a part into its player list
public _snd_2102
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
    je L2126 ; 211F
    mov si, ax ; 2121
    mov word ptr [si + 2], bx ; 2123
L2126:
    pop si ; 2126
    leave ; 2127
    ret ; 2128

; Allocate a free part or steal one by priority
public _snd_2129
_snd_2129 label near
    enter 0, 0 ; 2129
    push si ; 212D
    push di ; 212E
    mov si, offset _snd_parts ; 212F
    xor di, di ; 2132
    xor dx, dx ; 2134
L2136:
    cmp word ptr [si], 0 ; 2136
    je L2156 ; 2139
    mov al, byte ptr [bp + 4] ; 213B
    cmp byte ptr [si + 0Fh], al ; 213E
    ja L214B ; 2141
    mov al, byte ptr [si + 0Fh] ; 2143
    mov byte ptr [bp + 4], al ; 2146
    mov di, si ; 2149
L214B:
    add si, 020h ; 214B
    inc dx ; 214E
    cmp dx, 020h ; 214F
    jl L2136 ; 2152
    jmp short L215C ; 2154
L2156:
    mov ax, si ; 2156
    pop di ; 2158
    pop si ; 2159
    leave ; 215A
    ret ; 215B
L215C:
    or di, di ; 215C
    je L2166 ; 215E
    push di ; 2160
    call near ptr _snd_20AA ; 2161
    inc sp ; 2164
    inc sp ; 2165
L2166:
    mov ax, di ; 2166
    pop di ; 2168
    pop si ; 2169
    leave ; 216A
    ret ; 216B

; Start a note on a player channel
public _snd_216C
_snd_216C label near
    enter 0, 0 ; 216C
    push si ; 2170
    mov al, byte ptr [bp + 6] ; 2171
    push ax ; 2174
    push word ptr [bp + 4] ; 2175
    call near ptr _snd_1FE4 ; 2178
    add sp, 4 ; 217B
    or ax, ax ; 217E
    je L219F ; 2180
    mov si, ax ; 2182
    cmp byte ptr [si + 0Dh], 0 ; 2184
    je L219F ; 2188
    cmp byte ptr [si + 0Ch], 0 ; 218A
    jne L219F ; 218E
    mov al, byte ptr [bp + 0Ah] ; 2190
    push ax ; 2193
    mov al, byte ptr [bp + 8] ; 2194
    push ax ; 2197
    push si ; 2198
    call near ptr _snd_2709 ; 2199
    add sp, 6 ; 219C
L219F:
    pop si ; 219F
    leave ; 21A0
    ret ; 21A1

; Stop or sustain a note on a player channel
public _snd_21A2
_snd_21A2 label near
    enter 0, 0 ; 21A2
    push si ; 21A6
    mov bx, word ptr [bp + 4] ; 21A7
    mov si, word ptr [bx + 4] ; 21AA
L21AD:
    or si, si ; 21AD
    je L21EC ; 21AF
    mov al, byte ptr [bp + 6] ; 21B1
    cmp byte ptr [si + 0Bh], al ; 21B4
    jne L21E7 ; 21B7
    cmp byte ptr [si + 0Dh], 0 ; 21B9
    je L21E7 ; 21BD
    cmp byte ptr [si + 0Ch], 0 ; 21BF
    jne L21E7 ; 21C3
    cmp byte ptr [si + 019h], 0 ; 21C5
    je L21DA ; 21C9
    mov al, byte ptr [bp + 8] ; 21CB
    push ax ; 21CE
    push word ptr [si + 6] ; 21CF
    call near ptr _snd_28BD ; 21D2
    add sp, 4 ; 21D5
    jmp short L21E7 ; 21D8
L21DA:
    mov al, byte ptr [bp + 8] ; 21DA
    push ax ; 21DD
    push word ptr [si + 6] ; 21DE
    call near ptr _snd_2750 ; 21E1
    add sp, 4 ; 21E4
L21E7:
    mov si, word ptr [si + 4] ; 21E7
    jmp short L21AD ; 21EA
L21EC:
    pop si ; 21EC
    leave ; 21ED
    ret ; 21EE

; Stop voices on a list of parts
public _snd_21EF
_snd_21EF label near
    enter 0, 0 ; 21EF
    push si ; 21F3
    mov si, word ptr [bp + 4] ; 21F4
L21F7:
    or si, si ; 21F7
    je L2206 ; 21F9
    push si ; 21FB
    call near ptr _snd_2772 ; 21FC
    inc sp ; 21FF
    inc sp ; 2200
    mov si, word ptr [si + 4] ; 2201
    jmp short L21F7 ; 2204
L2206:
    pop si ; 2206
    leave ; 2207
    ret ; 2208

; Release sustained voices on a list of parts
public _snd_2209
_snd_2209 label near
    enter 0, 0 ; 2209
    push si ; 220D
    mov si, word ptr [bp + 4] ; 220E
L2211:
    or si, si ; 2211
    je L222C ; 2213
    cmp byte ptr [si + 019h], 0 ; 2215
    je L2227 ; 2219
    mov byte ptr [si + 019h], 0 ; 221B
    push word ptr [si + 6] ; 221F
    call near ptr _snd_28DB ; 2222
    inc sp ; 2225
    inc sp ; 2226
L2227:
    mov si, word ptr [si + 4] ; 2227
    jmp short L2211 ; 222A
L222C:
    pop si ; 222C
    leave ; 222D
    ret ; 222E

; Collect note/channel masks from active voices
public _snd_222F
_snd_222F label near
    enter 0, 0 ; 222F
    push di ; 2233
    push si ; 2234
    mov dx, word ptr [bp + 6] ; 2235
    mov cx, word ptr [bp + 8] ; 2238
    mov si, word ptr [bp + 4] ; 223B
L223E:
    or si, si ; 223E
    je L2273 ; 2240
    mov di, word ptr [si + 6] ; 2242
    or di, di ; 2245
    je L226E ; 2247
    mov bl, byte ptr [si + 0Bh] ; 2249
    xor bh, bh ; 224C
    shl bx, 1 ; 224E
    mov ax, word ptr [bx + _snd_channel_masks] ; 2250
L2254:
    mov bl, byte ptr [di + 8] ; 2254
    xor bh, bh ; 2257
    shl bx, 1 ; 2259
    add bx, dx ; 225B
    test word ptr [bx], ax ; 225D
    jne L2267 ; 225F
    or word ptr [bx], ax ; 2261
    mov bx, cx ; 2263
    inc word ptr [bx] ; 2265
L2267:
    mov di, word ptr [di + 4] ; 2267
    or di, di ; 226A
    jne L2254 ; 226C
L226E:
    mov si, word ptr [si + 4] ; 226E
    jmp short L223E ; 2271
L2273:
    pop si ; 2273
    pop di ; 2274
    leave ; 2275
    ret ; 2276

; Set instrument program
public _snd_2277
_snd_2277 label near
    enter 0, 0 ; 2277
    push si ; 227B
    mov al, byte ptr [bp + 6] ; 227C
    push ax ; 227F
    push word ptr [bp + 4] ; 2280
    call near ptr _snd_1FE4 ; 2283
    add sp, 4 ; 2286
    or ax, ax ; 2289
    je L22A1 ; 228B
    mov si, ax ; 228D
    mov al, byte ptr [bp + 8] ; 228F
    mov byte ptr [si + 0Ah], al ; 2292
    push ax ; 2295
    push si ; 2296
    call near ptr _snd_269B ; 2297
    add sp, 4 ; 229A
    mov byte ptr [si + 0Ch], 0 ; 229D
L22A1:
    pop si ; 22A1
    leave ; 22A2
    ret ; 22A3

; Set a custom instrument
public _snd_22A4
_snd_22A4 label near
    enter 0, 0 ; 22A4
    push si ; 22A8
    mov al, byte ptr [bp + 6] ; 22A9
    push ax ; 22AC
    push word ptr [bp + 4] ; 22AD
    call near ptr _snd_1FE4 ; 22B0
    add sp, 4 ; 22B3
    or ax, ax ; 22B6
    je L22CA ; 22B8
    mov si, ax ; 22BA
    push word ptr [bp + 8] ; 22BC
    push si ; 22BF
    call near ptr _snd_2665 ; 22C0
    add sp, 4 ; 22C3
    mov byte ptr [si + 0Ch], 0 ; 22C6
L22CA:
    pop si ; 22CA
    leave ; 22CB
    ret ; 22CC

; Set an instrument parameter
public _snd_22CD
_snd_22CD label near
    enter 0, 0 ; 22CD
    mov al, byte ptr [bp + 6] ; 22D1
    push ax ; 22D4
    push word ptr [bp + 4] ; 22D5
    call near ptr _snd_1FE4 ; 22D8
    add sp, 4 ; 22DB
    or ax, ax ; 22DE
    je L22EF ; 22E0
    push word ptr [bp + 0Ah] ; 22E2
    push word ptr [bp + 8] ; 22E5
    push ax ; 22E8
    call near ptr _snd_26C3 ; 22E9
    add sp, 6 ; 22EC
L22EF:
    leave ; 22EF
    ret ; 22F0

; Set effective part priority
public _snd_22F1
_snd_22F1 label near
    enter 0, 0 ; 22F1
    push si ; 22F5
    cmp byte ptr [bp + 6], 010h ; 22F6
    jne L2325 ; 22FA
    mov bx, word ptr [bp + 4] ; 22FC
    mov si, word ptr [bx + 4] ; 22FF
L2302:
    or si, si ; 2302
    je L2357 ; 2304
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
    jmp short L2302 ; 2323
L2325:
    mov al, byte ptr [bp + 6] ; 2325
    push ax ; 2328
    push word ptr [bp + 4] ; 2329
    call near ptr _snd_1FE4 ; 232C
    add sp, 4 ; 232F
    or ax, ax ; 2332
    je L2357 ; 2334
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
L2357:
    pop si ; 2357
    leave ; 2358
    ret ; 2359

; Set part volume and update its voices
public _snd_235A
_snd_235A label near
    enter 0, 0 ; 235A
    push si ; 235E
    cmp byte ptr [bp + 6], 010h ; 235F
    jne L2391 ; 2363
    mov bx, word ptr [bp + 4] ; 2365
    mov si, word ptr [bx + 4] ; 2368
L236B:
    or si, si ; 236B
    je L23C6 ; 236D
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
    jmp short L236B ; 238F
L2391:
    mov al, byte ptr [bp + 6] ; 2391
    push ax ; 2394
    push word ptr [bp + 4] ; 2395
    call near ptr _snd_1FE4 ; 2398
    add sp, 4 ; 239B
    or ax, ax ; 239E
    je L23CB ; 23A0
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
L23C6:
    xor ax, ax ; 23C6
    pop si ; 23C8
    leave ; 23C9
    ret ; 23CA
L23CB:
    mov ax, 0FFFFh ; 23CB
    pop si ; 23CE
    leave ; 23CF
    ret ; 23D0

; Empty reserved procedure
public _snd_23D1
_snd_23D1 label near
    ret ; 23D1

; Set part transposition
public _snd_23D2
_snd_23D2 label near
    enter 0, 0 ; 23D2
    push si ; 23D6
    cmp byte ptr [bp + 0Ah], 018h ; 23D7
    jle L23E0 ; 23DB
    jmp near ptr L247B ; 23DD
L23E0:
    cmp byte ptr [bp + 0Ah], 0E8h ; 23E0
    jge L23E9 ; 23E4
    jmp near ptr L247B ; 23E6
L23E9:
    cmp byte ptr [bp + 6], 010h ; 23E9
    jne L2425 ; 23ED
    mov bx, word ptr [bp + 4] ; 23EF
    mov si, word ptr [bx + 4] ; 23F2
L23F5:
    or si, si ; 23F5
    jne L23FC ; 23F7
    jmp near ptr L247B ; 23F9
L23FC:
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
    jmp short L23F5 ; 2423
L2425:
    mov al, byte ptr [bp + 6] ; 2425
    push ax ; 2428
    push word ptr [bp + 4] ; 2429
    call near ptr _snd_1FE4 ; 242C
    add sp, 4 ; 242F
    or ax, ax ; 2432
    je L247B ; 2434
    mov si, ax ; 2436
    mov al, byte ptr [bp + 0Ah] ; 2438
    cmp byte ptr [bp + 8], 0 ; 243B
    je L2455 ; 243F
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
L2455:
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
L247B:
    pop si ; 247B
    leave ; 247C
    ret ; 247D

; Set part detune
public _snd_247E
_snd_247E label near
    enter 0, 0 ; 247E
    push si ; 2482
    cmp byte ptr [bp + 6], 010h ; 2483
    jne L24C3 ; 2487
    mov bx, word ptr [bp + 4] ; 2489
    mov si, word ptr [bx + 4] ; 248C
L248F:
    or si, si ; 248F
    je L2506 ; 2491
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
    jmp short L248F ; 24C1
L24C3:
    mov al, byte ptr [bp + 6] ; 24C3
    push ax ; 24C6
    push word ptr [bp + 4] ; 24C7
    call near ptr _snd_1FE4 ; 24CA
    add sp, 4 ; 24CD
    or ax, ax ; 24D0
    je L2506 ; 24D2
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
L2506:
    pop si ; 2506
    leave ; 2507
    ret ; 2508

; Set part enable state
public _snd_2509
_snd_2509 label near
    enter 0, 0 ; 2509
    push si ; 250D
    mov al, byte ptr [bp + 6] ; 250E
    push ax ; 2511
    push word ptr [bp + 4] ; 2512
    call near ptr _snd_1FE4 ; 2515
    add sp, 4 ; 2518
    or ax, ax ; 251B
    je L2536 ; 251D
    mov si, ax ; 251F
    mov al, byte ptr [bp + 8] ; 2521
    mov byte ptr [si + 0Dh], al ; 2524
    or al, al ; 2527
    jne L2531 ; 2529
    push si ; 252B
    call near ptr _snd_2772 ; 252C
    inc sp ; 252F
    inc sp ; 2530
L2531:
    xor ax, ax ; 2531
    pop si ; 2533
    leave ; 2534
    ret ; 2535
L2536:
    mov ax, 0FFFFh ; 2536
    pop si ; 2539
    leave ; 253A
    ret ; 253B

; Set part modulation
public _snd_253C
_snd_253C label near
    enter 0, 0 ; 253C
    push si ; 2540
    mov al, byte ptr [bp + 6] ; 2541
    push ax ; 2544
    push word ptr [bp + 4] ; 2545
    call near ptr _snd_1FE4 ; 2548
    add sp, 4 ; 254B
    or ax, ax ; 254E
    je L2564 ; 2550
    mov si, ax ; 2552
    mov al, byte ptr [bp + 8] ; 2554
    mov byte ptr [si + 018h], al ; 2557
    push ax ; 255A
    push word ptr [si + 6] ; 255B
    call near ptr _snd_2B03 ; 255E
    add sp, 4 ; 2561
L2564:
    pop si ; 2564
    leave ; 2565
    ret ; 2566

; Set sustain-pedal state
public _snd_2567
_snd_2567 label near
    enter 0, 0 ; 2567
    push si ; 256B
    mov al, byte ptr [bp + 6] ; 256C
    push ax ; 256F
    push word ptr [bp + 4] ; 2570
    call near ptr _snd_1FE4 ; 2573
    add sp, 4 ; 2576
    or ax, ax ; 2579
    je L2591 ; 257B
    mov si, ax ; 257D
    mov al, byte ptr [bp + 8] ; 257F
    mov byte ptr [si + 019h], al ; 2582
    or al, al ; 2585
    jne L2591 ; 2587
    push word ptr [si + 6] ; 2589
    call near ptr _snd_28DB ; 258C
    inc sp ; 258F
    inc sp ; 2590
L2591:
    pop si ; 2591
    leave ; 2592
    ret ; 2593

; Set pitch bend
public _snd_2594
_snd_2594 label near
    enter 0, 0 ; 2594
    push si ; 2598
    mov al, byte ptr [bp + 6] ; 2599
    push ax ; 259C
    push word ptr [bp + 4] ; 259D
    call near ptr _snd_1FE4 ; 25A0
    add sp, 4 ; 25A3
    or ax, ax ; 25A6
    je L25E4 ; 25A8
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
L25E4:
    pop si ; 25E4
    leave ; 25E5
    ret ; 25E6

; Set pitch-bend range; preserves original pointer/channel anomaly
public _snd_25E7
_snd_25E7 label near
    enter 0, 0 ; 25E7
    push si ; 25EB
    cmp byte ptr [bp + 8], 0Ch ; 25EC
    ja L2617 ; 25F0
    mov al, byte ptr [bp + 6] ; 25F2
    push ax ; 25F5
    push word ptr [bp + 4] ; 25F6
    call near ptr _snd_1FE4 ; 25F9
    add sp, 4 ; 25FC
    or ax, ax ; 25FF
    je L2617 ; 2601
    mov si, ax ; 2603
    push 0 ; 2605
    push ax ; 2607
    push word ptr [bp + 4] ; 2608
    call near ptr _snd_2594 ; 260B
    add sp, 6 ; 260E
    mov al, byte ptr [bp + 8] ; 2611
    mov byte ptr [si + 01Ah], al ; 2614
L2617:
    pop si ; 2617
    leave ; 2618
    ret ; 2619

; Read a part parameter
public _snd_261A
_snd_261A label near
    enter 0, 0 ; 261A
    mov bx, word ptr [bp + 4] ; 261E
    mov bx, word ptr [bx + 4] ; 2621
    mov al, byte ptr [bp + 8] ; 2624
L2627:
    or bx, bx ; 2627
    je L2661 ; 2629
    cmp byte ptr [bx + 0Bh], al ; 262B
    je L2635 ; 262E
    mov bx, word ptr [bx + 4] ; 2630
    jmp short L2627 ; 2633
L2635:
    mov al, byte ptr [bp + 6] ; 2635
    xor ah, ah ; 2638
    sub ax, 0Eh ; 263A
    je L264D ; 263D
    dec ax ; 263F
    je L2652 ; 2640
    dec ax ; 2642
    je L2657 ; 2643
    dec ax ; 2645
    je L265C ; 2646
    mov ax, 0FFFFh ; 2648
    leave ; 264B
    ret ; 264C
L264D:
    mov al, byte ptr [bx + 0Dh] ; 264D
    leave ; 2650
    ret ; 2651
L2652:
    mov al, byte ptr [bx + 010h] ; 2652
    leave ; 2655
    ret ; 2656
L2657:
    mov al, byte ptr [bx + 0Ah] ; 2657
    leave ; 265A
    ret ; 265B
L265C:
    mov al, byte ptr [bx + 014h] ; 265C
    leave ; 265F
    ret ; 2660
L2661:
    mov al, 081h ; 2661
    leave ; 2663
    ret ; 2664

; Copy custom instrument to a part
public _snd_2665
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
public _snd_2679
_snd_2679 label near
    enter 0, 0 ; 2679
    push si ; 267D
    mov al, byte ptr [bp + 4] ; 267E
    cmp al, 020h ; 2681
    jae L2698 ; 2683
    mov cx, 01Eh ; 2685
    mul cl ; 2688
    add ax, offset _snd_global_instruments ; 268A
    push cx ; 268D
    push word ptr [bp + 6] ; 268E
    push ax ; 2691
    call near ptr _snd_053D ; 2692
    add sp, 6 ; 2695
L2698:
    pop si ; 2698
    leave ; 2699
    ret ; 269A

; Select a global or default instrument
public _snd_269B
_snd_269B label near
    enter 0, 0 ; 269B
    mov al, byte ptr [bp + 6] ; 269F
    mov cx, 01Eh ; 26A2
    cmp al, 020h ; 26A5
    jae L26B0 ; 26A7
    mul cl ; 26A9
    add ax, offset _snd_global_instruments ; 26AB
    jmp short L26B3 ; 26AE
L26B0:
    mov ax, offset _snd_default_instrument ; 26B0
L26B3:
    mov bx, word ptr [bp + 4] ; 26B3
    push cx ; 26B6
    push ax ; 26B7
    push word ptr [bx + 8] ; 26B8
    call near ptr _snd_053D ; 26BB
    add sp, 6 ; 26BE
    leave ; 26C1
    ret ; 26C2

; Modify instrument field; preserves original DI-clobber anomaly
public _snd_26C3
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
public _snd_2709
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
    je L274C ; 271F
    mov si, ax ; 2721
    mov word ptr [si], di ; 2723
    mov bx, word ptr [di + 6] ; 2725
    mov word ptr [si + 4], bx ; 2728
    mov word ptr [si + 2], 0 ; 272B
    mov word ptr [di + 6], si ; 2730
    or bx, bx ; 2733
    je L273A ; 2735
    mov word ptr [bx + 2], si ; 2737
L273A:
    mov al, byte ptr [bp + 8] ; 273A
    xor ah, ah ; 273D
    push ax ; 273F
    mov al, byte ptr [bp + 6] ; 2740
    push ax ; 2743
    push si ; 2744
    push di ; 2745
    call near ptr _snd_278D ; 2746
    add sp, 8 ; 2749
L274C:
    pop si ; 274C
    pop di ; 274D
    leave ; 274E
    ret ; 274F

; Stop a matching note in a voice list
public _snd_2750
_snd_2750 label near
    enter 0, 0 ; 2750
    push si ; 2754
    mov si, word ptr [bp + 4] ; 2755
L2758:
    or si, si ; 2758
    je L276F ; 275A
    mov al, byte ptr [bp + 6] ; 275C
    cmp byte ptr [si + 8], al ; 275F
    jne L276A ; 2762
    push si ; 2764
    call near ptr _snd_2BC4 ; 2765
    inc sp ; 2768
    inc sp ; 2769
L276A:
    mov si, word ptr [si + 4] ; 276A
    jmp short L2758 ; 276D
L276F:
    pop si ; 276F
    leave ; 2770
    ret ; 2771

; Stop every voice belonging to a part
public _snd_2772
_snd_2772 label near
    enter 0, 0 ; 2772
    push si ; 2776
    mov si, word ptr [bp + 4] ; 2777
L277A:
    cmp word ptr [si + 6], 0 ; 277A
    je L278A ; 277E
    push word ptr [si + 6] ; 2780
    call near ptr _snd_2BC4 ; 2783
    inc sp ; 2786
    inc sp ; 2787
    jmp short L277A ; 2788
L278A:
    pop si ; 278A
    leave ; 278B
    ret ; 278C

; Program a new voice and initialize its two envelopes
public _snd_278D
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
    je L27C6 ; 27BB
    mov ax, 03Fh ; 27BD
    imul word ptr [si + 0Ch] ; 27C0
    mov word ptr [si + 0Ch], ax ; 27C3
L27C6:
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
    jbe L27F4 ; 27F0
    mov al, 03Fh ; 27F2
L27F4:
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
    jbe L2817 ; 2813
    mov al, 03Fh ; 2815
L2817:
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
    jne L2843 ; 2836
    xor bh, bh ; 2838
    shl bx, 5 ; 283A
    add bx, ax ; 283D
    mov bl, byte ptr [bx + _snd_volume_products] ; 283F
L2843:
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
    je L2889 ; 286A
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
    jmp short L288D ; 2887
L2889:
    mov byte ptr [si + 0Eh], 0 ; 2889
L288D:
    mov bx, word ptr [bp - 2] ; 288D
    test byte ptr [bx + 014h], 080h ; 2890
    je L28B5 ; 2894
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
L28B5:
    mov byte ptr [si + 038h], 0 ; 28B5
    pop si ; 28B9
    pop di ; 28BA
    leave ; 28BB
    ret ; 28BC

; Mark a note as sustained
public _snd_28BD
_snd_28BD label near
    enter 0, 0 ; 28BD
    mov bx, word ptr [bp + 4] ; 28C1
L28C4:
    or bx, bx ; 28C4
    je L28D9 ; 28C6
    mov al, byte ptr [bp + 6] ; 28C8
    cmp byte ptr [bx + 8], al ; 28CB
    jne L28D4 ; 28CE
    mov byte ptr [bx + 0Bh], 1 ; 28D0
L28D4:
    mov bx, word ptr [bx + 4] ; 28D4
    jmp short L28C4 ; 28D7
L28D9:
    leave ; 28D9
    ret ; 28DA

; Release sustained voices
public _snd_28DB
_snd_28DB label near
    enter 0, 0 ; 28DB
    push si ; 28DF
    mov si, word ptr [bp + 4] ; 28E0
L28E3:
    or si, si ; 28E3
    je L28F8 ; 28E5
    cmp byte ptr [si + 0Bh], 0 ; 28E7
    je L28F3 ; 28EB
    push si ; 28ED
    call near ptr _snd_2BC4 ; 28EE
    inc sp ; 28F1
    inc sp ; 28F2
L28F3:
    mov si, word ptr [si + 4] ; 28F3
    jmp short L28E3 ; 28F6
L28F8:
    pop si ; 28F8
    leave ; 28F9
    ret ; 28FA

; Advance one envelope and apply its parameter change
public _snd_28FB
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
    je L298B ; 2916
    mov cl, byte ptr [si + 2] ; 2918
    xor ch, ch ; 291B
    cmp cl, 0 ; 291D
    je L293B ; 2920
    cmp cl, 0Dh ; 2922
    je L2948 ; 2925
    cmp cl, 01Eh ; 2927
    je L2979 ; 292A
    cmp cl, 01Fh ; 292C
    je L2983 ; 292F
    mov bx, word ptr [bp + 6] ; 2931
    mov ax, word ptr [bx + 8] ; 2934
    add ax, word ptr [si] ; 2937
    jmp short L296E ; 2939
L293B:
    mov bx, word ptr [bp + 6] ; 293B
    mov al, byte ptr [bx + 8] ; 293E
    add al, byte ptr [si] ; 2941
    mov byte ptr [di + 9], al ; 2943
    jmp short L2959 ; 2946
L2948:
    mov bx, word ptr [bp + 6] ; 2948
    mov al, byte ptr [bx + 8] ; 294B
    add al, byte ptr [si] ; 294E
    mov byte ptr [di + 0Ah], al ; 2950
    cmp byte ptr [di + 6], 1 ; 2953
    jne L296E ; 2957
L2959:
    xor ah, ah ; 2959
    shl ax, 5 ; 295B
    mov bx, word ptr [di] ; 295E
    mov bl, byte ptr [bx + 011h] ; 2960
    shr bl, 2 ; 2963
    xor bh, bh ; 2966
    add bx, ax ; 2968
    mov al, byte ptr [bx + _snd_volume_products] ; 296A
L296E:
    push ax ; 296E
    push cx ; 296F
    push di ; 2970
    call near ptr _snd_2FB1 ; 2971
    add sp, 6 ; 2974
    jmp short L298B ; 2977
L2979:
    mov al, byte ptr [si] ; 2979
    mov bx, word ptr [si + 6] ; 297B
    mov byte ptr [bx + 014h], al ; 297E
    jmp short L298B ; 2981
L2983:
    mov al, byte ptr [si] ; 2983
    mov bx, word ptr [si + 6] ; 2985
    mov byte ptr [bx + 013h], al ; 2988
L298B:
    test byte ptr [bp - 2], 2 ; 298B
    je L299D ; 298F
    cmp byte ptr [si + 4], 0 ; 2991
    je L299D ; 2995
    mov ah, byte ptr [di + 7] ; 2997
    call near ptr _snd_2FA0 ; 299A
L299D:
    pop si ; 299D
    pop di ; 299E
    leave ; 299F
    ret ; 29A0

; Initialize an envelope and its companion work record
public _snd_29A1
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
    je L29F9 ; 29EF
    mov bx, word ptr [di] ; 29F1
    mov al, byte ptr [bx + 018h] ; 29F3
    shr al, 2 ; 29F6
L29F9:
    mov byte ptr [si + 014h], al ; 29F9
    mov bx, dx ; 29FC
    mov al, byte ptr [bx + 2] ; 29FE
    xor ah, ah ; 2A01
    or al, al ; 2A03
    je L2A26 ; 2A05
    cmp al, 0Dh ; 2A07
    je L2A2E ; 2A09
    cmp al, 01Eh ; 2A0B
    je L2A36 ; 2A0D
    cmp al, 01Fh ; 2A0F
    je L2A44 ; 2A11
    mov al, byte ptr [bx + 2] ; 2A13
    push ax ; 2A16
    mov al, byte ptr [di + 7] ; 2A17
    push ax ; 2A1A
    call near ptr _snd_304C ; 2A1B
    add sp, 4 ; 2A1E
    mov word ptr [si + 8], ax ; 2A21
    jmp short L2A50 ; 2A24
L2A26:
    mov al, byte ptr [di + 9] ; 2A26
    mov word ptr [si + 8], ax ; 2A29
    jmp short L2A50 ; 2A2C
L2A2E:
    mov al, byte ptr [di + 0Ah] ; 2A2E
    mov word ptr [si + 8], ax ; 2A31
    jmp short L2A50 ; 2A34
L2A36:
    mov word ptr [si + 8], 01Fh ; 2A36
    mov bx, word ptr [bx + 6] ; 2A3B
    mov byte ptr [bx + 014h], 0 ; 2A3E
    jmp short L2A50 ; 2A42
L2A44:
    mov word ptr [si + 8], 0 ; 2A44
    mov bx, word ptr [bx + 6] ; 2A49
    mov byte ptr [bx + 013h], 0 ; 2A4C
L2A50:
    push word ptr [bp + 0Ch] ; 2A50
    push si ; 2A53
    call near ptr _snd_2BF6 ; 2A54
    add sp, 4 ; 2A57
    pop si ; 2A5A
    pop di ; 2A5B
    leave ; 2A5C
    ret ; 2A5D

; Set a parameter across a voice list
public _snd_2A5E
_snd_2A5E label near
    enter 0, 0 ; 2A5E
    push di ; 2A62
    push si ; 2A63
    mov si, word ptr [bp + 6] ; 2A64
    cmp si, 01Ch ; 2A67
    jge L2A83 ; 2A6A
    mov di, word ptr [bp + 4] ; 2A6C
L2A6F:
    or di, di ; 2A6F
    je L2A83 ; 2A71
    push word ptr [bp + 8] ; 2A73
    push si ; 2A76
    push di ; 2A77
    call near ptr _snd_2FB1 ; 2A78
    add sp, 6 ; 2A7B
    mov di, word ptr [di + 4] ; 2A7E
    jmp short L2A6F ; 2A81
L2A83:
    pop si ; 2A83
    pop di ; 2A84
    leave ; 2A85
    ret ; 2A86

; Recompute voice output levels
public _snd_2A87
_snd_2A87 label near
    enter 0, 0 ; 2A87
    push di ; 2A8B
    push si ; 2A8C
    mov al, byte ptr [bp + 6] ; 2A8D
    shr al, 2 ; 2A90
    xor ah, ah ; 2A93
    mov di, ax ; 2A95
    mov si, word ptr [bp + 4] ; 2A97
L2A9A:
    or si, si ; 2A9A
    je L2AD5 ; 2A9C
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
    jne L2AD0 ; 2AB8
    mov bl, byte ptr [si + 0Ah] ; 2ABA
    xor bh, bh ; 2ABD
    shl bx, 5 ; 2ABF
    mov al, byte ptr [bx + di + _snd_volume_products] ; 2AC2
    push ax ; 2AC6
    push 0Dh ; 2AC7
    push si ; 2AC9
    call near ptr _snd_2FB1 ; 2ACA
    add sp, 6 ; 2ACD
L2AD0:
    mov si, word ptr [si + 4] ; 2AD0
    jmp short L2A9A ; 2AD3
L2AD5:
    pop si ; 2AD5
    pop di ; 2AD6
    leave ; 2AD7
    ret ; 2AD8

; Transpose a list of voices
public _snd_2AD9
_snd_2AD9 label near
    enter 0, 0 ; 2AD9
    push si ; 2ADD
    mov si, word ptr [bp + 4] ; 2ADE
L2AE1:
    or si, si ; 2AE1
    je L2B00 ; 2AE3
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
    jmp short L2AE1 ; 2AFE
L2B00:
    pop si ; 2B00
    leave ; 2B01
    ret ; 2B02

; Update modulation envelope scaling
public _snd_2B03
_snd_2B03 label near
    enter 0, 0 ; 2B03
    mov bx, word ptr [bp + 4] ; 2B07
L2B0A:
    or bx, bx ; 2B0A
    je L2B3D ; 2B0C
    cmp byte ptr [bx + 0Eh], 0 ; 2B0E
    je L2B23 ; 2B12
    cmp byte ptr [bx + 033h], 0 ; 2B14
    je L2B23 ; 2B18
    mov al, byte ptr [bp + 6] ; 2B1A
    shr al, 2 ; 2B1D
    mov byte ptr [bx + 022h], al ; 2B20
L2B23:
    cmp byte ptr [bx + 038h], 0 ; 2B23
    je L2B38 ; 2B27
    cmp byte ptr [bx + 05Dh], 0 ; 2B29
    je L2B38 ; 2B2D
    mov al, byte ptr [bp + 6] ; 2B2F
    shr al, 2 ; 2B32
    mov byte ptr [bx + 04Ch], al ; 2B35
L2B38:
    mov bx, word ptr [bx + 4] ; 2B38
    jmp short L2B0A ; 2B3B
L2B3D:
    leave ; 2B3D
    ret ; 2B3E

; Retune a list of voices
public _snd_2B3F
_snd_2B3F label near
    enter 0, 0 ; 2B3F
    push di ; 2B43
    push si ; 2B44
    mov di, word ptr [bp + 6] ; 2B45
    mov si, word ptr [bp + 4] ; 2B48
L2B4B:
    or si, si ; 2B4B
    je L2B68 ; 2B4D
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
    jmp short L2B4B ; 2B66
L2B68:
    pop si ; 2B68
    pop di ; 2B69
    leave ; 2B6A
    ret ; 2B6B

; Allocate a free voice or steal a lower-priority voice
public _snd_2B6C
_snd_2B6C label near
    enter 0, 0 ; 2B6C
    push di ; 2B70
    push si ; 2B71
    mov dl, byte ptr [bp + 4] ; 2B72
    xor di, di ; 2B75
    mov cx, 9 ; 2B77
L2B7A:
    inc byte ptr [_snd_voice_counter] ; 2B7A
    cmp byte ptr [_snd_voice_counter], 9 ; 2B7E
    jb L2B8A ; 2B83
    mov byte ptr [_snd_voice_counter], 0 ; 2B85
L2B8A:
    mov al, 062h ; 2B8A
    mul byte ptr [_snd_voice_counter] ; 2B8C
    add ax, offset _snd_voices ; 2B90
    mov si, ax ; 2B93
    cmp word ptr [si], 0 ; 2B95
    je L2BBE ; 2B98
    cmp word ptr [si + 4], 0 ; 2B9A
    jne L2BAC ; 2B9E
    mov bx, word ptr [si] ; 2BA0
    cmp dl, byte ptr [bx + 0Fh] ; 2BA2
    jb L2BAC ; 2BA5
    mov dl, byte ptr [bx + 0Fh] ; 2BA7
    mov di, si ; 2BAA
L2BAC:
    loop L2B7A ; 2BAC
    or di, di ; 2BAE
    je L2BB8 ; 2BB0
    push di ; 2BB2
    call near ptr _snd_2BC4 ; 2BB3
    inc sp ; 2BB6
    inc sp ; 2BB7
L2BB8:
    mov ax, di ; 2BB8
    pop si ; 2BBA
    pop di ; 2BBB
    leave ; 2BBC
    ret ; 2BBD
L2BBE:
    mov ax, si ; 2BBE
    pop si ; 2BC0
    pop di ; 2BC1
    leave ; 2BC2
    ret ; 2BC3

; Stop and unlink one voice
public _snd_2BC4
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
    je L2BE0 ; 2BDB
    mov word ptr [si + 2], bx ; 2BDD
L2BE0:
    or bx, bx ; 2BE0
    je L2BE9 ; 2BE2
    mov word ptr [bx + 4], si ; 2BE4
    jmp short L2BEE ; 2BE7
L2BE9:
    mov bx, word ptr [di] ; 2BE9
    mov word ptr [bx + 6], si ; 2BEB
L2BEE:
    mov word ptr [di], 0 ; 2BEE
    pop si ; 2BF2
    pop di ; 2BF3
    leave ; 2BF4
    ret ; 2BF5

; Load envelope state from instrument bytes
public _snd_2BF6
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
    je L2C21 ; 2C16
    mov ax, 03Fh ; 2C18
    imul word ptr [si + 4] ; 2C1B
    mov word ptr [si + 4], ax ; 2C1E
L2C21:
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
public _snd_2C59
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
    je L2C9F ; 2C94
    push ax ; 2C96
    call near ptr _snd_2E7A ; 2C97
    inc sp ; 2C9A
    inc sp ; 2C9B
    mov word ptr [bp - 4], ax ; 2C9C
L2C9F:
    cmp word ptr [bp - 4], 0 ; 2C9F
    jne L2CA8 ; 2CA3
    inc word ptr [bp - 4] ; 2CA5
L2CA8:
    mov ax, word ptr [bp - 4] ; 2CA8
    mov word ptr [di + 016h], ax ; 2CAB
    mov word ptr [di + 018h], ax ; 2CAE
    cmp byte ptr [bp - 2], 2 ; 2CB1
    je L2D0F ; 2CB5
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
    je L2CED ; 2CE2
    push ax ; 2CE4
    call near ptr _snd_2E7A ; 2CE5
    inc sp ; 2CE8
    inc sp ; 2CE9
    mov word ptr [bp - 6], ax ; 2CEA
L2CED:
    add ax, si ; 2CED
    cmp ax, word ptr [bp - 8] ; 2CEF
    jle L2CFB ; 2CF2
    mov dx, word ptr [bp - 8] ; 2CF4
    sub dx, si ; 2CF7
    jmp short L2D08 ; 2CF9
L2CFB:
    mov dx, word ptr [bp - 6] ; 2CFB
    mov ax, dx ; 2CFE
    add ax, si ; 2D00
    jns L2D08 ; 2D02
    mov dx, si ; 2D04
    neg dx ; 2D06
L2D08:
    mov bx, dx ; 2D08
    sub bx, word ptr [di + 2] ; 2D0A
    jmp short L2D11 ; 2D0D
L2D0F:
    xor bx, bx ; 2D0F
L2D11:
    mov ax, bx ; 2D11
    cwd ; 2D13
    idiv word ptr [bp - 4] ; 2D14
    mov word ptr [di + 01Ah], ax ; 2D17
    mov al, 1 ; 2D1A
    or bx, bx ; 2D1C
    jge L2D24 ; 2D1E
    neg dx ; 2D20
    neg al ; 2D22
L2D24:
    mov byte ptr [di + 01Ch], al ; 2D24
    mov word ptr [di + 01Eh], dx ; 2D27
    mov word ptr [di + 020h], 0 ; 2D2A
    pop si ; 2D2F
    pop di ; 2D30
    leave ; 2D31
    ret ; 2D32

; Advance envelope interpolation and stage transitions
public _snd_2D33
_snd_2D33 label near
    enter 2, 0 ; 2D33
    push di ; 2D37
    push si ; 2D38
    mov si, word ptr [bp + 4] ; 2D39
    mov word ptr [bp - 2], 0 ; 2D3C
    cmp word ptr [si + 4], 0 ; 2D41
    je L2D5A ; 2D45
    sub word ptr [si + 4], 011h ; 2D47
    cmp word ptr [si + 4], 0 ; 2D4B
    jg L2D5A ; 2D4F
    mov byte ptr [si], 0 ; 2D51
    xor ax, ax ; 2D54
    pop si ; 2D56
    pop di ; 2D57
    leave ; 2D58
    ret ; 2D59
L2D5A:
    mov di, word ptr [si + 2] ; 2D5A
    add di, word ptr [si + 01Ah] ; 2D5D
    mov ax, word ptr [si + 016h] ; 2D60
    mov cx, word ptr [si + 01Eh] ; 2D63
    add word ptr [si + 020h], cx ; 2D66
    cmp word ptr [si + 020h], ax ; 2D69
    jb L2D77 ; 2D6C
    sub word ptr [si + 020h], ax ; 2D6E
    mov al, byte ptr [si + 01Ch] ; 2D71
    cbw ; 2D74
    add di, ax ; 2D75
L2D77:
    cmp word ptr [si + 2], di ; 2D77
    jne L2D84 ; 2D7A
    mov al, byte ptr [si + 015h] ; 2D7C
    cmp byte ptr [si + 014h], al ; 2D7F
    je L2DA6 ; 2D82
L2D84:
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
    je L2DA6 ; 2D9D
    mov word ptr [bx], di ; 2D9F
    mov word ptr [bp - 2], 1 ; 2DA1
L2DA6:
    dec word ptr [si + 018h] ; 2DA6
    jne L2DCC ; 2DA9
    inc byte ptr [si] ; 2DAB
    cmp byte ptr [si], 4 ; 2DAD
    jbe L2DC6 ; 2DB0
    cmp byte ptr [si + 0Ah], 0 ; 2DB2
    je L2DC1 ; 2DB6
    mov byte ptr [si], 1 ; 2DB8
    or word ptr [bp - 2], 2 ; 2DBB
    jmp short L2DC6 ; 2DBF
L2DC1:
    mov byte ptr [si], 0 ; 2DC1
    jmp short L2DCC ; 2DC4
L2DC6:
    push si ; 2DC6
    call near ptr _snd_2C59 ; 2DC7
    inc sp ; 2DCA
    inc sp ; 2DCB
L2DCC:
    mov ax, word ptr [bp - 2] ; 2DCC
    pop si ; 2DCF
    pop di ; 2DD0
    leave ; 2DD1
    ret ; 2DD2

; Scale an envelope amplitude
public _snd_2DD3
_snd_2DD3 label near
    enter 0, 0 ; 2DD3
    push si ; 2DD7
    cmp byte ptr [bp + 6], 0 ; 2DD8
    jne L2DE3 ; 2DDC
    xor ax, ax ; 2DDE
    pop si ; 2DE0
    leave ; 2DE1
    ret ; 2DE2
L2DE3:
    cmp byte ptr [bp + 6], 01Fh ; 2DE3
    jne L2DEF ; 2DE7
    mov ax, word ptr [bp + 4] ; 2DE9
    pop si ; 2DEC
    leave ; 2DED
    ret ; 2DEE
L2DEF:
    mov si, word ptr [bp + 4] ; 2DEF
    cmp si, 03Fh ; 2DF2
    jg L2E58 ; 2DF5
    cmp si, -03Fh ; 2DF7
    jl L2E58 ; 2DFA
    cmp byte ptr [bp + 6], 0 ; 2DFC
    jge L2E33 ; 2E00
    or si, si ; 2E02
    jge L2E1D ; 2E04
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
L2E1D:
    mov al, byte ptr [bp + 6] ; 2E1D
    cbw ; 2E20
    mov bx, si ; 2E21
    shl bx, 5 ; 2E23
L2E26:
    sub bx, ax ; 2E26
    mov al, byte ptr [bx + _snd_volume_products] ; 2E28
    xor ah, ah ; 2E2C
    neg ax ; 2E2E
    pop si ; 2E30
    leave ; 2E31
    ret ; 2E32
L2E33:
    or si, si ; 2E33
    jge L2E44 ; 2E35
    mov al, byte ptr [bp + 6] ; 2E37
    cbw ; 2E3A
    mov bx, ax ; 2E3B
    mov ax, si ; 2E3D
    shl ax, 5 ; 2E3F
    jmp short L2E26 ; 2E42
L2E44:
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
L2E58:
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
public _snd_2E7A
_snd_2E7A label near
    enter 0, 0 ; 2E7A
    mov al, byte ptr [_snd_random_seed] ; 2E7E
    shr al, 1 ; 2E81
    jae L2E87 ; 2E83
    xor al, 0B8h ; 2E85
L2E87:
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
_TEXT ends
_DATA segment word public 'DATA'
extrn _snd_channel_masks:byte
extrn _snd_default_instrument:byte
extrn _snd_global_instruments:byte
extrn _snd_instrument_fields:byte
extrn _snd_max_values:byte
extrn _snd_parameter_map:byte
extrn _snd_parts:byte
extrn _snd_random_seed:byte
extrn _snd_step_counts:byte
extrn _snd_voice_counter:byte
extrn _snd_voice_tick:byte
extrn _snd_voices:byte
extrn _snd_volume_products:byte
_DATA ends
DGROUP group _DATA
end
