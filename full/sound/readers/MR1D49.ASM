; Register-ABI MIDI reader recovered as instructions, no encoded code arrays.
; ES:SI and live flags are intentionally preserved across the reader paths.
; Explicit 16-bit wrap on near JMP operands preserves original instruction width.
.286
_TEXT segment byte public 'CODE'
assume cs:_TEXT, ds:DGROUP
public _snd_1D49
_snd_1D49 label near
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
_TEXT ends
_DATA segment word public 'DATA'
_DATA ends
_BSS segment word public 'BSS'
_BSS ends
DGROUP group _DATA, _BSS
end
