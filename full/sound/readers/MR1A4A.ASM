; Register-ABI MIDI reader recovered as instructions, no encoded code arrays.
; ES:SI and live flags are intentionally preserved across the reader paths.
; Explicit 16-bit wrap on near JMP operands preserves original instruction width.
.286
_TEXT segment byte public 'CODE'
assume cs:_TEXT, ds:DGROUP
extrn _snd_04CC:near
extrn _snd_0B2E:near
extrn _snd_0B6E:near
extrn _snd_109C:near
extrn _snd_10E7:near
extrn _snd_1118:near
extrn _snd_114D:near
extrn _snd_1182:near
extrn _snd_11B7:near
extrn _snd_171D:near
extrn _snd_1D49:near
extrn _snd_1E83:near
extrn _snd_1FA2:near
extrn _snd_20E7:near
extrn _snd_2277:near
extrn _snd_22A4:near
extrn _snd_22CD:near
extrn _snd_2679:near
public _snd_1A4A
_snd_1A4A label near
    enter 0, 0 ; 1A4A
    push di ; 1A4E
    push si ; 1A4F
    les si, dword ptr [bp + 6] ; 1A50
    lods byte ptr es:[si] ; 1A53
    cmp al, 0 ; 1A55
    je short midi_1AC6 ; 1A57
    cmp al, 1 ; 1A59
    jne short midi_1A60 ; 1A5B
    jmp near ptr midi_1AEE-10000h ; 1A5D
midi_1A60:
    cmp al, 2 ; 1A60
    jne short midi_1A67 ; 1A62
    jmp near ptr midi_1B03-10000h ; 1A64
midi_1A67:
    cmp al, 010h ; 1A67
    jne short midi_1A6E ; 1A69
    jmp near ptr midi_1B0F-10000h ; 1A6B
midi_1A6E:
    cmp al, 011h ; 1A6E
    jne short midi_1A75 ; 1A70
    jmp near ptr midi_1B41-10000h ; 1A72
midi_1A75:
    cmp al, 021h ; 1A75
    jne short midi_1A7C ; 1A77
    jmp near ptr midi_1B6D-10000h ; 1A79
midi_1A7C:
    cmp al, 030h ; 1A7C
    jne short midi_1A83 ; 1A7E
    jmp near ptr midi_1BAE-10000h ; 1A80
midi_1A83:
    cmp al, 031h ; 1A83
    jne short midi_1A8A ; 1A85
    jmp near ptr midi_1BDA-10000h ; 1A87
midi_1A8A:
    cmp al, 032h ; 1A8A
    jne short midi_1A91 ; 1A8C
    jmp near ptr midi_1BFC-10000h ; 1A8E
midi_1A91:
    cmp al, 033h ; 1A91
    jne short midi_1A98 ; 1A93
    jmp near ptr midi_1C24-10000h ; 1A95
midi_1A98:
    cmp al, 034h ; 1A98
    jne short midi_1A9F ; 1A9A
    jmp near ptr midi_1C4C-10000h ; 1A9C
midi_1A9F:
    cmp al, 035h ; 1A9F
    jne short midi_1AA6 ; 1AA1
    jmp near ptr midi_1C74-10000h ; 1AA3
midi_1AA6:
    cmp al, 040h ; 1AA6
    jne short midi_1AAD ; 1AA8
    jmp near ptr midi_1C9C-10000h ; 1AAA
midi_1AAD:
    cmp al, 050h ; 1AAD
    jne short midi_1AB4 ; 1AAF
    jmp near ptr midi_1CB6-10000h ; 1AB1
midi_1AB4:
    cmp al, 051h ; 1AB4
    jne short midi_1ABB ; 1AB6
    jmp near ptr midi_1D04-10000h ; 1AB8
midi_1ABB:
    cmp al, 060h ; 1ABB
    jne short midi_1AC2 ; 1ABD
    jmp near ptr midi_1D12-10000h ; 1ABF
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
    jmp near ptr midi_1D45-10000h ; 1B1B
midi_1B1E:
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
midi_1B41:
    inc si ; 1B41
    lods byte ptr es:[si] ; 1B42
    cmp al, 1 ; 1B44
    je short midi_1B4B ; 1B46
    jmp near ptr midi_1D45-10000h ; 1B48
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
    call near ptr _snd_1D49 ; 1B5D
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
    jmp near ptr midi_1D45-10000h ; 1B79
midi_1B7C:
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
midi_1BAE:
    cmp word ptr [_snd_scanning], 0 ; 1BAE
    je short midi_1BB8 ; 1BB3
    jmp near ptr midi_1D45-10000h ; 1BB5
midi_1BB8:
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
midi_1BDA:
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
midi_1C9C:
    inc si ; 1C9C
    mov di, word ptr [bp + 0Ah] ; 1C9D
    dec di ; 1CA0
    dec di ; 1CA1
midi_1CA2:
    dec di ; 1CA2
    jns short midi_1CA8 ; 1CA3
    jmp near ptr midi_1D45-10000h ; 1CA5
midi_1CA8:
    lods byte ptr es:[si] ; 1CA8
    push ax ; 1CAA
    push word ptr [bp + 4] ; 1CAB
    call near ptr _snd_171D ; 1CAE
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
_TEXT ends
_DATA segment word public 'DATA'
extrn _snd_scanning:byte
extrn _snd_sysex_buffer:byte
_DATA ends
_BSS segment word public 'BSS'
_BSS ends
DGROUP group _DATA, _BSS
end
