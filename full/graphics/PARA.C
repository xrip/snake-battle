#include <alloc.h>
#include <dos.h>
#include "LOW.H"

void para_0007(unsigned *segment,unsigned paragraphs)
{
    void *memory;
    memory=farcalloc(paragraphs+1,16L);
    if(!memory) f_0b33_0003(g_0e78);
    else if(FP_OFF(memory)!=4) f_0b33_0003(g_0e88);
    *segment=FP_SEG(memory)+1;
}

void para_0055(unsigned *segment)
{
    farfree(MK_FP(*segment-1,4));
    *segment=0;
}
