; Register-ABI MIDI reader recovered as instructions, no encoded code arrays.
; ES:SI and live flags are intentionally preserved across the reader paths.
; Explicit 16-bit wrap on near JMP operands preserves original instruction width.
.286
_TEXT segment byte public 'CODE'
assume cs:_TEXT, ds:DGROUP
public _snd_101E
_snd_101E label near
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
_TEXT ends
_DATA segment word public 'DATA'
_DATA ends
_BSS segment word public 'BSS'
_BSS ends
DGROUP group _DATA, _BSS
end
