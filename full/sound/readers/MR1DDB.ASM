; Register-ABI MIDI reader recovered as instructions, no encoded code arrays.
; ES:SI and live flags are intentionally preserved across the reader paths.
; Explicit 16-bit wrap on near JMP operands preserves original instruction width.
.286
_TEXT segment byte public 'CODE'
assume cs:_TEXT, ds:DGROUP
extrn _snd_1DC6:near
extrn _snd_312B:near
public _snd_1DDB
_snd_1DDB label far
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
    call near ptr _snd_1DC6 ; 1E02
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
extrn _snd_voices:byte
_DATA ends
_BSS segment word public 'BSS'
_BSS ends
DGROUP group _DATA, _BSS
end
