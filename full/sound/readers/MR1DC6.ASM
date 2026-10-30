; Register-ABI MIDI reader recovered as instructions, no encoded code arrays.
; ES:SI and live flags are intentionally preserved across the reader paths.
; Explicit 16-bit wrap on near JMP operands preserves original instruction width.
.286
_TEXT segment byte public 'CODE'
assume cs:_TEXT, ds:DGROUP
extrn _snd_0496:near
extrn _snd_3164:near
public _snd_1DC6
_snd_1DC6 label near
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
_TEXT ends
_DATA segment word public 'DATA'
_DATA ends
_BSS segment word public 'BSS'
_BSS ends
DGROUP group _DATA, _BSS
end
