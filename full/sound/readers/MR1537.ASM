; Register-ABI MIDI reader recovered as instructions, no encoded code arrays.
; ES:SI and live flags are intentionally preserved across the reader paths.
; Explicit 16-bit wrap on near JMP operands preserves original instruction width.
.286
_TEXT segment byte public 'CODE'
assume cs:_TEXT, ds:DGROUP
extrn _snd_101E:near
public _snd_1537
_snd_1537 label near
    enter 0, 0 ; 1537
    push si ; 153B
    cld ; 153C
    mov bx, word ptr [bp + 4] ; 153D
    les si, dword ptr [bx] ; 1540
    lods byte ptr es:[si] ; 1542
    mov bl, al ; 1544
    cmp al, 080h ; 1546
    jb short midi_1589 ; 1548
    cmp al, 0F0h ; 154A
    jae short midi_15A4 ; 154C
    and ax, 070h ; 154E
    shr ax, 3 ; 1551
    xchg bx, ax ; 1554
    jmp word ptr cs:[bx + midi_155A] ; 1555
midi_155A:
    dw offset midi_1568, offset midi_1582, offset midi_15A0, offset midi_15A0, offset midi_15A1, offset midi_15A1, offset midi_15A0 ; MIDI event dispatch
midi_1568:
    and al, 0Fh ; 1568
    mov byte ptr [_snd_event_channel], al ; 156A
    lods byte ptr es:[si] ; 156D
    mov byte ptr [_snd_event_note], al ; 156F
    lods byte ptr es:[si] ; 1572
    mov byte ptr [_snd_event_velocity], al ; 1574
    mov bx, word ptr [bp + 4] ; 1577
    mov word ptr [bx], si ; 157A
midi_157C:
    mov ax, 1 ; 157C
    pop si ; 157F
    leave ; 1580
    ret ; 1581
midi_1582:
    and al, 0Fh ; 1582
    mov byte ptr [_snd_event_channel], al ; 1584
    lods byte ptr es:[si] ; 1587
midi_1589:
    mov byte ptr [_snd_event_note], al ; 1589
    lods byte ptr es:[si] ; 158C
    mov byte ptr [_snd_event_velocity], al ; 158E
    mov bx, word ptr [bp + 4] ; 1591
    mov word ptr [bx], si ; 1594
    or al, al ; 1596
    je short midi_157C ; 1598
    mov ax, 2 ; 159A
    pop si ; 159D
    leave ; 159E
    ret ; 159F
midi_15A0:
    inc si ; 15A0
midi_15A1:
    inc si ; 15A1
    jmp short midi_15D5 ; 15A2
midi_15A4:
    cmp al, 0F0h ; 15A4
    je short midi_15B6 ; 15A6
    cmp al, 0F7h ; 15A8
    je short midi_15B6 ; 15AA
    cmp al, 0FFh ; 15AC
    jne short midi_15CA ; 15AE
    lods byte ptr es:[si] ; 15B0
    cmp al, 02Fh ; 15B2
    je short midi_15CA ; 15B4
midi_15B6:
    mov dx, si ; 15B6
    mov si, word ptr [bp + 4] ; 15B8
    mov word ptr [si], dx ; 15BB
    push si ; 15BD
    call near ptr _snd_101E ; 15BE
    inc sp ; 15C1
    inc sp ; 15C2
    add word ptr [si], ax ; 15C3
    xor ax, ax ; 15C5
    pop si ; 15C7
    leave ; 15C8
    ret ; 15C9
midi_15CA:
    xor ax, ax ; 15CA
    mov word ptr [_snd_scan_note_count], ax ; 15CC
    mov word ptr [_snd_scan_end_tick+02h], ax ; 15CF
    mov word ptr [_snd_scan_end_tick], ax ; 15D2
midi_15D5:
    mov bx, word ptr [bp + 4] ; 15D5
    mov word ptr [bx], si ; 15D8
    xor ax, ax ; 15DA
    pop si ; 15DC
    leave ; 15DD
    ret ; 15DE
_TEXT ends
_DATA segment word public 'DATA'
extrn _snd_event_channel:byte
extrn _snd_event_note:byte
extrn _snd_event_velocity:byte
extrn _snd_scan_end_tick:byte
extrn _snd_scan_note_count:byte
_DATA ends
_BSS segment word public 'BSS'
_BSS ends
DGROUP group _DATA, _BSS
end
