; Recovered original register-ABI OPL operations, segment1341:2E9B..30C4.
; These hardware routines use AH=register, AL=value; calls preserve AX/BX/CX/DX.
; Every executable byte is an instruction assembled by TASM; no code-byte data.
.286
_TEXT segment word public 'CODE'
assume cs:_TEXT, ds:DGROUP
extrn _snd_30C4:near, _snd_312B:near, _snd_316E:near

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
    jbe short L2FD5 ; 2FC0
    cmp al, 019h ; 2FC2
    jbe short L2FE0 ; 2FC4
    cmp al, 01Bh ; 2FC6
    jbe short L2FED ; 2FC8
    cmp al, 01Ch ; 2FCA
    je short L3024 ; 2FCC
    cmp al, 01Dh ; 2FCE
    je short L302C ; 2FD0
    pop si ; 2FD2
    leave  ; 2FD3
    ret  ; 2FD4
L2FD5:
    mov bl, byte ptr [si + 7] ; 2FD5
    xor bh, bh ; 2FD8
    mov dl, byte ptr [bx + _snd_carrier_slots] ; 2FDA
    jmp short L2FF2 ; 2FDE
L2FE0:
    sub al, 0Dh ; 2FE0
    mov bl, byte ptr [si + 7] ; 2FE2
    xor bh, bh ; 2FE5
    mov dl, byte ptr [bx + _snd_modulator_slots] ; 2FE7
    jmp short L2FF2 ; 2FEB
L2FED:
    sub al, 0Dh ; 2FED
    mov dl, byte ptr [si + 7] ; 2FEF
L2FF2:
    mov dh, byte ptr [bp + 8] ; 2FF2
    mov bx, ax ; 2FF5
    shl bx, 2 ; 2FF7
    mov al, byte ptr [bx + _snd_register_fields+3] ; 2FFA
    or al, al ; 2FFE
    je short L3006 ; 3000
    sub al, dh ; 3002
    mov dh, al ; 3004
L3006:
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
    jmp short L3049 ; 3022
L3024:
    mov ax, word ptr [bp + 8] ; 3024
    sub ax, 0Fh ; 3027
    jmp short L3032 ; 302A
L302C:
    mov ax, word ptr [bp + 8] ; 302C
    sub ax, 017Fh ; 302F
L3032:
    shl ax, 4 ; 3032
    mov bl, byte ptr [si + 7] ; 3035
    xor bh, bh ; 3038
    shl bx, 1 ; 303A
    mov word ptr [bx + _snd_channel_frequency+18], ax ; 303C
    add ax, word ptr [bx + _snd_channel_frequency] ; 3040
    shr bx, 1 ; 3044
    call near ptr _snd_30C4 ; 3046
L3049:
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
    jbe short L306F ; 3059
    cmp al, 019h ; 305B
    jbe short L307A ; 305D
    cmp al, 01Bh ; 305F
    jbe short L3087 ; 3061
    cmp al, 01Ch ; 3063
    je short L30B8 ; 3065
    cmp al, 01Dh ; 3067
    je short L30BD ; 3069
    xor ax, ax ; 306B
    jmp short L30C0 ; 306D
L306F:
    mov bl, byte ptr [bp + 4] ; 306F
    xor bh, bh ; 3072
    mov dl, byte ptr [bx + _snd_carrier_slots] ; 3074
    jmp short L308E ; 3078
L307A:
    sub al, 0Dh ; 307A
    mov bl, byte ptr [bp + 4] ; 307C
    xor bh, bh ; 307F
    mov dl, byte ptr [bx + _snd_modulator_slots] ; 3081
    jmp short L308E ; 3085
L3087:
    sub al, 0Dh ; 3087
    mov bl, byte ptr [bp + 4] ; 3089
    mov dl, bl ; 308C
L308E:
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
    je short L30C0 ; 30B0
    sub cl, al ; 30B2
    mov al, cl ; 30B4
    jmp short L30C0 ; 30B6
L30B8:
    mov ax, 0Fh ; 30B8
    jmp short L30C0 ; 30BB
L30BD:
    mov ax, 017Fh ; 30BD
L30C0:
    pop si ; 30C0
    pop di ; 30C1
    leave  ; 30C2
    ret  ; 30C3
_TEXT ends
_DATA segment word public 'DATA'
extrn _snd_modulator_slots:byte, _snd_carrier_slots:byte
extrn _snd_channel_frequency:word, _snd_register_fields:byte
_DATA ends
DGROUP group _DATA
end
