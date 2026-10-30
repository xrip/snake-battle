#include <stdio.h>
#include <stdlib.h>
#include "SUPPORT.H"

void assert_0006(int condition,char *text,char *kind,int status)
{
    if(!condition) {
        printf(g_0d3a,f_0c31_0007(g_0d3e,kind,text));
        assert_00f5(status);
    }
}
void assert_0042(int condition,char *text) { assert_0006(condition,text,g_0d4f,223); }
void assert_0060(int condition,char *text) { assert_0006(condition,text,g_0d57,224); }
void assert_007e(int condition,char *text) { assert_0006(condition,text,g_0d5e,222); }
void assert_009c(int code,char *text)
{ printf(g_0d3a,f_0c31_0007(g_0d64,f_0c1e_000c(code,6),text)); }
void assert_00d3(int code,char *text) { assert_009c(code,text); exit(code); }
int assert_00f1(void) { return g_3ac0; }
void assert_00f5(int code) { exit(code); }
