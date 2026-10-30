#ifndef SB_SUPPORT_H
#define SB_SUPPORT_H
#include <stdio.h>
extern char g_0d3a[],g_0d3e[],g_0d4f[],g_0d57[],g_0d5e[],g_0d64[];
extern int g_3ac0;
extern char g_3ac2[256];
char *f_0c1e_000c(int,int);
char *f_0c31_0007(char *,...);
void assert_0006(int,char *,char *,int);
void assert_0042(int,char *);
void assert_0060(int,char *);
void assert_007e(int,char *);
void assert_009c(int,char *);
void assert_00d3(int,char *);
int assert_00f1(void);
void assert_00f5(int);
void format_0003(void);
int format_0004(void);
char *format_0007(char *,...);
void format_004b(char *,char *,...);
int format_008b(FILE *,char *,...);
void video_000b(int);
void video_002c(int);
int video_0050(void);

typedef struct Stamp { unsigned time,date; long size; } Stamp;
typedef struct Resource {
    char name[13]; unsigned char method;
    long offset; unsigned packed_size,unpacked_size;
} Resource;
typedef struct Challenge { unsigned char symbol,number; char cipher[16]; } Challenge;
typedef struct ChallengeList { int count; Challenge item[1]; } ChallengeList;
extern char *g_0d76;
extern int g_0d7a,g_1af6;
extern char g_0d8e[],g_0d91[],g_0d97[],g_0d9a[],g_0da4[],g_0dae[];
extern Stamp g_3bc2[15];
extern Challenge *g_3c3a;
extern ChallengeList *g_3c3e;
void f_0b2b_000f(void *,int,char);
void *f_0b33_002a(unsigned);
void f_0b33_0063(void *);
int f_0b33_0d8f(int);
void f_11db_006d(char *,Resource *);
void f_11db_01fa(char *,int,void *);
int register_0006(void);
void register_0251(int *,char *);
int register_02a1(char *);
void register_03ca(void);
#endif
