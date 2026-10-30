; Register-ABI MIDI reader recovered as instructions, no encoded code arrays.
; ES:SI and live flags are intentionally preserved across the reader paths.
; Explicit 16-bit wrap on near JMP operands preserves original instruction width.
.286
_TEXT segment byte public 'CODE'
assume cs:_TEXT, ds:DGROUP
extrn _snd_0643:near
extrn _snd_0FBE:near
extrn _snd_101E:near
extrn _snd_15F0:near
extrn _snd_160C:near
extrn _snd_1A4A:near
extrn _snd_216C:near
extrn _snd_21A2:near
extrn _snd_2277:near
extrn _snd_22F1:near
extrn _snd_235A:near
extrn _snd_23D1:near
extrn _snd_247E:near
extrn _snd_253C:near
extrn _snd_2567:near
extrn _snd_2594:near
extrn _snd_25E7:near
public _snd_183E
_snd_183E label near
    enter 0, 0 ; 183E
    push si ; 1842
    mov bx, word ptr [bp + 6] ; 1843
    les si, dword ptr [bx] ; 1846
    cld ; 1848
    lods byte ptr es:[si] ; 1849
    cmp al, 080h ; 184B
    jae short midi_1857 ; 184D
    mov dx, ax ; 184F
    mov cl, byte ptr [_snd_event_channel] ; 1851
    jmp short midi_18A8 ; 1855
midi_1857:
    cmp al, 0F0h ; 1857
    jb short midi_185E ; 1859
    jmp near ptr midi_19AA-10000h ; 185B
midi_185E:
    mov bx, ax ; 185E
    and al, 0Fh ; 1860
    cbw ; 1862
    mov cx, ax ; 1863
    and bx, 070h ; 1865
    shr bx, 3 ; 1868
    jmp word ptr cs:[bx + midi_1870] ; 186B
midi_1870:
    dw offset midi_187E, offset midi_18A0, offset midi_18EA, offset midi_18F0, offset midi_197C, offset midi_189C, offset midi_18EA ; MIDI event dispatch
midi_187E:
    lods byte ptr es:[si] ; 187E
    cmp word ptr [_snd_scanning], 0 ; 1880
    jne short midi_1894 ; 1885
    push ax ; 1887
    push cx ; 1888
    push word ptr [bp + 4] ; 1889
    call near ptr _snd_21A2 ; 188C
    add sp, 6 ; 188F
    jmp short midi_189C ; 1892
midi_1894:
    push ax ; 1894
    push cx ; 1895
    call near ptr _snd_160C ; 1896
    add sp, 4 ; 1899
midi_189C:
    inc si ; 189C
    jmp near ptr midi_1A40-10000h ; 189D
midi_18A0:
    mov byte ptr [_snd_event_channel], cl ; 18A0
    lods byte ptr es:[si] ; 18A4
    mov dl, al ; 18A6
midi_18A8:
    lods byte ptr es:[si] ; 18A8
    cmp word ptr [_snd_scanning], 0 ; 18AA
    jne short midi_18D2 ; 18AF
    or al, al ; 18B1
    je short midi_18C4 ; 18B3
    push ax ; 18B5
    push dx ; 18B6
    push cx ; 18B7
    push word ptr [bp + 4] ; 18B8
    call near ptr _snd_216C ; 18BB
    add sp, 8 ; 18BE
    jmp near ptr midi_1A40-10000h ; 18C1
midi_18C4:
    push dx ; 18C4
    push cx ; 18C5
    push word ptr [bp + 4] ; 18C6
    call near ptr _snd_21A2 ; 18C9
    add sp, 6 ; 18CC
    jmp near ptr midi_1A40-10000h ; 18CF
midi_18D2:
    push dx ; 18D2
    push cx ; 18D3
    or al, al ; 18D4
    je short midi_18E1 ; 18D6
    call near ptr _snd_15F0 ; 18D8
    add sp, 4 ; 18DB
    jmp near ptr midi_1A40-10000h ; 18DE
midi_18E1:
    call near ptr _snd_160C ; 18E1
    add sp, 4 ; 18E4
    jmp near ptr midi_1A40-10000h ; 18E7
midi_18EA:
    inc si ; 18EA
    inc si ; 18EB
    jmp near ptr midi_1A40-10000h ; 18EC
    nop ; 18EF
midi_18F0:
    lods byte ptr es:[si] ; 18F0
    mov bx, word ptr [bp + 4] ; 18F2
    cmp al, 1 ; 18F5
    je short midi_1914 ; 18F7
    cmp al, 7 ; 18F9
    je short midi_1922 ; 18FB
    cmp al, 0Ah ; 18FD
    je short midi_1930 ; 18FF
    cmp al, 010h ; 1901
    je short midi_1940 ; 1903
    cmp al, 011h ; 1905
    je short midi_194E ; 1907
    cmp al, 012h ; 1909
    je short midi_195E ; 190B
    cmp al, 040h ; 190D
    je short midi_196E ; 190F
    jmp near ptr midi_1A40-10000h ; 1911
midi_1914:
    lods byte ptr es:[si] ; 1914
    push ax ; 1916
    push cx ; 1917
    push bx ; 1918
    call near ptr _snd_253C ; 1919
    add sp, 6 ; 191C
    jmp near ptr midi_1A40-10000h ; 191F
midi_1922:
    lods byte ptr es:[si] ; 1922
    push ax ; 1924
    push cx ; 1925
    push bx ; 1926
    call near ptr _snd_235A ; 1927
    add sp, 6 ; 192A
    jmp near ptr midi_1A40-10000h ; 192D
midi_1930:
    lods byte ptr es:[si] ; 1930
    sub al, 040h ; 1932
    push ax ; 1934
    push cx ; 1935
    push bx ; 1936
    call near ptr _snd_23D1 ; 1937
    add sp, 6 ; 193A
    jmp near ptr midi_1A40-10000h ; 193D
midi_1940:
    lods byte ptr es:[si] ; 1940
    push ax ; 1942
    push cx ; 1943
    push bx ; 1944
    call near ptr _snd_25E7 ; 1945
    add sp, 6 ; 1948
    jmp near ptr midi_1A40-10000h ; 194B
midi_194E:
    lods byte ptr es:[si] ; 194E
    sub al, 040h ; 1950
    push ax ; 1952
    push cx ; 1953
    push bx ; 1954
    call near ptr _snd_247E ; 1955
    add sp, 6 ; 1958
    jmp near ptr midi_1A40-10000h ; 195B
midi_195E:
    lods byte ptr es:[si] ; 195E
    sub al, 040h ; 1960
    push ax ; 1962
    push cx ; 1963
    push bx ; 1964
    call near ptr _snd_22F1 ; 1965
    add sp, 6 ; 1968
    jmp near ptr midi_1A40-10000h ; 196B
midi_196E:
    lods byte ptr es:[si] ; 196E
    push ax ; 1970
    push cx ; 1971
    push bx ; 1972
    call near ptr _snd_2567 ; 1973
    add sp, 6 ; 1976
    jmp near ptr midi_1A40-10000h ; 1979
midi_197C:
    lods byte ptr es:[si] ; 197C
    push ax ; 197E
    push cx ; 197F
    push word ptr [bp + 4] ; 1980
    call near ptr _snd_2277 ; 1983
    add sp, 6 ; 1986
    jmp near ptr midi_1A40-10000h ; 1989
    xor ah, ah ; 198C
    lods byte ptr es:[si] ; 198E
    mov dx, ax ; 1990
    lods byte ptr es:[si] ; 1992
    sub ax, 040h ; 1994
    shl ax, 7 ; 1997
    add ax, dx ; 199A
    push ax ; 199C
    push cx ; 199D
    push word ptr [bp + 4] ; 199E
    call near ptr _snd_2594 ; 19A1
    add sp, 6 ; 19A4
    jmp near ptr midi_1A40-10000h ; 19A7
midi_19AA:
    cmp al, 0FFh ; 19AA
    je short midi_19EF ; 19AC
    cmp al, 0F7h ; 19AE
    je short midi_1A15 ; 19B0
    cmp al, 0F0h ; 19B2
    jne short midi_19F5 ; 19B4
    mov ax, si ; 19B6
    mov si, word ptr [bp + 6] ; 19B8
    mov word ptr [si], ax ; 19BB
    push si ; 19BD
    call near ptr _snd_101E ; 19BE
    add sp, 2 ; 19C1
    les bx, dword ptr [si] ; 19C4
    cmp byte ptr es:[bx], 07Dh ; 19C6
    jne short midi_19EB ; 19CA
    push ax ; 19CC
    push dx ; 19CD
    inc bx ; 19CE
    inc word ptr [_snd_disabled] ; 19CF
    sub ax, 2 ; 19D3
    sbb dx, 0 ; 19D6
    push ax ; 19D9
    push es ; 19DA
    push bx ; 19DB
    push word ptr [bp + 4] ; 19DC
    call near ptr _snd_1A4A ; 19DF
    add sp, 8 ; 19E2
    dec word ptr [_snd_disabled] ; 19E5
    pop dx ; 19E9
    pop ax ; 19EA
midi_19EB:
    add ax, word ptr [si] ; 19EB
    jmp short midi_1A42 ; 19ED
midi_19EF:
    lods byte ptr es:[si] ; 19EF
    cmp al, 02Fh ; 19F1
    jne short midi_1A11 ; 19F3
midi_19F5:
    cmp word ptr [_snd_scanning], 0 ; 19F5
    jne short midi_1A04 ; 19FA
    push word ptr [bp + 4] ; 19FC
    call near ptr _snd_0643 ; 19FF
    inc sp ; 1A02
    inc sp ; 1A03
midi_1A04:
    mov si, word ptr [bp + 6] ; 1A04
    xor ax, ax ; 1A07
    mov word ptr [si], ax ; 1A09
    mov word ptr [si + 2], ax ; 1A0B
    pop si ; 1A0E
    leave ; 1A0F
    ret ; 1A10
midi_1A11:
    cmp al, 051h ; 1A11
    je short midi_1A26 ; 1A13
midi_1A15:
    mov ax, si ; 1A15
    mov si, word ptr [bp + 6] ; 1A17
    mov word ptr [si], ax ; 1A1A
    push si ; 1A1C
    call near ptr _snd_101E ; 1A1D
    inc sp ; 1A20
    inc sp ; 1A21
    add ax, word ptr [si] ; 1A22
    jmp short midi_1A42 ; 1A24
midi_1A26:
    inc si ; 1A26
    xor dh, dh ; 1A27
    lods byte ptr es:[si] ; 1A29
    mov dl, al ; 1A2B
    lods byte ptr es:[si] ; 1A2D
    mov ah, al ; 1A2F
    lods byte ptr es:[si] ; 1A31
    mov bx, word ptr [bp + 4] ; 1A33
    push dx ; 1A36
    push ax ; 1A37
    push word ptr [bx] ; 1A38
    call near ptr _snd_0FBE ; 1A3A
    add sp, 6 ; 1A3D
midi_1A40:
    mov ax, si ; 1A40
midi_1A42:
    mov si, word ptr [bp + 6] ; 1A42
    mov word ptr [si], ax ; 1A45
    pop si ; 1A47
    leave ; 1A48
    ret ; 1A49
_TEXT ends
_DATA segment word public 'DATA'
extrn _snd_disabled:byte
extrn _snd_event_channel:byte
extrn _snd_scanning:byte
_DATA ends
_BSS segment word public 'BSS'
_BSS ends
DGROUP group _DATA, _BSS
end
