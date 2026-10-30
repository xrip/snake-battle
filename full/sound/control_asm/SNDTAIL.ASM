; Reconstructed hardware/math support at original 1341:30C4..3283.
; The OPL interface uses AH=register, AL=value. The unsigned long helpers
; retain the observed near/far callee-clean conventions of this driver.
.286
_TEXT segment byte public 'CODE'
assume cs:_TEXT,ds:DGROUP
public _snd_30C4,_snd_312B,_snd_3164,_snd_316E
public _snd_3179,_snd_31AA,_snd_320A,__aNulmul,__aFuldiv

; AX=pitch in 1/128 semitones, BL=OPL voice.
_snd_30C4 label near
    mov ch,bl
    shl ax,1
    sub ah,4
    mov bl,ah
    xor bh,bh
    shr al,5
    mov dl,al
    mov cl,byte ptr [bx+_snd_octaves]
    shl cl,2
    mov dh,byte ptr [bx+_snd_semitones]
    mov ah,0b0h
    add ah,ch
    call near ptr _snd_316E
    mov ch,al
    and al,020h
    jz short make_frequency
    and ch,0dfh
    cmp cl,ch
    ja short rising_octave
    jb short falling_octave
    jmp short make_frequency
rising_octave:
    cmp dh,6
    jae short make_frequency
    add dh,12
    sub cl,4
    jmp short make_frequency
falling_octave:
    cmp dh,11
    jbe short make_frequency
    sub dh,12
    add cl,4
make_frequency:
    shl dh,3
    add dh,dl
    mov bl,dh
    mov al,byte ptr [bx+_snd_frequencies]
    sub ah,010h
    call near ptr _snd_312B
    mov al,cl
    or al,020h
    add ah,010h
    call near ptr _snd_312B
    ret

; Cached write: skip identical values. Preserve AX/BX/CX/DX.
_snd_312B label near
    push ax
    push bx
    push cx
    push dx
    xor bh,bh
    mov bl,ah
    cmp al,byte ptr [bx+_snd_opl_cache]
    je short opl_write_done
opl_write:
    mov byte ptr [bx+_snd_opl_cache],al
    xchg al,ah
    mov dx,0388h
    out dx,al
    mov cx,word ptr _snd_opl_index_delay
    nop
opl_index_wait:
    in al,dx
    and al,0
    cmp al,0ffh
    loopne opl_index_wait
    xchg al,ah
    inc dx
    out dx,al
    dec dx
    mov cx,word ptr _snd_opl_data_delay
opl_data_wait:
    in al,dx
    and al,0
    cmp al,0ffh
    loopne opl_data_wait
opl_write_done:
    pop dx
    pop cx
    pop bx
    pop ax
    ret

; Uncached write shares the same timing and cache-update path.
_snd_3164 label near
    push ax
    push bx
    push cx
    push dx
    xor bh,bh
    mov bl,ah
    jmp short opl_write
_snd_316E label near
    push bx
    xor bh,bh
    mov bl,ah
    mov al,byte ptr [bx+_snd_opl_cache]
    pop bx
    ret

; Low 32 bits of an unsigned 32x32 multiplication, RET 8.
__aNulmul label near
_snd_3179 label near
    enter 0,0
    mov ax,[bp+6]
    mov cx,[bp+0ah]
    or cx,ax
    mov cx,[bp+8]
    jnz short multiply_wide
    mov ax,[bp+4]
    mul cx
    leave
    ret 8
multiply_wide:
    mul cx
    mov bx,ax
    mov ax,[bp+4]
    mul word ptr [bp+0ah]
    add bx,ax
    mov ax,[bp+4]
    mul cx
    add dx,bx
    leave
    ret 8

; Original unsigned division helper with far return, RETF 8.
__aFuldiv label far
_snd_31AA label far
    enter 0,0
    push bx
    push si
    mov ax,[bp+0ch]
    or ax,ax
    jnz short divide_wide
    mov cx,[bp+0ah]
    mov ax,[bp+8]
    xor dx,dx
    div cx
    mov bx,ax
    mov ax,[bp+6]
    div cx
    mov dx,bx
    jmp short divide_done
divide_wide:
    mov cx,ax
    mov bx,[bp+0ah]
    mov dx,[bp+8]
    mov ax,[bp+6]
divide_normalize:
    shr cx,1
    rcr bx,1
    shr dx,1
    rcr ax,1
    or cx,cx
    jnz short divide_normalize
    div bx
    mov si,ax
    mul word ptr [bp+0ch]
    xchg cx,ax
    mov ax,[bp+0ah]
    mul si
    add dx,cx
    jc short quotient_high
    cmp dx,[bp+8]
    ja short quotient_high
    jb short quotient_ready
    cmp ax,[bp+6]
    jbe short quotient_ready
quotient_high:
    dec si
quotient_ready:
    xor dx,dx
    xchg si,ax
divide_done:
    pop si
    pop bx
    leave
    retf 8

; Probe AdLib timer status and calibrate the register/data I/O waits.
_snd_320A label near
    mov ax,0460h
    call near ptr _snd_3164
    mov ax,0480h
    call near ptr _snd_3164
    mov dx,0388h
    in al,dx
    and al,0e0h
    jnz short no_opl
    mov ax,02c0h
    call near ptr _snd_3164
    mov cx,20
    mov ax,02104h
    out dx,al
    nop
probe_initial_wait:
    in al,dx
    loop probe_initial_wait
    mov al,ah
    inc dx
    cli
    out dx,al
    dec dx
    nop
probe_timer_wait:
    in al,dx
    and al,0e0h
    cmp al,0c0h
    loopne probe_timer_wait
    sti
    jne short no_opl
    mov ax,0460h
    call near ptr _snd_3164
    mov ax,0480h
    call near ptr _snd_3164
    neg cx
    mov ax,cx
    xor dx,dx
    mov bx,228
    div bx
    or ax,ax
    jz short round_data_up
    shl dx,1
    cmp dx,bx
    jb short store_data_wait
round_data_up:
    inc ax
store_data_wait:
    mov word ptr _snd_opl_data_delay,ax
    mov ax,cx
    xor dx,dx
    mov bx,1551
    div bx
    or ax,ax
    jz short round_index_up
    shl dx,1
    cmp dx,bx
    jb short store_index_wait
round_index_up:
    inc ax
store_index_wait:
    mov word ptr _snd_opl_index_delay,ax
    xor ax,ax
    ret
no_opl:
    mov ax,-1
    ret
_TEXT ends
_DATA segment word public 'DATA'
extrn _snd_octaves:byte,_snd_semitones:byte,_snd_frequencies:byte
extrn _snd_opl_index_delay:word,_snd_opl_data_delay:word
_DATA ends
_BSS segment word public 'BSS'
extrn _snd_opl_cache:byte
_BSS ends
DGROUP group _DATA,_BSS
end
