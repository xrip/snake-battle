
#include <alloc.h>
#include <dos.h>
#include "LOW.H"

/* Recovered DATA at DS:0E78, 39 bytes. */
typedef struct SB_SB_PARA_STRINGS {
    char text_0e78[16];
    char text_0e88[23];
} SB_SB_PARA_STRINGS;
typedef char CHECK_sb_para_strings[(sizeof(SB_SB_PARA_STRINGS) == 39) ? 1 : -1];
SB_SB_PARA_STRINGS sb_para_strings = {
    "not free memory",
    "error in allocmemblock"
};



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

