#include <dos.h>
#include "SUPPORT.H"

void video_000b(int mode)
{
    struct REGPACK regs;
    regs.r_ax=mode;
    intr(16,&regs);
}

void video_002c(int page)
{
    struct REGPACK regs;
    regs.r_ax=page+0x500;
    intr(16,&regs);
}

int video_0050(void)
{
    struct REGPACK regs;
    regs.r_ax=0xF00;
    intr(16,&regs);
    return 255&regs.r_ax;
}
