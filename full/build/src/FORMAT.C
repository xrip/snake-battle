
#include <stdio.h>
#include <stdarg.h>
#include <string.h>
#include "SUPPORT.H"


/* Recovered BSS at DS:3AC2, 256 bytes. */
typedef struct SB_SB_FORMAT_STATE {
    char text[256];
} SB_SB_FORMAT_STATE;
typedef char CHECK_sb_format_state[(sizeof(SB_SB_FORMAT_STATE) == 256) ? 1 : -1];
SB_SB_FORMAT_STATE sb_format_state;


void format_0003(void) {}
int format_0004(void) { return 0; }

char *format_0007(char *format,...)
{
    va_list args;
    char text[256];
    va_start(args,format);
    vsprintf(text,format,args);
    strcpy(g_3ac2,text);
    return g_3ac2;
}

void format_004b(char *dest,char *format,...)
{
    va_list args;
    char text[256];
    va_start(args,format);
    vsprintf(text,format,args);
    strcpy(dest,text);
}

int format_008b(FILE *file,char *format,...)
{
    va_list args;
    char *text;
    int result;
    va_start(args,format);
    if(*format=='#') {
        text=va_arg(args,char *);
        fgets(text,255,file);
        text[strlen(text)-1]=0;
        return 1;
    } else {
        result=vfscanf(file,format,args);
        return result;
    }
}

