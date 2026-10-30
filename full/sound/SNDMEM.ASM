; Original near-memory copy primitive. CDECL (destination,source,length).
; Returns zero in AX. DS=ES is established explicitly; DF follows caller ABI.
.286
_TEXT segment byte public 'CODE'
assume cs:_TEXT
public _snd_053D
_snd_053D label near
    enter 0,0
    push di
    push si
    mov si,[bp+6]
    mov di,[bp+4]
    mov cx,[bp+8]
    mov ax,ds
    mov es,ax
    shr cx,1
    rep movsw
    adc cx,cx
    rep movsb
    mov ax,cx
    pop si
    pop di
    leave
    ret
_TEXT ends
end
