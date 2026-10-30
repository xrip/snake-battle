
#include <dos.h>
#include <stdlib.h>
#include <string.h>
#include "LOW.H"

/* Recovered DATA at DS:0E4C, 43 bytes. */
typedef struct SB_SB_BLO_STRINGS {
    char text_0e4c[3];
    char text_0e4f[21];
    char text_0e64[16];
    char text_0e74[3];
} SB_SB_BLO_STRINGS;
typedef char CHECK_sb_blo_strings[(sizeof(SB_SB_BLO_STRINGS) == 43) ? 1 : -1];
SB_SB_BLO_STRINGS sb_blo_strings = {
    "rb",
    "game not full. file ",
    "wrong game file",
    "wb"
};

/* Recovered BSS at DS:40C0, 8 bytes. */
typedef struct SB_SB_BLO_STATE {
    DriverEntry original;
    DriverEntry current;
} SB_SB_BLO_STATE;
typedef char CHECK_sb_blo_state[(sizeof(SB_SB_BLO_STATE) == 8) ? 1 : -1];
SB_SB_BLO_STATE sb_blo_state;


void blo_0009(void) { g_40c4=g_40c0; }

void blo_0018(DriverEntry driver)
{
    int status;
    g_40c0=g_40c4;
    g_40c4=driver;
    status=g_40c4();
    if(status) {
        blo_0009();
        f_0c21_00f5(status+244);
    }
}

unsigned blo_005b(unsigned segment)
{
    Image *image=MK_FP(segment,0);
    return (image->stride*image->height+15U)>>4;
}

unsigned blo_0082(unsigned segment) { return blo_005b(segment)*4+2; }

void blo_0096(char *name,Image **image)
{
    FILE *file;
    unsigned plane_paragraphs,paragraphs;
    int count;
    char plane;
    Image header;
    char message[100];
    file=fopen(name,g_0e4c);
    if(!file) {
        strcpy(message,g_0e4f);
        strcat(message,name);
        f_0b33_0003(message);
        f_0c21_00f5(240);
    }
    count=fread(&header,1,sizeof(Image),file);
    if(count!=32) {
        f_0b33_0003(g_0e64);
        f_0c21_00f5(240);
    }
    plane_paragraphs=(header.stride*header.height+15U)>>4;
    paragraphs=plane_paragraphs*4+2;
    f_0def_0007(&((unsigned *)image)[1],paragraphs);
    ((unsigned *)image)[0]=0;
    memcpy(*image,&header,sizeof(Image));
    for(plane=0;plane<=(((*image)->flags>>3)&3);plane++)
        (*image)->plane[plane]=(*image)->plane[plane]+FP_SEG(*image);
    f_0ddb_00a8(file,FP_SEG(*image)+2,paragraphs-2);
    fclose(file);
}

void blo_0200(char *name,Image **image)
{
    FILE *file;
    unsigned plane_paragraphs,paragraphs;
    char plane;
    file=fopen(name,g_0e74);
    if(!file) f_0c21_00f5(241);
    plane_paragraphs=((*image)->stride*(*image)->height+15U)>>4;
    paragraphs=plane_paragraphs*4+2;
    for(plane=0;plane<=(((*image)->flags>>3)&3);plane++)
        (*image)->plane[plane]=(*image)->plane[plane]-FP_SEG(*image);
    f_0ddb_0009(file,FP_SEG(*image),paragraphs);
    for(plane=0;plane<=(((*image)->flags>>3)&3);plane++)
        (*image)->plane[plane]=(*image)->plane[plane]+FP_SEG(*image);
    fclose(file);
}

void blo_0317(Image *source,Image *part,int *x,int *y)
{
    long delta;
    delta=((part->plane[0]-source->plane[0])<<4)+(part->mode-source->mode);
    *y=delta/(unsigned)source->stride;
    delta%=(unsigned)source->stride;
    delta<<=3;
    delta+=part->flags&7;
    delta-=source->flags&7;
    *x=delta;
}

void blo_03be(void) { exit(1); }

