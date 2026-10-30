#include <dos.h>
#include "LOW.H"

void chunk_0009(FILE *file,unsigned segment,unsigned paragraphs)
{
    int index;
    unsigned count,tail;
    for(index=0;index<=(int)(paragraphs>>11)-1;++index) {
        count=fwrite(MK_FP(segment+(index<<11),0),1,0x8000U,file);
        if(count!=0x8000U) f_0c21_00f5(230);
    }
    tail=(paragraphs&2047)<<4;
    count=fwrite(MK_FP(segment+((paragraphs>>11)<<11),0),1,tail,file);
    if(count!=tail) f_0c21_00f5(230);
}

void chunk_00a8(FILE *file,unsigned segment,unsigned paragraphs)
{
    int index;
    unsigned count,tail;
    for(index=0;index<=(int)(paragraphs>>11)-1;++index) {
        count=fread(MK_FP(segment+(index<<11),0),1,0x8000U,file);
        if(count!=0x8000U) f_0c21_00f5(231);
    }
    tail=(paragraphs&2047)<<4;
    count=fread(MK_FP(segment+((paragraphs>>11)<<11),0),1,tail,file);
    if(count!=tail) f_0c21_00f5(231);
}
