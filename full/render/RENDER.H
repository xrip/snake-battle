#ifndef SB_RENDER_H
#define SB_RENDER_H
/* Original 16-bit Borland large-model ABI. */
typedef struct Image {
    int width,height,stride;
    signed char flags,mode;
    unsigned plane[4];
    unsigned reserved[8];
} Image;
typedef struct Cursor {
    int hidden,x,y,width,height;
    Image *background,*shape,*target;
} Cursor;
typedef struct Resource {
    char name[13]; unsigned char method;
    long offset;
    unsigned packed_size,unpacked_size;
} Resource;
typedef struct Glyph { int row,column; } Glyph;
/* The same far driver entry has command-dependent argument lists and
 * Pascal stack cleanup. Typed union views preserve the original byte ABI. */
typedef union Driver {
    int (far pascal *start)(void);
    int (far pascal *convert)(Image *,int,unsigned,int);
    int (far pascal *blit)(int,int,Image *,Image *,int);
    int (far pascal *create)(int,int,char,char,char,char,Image *,unsigned,int);
    int (far pascal *clip)(int,int,int,int,Image *,Image *,int *,int *,int);
    int (far pascal *pixel)(Image *,int,int,int,int);
    int (far pascal *size)(int,int,char,char,char,int);
    int (far pascal *query)(Image *,int,int,int);
    int (far pascal *fill)(Image *,int,int);
} Driver;
extern int g_0db2,g_0db4,g_1af6;
extern char g_19bf;
extern Glyph g_3c42[256];
extern char *g_4042,*g_4046,*g_40ae;
extern Image *g_404a,*g_404e,*g_4052;
extern int g_4056,g_4058;
extern Image g_405a,g_407a;
extern int g_409a,g_40a4,g_40b6;
extern Image *g_409c[2],*g_40b8,*g_40bc;
extern Cursor *g_40b2;
extern Driver g_40c4;
extern char g_0dd9[],g_0de6[],g_0df3[],g_0e00[],g_0e0d[],g_0e1a[];
extern char g_0e27[],g_0e2a[],g_0e35[],g_0e42[];
void *f_0b33_002a(unsigned);
void f_0b33_0063(void *);
void f_0b33_0003(char *);
int f_0b33_0d8f(int);
void f_11db_0006(char *);
void f_11db_0052(void);
void f_11db_006d(char *,Resource *);
void f_11db_01fa(char *,int,void *);
void f_11db_04fa(void *,int);
void f_0def_0007(unsigned *,unsigned);
void f_0def_0055(unsigned *);
unsigned f_0d9f_005b(unsigned);
void f_0d9f_0018(int (far pascal *)(void));
void f_0d9f_0317(Image *,Image *,int *,int *);
int far pascal f_0ed6_0000(void);
void f_0c41_000b(int);
void f_0c41_002c(int);
int f_0c41_0050(void);
void f_0ed3_0000(void);
void f_03f2_0288(void);
void f_03f2_02fe(void);
void f_0431_0077(void);
void f_0431_01c0(void);
long f_0c10_000a(void);
void f_0c10_0016(long,long);
void render_000a(int,int,int,int,int,Image *);
void render_01a2(char **,int);
void render_0449(void);
void render_0458(void);
int render_0467(int);
void render_049d(Image *,int,int,char *);
void render_0562(Image *,int,int,char);
void render_058e(int *,int *);
void render_05a5(Image *,int,int,int);
void render_05dc(void);
void render_0670(Image *);
void render_0687(Cursor *,int,int);
void render_078a(Cursor *);
void render_07d3(Cursor *);
int render_087c(Cursor *,int,int,int,int);
void render_0958(char *,Image **);
void render_09ea(char *,Image *);
void render_0a6a(Image **,int,int,int,int,int);
void render_0b2f(Image **);
void render_0b4f(int,int,int,int,Image *,Image *);
void render_0b83(int,int,Image *,Image *);
void render_0bb2(int,int,int,int,Image *,int,int,Image *);
void render_0c0e(int,int,int,int,Image *,int,int,Image *,int);
int render_0e6e(Image *,int,int);
void render_0e87(Image *,int);
void render_0ead(int,int,int,int,Image *,int);
void render_0f00(char *,Image **,int);
void render_0f4f(Image *,Image *,int *,int *);
void render_0f74(void);
void render_0fb1(void);
void render_0fe1(void);
void render_1009(void);
void render_10ee(void);
void render_1108(void);
#endif
