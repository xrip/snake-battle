; Executable mnemonic specification for 1341:0DB9..1E1A (4193 bytes).
; Includes 26 C-like functions and 7 register-ABI assembly procedures.
; MIDISND.C is the separate readable C reconstruction. This file does NOT
; establish that its C-like parts were historically authored as assembler
; and is not counted as compiler-matched C. See exact/PROVENANCE.md.
; The assembler build reads only source; no reference EXE or byte patch.
; Near JMP -10000h denotes the same 16-bit target while forcing E9 width.
.286
_TEXT segment byte public 'CODE'
assume cs:_TEXT, ds:DGROUP
extrn _snd_00FE:near
extrn _snd_0406:near
extrn _snd_0496:near
extrn _snd_04CC:near
extrn _snd_0643:near
extrn _snd_075E:near
extrn _snd_07AA:near
extrn _snd_0814:near
extrn _snd_0857:near
extrn _snd_0B2E:near
extrn _snd_0B6E:near
extrn _snd_1E83:near
extrn _snd_1FA2:near
extrn _snd_20E7:near
extrn _snd_216C:near
extrn _snd_21A2:near
extrn _snd_222F:near
extrn _snd_2277:near
extrn _snd_22A4:near
extrn _snd_22CD:near
extrn _snd_22F1:near
extrn _snd_235A:near
extrn _snd_23D1:near
extrn _snd_23D2:near
extrn _snd_247E:near
extrn _snd_2509:near
extrn _snd_253C:near
extrn _snd_2567:near
extrn _snd_2594:near
extrn _snd_25E7:near
extrn _snd_2679:near
extrn _snd_312B:near
extrn _snd_3164:near
extrn _snd_31AA:near

; initialize sequence; original CS:0DB9
public _snd_0DB9
_snd_0DB9 label near
midi_0DB9:
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
    call near ptr midi_0FBE ; 0DE9
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
    je short midi_0E66 ; 0E19
    mov word ptr [bp - 4], ax ; 0E1B
    mov word ptr [bp - 2], dx ; 0E1E
    push offset _snd_parse_cursor ; 0E21
    call near ptr midi_101E ; 0E24
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
    call near ptr midi_1041 ; 0E43
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
midi_0E66:
    pop si ; 0E66
    pop di ; 0E67
    leave ; 0E68
    ret ; 0E69

; stop sequence; original CS:0E6A
public _snd_0E6A
_snd_0E6A label near
midi_0E6A:
    enter 0, 0 ; 0E6A
    mov bx, word ptr [bp + 4] ; 0E6E
    mov byte ptr [bx + 2], 0 ; 0E71
    mov byte ptr [_snd_parse_finished], 1 ; 0E75
    leave ; 0E7A
    ret ; 0E7B

; advance sequences on timer; original CS:0E7C
public _snd_0E7C
_snd_0E7C label near
midi_0E7C:
    enter 4, 0 ; 0E7C
    push di ; 0E80
    push si ; 0E81
    cmp byte ptr [_snd_parse_nesting], 0 ; 0E82
    je short midi_0E8C ; 0E87
    jmp near ptr midi_0FBA ; 0E89
midi_0E8C:
    mov si, offset _snd_sequences ; 0E8C
    mov di, 2 ; 0E8F
midi_0E92:
    cmp byte ptr [si + 2], 1 ; 0E92
    je short midi_0E9B ; 0E96
    jmp near ptr midi_0FB1 ; 0E98
midi_0E9B:
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
    jb short midi_0ECF ; 0EBD
    mov ax, word ptr [si + 0Eh] ; 0EBF
    xor dx, dx ; 0EC2
    mov cx, 01E0h ; 0EC4
    div cx ; 0EC7
    add word ptr [si + 0Ch], ax ; 0EC9
    mov word ptr [si + 0Eh], dx ; 0ECC
midi_0ECF:
    cmp word ptr [si + 02Ah], 0 ; 0ECF
    je short midi_0EF8 ; 0ED3
    mov ax, word ptr [si + 030h] ; 0ED5
    cmp word ptr [si + 0Ch], ax ; 0ED8
    jb short midi_0EF8 ; 0EDB
    mov ax, word ptr [si + 032h] ; 0EDD
    cmp word ptr [si + 0Eh], ax ; 0EE0
    jb short midi_0EF8 ; 0EE3
    dec word ptr [si + 02Ah] ; 0EE5
    push word ptr [si + 02Eh] ; 0EE8
    push word ptr [si + 02Ch] ; 0EEB
    push word ptr [si + 0Ah] ; 0EEE
    push si ; 0EF1
    call near ptr _snd_0857 ; 0EF2
    add sp, 8 ; 0EF5
midi_0EF8:
    mov ax, word ptr [si + 010h] ; 0EF8
    mov dx, word ptr [si + 012h] ; 0EFB
    cmp word ptr [si + 016h], dx ; 0EFE
    jbe short midi_0F06 ; 0F01
    jmp near ptr midi_0FB1 ; 0F03
midi_0F06:
    jb short midi_0F10 ; 0F06
    cmp word ptr [si + 014h], ax ; 0F08
    jbe short midi_0F10 ; 0F0B
    jmp near ptr midi_0FB1 ; 0F0D
midi_0F10:
    push word ptr [si + 0Ah] ; 0F10
    push word ptr [_snd_midi_tags+06h] ; 0F13
    push word ptr [_snd_midi_tags+04h] ; 0F17
    push word ptr [si + 4] ; 0F1B
    call near ptr _snd_0406 ; 0F1E
    add sp, 8 ; 0F21
    mov word ptr [bp - 4], ax ; 0F24
    mov word ptr [bp - 2], dx ; 0F27
    or dx, ax ; 0F2A
    jne short midi_0F35 ; 0F2C
    push word ptr [si] ; 0F2E
    call near ptr _snd_0643 ; 0F30
    inc sp ; 0F33
    inc sp ; 0F34
midi_0F35:
    mov ax, word ptr [si + 6] ; 0F35
    add ax, word ptr [bp - 4] ; 0F38
    mov dx, word ptr [bp - 2] ; 0F3B
    mov word ptr [_snd_parse_cursor], ax ; 0F3E
    mov word ptr [_snd_parse_cursor+02h], dx ; 0F41
    mov byte ptr [_snd_parse_finished], 0 ; 0F45
midi_0F4A:
    mov ax, word ptr [si + 010h] ; 0F4A
    mov dx, word ptr [si + 012h] ; 0F4D
    cmp word ptr [si + 016h], dx ; 0F50
    ja short midi_0F87 ; 0F53
    jb short midi_0F5C ; 0F55
    cmp word ptr [si + 014h], ax ; 0F57
    ja short midi_0F87 ; 0F5A
midi_0F5C:
    push offset _snd_parse_cursor ; 0F5C
    push word ptr [si] ; 0F5F
    call near ptr midi_183E ; 0F61
    add sp, 4 ; 0F64
    mov ax, word ptr [_snd_parse_cursor+02h] ; 0F67
    or ax, word ptr [_snd_parse_cursor] ; 0F6A
    je short midi_0FB1 ; 0F6E
    cmp byte ptr [_snd_parse_finished], 0 ; 0F70
    jne short midi_0FB1 ; 0F75
    push offset _snd_parse_cursor ; 0F77
    call near ptr midi_101E ; 0F7A
    inc sp ; 0F7D
    inc sp ; 0F7E
    add word ptr [si + 014h], ax ; 0F7F
    adc word ptr [si + 016h], dx ; 0F82
    jmp short midi_0F4A ; 0F85
midi_0F87:
    mov ax, word ptr [_snd_parse_cursor+02h] ; 0F87
    or ax, word ptr [_snd_parse_cursor] ; 0F8A
    je short midi_0FB1 ; 0F8E
    cmp byte ptr [_snd_parse_finished], 0 ; 0F90
    jne short midi_0FB1 ; 0F95
    push word ptr [bp - 2] ; 0F97
    push word ptr [bp - 4] ; 0F9A
    push word ptr [_snd_parse_cursor+02h] ; 0F9D
    push word ptr [_snd_parse_cursor] ; 0FA1
    call near ptr midi_1041 ; 0FA5
    add sp, 8 ; 0FA8
    mov word ptr [si + 6], ax ; 0FAB
    mov word ptr [si + 8], dx ; 0FAE
midi_0FB1:
    add si, 034h ; 0FB1
    dec di ; 0FB4
    je short midi_0FBA ; 0FB5
    jmp near ptr midi_0E92 ; 0FB7
midi_0FBA:
    pop si ; 0FBA
    pop di ; 0FBB
    leave ; 0FBC
    ret ; 0FBD

; set tempo; original CS:0FBE
public _snd_0FBE
_snd_0FBE label near
midi_0FBE:
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
public _snd_101E
_snd_101E label near
midi_101E:
    enter 0, 0 ; 101E
    push si ; 1022
    mov bx, word ptr [bp + 4] ; 1023
    les si, dword ptr [bx] ; 1026
    cld ; 1028
    xor ax, ax ; 1029
    cwd ; 102B
midi_102C:
    mov dh, dl ; 102C
    mov dl, ah ; 102E
    mov ah, al ; 1030
    lods byte ptr es:[si] ; 1032
    rol al, 1 ; 1034
    shr dx, 1 ; 1036
    rcr ax, 1 ; 1038
    jb short midi_102C ; 103A
    mov word ptr [bx], si ; 103C
    pop si ; 103E
    leave ; 103F
    ret ; 1040

; absolute physical far-pointer distance; original CS:1041
public _snd_1041
_snd_1041 label near
midi_1041:
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
    jns short midi_1083 ; 107A
    neg dx ; 107C
    neg ax ; 107E
    sbb dx, 0 ; 1080
midi_1083:
    pop si ; 1083
    leave ; 1084
    ret ; 1085

; clear player hooks; original CS:1086
public _snd_1086
_snd_1086 label near
midi_1086:
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
public _snd_109C
_snd_109C label near
midi_109C:
    enter 0, 0 ; 109C
    push si ; 10A0
    mov si, word ptr [bp + 4] ; 10A1
    mov bx, word ptr [bp + 6] ; 10A4
    mov al, byte ptr [bx] ; 10A7
    mov bx, word ptr [si + 2] ; 10A9
    or al, al ; 10AC
    je short midi_10B7 ; 10AE
    cmp byte ptr [bx], al ; 10B0
    jne short midi_10E4 ; 10B2
    mov byte ptr [bx], 0 ; 10B4
midi_10B7:
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
midi_10E4:
    pop si ; 10E4
    leave ; 10E5
    ret ; 10E6

; transpose hook; original CS:10E7
public _snd_10E7
_snd_10E7 label near
midi_10E7:
    enter 0, 0 ; 10E7
    push si ; 10EB
    push di ; 10EC
    mov di, word ptr [bp + 4] ; 10ED
    mov si, word ptr [bp + 6] ; 10F0
    mov bx, word ptr [di + 2] ; 10F3
    mov al, byte ptr [si] ; 10F6
    or al, al ; 10F8
    je short midi_1105 ; 10FA
    cmp byte ptr [bx + 1], al ; 10FC
    jne short midi_1114 ; 10FF
    mov byte ptr [bx + 1], 0 ; 1101
midi_1105:
    mov al, byte ptr [si + 2] ; 1105
    push ax ; 1108
    mov al, byte ptr [si + 1] ; 1109
    push ax ; 110C
    push di ; 110D
    call near ptr _snd_07AA ; 110E
    add sp, 6 ; 1111
midi_1114:
    pop di ; 1114
    pop si ; 1115
    leave ; 1116
    ret ; 1117

; part enable hook; original CS:1118
public _snd_1118
_snd_1118 label near
midi_1118:
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
    je short midi_113D ; 1132
    cmp byte ptr [si + 2], al ; 1134
    jne short midi_1149 ; 1137
    mov byte ptr [si + 2], 0 ; 1139
midi_113D:
    mov al, byte ptr [di + 2] ; 113D
    push ax ; 1140
    push cx ; 1141
    push bx ; 1142
    call near ptr _snd_2509 ; 1143
    add sp, 6 ; 1146
midi_1149:
    pop di ; 1149
    pop si ; 114A
    leave ; 114B
    ret ; 114C

; part volume hook; original CS:114D
public _snd_114D
_snd_114D label near
midi_114D:
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
    je short midi_1172 ; 1167
    cmp byte ptr [si + 012h], al ; 1169
    jne short midi_117E ; 116C
    mov byte ptr [si + 012h], 0 ; 116E
midi_1172:
    mov al, byte ptr [di + 2] ; 1172
    push ax ; 1175
    push cx ; 1176
    push bx ; 1177
    call near ptr _snd_235A ; 1178
    add sp, 6 ; 117B
midi_117E:
    pop di ; 117E
    pop si ; 117F
    leave ; 1180
    ret ; 1181

; part instrument hook; original CS:1182
public _snd_1182
_snd_1182 label near
midi_1182:
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
    je short midi_11A7 ; 119C
    cmp byte ptr [si + 022h], al ; 119E
    jne short midi_11B3 ; 11A1
    mov byte ptr [si + 022h], 0 ; 11A3
midi_11A7:
    mov al, byte ptr [di + 2] ; 11A7
    push ax ; 11AA
    push cx ; 11AB
    push bx ; 11AC
    call near ptr _snd_2277 ; 11AD
    add sp, 6 ; 11B0
midi_11B3:
    pop di ; 11B3
    pop si ; 11B4
    leave ; 11B5
    ret ; 11B6

; part transpose hook; original CS:11B7
public _snd_11B7
_snd_11B7 label near
midi_11B7:
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
    je short midi_11DC ; 11D1
    cmp byte ptr [si + 032h], al ; 11D3
    jne short midi_11EC ; 11D6
    mov byte ptr [si + 032h], 0 ; 11D8
midi_11DC:
    mov al, byte ptr [di + 3] ; 11DC
    push ax ; 11DF
    mov al, byte ptr [di + 2] ; 11E0
    push ax ; 11E3
    push cx ; 11E4
    push bx ; 11E5
    call near ptr _snd_23D2 ; 11E6
    add sp, 8 ; 11E9
midi_11EC:
    pop di ; 11EC
    pop si ; 11ED
    leave ; 11EE
    ret ; 11EF

; read hook value; original CS:11F0
public _snd_11F0
_snd_11F0 label near
midi_11F0:
    enter 0, 0 ; 11F0
    mov bl, byte ptr [bp + 6] ; 11F4
    xor bh, bh ; 11F7
    sub bx, 012h ; 11F9
    cmp bx, 5 ; 11FC
    ja short midi_1216 ; 11FF
    shl bx, 1 ; 1201
    xor ax, ax ; 1203
    jmp word ptr cs:[bx + midi_120A] ; 1205
midi_120A:
    dw offset midi_121C, offset midi_1224, offset midi_122C, offset midi_123A, offset midi_1248, offset midi_1256 ; MIDI event dispatch
midi_1216:
    mov ax, 0FFFFh ; 1216
    leave ; 1219
    ret ; 121A
    nop ; 121B
midi_121C:
    mov bx, word ptr [bp + 4] ; 121C
    mov al, byte ptr [bx] ; 121F
    leave ; 1221
    ret ; 1222
    nop ; 1223
midi_1224:
    mov bx, word ptr [bp + 4] ; 1224
    mov al, byte ptr [bx + 1] ; 1227
    leave ; 122A
    ret ; 122B
midi_122C:
    mov bx, word ptr [bp + 4] ; 122C
    mov al, byte ptr [bp + 8] ; 122F
    add bx, ax ; 1232
    mov al, byte ptr [bx + 2] ; 1234
    leave ; 1237
    ret ; 1238
    nop ; 1239
midi_123A:
    mov bx, word ptr [bp + 4] ; 123A
    mov al, byte ptr [bp + 8] ; 123D
    add bx, ax ; 1240
    mov al, byte ptr [bx + 012h] ; 1242
    leave ; 1245
    ret ; 1246
    nop ; 1247
midi_1248:
    mov bx, word ptr [bp + 4] ; 1248
    mov al, byte ptr [bp + 8] ; 124B
    add bx, ax ; 124E
    mov al, byte ptr [bx + 022h] ; 1250
    leave ; 1253
    ret ; 1254
    nop ; 1255
midi_1256:
    mov bx, word ptr [bp + 4] ; 1256
    mov al, byte ptr [bp + 8] ; 1259
    add bx, ax ; 125C
    mov al, byte ptr [bx + 032h] ; 125E
    leave ; 1261
    ret ; 1262

; advance held notes; original CS:1263
public _snd_1263
_snd_1263 label near
midi_1263:
    push di ; 1263
    push si ; 1264
    mov si, word ptr [_snd_held_active] ; 1265
midi_1269:
    or si, si ; 1269
    je short midi_12D5 ; 126B
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
    ja short midi_12D1 ; 1296
    jb short midi_129F ; 1298
    cmp word ptr [si + 8], ax ; 129A
    ja short midi_12D1 ; 129D
midi_129F:
    mov al, byte ptr [si + 4] ; 129F
    push ax ; 12A2
    mov al, byte ptr [si + 5] ; 12A3
    push ax ; 12A6
    push word ptr [bx] ; 12A7
    call near ptr _snd_21A2 ; 12A9
    add sp, 6 ; 12AC
    or di, di ; 12AF
    je short midi_12B7 ; 12B1
    mov ax, word ptr [si] ; 12B3
    mov word ptr [di], ax ; 12B5
midi_12B7:
    cmp word ptr [si], 0 ; 12B7
    je short midi_12C3 ; 12BA
    mov bx, word ptr [si] ; 12BC
    mov word ptr [bx + 2], di ; 12BE
    jmp short midi_12C7 ; 12C1
midi_12C3:
    mov word ptr [_snd_held_active], di ; 12C3
midi_12C7:
    mov ax, word ptr [_snd_held_free] ; 12C7
    mov word ptr [si + 2], ax ; 12CA
    mov word ptr [_snd_held_free], si ; 12CD
midi_12D1:
    mov si, di ; 12D1
    jmp short midi_1269 ; 12D3
midi_12D5:
    pop si ; 12D5
    pop di ; 12D6
    ret ; 12D7

; retain notes across a jump; original CS:12D8
public _snd_12D8
_snd_12D8 label near
midi_12D8:
    enter 8, 0 ; 12D8
    push si ; 12DC
    push di ; 12DD
    call near ptr midi_15DF ; 12DE
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
    jge short midi_1326 ; 131C
    xor ax, ax ; 131E
    mov word ptr [bp - 4], ax ; 1320
    mov word ptr [bp - 2], ax ; 1323
midi_1326:
    cmp word ptr [_snd_scan_note_count], 0 ; 1326
    jne short midi_1330 ; 132B
    jmp near ptr midi_13C7 ; 132D
midi_1330:
    push offset _snd_parse_cursor ; 1330
    call near ptr midi_1537 ; 1333
    inc sp ; 1336
    inc sp ; 1337
    dec ax ; 1338
    jne short midi_13AF ; 1339
    mov bl, byte ptr [_snd_event_channel] ; 133B
    xor bh, bh ; 133F
    shl bx, 1 ; 1341
    mov ax, word ptr [bx + _snd_channel_masks] ; 1343
    mov bl, byte ptr [_snd_event_note] ; 1347
    xor bh, bh ; 134B
    shl bx, 1 ; 134D
    add bx, 0415Ah ; 134F
    test word ptr [bx], ax ; 1353
    je short midi_13AF ; 1355
    not ax ; 1357
    and word ptr [bx], ax ; 1359
    dec word ptr [_snd_scan_note_count] ; 135B
    mov si, word ptr [_snd_held_free] ; 135F
    or si, si ; 1363
    jne short midi_136A ; 1365
    jmp near ptr midi_1533 ; 1367
midi_136A:
    mov ax, word ptr [si + 2] ; 136A
    mov word ptr [_snd_held_free], ax ; 136D
    mov ax, word ptr [_snd_held_cursor] ; 1370
    mov word ptr [si + 2], ax ; 1373
    mov word ptr [_snd_held_cursor], si ; 1376
    mov word ptr [si], 0 ; 137A
    or ax, ax ; 137E
    je short midi_1386 ; 1380
    mov bx, ax ; 1382
    mov word ptr [bx], si ; 1384
midi_1386:
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
midi_13AF:
    push offset _snd_parse_cursor ; 13AF
    call near ptr midi_101E ; 13B2
    inc sp ; 13B5
    inc sp ; 13B6
    add word ptr [bp - 4], ax ; 13B7
    adc word ptr [bp - 2], dx ; 13BA
    cmp word ptr [_snd_scan_note_count], 0 ; 13BD
    je short midi_13C7 ; 13C2
    jmp near ptr midi_1330 ; 13C4
midi_13C7:
    xor ax, ax ; 13C7
    mov word ptr [_snd_scan_end_tick+02h], ax ; 13C9
    mov word ptr [_snd_scan_end_tick], ax ; 13CC
    mov si, word ptr [_snd_held_cursor] ; 13CF
midi_13D3:
    or si, si ; 13D3
    je short midi_1412 ; 13D5
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
    jb short midi_140D ; 13F7
    ja short midi_1400 ; 13F9
    cmp word ptr [si + 8], ax ; 13FB
    jbe short midi_140D ; 13FE
midi_1400:
    mov ax, word ptr [si + 8] ; 1400
    mov dx, word ptr [si + 0Ah] ; 1403
    mov word ptr [_snd_scan_end_tick], ax ; 1406
    mov word ptr [_snd_scan_end_tick+02h], dx ; 1409
midi_140D:
    mov si, word ptr [si + 2] ; 140D
    jmp short midi_13D3 ; 1410
midi_1412:
    mov ax, word ptr [bp + 0Ah] ; 1412
    mov dx, word ptr [bp + 0Ch] ; 1415
    mov word ptr [_snd_parse_cursor], ax ; 1418
    mov word ptr [_snd_parse_cursor+02h], dx ; 141B
    mov ax, word ptr [bp + 0Eh] ; 141F
    mov dx, word ptr [bp + 010h] ; 1422
    mov word ptr [bp - 4], ax ; 1425
    mov word ptr [bp - 2], dx ; 1428
    cmp dx, word ptr [_snd_scan_end_tick+02h] ; 142B
    jbe short midi_1434 ; 142F
    jmp near ptr midi_14F5 ; 1431
midi_1434:
    jb short midi_143F ; 1434
    cmp ax, word ptr [_snd_scan_end_tick] ; 1436
    jb short midi_143F ; 143A
    jmp near ptr midi_14F5 ; 143C
midi_143F:
    push offset _snd_parse_cursor ; 143F
    call near ptr midi_1537 ; 1442
    inc sp ; 1445
    inc sp ; 1446
    cmp ax, 2 ; 1447
    je short midi_144F ; 144A
    jmp near ptr midi_14CE-10000h ; 144C
midi_144F:
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
    je short midi_14CE ; 146F
    mov si, word ptr [_snd_held_cursor] ; 1471
midi_1475:
    or si, si ; 1475
    je short midi_14CE ; 1477
    mov di, word ptr [si + 2] ; 1479
    mov al, byte ptr [_snd_event_note] ; 147C
    cmp byte ptr [si + 4], al ; 147F
    jne short midi_14CA ; 1482
    mov al, byte ptr [_snd_event_channel] ; 1484
    cmp byte ptr [si + 5], al ; 1487
    jne short midi_14CA ; 148A
    mov ax, word ptr [bp - 4] ; 148C
    mov dx, word ptr [bp - 2] ; 148F
    cmp word ptr [si + 0Ah], dx ; 1492
    jb short midi_14CA ; 1495
    ja short midi_149E ; 1497
    cmp word ptr [si + 8], ax ; 1499
    jbe short midi_14CA ; 149C
midi_149E:
    mov ax, word ptr [bp - 6] ; 149E
    not ax ; 14A1
    mov bx, word ptr [bp - 8] ; 14A3
    and word ptr [bx], ax ; 14A6
    or di, di ; 14A8
    je short midi_14B0 ; 14AA
    mov ax, word ptr [si] ; 14AC
    mov word ptr [di], ax ; 14AE
midi_14B0:
    cmp word ptr [si], 0 ; 14B0
    je short midi_14BC ; 14B3
    mov bx, word ptr [si] ; 14B5
    mov word ptr [bx + 2], di ; 14B7
    jmp short midi_14C0 ; 14BA
midi_14BC:
    mov word ptr [_snd_held_cursor], di ; 14BC
midi_14C0:
    mov ax, word ptr [_snd_held_free] ; 14C0
    mov word ptr [si + 2], ax ; 14C3
    mov word ptr [_snd_held_free], si ; 14C6
midi_14CA:
    mov si, di ; 14CA
    jmp short midi_1475 ; 14CC
midi_14CE:
    push offset _snd_parse_cursor ; 14CE
    call near ptr midi_101E ; 14D1
    inc sp ; 14D4
    inc sp ; 14D5
    add word ptr [bp - 4], ax ; 14D6
    adc word ptr [bp - 2], dx ; 14D9
    mov ax, word ptr [_snd_scan_end_tick] ; 14DC
    mov dx, word ptr [_snd_scan_end_tick+02h] ; 14DF
    cmp word ptr [bp - 2], dx ; 14E3
    jae short midi_14EB ; 14E6
    jmp near ptr midi_143F ; 14E8
midi_14EB:
    ja short midi_14F5 ; 14EB
    cmp word ptr [bp - 4], ax ; 14ED
    jae short midi_14F5 ; 14F0
    jmp near ptr midi_143F ; 14F2
midi_14F5:
    cmp word ptr [_snd_held_active], 0 ; 14F5
    jne short midi_150C ; 14FA
    mov ax, word ptr [_snd_held_cursor] ; 14FC
    mov word ptr [_snd_held_active], ax ; 14FF
    mov word ptr [_snd_held_cursor], 0 ; 1502
    pop di ; 1508
    pop si ; 1509
    leave ; 150A
    ret ; 150B
midi_150C:
    mov bx, word ptr [_snd_held_active] ; 150C
    cmp word ptr [bx + 2], 0 ; 1510
    je short midi_151F ; 1514
midi_1516:
    mov bx, word ptr [bx + 2] ; 1516
    cmp word ptr [bx + 2], 0 ; 1519
    jne short midi_1516 ; 151D
midi_151F:
    mov ax, word ptr [_snd_held_cursor] ; 151F
    mov word ptr [bx + 2], ax ; 1522
    mov word ptr [_snd_held_cursor], 0 ; 1525
    or ax, ax ; 152B
    je short midi_1533 ; 152D
    mov si, ax ; 152F
    mov word ptr [si], bx ; 1531
midi_1533:
    pop di ; 1533
    pop si ; 1534
    leave ; 1535
    ret ; 1536

; scan note events; original CS:1537
public _snd_1537
_snd_1537 label near
midi_1537:
    enter 0, 0 ; 1537
    push si ; 153B
    cld ; 153C
    mov bx, word ptr [bp + 4] ; 153D
    les si, dword ptr [bx] ; 1540
    lods byte ptr es:[si] ; 1542
    mov bl, al ; 1544
    cmp al, 080h ; 1546
    jb short midi_1589 ; 1548
    cmp al, 0F0h ; 154A
    jae short midi_15A4 ; 154C
    and ax, 070h ; 154E
    shr ax, 3 ; 1551
    xchg bx, ax ; 1554
    jmp word ptr cs:[bx + midi_155A] ; 1555
midi_155A:
    dw offset midi_1568, offset midi_1582, offset midi_15A0, offset midi_15A0, offset midi_15A1, offset midi_15A1, offset midi_15A0 ; MIDI event dispatch
midi_1568:
    and al, 0Fh ; 1568
    mov byte ptr [_snd_event_channel], al ; 156A
    lods byte ptr es:[si] ; 156D
    mov byte ptr [_snd_event_note], al ; 156F
    lods byte ptr es:[si] ; 1572
    mov byte ptr [_snd_event_velocity], al ; 1574
    mov bx, word ptr [bp + 4] ; 1577
    mov word ptr [bx], si ; 157A
midi_157C:
    mov ax, 1 ; 157C
    pop si ; 157F
    leave ; 1580
    ret ; 1581
midi_1582:
    and al, 0Fh ; 1582
    mov byte ptr [_snd_event_channel], al ; 1584
    lods byte ptr es:[si] ; 1587
midi_1589:
    mov byte ptr [_snd_event_note], al ; 1589
    lods byte ptr es:[si] ; 158C
    mov byte ptr [_snd_event_velocity], al ; 158E
    mov bx, word ptr [bp + 4] ; 1591
    mov word ptr [bx], si ; 1594
    or al, al ; 1596
    je short midi_157C ; 1598
    mov ax, 2 ; 159A
    pop si ; 159D
    leave ; 159E
    ret ; 159F
midi_15A0:
    inc si ; 15A0
midi_15A1:
    inc si ; 15A1
    jmp short midi_15D5 ; 15A2
midi_15A4:
    cmp al, 0F0h ; 15A4
    je short midi_15B6 ; 15A6
    cmp al, 0F7h ; 15A8
    je short midi_15B6 ; 15AA
    cmp al, 0FFh ; 15AC
    jne short midi_15CA ; 15AE
    lods byte ptr es:[si] ; 15B0
    cmp al, 02Fh ; 15B2
    je short midi_15CA ; 15B4
midi_15B6:
    mov dx, si ; 15B6
    mov si, word ptr [bp + 4] ; 15B8
    mov word ptr [si], dx ; 15BB
    push si ; 15BD
    call near ptr midi_101E ; 15BE
    inc sp ; 15C1
    inc sp ; 15C2
    add word ptr [si], ax ; 15C3
    xor ax, ax ; 15C5
    pop si ; 15C7
    leave ; 15C8
    ret ; 15C9
midi_15CA:
    xor ax, ax ; 15CA
    mov word ptr [_snd_scan_note_count], ax ; 15CC
    mov word ptr [_snd_scan_end_tick+02h], ax ; 15CF
    mov word ptr [_snd_scan_end_tick], ax ; 15D2
midi_15D5:
    mov bx, word ptr [bp + 4] ; 15D5
    mov word ptr [bx], si ; 15D8
    xor ax, ax ; 15DA
    pop si ; 15DC
    leave ; 15DD
    ret ; 15DE

; clear note/channel bitset; original CS:15DF
public _snd_15DF
_snd_15DF label near
midi_15DF:
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
public _snd_15F0
_snd_15F0 label near
midi_15F0:
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
public _snd_160C
_snd_160C label near
midi_160C:
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
public _snd_162A
_snd_162A label near
midi_162A:
    enter 4, 0 ; 162A
    push si ; 162E
    push di ; 162F
    mov byte ptr [bp - 2], 0 ; 1630
    mov si, word ptr [bp + 4] ; 1634
midi_1637:
    mov bl, byte ptr [bp - 2] ; 1637
    xor bh, bh ; 163A
    shl bx, 1 ; 163C
    mov di, word ptr [bx + _snd_note_channels] ; 163E
    or di, di ; 1642
    je short midi_1671 ; 1644
    mov byte ptr [bp - 4], 0 ; 1646
midi_164A:
    mov bl, byte ptr [bp - 4] ; 164A
    xor bh, bh ; 164D
    shl bx, 1 ; 164F
    test word ptr [bx + _snd_channel_masks], di ; 1651
    je short midi_1668 ; 1655
    push 050h ; 1657
    mov al, byte ptr [bp - 2] ; 1659
    push ax ; 165C
    mov al, byte ptr [bp - 4] ; 165D
    push ax ; 1660
    push si ; 1661
    call near ptr _snd_216C ; 1662
    add sp, 8 ; 1665
midi_1668:
    inc byte ptr [bp - 4] ; 1668
    cmp byte ptr [bp - 4], 010h ; 166B
    jb short midi_164A ; 166F
midi_1671:
    inc byte ptr [bp - 2] ; 1671
    cmp byte ptr [bp - 2], 080h ; 1674
    jb short midi_1637 ; 1678
    pop di ; 167A
    pop si ; 167B
    leave ; 167C
    ret ; 167D

; clear fade state; original CS:167E
public _snd_167E
_snd_167E label near
midi_167E:
    xor ax, ax ; 167E
    mov byte ptr [_snd_fade_state], al ; 1680
    ret ; 1683

; cancel player fade; original CS:1684
public _snd_1684
_snd_1684 label near
midi_1684:
    enter 0, 0 ; 1684
    mov bx, offset _snd_fades ; 1688
    mov cx, 2 ; 168B
    mov dx, word ptr [bp + 4] ; 168E
midi_1691:
    cmp byte ptr [bx], 0 ; 1691
    je short midi_169E ; 1694
    cmp word ptr [bx + 2], dx ; 1696
    jne short midi_169E ; 1699
    mov byte ptr [bx], 0 ; 169B
midi_169E:
    add bx, 010h ; 169E
    loop midi_1691 ; 16A1
    leave ; 16A3
    ret ; 16A4

; advance volume fades; original CS:16A5
public _snd_16A5
_snd_16A5 label near
midi_16A5:
    push di ; 16A5
    push si ; 16A6
    cmp byte ptr [_snd_fade_state], 0 ; 16A7
    je short midi_171A ; 16AC
    inc word ptr [_snd_fade_tick_scale] ; 16AE
    and word ptr [_snd_fade_tick_scale], 3 ; 16B2
    jne short midi_171A ; 16B7
    mov si, offset _snd_fades ; 16B9
    mov byte ptr [_snd_fade_state], 0 ; 16BC
    mov di, 2 ; 16C1
midi_16C4:
    cmp byte ptr [si], 0 ; 16C4
    je short midi_1714 ; 16C7
    mov byte ptr [_snd_fade_state], 1 ; 16C9
    mov cl, byte ptr [si + 4] ; 16CE
    add cl, byte ptr [si + 0Ah] ; 16D1
    mov al, byte ptr [si + 0Ch] ; 16D4
    cbw ; 16D7
    add word ptr [si + 0Eh], ax ; 16D8
    mov ax, word ptr [si + 6] ; 16DB
    cmp word ptr [si + 0Eh], ax ; 16DE
    jb short midi_16E9 ; 16E1
    sub word ptr [si + 0Eh], ax ; 16E3
    add cl, byte ptr [si + 0Bh] ; 16E6
midi_16E9:
    cmp cl, byte ptr [si + 4] ; 16E9
    je short midi_170C ; 16EC
    or cl, cl ; 16EE
    je short midi_1701 ; 16F0
    mov byte ptr [si + 4], cl ; 16F2
    push cx ; 16F5
    push word ptr [si + 2] ; 16F6
    call near ptr _snd_075E ; 16F9
    add sp, 4 ; 16FC
    jmp short midi_170C ; 16FF
midi_1701:
    push word ptr [si + 2] ; 1701
    call near ptr _snd_0643 ; 1704
    inc sp ; 1707
    inc sp ; 1708
    mov byte ptr [si], 0 ; 1709
midi_170C:
    dec word ptr [si + 8] ; 170C
    jne short midi_1714 ; 170F
    mov byte ptr [si], 0 ; 1711
midi_1714:
    add si, 010h ; 1714
    dec di ; 1717
    jne short midi_16C4 ; 1718
midi_171A:
    pop si ; 171A
    pop di ; 171B
    ret ; 171C

; execute marker command queue; original CS:171D
public _snd_171D
_snd_171D label near
midi_171D:
    enter 0, 0 ; 171D
    push si ; 1721
    mov bx, word ptr [_snd_queue_read] ; 1722
    cmp bx, word ptr [_snd_queue_write] ; 1726
    jne short midi_172F ; 172A
    jmp near ptr midi_17B8 ; 172C
midi_172F:
    mov si, word ptr [bp + 4] ; 172F
    mov si, word ptr [si + 8] ; 1732
    cmp byte ptr [_snd_building_queue], 0 ; 1735
    je short midi_174C ; 173A
    cmp word ptr [_snd_queued_sound], si ; 173C
    jne short midi_174C ; 1740
    mov al, byte ptr [_snd_queued_marker] ; 1742
    cmp byte ptr [bp + 6], al ; 1745
    jne short midi_174C ; 1748
    jmp short midi_17B8 ; 174A
midi_174C:
    shl bx, 4 ; 174C
    cmp word ptr [bx + _snd_queue], 0 ; 174F
    jne short midi_17B8 ; 1754
    cmp word ptr [bx + _snd_queue+02h], si ; 1756
    jne short midi_17B8 ; 175A
    mov al, byte ptr [bp + 6] ; 175C
    xor ah, ah ; 175F
    cmp word ptr [bx + _snd_queue+04h], ax ; 1761
    jne short midi_17B8 ; 1765
    dec word ptr [_snd_trigger_count] ; 1767
midi_176B:
    mov si, word ptr [_snd_queue_read] ; 176B
    inc si ; 176F
    cmp si, 040h ; 1770
    jl short midi_1777 ; 1773
    xor si, si ; 1775
midi_1777:
    cmp word ptr [_snd_queue_write], si ; 1777
    je short midi_17B4 ; 177B
    mov bx, si ; 177D
    shl bx, 4 ; 177F
    cmp word ptr [bx + _snd_queue], 1 ; 1782
    jne short midi_17B4 ; 1787
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
    jmp short midi_176B ; 17B2
midi_17B4:
    mov word ptr [_snd_queue_read], si ; 17B4
midi_17B8:
    pop si ; 17B8
    leave ; 17B9
    ret ; 17BA

; read queue state; original CS:17BB
public _snd_17BB
_snd_17BB label near
midi_17BB:
    enter 0, 0 ; 17BB
    mov ax, word ptr [bp + 4] ; 17BF
    or ax, ax ; 17C2
    je short midi_17D1 ; 17C4
    dec ax ; 17C6
    je short midi_17D6 ; 17C7
    dec ax ; 17C9
    je short midi_17E9 ; 17CA
midi_17CC:
    mov ax, 0FFFFh ; 17CC
    leave ; 17CF
    ret ; 17D0
midi_17D1:
    mov ax, word ptr [_snd_trigger_count] ; 17D1
    leave ; 17D4
    ret ; 17D5
midi_17D6:
    mov bx, word ptr [_snd_queue_read] ; 17D6
    cmp word ptr [_snd_queue_write], bx ; 17DA
    je short midi_17CC ; 17DE
    shl bx, 4 ; 17E0
    mov ax, word ptr [bx + _snd_queue+02h] ; 17E3
    leave ; 17E7
    ret ; 17E8
midi_17E9:
    mov bx, word ptr [_snd_queue_read] ; 17E9
    cmp word ptr [_snd_queue_write], bx ; 17ED
    je short midi_17CC ; 17F1
    shl bx, 4 ; 17F3
    mov ax, word ptr [bx + _snd_queue+04h] ; 17F6
    leave ; 17FA
    ret ; 17FB

; find queued sound; original CS:17FC
public _snd_17FC
_snd_17FC label near
midi_17FC:
    enter 0, 0 ; 17FC
    push si ; 1800
    mov cx, word ptr [bp + 4] ; 1801
    mov dx, word ptr [_snd_queue_write] ; 1804
    mov si, word ptr [_snd_queue_read] ; 1808
midi_180C:
    cmp si, dx ; 180C
    je short midi_1839 ; 180E
    mov bx, si ; 1810
    shl bx, 4 ; 1812
    cmp word ptr [bx + _snd_queue], 1 ; 1815
    jne short midi_182F ; 181A
    cmp word ptr [bx + _snd_queue+02h], 8 ; 181C
    jne short midi_182F ; 1821
    cmp word ptr [bx + _snd_queue+04h], cx ; 1823
    jne short midi_182F ; 1827
    mov ax, 2 ; 1829
    pop si ; 182C
    leave ; 182D
    ret ; 182E
midi_182F:
    inc si ; 182F
    cmp si, 040h ; 1830
    jl short midi_180C ; 1833
    xor si, si ; 1835
    jmp short midi_180C ; 1837
midi_1839:
    xor ax, ax ; 1839
    pop si ; 183B
    leave ; 183C
    ret ; 183D

; dispatch MIDI event; original CS:183E
public _snd_183E
_snd_183E label near
midi_183E:
    enter 0, 0 ; 183E
    push si ; 1842
    mov bx, word ptr [bp + 6] ; 1843
    les si, dword ptr [bx] ; 1846
    cld ; 1848
    lods byte ptr es:[si] ; 1849
    cmp al, 080h ; 184B
    jae short midi_1857 ; 184D
    mov dx, ax ; 184F
    mov cl, byte ptr [_snd_event_channel] ; 1851
    jmp short midi_18A8 ; 1855
midi_1857:
    cmp al, 0F0h ; 1857
    jb short midi_185E ; 1859
    jmp near ptr midi_19AA ; 185B
midi_185E:
    mov bx, ax ; 185E
    and al, 0Fh ; 1860
    cbw ; 1862
    mov cx, ax ; 1863
    and bx, 070h ; 1865
    shr bx, 3 ; 1868
    jmp word ptr cs:[bx + midi_1870] ; 186B
midi_1870:
    dw offset midi_187E, offset midi_18A0, offset midi_18EA, offset midi_18F0, offset midi_197C, offset midi_189C, offset midi_18EA ; MIDI event dispatch
midi_187E:
    lods byte ptr es:[si] ; 187E
    cmp word ptr [_snd_scanning], 0 ; 1880
    jne short midi_1894 ; 1885
    push ax ; 1887
    push cx ; 1888
    push word ptr [bp + 4] ; 1889
    call near ptr _snd_21A2 ; 188C
    add sp, 6 ; 188F
    jmp short midi_189C ; 1892
midi_1894:
    push ax ; 1894
    push cx ; 1895
    call near ptr midi_160C ; 1896
    add sp, 4 ; 1899
midi_189C:
    inc si ; 189C
    jmp near ptr midi_1A40 ; 189D
midi_18A0:
    mov byte ptr [_snd_event_channel], cl ; 18A0
    lods byte ptr es:[si] ; 18A4
    mov dl, al ; 18A6
midi_18A8:
    lods byte ptr es:[si] ; 18A8
    cmp word ptr [_snd_scanning], 0 ; 18AA
    jne short midi_18D2 ; 18AF
    or al, al ; 18B1
    je short midi_18C4 ; 18B3
    push ax ; 18B5
    push dx ; 18B6
    push cx ; 18B7
    push word ptr [bp + 4] ; 18B8
    call near ptr _snd_216C ; 18BB
    add sp, 8 ; 18BE
    jmp near ptr midi_1A40 ; 18C1
midi_18C4:
    push dx ; 18C4
    push cx ; 18C5
    push word ptr [bp + 4] ; 18C6
    call near ptr _snd_21A2 ; 18C9
    add sp, 6 ; 18CC
    jmp near ptr midi_1A40 ; 18CF
midi_18D2:
    push dx ; 18D2
    push cx ; 18D3
    or al, al ; 18D4
    je short midi_18E1 ; 18D6
    call near ptr midi_15F0 ; 18D8
    add sp, 4 ; 18DB
    jmp near ptr midi_1A40 ; 18DE
midi_18E1:
    call near ptr midi_160C ; 18E1
    add sp, 4 ; 18E4
    jmp near ptr midi_1A40 ; 18E7
midi_18EA:
    inc si ; 18EA
    inc si ; 18EB
    jmp near ptr midi_1A40 ; 18EC
    nop ; 18EF
midi_18F0:
    lods byte ptr es:[si] ; 18F0
    mov bx, word ptr [bp + 4] ; 18F2
    cmp al, 1 ; 18F5
    je short midi_1914 ; 18F7
    cmp al, 7 ; 18F9
    je short midi_1922 ; 18FB
    cmp al, 0Ah ; 18FD
    je short midi_1930 ; 18FF
    cmp al, 010h ; 1901
    je short midi_1940 ; 1903
    cmp al, 011h ; 1905
    je short midi_194E ; 1907
    cmp al, 012h ; 1909
    je short midi_195E ; 190B
    cmp al, 040h ; 190D
    je short midi_196E ; 190F
    jmp near ptr midi_1A40 ; 1911
midi_1914:
    lods byte ptr es:[si] ; 1914
    push ax ; 1916
    push cx ; 1917
    push bx ; 1918
    call near ptr _snd_253C ; 1919
    add sp, 6 ; 191C
    jmp near ptr midi_1A40 ; 191F
midi_1922:
    lods byte ptr es:[si] ; 1922
    push ax ; 1924
    push cx ; 1925
    push bx ; 1926
    call near ptr _snd_235A ; 1927
    add sp, 6 ; 192A
    jmp near ptr midi_1A40 ; 192D
midi_1930:
    lods byte ptr es:[si] ; 1930
    sub al, 040h ; 1932
    push ax ; 1934
    push cx ; 1935
    push bx ; 1936
    call near ptr _snd_23D1 ; 1937
    add sp, 6 ; 193A
    jmp near ptr midi_1A40 ; 193D
midi_1940:
    lods byte ptr es:[si] ; 1940
    push ax ; 1942
    push cx ; 1943
    push bx ; 1944
    call near ptr _snd_25E7 ; 1945
    add sp, 6 ; 1948
    jmp near ptr midi_1A40 ; 194B
midi_194E:
    lods byte ptr es:[si] ; 194E
    sub al, 040h ; 1950
    push ax ; 1952
    push cx ; 1953
    push bx ; 1954
    call near ptr _snd_247E ; 1955
    add sp, 6 ; 1958
    jmp near ptr midi_1A40 ; 195B
midi_195E:
    lods byte ptr es:[si] ; 195E
    sub al, 040h ; 1960
    push ax ; 1962
    push cx ; 1963
    push bx ; 1964
    call near ptr _snd_22F1 ; 1965
    add sp, 6 ; 1968
    jmp near ptr midi_1A40 ; 196B
midi_196E:
    lods byte ptr es:[si] ; 196E
    push ax ; 1970
    push cx ; 1971
    push bx ; 1972
    call near ptr _snd_2567 ; 1973
    add sp, 6 ; 1976
    jmp near ptr midi_1A40 ; 1979
midi_197C:
    lods byte ptr es:[si] ; 197C
    push ax ; 197E
    push cx ; 197F
    push word ptr [bp + 4] ; 1980
    call near ptr _snd_2277 ; 1983
    add sp, 6 ; 1986
    jmp near ptr midi_1A40 ; 1989
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
    jmp near ptr midi_1A40 ; 19A7
midi_19AA:
    cmp al, 0FFh ; 19AA
    je short midi_19EF ; 19AC
    cmp al, 0F7h ; 19AE
    je short midi_1A15 ; 19B0
    cmp al, 0F0h ; 19B2
    jne short midi_19F5 ; 19B4
    mov ax, si ; 19B6
    mov si, word ptr [bp + 6] ; 19B8
    mov word ptr [si], ax ; 19BB
    push si ; 19BD
    call near ptr midi_101E ; 19BE
    add sp, 2 ; 19C1
    les bx, dword ptr [si] ; 19C4
    cmp byte ptr es:[bx], 07Dh ; 19C6
    jne short midi_19EB ; 19CA
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
    call near ptr midi_1A4A ; 19DF
    add sp, 8 ; 19E2
    dec word ptr [_snd_disabled] ; 19E5
    pop dx ; 19E9
    pop ax ; 19EA
midi_19EB:
    add ax, word ptr [si] ; 19EB
    jmp short midi_1A42 ; 19ED
midi_19EF:
    lods byte ptr es:[si] ; 19EF
    cmp al, 02Fh ; 19F1
    jne short midi_1A11 ; 19F3
midi_19F5:
    cmp word ptr [_snd_scanning], 0 ; 19F5
    jne short midi_1A04 ; 19FA
    push word ptr [bp + 4] ; 19FC
    call near ptr _snd_0643 ; 19FF
    inc sp ; 1A02
    inc sp ; 1A03
midi_1A04:
    mov si, word ptr [bp + 6] ; 1A04
    xor ax, ax ; 1A07
    mov word ptr [si], ax ; 1A09
    mov word ptr [si + 2], ax ; 1A0B
    pop si ; 1A0E
    leave ; 1A0F
    ret ; 1A10
midi_1A11:
    cmp al, 051h ; 1A11
    je short midi_1A26 ; 1A13
midi_1A15:
    mov ax, si ; 1A15
    mov si, word ptr [bp + 6] ; 1A17
    mov word ptr [si], ax ; 1A1A
    push si ; 1A1C
    call near ptr midi_101E ; 1A1D
    inc sp ; 1A20
    inc sp ; 1A21
    add ax, word ptr [si] ; 1A22
    jmp short midi_1A42 ; 1A24
midi_1A26:
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
    call near ptr midi_0FBE ; 1A3A
    add sp, 6 ; 1A3D
midi_1A40:
    mov ax, si ; 1A40
midi_1A42:
    mov si, word ptr [bp + 6] ; 1A42
    mov word ptr [si], ax ; 1A45
    pop si ; 1A47
    leave ; 1A48
    ret ; 1A49

; dispatch manufacturer 7D SysEx; original CS:1A4A
public _snd_1A4A
_snd_1A4A label near
midi_1A4A:
    enter 0, 0 ; 1A4A
    push di ; 1A4E
    push si ; 1A4F
    les si, dword ptr [bp + 6] ; 1A50
    lods byte ptr es:[si] ; 1A53
    cmp al, 0 ; 1A55
    je short midi_1AC6 ; 1A57
    cmp al, 1 ; 1A59
    jne short midi_1A60 ; 1A5B
    jmp near ptr midi_1AEE ; 1A5D
midi_1A60:
    cmp al, 2 ; 1A60
    jne short midi_1A67 ; 1A62
    jmp near ptr midi_1B03 ; 1A64
midi_1A67:
    cmp al, 010h ; 1A67
    jne short midi_1A6E ; 1A69
    jmp near ptr midi_1B0F ; 1A6B
midi_1A6E:
    cmp al, 011h ; 1A6E
    jne short midi_1A75 ; 1A70
    jmp near ptr midi_1B41 ; 1A72
midi_1A75:
    cmp al, 021h ; 1A75
    jne short midi_1A7C ; 1A77
    jmp near ptr midi_1B6D ; 1A79
midi_1A7C:
    cmp al, 030h ; 1A7C
    jne short midi_1A83 ; 1A7E
    jmp near ptr midi_1BAE ; 1A80
midi_1A83:
    cmp al, 031h ; 1A83
    jne short midi_1A8A ; 1A85
    jmp near ptr midi_1BDA ; 1A87
midi_1A8A:
    cmp al, 032h ; 1A8A
    jne short midi_1A91 ; 1A8C
    jmp near ptr midi_1BFC ; 1A8E
midi_1A91:
    cmp al, 033h ; 1A91
    jne short midi_1A98 ; 1A93
    jmp near ptr midi_1C24 ; 1A95
midi_1A98:
    cmp al, 034h ; 1A98
    jne short midi_1A9F ; 1A9A
    jmp near ptr midi_1C4C ; 1A9C
midi_1A9F:
    cmp al, 035h ; 1A9F
    jne short midi_1AA6 ; 1AA1
    jmp near ptr midi_1C74 ; 1AA3
midi_1AA6:
    cmp al, 040h ; 1AA6
    jne short midi_1AAD ; 1AA8
    jmp near ptr midi_1C9C ; 1AAA
midi_1AAD:
    cmp al, 050h ; 1AAD
    jne short midi_1AB4 ; 1AAF
    jmp near ptr midi_1CB6 ; 1AB1
midi_1AB4:
    cmp al, 051h ; 1AB4
    jne short midi_1ABB ; 1AB6
    jmp near ptr midi_1D04 ; 1AB8
midi_1ABB:
    cmp al, 060h ; 1ABB
    jne short midi_1AC2 ; 1ABD
    jmp near ptr midi_1D12 ; 1ABF
midi_1AC2:
    pop si ; 1AC2
    pop di ; 1AC3
    leave ; 1AC4
    ret ; 1AC5
midi_1AC6:
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
    call near ptr midi_1D49 ; 1AD8
    add sp, 8 ; 1ADB
    push offset _snd_sysex_buffer ; 1ADE
    push word ptr [bp + 4] ; 1AE1
    call near ptr _snd_1E83 ; 1AE4
    add sp, 4 ; 1AE7
    pop si ; 1AEA
    pop di ; 1AEB
    leave ; 1AEC
    ret ; 1AED
midi_1AEE:
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
midi_1B03:
    push word ptr [bp + 4] ; 1B03
    call near ptr _snd_20E7 ; 1B06
    inc sp ; 1B09
    inc sp ; 1B0A
    pop si ; 1B0B
    pop di ; 1B0C
    leave ; 1B0D
    ret ; 1B0E
midi_1B0F:
    lods byte ptr es:[si] ; 1B0F
    and al, 0Fh ; 1B11
    mov dl, al ; 1B13
    lods byte ptr es:[si] ; 1B15
    cmp al, 1 ; 1B17
    je short midi_1B1E ; 1B19
    jmp near ptr midi_1D45 ; 1B1B
midi_1B1E:
    push offset _snd_sysex_buffer ; 1B1E
    push dx ; 1B21
    mov ax, word ptr [bp + 0Ah] ; 1B22
    sub ax, 3 ; 1B25
    push ax ; 1B28
    push offset _snd_sysex_buffer ; 1B29
    push es ; 1B2C
    push si ; 1B2D
    call near ptr midi_1D49 ; 1B2E
    add sp, 8 ; 1B31
    push word ptr [bp + 4] ; 1B34
    call near ptr _snd_22A4 ; 1B37
    add sp, 6 ; 1B3A
    pop si ; 1B3D
    pop di ; 1B3E
    leave ; 1B3F
    ret ; 1B40
midi_1B41:
    inc si ; 1B41
    lods byte ptr es:[si] ; 1B42
    cmp al, 1 ; 1B44
    je short midi_1B4B ; 1B46
    jmp near ptr midi_1D45 ; 1B48
midi_1B4B:
    lods byte ptr es:[si] ; 1B4B
    push offset _snd_sysex_buffer ; 1B4D
    push ax ; 1B50
    mov ax, word ptr [bp + 0Ah] ; 1B51
    sub ax, 4 ; 1B54
    push ax ; 1B57
    push offset _snd_sysex_buffer ; 1B58
    push es ; 1B5B
    push si ; 1B5C
    call near ptr midi_1D49 ; 1B5D
    add sp, 8 ; 1B60
    call near ptr _snd_2679 ; 1B63
    add sp, 4 ; 1B66
    pop si ; 1B69
    pop di ; 1B6A
    leave ; 1B6B
    ret ; 1B6C
midi_1B6D:
    lods byte ptr es:[si] ; 1B6D
    and al, 0Fh ; 1B6F
    mov di, ax ; 1B71
    lods byte ptr es:[si] ; 1B73
    cmp al, 1 ; 1B75
    je short midi_1B7C ; 1B77
    jmp near ptr midi_1D45 ; 1B79
midi_1B7C:
    mov ax, word ptr [bp + 0Ah] ; 1B7C
    sub ax, 3 ; 1B7F
    push ax ; 1B82
    push offset _snd_sysex_buffer ; 1B83
    push es ; 1B86
    push si ; 1B87
    call near ptr midi_1D49 ; 1B88
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
midi_1BAE:
    cmp word ptr [_snd_scanning], 0 ; 1BAE
    je short midi_1BB8 ; 1BB3
    jmp near ptr midi_1D45 ; 1BB5
midi_1BB8:
    mov ax, word ptr [bp + 0Ah] ; 1BB8
    dec ax ; 1BBB
    dec ax ; 1BBC
    push ax ; 1BBD
    push offset _snd_sysex_buffer ; 1BBE
    inc si ; 1BC1
    push es ; 1BC2
    push si ; 1BC3
    call near ptr midi_1D49 ; 1BC4
    add sp, 8 ; 1BC7
    push offset _snd_sysex_buffer ; 1BCA
    push word ptr [bp + 4] ; 1BCD
    call near ptr midi_109C ; 1BD0
    add sp, 4 ; 1BD3
    pop si ; 1BD6
    pop di ; 1BD7
    leave ; 1BD8
    ret ; 1BD9
midi_1BDA:
    mov ax, word ptr [bp + 0Ah] ; 1BDA
    dec ax ; 1BDD
    dec ax ; 1BDE
    push ax ; 1BDF
    push offset _snd_sysex_buffer ; 1BE0
    inc si ; 1BE3
    push es ; 1BE4
    push si ; 1BE5
    call near ptr midi_1D49 ; 1BE6
    add sp, 8 ; 1BE9
    push offset _snd_sysex_buffer ; 1BEC
    push word ptr [bp + 4] ; 1BEF
    call near ptr midi_10E7 ; 1BF2
    add sp, 4 ; 1BF5
    pop si ; 1BF8
    pop di ; 1BF9
    leave ; 1BFA
    ret ; 1BFB
midi_1BFC:
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
    call near ptr midi_1D49 ; 1C0E
    add sp, 8 ; 1C11
    push offset _snd_sysex_buffer ; 1C14
    push word ptr [bp + 4] ; 1C17
    call near ptr midi_1118 ; 1C1A
    add sp, 4 ; 1C1D
    pop si ; 1C20
    pop di ; 1C21
    leave ; 1C22
    ret ; 1C23
midi_1C24:
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
    call near ptr midi_1D49 ; 1C36
    add sp, 8 ; 1C39
    push offset _snd_sysex_buffer ; 1C3C
    push word ptr [bp + 4] ; 1C3F
    call near ptr midi_114D ; 1C42
    add sp, 4 ; 1C45
    pop si ; 1C48
    pop di ; 1C49
    leave ; 1C4A
    ret ; 1C4B
midi_1C4C:
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
    call near ptr midi_1D49 ; 1C5E
    add sp, 8 ; 1C61
    push offset _snd_sysex_buffer ; 1C64
    push word ptr [bp + 4] ; 1C67
    call near ptr midi_1182 ; 1C6A
    add sp, 4 ; 1C6D
    pop si ; 1C70
    pop di ; 1C71
    leave ; 1C72
    ret ; 1C73
midi_1C74:
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
    call near ptr midi_1D49 ; 1C86
    add sp, 8 ; 1C89
    push offset _snd_sysex_buffer ; 1C8C
    push word ptr [bp + 4] ; 1C8F
    call near ptr midi_11B7 ; 1C92
    add sp, 4 ; 1C95
    pop si ; 1C98
    pop di ; 1C99
    leave ; 1C9A
    ret ; 1C9B
midi_1C9C:
    inc si ; 1C9C
    mov di, word ptr [bp + 0Ah] ; 1C9D
    dec di ; 1CA0
    dec di ; 1CA1
midi_1CA2:
    dec di ; 1CA2
    jns short midi_1CA8 ; 1CA3
    jmp near ptr midi_1D45 ; 1CA5
midi_1CA8:
    lods byte ptr es:[si] ; 1CA8
    push ax ; 1CAA
    push word ptr [bp + 4] ; 1CAB
    call near ptr midi_171D ; 1CAE
    add sp, 4 ; 1CB1
    jmp short midi_1CA2 ; 1CB4
midi_1CB6:
    mov ax, word ptr [bp + 0Ah] ; 1CB6
    dec ax ; 1CB9
    dec ax ; 1CBA
    push ax ; 1CBB
    push offset _snd_sysex_buffer ; 1CBC
    inc si ; 1CBF
    push es ; 1CC0
    push si ; 1CC1
    call near ptr midi_1D49 ; 1CC2
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
midi_1D04:
    mov bx, word ptr [bp + 4] ; 1D04
    push word ptr [bx] ; 1D07
    call near ptr _snd_0B6E ; 1D09
    inc sp ; 1D0C
    inc sp ; 1D0D
    pop si ; 1D0E
    pop di ; 1D0F
    leave ; 1D10
    ret ; 1D11
midi_1D12:
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
midi_1D45:
    pop si ; 1D45
    pop di ; 1D46
    leave ; 1D47
    ret ; 1D48

; unpack paired nibbles; original CS:1D49
public _snd_1D49
_snd_1D49 label near
midi_1D49:
    enter 0, 0 ; 1D49
    push si ; 1D4D
    mov cx, word ptr [bp + 0Ah] ; 1D4E
    jcxz short midi_1D6A ; 1D51
    inc cx ; 1D53
    inc cx ; 1D54
    shr cx, 1 ; 1D55
    cld ; 1D57
    mov bx, word ptr [bp + 8] ; 1D58
    les si, dword ptr [bp + 4] ; 1D5B
midi_1D5E:
    lods word ptr es:[si] ; 1D5E
    shl al, 4 ; 1D60
    or al, ah ; 1D63
    mov byte ptr [bx], al ; 1D65
    inc bx ; 1D67
    loop midi_1D5E ; 1D68
midi_1D6A:
    pop si ; 1D6A
    leave ; 1D6B
    ret ; 1D6C

; skip one MIDI event; original CS:1D6D
public _snd_1D6D
_snd_1D6D label near
midi_1D6D:
    enter 0, 0 ; 1D6D
    push si ; 1D71
    mov si, word ptr [bp + 4] ; 1D72
    les bx, dword ptr [si] ; 1D75
    inc word ptr [si] ; 1D77
    mov al, byte ptr es:[bx] ; 1D79
    cmp al, 080h ; 1D7C
    jae short midi_1D85 ; 1D7E
    mov ax, 1 ; 1D80
    jmp short midi_1DB7 ; 1D83
midi_1D85:
    cmp al, 0F0h ; 1D85
    jae short midi_1D9B ; 1D87
    mov bl, al ; 1D89
    and bl, 070h ; 1D8B
    shr bl, 4 ; 1D8E
    xor bh, bh ; 1D91
    mov al, byte ptr [bx + _snd_midi_lengths] ; 1D93
    xor ah, ah ; 1D97
    jmp short midi_1DB7 ; 1D99
midi_1D9B:
    cmp al, 0F0h ; 1D9B
    je short midi_1DB0 ; 1D9D
    cmp al, 0F7h ; 1D9F
    je short midi_1DB0 ; 1DA1
    cmp al, 0FFh ; 1DA3
    jne short midi_1DBC ; 1DA5
    inc word ptr [si] ; 1DA7
    cmp byte ptr es:[bx + 1], 02Fh ; 1DA9
    je short midi_1DBC ; 1DAE
midi_1DB0:
    push si ; 1DB0
    call near ptr midi_101E ; 1DB1
    add sp, 2 ; 1DB4
midi_1DB7:
    add word ptr [si], ax ; 1DB7
    pop si ; 1DB9
    leave ; 1DBA
    ret ; 1DBB
midi_1DBC:
    xor ax, ax ; 1DBC
    mov word ptr [si], ax ; 1DBE
    mov word ptr [si + 2], ax ; 1DC0
    pop si ; 1DC3
    leave ; 1DC4
    ret ; 1DC5

; reset OPL; original CS:1DC6
public _snd_1DC6
_snd_1DC6 label near
midi_1DC6:
    xor ax, ax ; 1DC6
    mov cx, 0100h ; 1DC8
midi_1DCB:
    dec ah ; 1DCB
    call near ptr _snd_3164 ; 1DCD
    mov bx, 1 ; 1DD0
    call near ptr _snd_0496 ; 1DD3
    loop midi_1DCB ; 1DD6
    xor ax, ax ; 1DD8
    ret ; 1DDA

; initialize OPL voices; original CS:1DDB
public _snd_1DDB
_snd_1DDB label far
midi_1DDB:
    mov bx, offset _snd_voices ; 1DDB
    xor cx, cx ; 1DDE
midi_1DE0:
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
    jl short midi_1DE0 ; 1E00
    call near ptr midi_1DC6 ; 1E02
    mov ax, 0120h ; 1E05
    call near ptr _snd_312B ; 1E08
    mov ax, 0840h ; 1E0B
    call near ptr _snd_312B ; 1E0E
    mov ax, 0BD00h ; 1E11
    call near ptr _snd_312B ; 1E14
    xor ax, ax ; 1E17
    retf ; 1E19
_TEXT ends
_DATA segment word public 'DATA'
extrn _snd_building_queue:byte
extrn _snd_channel_masks:byte
extrn _snd_disabled:byte
extrn _snd_event_channel:byte
extrn _snd_event_note:byte
extrn _snd_event_velocity:byte
extrn _snd_fade_state:byte
extrn _snd_fade_tick_scale:byte
extrn _snd_fades:byte
extrn _snd_held_active:byte
extrn _snd_held_cursor:byte
extrn _snd_held_free:byte
extrn _snd_midi_lengths:byte
extrn _snd_midi_tags:byte
extrn _snd_note_channels:byte
extrn _snd_parse_cursor:byte
extrn _snd_parse_finished:byte
extrn _snd_parse_nesting:byte
extrn _snd_queue:byte
extrn _snd_queue_read:byte
extrn _snd_queue_write:byte
extrn _snd_queued_marker:byte
extrn _snd_queued_sound:byte
extrn _snd_scan_end_tick:byte
extrn _snd_scan_note_count:byte
extrn _snd_scanning:byte
extrn _snd_sequences:byte
extrn _snd_sysex_buffer:byte
extrn _snd_tick_period:byte
extrn _snd_trigger_count:byte
extrn _snd_voices:byte
_DATA ends
_BSS segment word public 'BSS'
_BSS ends
DGROUP group _DATA, _BSS
end
