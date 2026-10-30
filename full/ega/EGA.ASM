; SPEGAVGA.DRV 1.00 (October 26, 1990), recovered assembly.
; Header attribution retained: Copyright (c) 1990 Andrey Vlasov.
; All executable bytes below are assembled instructions, including the
; templates copied into generated_program. No binary include is used.
; Header-relative offsets are intentional: the initializer moves the code
; down by 22 bytes and changes CS before normal dispatch.

EGA_TEXT segment para public 'CODE'
    assume cs:EGA_TEXT
    .8086

public _ega_dispatch, _ega_header
_ega_dispatch label far
    rept 6
        nop
    endm
_ega_header label near
driver_header:
    call near ptr driver_decode
    dw 01234h
    dw driver_dispatch-driver_header
    dw 07527h ; historical stored checksum (the supplied wrapper skips rejection)
    dw (driver_end-driver_header)/2
    dw driver_relocate-driver_header
    db 'EGA/VGA Sprite Device Driver (SPEGAVGA.DRV) 1.00 - Oct 26 1990.',13,10
    db 'For EGA/VGA native graphics modes.',13,10
    db 'Copyright (c) 1990 Andrey Vlasov.',13,10,0
    db 0B0h-($-driver_header) dup (0)

return_argument_count equ L00FF+1
driver_dispatch:
    push bp ; 00B0
    mov bp, sp ; 00B1
    mov bp, word ptr [bp + 6] ; 00B3
    shl bp, 1 ; 00B6
    mov bp, word ptr cs:[bp + 0126h] ; 00B8
    sub bp, sp ; 00BD
    neg bp ; 00BF
    xchg bp, sp ; 00C1
    push bx ; 00C3
    push cx ; 00C4
    push dx ; 00C5
    push si ; 00C6
    push di ; 00C7
    push ds ; 00C8
    push es ; 00C9
    mov ax, cs ; 00CA
    mov ds, ax ; 00CC
    mov es, ax ; 00CE
    cld ; 00D0
    mov bx, word ptr [bp + 6] ; 00D1
    shl bx, 1 ; 00D4
    cmp bx, 010h ; 00D6
    nop ; 00D9
    jbe L00E1 ; 00DA
    mov ax, 2 ; 00DC
    jmp short L00E9 ; 00DF
L00E1:
    push bx ; 00E1
    push bp ; 00E2
    call word ptr [bx + 0102h] ; 00E3
    pop bp ; 00E7
    pop bx ; 00E8
L00E9:
    mov bx, word ptr cs:[bx + 0114h] ; 00E9
    mov word ptr cs:[0100h], bx ; 00EE
    jmp short L00F5 ; 00F3
L00F5:
    pop es ; 00F5
    pop ds ; 00F6
    pop di ; 00F7
    pop si ; 00F8
    pop dx ; 00F9
    pop cx ; 00FA
    pop bx ; 00FB
    mov sp, bp ; 00FC
    pop bp ; 00FE
L00FF:
    retf 2 ; 00FF
dispatch_table:
    dw create_mask-driver_header, blit_surface-driver_header, create_surface-driver_header, clip_surface-driver_header, get_pixel-driver_header, put_pixel-driver_header, surface_paragraphs-driver_header, mirror_surface_x-driver_header, fill_surface-driver_header
argument_sizes:
    dw 10, 14, 20, 26, 10, 12, 12, 10, 8
local_sizes:
    dw 12, 30, 0, 4, 0, 0, 0, 14, 6
unsupported:
    mov ax, 2 ; 0138
    ret ; 013B
work_segment:
    dw 0
work_offset:
    dw 0
generated_cursor:
    dw 0
generated_program:
    ; Runtime code-generation workspace, initialized to NOP.
    rept 800
        nop
    endm
generated_program_end:
    ret ; 0462
L0463:
    mov dx, 03CEh ; 0463
    mov ah, 0 ; 0466
    mov al, 3 ; 0468
    out dx, ax ; 046A
    mov ax, 5 ; 046B
    out dx, ax ; 046E
    mov ax, 7 ; 046F
    out dx, ax ; 0472
    mov ax, 0FF08h ; 0473
    out dx, ax ; 0476
    mov dl, 0C4h ; 0477
    mov ax, 0802h ; 0479
    ret ; 047C
L047D:
    mov dx, 03CEh ; 047D
    mov ah, byte ptr [bp - 0Dh] ; 0480
    mov al, 4 ; 0483
    out dx, ax ; 0485
    mov dl, 0C4h ; 0486
    mov cl, ah ; 0488
    mov ah, 1 ; 048A
    shl ah, cl ; 048C
    mov al, 2 ; 048E
    out dx, ax ; 0490
    ret ; 0491
L0492:
    mov dx, 03C4h ; 0492
    mov ax, 0F02h ; 0495
    out dx, ax ; 0498
    mov dl, 0CEh ; 0499
    mov ax, 3 ; 049B
    out dx, ax ; 049E
    mov ax, 5 ; 049F
    out dx, ax ; 04A2
    mov ax, 0F07h ; 04A3
    out dx, ax ; 04A6
    mov ax, 0FF08h ; 04A7
    out dx, ax ; 04AA
    ret ; 04AB
L04AC:
    test byte ptr [bp - 0Eh], 0Ah ; 04AC
    je L04B5 ; 04B0
    call near ptr L0463 ; 04B2
L04B5:
    ret ; 04B5
L04B6:
    test byte ptr [bp - 0Eh], 0Ah ; 04B6
    je L04BF ; 04BA
    call near ptr L0492 ; 04BC
L04BF:
    ret ; 04BF
L04C0:
    mov bl, byte ptr [bp - 0Dh] ; 04C0
    and bx, 3 ; 04C3
    xor bl, 3 ; 04C6
    shl bl, 1 ; 04C9
    lds si, dword ptr [bp + 8] ; 04CB
    mov ax, word ptr [bx + si + 8] ; 04CE
    add ax, word ptr [bp - 018h] ; 04D1
    mov es, ax ; 04D4
    mov al, byte ptr [bp - 014h] ; 04D6
    xor ah, ah ; 04D9
    mov di, ax ; 04DB
    lds si, dword ptr [bp + 0Ch] ; 04DD
    mov ax, word ptr [bx + si + 8] ; 04E0
    add ax, word ptr [bp - 016h] ; 04E3
    mov ds, ax ; 04E6
    mov al, byte ptr [bp - 013h] ; 04E8
    xor ah, ah ; 04EB
    mov si, ax ; 04ED
    test byte ptr [bp - 0Eh], 0Ah ; 04EF
    je L04F8 ; 04F3
    call near ptr L047D ; 04F5
L04F8:
    ret ; 04F8
L04F9:
    mov dx, 03CEh ; 04F9
    mov ax, 0803h ; 04FC
    out dx, ax ; 04FF
    ret ; 0500
L0501:
    mov dx, 03CEh ; 0501
    mov ax, 01003h ; 0504
    out dx, ax ; 0507
    ret ; 0508
L0509:
    mov dx, 03C4h ; 0509
    mov ax, 0F02h ; 050C
    out dx, ax ; 050F
    ret ; 0510
L0511:
    mov bl, byte ptr [bp - 0Dh] ; 0511
    and bx, 3 ; 0514
    shl bl, 1 ; 0517
    lds si, dword ptr [bp + 8] ; 0519
    mov ax, word ptr [si + 8] ; 051C
    add ax, word ptr [bp - 018h] ; 051F
    mov es, ax ; 0522
    mov al, byte ptr [bp - 014h] ; 0524
    xor ah, ah ; 0527
    mov di, ax ; 0529
    lds si, dword ptr [bp + 0Ch] ; 052B
    mov ax, word ptr [bx + si + 0Ah] ; 052E
    add ax, word ptr [bp - 016h] ; 0531
    mov ds, ax ; 0534
    mov al, byte ptr [bp - 013h] ; 0536
    xor ah, ah ; 0539
    mov si, ax ; 053B
    call near ptr L0509 ; 053D
    ret ; 0540
L0541:
    mov bl, 0 ; 0541
    mov bh, bl ; 0543
    not bh ; 0545
L0547:
    mov dx, 0 ; 0547
    mov ds, dx ; 054A
    mov ax, word ptr [si] ; 054C
    rol ax, cl ; 054E
    and al, bh ; 0550
    mov dx, 0 ; 0552
    mov es, dx ; 0555
    mov ah, byte ptr es:[di] ; 0557
    and ah, bl ; 055A
    or al, ah ; 055C
    mov byte ptr es:[di], al ; 055E
L0561:
    mov dx, 0 ; 0561
    mov ds, dx ; 0564
    mov ax, word ptr [si] ; 0566
    rol ax, cl ; 0568
    mov dx, 0 ; 056A
    mov es, dx ; 056D
    mov byte ptr es:[di], al ; 056F
L0572:
    mov bl, 0 ; 0572
    mov bh, bl ; 0574
    not bh ; 0576
L0578:
    mov dx, 0 ; 0578
    mov ds, dx ; 057B
    mov al, byte ptr [si] ; 057D
    and al, bh ; 057F
    mov dx, 0 ; 0581
    mov es, dx ; 0584
    mov ah, byte ptr es:[di] ; 0586
    and ah, bl ; 0589
    or al, ah ; 058B
    mov byte ptr es:[di], al ; 058D
L0590:
    mov dx, 0 ; 0590
    mov ds, dx ; 0593
    mov al, byte ptr [si] ; 0595
    mov dx, 0 ; 0597
    mov es, dx ; 059A
    mov byte ptr es:[di], al ; 059C
L059F:
    mov bl, 0 ; 059F
    mov bh, bl ; 05A1
    not bh ; 05A3
L05A5:
    mov dx, 0 ; 05A5
    mov ds, dx ; 05A8
    lodsw ; 05AA
    dec si ; 05AB
    rol ax, cl ; 05AC
    and al, bh ; 05AE
    mov dx, 0 ; 05B0
    mov es, dx ; 05B3
    mov ah, byte ptr es:[di] ; 05B5
    and ah, bl ; 05B8
    or al, ah ; 05BA
    stosb ; 05BC
L05BD:
    mov dx, 0 ; 05BD
    mov ds, dx ; 05C0
    lodsw ; 05C2
    dec si ; 05C3
    rol ax, cl ; 05C4
    mov dx, 0 ; 05C6
    mov es, dx ; 05C9
    stosb ; 05CB
L05CC:
    mov bl, 0 ; 05CC
    mov bh, bl ; 05CE
    not bh ; 05D0
L05D2:
    mov dx, 0 ; 05D2
    mov ds, dx ; 05D5
    lodsb ; 05D7
    and al, bh ; 05D8
    mov dx, 0 ; 05DA
    mov es, dx ; 05DD
    mov ah, byte ptr es:[di] ; 05DF
    and ah, bl ; 05E2
    or al, ah ; 05E4
    stosb ; 05E6
L05E7:
    mov dx, 0 ; 05E7
    mov ds, dx ; 05EA
    lodsb ; 05EC
    mov dx, 0 ; 05ED
    mov es, dx ; 05F0
    stosb ; 05F2
L05F3:
    mov dx, 0 ; 05F3
    mov ds, dx ; 05F6
    mov bx, word ptr [si] ; 05F8
    rol bx, cl ; 05FA
    mov bh, 0 ; 05FC
    or bl, bh ; 05FE
    mov bh, bl ; 0600
    not bh ; 0602
L0604:
    mov dx, 0 ; 0604
    mov ds, dx ; 0607
    mov ax, word ptr [si] ; 0609
    rol ax, cl ; 060B
    and al, bh ; 060D
    mov dx, 0 ; 060F
    mov es, dx ; 0612
    mov ah, byte ptr es:[di] ; 0614
    and ah, bl ; 0617
    or al, ah ; 0619
    mov byte ptr es:[di], al ; 061B
L061E:
    mov dx, 0 ; 061E
    mov ds, dx ; 0621
    mov bx, word ptr [si] ; 0623
    rol bx, cl ; 0625
L0627:
    mov dx, 0 ; 0627
    mov ds, dx ; 062A
    mov ax, word ptr [si] ; 062C
    rol ax, cl ; 062E
    mov dx, 0 ; 0630
    mov es, dx ; 0633
    mov ah, byte ptr es:[di] ; 0635
    and ah, bl ; 0638
    or al, ah ; 063A
    mov byte ptr es:[di], al ; 063C
L063F:
    mov dx, 0 ; 063F
    mov ds, dx ; 0642
    mov bl, byte ptr [si] ; 0644
    mov bh, 0 ; 0646
    or bl, bh ; 0648
    mov bh, bl ; 064A
    not bh ; 064C
L064E:
    mov dx, 0 ; 064E
    mov ds, dx ; 0651
    mov al, byte ptr [si] ; 0653
    and al, bh ; 0655
    mov dx, 0 ; 0657
    mov es, dx ; 065A
    mov ah, byte ptr es:[di] ; 065C
    and ah, bl ; 065F
    or al, ah ; 0661
    mov byte ptr es:[di], al ; 0663
L0666:
    mov dx, 0 ; 0666
    mov ds, dx ; 0669
    mov bl, byte ptr [si] ; 066B
L066D:
    mov dx, 0 ; 066D
    mov ds, dx ; 0670
    mov al, byte ptr [si] ; 0672
    mov dx, 0 ; 0674
    mov es, dx ; 0677
    mov ah, byte ptr es:[di] ; 0679
    and ah, bl ; 067C
    or al, ah ; 067E
    mov byte ptr es:[di], al ; 0680
L0683:
    mov dx, 0 ; 0683
    mov ds, dx ; 0686
    mov bx, word ptr [si] ; 0688
    rol bx, cl ; 068A
    mov bh, 0 ; 068C
    or bl, bh ; 068E
    mov bh, bl ; 0690
    not bh ; 0692
L0694:
    mov dx, 0 ; 0694
    mov ds, dx ; 0697
    lodsw ; 0699
    dec si ; 069A
    rol ax, cl ; 069B
    and al, bh ; 069D
    mov dx, 0 ; 069F
    mov es, dx ; 06A2
    mov ah, byte ptr es:[di] ; 06A4
    and ah, bl ; 06A7
    or al, ah ; 06A9
    stosb ; 06AB
L06AC:
    mov dx, 0 ; 06AC
    mov ds, dx ; 06AF
    mov bx, word ptr [si] ; 06B1
    rol bx, cl ; 06B3
L06B5:
    mov dx, 0 ; 06B5
    mov ds, dx ; 06B8
    lodsw ; 06BA
    dec si ; 06BB
    rol ax, cl ; 06BC
    mov dx, 0 ; 06BE
    mov es, dx ; 06C1
    mov ah, byte ptr es:[di] ; 06C3
    and ah, bl ; 06C6
    or al, ah ; 06C8
    stosb ; 06CA
L06CB:
    mov dx, 0 ; 06CB
    mov ds, dx ; 06CE
    mov bl, byte ptr [si] ; 06D0
    mov bh, 0 ; 06D2
    or bl, bh ; 06D4
    mov bh, bl ; 06D6
    not bh ; 06D8
L06DA:
    mov dx, 0 ; 06DA
    mov ds, dx ; 06DD
    lodsb ; 06DF
    and al, bh ; 06E0
    mov dx, 0 ; 06E2
    mov es, dx ; 06E5
    mov ah, byte ptr es:[di] ; 06E7
    and ah, bl ; 06EA
    or al, ah ; 06EC
    stosb ; 06EE
L06EF:
    mov dx, 0 ; 06EF
    mov ds, dx ; 06F2
    mov bl, byte ptr [si] ; 06F4
L06F6:
    mov dx, 0 ; 06F6
    mov ds, dx ; 06F9
    lodsb ; 06FB
    mov dx, 0 ; 06FC
    mov es, dx ; 06FF
    mov ah, byte ptr es:[di] ; 0701
    and ah, bl ; 0704
    or al, ah ; 0706
    stosb ; 0708
L0709:
    mov dx, 0 ; 0709
    mov es, dx ; 070C
    mov bl, byte ptr es:[di] ; 070E
    not bl ; 0711
    mov bh, 0 ; 0713
    or bl, bh ; 0715
    mov bh, bl ; 0717
    not bh ; 0719
L071B:
    mov dx, 0 ; 071B
    mov ds, dx ; 071E
    mov ax, word ptr [si] ; 0720
    rol ax, cl ; 0722
    and al, bh ; 0724
    mov dx, 0 ; 0726
    mov es, dx ; 0729
    mov ah, byte ptr es:[di] ; 072B
    and ah, bl ; 072E
    or al, ah ; 0730
    mov byte ptr es:[di], al ; 0732
L0735:
    mov dx, 0 ; 0735
    mov es, dx ; 0738
    mov bl, byte ptr es:[di] ; 073A
    not bl ; 073D
    mov bh, bl ; 073F
    not bh ; 0741
L0743:
    mov dx, 0 ; 0743
    mov ds, dx ; 0746
    mov ax, word ptr [si] ; 0748
    rol ax, cl ; 074A
    and al, bh ; 074C
    mov dx, 0 ; 074E
    mov es, dx ; 0751
    mov ah, byte ptr es:[di] ; 0753
    and ah, bl ; 0756
    or al, ah ; 0758
    mov byte ptr es:[di], al ; 075A
L075D:
    mov dx, 0 ; 075D
    mov es, dx ; 0760
    mov bl, byte ptr es:[di] ; 0762
    not bl ; 0765
    mov bh, 0 ; 0767
    or bl, bh ; 0769
    mov bh, bl ; 076B
    not bh ; 076D
L076F:
    mov dx, 0 ; 076F
    mov ds, dx ; 0772
    mov al, byte ptr [si] ; 0774
    and al, bh ; 0776
    mov dx, 0 ; 0778
    mov es, dx ; 077B
    mov ah, byte ptr es:[di] ; 077D
    and ah, bl ; 0780
    or al, ah ; 0782
    mov byte ptr es:[di], al ; 0784
L0787:
    mov dx, 0 ; 0787
    mov es, dx ; 078A
    mov bl, byte ptr es:[di] ; 078C
    not bl ; 078F
    mov bh, bl ; 0791
    not bh ; 0793
L0795:
    mov dx, 0 ; 0795
    mov ds, dx ; 0798
    mov al, byte ptr [si] ; 079A
    and al, bh ; 079C
    mov dx, 0 ; 079E
    mov es, dx ; 07A1
    mov ah, byte ptr es:[di] ; 07A3
    and ah, bl ; 07A6
    or al, ah ; 07A8
    mov byte ptr es:[di], al ; 07AA
L07AD:
    mov dx, 0 ; 07AD
    mov es, dx ; 07B0
    mov bl, byte ptr es:[di] ; 07B2
    not bl ; 07B5
    mov bh, 0 ; 07B7
    or bl, bh ; 07B9
    mov bh, bl ; 07BB
    not bh ; 07BD
L07BF:
    mov dx, 0 ; 07BF
    mov ds, dx ; 07C2
    lodsw ; 07C4
    dec si ; 07C5
    rol ax, cl ; 07C6
    and al, bh ; 07C8
    mov dx, 0 ; 07CA
    mov es, dx ; 07CD
    mov ah, byte ptr es:[di] ; 07CF
    and ah, bl ; 07D2
    or al, ah ; 07D4
    stosb ; 07D6
L07D7:
    mov dx, 0 ; 07D7
    mov es, dx ; 07DA
    mov bl, byte ptr es:[di] ; 07DC
    not bl ; 07DF
    mov bh, bl ; 07E1
    not bh ; 07E3
L07E5:
    mov dx, 0 ; 07E5
    mov ds, dx ; 07E8
    lodsw ; 07EA
    dec si ; 07EB
    rol ax, cl ; 07EC
    and al, bh ; 07EE
    mov dx, 0 ; 07F0
    mov es, dx ; 07F3
    mov ah, byte ptr es:[di] ; 07F5
    and ah, bl ; 07F8
    or al, ah ; 07FA
    stosb ; 07FC
L07FD:
    mov dx, 0 ; 07FD
    mov es, dx ; 0800
    mov bl, byte ptr es:[di] ; 0802
    not bl ; 0805
    mov bh, 0 ; 0807
    or bl, bh ; 0809
    mov bh, bl ; 080B
    not bh ; 080D
L080F:
    mov dx, 0 ; 080F
    mov ds, dx ; 0812
    lodsb ; 0814
    and al, bh ; 0815
    mov dx, 0 ; 0817
    mov es, dx ; 081A
    mov ah, byte ptr es:[di] ; 081C
    and ah, bl ; 081F
    or al, ah ; 0821
    stosb ; 0823
L0824:
    mov dx, 0 ; 0824
    mov es, dx ; 0827
    mov bl, byte ptr es:[di] ; 0829
    not bl ; 082C
    mov bh, bl ; 082E
    not bh ; 0830
L0832:
    mov dx, 0 ; 0832
    mov ds, dx ; 0835
    lodsb ; 0837
    and al, bh ; 0838
    mov dx, 0 ; 083A
    mov es, dx ; 083D
    mov ah, byte ptr es:[di] ; 083F
    and ah, bl ; 0842
    or al, ah ; 0844
    stosb ; 0846
L0847:
    mov dx, 0 ; 0847
    mov ds, dx ; 084A
    mov bx, word ptr [si] ; 084C
    rol bx, cl ; 084E
    mov dx, 0 ; 0850
    mov es, dx ; 0853
    mov bh, byte ptr es:[di] ; 0855
    not bh ; 0858
    or bl, bh ; 085A
    mov bh, 0 ; 085C
    or bl, bh ; 085E
    mov bh, bl ; 0860
    not bh ; 0862
L0864:
    mov dx, 0 ; 0864
    mov ds, dx ; 0867
    mov ax, word ptr [si] ; 0869
    rol ax, cl ; 086B
    and al, bh ; 086D
    mov dx, 0 ; 086F
    mov es, dx ; 0872
    mov ah, byte ptr es:[di] ; 0874
    and ah, bl ; 0877
    or al, ah ; 0879
    mov byte ptr es:[di], al ; 087B
L087E:
    mov dx, 0 ; 087E
    mov ds, dx ; 0881
    mov bx, word ptr [si] ; 0883
    rol bx, cl ; 0885
    mov dx, 0 ; 0887
    mov es, dx ; 088A
    mov bh, byte ptr es:[di] ; 088C
    not bh ; 088F
    or bl, bh ; 0891
    mov bh, bl ; 0893
    not bh ; 0895
L0897:
    mov dx, 0 ; 0897
    mov ds, dx ; 089A
    mov ax, word ptr [si] ; 089C
    rol ax, cl ; 089E
    and al, bh ; 08A0
    mov dx, 0 ; 08A2
    mov es, dx ; 08A5
    mov ah, byte ptr es:[di] ; 08A7
    and ah, bl ; 08AA
    or al, ah ; 08AC
    mov byte ptr es:[di], al ; 08AE
L08B1:
    mov dx, 0 ; 08B1
    mov ds, dx ; 08B4
    mov bl, byte ptr [si] ; 08B6
    mov dx, 0 ; 08B8
    mov es, dx ; 08BB
    mov bh, byte ptr es:[di] ; 08BD
    not bh ; 08C0
    or bl, bh ; 08C2
    mov bh, 0 ; 08C4
    or bl, bh ; 08C6
    mov bh, bl ; 08C8
    not bh ; 08CA
L08CC:
    mov dx, 0 ; 08CC
    mov ds, dx ; 08CF
    mov al, byte ptr [si] ; 08D1
    and al, bh ; 08D3
    mov dx, 0 ; 08D5
    mov es, dx ; 08D8
    mov ah, byte ptr es:[di] ; 08DA
    and ah, bl ; 08DD
    or al, ah ; 08DF
    mov byte ptr es:[di], al ; 08E1
L08E4:
    mov dx, 0 ; 08E4
    mov ds, dx ; 08E7
    mov bl, byte ptr [si] ; 08E9
    mov dx, 0 ; 08EB
    mov es, dx ; 08EE
    mov bh, byte ptr es:[di] ; 08F0
    not bh ; 08F3
    or bl, bh ; 08F5
    mov bh, bl ; 08F7
    not bh ; 08F9
L08FB:
    mov dx, 0 ; 08FB
    mov ds, dx ; 08FE
    mov al, byte ptr [si] ; 0900
    and al, bh ; 0902
    mov dx, 0 ; 0904
    mov es, dx ; 0907
    mov ah, byte ptr es:[di] ; 0909
    and ah, bl ; 090C
    or al, ah ; 090E
    mov byte ptr es:[di], al ; 0910
L0913:
    mov dx, 0 ; 0913
    mov ds, dx ; 0916
    mov bx, word ptr [si] ; 0918
    rol bx, cl ; 091A
    mov dx, 0 ; 091C
    mov es, dx ; 091F
    mov bh, byte ptr es:[di] ; 0921
    not bh ; 0924
    or bl, bh ; 0926
    mov bh, 0 ; 0928
    or bl, bh ; 092A
    mov bh, bl ; 092C
    not bh ; 092E
L0930:
    mov dx, 0 ; 0930
    mov ds, dx ; 0933
    lodsw ; 0935
    dec si ; 0936
    rol ax, cl ; 0937
    and al, bh ; 0939
    mov dx, 0 ; 093B
    mov es, dx ; 093E
    mov ah, byte ptr es:[di] ; 0940
    and ah, bl ; 0943
    or al, ah ; 0945
    stosb ; 0947
L0948:
    mov dx, 0 ; 0948
    mov ds, dx ; 094B
    mov bx, word ptr [si] ; 094D
    rol bx, cl ; 094F
    mov dx, 0 ; 0951
    mov es, dx ; 0954
    mov bh, byte ptr es:[di] ; 0956
    not bh ; 0959
    or bl, bh ; 095B
    mov bh, bl ; 095D
    not bh ; 095F
L0961:
    mov dx, 0 ; 0961
    mov ds, dx ; 0964
    lodsw ; 0966
    dec si ; 0967
    rol ax, cl ; 0968
    and al, bh ; 096A
    mov dx, 0 ; 096C
    mov es, dx ; 096F
    mov ah, byte ptr es:[di] ; 0971
    and ah, bl ; 0974
    or al, ah ; 0976
    stosb ; 0978
L0979:
    mov dx, 0 ; 0979
    mov ds, dx ; 097C
    mov bl, byte ptr [si] ; 097E
    mov dx, 0 ; 0980
    mov es, dx ; 0983
    mov bh, byte ptr es:[di] ; 0985
    not bh ; 0988
    or bl, bh ; 098A
    mov bh, 0 ; 098C
    or bl, bh ; 098E
    mov bh, bl ; 0990
    not bh ; 0992
L0994:
    mov dx, 0 ; 0994
    mov ds, dx ; 0997
    lodsb ; 0999
    and al, bh ; 099A
    mov dx, 0 ; 099C
    mov es, dx ; 099F
    mov ah, byte ptr es:[di] ; 09A1
    and ah, bl ; 09A4
    or al, ah ; 09A6
    stosb ; 09A8
L09A9:
    mov dx, 0 ; 09A9
    mov ds, dx ; 09AC
    mov bl, byte ptr [si] ; 09AE
    mov dx, 0 ; 09B0
    mov es, dx ; 09B3
    mov bh, byte ptr es:[di] ; 09B5
    not bh ; 09B8
    or bl, bh ; 09BA
    mov bh, bl ; 09BC
    not bh ; 09BE
L09C0:
    mov dx, 0 ; 09C0
    mov ds, dx ; 09C3
    lodsb ; 09C5
    and al, bh ; 09C6
    mov dx, 0 ; 09C8
    mov es, dx ; 09CB
    mov ah, byte ptr es:[di] ; 09CD
    and ah, bl ; 09D0
    or al, ah ; 09D2
    stosb ; 09D4
L09D5:
    inc di ; 09D5
    inc si ; 09D6
L09D7:
    dec ch ; 09D7
    jne L09DB ; 09D9
L09DB:
    dec ch ; 09DB
    je L09E2 ; 09DD
    nosmart ; runtime-patched branch template requires a word displacement
    jmp near ptr L09E2 - 10000h ; 09DF: same 16-bit IP, retain word displacement
    smart
L09E2:
    ret ; 09E2
L09E3:
    cmp bl, 0FFh ; 09E3
    je L09E8 ; 09E6
L09E8:
    cmp bl, 0FFh ; 09E8
    jne L09F2 ; 09EB
    inc di ; 09ED
    inc si ; 09EE
    nosmart ; runtime-patched branch template requires a word displacement
    jmp near ptr L09F2 - 10000h ; 09EF: same 16-bit IP, retain word displacement
    smart
L09F2:
    mov dx, 03CEh ; 09F2
    mov ax, 034h ; 09F5
    out dx, ax ; 09F8
    mov dl, 0C4h ; 09F9
    mov ax, 082h ; 09FB
    out dx, ax ; 09FE
emit_template:
    push ds ; 09FF
    push es ; 0A00
    push di ; 0A01
    push ax ; 0A02
    mov ax, cs ; 0A03
    mov es, ax ; 0A05
    mov ds, ax ; 0A07
    mov di, word ptr cs:[0140h] ; 0A09
    jcxz L0A17 ; 0A0E
    rep movsb ; 0A10
    mov word ptr cs:[0140h], di ; 0A12
L0A17:
    pop ax ; 0A17
    pop di ; 0A18
    pop es ; 0A19
    pop ds ; 0A1A
    ret ; 0A1B
L0A1C:
    test byte ptr [bp - 012h], 0FFh ; 0A1C
    je L0A25 ; 0A20
    jmp near ptr L0CD7 ; 0A22
L0A25:
    push word ptr cs:[0140h] ; 0A25
    mov ax, 0142h ; 0A2A
    mov word ptr cs:[0140h], ax ; 0A2D
    mov cl, byte ptr [bp - 0Dh] ; 0A31
    mov al, byte ptr [bp - 0Fh] ; 0A34
    not al ; 0A37
    test al, 0FFh ; 0A39
    jne L0A40 ; 0A3B
    jmp near ptr L0AE8 ; 0A3D
L0A40:
    mov byte ptr cs:[0573h], al ; 0A40
    mov bl, cl ; 0A44
    xor bh, bh ; 0A46
    shl bl, 1 ; 0A48
    push si ; 0A4A
    push cx ; 0A4B
    mov si, 0572h ; 0A4C
    mov cx, 6 ; 0A4F
    call near ptr emit_template ; 0A52
    pop cx ; 0A55
    pop si ; 0A56
    xor bx, bx ; 0A57
    push cx ; 0A59
L0A5A:
    test byte ptr [bp - 0Eh], 0Ah ; 0A5A
    je L0A7B ; 0A5E
    mov ah, 1 ; 0A60
    shl ah, cl ; 0A62
    mov byte ptr cs:[09F7h], cl ; 0A64
    mov byte ptr cs:[09FDh], ah ; 0A69
    push si ; 0A6E
    push cx ; 0A6F
    mov si, 09F2h ; 0A70
    mov cx, 0Dh ; 0A73
    call near ptr emit_template ; 0A76
    pop cx ; 0A79
    pop si ; 0A7A
L0A7B:
    mov ax, word ptr [bx + si + 8] ; 0A7B
    add ax, word ptr [bp - 016h] ; 0A7E
    mov word ptr cs:[0579h], ax ; 0A81
    mov ax, word ptr es:[bx + di + 8] ; 0A85
    add ax, word ptr [bp - 018h] ; 0A89
    mov word ptr cs:[0582h], ax ; 0A8C
    push si ; 0A90
    push cx ; 0A91
    mov si, 0578h ; 0A92
    mov cx, 018h ; 0A95
    call near ptr emit_template ; 0A98
    pop cx ; 0A9B
    pop si ; 0A9C
    inc bx ; 0A9D
    inc bx ; 0A9E
    dec cx ; 0A9F
    je L0AA4 ; 0AA0
    jmp short L0A5A ; 0AA2
L0AA4:
    test byte ptr [bp - 0Eh], 0Ah ; 0AA4
    je L0AC5 ; 0AA8
    mov ah, 1 ; 0AAA
    shl ah, cl ; 0AAC
    mov byte ptr cs:[09F7h], cl ; 0AAE
    mov byte ptr cs:[09FDh], ah ; 0AB3
    push si ; 0AB8
    push cx ; 0AB9
    mov si, 09F2h ; 0ABA
    mov cx, 0Dh ; 0ABD
    call near ptr emit_template ; 0AC0
    pop cx ; 0AC3
    pop si ; 0AC4
L0AC5:
    mov ax, word ptr [bx + si + 8] ; 0AC5
    add ax, word ptr [bp - 016h] ; 0AC8
    mov word ptr cs:[05D3h], ax ; 0ACB
    mov ax, word ptr es:[bx + di + 8] ; 0ACF
    add ax, word ptr [bp - 018h] ; 0AD3
    mov word ptr cs:[05DBh], ax ; 0AD6
    push si ; 0ADA
    push cx ; 0ADB
    mov si, 05D2h ; 0ADC
    mov cx, 015h ; 0ADF
    call near ptr emit_template ; 0AE2
    pop cx ; 0AE5
    pop si ; 0AE6
    pop cx ; 0AE7
L0AE8:
    cmp word ptr [bp - 01Ah], 0 ; 0AE8
    jne L0AF1 ; 0AEC
    jmp near ptr L0C09 ; 0AEE
L0AF1:
    push word ptr cs:[0140h] ; 0AF1
    mov bl, cl ; 0AF6
    xor bh, bh ; 0AF8
    shl bl, 1 ; 0AFA
    push si ; 0AFC
    push cx ; 0AFD
    mov si, 0590h ; 0AFE
    mov cx, 0 ; 0B01
    call near ptr emit_template ; 0B04
    pop cx ; 0B07
    pop si ; 0B08
    mov ax, 0Fh ; 0B09
    xor bx, bx ; 0B0C
    test byte ptr [bp - 0Eh], 0Ah ; 0B0E
    je L0B17 ; 0B12
    mov bx, 0Dh ; 0B14
L0B17:
    add ax, bx ; 0B17
    mul cx ; 0B19
    add ax, 0Ch ; 0B1B
    add ax, bx ; 0B1E
    test byte ptr [bp - 0Eh], 5 ; 0B20
    je L0B37 ; 0B24
    mov word ptr cs:[09F0h], ax ; 0B26
    push si ; 0B2A
    push cx ; 0B2B
    mov si, 09E8h ; 0B2C
    mov cx, 0Ah ; 0B2F
    call near ptr emit_template ; 0B32
    pop cx ; 0B35
    pop si ; 0B36
L0B37:
    xor bx, bx ; 0B37
    push cx ; 0B39
L0B3A:
    test byte ptr [bp - 0Eh], 0Ah ; 0B3A
    je L0B5B ; 0B3E
    mov ah, 1 ; 0B40
    shl ah, cl ; 0B42
    mov byte ptr cs:[09F7h], cl ; 0B44
    mov byte ptr cs:[09FDh], ah ; 0B49
    push si ; 0B4E
    push cx ; 0B4F
    mov si, 09F2h ; 0B50
    mov cx, 0Dh ; 0B53
    call near ptr emit_template ; 0B56
    pop cx ; 0B59
    pop si ; 0B5A
L0B5B:
    mov ax, word ptr [bx + si + 8] ; 0B5B
    add ax, word ptr [bp - 016h] ; 0B5E
    mov word ptr cs:[0591h], ax ; 0B61
    mov ax, word ptr es:[bx + di + 8] ; 0B65
    add ax, word ptr [bp - 018h] ; 0B69
    mov word ptr cs:[0598h], ax ; 0B6C
    push si ; 0B70
    push cx ; 0B71
    mov si, 0590h ; 0B72
    mov cx, 0Fh ; 0B75
    call near ptr emit_template ; 0B78
    pop cx ; 0B7B
    pop si ; 0B7C
    inc bx ; 0B7D
    inc bx ; 0B7E
    dec cx ; 0B7F
    je L0B84 ; 0B80
    jmp short L0B3A ; 0B82
L0B84:
    test byte ptr [bp - 0Eh], 0Ah ; 0B84
    je L0BA5 ; 0B88
    mov ah, 1 ; 0B8A
    shl ah, cl ; 0B8C
    mov byte ptr cs:[09F7h], cl ; 0B8E
    mov byte ptr cs:[09FDh], ah ; 0B93
    push si ; 0B98
    push cx ; 0B99
    mov si, 09F2h ; 0B9A
    mov cx, 0Dh ; 0B9D
    call near ptr emit_template ; 0BA0
    pop cx ; 0BA3
    pop si ; 0BA4
L0BA5:
    mov ax, word ptr [bx + si + 8] ; 0BA5
    add ax, word ptr [bp - 016h] ; 0BA8
    mov word ptr cs:[05E8h], ax ; 0BAB
    mov ax, word ptr es:[bx + di + 8] ; 0BAF
    add ax, word ptr [bp - 018h] ; 0BB3
    mov word ptr cs:[05EEh], ax ; 0BB6
    push si ; 0BBA
    push cx ; 0BBB
    mov si, 05E7h ; 0BBC
    mov cx, 0Ch ; 0BBF
    call near ptr emit_template ; 0BC2
    pop cx ; 0BC5
    pop si ; 0BC6
    pop cx ; 0BC7
    mov ax, word ptr cs:[0140h] ; 0BC8
    pop bx ; 0BCC
    sub ax, bx ; 0BCD
    mov bx, ax ; 0BCF
    add ax, 4 ; 0BD1
    cmp ax, 07Fh ; 0BD4
    jg L0BEE ; 0BD7
    neg ax ; 0BD9
    mov byte ptr cs:[09DAh], al ; 0BDB
    push si ; 0BDF
    push cx ; 0BE0
    mov si, 09D7h ; 0BE1
    mov cx, 4 ; 0BE4
    call near ptr emit_template ; 0BE7
    pop cx ; 0BEA
    pop si ; 0BEB
    jmp short L0C06 ; 0BEC
L0BEE:
    mov ax, bx ; 0BEE
    add ax, 7 ; 0BF0
    neg ax ; 0BF3
    mov word ptr cs:[09E0h], ax ; 0BF5
    push si ; 0BF9
    push cx ; 0BFA
    mov si, 09DBh ; 0BFB
    mov cx, 7 ; 0BFE
    call near ptr emit_template ; 0C01
    pop cx ; 0C04
    pop si ; 0C05
L0C06:
    mov word ptr [bp - 4], bx ; 0C06
L0C09:
    mov al, byte ptr [bp - 010h] ; 0C09
    not al ; 0C0C
    test al, 0FFh ; 0C0E
    jne L0C15 ; 0C10
    jmp near ptr L0CBD ; 0C12
L0C15:
    mov byte ptr cs:[0573h], al ; 0C15
    mov bl, cl ; 0C19
    xor bh, bh ; 0C1B
    shl bl, 1 ; 0C1D
    push si ; 0C1F
    push cx ; 0C20
    mov si, 0572h ; 0C21
    mov cx, 6 ; 0C24
    call near ptr emit_template ; 0C27
    pop cx ; 0C2A
    pop si ; 0C2B
    xor bx, bx ; 0C2C
    push cx ; 0C2E
L0C2F:
    test byte ptr [bp - 0Eh], 0Ah ; 0C2F
    je L0C50 ; 0C33
    mov ah, 1 ; 0C35
    shl ah, cl ; 0C37
    mov byte ptr cs:[09F7h], cl ; 0C39
    mov byte ptr cs:[09FDh], ah ; 0C3E
    push si ; 0C43
    push cx ; 0C44
    mov si, 09F2h ; 0C45
    mov cx, 0Dh ; 0C48
    call near ptr emit_template ; 0C4B
    pop cx ; 0C4E
    pop si ; 0C4F
L0C50:
    mov ax, word ptr [bx + si + 8] ; 0C50
    add ax, word ptr [bp - 016h] ; 0C53
    mov word ptr cs:[0579h], ax ; 0C56
    mov ax, word ptr es:[bx + di + 8] ; 0C5A
    add ax, word ptr [bp - 018h] ; 0C5E
    mov word ptr cs:[0582h], ax ; 0C61
    push si ; 0C65
    push cx ; 0C66
    mov si, 0578h ; 0C67
    mov cx, 018h ; 0C6A
    call near ptr emit_template ; 0C6D
    pop cx ; 0C70
    pop si ; 0C71
    inc bx ; 0C72
    inc bx ; 0C73
    dec cx ; 0C74
    je L0C79 ; 0C75
    jmp short L0C2F ; 0C77
L0C79:
    test byte ptr [bp - 0Eh], 0Ah ; 0C79
    je L0C9A ; 0C7D
    mov ah, 1 ; 0C7F
    shl ah, cl ; 0C81
    mov byte ptr cs:[09F7h], cl ; 0C83
    mov byte ptr cs:[09FDh], ah ; 0C88
    push si ; 0C8D
    push cx ; 0C8E
    mov si, 09F2h ; 0C8F
    mov cx, 0Dh ; 0C92
    call near ptr emit_template ; 0C95
    pop cx ; 0C98
    pop si ; 0C99
L0C9A:
    mov ax, word ptr [bx + si + 8] ; 0C9A
    add ax, word ptr [bp - 016h] ; 0C9D
    mov word ptr cs:[05D3h], ax ; 0CA0
    mov ax, word ptr es:[bx + di + 8] ; 0CA4
    add ax, word ptr [bp - 018h] ; 0CA8
    mov word ptr cs:[05DBh], ax ; 0CAB
    push si ; 0CAF
    push cx ; 0CB0
    mov si, 05D2h ; 0CB1
    mov cx, 015h ; 0CB4
    call near ptr emit_template ; 0CB7
    pop cx ; 0CBA
    pop si ; 0CBB
    pop cx ; 0CBC
L0CBD:
    push si ; 0CBD
    push cx ; 0CBE
    mov si, 09E2h ; 0CBF
    mov cx, 1 ; 0CC2
    call near ptr emit_template ; 0CC5
    pop cx ; 0CC8
    pop si ; 0CC9
    mov ax, word ptr cs:[0140h] ; 0CCA
    pop bx ; 0CCE
    sub ax, bx ; 0CCF
    mov word ptr [bp - 2], ax ; 0CD1
    jmp near ptr L0F86 ; 0CD4
L0CD7:
    push word ptr cs:[0140h] ; 0CD7
    mov ax, 0142h ; 0CDC
    mov word ptr cs:[0140h], ax ; 0CDF
    mov cl, byte ptr [bp - 0Dh] ; 0CE3
    mov al, byte ptr [bp - 0Fh] ; 0CE6
    not al ; 0CE9
    test al, 0FFh ; 0CEB
    jne L0CF2 ; 0CED
    jmp near ptr L0D9A ; 0CEF
L0CF2:
    mov byte ptr cs:[0542h], al ; 0CF2
    mov bl, cl ; 0CF6
    xor bh, bh ; 0CF8
    shl bl, 1 ; 0CFA
    push si ; 0CFC
    push cx ; 0CFD
    mov si, 0541h ; 0CFE
    mov cx, 6 ; 0D01
    call near ptr emit_template ; 0D04
    pop cx ; 0D07
    pop si ; 0D08
    xor bx, bx ; 0D09
    push cx ; 0D0B
L0D0C:
    test byte ptr [bp - 0Eh], 0Ah ; 0D0C
    je L0D2D ; 0D10
    mov ah, 1 ; 0D12
    shl ah, cl ; 0D14
    mov byte ptr cs:[09F7h], cl ; 0D16
    mov byte ptr cs:[09FDh], ah ; 0D1B
    push si ; 0D20
    push cx ; 0D21
    mov si, 09F2h ; 0D22
    mov cx, 0Dh ; 0D25
    call near ptr emit_template ; 0D28
    pop cx ; 0D2B
    pop si ; 0D2C
L0D2D:
    mov ax, word ptr [bx + si + 8] ; 0D2D
    add ax, word ptr [bp - 016h] ; 0D30
    mov word ptr cs:[0548h], ax ; 0D33
    mov ax, word ptr es:[bx + di + 8] ; 0D37
    add ax, word ptr [bp - 018h] ; 0D3B
    mov word ptr cs:[0553h], ax ; 0D3E
    push si ; 0D42
    push cx ; 0D43
    mov si, 0547h ; 0D44
    mov cx, 01Ah ; 0D47
    call near ptr emit_template ; 0D4A
    pop cx ; 0D4D
    pop si ; 0D4E
    inc bx ; 0D4F
    inc bx ; 0D50
    dec cx ; 0D51
    je L0D56 ; 0D52
    jmp short L0D0C ; 0D54
L0D56:
    test byte ptr [bp - 0Eh], 0Ah ; 0D56
    je L0D77 ; 0D5A
    mov ah, 1 ; 0D5C
    shl ah, cl ; 0D5E
    mov byte ptr cs:[09F7h], cl ; 0D60
    mov byte ptr cs:[09FDh], ah ; 0D65
    push si ; 0D6A
    push cx ; 0D6B
    mov si, 09F2h ; 0D6C
    mov cx, 0Dh ; 0D6F
    call near ptr emit_template ; 0D72
    pop cx ; 0D75
    pop si ; 0D76
L0D77:
    mov ax, word ptr [bx + si + 8] ; 0D77
    add ax, word ptr [bp - 016h] ; 0D7A
    mov word ptr cs:[05A6h], ax ; 0D7D
    mov ax, word ptr es:[bx + di + 8] ; 0D81
    add ax, word ptr [bp - 018h] ; 0D85
    mov word ptr cs:[05B1h], ax ; 0D88
    push si ; 0D8C
    push cx ; 0D8D
    mov si, 05A5h ; 0D8E
    mov cx, 018h ; 0D91
    call near ptr emit_template ; 0D94
    pop cx ; 0D97
    pop si ; 0D98
    pop cx ; 0D99
L0D9A:
    cmp word ptr [bp - 01Ah], 0 ; 0D9A
    jne L0DA3 ; 0D9E
    jmp near ptr L0EBB ; 0DA0
L0DA3:
    push word ptr cs:[0140h] ; 0DA3
    mov bl, cl ; 0DA8
    xor bh, bh ; 0DAA
    shl bl, 1 ; 0DAC
    push si ; 0DAE
    push cx ; 0DAF
    mov si, 0561h ; 0DB0
    mov cx, 0 ; 0DB3
    call near ptr emit_template ; 0DB6
    pop cx ; 0DB9
    pop si ; 0DBA
    mov ax, 011h ; 0DBB
    xor bx, bx ; 0DBE
    test byte ptr [bp - 0Eh], 0Ah ; 0DC0
    je L0DC9 ; 0DC4
    mov bx, 0Dh ; 0DC6
L0DC9:
    add ax, bx ; 0DC9
    mul cx ; 0DCB
    add ax, 0Fh ; 0DCD
    add ax, bx ; 0DD0
    test byte ptr [bp - 0Eh], 5 ; 0DD2
    je L0DE9 ; 0DD6
    mov word ptr cs:[09F0h], ax ; 0DD8
    push si ; 0DDC
    push cx ; 0DDD
    mov si, 09E8h ; 0DDE
    mov cx, 0Ah ; 0DE1
    call near ptr emit_template ; 0DE4
    pop cx ; 0DE7
    pop si ; 0DE8
L0DE9:
    xor bx, bx ; 0DE9
    push cx ; 0DEB
L0DEC:
    test byte ptr [bp - 0Eh], 0Ah ; 0DEC
    je L0E0D ; 0DF0
    mov ah, 1 ; 0DF2
    shl ah, cl ; 0DF4
    mov byte ptr cs:[09F7h], cl ; 0DF6
    mov byte ptr cs:[09FDh], ah ; 0DFB
    push si ; 0E00
    push cx ; 0E01
    mov si, 09F2h ; 0E02
    mov cx, 0Dh ; 0E05
    call near ptr emit_template ; 0E08
    pop cx ; 0E0B
    pop si ; 0E0C
L0E0D:
    mov ax, word ptr [bx + si + 8] ; 0E0D
    add ax, word ptr [bp - 016h] ; 0E10
    mov word ptr cs:[0562h], ax ; 0E13
    mov ax, word ptr es:[bx + di + 8] ; 0E17
    add ax, word ptr [bp - 018h] ; 0E1B
    mov word ptr cs:[056Bh], ax ; 0E1E
    push si ; 0E22
    push cx ; 0E23
    mov si, 0561h ; 0E24
    mov cx, 011h ; 0E27
    call near ptr emit_template ; 0E2A
    pop cx ; 0E2D
    pop si ; 0E2E
    inc bx ; 0E2F
    inc bx ; 0E30
    dec cx ; 0E31
    je L0E36 ; 0E32
    jmp short L0DEC ; 0E34
L0E36:
    test byte ptr [bp - 0Eh], 0Ah ; 0E36
    je L0E57 ; 0E3A
    mov ah, 1 ; 0E3C
    shl ah, cl ; 0E3E
    mov byte ptr cs:[09F7h], cl ; 0E40
    mov byte ptr cs:[09FDh], ah ; 0E45
    push si ; 0E4A
    push cx ; 0E4B
    mov si, 09F2h ; 0E4C
    mov cx, 0Dh ; 0E4F
    call near ptr emit_template ; 0E52
    pop cx ; 0E55
    pop si ; 0E56
L0E57:
    mov ax, word ptr [bx + si + 8] ; 0E57
    add ax, word ptr [bp - 016h] ; 0E5A
    mov word ptr cs:[05BEh], ax ; 0E5D
    mov ax, word ptr es:[bx + di + 8] ; 0E61
    add ax, word ptr [bp - 018h] ; 0E65
    mov word ptr cs:[05C7h], ax ; 0E68
    push si ; 0E6C
    push cx ; 0E6D
    mov si, 05BDh ; 0E6E
    mov cx, 0Fh ; 0E71
    call near ptr emit_template ; 0E74
    pop cx ; 0E77
    pop si ; 0E78
    pop cx ; 0E79
    mov ax, word ptr cs:[0140h] ; 0E7A
    pop bx ; 0E7E
    sub ax, bx ; 0E7F
    mov bx, ax ; 0E81
    add ax, 4 ; 0E83
    cmp ax, 07Fh ; 0E86
    jg L0EA0 ; 0E89
    neg ax ; 0E8B
    mov byte ptr cs:[09DAh], al ; 0E8D
    push si ; 0E91
    push cx ; 0E92
    mov si, 09D7h ; 0E93
    mov cx, 4 ; 0E96
    call near ptr emit_template ; 0E99
    pop cx ; 0E9C
    pop si ; 0E9D
    jmp short L0EB8 ; 0E9E
L0EA0:
    mov ax, bx ; 0EA0
    add ax, 7 ; 0EA2
    neg ax ; 0EA5
    mov word ptr cs:[09E0h], ax ; 0EA7
    push si ; 0EAB
    push cx ; 0EAC
    mov si, 09DBh ; 0EAD
    mov cx, 7 ; 0EB0
    call near ptr emit_template ; 0EB3
    pop cx ; 0EB6
    pop si ; 0EB7
L0EB8:
    mov word ptr [bp - 4], bx ; 0EB8
L0EBB:
    mov al, byte ptr [bp - 010h] ; 0EBB
    not al ; 0EBE
    test al, 0FFh ; 0EC0
    jne L0EC7 ; 0EC2
    jmp near ptr L0F6F ; 0EC4
L0EC7:
    mov byte ptr cs:[0542h], al ; 0EC7
    mov bl, cl ; 0ECB
    xor bh, bh ; 0ECD
    shl bl, 1 ; 0ECF
    push si ; 0ED1
    push cx ; 0ED2
    mov si, 0541h ; 0ED3
    mov cx, 6 ; 0ED6
    call near ptr emit_template ; 0ED9
    pop cx ; 0EDC
    pop si ; 0EDD
    xor bx, bx ; 0EDE
    push cx ; 0EE0
L0EE1:
    test byte ptr [bp - 0Eh], 0Ah ; 0EE1
    je L0F02 ; 0EE5
    mov ah, 1 ; 0EE7
    shl ah, cl ; 0EE9
    mov byte ptr cs:[09F7h], cl ; 0EEB
    mov byte ptr cs:[09FDh], ah ; 0EF0
    push si ; 0EF5
    push cx ; 0EF6
    mov si, 09F2h ; 0EF7
    mov cx, 0Dh ; 0EFA
    call near ptr emit_template ; 0EFD
    pop cx ; 0F00
    pop si ; 0F01
L0F02:
    mov ax, word ptr [bx + si + 8] ; 0F02
    add ax, word ptr [bp - 016h] ; 0F05
    mov word ptr cs:[0548h], ax ; 0F08
    mov ax, word ptr es:[bx + di + 8] ; 0F0C
    add ax, word ptr [bp - 018h] ; 0F10
    mov word ptr cs:[0553h], ax ; 0F13
    push si ; 0F17
    push cx ; 0F18
    mov si, 0547h ; 0F19
    mov cx, 01Ah ; 0F1C
    call near ptr emit_template ; 0F1F
    pop cx ; 0F22
    pop si ; 0F23
    inc bx ; 0F24
    inc bx ; 0F25
    dec cx ; 0F26
    je L0F2B ; 0F27
    jmp short L0EE1 ; 0F29
L0F2B:
    test byte ptr [bp - 0Eh], 0Ah ; 0F2B
    je L0F4C ; 0F2F
    mov ah, 1 ; 0F31
    shl ah, cl ; 0F33
    mov byte ptr cs:[09F7h], cl ; 0F35
    mov byte ptr cs:[09FDh], ah ; 0F3A
    push si ; 0F3F
    push cx ; 0F40
    mov si, 09F2h ; 0F41
    mov cx, 0Dh ; 0F44
    call near ptr emit_template ; 0F47
    pop cx ; 0F4A
    pop si ; 0F4B
L0F4C:
    mov ax, word ptr [bx + si + 8] ; 0F4C
    add ax, word ptr [bp - 016h] ; 0F4F
    mov word ptr cs:[05A6h], ax ; 0F52
    mov ax, word ptr es:[bx + di + 8] ; 0F56
    add ax, word ptr [bp - 018h] ; 0F5A
    mov word ptr cs:[05B1h], ax ; 0F5D
    push si ; 0F61
    push cx ; 0F62
    mov si, 05A5h ; 0F63
    mov cx, 018h ; 0F66
    call near ptr emit_template ; 0F69
    pop cx ; 0F6C
    pop si ; 0F6D
    pop cx ; 0F6E
L0F6F:
    push si ; 0F6F
    push cx ; 0F70
    mov si, 09E2h ; 0F71
    mov cx, 1 ; 0F74
    call near ptr emit_template ; 0F77
    pop cx ; 0F7A
    pop si ; 0F7B
    mov ax, word ptr cs:[0140h] ; 0F7C
    pop bx ; 0F80
    sub ax, bx ; 0F81
    mov word ptr [bp - 2], ax ; 0F83
L0F86:
    ret ; 0F86
L0F87:
    test byte ptr [bp - 012h], 0FFh ; 0F87
    je L0F90 ; 0F8B
    jmp near ptr L1260 ; 0F8D
L0F90:
    push word ptr cs:[0140h] ; 0F90
    mov ax, 0142h ; 0F95
    mov word ptr cs:[0140h], ax ; 0F98
    mov cl, byte ptr [bp - 0Dh] ; 0F9C
    mov al, byte ptr [bp - 0Fh] ; 0F9F
    not al ; 0FA2
    test al, 0FFh ; 0FA4
    jne L0FAB ; 0FA6
    jmp near ptr L105D ; 0FA8
L0FAB:
    mov byte ptr cs:[0647h], al ; 0FAB
    mov bl, cl ; 0FAF
    xor bh, bh ; 0FB1
    shl bl, 1 ; 0FB3
    mov ax, word ptr [bx + si + 0Ah] ; 0FB5
    add ax, word ptr [bp - 016h] ; 0FB8
    mov word ptr cs:[0640h], ax ; 0FBB
    push si ; 0FBF
    push cx ; 0FC0
    mov si, 063Fh ; 0FC1
    mov cx, 0Fh ; 0FC4
    call near ptr emit_template ; 0FC7
    pop cx ; 0FCA
    pop si ; 0FCB
    xor bx, bx ; 0FCC
    push cx ; 0FCE
L0FCF:
    test byte ptr [bp - 0Eh], 0Ah ; 0FCF
    je L0FF0 ; 0FD3
    mov ah, 1 ; 0FD5
    shl ah, cl ; 0FD7
    mov byte ptr cs:[09F7h], cl ; 0FD9
    mov byte ptr cs:[09FDh], ah ; 0FDE
    push si ; 0FE3
    push cx ; 0FE4
    mov si, 09F2h ; 0FE5
    mov cx, 0Dh ; 0FE8
    call near ptr emit_template ; 0FEB
    pop cx ; 0FEE
    pop si ; 0FEF
L0FF0:
    mov ax, word ptr [bx + si + 8] ; 0FF0
    add ax, word ptr [bp - 016h] ; 0FF3
    mov word ptr cs:[064Fh], ax ; 0FF6
    mov ax, word ptr es:[bx + di + 8] ; 0FFA
    add ax, word ptr [bp - 018h] ; 0FFE
    mov word ptr cs:[0658h], ax ; 1001
    push si ; 1005
    push cx ; 1006
    mov si, 064Eh ; 1007
    mov cx, 018h ; 100A
    call near ptr emit_template ; 100D
    pop cx ; 1010
    pop si ; 1011
    inc bx ; 1012
    inc bx ; 1013
    dec cx ; 1014
    je L1019 ; 1015
    jmp short L0FCF ; 1017
L1019:
    test byte ptr [bp - 0Eh], 0Ah ; 1019
    je L103A ; 101D
    mov ah, 1 ; 101F
    shl ah, cl ; 1021
    mov byte ptr cs:[09F7h], cl ; 1023
    mov byte ptr cs:[09FDh], ah ; 1028
    push si ; 102D
    push cx ; 102E
    mov si, 09F2h ; 102F
    mov cx, 0Dh ; 1032
    call near ptr emit_template ; 1035
    pop cx ; 1038
    pop si ; 1039
L103A:
    mov ax, word ptr [bx + si + 8] ; 103A
    add ax, word ptr [bp - 016h] ; 103D
    mov word ptr cs:[06DBh], ax ; 1040
    mov ax, word ptr es:[bx + di + 8] ; 1044
    add ax, word ptr [bp - 018h] ; 1048
    mov word ptr cs:[06E3h], ax ; 104B
    push si ; 104F
    push cx ; 1050
    mov si, 06DAh ; 1051
    mov cx, 015h ; 1054
    call near ptr emit_template ; 1057
    pop cx ; 105A
    pop si ; 105B
    pop cx ; 105C
L105D:
    cmp word ptr [bp - 01Ah], 0 ; 105D
    jne L1066 ; 1061
    jmp near ptr L1188 ; 1063
L1066:
    push word ptr cs:[0140h] ; 1066
    mov bl, cl ; 106B
    xor bh, bh ; 106D
    shl bl, 1 ; 106F
    mov ax, word ptr [bx + si + 0Ah] ; 1071
    add ax, word ptr [bp - 016h] ; 1074
    mov word ptr cs:[0667h], ax ; 1077
    push si ; 107B
    push cx ; 107C
    mov si, 0666h ; 107D
    mov cx, 7 ; 1080
    call near ptr emit_template ; 1083
    pop cx ; 1086
    pop si ; 1087
    mov ax, 016h ; 1088
    xor bx, bx ; 108B
    test byte ptr [bp - 0Eh], 0Ah ; 108D
    je L1096 ; 1091
    mov bx, 0Dh ; 1093
L1096:
    add ax, bx ; 1096
    mul cx ; 1098
    add ax, 013h ; 109A
    add ax, bx ; 109D
    test byte ptr [bp - 0Eh], 5 ; 109F
    je L10B6 ; 10A3
    mov word ptr cs:[09F0h], ax ; 10A5
    push si ; 10A9
    push cx ; 10AA
    mov si, 09E8h ; 10AB
    mov cx, 0Ah ; 10AE
    call near ptr emit_template ; 10B1
    pop cx ; 10B4
    pop si ; 10B5
L10B6:
    xor bx, bx ; 10B6
    push cx ; 10B8
L10B9:
    test byte ptr [bp - 0Eh], 0Ah ; 10B9
    je L10DA ; 10BD
    mov ah, 1 ; 10BF
    shl ah, cl ; 10C1
    mov byte ptr cs:[09F7h], cl ; 10C3
    mov byte ptr cs:[09FDh], ah ; 10C8
    push si ; 10CD
    push cx ; 10CE
    mov si, 09F2h ; 10CF
    mov cx, 0Dh ; 10D2
    call near ptr emit_template ; 10D5
    pop cx ; 10D8
    pop si ; 10D9
L10DA:
    mov ax, word ptr [bx + si + 8] ; 10DA
    add ax, word ptr [bp - 016h] ; 10DD
    mov word ptr cs:[066Eh], ax ; 10E0
    mov ax, word ptr es:[bx + di + 8] ; 10E4
    add ax, word ptr [bp - 018h] ; 10E8
    mov word ptr cs:[0675h], ax ; 10EB
    push si ; 10EF
    push cx ; 10F0
    mov si, 066Dh ; 10F1
    mov cx, 016h ; 10F4
    call near ptr emit_template ; 10F7
    pop cx ; 10FA
    pop si ; 10FB
    inc bx ; 10FC
    inc bx ; 10FD
    dec cx ; 10FE
    je L1103 ; 10FF
    jmp short L10B9 ; 1101
L1103:
    test byte ptr [bp - 0Eh], 0Ah ; 1103
    je L1124 ; 1107
    mov ah, 1 ; 1109
    shl ah, cl ; 110B
    mov byte ptr cs:[09F7h], cl ; 110D
    mov byte ptr cs:[09FDh], ah ; 1112
    push si ; 1117
    push cx ; 1118
    mov si, 09F2h ; 1119
    mov cx, 0Dh ; 111C
    call near ptr emit_template ; 111F
    pop cx ; 1122
    pop si ; 1123
L1124:
    mov ax, word ptr [bx + si + 8] ; 1124
    add ax, word ptr [bp - 016h] ; 1127
    mov word ptr cs:[06F7h], ax ; 112A
    mov ax, word ptr es:[bx + di + 8] ; 112E
    add ax, word ptr [bp - 018h] ; 1132
    mov word ptr cs:[06FDh], ax ; 1135
    push si ; 1139
    push cx ; 113A
    mov si, 06F6h ; 113B
    mov cx, 013h ; 113E
    call near ptr emit_template ; 1141
    pop cx ; 1144
    pop si ; 1145
    pop cx ; 1146
    mov ax, word ptr cs:[0140h] ; 1147
    pop bx ; 114B
    sub ax, bx ; 114C
    mov bx, ax ; 114E
    add ax, 4 ; 1150
    cmp ax, 07Fh ; 1153
    jg L116D ; 1156
    neg ax ; 1158
    mov byte ptr cs:[09DAh], al ; 115A
    push si ; 115E
    push cx ; 115F
    mov si, 09D7h ; 1160
    mov cx, 4 ; 1163
    call near ptr emit_template ; 1166
    pop cx ; 1169
    pop si ; 116A
    jmp short L1185 ; 116B
L116D:
    mov ax, bx ; 116D
    add ax, 7 ; 116F
    neg ax ; 1172
    mov word ptr cs:[09E0h], ax ; 1174
    push si ; 1178
    push cx ; 1179
    mov si, 09DBh ; 117A
    mov cx, 7 ; 117D
    call near ptr emit_template ; 1180
    pop cx ; 1183
    pop si ; 1184
L1185:
    mov word ptr [bp - 4], bx ; 1185
L1188:
    mov al, byte ptr [bp - 010h] ; 1188
    not al ; 118B
    test al, 0FFh ; 118D
    jne L1194 ; 118F
    jmp near ptr L1246 ; 1191
L1194:
    mov byte ptr cs:[0647h], al ; 1194
    mov bl, cl ; 1198
    xor bh, bh ; 119A
    shl bl, 1 ; 119C
    mov ax, word ptr [bx + si + 0Ah] ; 119E
    add ax, word ptr [bp - 016h] ; 11A1
    mov word ptr cs:[0640h], ax ; 11A4
    push si ; 11A8
    push cx ; 11A9
    mov si, 063Fh ; 11AA
    mov cx, 0Fh ; 11AD
    call near ptr emit_template ; 11B0
    pop cx ; 11B3
    pop si ; 11B4
    xor bx, bx ; 11B5
    push cx ; 11B7
L11B8:
    test byte ptr [bp - 0Eh], 0Ah ; 11B8
    je L11D9 ; 11BC
    mov ah, 1 ; 11BE
    shl ah, cl ; 11C0
    mov byte ptr cs:[09F7h], cl ; 11C2
    mov byte ptr cs:[09FDh], ah ; 11C7
    push si ; 11CC
    push cx ; 11CD
    mov si, 09F2h ; 11CE
    mov cx, 0Dh ; 11D1
    call near ptr emit_template ; 11D4
    pop cx ; 11D7
    pop si ; 11D8
L11D9:
    mov ax, word ptr [bx + si + 8] ; 11D9
    add ax, word ptr [bp - 016h] ; 11DC
    mov word ptr cs:[064Fh], ax ; 11DF
    mov ax, word ptr es:[bx + di + 8] ; 11E3
    add ax, word ptr [bp - 018h] ; 11E7
    mov word ptr cs:[0658h], ax ; 11EA
    push si ; 11EE
    push cx ; 11EF
    mov si, 064Eh ; 11F0
    mov cx, 018h ; 11F3
    call near ptr emit_template ; 11F6
    pop cx ; 11F9
    pop si ; 11FA
    inc bx ; 11FB
    inc bx ; 11FC
    dec cx ; 11FD
    je L1202 ; 11FE
    jmp short L11B8 ; 1200
L1202:
    test byte ptr [bp - 0Eh], 0Ah ; 1202
    je L1223 ; 1206
    mov ah, 1 ; 1208
    shl ah, cl ; 120A
    mov byte ptr cs:[09F7h], cl ; 120C
    mov byte ptr cs:[09FDh], ah ; 1211
    push si ; 1216
    push cx ; 1217
    mov si, 09F2h ; 1218
    mov cx, 0Dh ; 121B
    call near ptr emit_template ; 121E
    pop cx ; 1221
    pop si ; 1222
L1223:
    mov ax, word ptr [bx + si + 8] ; 1223
    add ax, word ptr [bp - 016h] ; 1226
    mov word ptr cs:[06DBh], ax ; 1229
    mov ax, word ptr es:[bx + di + 8] ; 122D
    add ax, word ptr [bp - 018h] ; 1231
    mov word ptr cs:[06E3h], ax ; 1234
    push si ; 1238
    push cx ; 1239
    mov si, 06DAh ; 123A
    mov cx, 015h ; 123D
    call near ptr emit_template ; 1240
    pop cx ; 1243
    pop si ; 1244
    pop cx ; 1245
L1246:
    push si ; 1246
    push cx ; 1247
    mov si, 09E2h ; 1248
    mov cx, 1 ; 124B
    call near ptr emit_template ; 124E
    pop cx ; 1251
    pop si ; 1252
    mov ax, word ptr cs:[0140h] ; 1253
    pop bx ; 1257
    sub ax, bx ; 1258
    mov word ptr [bp - 2], ax ; 125A
    jmp near ptr L152D ; 125D
L1260:
    push word ptr cs:[0140h] ; 1260
    mov ax, 0142h ; 1265
    mov word ptr cs:[0140h], ax ; 1268
    mov cl, byte ptr [bp - 0Dh] ; 126C
    mov al, byte ptr [bp - 0Fh] ; 126F
    not al ; 1272
    test al, 0FFh ; 1274
    jne L127B ; 1276
    jmp near ptr L132D ; 1278
L127B:
    mov byte ptr cs:[05FDh], al ; 127B
    mov bl, cl ; 127F
    xor bh, bh ; 1281
    shl bl, 1 ; 1283
    mov ax, word ptr [bx + si + 0Ah] ; 1285
    add ax, word ptr [bp - 016h] ; 1288
    mov word ptr cs:[05F4h], ax ; 128B
    push si ; 128F
    push cx ; 1290
    mov si, 05F3h ; 1291
    mov cx, 011h ; 1294
    call near ptr emit_template ; 1297
    pop cx ; 129A
    pop si ; 129B
    xor bx, bx ; 129C
    push cx ; 129E
L129F:
    test byte ptr [bp - 0Eh], 0Ah ; 129F
    je L12C0 ; 12A3
    mov ah, 1 ; 12A5
    shl ah, cl ; 12A7
    mov byte ptr cs:[09F7h], cl ; 12A9
    mov byte ptr cs:[09FDh], ah ; 12AE
    push si ; 12B3
    push cx ; 12B4
    mov si, 09F2h ; 12B5
    mov cx, 0Dh ; 12B8
    call near ptr emit_template ; 12BB
    pop cx ; 12BE
    pop si ; 12BF
L12C0:
    mov ax, word ptr [bx + si + 8] ; 12C0
    add ax, word ptr [bp - 016h] ; 12C3
    mov word ptr cs:[0605h], ax ; 12C6
    mov ax, word ptr es:[bx + di + 8] ; 12CA
    add ax, word ptr [bp - 018h] ; 12CE
    mov word ptr cs:[0610h], ax ; 12D1
    push si ; 12D5
    push cx ; 12D6
    mov si, 0604h ; 12D7
    mov cx, 01Ah ; 12DA
    call near ptr emit_template ; 12DD
    pop cx ; 12E0
    pop si ; 12E1
    inc bx ; 12E2
    inc bx ; 12E3
    dec cx ; 12E4
    je L12E9 ; 12E5
    jmp short L129F ; 12E7
L12E9:
    test byte ptr [bp - 0Eh], 0Ah ; 12E9
    je L130A ; 12ED
    mov ah, 1 ; 12EF
    shl ah, cl ; 12F1
    mov byte ptr cs:[09F7h], cl ; 12F3
    mov byte ptr cs:[09FDh], ah ; 12F8
    push si ; 12FD
    push cx ; 12FE
    mov si, 09F2h ; 12FF
    mov cx, 0Dh ; 1302
    call near ptr emit_template ; 1305
    pop cx ; 1308
    pop si ; 1309
L130A:
    mov ax, word ptr [bx + si + 8] ; 130A
    add ax, word ptr [bp - 016h] ; 130D
    mov word ptr cs:[0695h], ax ; 1310
    mov ax, word ptr es:[bx + di + 8] ; 1314
    add ax, word ptr [bp - 018h] ; 1318
    mov word ptr cs:[06A0h], ax ; 131B
    push si ; 131F
    push cx ; 1320
    mov si, 0694h ; 1321
    mov cx, 018h ; 1324
    call near ptr emit_template ; 1327
    pop cx ; 132A
    pop si ; 132B
    pop cx ; 132C
L132D:
    cmp word ptr [bp - 01Ah], 0 ; 132D
    jne L1336 ; 1331
    jmp near ptr L1458 ; 1333
L1336:
    push word ptr cs:[0140h] ; 1336
    mov bl, cl ; 133B
    xor bh, bh ; 133D
    shl bl, 1 ; 133F
    mov ax, word ptr [bx + si + 0Ah] ; 1341
    add ax, word ptr [bp - 016h] ; 1344
    mov word ptr cs:[061Fh], ax ; 1347
    push si ; 134B
    push cx ; 134C
    mov si, 061Eh ; 134D
    mov cx, 9 ; 1350
    call near ptr emit_template ; 1353
    pop cx ; 1356
    pop si ; 1357
    mov ax, 018h ; 1358
    xor bx, bx ; 135B
    test byte ptr [bp - 0Eh], 0Ah ; 135D
    je L1366 ; 1361
    mov bx, 0Dh ; 1363
L1366:
    add ax, bx ; 1366
    mul cx ; 1368
    add ax, 016h ; 136A
    add ax, bx ; 136D
    test byte ptr [bp - 0Eh], 5 ; 136F
    je L1386 ; 1373
    mov word ptr cs:[09F0h], ax ; 1375
    push si ; 1379
    push cx ; 137A
    mov si, 09E8h ; 137B
    mov cx, 0Ah ; 137E
    call near ptr emit_template ; 1381
    pop cx ; 1384
    pop si ; 1385
L1386:
    xor bx, bx ; 1386
    push cx ; 1388
L1389:
    test byte ptr [bp - 0Eh], 0Ah ; 1389
    je L13AA ; 138D
    mov ah, 1 ; 138F
    shl ah, cl ; 1391
    mov byte ptr cs:[09F7h], cl ; 1393
    mov byte ptr cs:[09FDh], ah ; 1398
    push si ; 139D
    push cx ; 139E
    mov si, 09F2h ; 139F
    mov cx, 0Dh ; 13A2
    call near ptr emit_template ; 13A5
    pop cx ; 13A8
    pop si ; 13A9
L13AA:
    mov ax, word ptr [bx + si + 8] ; 13AA
    add ax, word ptr [bp - 016h] ; 13AD
    mov word ptr cs:[0628h], ax ; 13B0
    mov ax, word ptr es:[bx + di + 8] ; 13B4
    add ax, word ptr [bp - 018h] ; 13B8
    mov word ptr cs:[0631h], ax ; 13BB
    push si ; 13BF
    push cx ; 13C0
    mov si, 0627h ; 13C1
    mov cx, 018h ; 13C4
    call near ptr emit_template ; 13C7
    pop cx ; 13CA
    pop si ; 13CB
    inc bx ; 13CC
    inc bx ; 13CD
    dec cx ; 13CE
    je L13D3 ; 13CF
    jmp short L1389 ; 13D1
L13D3:
    test byte ptr [bp - 0Eh], 0Ah ; 13D3
    je L13F4 ; 13D7
    mov ah, 1 ; 13D9
    shl ah, cl ; 13DB
    mov byte ptr cs:[09F7h], cl ; 13DD
    mov byte ptr cs:[09FDh], ah ; 13E2
    push si ; 13E7
    push cx ; 13E8
    mov si, 09F2h ; 13E9
    mov cx, 0Dh ; 13EC
    call near ptr emit_template ; 13EF
    pop cx ; 13F2
    pop si ; 13F3
L13F4:
    mov ax, word ptr [bx + si + 8] ; 13F4
    add ax, word ptr [bp - 016h] ; 13F7
    mov word ptr cs:[06B6h], ax ; 13FA
    mov ax, word ptr es:[bx + di + 8] ; 13FE
    add ax, word ptr [bp - 018h] ; 1402
    mov word ptr cs:[06BFh], ax ; 1405
    push si ; 1409
    push cx ; 140A
    mov si, 06B5h ; 140B
    mov cx, 016h ; 140E
    call near ptr emit_template ; 1411
    pop cx ; 1414
    pop si ; 1415
    pop cx ; 1416
    mov ax, word ptr cs:[0140h] ; 1417
    pop bx ; 141B
    sub ax, bx ; 141C
    mov bx, ax ; 141E
    add ax, 4 ; 1420
    cmp ax, 07Fh ; 1423
    jg L143D ; 1426
    neg ax ; 1428
    mov byte ptr cs:[09DAh], al ; 142A
    push si ; 142E
    push cx ; 142F
    mov si, 09D7h ; 1430
    mov cx, 4 ; 1433
    call near ptr emit_template ; 1436
    pop cx ; 1439
    pop si ; 143A
    jmp short L1455 ; 143B
L143D:
    mov ax, bx ; 143D
    add ax, 7 ; 143F
    neg ax ; 1442
    mov word ptr cs:[09E0h], ax ; 1444
    push si ; 1448
    push cx ; 1449
    mov si, 09DBh ; 144A
    mov cx, 7 ; 144D
    call near ptr emit_template ; 1450
    pop cx ; 1453
    pop si ; 1454
L1455:
    mov word ptr [bp - 4], bx ; 1455
L1458:
    mov al, byte ptr [bp - 010h] ; 1458
    not al ; 145B
    test al, 0FFh ; 145D
    jne L1464 ; 145F
    jmp near ptr L1516 ; 1461
L1464:
    mov byte ptr cs:[05FDh], al ; 1464
    mov bl, cl ; 1468
    xor bh, bh ; 146A
    shl bl, 1 ; 146C
    mov ax, word ptr [bx + si + 0Ah] ; 146E
    add ax, word ptr [bp - 016h] ; 1471
    mov word ptr cs:[05F4h], ax ; 1474
    push si ; 1478
    push cx ; 1479
    mov si, 05F3h ; 147A
    mov cx, 011h ; 147D
    call near ptr emit_template ; 1480
    pop cx ; 1483
    pop si ; 1484
    xor bx, bx ; 1485
    push cx ; 1487
L1488:
    test byte ptr [bp - 0Eh], 0Ah ; 1488
    je L14A9 ; 148C
    mov ah, 1 ; 148E
    shl ah, cl ; 1490
    mov byte ptr cs:[09F7h], cl ; 1492
    mov byte ptr cs:[09FDh], ah ; 1497
    push si ; 149C
    push cx ; 149D
    mov si, 09F2h ; 149E
    mov cx, 0Dh ; 14A1
    call near ptr emit_template ; 14A4
    pop cx ; 14A7
    pop si ; 14A8
L14A9:
    mov ax, word ptr [bx + si + 8] ; 14A9
    add ax, word ptr [bp - 016h] ; 14AC
    mov word ptr cs:[0605h], ax ; 14AF
    mov ax, word ptr es:[bx + di + 8] ; 14B3
    add ax, word ptr [bp - 018h] ; 14B7
    mov word ptr cs:[0610h], ax ; 14BA
    push si ; 14BE
    push cx ; 14BF
    mov si, 0604h ; 14C0
    mov cx, 01Ah ; 14C3
    call near ptr emit_template ; 14C6
    pop cx ; 14C9
    pop si ; 14CA
    inc bx ; 14CB
    inc bx ; 14CC
    dec cx ; 14CD
    je L14D2 ; 14CE
    jmp short L1488 ; 14D0
L14D2:
    test byte ptr [bp - 0Eh], 0Ah ; 14D2
    je L14F3 ; 14D6
    mov ah, 1 ; 14D8
    shl ah, cl ; 14DA
    mov byte ptr cs:[09F7h], cl ; 14DC
    mov byte ptr cs:[09FDh], ah ; 14E1
    push si ; 14E6
    push cx ; 14E7
    mov si, 09F2h ; 14E8
    mov cx, 0Dh ; 14EB
    call near ptr emit_template ; 14EE
    pop cx ; 14F1
    pop si ; 14F2
L14F3:
    mov ax, word ptr [bx + si + 8] ; 14F3
    add ax, word ptr [bp - 016h] ; 14F6
    mov word ptr cs:[0695h], ax ; 14F9
    mov ax, word ptr es:[bx + di + 8] ; 14FD
    add ax, word ptr [bp - 018h] ; 1501
    mov word ptr cs:[06A0h], ax ; 1504
    push si ; 1508
    push cx ; 1509
    mov si, 0694h ; 150A
    mov cx, 018h ; 150D
    call near ptr emit_template ; 1510
    pop cx ; 1513
    pop si ; 1514
    pop cx ; 1515
L1516:
    push si ; 1516
    push cx ; 1517
    mov si, 09E2h ; 1518
    mov cx, 1 ; 151B
    call near ptr emit_template ; 151E
    pop cx ; 1521
    pop si ; 1522
    mov ax, word ptr cs:[0140h] ; 1523
    pop bx ; 1527
    sub ax, bx ; 1528
    mov word ptr [bp - 2], ax ; 152A
L152D:
    ret ; 152D
L152E:
    test byte ptr [bp - 012h], 0FFh ; 152E
    je L1537 ; 1532
    jmp near ptr L180A ; 1534
L1537:
    push word ptr cs:[0140h] ; 1537
    mov ax, 0142h ; 153C
    mov word ptr cs:[0140h], ax ; 153F
    mov cl, byte ptr [bp - 0Dh] ; 1543
    mov al, byte ptr [bp - 0Fh] ; 1546
    not al ; 1549
    test al, 0FFh ; 154B
    jne L1552 ; 154D
    jmp near ptr L1605 ; 154F
L1552:
    mov byte ptr cs:[0768h], al ; 1552
    mov bl, cl ; 1556
    xor bh, bh ; 1558
    shl bl, 1 ; 155A
    mov ax, word ptr es:[bx + di + 0Ah] ; 155C
    add ax, word ptr [bp - 018h] ; 1560
    mov word ptr cs:[075Eh], ax ; 1563
    push si ; 1567
    push cx ; 1568
    mov si, 075Dh ; 1569
    mov cx, 012h ; 156C
    call near ptr emit_template ; 156F
    pop cx ; 1572
    pop si ; 1573
    xor bx, bx ; 1574
    push cx ; 1576
L1577:
    test byte ptr [bp - 0Eh], 0Ah ; 1577
    je L1598 ; 157B
    mov ah, 1 ; 157D
    shl ah, cl ; 157F
    mov byte ptr cs:[09F7h], cl ; 1581
    mov byte ptr cs:[09FDh], ah ; 1586
    push si ; 158B
    push cx ; 158C
    mov si, 09F2h ; 158D
    mov cx, 0Dh ; 1590
    call near ptr emit_template ; 1593
    pop cx ; 1596
    pop si ; 1597
L1598:
    mov ax, word ptr [bx + si + 8] ; 1598
    add ax, word ptr [bp - 016h] ; 159B
    mov word ptr cs:[0770h], ax ; 159E
    mov ax, word ptr es:[bx + di + 8] ; 15A2
    add ax, word ptr [bp - 018h] ; 15A6
    mov word ptr cs:[0779h], ax ; 15A9
    push si ; 15AD
    push cx ; 15AE
    mov si, 076Fh ; 15AF
    mov cx, 018h ; 15B2
    call near ptr emit_template ; 15B5
    pop cx ; 15B8
    pop si ; 15B9
    inc bx ; 15BA
    inc bx ; 15BB
    dec cx ; 15BC
    je L15C1 ; 15BD
    jmp short L1577 ; 15BF
L15C1:
    test byte ptr [bp - 0Eh], 0Ah ; 15C1
    je L15E2 ; 15C5
    mov ah, 1 ; 15C7
    shl ah, cl ; 15C9
    mov byte ptr cs:[09F7h], cl ; 15CB
    mov byte ptr cs:[09FDh], ah ; 15D0
    push si ; 15D5
    push cx ; 15D6
    mov si, 09F2h ; 15D7
    mov cx, 0Dh ; 15DA
    call near ptr emit_template ; 15DD
    pop cx ; 15E0
    pop si ; 15E1
L15E2:
    mov ax, word ptr [bx + si + 8] ; 15E2
    add ax, word ptr [bp - 016h] ; 15E5
    mov word ptr cs:[0810h], ax ; 15E8
    mov ax, word ptr es:[bx + di + 8] ; 15EC
    add ax, word ptr [bp - 018h] ; 15F0
    mov word ptr cs:[0818h], ax ; 15F3
    push si ; 15F7
    push cx ; 15F8
    mov si, 080Fh ; 15F9
    mov cx, 015h ; 15FC
    call near ptr emit_template ; 15FF
    pop cx ; 1602
    pop si ; 1603
    pop cx ; 1604
L1605:
    cmp word ptr [bp - 01Ah], 0 ; 1605
    jne L160E ; 1609
    jmp near ptr L1731 ; 160B
L160E:
    push word ptr cs:[0140h] ; 160E
    mov bl, cl ; 1613
    xor bh, bh ; 1615
    shl bl, 1 ; 1617
    mov ax, word ptr es:[bx + di + 0Ah] ; 1619
    add ax, word ptr [bp - 018h] ; 161D
    mov word ptr cs:[0788h], ax ; 1620
    push si ; 1624
    push cx ; 1625
    mov si, 0787h ; 1626
    mov cx, 0Eh ; 1629
    call near ptr emit_template ; 162C
    pop cx ; 162F
    pop si ; 1630
    mov ax, 018h ; 1631
    xor bx, bx ; 1634
    test byte ptr [bp - 0Eh], 0Ah ; 1636
    je L163F ; 163A
    mov bx, 0Dh ; 163C
L163F:
    add ax, bx ; 163F
    mul cx ; 1641
    add ax, 015h ; 1643
    add ax, bx ; 1646
    test byte ptr [bp - 0Eh], 5 ; 1648
    je L165F ; 164C
    mov word ptr cs:[09F0h], ax ; 164E
    push si ; 1652
    push cx ; 1653
    mov si, 09E8h ; 1654
    mov cx, 0Ah ; 1657
    call near ptr emit_template ; 165A
    pop cx ; 165D
    pop si ; 165E
L165F:
    xor bx, bx ; 165F
    push cx ; 1661
L1662:
    test byte ptr [bp - 0Eh], 0Ah ; 1662
    je L1683 ; 1666
    mov ah, 1 ; 1668
    shl ah, cl ; 166A
    mov byte ptr cs:[09F7h], cl ; 166C
    mov byte ptr cs:[09FDh], ah ; 1671
    push si ; 1676
    push cx ; 1677
    mov si, 09F2h ; 1678
    mov cx, 0Dh ; 167B
    call near ptr emit_template ; 167E
    pop cx ; 1681
    pop si ; 1682
L1683:
    mov ax, word ptr [bx + si + 8] ; 1683
    add ax, word ptr [bp - 016h] ; 1686
    mov word ptr cs:[0796h], ax ; 1689
    mov ax, word ptr es:[bx + di + 8] ; 168D
    add ax, word ptr [bp - 018h] ; 1691
    mov word ptr cs:[079Fh], ax ; 1694
    push si ; 1698
    push cx ; 1699
    mov si, 0795h ; 169A
    mov cx, 018h ; 169D
    call near ptr emit_template ; 16A0
    pop cx ; 16A3
    pop si ; 16A4
    inc bx ; 16A5
    inc bx ; 16A6
    dec cx ; 16A7
    je L16AC ; 16A8
    jmp short L1662 ; 16AA
L16AC:
    test byte ptr [bp - 0Eh], 0Ah ; 16AC
    je L16CD ; 16B0
    mov ah, 1 ; 16B2
    shl ah, cl ; 16B4
    mov byte ptr cs:[09F7h], cl ; 16B6
    mov byte ptr cs:[09FDh], ah ; 16BB
    push si ; 16C0
    push cx ; 16C1
    mov si, 09F2h ; 16C2
    mov cx, 0Dh ; 16C5
    call near ptr emit_template ; 16C8
    pop cx ; 16CB
    pop si ; 16CC
L16CD:
    mov ax, word ptr [bx + si + 8] ; 16CD
    add ax, word ptr [bp - 016h] ; 16D0
    mov word ptr cs:[0833h], ax ; 16D3
    mov ax, word ptr es:[bx + di + 8] ; 16D7
    add ax, word ptr [bp - 018h] ; 16DB
    mov word ptr cs:[083Bh], ax ; 16DE
    push si ; 16E2
    push cx ; 16E3
    mov si, 0832h ; 16E4
    mov cx, 015h ; 16E7
    call near ptr emit_template ; 16EA
    pop cx ; 16ED
    pop si ; 16EE
    pop cx ; 16EF
    mov ax, word ptr cs:[0140h] ; 16F0
    pop bx ; 16F4
    sub ax, bx ; 16F5
    mov bx, ax ; 16F7
    add ax, 4 ; 16F9
    cmp ax, 07Fh ; 16FC
    jg L1716 ; 16FF
    neg ax ; 1701
    mov byte ptr cs:[09DAh], al ; 1703
    push si ; 1707
    push cx ; 1708
    mov si, 09D7h ; 1709
    mov cx, 4 ; 170C
    call near ptr emit_template ; 170F
    pop cx ; 1712
    pop si ; 1713
    jmp short L172E ; 1714
L1716:
    mov ax, bx ; 1716
    add ax, 7 ; 1718
    neg ax ; 171B
    mov word ptr cs:[09E0h], ax ; 171D
    push si ; 1721
    push cx ; 1722
    mov si, 09DBh ; 1723
    mov cx, 7 ; 1726
    call near ptr emit_template ; 1729
    pop cx ; 172C
    pop si ; 172D
L172E:
    mov word ptr [bp - 4], bx ; 172E
L1731:
    mov al, byte ptr [bp - 010h] ; 1731
    not al ; 1734
    test al, 0FFh ; 1736
    jne L173D ; 1738
    jmp near ptr L17F0 ; 173A
L173D:
    mov byte ptr cs:[0768h], al ; 173D
    mov bl, cl ; 1741
    xor bh, bh ; 1743
    shl bl, 1 ; 1745
    mov ax, word ptr es:[bx + di + 0Ah] ; 1747
    add ax, word ptr [bp - 018h] ; 174B
    mov word ptr cs:[075Eh], ax ; 174E
    push si ; 1752
    push cx ; 1753
    mov si, 075Dh ; 1754
    mov cx, 012h ; 1757
    call near ptr emit_template ; 175A
    pop cx ; 175D
    pop si ; 175E
    xor bx, bx ; 175F
    push cx ; 1761
L1762:
    test byte ptr [bp - 0Eh], 0Ah ; 1762
    je L1783 ; 1766
    mov ah, 1 ; 1768
    shl ah, cl ; 176A
    mov byte ptr cs:[09F7h], cl ; 176C
    mov byte ptr cs:[09FDh], ah ; 1771
    push si ; 1776
    push cx ; 1777
    mov si, 09F2h ; 1778
    mov cx, 0Dh ; 177B
    call near ptr emit_template ; 177E
    pop cx ; 1781
    pop si ; 1782
L1783:
    mov ax, word ptr [bx + si + 8] ; 1783
    add ax, word ptr [bp - 016h] ; 1786
    mov word ptr cs:[0770h], ax ; 1789
    mov ax, word ptr es:[bx + di + 8] ; 178D
    add ax, word ptr [bp - 018h] ; 1791
    mov word ptr cs:[0779h], ax ; 1794
    push si ; 1798
    push cx ; 1799
    mov si, 076Fh ; 179A
    mov cx, 018h ; 179D
    call near ptr emit_template ; 17A0
    pop cx ; 17A3
    pop si ; 17A4
    inc bx ; 17A5
    inc bx ; 17A6
    dec cx ; 17A7
    je L17AC ; 17A8
    jmp short L1762 ; 17AA
L17AC:
    test byte ptr [bp - 0Eh], 0Ah ; 17AC
    je L17CD ; 17B0
    mov ah, 1 ; 17B2
    shl ah, cl ; 17B4
    mov byte ptr cs:[09F7h], cl ; 17B6
    mov byte ptr cs:[09FDh], ah ; 17BB
    push si ; 17C0
    push cx ; 17C1
    mov si, 09F2h ; 17C2
    mov cx, 0Dh ; 17C5
    call near ptr emit_template ; 17C8
    pop cx ; 17CB
    pop si ; 17CC
L17CD:
    mov ax, word ptr [bx + si + 8] ; 17CD
    add ax, word ptr [bp - 016h] ; 17D0
    mov word ptr cs:[0810h], ax ; 17D3
    mov ax, word ptr es:[bx + di + 8] ; 17D7
    add ax, word ptr [bp - 018h] ; 17DB
    mov word ptr cs:[0818h], ax ; 17DE
    push si ; 17E2
    push cx ; 17E3
    mov si, 080Fh ; 17E4
    mov cx, 015h ; 17E7
    call near ptr emit_template ; 17EA
    pop cx ; 17ED
    pop si ; 17EE
    pop cx ; 17EF
L17F0:
    push si ; 17F0
    push cx ; 17F1
    mov si, 09E2h ; 17F2
    mov cx, 1 ; 17F5
    call near ptr emit_template ; 17F8
    pop cx ; 17FB
    pop si ; 17FC
    mov ax, word ptr cs:[0140h] ; 17FD
    pop bx ; 1801
    sub ax, bx ; 1802
    mov word ptr [bp - 2], ax ; 1804
    jmp near ptr L1ADA ; 1807
L180A:
    push word ptr cs:[0140h] ; 180A
    mov ax, 0142h ; 180F
    mov word ptr cs:[0140h], ax ; 1812
    mov cl, byte ptr [bp - 0Dh] ; 1816
    mov al, byte ptr [bp - 0Fh] ; 1819
    not al ; 181C
    test al, 0FFh ; 181E
    jne L1825 ; 1820
    jmp near ptr L18D8 ; 1822
L1825:
    mov byte ptr cs:[0714h], al ; 1825
    mov bl, cl ; 1829
    xor bh, bh ; 182B
    shl bl, 1 ; 182D
    mov ax, word ptr es:[bx + di + 0Ah] ; 182F
    add ax, word ptr [bp - 018h] ; 1833
    mov word ptr cs:[070Ah], ax ; 1836
    push si ; 183A
    push cx ; 183B
    mov si, 0709h ; 183C
    mov cx, 012h ; 183F
    call near ptr emit_template ; 1842
    pop cx ; 1845
    pop si ; 1846
    xor bx, bx ; 1847
    push cx ; 1849
L184A:
    test byte ptr [bp - 0Eh], 0Ah ; 184A
    je L186B ; 184E
    mov ah, 1 ; 1850
    shl ah, cl ; 1852
    mov byte ptr cs:[09F7h], cl ; 1854
    mov byte ptr cs:[09FDh], ah ; 1859
    push si ; 185E
    push cx ; 185F
    mov si, 09F2h ; 1860
    mov cx, 0Dh ; 1863
    call near ptr emit_template ; 1866
    pop cx ; 1869
    pop si ; 186A
L186B:
    mov ax, word ptr [bx + si + 8] ; 186B
    add ax, word ptr [bp - 016h] ; 186E
    mov word ptr cs:[071Ch], ax ; 1871
    mov ax, word ptr es:[bx + di + 8] ; 1875
    add ax, word ptr [bp - 018h] ; 1879
    mov word ptr cs:[0727h], ax ; 187C
    push si ; 1880
    push cx ; 1881
    mov si, 071Bh ; 1882
    mov cx, 01Ah ; 1885
    call near ptr emit_template ; 1888
    pop cx ; 188B
    pop si ; 188C
    inc bx ; 188D
    inc bx ; 188E
    dec cx ; 188F
    je L1894 ; 1890
    jmp short L184A ; 1892
L1894:
    test byte ptr [bp - 0Eh], 0Ah ; 1894
    je L18B5 ; 1898
    mov ah, 1 ; 189A
    shl ah, cl ; 189C
    mov byte ptr cs:[09F7h], cl ; 189E
    mov byte ptr cs:[09FDh], ah ; 18A3
    push si ; 18A8
    push cx ; 18A9
    mov si, 09F2h ; 18AA
    mov cx, 0Dh ; 18AD
    call near ptr emit_template ; 18B0
    pop cx ; 18B3
    pop si ; 18B4
L18B5:
    mov ax, word ptr [bx + si + 8] ; 18B5
    add ax, word ptr [bp - 016h] ; 18B8
    mov word ptr cs:[07C0h], ax ; 18BB
    mov ax, word ptr es:[bx + di + 8] ; 18BF
    add ax, word ptr [bp - 018h] ; 18C3
    mov word ptr cs:[07CBh], ax ; 18C6
    push si ; 18CA
    push cx ; 18CB
    mov si, 07BFh ; 18CC
    mov cx, 018h ; 18CF
    call near ptr emit_template ; 18D2
    pop cx ; 18D5
    pop si ; 18D6
    pop cx ; 18D7
L18D8:
    cmp word ptr [bp - 01Ah], 0 ; 18D8
    jne L18E1 ; 18DC
    jmp near ptr L1A04 ; 18DE
L18E1:
    push word ptr cs:[0140h] ; 18E1
    mov bl, cl ; 18E6
    xor bh, bh ; 18E8
    shl bl, 1 ; 18EA
    mov ax, word ptr es:[bx + di + 0Ah] ; 18EC
    add ax, word ptr [bp - 018h] ; 18F0
    mov word ptr cs:[0736h], ax ; 18F3
    push si ; 18F7
    push cx ; 18F8
    mov si, 0735h ; 18F9
    mov cx, 0Eh ; 18FC
    call near ptr emit_template ; 18FF
    pop cx ; 1902
    pop si ; 1903
    mov ax, 01Ah ; 1904
    xor bx, bx ; 1907
    test byte ptr [bp - 0Eh], 0Ah ; 1909
    je L1912 ; 190D
    mov bx, 0Dh ; 190F
L1912:
    add ax, bx ; 1912
    mul cx ; 1914
    add ax, 018h ; 1916
    add ax, bx ; 1919
    test byte ptr [bp - 0Eh], 5 ; 191B
    je L1932 ; 191F
    mov word ptr cs:[09F0h], ax ; 1921
    push si ; 1925
    push cx ; 1926
    mov si, 09E8h ; 1927
    mov cx, 0Ah ; 192A
    call near ptr emit_template ; 192D
    pop cx ; 1930
    pop si ; 1931
L1932:
    xor bx, bx ; 1932
    push cx ; 1934
L1935:
    test byte ptr [bp - 0Eh], 0Ah ; 1935
    je L1956 ; 1939
    mov ah, 1 ; 193B
    shl ah, cl ; 193D
    mov byte ptr cs:[09F7h], cl ; 193F
    mov byte ptr cs:[09FDh], ah ; 1944
    push si ; 1949
    push cx ; 194A
    mov si, 09F2h ; 194B
    mov cx, 0Dh ; 194E
    call near ptr emit_template ; 1951
    pop cx ; 1954
    pop si ; 1955
L1956:
    mov ax, word ptr [bx + si + 8] ; 1956
    add ax, word ptr [bp - 016h] ; 1959
    mov word ptr cs:[0744h], ax ; 195C
    mov ax, word ptr es:[bx + di + 8] ; 1960
    add ax, word ptr [bp - 018h] ; 1964
    mov word ptr cs:[074Fh], ax ; 1967
    push si ; 196B
    push cx ; 196C
    mov si, 0743h ; 196D
    mov cx, 01Ah ; 1970
    call near ptr emit_template ; 1973
    pop cx ; 1976
    pop si ; 1977
    inc bx ; 1978
    inc bx ; 1979
    dec cx ; 197A
    je L197F ; 197B
    jmp short L1935 ; 197D
L197F:
    test byte ptr [bp - 0Eh], 0Ah ; 197F
    je L19A0 ; 1983
    mov ah, 1 ; 1985
    shl ah, cl ; 1987
    mov byte ptr cs:[09F7h], cl ; 1989
    mov byte ptr cs:[09FDh], ah ; 198E
    push si ; 1993
    push cx ; 1994
    mov si, 09F2h ; 1995
    mov cx, 0Dh ; 1998
    call near ptr emit_template ; 199B
    pop cx ; 199E
    pop si ; 199F
L19A0:
    mov ax, word ptr [bx + si + 8] ; 19A0
    add ax, word ptr [bp - 016h] ; 19A3
    mov word ptr cs:[07E6h], ax ; 19A6
    mov ax, word ptr es:[bx + di + 8] ; 19AA
    add ax, word ptr [bp - 018h] ; 19AE
    mov word ptr cs:[07F1h], ax ; 19B1
    push si ; 19B5
    push cx ; 19B6
    mov si, 07E5h ; 19B7
    mov cx, 018h ; 19BA
    call near ptr emit_template ; 19BD
    pop cx ; 19C0
    pop si ; 19C1
    pop cx ; 19C2
    mov ax, word ptr cs:[0140h] ; 19C3
    pop bx ; 19C7
    sub ax, bx ; 19C8
    mov bx, ax ; 19CA
    add ax, 4 ; 19CC
    cmp ax, 07Fh ; 19CF
    jg L19E9 ; 19D2
    neg ax ; 19D4
    mov byte ptr cs:[09DAh], al ; 19D6
    push si ; 19DA
    push cx ; 19DB
    mov si, 09D7h ; 19DC
    mov cx, 4 ; 19DF
    call near ptr emit_template ; 19E2
    pop cx ; 19E5
    pop si ; 19E6
    jmp short L1A01 ; 19E7
L19E9:
    mov ax, bx ; 19E9
    add ax, 7 ; 19EB
    neg ax ; 19EE
    mov word ptr cs:[09E0h], ax ; 19F0
    push si ; 19F4
    push cx ; 19F5
    mov si, 09DBh ; 19F6
    mov cx, 7 ; 19F9
    call near ptr emit_template ; 19FC
    pop cx ; 19FF
    pop si ; 1A00
L1A01:
    mov word ptr [bp - 4], bx ; 1A01
L1A04:
    mov al, byte ptr [bp - 010h] ; 1A04
    not al ; 1A07
    test al, 0FFh ; 1A09
    jne L1A10 ; 1A0B
    jmp near ptr L1AC3 ; 1A0D
L1A10:
    mov byte ptr cs:[0714h], al ; 1A10
    mov bl, cl ; 1A14
    xor bh, bh ; 1A16
    shl bl, 1 ; 1A18
    mov ax, word ptr es:[bx + di + 0Ah] ; 1A1A
    add ax, word ptr [bp - 018h] ; 1A1E
    mov word ptr cs:[070Ah], ax ; 1A21
    push si ; 1A25
    push cx ; 1A26
    mov si, 0709h ; 1A27
    mov cx, 012h ; 1A2A
    call near ptr emit_template ; 1A2D
    pop cx ; 1A30
    pop si ; 1A31
    xor bx, bx ; 1A32
    push cx ; 1A34
L1A35:
    test byte ptr [bp - 0Eh], 0Ah ; 1A35
    je L1A56 ; 1A39
    mov ah, 1 ; 1A3B
    shl ah, cl ; 1A3D
    mov byte ptr cs:[09F7h], cl ; 1A3F
    mov byte ptr cs:[09FDh], ah ; 1A44
    push si ; 1A49
    push cx ; 1A4A
    mov si, 09F2h ; 1A4B
    mov cx, 0Dh ; 1A4E
    call near ptr emit_template ; 1A51
    pop cx ; 1A54
    pop si ; 1A55
L1A56:
    mov ax, word ptr [bx + si + 8] ; 1A56
    add ax, word ptr [bp - 016h] ; 1A59
    mov word ptr cs:[071Ch], ax ; 1A5C
    mov ax, word ptr es:[bx + di + 8] ; 1A60
    add ax, word ptr [bp - 018h] ; 1A64
    mov word ptr cs:[0727h], ax ; 1A67
    push si ; 1A6B
    push cx ; 1A6C
    mov si, 071Bh ; 1A6D
    mov cx, 01Ah ; 1A70
    call near ptr emit_template ; 1A73
    pop cx ; 1A76
    pop si ; 1A77
    inc bx ; 1A78
    inc bx ; 1A79
    dec cx ; 1A7A
    je L1A7F ; 1A7B
    jmp short L1A35 ; 1A7D
L1A7F:
    test byte ptr [bp - 0Eh], 0Ah ; 1A7F
    je L1AA0 ; 1A83
    mov ah, 1 ; 1A85
    shl ah, cl ; 1A87
    mov byte ptr cs:[09F7h], cl ; 1A89
    mov byte ptr cs:[09FDh], ah ; 1A8E
    push si ; 1A93
    push cx ; 1A94
    mov si, 09F2h ; 1A95
    mov cx, 0Dh ; 1A98
    call near ptr emit_template ; 1A9B
    pop cx ; 1A9E
    pop si ; 1A9F
L1AA0:
    mov ax, word ptr [bx + si + 8] ; 1AA0
    add ax, word ptr [bp - 016h] ; 1AA3
    mov word ptr cs:[07C0h], ax ; 1AA6
    mov ax, word ptr es:[bx + di + 8] ; 1AAA
    add ax, word ptr [bp - 018h] ; 1AAE
    mov word ptr cs:[07CBh], ax ; 1AB1
    push si ; 1AB5
    push cx ; 1AB6
    mov si, 07BFh ; 1AB7
    mov cx, 018h ; 1ABA
    call near ptr emit_template ; 1ABD
    pop cx ; 1AC0
    pop si ; 1AC1
    pop cx ; 1AC2
L1AC3:
    push si ; 1AC3
    push cx ; 1AC4
    mov si, 09E2h ; 1AC5
    mov cx, 1 ; 1AC8
    call near ptr emit_template ; 1ACB
    pop cx ; 1ACE
    pop si ; 1ACF
    mov ax, word ptr cs:[0140h] ; 1AD0
    pop bx ; 1AD4
    sub ax, bx ; 1AD5
    mov word ptr [bp - 2], ax ; 1AD7
L1ADA:
    ret ; 1ADA
L1ADB:
    test byte ptr [bp - 012h], 0FFh ; 1ADB
    je L1AE4 ; 1ADF
    jmp near ptr L1DD5 ; 1AE1
L1AE4:
    push word ptr cs:[0140h] ; 1AE4
    mov ax, 0142h ; 1AE9
    mov word ptr cs:[0140h], ax ; 1AEC
    mov cl, byte ptr [bp - 0Dh] ; 1AF0
    mov al, byte ptr [bp - 0Fh] ; 1AF3
    not al ; 1AF6
    test al, 0FFh ; 1AF8
    jne L1AFF ; 1AFA
    jmp near ptr L1BBC ; 1AFC
L1AFF:
    mov byte ptr cs:[08C5h], al ; 1AFF
    mov bl, cl ; 1B03
    xor bh, bh ; 1B05
    shl bl, 1 ; 1B07
    mov ax, word ptr es:[bx + di + 0Ah] ; 1B09
    add ax, word ptr [bp - 018h] ; 1B0D
    mov word ptr cs:[08B9h], ax ; 1B10
    mov ax, word ptr [bx + si + 0Ah] ; 1B14
    add ax, word ptr [bp - 016h] ; 1B17
    mov word ptr cs:[08B2h], ax ; 1B1A
    push si ; 1B1E
    push cx ; 1B1F
    mov si, 08B1h ; 1B20
    mov cx, 01Bh ; 1B23
    call near ptr emit_template ; 1B26
    pop cx ; 1B29
    pop si ; 1B2A
    xor bx, bx ; 1B2B
    push cx ; 1B2D
L1B2E:
    test byte ptr [bp - 0Eh], 0Ah ; 1B2E
    je L1B4F ; 1B32
    mov ah, 1 ; 1B34
    shl ah, cl ; 1B36
    mov byte ptr cs:[09F7h], cl ; 1B38
    mov byte ptr cs:[09FDh], ah ; 1B3D
    push si ; 1B42
    push cx ; 1B43
    mov si, 09F2h ; 1B44
    mov cx, 0Dh ; 1B47
    call near ptr emit_template ; 1B4A
    pop cx ; 1B4D
    pop si ; 1B4E
L1B4F:
    mov ax, word ptr [bx + si + 8] ; 1B4F
    add ax, word ptr [bp - 016h] ; 1B52
    mov word ptr cs:[08CDh], ax ; 1B55
    mov ax, word ptr es:[bx + di + 8] ; 1B59
    add ax, word ptr [bp - 018h] ; 1B5D
    mov word ptr cs:[08D6h], ax ; 1B60
    push si ; 1B64
    push cx ; 1B65
    mov si, 08CCh ; 1B66
    mov cx, 018h ; 1B69
    call near ptr emit_template ; 1B6C
    pop cx ; 1B6F
    pop si ; 1B70
    inc bx ; 1B71
    inc bx ; 1B72
    dec cx ; 1B73
    je L1B78 ; 1B74
    jmp short L1B2E ; 1B76
L1B78:
    test byte ptr [bp - 0Eh], 0Ah ; 1B78
    je L1B99 ; 1B7C
    mov ah, 1 ; 1B7E
    shl ah, cl ; 1B80
    mov byte ptr cs:[09F7h], cl ; 1B82
    mov byte ptr cs:[09FDh], ah ; 1B87
    push si ; 1B8C
    push cx ; 1B8D
    mov si, 09F2h ; 1B8E
    mov cx, 0Dh ; 1B91
    call near ptr emit_template ; 1B94
    pop cx ; 1B97
    pop si ; 1B98
L1B99:
    mov ax, word ptr [bx + si + 8] ; 1B99
    add ax, word ptr [bp - 016h] ; 1B9C
    mov word ptr cs:[0995h], ax ; 1B9F
    mov ax, word ptr es:[bx + di + 8] ; 1BA3
    add ax, word ptr [bp - 018h] ; 1BA7
    mov word ptr cs:[099Dh], ax ; 1BAA
    push si ; 1BAE
    push cx ; 1BAF
    mov si, 0994h ; 1BB0
    mov cx, 015h ; 1BB3
    call near ptr emit_template ; 1BB6
    pop cx ; 1BB9
    pop si ; 1BBA
    pop cx ; 1BBB
L1BBC:
    cmp word ptr [bp - 01Ah], 0 ; 1BBC
    jne L1BC5 ; 1BC0
    jmp near ptr L1CF2 ; 1BC2
L1BC5:
    push word ptr cs:[0140h] ; 1BC5
    mov bl, cl ; 1BCA
    xor bh, bh ; 1BCC
    shl bl, 1 ; 1BCE
    mov ax, word ptr es:[bx + di + 0Ah] ; 1BD0
    add ax, word ptr [bp - 018h] ; 1BD4
    mov word ptr cs:[08ECh], ax ; 1BD7
    mov ax, word ptr [bx + si + 0Ah] ; 1BDB
    add ax, word ptr [bp - 016h] ; 1BDE
    mov word ptr cs:[08E5h], ax ; 1BE1
    push si ; 1BE5
    push cx ; 1BE6
    mov si, 08E4h ; 1BE7
    mov cx, 017h ; 1BEA
    call near ptr emit_template ; 1BED
    pop cx ; 1BF0
    pop si ; 1BF1
    mov ax, 018h ; 1BF2
    xor bx, bx ; 1BF5
    test byte ptr [bp - 0Eh], 0Ah ; 1BF7
    je L1C00 ; 1BFB
    mov bx, 0Dh ; 1BFD
L1C00:
    add ax, bx ; 1C00
    mul cx ; 1C02
    add ax, 015h ; 1C04
    add ax, bx ; 1C07
    test byte ptr [bp - 0Eh], 5 ; 1C09
    je L1C20 ; 1C0D
    mov word ptr cs:[09F0h], ax ; 1C0F
    push si ; 1C13
    push cx ; 1C14
    mov si, 09E8h ; 1C15
    mov cx, 0Ah ; 1C18
    call near ptr emit_template ; 1C1B
    pop cx ; 1C1E
    pop si ; 1C1F
L1C20:
    xor bx, bx ; 1C20
    push cx ; 1C22
L1C23:
    test byte ptr [bp - 0Eh], 0Ah ; 1C23
    je L1C44 ; 1C27
    mov ah, 1 ; 1C29
    shl ah, cl ; 1C2B
    mov byte ptr cs:[09F7h], cl ; 1C2D
    mov byte ptr cs:[09FDh], ah ; 1C32
    push si ; 1C37
    push cx ; 1C38
    mov si, 09F2h ; 1C39
    mov cx, 0Dh ; 1C3C
    call near ptr emit_template ; 1C3F
    pop cx ; 1C42
    pop si ; 1C43
L1C44:
    mov ax, word ptr [bx + si + 8] ; 1C44
    add ax, word ptr [bp - 016h] ; 1C47
    mov word ptr cs:[08FCh], ax ; 1C4A
    mov ax, word ptr es:[bx + di + 8] ; 1C4E
    add ax, word ptr [bp - 018h] ; 1C52
    mov word ptr cs:[0905h], ax ; 1C55
    push si ; 1C59
    push cx ; 1C5A
    mov si, 08FBh ; 1C5B
    mov cx, 018h ; 1C5E
    call near ptr emit_template ; 1C61
    pop cx ; 1C64
    pop si ; 1C65
    inc bx ; 1C66
    inc bx ; 1C67
    dec cx ; 1C68
    je L1C6D ; 1C69
    jmp short L1C23 ; 1C6B
L1C6D:
    test byte ptr [bp - 0Eh], 0Ah ; 1C6D
    je L1C8E ; 1C71
    mov ah, 1 ; 1C73
    shl ah, cl ; 1C75
    mov byte ptr cs:[09F7h], cl ; 1C77
    mov byte ptr cs:[09FDh], ah ; 1C7C
    push si ; 1C81
    push cx ; 1C82
    mov si, 09F2h ; 1C83
    mov cx, 0Dh ; 1C86
    call near ptr emit_template ; 1C89
    pop cx ; 1C8C
    pop si ; 1C8D
L1C8E:
    mov ax, word ptr [bx + si + 8] ; 1C8E
    add ax, word ptr [bp - 016h] ; 1C91
    mov word ptr cs:[09C1h], ax ; 1C94
    mov ax, word ptr es:[bx + di + 8] ; 1C98
    add ax, word ptr [bp - 018h] ; 1C9C
    mov word ptr cs:[09C9h], ax ; 1C9F
    push si ; 1CA3
    push cx ; 1CA4
    mov si, 09C0h ; 1CA5
    mov cx, 015h ; 1CA8
    call near ptr emit_template ; 1CAB
    pop cx ; 1CAE
    pop si ; 1CAF
    pop cx ; 1CB0
    mov ax, word ptr cs:[0140h] ; 1CB1
    pop bx ; 1CB5
    sub ax, bx ; 1CB6
    mov bx, ax ; 1CB8
    add ax, 4 ; 1CBA
    cmp ax, 07Fh ; 1CBD
    jg L1CD7 ; 1CC0
    neg ax ; 1CC2
    mov byte ptr cs:[09DAh], al ; 1CC4
    push si ; 1CC8
    push cx ; 1CC9
    mov si, 09D7h ; 1CCA
    mov cx, 4 ; 1CCD
    call near ptr emit_template ; 1CD0
    pop cx ; 1CD3
    pop si ; 1CD4
    jmp short L1CEF ; 1CD5
L1CD7:
    mov ax, bx ; 1CD7
    add ax, 7 ; 1CD9
    neg ax ; 1CDC
    mov word ptr cs:[09E0h], ax ; 1CDE
    push si ; 1CE2
    push cx ; 1CE3
    mov si, 09DBh ; 1CE4
    mov cx, 7 ; 1CE7
    call near ptr emit_template ; 1CEA
    pop cx ; 1CED
    pop si ; 1CEE
L1CEF:
    mov word ptr [bp - 4], bx ; 1CEF
L1CF2:
    mov al, byte ptr [bp - 010h] ; 1CF2
    not al ; 1CF5
    test al, 0FFh ; 1CF7
    jne L1CFE ; 1CF9
    jmp near ptr L1DBB ; 1CFB
L1CFE:
    mov byte ptr cs:[08C5h], al ; 1CFE
    mov bl, cl ; 1D02
    xor bh, bh ; 1D04
    shl bl, 1 ; 1D06
    mov ax, word ptr es:[bx + di + 0Ah] ; 1D08
    add ax, word ptr [bp - 018h] ; 1D0C
    mov word ptr cs:[08B9h], ax ; 1D0F
    mov ax, word ptr [bx + si + 0Ah] ; 1D13
    add ax, word ptr [bp - 016h] ; 1D16
    mov word ptr cs:[08B2h], ax ; 1D19
    push si ; 1D1D
    push cx ; 1D1E
    mov si, 08B1h ; 1D1F
    mov cx, 01Bh ; 1D22
    call near ptr emit_template ; 1D25
    pop cx ; 1D28
    pop si ; 1D29
    xor bx, bx ; 1D2A
    push cx ; 1D2C
L1D2D:
    test byte ptr [bp - 0Eh], 0Ah ; 1D2D
    je L1D4E ; 1D31
    mov ah, 1 ; 1D33
    shl ah, cl ; 1D35
    mov byte ptr cs:[09F7h], cl ; 1D37
    mov byte ptr cs:[09FDh], ah ; 1D3C
    push si ; 1D41
    push cx ; 1D42
    mov si, 09F2h ; 1D43
    mov cx, 0Dh ; 1D46
    call near ptr emit_template ; 1D49
    pop cx ; 1D4C
    pop si ; 1D4D
L1D4E:
    mov ax, word ptr [bx + si + 8] ; 1D4E
    add ax, word ptr [bp - 016h] ; 1D51
    mov word ptr cs:[08CDh], ax ; 1D54
    mov ax, word ptr es:[bx + di + 8] ; 1D58
    add ax, word ptr [bp - 018h] ; 1D5C
    mov word ptr cs:[08D6h], ax ; 1D5F
    push si ; 1D63
    push cx ; 1D64
    mov si, 08CCh ; 1D65
    mov cx, 018h ; 1D68
    call near ptr emit_template ; 1D6B
    pop cx ; 1D6E
    pop si ; 1D6F
    inc bx ; 1D70
    inc bx ; 1D71
    dec cx ; 1D72
    je L1D77 ; 1D73
    jmp short L1D2D ; 1D75
L1D77:
    test byte ptr [bp - 0Eh], 0Ah ; 1D77
    je L1D98 ; 1D7B
    mov ah, 1 ; 1D7D
    shl ah, cl ; 1D7F
    mov byte ptr cs:[09F7h], cl ; 1D81
    mov byte ptr cs:[09FDh], ah ; 1D86
    push si ; 1D8B
    push cx ; 1D8C
    mov si, 09F2h ; 1D8D
    mov cx, 0Dh ; 1D90
    call near ptr emit_template ; 1D93
    pop cx ; 1D96
    pop si ; 1D97
L1D98:
    mov ax, word ptr [bx + si + 8] ; 1D98
    add ax, word ptr [bp - 016h] ; 1D9B
    mov word ptr cs:[0995h], ax ; 1D9E
    mov ax, word ptr es:[bx + di + 8] ; 1DA2
    add ax, word ptr [bp - 018h] ; 1DA6
    mov word ptr cs:[099Dh], ax ; 1DA9
    push si ; 1DAD
    push cx ; 1DAE
    mov si, 0994h ; 1DAF
    mov cx, 015h ; 1DB2
    call near ptr emit_template ; 1DB5
    pop cx ; 1DB8
    pop si ; 1DB9
    pop cx ; 1DBA
L1DBB:
    push si ; 1DBB
    push cx ; 1DBC
    mov si, 09E2h ; 1DBD
    mov cx, 1 ; 1DC0
    call near ptr emit_template ; 1DC3
    pop cx ; 1DC6
    pop si ; 1DC7
    mov ax, word ptr cs:[0140h] ; 1DC8
    pop bx ; 1DCC
    sub ax, bx ; 1DCD
    mov word ptr [bp - 2], ax ; 1DCF
    jmp near ptr L20C3 ; 1DD2
L1DD5:
    push word ptr cs:[0140h] ; 1DD5
    mov ax, 0142h ; 1DDA
    mov word ptr cs:[0140h], ax ; 1DDD
    mov cl, byte ptr [bp - 0Dh] ; 1DE1
    mov al, byte ptr [bp - 0Fh] ; 1DE4
    not al ; 1DE7
    test al, 0FFh ; 1DE9
    jne L1DF0 ; 1DEB
    jmp near ptr L1EAD ; 1DED
L1DF0:
    mov byte ptr cs:[085Dh], al ; 1DF0
    mov bl, cl ; 1DF4
    xor bh, bh ; 1DF6
    shl bl, 1 ; 1DF8
    mov ax, word ptr es:[bx + di + 0Ah] ; 1DFA
    add ax, word ptr [bp - 018h] ; 1DFE
    mov word ptr cs:[0851h], ax ; 1E01
    mov ax, word ptr [bx + si + 0Ah] ; 1E05
    add ax, word ptr [bp - 016h] ; 1E08
    mov word ptr cs:[0848h], ax ; 1E0B
    push si ; 1E0F
    push cx ; 1E10
    mov si, 0847h ; 1E11
    mov cx, 01Dh ; 1E14
    call near ptr emit_template ; 1E17
    pop cx ; 1E1A
    pop si ; 1E1B
    xor bx, bx ; 1E1C
    push cx ; 1E1E
L1E1F:
    test byte ptr [bp - 0Eh], 0Ah ; 1E1F
    je L1E40 ; 1E23
    mov ah, 1 ; 1E25
    shl ah, cl ; 1E27
    mov byte ptr cs:[09F7h], cl ; 1E29
    mov byte ptr cs:[09FDh], ah ; 1E2E
    push si ; 1E33
    push cx ; 1E34
    mov si, 09F2h ; 1E35
    mov cx, 0Dh ; 1E38
    call near ptr emit_template ; 1E3B
    pop cx ; 1E3E
    pop si ; 1E3F
L1E40:
    mov ax, word ptr [bx + si + 8] ; 1E40
    add ax, word ptr [bp - 016h] ; 1E43
    mov word ptr cs:[0865h], ax ; 1E46
    mov ax, word ptr es:[bx + di + 8] ; 1E4A
    add ax, word ptr [bp - 018h] ; 1E4E
    mov word ptr cs:[0870h], ax ; 1E51
    push si ; 1E55
    push cx ; 1E56
    mov si, 0864h ; 1E57
    mov cx, 01Ah ; 1E5A
    call near ptr emit_template ; 1E5D
    pop cx ; 1E60
    pop si ; 1E61
    inc bx ; 1E62
    inc bx ; 1E63
    dec cx ; 1E64
    je L1E69 ; 1E65
    jmp short L1E1F ; 1E67
L1E69:
    test byte ptr [bp - 0Eh], 0Ah ; 1E69
    je L1E8A ; 1E6D
    mov ah, 1 ; 1E6F
    shl ah, cl ; 1E71
    mov byte ptr cs:[09F7h], cl ; 1E73
    mov byte ptr cs:[09FDh], ah ; 1E78
    push si ; 1E7D
    push cx ; 1E7E
    mov si, 09F2h ; 1E7F
    mov cx, 0Dh ; 1E82
    call near ptr emit_template ; 1E85
    pop cx ; 1E88
    pop si ; 1E89
L1E8A:
    mov ax, word ptr [bx + si + 8] ; 1E8A
    add ax, word ptr [bp - 016h] ; 1E8D
    mov word ptr cs:[0931h], ax ; 1E90
    mov ax, word ptr es:[bx + di + 8] ; 1E94
    add ax, word ptr [bp - 018h] ; 1E98
    mov word ptr cs:[093Ch], ax ; 1E9B
    push si ; 1E9F
    push cx ; 1EA0
    mov si, 0930h ; 1EA1
    mov cx, 018h ; 1EA4
    call near ptr emit_template ; 1EA7
    pop cx ; 1EAA
    pop si ; 1EAB
    pop cx ; 1EAC
L1EAD:
    cmp word ptr [bp - 01Ah], 0 ; 1EAD
    jne L1EB6 ; 1EB1
    jmp near ptr L1FE3 ; 1EB3
L1EB6:
    push word ptr cs:[0140h] ; 1EB6
    mov bl, cl ; 1EBB
    xor bh, bh ; 1EBD
    shl bl, 1 ; 1EBF
    mov ax, word ptr es:[bx + di + 0Ah] ; 1EC1
    add ax, word ptr [bp - 018h] ; 1EC5
    mov word ptr cs:[0888h], ax ; 1EC8
    mov ax, word ptr [bx + si + 0Ah] ; 1ECC
    add ax, word ptr [bp - 016h] ; 1ECF
    mov word ptr cs:[087Fh], ax ; 1ED2
    push si ; 1ED6
    push cx ; 1ED7
    mov si, 087Eh ; 1ED8
    mov cx, 019h ; 1EDB
    call near ptr emit_template ; 1EDE
    pop cx ; 1EE1
    pop si ; 1EE2
    mov ax, 01Ah ; 1EE3
    xor bx, bx ; 1EE6
    test byte ptr [bp - 0Eh], 0Ah ; 1EE8
    je L1EF1 ; 1EEC
    mov bx, 0Dh ; 1EEE
L1EF1:
    add ax, bx ; 1EF1
    mul cx ; 1EF3
    add ax, 018h ; 1EF5
    add ax, bx ; 1EF8
    test byte ptr [bp - 0Eh], 5 ; 1EFA
    je L1F11 ; 1EFE
    mov word ptr cs:[09F0h], ax ; 1F00
    push si ; 1F04
    push cx ; 1F05
    mov si, 09E8h ; 1F06
    mov cx, 0Ah ; 1F09
    call near ptr emit_template ; 1F0C
    pop cx ; 1F0F
    pop si ; 1F10
L1F11:
    xor bx, bx ; 1F11
    push cx ; 1F13
L1F14:
    test byte ptr [bp - 0Eh], 0Ah ; 1F14
    je L1F35 ; 1F18
    mov ah, 1 ; 1F1A
    shl ah, cl ; 1F1C
    mov byte ptr cs:[09F7h], cl ; 1F1E
    mov byte ptr cs:[09FDh], ah ; 1F23
    push si ; 1F28
    push cx ; 1F29
    mov si, 09F2h ; 1F2A
    mov cx, 0Dh ; 1F2D
    call near ptr emit_template ; 1F30
    pop cx ; 1F33
    pop si ; 1F34
L1F35:
    mov ax, word ptr [bx + si + 8] ; 1F35
    add ax, word ptr [bp - 016h] ; 1F38
    mov word ptr cs:[0898h], ax ; 1F3B
    mov ax, word ptr es:[bx + di + 8] ; 1F3F
    add ax, word ptr [bp - 018h] ; 1F43
    mov word ptr cs:[08A3h], ax ; 1F46
    push si ; 1F4A
    push cx ; 1F4B
    mov si, 0897h ; 1F4C
    mov cx, 01Ah ; 1F4F
    call near ptr emit_template ; 1F52
    pop cx ; 1F55
    pop si ; 1F56
    inc bx ; 1F57
    inc bx ; 1F58
    dec cx ; 1F59
    je L1F5E ; 1F5A
    jmp short L1F14 ; 1F5C
L1F5E:
    test byte ptr [bp - 0Eh], 0Ah ; 1F5E
    je L1F7F ; 1F62
    mov ah, 1 ; 1F64
    shl ah, cl ; 1F66
    mov byte ptr cs:[09F7h], cl ; 1F68
    mov byte ptr cs:[09FDh], ah ; 1F6D
    push si ; 1F72
    push cx ; 1F73
    mov si, 09F2h ; 1F74
    mov cx, 0Dh ; 1F77
    call near ptr emit_template ; 1F7A
    pop cx ; 1F7D
    pop si ; 1F7E
L1F7F:
    mov ax, word ptr [bx + si + 8] ; 1F7F
    add ax, word ptr [bp - 016h] ; 1F82
    mov word ptr cs:[0962h], ax ; 1F85
    mov ax, word ptr es:[bx + di + 8] ; 1F89
    add ax, word ptr [bp - 018h] ; 1F8D
    mov word ptr cs:[096Dh], ax ; 1F90
    push si ; 1F94
    push cx ; 1F95
    mov si, 0961h ; 1F96
    mov cx, 018h ; 1F99
    call near ptr emit_template ; 1F9C
    pop cx ; 1F9F
    pop si ; 1FA0
    pop cx ; 1FA1
    mov ax, word ptr cs:[0140h] ; 1FA2
    pop bx ; 1FA6
    sub ax, bx ; 1FA7
    mov bx, ax ; 1FA9
    add ax, 4 ; 1FAB
    cmp ax, 07Fh ; 1FAE
    jg L1FC8 ; 1FB1
    neg ax ; 1FB3
    mov byte ptr cs:[09DAh], al ; 1FB5
    push si ; 1FB9
    push cx ; 1FBA
    mov si, 09D7h ; 1FBB
    mov cx, 4 ; 1FBE
    call near ptr emit_template ; 1FC1
    pop cx ; 1FC4
    pop si ; 1FC5
    jmp short L1FE0 ; 1FC6
L1FC8:
    mov ax, bx ; 1FC8
    add ax, 7 ; 1FCA
    neg ax ; 1FCD
    mov word ptr cs:[09E0h], ax ; 1FCF
    push si ; 1FD3
    push cx ; 1FD4
    mov si, 09DBh ; 1FD5
    mov cx, 7 ; 1FD8
    call near ptr emit_template ; 1FDB
    pop cx ; 1FDE
    pop si ; 1FDF
L1FE0:
    mov word ptr [bp - 4], bx ; 1FE0
L1FE3:
    mov al, byte ptr [bp - 010h] ; 1FE3
    not al ; 1FE6
    test al, 0FFh ; 1FE8
    jne L1FEF ; 1FEA
    jmp near ptr L20AC ; 1FEC
L1FEF:
    mov byte ptr cs:[085Dh], al ; 1FEF
    mov bl, cl ; 1FF3
    xor bh, bh ; 1FF5
    shl bl, 1 ; 1FF7
    mov ax, word ptr es:[bx + di + 0Ah] ; 1FF9
    add ax, word ptr [bp - 018h] ; 1FFD
    mov word ptr cs:[0851h], ax ; 2000
    mov ax, word ptr [bx + si + 0Ah] ; 2004
    add ax, word ptr [bp - 016h] ; 2007
    mov word ptr cs:[0848h], ax ; 200A
    push si ; 200E
    push cx ; 200F
    mov si, 0847h ; 2010
    mov cx, 01Dh ; 2013
    call near ptr emit_template ; 2016
    pop cx ; 2019
    pop si ; 201A
    xor bx, bx ; 201B
    push cx ; 201D
L201E:
    test byte ptr [bp - 0Eh], 0Ah ; 201E
    je L203F ; 2022
    mov ah, 1 ; 2024
    shl ah, cl ; 2026
    mov byte ptr cs:[09F7h], cl ; 2028
    mov byte ptr cs:[09FDh], ah ; 202D
    push si ; 2032
    push cx ; 2033
    mov si, 09F2h ; 2034
    mov cx, 0Dh ; 2037
    call near ptr emit_template ; 203A
    pop cx ; 203D
    pop si ; 203E
L203F:
    mov ax, word ptr [bx + si + 8] ; 203F
    add ax, word ptr [bp - 016h] ; 2042
    mov word ptr cs:[0865h], ax ; 2045
    mov ax, word ptr es:[bx + di + 8] ; 2049
    add ax, word ptr [bp - 018h] ; 204D
    mov word ptr cs:[0870h], ax ; 2050
    push si ; 2054
    push cx ; 2055
    mov si, 0864h ; 2056
    mov cx, 01Ah ; 2059
    call near ptr emit_template ; 205C
    pop cx ; 205F
    pop si ; 2060
    inc bx ; 2061
    inc bx ; 2062
    dec cx ; 2063
    je L2068 ; 2064
    jmp short L201E ; 2066
L2068:
    test byte ptr [bp - 0Eh], 0Ah ; 2068
    je L2089 ; 206C
    mov ah, 1 ; 206E
    shl ah, cl ; 2070
    mov byte ptr cs:[09F7h], cl ; 2072
    mov byte ptr cs:[09FDh], ah ; 2077
    push si ; 207C
    push cx ; 207D
    mov si, 09F2h ; 207E
    mov cx, 0Dh ; 2081
    call near ptr emit_template ; 2084
    pop cx ; 2087
    pop si ; 2088
L2089:
    mov ax, word ptr [bx + si + 8] ; 2089
    add ax, word ptr [bp - 016h] ; 208C
    mov word ptr cs:[0931h], ax ; 208F
    mov ax, word ptr es:[bx + di + 8] ; 2093
    add ax, word ptr [bp - 018h] ; 2097
    mov word ptr cs:[093Ch], ax ; 209A
    push si ; 209E
    push cx ; 209F
    mov si, 0930h ; 20A0
    mov cx, 018h ; 20A3
    call near ptr emit_template ; 20A6
    pop cx ; 20A9
    pop si ; 20AA
    pop cx ; 20AB
L20AC:
    push si ; 20AC
    push cx ; 20AD
    mov si, 09E2h ; 20AE
    mov cx, 1 ; 20B1
    call near ptr emit_template ; 20B4
    pop cx ; 20B7
    pop si ; 20B8
    mov ax, word ptr cs:[0140h] ; 20B9
    pop bx ; 20BD
    sub ax, bx ; 20BE
    mov word ptr [bp - 2], ax ; 20C0
L20C3:
    ret ; 20C3
draw_generator_table:
    dw L0A1C-driver_header, L0F87-driver_header, L152E-driver_header, L1ADB-driver_header
L20CC:
    mov bh, byte ptr [bp - 0Eh] ; 20CC
    mov cl, 4 ; 20CF
    shl bh, cl ; 20D1
    xor bl, bl ; 20D3
    shl bh, 1 ; 20D5
    rol bx, 1 ; 20D7
    shl bh, 1 ; 20D9
    rol bx, 1 ; 20DB
    shl bl, 1 ; 20DD
    xor bh, bh ; 20DF
    call word ptr cs:[bx + 020C4h] ; 20E1
    mov cx, word ptr [bp - 01Ah] ; 20E6
    mov ch, cl ; 20E9
    mov cl, byte ptr [bp - 012h] ; 20EB
    mov bx, word ptr [bp - 8] ; 20EE
    xor ah, ah ; 20F1
    mov al, byte ptr [bp - 013h] ; 20F3
    mov si, ax ; 20F6
    mov al, byte ptr [bp - 014h] ; 20F8
    mov di, ax ; 20FB
L20FD:
    push bx ; 20FD
    push si ; 20FE
    push di ; 20FF
    push cx ; 2100
    call near ptr generated_program ; 2101
    pop cx ; 2104
    pop di ; 2105
    pop si ; 2106
    add si, word ptr [bp - 01Ch] ; 2107
    add di, word ptr [bp - 01Eh] ; 210A
    pop bx ; 210D
    dec bx ; 210E
    jne L20FD ; 210F
    ret ; 2111
L2112:
    mov bx, 0 ; 2112
    lodsw ; 2115
    dec si ; 2116
    rol ax, cl ; 2117
    and al, bl ; 2119
    and bh, byte ptr es:[di] ; 211B
    or al, bh ; 211E
    stosb ; 2120
L2121:
    mov bx, 0 ; 2121
    lodsb ; 2124
    and al, bl ; 2125
    and bh, byte ptr es:[di] ; 2127
    or al, bh ; 212A
    stosb ; 212C
L212D:
    lodsw ; 212D
    dec si ; 212E
    rol ax, cl ; 212F
    stosb ; 2131
L2132:
    mov cx, 0 ; 2132
    rep movsw ; 2135
L2137:
    movsb ; 2137
L2138:
    dec dx ; 2138
L2139:
    jne L2139 ; 2139
L213B:
    mov dx, 0 ; 213B
L213E:
    ret ; 213E
L213F:
    mov ax, 0142h ; 213F
    mov word ptr cs:[0140h], ax ; 2142
    test byte ptr [bp - 012h], 0FFh ; 2146
    je L214F ; 214A
    jmp short L21BD ; 214C
    nop ; 214E
L214F:
    mov bl, byte ptr [bp - 0Fh] ; 214F
    cmp bl, 0FFh ; 2152
    je L216D ; 2155
    mov bh, bl ; 2157
    not bh ; 2159
    mov word ptr cs:[02122h], bx ; 215B
    push si ; 2160
    push cx ; 2161
    mov si, 02121h ; 2162
    mov cx, 0Ch ; 2165
    call near ptr emit_template ; 2168
    pop cx ; 216B
    pop si ; 216C
L216D:
    mov ax, word ptr [bp - 01Ah] ; 216D
    test ax, 0FFFFh ; 2170
    je L219C ; 2173
    shr ax, 1 ; 2175
    jae L2186 ; 2177
    push si ; 2179
    push cx ; 217A
    mov si, 02137h ; 217B
    mov cx, 1 ; 217E
    call near ptr emit_template ; 2181
    pop cx ; 2184
    pop si ; 2185
L2186:
    test ax, 0FFFFh ; 2186
    je L219C ; 2189
    mov word ptr cs:[02133h], ax ; 218B
    push si ; 218F
    push cx ; 2190
    mov si, 02132h ; 2191
    mov cx, 5 ; 2194
    call near ptr emit_template ; 2197
    pop cx ; 219A
    pop si ; 219B
L219C:
    mov bl, byte ptr [bp - 010h] ; 219C
    cmp bl, 0FFh ; 219F
    je L21BA ; 21A2
    mov bh, bl ; 21A4
    not bh ; 21A6
    mov word ptr cs:[02122h], bx ; 21A8
    push si ; 21AD
    push cx ; 21AE
    mov si, 02121h ; 21AF
    mov cx, 0Ch ; 21B2
    call near ptr emit_template ; 21B5
    pop cx ; 21B8
    pop si ; 21B9
L21BA:
    jmp near ptr L2261 ; 21BA
L21BD:
    mov bl, byte ptr [bp - 0Fh] ; 21BD
    cmp bl, 0FFh ; 21C0
    je L21DB ; 21C3
    mov bh, bl ; 21C5
    not bh ; 21C7
    mov word ptr cs:[02113h], bx ; 21C9
    push si ; 21CE
    push cx ; 21CF
    mov si, 02112h ; 21D0
    mov cx, 0Fh ; 21D3
    call near ptr emit_template ; 21D6
    pop cx ; 21D9
    pop si ; 21DA
L21DB:
    mov ax, word ptr [bp - 01Ah] ; 21DB
    test ax, 0FFFFh ; 21DE
    je L2243 ; 21E1
    mov cx, 018h ; 21E3
    xor dx, dx ; 21E6
    div cx ; 21E8
    test ax, 0FFFFh ; 21EA
    je L2230 ; 21ED
    mov word ptr cs:[0213Ch], ax ; 21EF
    push si ; 21F3
    push cx ; 21F4
    mov si, 0213Bh ; 21F5
    mov cx, 3 ; 21F8
    call near ptr emit_template ; 21FB
    pop cx ; 21FE
    pop si ; 21FF
    push word ptr cs:[0140h] ; 2200
L2205:
    push si ; 2205
    push cx ; 2206
    mov si, 0212Dh ; 2207
    mov cx, 5 ; 220A
    call near ptr emit_template ; 220D
    pop cx ; 2210
    pop si ; 2211
    loop L2205 ; 2212
    mov bx, word ptr cs:[0140h] ; 2214
    add bx, 3 ; 2219
    pop ax ; 221C
    sub ax, bx ; 221D
    mov byte ptr cs:[0213Ah], al ; 221F
    push si ; 2223
    push cx ; 2224
    mov si, 02138h ; 2225
    mov cx, 3 ; 2228
    call near ptr emit_template ; 222B
    pop cx ; 222E
    pop si ; 222F
L2230:
    mov cx, dx ; 2230
    jcxz L2243 ; 2232
L2234:
    push si ; 2234
    push cx ; 2235
    mov si, 0212Dh ; 2236
    mov cx, 5 ; 2239
    call near ptr emit_template ; 223C
    pop cx ; 223F
    pop si ; 2240
    loop L2234 ; 2241
L2243:
    mov bl, byte ptr [bp - 010h] ; 2243
    cmp bl, 0FFh ; 2246
    je L2261 ; 2249
    mov bh, bl ; 224B
    not bh ; 224D
    mov word ptr cs:[02113h], bx ; 224F
    push si ; 2254
    push cx ; 2255
    mov si, 02112h ; 2256
    mov cx, 0Fh ; 2259
    call near ptr emit_template ; 225C
    pop cx ; 225F
    pop si ; 2260
L2261:
    push si ; 2261
    push cx ; 2262
    mov si, 0213Eh ; 2263
    mov cx, 1 ; 2266
    call near ptr emit_template ; 2269
    pop cx ; 226C
    pop si ; 226D
L226E:
    call near ptr L04C0 ; 226E
    mov cl, byte ptr [bp - 012h] ; 2271
    mov bx, word ptr [bp - 8] ; 2274
L2277:
    push bx ; 2277
    push si ; 2278
    push di ; 2279
    call near ptr generated_program ; 227A
    pop di ; 227D
    pop si ; 227E
    add si, word ptr [bp - 01Ch] ; 227F
    add di, word ptr [bp - 01Eh] ; 2282
    pop bx ; 2285
    dec bx ; 2286
    jne L2277 ; 2287
    dec byte ptr [bp - 0Dh] ; 2289
    jns L226E ; 228C
    ret ; 228E
L228F:
    lodsw ; 228F
    dec si ; 2290
    rol ax, cl ; 2291
    or al, 0 ; 2293
    mov ah, byte ptr es:[di] ; 2295
    stosb ; 2298
L2299:
    lodsb ; 2299
    or al, 0 ; 229A
    mov ah, byte ptr es:[di] ; 229C
    stosb ; 229F
L22A0:
    lodsw ; 22A0
    dec si ; 22A1
    rol ax, cl ; 22A2
    and al, 0 ; 22A4
    mov ah, byte ptr es:[di] ; 22A6
    stosb ; 22A9
L22AA:
    lodsb ; 22AA
    and al, 0 ; 22AB
    mov ah, byte ptr es:[di] ; 22AD
    stosb ; 22B0
L22B1:
    lodsw ; 22B1
    dec si ; 22B2
    rol ax, cl ; 22B3
    mov ah, byte ptr es:[di] ; 22B5
    stosb ; 22B8
L22B9:
    lodsb ; 22B9
    mov ah, byte ptr es:[di] ; 22BA
    stosb ; 22BD
L22BE:
    mov ax, 0142h ; 22BE
    mov word ptr cs:[0140h], ax ; 22C1
    test byte ptr [bp - 012h], 0FFh ; 22C5
    je L22CE ; 22C9
    jmp near ptr L2371 ; 22CB
L22CE:
    mov bl, byte ptr [bp - 0Fh] ; 22CE
    cmp bl, 0FFh ; 22D1
    je L22EA ; 22D4
    not bl ; 22D6
    mov byte ptr cs:[0229Bh], bl ; 22D8
    push si ; 22DD
    push cx ; 22DE
    mov si, 02299h ; 22DF
    mov cx, 7 ; 22E2
    call near ptr emit_template ; 22E5
    pop cx ; 22E8
    pop si ; 22E9
L22EA:
    mov ax, word ptr [bp - 01Ah] ; 22EA
    test ax, 0FFFFh ; 22ED
    je L2352 ; 22F0
    mov cx, 018h ; 22F2
    xor dx, dx ; 22F5
    div cx ; 22F7
    test ax, 0FFFFh ; 22F9
    je L233F ; 22FC
    mov word ptr cs:[0213Ch], ax ; 22FE
    push si ; 2302
    push cx ; 2303
    mov si, 0213Bh ; 2304
    mov cx, 3 ; 2307
    call near ptr emit_template ; 230A
    pop cx ; 230D
    pop si ; 230E
    push word ptr cs:[0140h] ; 230F
L2314:
    push si ; 2314
    push cx ; 2315
    mov si, 022B9h ; 2316
    mov cx, 5 ; 2319
    call near ptr emit_template ; 231C
    pop cx ; 231F
    pop si ; 2320
    loop L2314 ; 2321
    mov bx, word ptr cs:[0140h] ; 2323
    add bx, 3 ; 2328
    pop ax ; 232B
    sub ax, bx ; 232C
    mov byte ptr cs:[0213Ah], al ; 232E
    push si ; 2332
    push cx ; 2333
    mov si, 02138h ; 2334
    mov cx, 3 ; 2337
    call near ptr emit_template ; 233A
    pop cx ; 233D
    pop si ; 233E
L233F:
    mov cx, dx ; 233F
    jcxz L2352 ; 2341
L2343:
    push si ; 2343
    push cx ; 2344
    mov si, 022B9h ; 2345
    mov cx, 5 ; 2348
    call near ptr emit_template ; 234B
    pop cx ; 234E
    pop si ; 234F
    loop L2343 ; 2350
L2352:
    mov bl, byte ptr [bp - 010h] ; 2352
    cmp bl, 0FFh ; 2355
    je L236E ; 2358
    not bl ; 235A
    mov byte ptr cs:[0229Bh], bl ; 235C
    push si ; 2361
    push cx ; 2362
    mov si, 02299h ; 2363
    mov cx, 7 ; 2366
    call near ptr emit_template ; 2369
    pop cx ; 236C
    pop si ; 236D
L236E:
    jmp near ptr L2411 ; 236E
L2371:
    mov bl, byte ptr [bp - 0Fh] ; 2371
    cmp bl, 0FFh ; 2374
    je L238D ; 2377
    not bl ; 2379
    mov byte ptr cs:[02294h], bl ; 237B
    push si ; 2380
    push cx ; 2381
    mov si, 0228Fh ; 2382
    mov cx, 0Ah ; 2385
    call near ptr emit_template ; 2388
    pop cx ; 238B
    pop si ; 238C
L238D:
    mov ax, word ptr [bp - 01Ah] ; 238D
    test ax, 0FFFFh ; 2390
    je L23F5 ; 2393
    mov cx, 0Fh ; 2395
    xor dx, dx ; 2398
    div cx ; 239A
    test ax, 0FFFFh ; 239C
    je L23E2 ; 239F
    mov word ptr cs:[0213Ch], ax ; 23A1
    push si ; 23A5
    push cx ; 23A6
    mov si, 0213Bh ; 23A7
    mov cx, 3 ; 23AA
    call near ptr emit_template ; 23AD
    pop cx ; 23B0
    pop si ; 23B1
    push word ptr cs:[0140h] ; 23B2
L23B7:
    push si ; 23B7
    push cx ; 23B8
    mov si, 022B1h ; 23B9
    mov cx, 8 ; 23BC
    call near ptr emit_template ; 23BF
    pop cx ; 23C2
    pop si ; 23C3
    loop L23B7 ; 23C4
    mov bx, word ptr cs:[0140h] ; 23C6
    add bx, 3 ; 23CB
    pop ax ; 23CE
    sub ax, bx ; 23CF
    mov byte ptr cs:[0213Ah], al ; 23D1
    push si ; 23D5
    push cx ; 23D6
    mov si, 02138h ; 23D7
    mov cx, 3 ; 23DA
    call near ptr emit_template ; 23DD
    pop cx ; 23E0
    pop si ; 23E1
L23E2:
    mov cx, dx ; 23E2
    jcxz L23F5 ; 23E4
L23E6:
    push si ; 23E6
    push cx ; 23E7
    mov si, 022B1h ; 23E8
    mov cx, 8 ; 23EB
    call near ptr emit_template ; 23EE
    pop cx ; 23F1
    pop si ; 23F2
    loop L23E6 ; 23F3
L23F5:
    mov bl, byte ptr [bp - 010h] ; 23F5
    cmp bl, 0FFh ; 23F8
    je L2411 ; 23FB
    not bl ; 23FD
    mov byte ptr cs:[02294h], bl ; 23FF
    push si ; 2404
    push cx ; 2405
    mov si, 0228Fh ; 2406
    mov cx, 0Ah ; 2409
    call near ptr emit_template ; 240C
    pop cx ; 240F
    pop si ; 2410
L2411:
    push si ; 2411
    push cx ; 2412
    mov si, 0213Eh ; 2413
    mov cx, 1 ; 2416
    call near ptr emit_template ; 2419
    pop cx ; 241C
    pop si ; 241D
    ret ; 241E
L241F:
    mov ax, 0142h ; 241F
    mov word ptr cs:[0140h], ax ; 2422
    test byte ptr [bp - 012h], 0FFh ; 2426
    je L242F ; 242A
    jmp near ptr L24CE ; 242C
L242F:
    mov bl, byte ptr [bp - 0Fh] ; 242F
    cmp bl, 0FFh ; 2432
    je L2449 ; 2435
    mov byte ptr cs:[022ACh], bl ; 2437
    push si ; 243C
    push cx ; 243D
    mov si, 022AAh ; 243E
    mov cx, 7 ; 2441
    call near ptr emit_template ; 2444
    pop cx ; 2447
    pop si ; 2448
L2449:
    mov ax, word ptr [bp - 01Ah] ; 2449
    test ax, 0FFFFh ; 244C
    je L24B1 ; 244F
    mov cx, 018h ; 2451
    xor dx, dx ; 2454
    div cx ; 2456
    test ax, 0FFFFh ; 2458
    je L249E ; 245B
    mov word ptr cs:[0213Ch], ax ; 245D
    push si ; 2461
    push cx ; 2462
    mov si, 0213Bh ; 2463
    mov cx, 3 ; 2466
    call near ptr emit_template ; 2469
    pop cx ; 246C
    pop si ; 246D
    push word ptr cs:[0140h] ; 246E
L2473:
    push si ; 2473
    push cx ; 2474
    mov si, 022B9h ; 2475
    mov cx, 5 ; 2478
    call near ptr emit_template ; 247B
    pop cx ; 247E
    pop si ; 247F
    loop L2473 ; 2480
    mov bx, word ptr cs:[0140h] ; 2482
    add bx, 3 ; 2487
    pop ax ; 248A
    sub ax, bx ; 248B
    mov byte ptr cs:[0213Ah], al ; 248D
    push si ; 2491
    push cx ; 2492
    mov si, 02138h ; 2493
    mov cx, 3 ; 2496
    call near ptr emit_template ; 2499
    pop cx ; 249C
    pop si ; 249D
L249E:
    mov cx, dx ; 249E
    jcxz L24B1 ; 24A0
L24A2:
    push si ; 24A2
    push cx ; 24A3
    mov si, 022B9h ; 24A4
    mov cx, 5 ; 24A7
    call near ptr emit_template ; 24AA
    pop cx ; 24AD
    pop si ; 24AE
    loop L24A2 ; 24AF
L24B1:
    mov bl, byte ptr [bp - 010h] ; 24B1
    cmp bl, 0FFh ; 24B4
    je L24CB ; 24B7
    mov byte ptr cs:[022ACh], bl ; 24B9
    push si ; 24BE
    push cx ; 24BF
    mov si, 022AAh ; 24C0
    mov cx, 7 ; 24C3
    call near ptr emit_template ; 24C6
    pop cx ; 24C9
    pop si ; 24CA
L24CB:
    jmp near ptr L256A ; 24CB
L24CE:
    mov bl, byte ptr [bp - 0Fh] ; 24CE
    cmp bl, 0FFh ; 24D1
    je L24E8 ; 24D4
    mov byte ptr cs:[022A5h], bl ; 24D6
    push si ; 24DB
    push cx ; 24DC
    mov si, 022A0h ; 24DD
    mov cx, 0Ah ; 24E0
    call near ptr emit_template ; 24E3
    pop cx ; 24E6
    pop si ; 24E7
L24E8:
    mov ax, word ptr [bp - 01Ah] ; 24E8
    test ax, 0FFFFh ; 24EB
    je L2550 ; 24EE
    mov cx, 0Fh ; 24F0
    xor dx, dx ; 24F3
    div cx ; 24F5
    test ax, 0FFFFh ; 24F7
    je L253D ; 24FA
    mov word ptr cs:[0213Ch], ax ; 24FC
    push si ; 2500
    push cx ; 2501
    mov si, 0213Bh ; 2502
    mov cx, 3 ; 2505
    call near ptr emit_template ; 2508
    pop cx ; 250B
    pop si ; 250C
    push word ptr cs:[0140h] ; 250D
L2512:
    push si ; 2512
    push cx ; 2513
    mov si, 022B1h ; 2514
    mov cx, 8 ; 2517
    call near ptr emit_template ; 251A
    pop cx ; 251D
    pop si ; 251E
    loop L2512 ; 251F
    mov bx, word ptr cs:[0140h] ; 2521
    add bx, 3 ; 2526
    pop ax ; 2529
    sub ax, bx ; 252A
    mov byte ptr cs:[0213Ah], al ; 252C
    push si ; 2530
    push cx ; 2531
    mov si, 02138h ; 2532
    mov cx, 3 ; 2535
    call near ptr emit_template ; 2538
    pop cx ; 253B
    pop si ; 253C
L253D:
    mov cx, dx ; 253D
    jcxz L2550 ; 253F
L2541:
    push si ; 2541
    push cx ; 2542
    mov si, 022B1h ; 2543
    mov cx, 8 ; 2546
    call near ptr emit_template ; 2549
    pop cx ; 254C
    pop si ; 254D
    loop L2541 ; 254E
L2550:
    mov bl, byte ptr [bp - 010h] ; 2550
    cmp bl, 0FFh ; 2553
    je L256A ; 2556
    mov byte ptr cs:[022A5h], bl ; 2558
    push si ; 255D
    push cx ; 255E
    mov si, 022A0h ; 255F
    mov cx, 0Ah ; 2562
    call near ptr emit_template ; 2565
    pop cx ; 2568
    pop si ; 2569
L256A:
    push si ; 256A
    push cx ; 256B
    mov si, 0213Eh ; 256C
    mov cx, 1 ; 256F
    call near ptr emit_template ; 2572
    pop cx ; 2575
    pop si ; 2576
    ret ; 2577
L2578:
    call near ptr L22BE ; 2578
    call near ptr L04F9 ; 257B
    call near ptr L0511 ; 257E
    mov cl, byte ptr [bp - 012h] ; 2581
    mov bx, word ptr [bp - 8] ; 2584
L2587:
    push bx ; 2587
    push si ; 2588
    push di ; 2589
    call near ptr generated_program ; 258A
    pop di ; 258D
    pop si ; 258E
    add si, word ptr [bp - 01Ch] ; 258F
    add di, word ptr [bp - 01Eh] ; 2592
    pop bx ; 2595
    dec bx ; 2596
    jne L2587 ; 2597
    call near ptr L241F ; 2599
    call near ptr L0501 ; 259C
L259F:
    call near ptr L04C0 ; 259F
    mov cl, byte ptr [bp - 012h] ; 25A2
    mov bx, word ptr [bp - 8] ; 25A5
L25A8:
    push bx ; 25A8
    push si ; 25A9
    push di ; 25AA
    call near ptr generated_program ; 25AB
    pop di ; 25AE
    pop si ; 25AF
    add si, word ptr [bp - 01Ch] ; 25B0
    add di, word ptr [bp - 01Eh] ; 25B3
    pop bx ; 25B6
    dec bx ; 25B7
    jne L25A8 ; 25B8
    dec byte ptr [bp - 0Dh] ; 25BA
    jns L259F ; 25BD
    ret ; 25BF
blit_mode_table:
    dw L213F-driver_header, L20CC-driver_header, L213F-driver_header, L20CC-driver_header, L20CC-driver_header, L20CC-driver_header, L20CC-driver_header, L20CC-driver_header, L213F-driver_header, L2578-driver_header, L213F-driver_header, L20CC-driver_header, L20CC-driver_header, L20CC-driver_header, L20CC-driver_header, L20CC-driver_header
blit_surface:
    mov ax, word ptr [bp + 012h] ; 25E0
    xor bx, bx ; 25E3
    cmp ax, bx ; 25E5
    jge L25EF ; 25E7
    neg ax ; 25E9
    mov bx, ax ; 25EB
    xor ax, ax ; 25ED
L25EF:
    mov word ptr [bp - 2], ax ; 25EF
    mov word ptr [bp - 0Ah], bx ; 25F2
    mov ax, word ptr [bp + 010h] ; 25F5
    xor bx, bx ; 25F8
    cmp ax, bx ; 25FA
    jge L2604 ; 25FC
    neg ax ; 25FE
    mov bx, ax ; 2600
    xor ax, ax ; 2602
L2604:
    mov word ptr [bp - 4], ax ; 2604
    mov word ptr [bp - 0Ch], bx ; 2607
    lds si, dword ptr [bp + 0Ch] ; 260A
    les di, dword ptr [bp + 8] ; 260D
    mov ax, word ptr [bp + 012h] ; 2610
    add ax, word ptr [si] ; 2613
    mov bx, word ptr es:[di] ; 2615
    cmp ax, bx ; 2618
    jle L261E ; 261A
    mov ax, bx ; 261C
L261E:
    dec ax ; 261E
    sub ax, word ptr [bp - 2] ; 261F
    inc ax ; 2622
    jg L2628 ; 2623
    jmp near ptr L2762 ; 2625
L2628:
    mov word ptr [bp - 6], ax ; 2628
    mov ax, word ptr [bp + 010h] ; 262B
    add ax, word ptr [si + 2] ; 262E
    mov bx, word ptr es:[di + 2] ; 2631
    cmp ax, bx ; 2635
    jle L263B ; 2637
    mov ax, bx ; 2639
L263B:
    dec ax ; 263B
    sub ax, word ptr [bp - 4] ; 263C
    inc ax ; 263F
    jg L2645 ; 2640
    jmp near ptr L2762 ; 2642
L2645:
    mov word ptr [bp - 8], ax ; 2645
    mov bl, byte ptr [si + 6] ; 2648
    mov bh, byte ptr es:[di + 6] ; 264B
    mov ax, bx ; 264F
    and ax, 01818h ; 2651
    cmp al, ah ; 2654
    je L265B ; 2656
    jmp near ptr L2762 ; 2658
L265B:
    mov cl, 3 ; 265B
    shr al, cl ; 265D
    mov byte ptr [bp - 0Dh], al ; 265F
    mov ax, bx ; 2662
    and ax, 0C0C0h ; 2664
    mov cl, 6 ; 2667
    shr ah, cl ; 2669
    shr ax, cl ; 266B
    mov byte ptr [bp - 0Eh], al ; 266D
    mov al, byte ptr es:[di + 6] ; 2670
    and ax, 7 ; 2674
    add ax, word ptr [bp - 2] ; 2677
    push ax ; 267A
    and al, 7 ; 267B
    mov bh, al ; 267D
    mov al, byte ptr [si + 6] ; 267F
    and ax, 7 ; 2682
    add ax, word ptr [bp - 0Ah] ; 2685
    push ax ; 2688
    and al, 7 ; 2689
    mov bl, al ; 268B
    sub al, bh ; 268D
    and al, 7 ; 268F
    mov byte ptr [bp - 012h], al ; 2691
    xor ah, ah ; 2694
    not ah ; 2696
    mov al, ah ; 2698
    mov cl, bh ; 269A
    shr al, cl ; 269C
    mov byte ptr [bp - 0Fh], al ; 269E
    mov al, ah ; 26A1
    mov cl, bh ; 26A3
    xor ch, ch ; 26A5
    add cx, word ptr [bp - 6] ; 26A7
    dec cx ; 26AA
    mov dx, cx ; 26AB
    and cx, 7 ; 26AD
    inc cx ; 26B0
    shr al, cl ; 26B1
    not al ; 26B3
    mov byte ptr [bp - 010h], al ; 26B5
    mov cl, 3 ; 26B8
    shr dx, cl ; 26BA
    inc dx ; 26BC
    cmp dx, 1 ; 26BD
    mov al, byte ptr [bp - 0Fh] ; 26C0
    jne L26CE ; 26C3
    and al, byte ptr [bp - 010h] ; 26C5
    mov byte ptr [bp - 0Fh], al ; 26C8
    mov byte ptr [bp - 010h], ah ; 26CB
L26CE:
    cmp al, ah ; 26CE
    je L26D3 ; 26D0
    dec dx ; 26D2
L26D3:
    mov al, byte ptr [bp - 010h] ; 26D3
    cmp al, ah ; 26D6
    je L26DB ; 26D8
    dec dx ; 26DA
L26DB:
    mov word ptr [bp - 01Ah], dx ; 26DB
    mov ax, word ptr [bp - 0Ch] ; 26DE
    xor dx, dx ; 26E1
    mul word ptr [si + 4] ; 26E3
    mov dl, byte ptr [si + 7] ; 26E6
    xor dh, dh ; 26E9
    add ax, dx ; 26EB
    pop cx ; 26ED
    shr cx, 1 ; 26EE
    shr cx, 1 ; 26F0
    shr cx, 1 ; 26F2
    add ax, cx ; 26F4
    xor dx, dx ; 26F6
    cmp bl, bh ; 26F8
    jge L2708 ; 26FA
    cmp ax, 0 ; 26FC
    jne L2707 ; 26FF
    mov ax, 010h ; 2701
    mov dx, 0FFFFh ; 2704
L2707:
    dec ax ; 2707
L2708:
    mov bx, ax ; 2708
    mov cl, 4 ; 270A
    shr ax, cl ; 270C
    add ax, dx ; 270E
    mov word ptr [bp - 016h], ax ; 2710
    and bl, 0Fh ; 2713
    mov byte ptr [bp - 013h], bl ; 2716
    mov ax, word ptr [bp - 4] ; 2719
    xor dx, dx ; 271C
    mul word ptr es:[di + 4] ; 271E
    mov dl, byte ptr es:[di + 7] ; 2722
    xor dh, dh ; 2726
    add ax, dx ; 2728
    pop cx ; 272A
    shr cx, 1 ; 272B
    shr cx, 1 ; 272D
    shr cx, 1 ; 272F
    add ax, cx ; 2731
    mov bx, ax ; 2733
    mov cl, 4 ; 2735
    shr ax, cl ; 2737
    mov word ptr [bp - 018h], ax ; 2739
    and bl, 0Fh ; 273C
    mov byte ptr [bp - 014h], bl ; 273F
    mov ax, word ptr [si + 4] ; 2742
    mov word ptr [bp - 01Ch], ax ; 2745
    mov ax, word ptr es:[di + 4] ; 2748
    mov word ptr [bp - 01Eh], ax ; 274C
    mov bl, byte ptr [bp - 0Eh] ; 274F
    and bx, 0Fh ; 2752
    shl bx, 1 ; 2755
    call near ptr L04AC ; 2757
    call word ptr cs:[bx + 025C0h] ; 275A
    call near ptr L04B6 ; 275F
L2762:
    ret ; 2762
    db 13 dup (0) ; zero alignment/reserved data
mask_mode_table:
    dw L2800-driver_header, L28E7-driver_header
create_mask:
    lds si, dword ptr [bp + 0Ch] ; 2774
    mov al, byte ptr [si + 6] ; 2777
    and ax, 7 ; 277A
    mov bh, al ; 277D
    not ah ; 277F
    mov al, ah ; 2781
    mov cl, bh ; 2783
    shr al, cl ; 2785
    mov byte ptr [bp - 5], al ; 2787
    mov al, ah ; 278A
    mov cl, bh ; 278C
    xor ch, ch ; 278E
    add cx, word ptr [si] ; 2790
    dec cx ; 2792
    mov dx, cx ; 2793
    and cl, 7 ; 2795
    inc cl ; 2798
    shr al, cl ; 279A
    not al ; 279C
    mov byte ptr [bp - 6], al ; 279E
    mov cl, 3 ; 27A1
    shr dx, cl ; 27A3
    inc dx ; 27A5
    cmp dx, 1 ; 27A6
    mov al, byte ptr [bp - 5] ; 27A9
    jne L27B7 ; 27AC
    and al, byte ptr [bp - 6] ; 27AE
    mov byte ptr [bp - 5], al ; 27B1
    mov byte ptr [bp - 6], ah ; 27B4
L27B7:
    cmp al, ah ; 27B7
    je L27BC ; 27B9
    dec dx ; 27BB
L27BC:
    mov al, byte ptr [bp - 6] ; 27BC
    cmp al, ah ; 27BF
    je L27C4 ; 27C1
    dec dx ; 27C3
L27C4:
    mov word ptr [bp - 4], dx ; 27C4
    mov al, byte ptr [si + 6] ; 27C7
    or al, 040h ; 27CA
    mov byte ptr [si + 6], al ; 27CC
    and ax, 018h ; 27CF
    mov cl, 3 ; 27D2
    shr al, cl ; 27D4
    mov cl, al ; 27D6
    mov bx, ax ; 27D8
    inc bx ; 27DA
    shl bx, 1 ; 27DB
    mov ax, word ptr [bp + 8] ; 27DD
    mov word ptr [bx + si + 8], ax ; 27E0
    mov al, byte ptr [si + 7] ; 27E3
    xor ah, ah ; 27E6
    mov di, ax ; 27E8
    mov ax, word ptr [si + 4] ; 27EA
    mov word ptr [bp - 2], ax ; 27ED
    mov bl, byte ptr [si + 6] ; 27F0
    rol bl, 1 ; 27F3
    and bx, 1 ; 27F5
    shl bl, 1 ; 27F8
    call word ptr cs:[bx + 02770h] ; 27FA
    ret ; 27FF
L2800:
    mov ch, 0FFh ; 2800
    mov bx, word ptr [bp + 0Ah] ; 2802
    ror bl, cl ; 2805
    ror bl, 1 ; 2807
    mov ch, 0FFh ; 2809
    mov dx, word ptr [si + 2] ; 280B
    lea si, [si + 8] ; 280E
    mov word ptr [bp - 8], bx ; 2811
    mov word ptr [bp - 0Ah], cx ; 2814
    mov word ptr [bp - 0Ch], si ; 2817
L281A:
    push dx ; 281A
    push di ; 281B
    mov dh, byte ptr [bp - 5] ; 281C
    cmp dh, 0FFh ; 281F
    je L285A ; 2822
    mov bx, word ptr [bp - 8] ; 2824
    mov cx, word ptr [bp - 0Ah] ; 2827
    mov si, word ptr [bp - 0Ch] ; 282A
L282D:
    lodsw ; 282D
    mov es, ax ; 282E
    mov bh, byte ptr es:[di] ; 2830
    rcl bl, 1 ; 2833
    jb L2839 ; 2835
    not bh ; 2837
L2839:
    and ch, bh ; 2839
    dec cl ; 283B
    jns L282D ; 283D
    lodsw ; 283F
    mov es, ax ; 2840
    mov byte ptr es:[di], ch ; 2842
    and dh, ch ; 2845
    not dh ; 2847
    mov cx, word ptr [bp - 0Ah] ; 2849
    mov si, word ptr [bp - 0Ch] ; 284C
L284F:
    lodsw ; 284F
    mov es, ax ; 2850
    and byte ptr es:[di], dh ; 2852
    dec cl ; 2855
    jns L284F ; 2857
    inc di ; 2859
L285A:
    mov ax, word ptr [bp - 4] ; 285A
    test ax, 0FFFFh ; 285D
    je L289D ; 2860
L2862:
    push ax ; 2862
    mov bx, word ptr [bp - 8] ; 2863
    mov cx, word ptr [bp - 0Ah] ; 2866
    mov si, word ptr [bp - 0Ch] ; 2869
L286C:
    lodsw ; 286C
    mov es, ax ; 286D
    mov bh, byte ptr es:[di] ; 286F
    rcl bl, 1 ; 2872
    jb L2878 ; 2874
    not bh ; 2876
L2878:
    and ch, bh ; 2878
    dec cl ; 287A
    jns L286C ; 287C
    lodsw ; 287E
    mov es, ax ; 287F
    mov byte ptr es:[di], ch ; 2881
    mov dh, ch ; 2884
    not dh ; 2886
    mov cx, word ptr [bp - 0Ah] ; 2888
    mov si, word ptr [bp - 0Ch] ; 288B
L288E:
    lodsw ; 288E
    mov es, ax ; 288F
    and byte ptr es:[di], dh ; 2891
    dec cl ; 2894
    jns L288E ; 2896
    inc di ; 2898
    pop ax ; 2899
    dec ax ; 289A
    jne L2862 ; 289B
L289D:
    mov dh, byte ptr [bp - 6] ; 289D
    cmp dh, 0FFh ; 28A0
    je L28DB ; 28A3
    mov bx, word ptr [bp - 8] ; 28A5
    mov cx, word ptr [bp - 0Ah] ; 28A8
    mov si, word ptr [bp - 0Ch] ; 28AB
L28AE:
    lodsw ; 28AE
    mov es, ax ; 28AF
    mov bh, byte ptr es:[di] ; 28B1
    rcl bl, 1 ; 28B4
    jb L28BA ; 28B6
    not bh ; 28B8
L28BA:
    and ch, bh ; 28BA
    dec cl ; 28BC
    jns L28AE ; 28BE
    lodsw ; 28C0
    mov es, ax ; 28C1
    mov byte ptr es:[di], ch ; 28C3
    and dh, ch ; 28C6
    not dh ; 28C8
    mov cx, word ptr [bp - 0Ah] ; 28CA
    mov si, word ptr [bp - 0Ch] ; 28CD
L28D0:
    lodsw ; 28D0
    mov es, ax ; 28D1
    and byte ptr es:[di], dh ; 28D3
    dec cl ; 28D6
    jns L28D0 ; 28D8
    inc di ; 28DA
L28DB:
    pop di ; 28DB
    add di, word ptr [bp - 2] ; 28DC
    pop dx ; 28DF
    dec dx ; 28E0
    je L28E6 ; 28E1
    jmp near ptr L281A ; 28E3
L28E6:
    ret ; 28E6
L28E7:
    ret ; 28E7
    db 8 dup (0) ; zero alignment/reserved data
pixel_mode_table:
    dw L297F-driver_header, L29A0-driver_header, L294C-driver_header, L29D9-driver_header
put_pixel:
    lds si, dword ptr [bp + 0Eh] ; 28F8
    mov al, byte ptr [si + 6] ; 28FB
    and ax, 7 ; 28FE
    add ax, word ptr [bp + 0Ch] ; 2901
    mov bx, ax ; 2904
    and al, 7 ; 2906
    xor al, 7 ; 2908
    mov cl, al ; 290A
    mov ah, 1 ; 290C
    shl ah, cl ; 290E
    xchg ax, bx ; 2910
    mov cl, 3 ; 2911
    shr ax, cl ; 2913
    mov cx, ax ; 2915
    mov ax, word ptr [bp + 0Ah] ; 2917
    xor dx, dx ; 291A
    mul word ptr [si + 4] ; 291C
    add ax, cx ; 291F
    mov cl, byte ptr [si + 7] ; 2921
    xor ch, ch ; 2924
    add ax, cx ; 2926
    mov di, ax ; 2928
    mov ch, bh ; 292A
    mov ah, byte ptr [si + 6] ; 292C
    mov bl, ah ; 292F
    and ah, 018h ; 2931
    mov cl, 3 ; 2934
    shr ah, cl ; 2936
    mov cl, ah ; 2938
    lea si, [si + 8] ; 293A
    rol bl, 1 ; 293D
    rol bl, 1 ; 293F
    and bx, 3 ; 2941
    shl bl, 1 ; 2944
    call word ptr cs:[bx + 028F0h] ; 2946
    ret ; 294B
L294C:
    call near ptr L2A31 ; 294C
    mov dl, ch ; 294F
    not ch ; 2951
    mov bx, word ptr [bp + 8] ; 2953
    ror bl, cl ; 2956
    ror bl, 1 ; 2958
L295A:
    call near ptr L2A1B ; 295A
    lodsw ; 295D
    mov es, ax ; 295E
    mov bh, byte ptr es:[di] ; 2960
    and bh, ch ; 2963
    rcl bl, 1 ; 2965
    jae L296B ; 2967
    or bh, dl ; 2969
L296B:
    mov byte ptr es:[di], bh ; 296B
    dec cl ; 296E
    jns L295A ; 2970
    call near ptr L2A31 ; 2972
    call near ptr L2A1B ; 2975
    call near ptr L2A4F ; 2978
    call near ptr L2A4F ; 297B
    ret ; 297E
L297F:
    mov dl, ch ; 297F
    not ch ; 2981
    mov bx, word ptr [bp + 8] ; 2983
    ror bl, cl ; 2986
    ror bl, 1 ; 2988
L298A:
    lodsw ; 298A
    mov es, ax ; 298B
    mov bh, byte ptr es:[di] ; 298D
    and bh, ch ; 2990
    rcl bl, 1 ; 2992
    jae L2998 ; 2994
    or bh, dl ; 2996
L2998:
    mov byte ptr es:[di], bh ; 2998
    dec cl ; 299B
    jns L298A ; 299D
    ret ; 299F
L29A0:
    mov dl, ch ; 29A0
    not ch ; 29A2
    xor bh, ah ; 29A4
    mov bl, cl ; 29A6
    inc bl ; 29A8
    shl bl, 1 ; 29AA
    mov ax, word ptr [bx + si] ; 29AC
    mov es, ax ; 29AE
    mov bh, byte ptr es:[di] ; 29B0
    test bh, dl ; 29B3
    je L29D8 ; 29B5
    mov bx, word ptr [bp + 8] ; 29B7
    ror bl, cl ; 29BA
    ror bl, 1 ; 29BC
    test bl, 1 ; 29BE
    jne L29D8 ; 29C1
L29C3:
    lodsw ; 29C3
    mov es, ax ; 29C4
    mov bh, byte ptr es:[di] ; 29C6
    and bh, ch ; 29C9
    rcl bl, 1 ; 29CB
    jae L29D1 ; 29CD
    or bh, dl ; 29CF
L29D1:
    mov byte ptr es:[di], bh ; 29D1
    dec cl ; 29D4
    jns L29C3 ; 29D6
L29D8:
    ret ; 29D8
L29D9:
    call near ptr L2A31 ; 29D9
    mov dl, ch ; 29DC
    not ch ; 29DE
    xor bh, ah ; 29E0
    mov bl, cl ; 29E2
    inc bl ; 29E4
    shl bl, 1 ; 29E6
    mov ax, word ptr [bx + si] ; 29E8
    mov es, ax ; 29EA
    mov bh, byte ptr es:[di] ; 29EC
    test bh, dl ; 29EF
    je L2A17 ; 29F1
    mov bx, word ptr [bp + 8] ; 29F3
    ror bl, cl ; 29F6
    ror bl, 1 ; 29F8
    test bl, 1 ; 29FA
    jne L2A17 ; 29FD
L29FF:
    call near ptr L2A1B ; 29FF
    lodsw ; 2A02
    mov es, ax ; 2A03
    mov bh, byte ptr es:[di] ; 2A05
    and bh, ch ; 2A08
    rcl bl, 1 ; 2A0A
    jae L2A10 ; 2A0C
    or bh, dl ; 2A0E
L2A10:
    mov byte ptr es:[di], bh ; 2A10
    dec cl ; 2A13
    jns L29FF ; 2A15
L2A17:
    call near ptr L2A4F ; 2A17
    ret ; 2A1A
L2A1B:
    push ax ; 2A1B
    push dx ; 2A1C
    mov dx, 03CEh ; 2A1D
    mov al, 4 ; 2A20
    mov ah, cl ; 2A22
    out dx, ax ; 2A24
    mov dl, 0C4h ; 2A25
    mov al, 2 ; 2A27
    mov ah, 1 ; 2A29
    shl ah, cl ; 2A2B
    out dx, ax ; 2A2D
    pop dx ; 2A2E
    pop ax ; 2A2F
    ret ; 2A30
L2A31:
    push ax ; 2A31
    push dx ; 2A32
    mov dx, 03CEh ; 2A33
    mov ah, 0 ; 2A36
    mov al, 3 ; 2A38
    out dx, ax ; 2A3A
    mov ax, 5 ; 2A3B
    out dx, ax ; 2A3E
    mov ax, 7 ; 2A3F
    out dx, ax ; 2A42
    mov ax, 0FF08h ; 2A43
    out dx, ax ; 2A46
    mov dl, 0C4h ; 2A47
    mov ax, 0802h ; 2A49
    pop dx ; 2A4C
    pop ax ; 2A4D
    ret ; 2A4E
L2A4F:
    push ax ; 2A4F
    push dx ; 2A50
    mov dx, 03C4h ; 2A51
    mov ax, 0F02h ; 2A54
    out dx, ax ; 2A57
    mov dl, 0CEh ; 2A58
    mov ax, 3 ; 2A5A
    out dx, ax ; 2A5D
    mov ax, 5 ; 2A5E
    out dx, ax ; 2A61
    mov ax, 0F07h ; 2A62
    out dx, ax ; 2A65
    mov ax, 0FF08h ; 2A66
    out dx, ax ; 2A69
    pop dx ; 2A6A
    pop ax ; 2A6B
    ret ; 2A6C
    db 3 dup (0) ; zero alignment/reserved data
get_pixel_mode_table:
    dw L2AED-driver_header, L2AD1-driver_header
get_pixel:
    lds si, dword ptr [bp + 0Ch] ; 2A74
    mov al, byte ptr [si + 6] ; 2A77
    and ax, 7 ; 2A7A
    add ax, word ptr [bp + 0Ah] ; 2A7D
    mov bx, ax ; 2A80
    and al, 7 ; 2A82
    xor al, 7 ; 2A84
    mov cl, al ; 2A86
    mov ah, 1 ; 2A88
    shl ah, cl ; 2A8A
    xchg ax, bx ; 2A8C
    mov cl, 3 ; 2A8D
    shr ax, cl ; 2A8F
    mov cx, ax ; 2A91
    mov ax, word ptr [bp + 8] ; 2A93
    xor dx, dx ; 2A96
    mul word ptr [si + 4] ; 2A98
    add ax, cx ; 2A9B
    mov cl, byte ptr [si + 7] ; 2A9D
    xor ch, ch ; 2AA0
    add ax, cx ; 2AA2
    mov di, ax ; 2AA4
    mov ch, bh ; 2AA6
    mov ah, byte ptr [si + 6] ; 2AA8
    mov bl, ah ; 2AAB
    and ah, 018h ; 2AAD
    mov cl, 3 ; 2AB0
    shr ah, cl ; 2AB2
    test bl, 040h ; 2AB4
    je L2ABB ; 2AB7
    inc ah ; 2AB9
L2ABB:
    mov cl, ah ; 2ABB
    lea si, [si + 8] ; 2ABD
    rol bl, 1 ; 2AC0
    and bx, 1 ; 2AC2
    shl bl, 1 ; 2AC5
    call word ptr cs:[bx + 02A70h] ; 2AC7
    mov al, bl ; 2ACC
    xor ah, ah ; 2ACE
    ret ; 2AD0
L2AD1:
    call near ptr L2B16 ; 2AD1
    xor bl, bl ; 2AD4
L2AD6:
    call near ptr L2B00 ; 2AD6
    lodsw ; 2AD9
    mov es, ax ; 2ADA
    mov bh, byte ptr es:[di] ; 2ADC
    and bh, ch ; 2ADF
    neg bh ; 2AE1
    rol bx, 1 ; 2AE3
    dec cl ; 2AE5
    jns L2AD6 ; 2AE7
    call near ptr L2B34 ; 2AE9
    ret ; 2AEC
L2AED:
    xor bl, bl ; 2AED
L2AEF:
    lodsw ; 2AEF
    mov es, ax ; 2AF0
    mov bh, byte ptr es:[di] ; 2AF2
    and bh, ch ; 2AF5
    neg bh ; 2AF7
    rol bx, 1 ; 2AF9
    dec cl ; 2AFB
    jns L2AEF ; 2AFD
    ret ; 2AFF
L2B00:
    push ax ; 2B00
    push dx ; 2B01
    mov dx, 03CEh ; 2B02
    mov al, 4 ; 2B05
    mov ah, cl ; 2B07
    out dx, ax ; 2B09
    mov dl, 0C4h ; 2B0A
    mov al, 2 ; 2B0C
    mov ah, 1 ; 2B0E
    shl ah, cl ; 2B10
    out dx, ax ; 2B12
    pop dx ; 2B13
    pop ax ; 2B14
    ret ; 2B15
L2B16:
    push ax ; 2B16
    push dx ; 2B17
    mov dx, 03CEh ; 2B18
    mov ah, 0 ; 2B1B
    mov al, 3 ; 2B1D
    out dx, ax ; 2B1F
    mov ax, 5 ; 2B20
    out dx, ax ; 2B23
    mov ax, 7 ; 2B24
    out dx, ax ; 2B27
    mov ax, 0FF08h ; 2B28
    out dx, ax ; 2B2B
    mov dl, 0C4h ; 2B2C
    mov ax, 0802h ; 2B2E
    pop dx ; 2B31
    pop ax ; 2B32
    ret ; 2B33
L2B34:
    push ax ; 2B34
    push dx ; 2B35
    mov dx, 03C4h ; 2B36
    mov ax, 0F02h ; 2B39
    out dx, ax ; 2B3C
    mov dl, 0CEh ; 2B3D
    mov ax, 3 ; 2B3F
    out dx, ax ; 2B42
    mov ax, 5 ; 2B43
    out dx, ax ; 2B46
    mov ax, 0F07h ; 2B47
    out dx, ax ; 2B4A
    mov ax, 0FF08h ; 2B4B
    out dx, ax ; 2B4E
    pop dx ; 2B4F
    pop ax ; 2B50
    ret ; 2B51
    db 14 dup (0) ; zero alignment/reserved data
create_surface:
    lds si, dword ptr [bp + 0Ah] ; 2B60
    mov ax, word ptr [bp + 016h] ; 2B63
    cmp ax, 0 ; 2B66
    jge L2B6D ; 2B69
    xor ax, ax ; 2B6B
L2B6D:
    mov word ptr [si + 2], ax ; 2B6D
    mov ax, word ptr [bp + 018h] ; 2B70
    cmp ax, 0 ; 2B73
    jg L2B7A ; 2B76
    xor ax, ax ; 2B78
L2B7A:
    mov word ptr [si], ax ; 2B7A
    mov bl, byte ptr [bp + 0Eh] ; 2B7C
    and bx, 0Fh ; 2B7F
    mov byte ptr [bp + 0Eh], bl ; 2B82
    mov cl, 3 ; 2B85
    add ax, bx ; 2B87
    dec ax ; 2B89
    shr ax, cl ; 2B8A
    and ax, 0FEh ; 2B8C
    inc ax ; 2B8F
    inc ax ; 2B90
    mov word ptr [si + 4], ax ; 2B91
    mov al, byte ptr [bp + 014h] ; 2B94
    and al, 1 ; 2B97
    shl al, 1 ; 2B99
    mov bl, byte ptr [bp + 012h] ; 2B9B
    and bl, 1 ; 2B9E
    or al, bl ; 2BA1
    shl al, cl ; 2BA3
    mov bl, byte ptr [bp + 010h] ; 2BA5
    and bl, 3 ; 2BA8
    or al, bl ; 2BAB
    shl al, cl ; 2BAD
    mov bl, byte ptr [bp + 0Eh] ; 2BAF
    and bl, 7 ; 2BB2
    or al, bl ; 2BB5
    mov byte ptr [si + 6], al ; 2BB7
    xor ax, ax ; 2BBA
    mov byte ptr [si + 7], al ; 2BBC
    test byte ptr [bp + 014h], 1 ; 2BBF
    jne L2BD5 ; 2BC3
    mov ax, word ptr [si + 2] ; 2BC5
    xor dx, dx ; 2BC8
    mul word ptr [si + 4] ; 2BCA
    dec ax ; 2BCD
    mov cl, 4 ; 2BCE
    shr ax, cl ; 2BD0
    inc ax ; 2BD2
    mov bx, ax ; 2BD3
L2BD5:
    mov cl, byte ptr [bp + 010h] ; 2BD5
    and cx, 3 ; 2BD8
    inc cx ; 2BDB
    test byte ptr [bp + 012h], 1 ; 2BDC
    je L2BE3 ; 2BE0
    inc cx ; 2BE2
L2BE3:
    mov ax, ds ; 2BE3
    mov es, ax ; 2BE5
    lea di, [si + 8] ; 2BE7
    mov ax, word ptr [bp + 8] ; 2BEA
L2BED:
    stosw ; 2BED
    add ax, bx ; 2BEE
    loop L2BED ; 2BF0
    ret ; 2BF2
    db 13 dup (0) ; zero alignment/reserved data
clip_surface:
    mov ax, word ptr [bp + 01Eh] ; 2C00
    cmp ax, 0 ; 2C03
    jge L2C0A ; 2C06
    xor ax, ax ; 2C08
L2C0A:
    mov word ptr [bp - 2], ax ; 2C0A
    les di, dword ptr [bp + 0Ch] ; 2C0D
    stosw ; 2C10
    mov ax, word ptr [bp + 01Ch] ; 2C11
    cmp ax, 0 ; 2C14
    jge L2C1B ; 2C17
    xor ax, ax ; 2C19
L2C1B:
    mov word ptr [bp - 4], ax ; 2C1B
    les di, dword ptr [bp + 8] ; 2C1E
    stosw ; 2C21
    lds si, dword ptr [bp + 014h] ; 2C22
    les di, dword ptr [bp + 010h] ; 2C25
    mov ax, word ptr [bp + 01Ah] ; 2C28
    mov bx, word ptr [si] ; 2C2B
    dec bx ; 2C2D
    cmp ax, bx ; 2C2E
    jle L2C34 ; 2C30
    mov ax, bx ; 2C32
L2C34:
    sub ax, word ptr [bp - 2] ; 2C34
    inc ax ; 2C37
    jge L2C3C ; 2C38
    xor ax, ax ; 2C3A
L2C3C:
    stosw ; 2C3C
    mov ax, word ptr [bp + 018h] ; 2C3D
    mov bx, word ptr [si + 2] ; 2C40
    dec bx ; 2C43
    cmp ax, bx ; 2C44
    jle L2C4A ; 2C46
    mov ax, bx ; 2C48
L2C4A:
    sub ax, word ptr [bp - 4] ; 2C4A
    inc ax ; 2C4D
    jge L2C52 ; 2C4E
    xor ax, ax ; 2C50
L2C52:
    stosw ; 2C52
    les di, dword ptr [bp + 010h] ; 2C53
    mov cl, byte ptr [si + 6] ; 2C56
    mov ax, cx ; 2C59
    and ax, 7 ; 2C5B
    add ax, word ptr [bp - 2] ; 2C5E
    mov bx, ax ; 2C61
    and al, 7 ; 2C63
    and cl, 0F8h ; 2C65
    or al, cl ; 2C68
    mov byte ptr es:[di + 6], al ; 2C6A
    mov cl, 3 ; 2C6E
    shr bx, cl ; 2C70
    xor dx, dx ; 2C72
    mov ax, word ptr [si + 4] ; 2C74
    mov word ptr es:[di + 4], ax ; 2C77
    mul word ptr [bp - 4] ; 2C7B
    mov cl, byte ptr [si + 7] ; 2C7E
    xor ch, ch ; 2C81
    add ax, cx ; 2C83
    add ax, bx ; 2C85
    mov bx, ax ; 2C87
    and ax, 0Fh ; 2C89
    mov byte ptr es:[di + 7], al ; 2C8C
    mov cl, 4 ; 2C90
    shr bx, cl ; 2C92
    mov al, byte ptr [si + 6] ; 2C94
    mov cl, al ; 2C97
    mov cl, 3 ; 2C99
    shr al, cl ; 2C9B
    and ax, 3 ; 2C9D
    inc ax ; 2CA0
    test cl, 6 ; 2CA1
    je L2CA7 ; 2CA4
    inc ax ; 2CA6
L2CA7:
    mov cx, ax ; 2CA7
    lea si, [si + 8] ; 2CA9
    lea di, [di + 8] ; 2CAC
    mov ax, bx ; 2CAF
L2CB1:
    lodsw ; 2CB1
    add ax, bx ; 2CB2
    stosw ; 2CB4
    loop L2CB1 ; 2CB5
    ret ; 2CB7
    db 8 dup (0) ; zero alignment/reserved data
surface_paragraphs:
    mov ax, word ptr [bp + 0Eh] ; 2CC0
    cmp ax, 0 ; 2CC3
    jge L2CCA ; 2CC6
    xor ax, ax ; 2CC8
L2CCA:
    mov word ptr [bp + 0Eh], ax ; 2CCA
    mov ax, word ptr [bp + 010h] ; 2CCD
    cmp ax, 0 ; 2CD0
    jge L2CD7 ; 2CD3
    xor ax, ax ; 2CD5
L2CD7:
    mov bl, byte ptr [bp + 8] ; 2CD7
    and bx, 0Fh ; 2CDA
    mov cl, 3 ; 2CDD
    add ax, bx ; 2CDF
    dec ax ; 2CE1
    shr ax, cl ; 2CE2
    and ax, 0FEh ; 2CE4
    inc ax ; 2CE7
    inc ax ; 2CE8
    xor dx, dx ; 2CE9
    mul word ptr [bp + 0Eh] ; 2CEB
    dec ax ; 2CEE
    mov cl, 4 ; 2CEF
    shr ax, cl ; 2CF1
    inc ax ; 2CF3
    mov cl, byte ptr [bp + 0Ah] ; 2CF4
    and cx, 3 ; 2CF7
    inc cx ; 2CFA
    test byte ptr [bp + 0Ch], 1 ; 2CFB
    je L2D02 ; 2CFF
    inc cx ; 2D01
L2D02:
    xor dx, dx ; 2D02
    mul cx ; 2D04
    ret ; 2D06
    db 9 dup (0) ; zero alignment/reserved data
mirror_surface_x:
    lds si, dword ptr [bp + 0Ch] ; 2D10
    les di, dword ptr [bp + 8] ; 2D13
    mov cx, 5 ; 2D16
    rep movsw ; 2D19
    lds si, dword ptr [bp + 0Ch] ; 2D1B
    les di, dword ptr [bp + 8] ; 2D1E
    mov al, byte ptr [si + 6] ; 2D21
    mov bl, al ; 2D24
    and bl, 0F8h ; 2D26
    and ax, 7 ; 2D29
    add ax, word ptr [si] ; 2D2C
    dec ax ; 2D2E
    mov dx, ax ; 2D2F
    and al, 7 ; 2D31
    xor al, 7 ; 2D33
    or al, bl ; 2D35
    mov byte ptr es:[di + 6], al ; 2D37
    mov cl, 3 ; 2D3B
    shr dx, cl ; 2D3D
    mov ax, dx ; 2D3F
    inc dx ; 2D41
    mov word ptr [bp - 6], dx ; 2D42
    and ax, 0FFFEh ; 2D45
    inc ax ; 2D48
    inc ax ; 2D49
    mov word ptr es:[di + 4], ax ; 2D4A
    mov word ptr [bp - 4], ax ; 2D4E
    mov ax, word ptr [si + 4] ; 2D51
    mov word ptr [bp - 2], ax ; 2D54
    mov al, byte ptr [si + 6] ; 2D57
    and ax, 018h ; 2D5A
    mov cl, 3 ; 2D5D
    shr al, cl ; 2D5F
    xor ah, ah ; 2D61
    inc ax ; 2D63
    mov word ptr [bp - 8], ax ; 2D64
    mov al, byte ptr [si + 7] ; 2D67
    xor ah, ah ; 2D6A
    add ax, word ptr [bp - 6] ; 2D6C
    dec ax ; 2D6F
    mov word ptr [bp - 0Ah], ax ; 2D70
    xor ax, ax ; 2D73
    mov byte ptr es:[di + 7], al ; 2D75
    mov word ptr [bp - 0Ch], ax ; 2D79
    mov ax, word ptr es:[di + 2] ; 2D7C
    xor dx, dx ; 2D80
    mul word ptr [bp - 4] ; 2D82
    dec ax ; 2D85
    mov cl, 4 ; 2D86
    shr ax, cl ; 2D88
    inc ax ; 2D8A
    mov bx, ax ; 2D8B
    mov dx, di ; 2D8D
    mov cl, 4 ; 2D8F
    shr dx, cl ; 2D91
    mov ax, es ; 2D93
    add ax, dx ; 2D95
    test di, 0Fh ; 2D97
    je L2D9E ; 2D9B
    inc ax ; 2D9D
L2D9E:
    inc ax ; 2D9E
    inc ax ; 2D9F
    lea di, [di + 8] ; 2DA0
    mov cx, word ptr [bp - 8] ; 2DA3
L2DA6:
    stosw ; 2DA6
    add ax, bx ; 2DA7
    loop L2DA6 ; 2DA9
    call near ptr L2DCF ; 2DAB
    ret ; 2DAE
L2DAF:
    mov bx, word ptr [bp - 8] ; 2DAF
    dec bx ; 2DB2
    xor bl, 3 ; 2DB3
    shl bl, 1 ; 2DB6
    lds si, dword ptr [bp + 8] ; 2DB8
    mov ax, word ptr [bx + si + 8] ; 2DBB
    mov es, ax ; 2DBE
    lds si, dword ptr [bp + 0Ch] ; 2DC0
    mov ax, word ptr [bx + si + 8] ; 2DC3
    mov ds, ax ; 2DC6
    mov si, word ptr [bp - 0Ah] ; 2DC8
    mov di, word ptr [bp - 0Ch] ; 2DCB
    ret ; 2DCE
L2DCF:
    mov ax, word ptr [si + 2] ; 2DCF
    mov word ptr [bp - 0Eh], ax ; 2DD2
L2DD5:
    call near ptr L2DAF ; 2DD5
    mov dx, word ptr [bp - 0Eh] ; 2DD8
L2DDB:
    push si ; 2DDB
    push di ; 2DDC
    mov cx, word ptr [bp - 6] ; 2DDD
L2DE0:
    mov ah, byte ptr [si] ; 2DE0
    dec si ; 2DE2
    shr ah, 1 ; 2DE3
    rcl al, 1 ; 2DE5
    shr ah, 1 ; 2DE7
    rcl al, 1 ; 2DE9
    shr ah, 1 ; 2DEB
    rcl al, 1 ; 2DED
    shr ah, 1 ; 2DEF
    rcl al, 1 ; 2DF1
    shr ah, 1 ; 2DF3
    rcl al, 1 ; 2DF5
    shr ah, 1 ; 2DF7
    rcl al, 1 ; 2DF9
    shr ah, 1 ; 2DFB
    rcl al, 1 ; 2DFD
    shr ah, 1 ; 2DFF
    rcl al, 1 ; 2E01
    stosb ; 2E03
    loop L2DE0 ; 2E04
    pop di ; 2E06
    pop si ; 2E07
    add si, word ptr [bp - 2] ; 2E08
    add di, word ptr [bp - 4] ; 2E0B
    dec dx ; 2E0E
    jne L2DDB ; 2E0F
    dec word ptr [bp - 8] ; 2E11
    jne L2DD5 ; 2E14
    ret ; 2E16
    db 9 dup (0) ; zero alignment/reserved data
fill_mode_table:
    dw L2EA0-driver_header, L2F07-driver_header
fill_surface:
    lds si, dword ptr [bp + 0Ah] ; 2E24
    mov al, byte ptr [si + 6] ; 2E27
    and ax, 7 ; 2E2A
    mov bh, al ; 2E2D
    not ah ; 2E2F
    mov al, ah ; 2E31
    mov cl, bh ; 2E33
    shr al, cl ; 2E35
    mov byte ptr [bp - 5], al ; 2E37
    mov al, ah ; 2E3A
    mov cl, bh ; 2E3C
    xor ch, ch ; 2E3E
    add cx, word ptr [si] ; 2E40
    dec cx ; 2E42
    mov dx, cx ; 2E43
    and cl, 7 ; 2E45
    inc cl ; 2E48
    shr al, cl ; 2E4A
    not al ; 2E4C
    mov byte ptr [bp - 6], al ; 2E4E
    mov cl, 3 ; 2E51
    shr dx, cl ; 2E53
    inc dx ; 2E55
    cmp dx, 1 ; 2E56
    mov al, byte ptr [bp - 5] ; 2E59
    jne L2E67 ; 2E5C
    and al, byte ptr [bp - 6] ; 2E5E
    mov byte ptr [bp - 5], al ; 2E61
    mov byte ptr [bp - 6], ah ; 2E64
L2E67:
    cmp al, ah ; 2E67
    je L2E6C ; 2E69
    dec dx ; 2E6B
L2E6C:
    mov al, byte ptr [bp - 6] ; 2E6C
    cmp al, ah ; 2E6F
    je L2E74 ; 2E71
    dec dx ; 2E73
L2E74:
    mov word ptr [bp - 4], dx ; 2E74
    mov al, byte ptr [si + 6] ; 2E77
    and ax, 018h ; 2E7A
    mov cl, 3 ; 2E7D
    shr al, cl ; 2E7F
    mov cl, al ; 2E81
    mov al, byte ptr [si + 7] ; 2E83
    xor ah, ah ; 2E86
    mov di, ax ; 2E88
    mov ax, word ptr [si + 4] ; 2E8A
    mov word ptr [bp - 2], ax ; 2E8D
    mov bl, byte ptr [si + 6] ; 2E90
    rol bl, 1 ; 2E93
    and bx, 1 ; 2E95
    shl bl, 1 ; 2E98
    call word ptr cs:[bx + 02E20h] ; 2E9A
    ret ; 2E9F
L2EA0:
    mov bx, word ptr [bp + 8] ; 2EA0
    ror bl, cl ; 2EA3
    ror bl, 1 ; 2EA5
    mov dx, word ptr [si + 2] ; 2EA7
    lea si, [si + 8] ; 2EAA
L2EAD:
    lodsw ; 2EAD
    mov es, ax ; 2EAE
    xor ax, ax ; 2EB0
    rcl bl, 1 ; 2EB2
    jae L2EB8 ; 2EB4
    not ax ; 2EB6
L2EB8:
    push di ; 2EB8
    push cx ; 2EB9
    push dx ; 2EBA
L2EBB:
    push di ; 2EBB
    mov cl, byte ptr [bp - 5] ; 2EBC
    cmp cl, 0FFh ; 2EBF
    je L2ED3 ; 2EC2
    mov ch, al ; 2EC4
    and ch, cl ; 2EC6
    not cl ; 2EC8
    and cl, byte ptr es:[di] ; 2ECA
    or cl, ch ; 2ECD
    mov byte ptr es:[di], cl ; 2ECF
    inc di ; 2ED2
L2ED3:
    mov cx, word ptr [bp - 4] ; 2ED3
    jcxz L2EDF ; 2ED6
    shr cx, 1 ; 2ED8
    rep stosw ; 2EDA
    jae L2EDF ; 2EDC
    stosb ; 2EDE
L2EDF:
    mov cl, byte ptr [bp - 6] ; 2EDF
    cmp cl, 0FFh ; 2EE2
    je L2EF6 ; 2EE5
    mov ch, al ; 2EE7
    and ch, cl ; 2EE9
    not cl ; 2EEB
    and cl, byte ptr es:[di] ; 2EED
    or cl, ch ; 2EF0
    mov byte ptr es:[di], cl ; 2EF2
    inc di ; 2EF5
L2EF6:
    pop di ; 2EF6
    add di, word ptr [bp - 2] ; 2EF7
    dec dx ; 2EFA
    je L2EFF ; 2EFB
    jmp short L2EBB ; 2EFD
L2EFF:
    pop dx ; 2EFF
    pop cx ; 2F00
    pop di ; 2F01
    dec cl ; 2F02
    jns L2EAD ; 2F04
    ret ; 2F06
L2F07:
    mov dx, 03C4h ; 2F07
    mov ax, 0FF02h ; 2F0A
    out dx, ax ; 2F0D
    mov ah, byte ptr [bp + 8] ; 2F0E
    mov al, 0 ; 2F11
    mov dl, 0CEh ; 2F13
    out dx, ax ; 2F15
    mov ax, 0F01h ; 2F16
    out dx, ax ; 2F19
    mov cx, word ptr [si + 2] ; 2F1A
    lea si, [si + 8] ; 2F1D
    lodsw ; 2F20
    mov es, ax ; 2F21
L2F23:
    push cx ; 2F23
    push di ; 2F24
    mov ah, byte ptr [bp - 5] ; 2F25
    cmp ah, 0FFh ; 2F28
    je L2F34 ; 2F2B
    mov al, 8 ; 2F2D
    out dx, ax ; 2F2F
    mov al, byte ptr es:[di] ; 2F30
    stosb ; 2F33
L2F34:
    mov cx, word ptr [bp - 4] ; 2F34
    jcxz L2F44 ; 2F37
    mov ax, 0FF08h ; 2F39
    out dx, ax ; 2F3C
    shr cx, 1 ; 2F3D
    rep stosw ; 2F3F
    jae L2F44 ; 2F41
    stosb ; 2F43
L2F44:
    mov ah, byte ptr [bp - 6] ; 2F44
    cmp ah, 0FFh ; 2F47
    je L2F53 ; 2F4A
    mov al, 8 ; 2F4C
    out dx, ax ; 2F4E
    mov al, byte ptr es:[di] ; 2F4F
    stosb ; 2F52
L2F53:
    pop di ; 2F53
    add di, word ptr [bp - 2] ; 2F54
    pop cx ; 2F57
    loop L2F23 ; 2F58
    mov ax, 0FF08h ; 2F5A
    out dx, ax ; 2F5D
    mov ax, 1 ; 2F5E
    out dx, ax ; 2F61
    ret ; 2F62
    db 13 dup (0) ; zero alignment/reserved data
driver_relocate:
    xor ax, ax ; 2F70
    mov es, ax ; 2F72
    xchg ax, word ptr es:[6] ; 2F74
    xchg ax, word ptr es:[0Eh] ; 2F79
    mov cx, word ptr [si + 0Bh] ; 2F7E
    sub cx, word ptr [si + 5] ; 2F81
    add si, word ptr [si + 5] ; 2F84
    mov bx, si ; 2F87
    shr si, 1 ; 2F89
    shr si, 1 ; 2F8B
    shr si, 1 ; 2F8D
    shr si, 1 ; 2F8F
    xchg ax, word ptr es:[0Eh] ; 2F91
    xchg ax, word ptr es:[6] ; 2F96
    mov ax, ds ; 2F9B
    add ax, si ; 2F9D
    mov ds, ax ; 2F9F
    xchg ax, bx ; 2FA1
    and ax, 0Fh ; 2FA2
    mov si, ax ; 2FA5
    je L2FB2 ; 2FA7
    xor ax, ax ; 2FA9
    dec bx ; 2FAB
    mov es, bx ; 2FAC
    mov di, ax ; 2FAE
    rep movsb ; 2FB0
L2FB2:
    mov ax, cs ; 2FB2
    mov ds, ax ; 2FB4
    mov es, ax ; 2FB6
    mov si, word ptr [bp + 2] ; 2FB8
    sub si, 3 ; 2FBB
    mov di, si ; 2FBE
    mov al, 0EAh ; 2FC0
    stosb ; 2FC2
    mov ax, word ptr [si + 5] ; 2FC3
    stosw ; 2FC6
    mov cl, 4 ; 2FC7
    shr ax, cl ; 2FC9
    xchg ax, bx ; 2FCB
    sub ax, bx ; 2FCC
    stosw ; 2FCE
    ret ; 2FCF
driver_decode:
    push bp ; 2FD0
    mov bp, sp ; 2FD1
    cld ; 2FD3
    push bx ; 2FD4
    push cx ; 2FD5
    push si ; 2FD6
    push di ; 2FD7
    push ds ; 2FD8
    push es ; 2FD9
    mov ax, cs ; 2FDA
    mov ds, ax ; 2FDC
    mov es, ax ; 2FDE
    mov si, word ptr [bp + 2] ; 2FE0
    sub si, 3 ; 2FE3
    cmp word ptr [si + 3], 01234h ; 2FE6
    je L2FF2 ; 2FEB
    mov ax, 1 ; 2FED
    jmp short L3042 ; 2FF0
L2FF2:
    mov di, si ; 2FF2
    mov ax, 033EBh ; 2FF4
    call near ptr L2FFA ; 2FF7
L2FFA:
    pop bx ; 2FFA
    nop ; 2FFB
    nop ; 2FFC
    nop ; 2FFD
    mov cx, word ptr [si + 9] ; 2FFE
    nop ; 3001
    nop ; 3002
    nop ; 3003
    mov bx, word ptr [si + 7] ; 3004
    mov word ptr [si + 7], 0 ; 3007
    xor ax, ax ; 300C
L300E:
    rol ax, 1 ; 300E
    add ax, word ptr es:[di] ; 3010
    add di, 2 ; 3013
    loop L300E ; 3016
    cmp ax, bx ; 3018
    jmp short L3021 ; 301A
    mov ax, 1 ; 301C
    jmp short L3042 ; 301F
L3021:
    mov di, si ; 3021
    add di, word ptr [si + 5] ; 3023
    mov cx, word ptr [si + 1] ; 3026
    add cx, 3 ; 3029
    sub cx, word ptr [si + 5] ; 302C
    xor al, al ; 302F
L3031:
    rol al, 1 ; 3031
    xor byte ptr es:[di], al ; 3033
    add al, byte ptr es:[di] ; 3036
    inc di ; 3039
    loop L3031 ; 303A
    call near ptr driver_relocate ; 303C
    mov ax, 0 ; 303F
L3042:
    pop es ; 3042
    pop ds ; 3043
    pop di ; 3044
    pop si ; 3045
    pop cx ; 3046
    pop bx ; 3047
    mov sp, bp ; 3048
    pop bp ; 304A
    add sp, 2 ; 304B
    retf ; 304E
legacy_trailer:
    db 0BEh ; original trailing non-code byte in driver word record
driver_end:
EGA_TEXT ends
end
