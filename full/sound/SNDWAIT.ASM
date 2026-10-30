; Original port-61 refresh-toggle wait. BX is the loop count; AX/CX preserved.
; The two jump-to-next instructions intentionally provide I/O settling time.
.286
_TEXT segment byte public 'CODE'
assume cs:_TEXT
public _snd_0496
_snd_0496 label near
    push ax
    push cx
next_wait:
    or bx,bx
    jz short wait_done
    mov cx,041h
    xor ax,ax
next_toggle:
    jmp short delay1
delay1:
    jmp short delay2
delay2:
    in al,061h
    and al,010h
    cmp al,ah
    je short next_toggle
    xor ah,010h
    loop next_toggle
    dec bx
    jmp short next_wait
wait_done:
    pop cx
    pop ax
    ret
_TEXT ends
end
