#ifndef SB_LOW_H
#define SB_LOW_H
#include <stdio.h>
typedef struct Image {
    int width,height,stride;
    signed char flags,mode;
    unsigned plane[4],reserved[8];
} Image;
typedef int (far pascal *DriverEntry)(void);
extern DriverEntry g_40c0,g_40c4;
extern char g_0e4c[],g_0e4f[],g_0e64[],g_0e74[],g_0e78[],g_0e88[];
void f_0b33_0003(char *);
void f_0c21_00f5(int);
void f_0ddb_0009(FILE *,unsigned,unsigned);
void f_0ddb_00a8(FILE *,unsigned,unsigned);
void f_0def_0007(unsigned *,unsigned);
void blo_0009(void);
void blo_0018(DriverEntry);
unsigned blo_005b(unsigned);
unsigned blo_0082(unsigned);
void blo_0096(char *,Image **);
void blo_0200(char *,Image **);
void blo_0317(Image *,Image *,int *,int *);
void blo_03be(void);
void chunk_0009(FILE *,unsigned,unsigned);
void chunk_00a8(FILE *,unsigned,unsigned);
void para_0007(unsigned *,unsigned);
void para_0055(unsigned *);
#endif
