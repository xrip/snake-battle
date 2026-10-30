; Original 8086 LZSS decoder, reconstructed as instructions and symbolic data.
; The 4096 bytes preceding the entry are a writable circular dictionary in
; the CODE segment.  They are not an encoded executable payload.
;
; void far lzss_decode(char far *source, void far *destination,
;                     unsigned packed_length);
;
; C calling convention: caller removes 10 argument bytes.  Source/destination
; are 16:16 real-mode pointers.  Input length counts compressed bytes.

LZSS_TEXT segment byte public 'CODE'
    assume cs:LZSS_TEXT

window db 4096 dup (0)

public _lzss_decode
_lzss_decode proc far
    push bp
    mov bp, sp
    push ds
    push es
    push si
    push di
    push dx
    push cx
    push bx
    push cs
    pop es
    cld
    mov cx, 0FEEh
    mov bx, cx
    mov al, 20h
    mov di, offset window
    rep stosb
    lds si, [bp+6]
    les di, [bp+10]
    mov cx, [bp+14]
    xor dx, dx

next_token:
    shr dx, 1
    test dx, 100h
    jnz have_flags
    lodsb
    dec cx
    or ax, 0FF00h
    mov dx, ax

have_flags:
    test dx, 1
    jz reference
    lodsb
    mov cs:window[bx], al
    stosb
    inc bx
    and bx, 0FFFh
    jmp short token_done

reference:
    lodsb
    xchg ah, al
    dec cx
    jz finished
    lodsb
    push si
    push cx
    xchg al, ah
    mov si, ax
    and si, 0FFFh
    shr ah, 1
    shr ah, 1
    shr ah, 1
    shr ah, 1
    mov cl, ah
    and cx, 0Fh
    add cx, 3

copy_reference:
    mov al, cs:window[si]
    stosb
    mov cs:window[bx], al
    inc bx
    and bx, 0FFFh
    inc si
    and si, 0FFFh
    loop copy_reference
    pop cx
    pop si

token_done:
    loop next_token

finished:
    pop bx
    pop cx
    pop dx
    pop di
    pop si
    pop es
    pop ds
    mov sp, bp
    pop bp
    retf
_lzss_decode endp
LZSS_TEXT ends
end
