



/* Synchronize with the leading edge of the adapter's vertical retrace.
   The BIOS data area supplies the active CRT-controller I/O base. */
void wait_retrace(void)
{
    asm push dx;
    asm push es;
    asm mov ax, 40h;
    asm mov es, ax;
    asm mov dx, es:[63h];
    asm add dl, 6;
    asm cli;
wait_end:
    asm in al, dx;
    asm test al, 8;
    asm jnz wait_end;
wait_start:
    asm in al, dx;
    asm test al, 8;
    asm jz wait_start;
    asm sti;
    asm pop es;
    asm pop dx;
}

