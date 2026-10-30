
#include <dir.h>
#include <dos.h>
#include <stdio.h>
#include <string.h>
#include "SUPPORT.H"

/* Recovered DATA at DS:0D76, 6 bytes. */
typedef struct SB_SB_REGISTER_DEFAULTS {
    char *filename;
    int enabled;
} SB_SB_REGISTER_DEFAULTS;
typedef char CHECK_sb_register_defaults[(sizeof(SB_SB_REGISTER_DEFAULTS) == 6) ? 1 : -1];
extern char sb_psw_name[10];
SB_SB_REGISTER_DEFAULTS sb_register_defaults = {
    sb_psw_name,
    1
};

/* Recovered BSS at DS:3BC2, 128 bytes. */
typedef struct SB_SB_REGISTER_STATE {
    Stamp cache[15];
    Challenge *challenge;
    ChallengeList *list;
} SB_SB_REGISTER_STATE;
typedef char CHECK_sb_register_state[(sizeof(SB_SB_REGISTER_STATE) == 128) ? 1 : -1];
SB_SB_REGISTER_STATE sb_register_state;


static Stamp zero_stamp={0,0,0L};

int register_0006(void)
{
    char *filename;
    Stamp *scan,zero;
    int index,result;
    FILE *file;
    char *current,*stored;
    Resource info;
    struct ffblk found;
    Stamp stamps[15];
    scan=stamps;
    zero=zero_stamp;
    for(index=0;index<15;++index) {
        *scan=zero;
        ++scan;
    }
    result=findfirst(g_0d8e,&found,FA_DIREC);
    scan=stamps;
    index=0;
    while(!result && index<15) {
        if(found.ff_attrib&FA_DIREC) {
            ++index;
            ++scan;
            scan->time=found.ff_ftime;
            scan->date=found.ff_fdate;
            scan->size=found.ff_fsize;
        }
        result=findnext(&found);
    }
    if(scan==stamps) {
        result=findfirst(g_0d91,&found,0);
        scan=stamps;
        index=0;
        while(!result && index<15) {
            scan->time=found.ff_ftime;
            scan->date=found.ff_fdate;
            scan->size=found.ff_fsize;
            result=findnext(&found);
            ++index;
            ++scan;
        }
    }
    f_0b2b_000f(stamps,sizeof(stamps),100);
    file=fopen(g_0d76,g_0d97);
    if(file)
        fread(g_3bc2,1,sizeof(stamps),file);
    fclose(file);
    g_0d7a=1;
    current=(char *)stamps;
    stored=(char *)g_3bc2;
    for(index=0;index<120;++index) {
        if(*current++!=*stored++) {
            g_0d7a=0;
            break;
        }
    }
    if(g_0d7a) return 1;
    memcpy(g_3bc2,stamps,sizeof(stamps));
    if(!g_1af6) filename=g_0d9a;
    else filename=g_0da4;
    f_11db_006d(filename,&info);
    g_3c3e=f_0b33_002a(info.unpacked_size);
    f_11db_01fa(filename,1,g_3c3e);
    return 0;
}

void register_0251(int *number,char *symbol)
{
    if(!g_0d7a) {
        g_3c3a=&g_3c3e->item[f_0b33_0d8f(g_3c3e->count)];
        *number=g_3c3a->number;
        *symbol=g_3c3a->symbol;
    }
}

int register_02a1(char *answer)
{
    int index;
    char previous;
    FILE *file;
    char text[16];
    if(!g_0d7a) {
        if(!strlen(answer) || strlen(answer)>=16) return 0;
        strcpy(text,answer);
        while(strlen(text)<15) strncat(text,text,16-strlen(text)-1);
        previous=*(unsigned char *)g_3c3a ^ g_3c3a->number;
        for(index=0;index<16;++index) {
            text[index]^=previous;
            previous=text[index];
            if(text[index]!=g_3c3a->cipher[index]) return 0;
        }
        file=fopen(g_0d76,g_0dae);
        fwrite(g_3bc2,1,sizeof(g_3bc2),file);
        fclose(file);
        g_0d7a=1;
    }
    return 1;
}

void register_03ca(void) { f_0b33_0063(g_3c3e); }

/* Recovered DATA at DS:0D8E, 35 bytes. */
typedef struct SB_SB_REGISTER_STRINGS {
    char text_0d8e[3];
    char text_0d91[6];
    char text_0d97[3];
    char text_0d9a[10];
    char text_0da4[10];
    char text_0dae[3];
} SB_SB_REGISTER_STRINGS;
typedef char CHECK_sb_register_strings[(sizeof(SB_SB_REGISTER_STRINGS) == 35) ? 1 : -1];
char sb_psw_name[10] = "snake.psw";
SB_SB_REGISTER_STRINGS sb_register_strings = {
    "\\*",
    "*.exe",
    "rb",
    "passw.rus",
    "passw.eng",
    "wb"
};
