; Reconstructed PIT/IRQ0 implementation, original 1341:006E..00FE.
; IRQ entry preserves all general registers, DS/ES, and chains the old INT 8
; whenever the 16-bit 1193182/0x174d timer accumulator overflows.
.286
_TEXT segment byte public 'CODE'
assume cs:_TEXT, ds:DGROUP
extrn _snd_055E:near
public _snd_isr_count, _snd_old_int8, _snd_0074, _snd_00B4, _snd_00E7
_snd_isr_count dw 0
_snd_old_int8 dd 0
_snd_0074 label near
    pusha
    push ds
    push es
    inc word ptr cs:_snd_isr_count
    cmp word ptr cs:_snd_isr_count,1
    jne short nested_irq
    mov ax,DGROUP
    mov ds,ax
next_pending_tick:
    add word ptr _snd_timer_accumulator,0174dh
    jnc short acknowledge_pic
    pushf
    call dword ptr cs:_snd_old_int8
    jmp short run_tick
acknowledge_pic:
    mov al,020h
    out 020h,al
run_tick:
    sti
    call near ptr _snd_055E
    dec word ptr cs:_snd_isr_count
    jne short next_pending_tick
    pop es
    pop ds
    popa
    iret
nested_irq:
    mov al,020h
    out 020h,al
    pop es
    pop ds
    popa
    iret
_snd_00B4 label near
    push ds
    push es
    mov ax,03508h
    int 021h
    mov word ptr cs:_snd_old_int8,bx
    mov word ptr cs:_snd_old_int8+2,es
    mov ax,cs
    mov ds,ax
    mov dx,offset _snd_0074
    mov ax,02508h
    int 021h
    mov al,034h
    out 043h,al
    mov ax,0174dh
    out 040h,al
    mov al,ah
    out 040h,al
    xor ax,ax
    mov word ptr cs:_snd_isr_count,ax
    pop es
    pop ds
    ret
_snd_00E7 label near
    push ds
    xor ax,ax
    out 040h,al
    mov al,ah
    out 040h,al
    lds dx,dword ptr cs:_snd_old_int8
    mov ax,02508h
    int 021h
    xor ax,ax
    pop ds
    ret
_TEXT ends
_DATA segment word public 'DATA'
_DATA ends
_BSS segment word public 'BSS'
extrn _snd_timer_accumulator:word
_BSS ends
DGROUP group _DATA,_BSS
end
