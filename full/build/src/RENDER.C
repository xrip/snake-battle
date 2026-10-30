
#include <dos.h>
#include <mem.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include "RENDER.H"

/* Recovered DATA at DS:0DB2, 4 bytes. */
typedef struct SB_SB_RENDER_DEFAULTS {
    int update;
    int active;
} SB_SB_RENDER_DEFAULTS;
typedef char CHECK_sb_render_defaults[(sizeof(SB_SB_RENDER_DEFAULTS) == 4) ? 1 : -1];
SB_SB_RENDER_DEFAULTS sb_render_defaults = {
    0,
    1
};

/* Recovered BSS at DS:3C42, 1150 bytes. */
typedef struct SB_SB_RENDER_STATE {
    Glyph font[256];
    char *messages;
    char *font_table;
    Image *font_small;
    Image *font_large;
    Image *font_current;
    int font_height;
    int font_width;
    Image surfaces[2];
    int mode;
    Image *pages[2];
    int page;
    unsigned planes[4];
    char *keymap;
    Cursor *cursor;
    int front_page;
    Image *back;
    Image *front;
} SB_SB_RENDER_STATE;
typedef char CHECK_sb_render_state[(sizeof(SB_SB_RENDER_STATE) == 1150) ? 1 : -1];
SB_SB_RENDER_STATE sb_render_state;


void render_000a(int x0,int y0,int x1,int y1,int color,Image *image)
{
    int dx,dy,error,tmp;
    if(g_0db2) disable();
    if(x0>x1) {
        tmp=x0; x0=x1; x1=tmp;
        tmp=y0; y0=y1; y1=tmp;
    }
    dx=x1-x0;
    error=0;
    if(y0<=y1) {
        dy=y1-y0;
        if(dx>=dy) {
            while(1) {
                g_40c4.pixel(image,x0,y0,color,5);
                if(x0==x1) break;
                ++x0; error+=dy; error+=dy;
                if(error<=dx) continue;
                error-=dx; error-=dx; ++y0;
                continue;
            }
        } else {
            while(1) {
                g_40c4.pixel(image,x0,y0,color,5);
                if(y0==y1) break;
                ++y0; error+=dx; error+=dx;
                if(error<=dy) continue;
                error-=dy; error-=dy; ++x0;
                continue;
            }
        }
    } else {
        dy=y0-y1;
        if(dx>=dy) {
            while(1) {
                g_40c4.pixel(image,x0,y0,color,5);
                if(x0==x1) break;
                ++x0; error+=dy; error+=dy;
                if(error<=dx) continue;
                error-=dx; error-=dx; --y0;
                continue;
            }
        } else {
            while(1) {
                g_40c4.pixel(image,x0,y0,color,5);
                if(y0==y1) break;
                --y0; error+=dx; error+=dx;
                if(error<=dy) continue;
                error-=dy; error-=dy; ++x0;
                continue;
            }
        }
    }
    if(g_0db2) enable();
}

void render_01a2(char **messages,int count)
{
    unsigned segment;
    char *line,*scan;
    int index,row;
    char *filename;
    int code;
    if(!g_1af6) render_0958(g_0dd9,&g_404e);
    else if(g_1af6==2) render_0958(g_0de6,&g_404e);
    else render_0958(g_0df3,&g_404e);
    f_0def_0007(&segment,f_0d9f_005b(FP_SEG(g_404e)));
    g_40c4.convert(g_404e,5,segment,0);
    if(!g_1af6) render_0958(g_0e00,&g_404a);
    else if(g_1af6==2) render_0958(g_0e0d,&g_404a);
    else render_0958(g_0e1a,&g_404a);
    f_0def_0007(&segment,f_0d9f_005b(FP_SEG(g_404a)));
    g_40c4.convert(g_404a,5,segment,0);
    g_4052=g_404e;
    g_4058=0;
    g_4056=0;
    {
    char english[]="english.txt";
    char russian[]="russian.txt";
    char swedish[]="sweden.txt";
    Resource info;
    if(!g_1af6) filename=russian;
    else if(g_1af6==2) filename=swedish;
    else filename=english;
    f_11db_006d(filename,&info);
    scan=f_0b33_002a(info.unpacked_size);
    f_11db_01fa(filename,1,scan);
    g_4042=scan;
    while(*scan!='\r') ++scan;
    *scan=0; ++scan; ++scan;
    g_4046=scan;
    while(*scan!='\r') ++scan;
    *scan=0; ++scan; ++scan;
    for(index=0;index<256;++index) {
        g_3c42[index].row=0;
        g_3c42[index].column=47;
    }
    for(row=0;row<4;++row) {
        line=scan;
        while(*scan!='\r') ++scan;
        *scan=0; ++scan; ++scan;
        for(index=0;index<strlen(line);++index) {
            code=(unsigned char)line[index];
            g_3c42[code].row=row;
            g_3c42[code].column=index;
        }
    }
    for(index=0;index<count;++index) {
        messages[index]=scan;
        while(*scan!='\r') ++scan;
        *scan=0; ++scan; ++scan;
    }
    }
}

void render_0449(void) { g_40ae=g_4046; }
void render_0458(void) { g_40ae=g_4042; }
int render_0467(int font)
{
    int old=g_0db4;
    if(font==1) g_4052=g_404e;
    else g_4052=g_404a;
    g_0db4=font;
    return old;
}

void render_049d(Image *target,int x,int y,char *text)
{
    int width,height,x0,y0,x1,y1,code;
    Image glyph;
    if(g_0db2) disable();
    g_4058=x;
    g_4056=y+1;
    while(*text) {
        code=(unsigned char)*text;
        x0=g_3c42[code].column*8;
        y0=g_3c42[code].row*10;
        x1=x0+7; y1=y0+9;
        g_40c4.clip(x0,y0,x1,y1,g_4052,&glyph,&width,&height,3);
        g_40c4.blit(g_4058,g_4056+1,&glyph,target,1);
        g_4058+=8;
        ++text;
    }
    if(g_0db2) enable();
}

void render_0562(Image *target,int x,int y,char ch)
{
    char text[2];
    text[0]=ch; text[1]=0;
    render_049d(target,x,y,text);
}

void render_058e(int *x,int *y) { *x=g_4058; *y=g_4056; }

void render_05a5(Image *target,int x,int y,int value)
{
    char text[20];
    sprintf(text,g_0e27,value);
    render_049d(target,x,y,text);
}

void render_05dc(void)
{
    Cursor *cursor;
    g_40b2=f_0b33_002a(sizeof(Cursor));
    cursor=g_40b2;
    cursor->hidden=1;
    cursor->width=26; cursor->height=21;
    cursor->x=cursor->width/2;
    cursor->y=cursor->height/2;
    render_0a6a(&cursor->background,cursor->width+1,cursor->height+1,0,0,0);
    render_0f00(g_0e2a,&cursor->shape,5);
}

void render_0670(Image *target) { g_40b2->target=target; }

void render_0687(Cursor *cursor,int x,int y)
{
    int width,height;
    Image view;
    if(cursor->x!=x || cursor->y!=y) {
        if(!cursor->hidden) {
            if(g_0db2) disable();
            g_40c4.blit(cursor->x,cursor->y,cursor->background,cursor->target,1);
            if(g_0db2) enable();
        }
        cursor->x=x; cursor->y=y;
        if(!cursor->hidden) {
            if(g_0db2) disable();
            g_40c4.clip(cursor->x,cursor->y,cursor->x+cursor->width,cursor->y+cursor->height,
                         cursor->target,&view,&width,&height,3);
            g_40c4.blit(0,0,&view,cursor->background,1);
            g_40c4.blit(cursor->x,cursor->y,cursor->shape,cursor->target,1);
            if(g_0db2) enable();
        }
    }
}

void render_078a(Cursor *cursor)
{
    if(!cursor->hidden) {
        if(g_0db2) disable();
        g_40c4.blit(cursor->x,cursor->y,cursor->background,cursor->target,1);
        if(g_0db2) enable();
    }
    cursor->hidden=1;
}

void render_07d3(Cursor *cursor)
{
    int width,height;
    Image view;
    if(cursor->hidden) {
        if(g_0db2) disable();
        g_40c4.clip(cursor->x,cursor->y,cursor->x+cursor->width,cursor->y+cursor->height,
                     cursor->target,&view,&width,&height,3);
        g_40c4.blit(0,0,&view,cursor->background,1);
        g_40c4.blit(cursor->x,cursor->y,cursor->shape,cursor->target,1);
        if(g_0db2) enable();
        cursor->hidden=0;
    }
}

int render_087c(Cursor *arg,int x0,int y0,int x1,int y1)
{
    Cursor *cursor=arg;
    if((cursor->x>=x0 && cursor->y>=y0 && cursor->x<=x1 && cursor->y<=y1) ||
       (cursor->x+cursor->width>=x0 && cursor->y>=y0 && cursor->x+cursor->width<=x1 && cursor->y<=y1) ||
       (cursor->x+cursor->width>=x0 && cursor->y+cursor->height>=y0 && cursor->x+cursor->width<=x1 && cursor->y+cursor->height<=y1) ||
       (cursor->x>=x0 && cursor->y+cursor->height>=y0 && cursor->x<=x1 && cursor->y+cursor->height<=y1)) return 1;
    else return 0;
}

void render_0958(char *name,Image **result)
{
    unsigned segment;
    int plane;
    Resource info;
    f_11db_006d(name,&info);
    f_0def_0007(&segment,(info.unpacked_size+15)>>4);
    *result=MK_FP(segment,0);
    f_11db_01fa(name,1,*result);
    for(plane=0;plane<=(((*result)->flags>>3)&3);++plane)
        (*result)->plane[plane]+=segment;
}

void render_09ea(char *name,Image *target)
{
    void *data;
    Resource info;
    f_11db_006d(name,&info);
    data=f_0b33_002a(info.packed_size);
    f_11db_01fa(name,0,data);
    if(g_0db2) disable();
    f_11db_04fa(data,target==&g_407a ? 0:1);
    if(g_0db2) enable();
    f_0b33_0063(data);
}

void render_0a6a(Image **result,int width,int height,int mode,int mask,int clear)
{
    unsigned paragraphs,segment;
    unsigned long address;
    int planes=3,zero=0;
    int index;
    char *scan;
    paragraphs=g_40c4.size(width,height,(char)mask,(char)planes,(char)zero,6)+2;
    f_0def_0007(&segment,paragraphs);
    address=segment; *result=(Image *)(address<<16);
    if(clear) {
        scan=(char *)*result;
        for(index=1;index<=16;++index) {
            setmem(scan,paragraphs,0);
            scan+=paragraphs;
        }
    }
    g_40c4.create(width,height,(char)mode,(char)mask,(char)planes,(char)zero,*result,segment+2,2);
}

void render_0b2f(Image **image)
{
    unsigned segment=FP_SEG(*image);
    f_0def_0055(&segment);
}

void render_0b4f(int x0,int y0,int x1,int y1,Image *source,Image *dest)
{
    int width,height;
    g_40c4.clip(x0,y0,x1,y1,source,dest,&width,&height,3);
}

void render_0b83(int x,int y,Image *source,Image *dest)
{
    if(g_0db2) disable();
    g_40c4.blit(x,y,source,dest,1);
    if(g_0db2) enable();
}

void render_0bb2(int x0,int y0,int x1,int y1,Image *source,int x,int y,Image *dest)
{
    int width,height;
    Image view;
    if(g_0db2) disable();
    g_40c4.clip(x0,y0,x1,y1,source,&view,&width,&height,3);
    g_40c4.blit(x,y,&view,dest,1);
    if(g_0db2) enable();
}

void render_0c0e(int x0,int y0,int x1,int y1,Image *source,int x,int y,Image *dest,int divisions)
{
    int width,last_width,height,last_height,index,row;
    union {struct {int second,first;} swap; long tick;} work;
    int temp,left,right,top,bottom;
    int rows[25],columns[25];
    if(divisions>25) f_0b33_0003(g_0e35);
    width=(x1-x0+1)/divisions;
    last_width=(x1-x0+1)-(divisions-1)*width;
    height=(y1-y0+1)/divisions;
    last_height=(y1-y0+1)-(divisions-1)*height;
    for(index=0;index<divisions;++index) {
        rows[index]=index;
        columns[index]=index;
    }
    for(index=0;index<divisions*16;++index) {
        work.swap.first=f_0b33_0d8f(divisions);
        work.swap.second=f_0b33_0d8f(divisions);
        temp=rows[work.swap.first];
        rows[work.swap.first]=rows[work.swap.second];
        rows[work.swap.second]=temp;
        work.swap.first=f_0b33_0d8f(divisions);
        work.swap.second=f_0b33_0d8f(divisions);
        temp=columns[work.swap.first];
        columns[work.swap.first]=columns[work.swap.second];
        columns[work.swap.second]=temp;
    }
    if(g_0db2) disable();
    for(row=0;row<divisions;++row) {
        work.tick=f_0c10_000a();
        temp=columns[row];
        for(index=0;index<divisions;++index) {
            ++temp; temp%=divisions;
            left=x0+index*width;
            top=y0+rows[temp]*height;
            right=(index==divisions-1 ? left+last_width:left+width)-1;
            bottom=(rows[temp]==divisions-1 ? top+last_height:top+height)-1;
            render_0bb2(left,top,right,bottom,source,x+left-x0,y+top-y0,dest);
        }
        f_0c10_0016(work.tick,1L);
    }
    if(g_0db2) enable();
}

int render_0e6e(Image *image,int x,int y) { return g_40c4.query(image,x,y,4); }
void render_0e87(Image *image,int color)
{
    if(g_0db2) disable();
    g_40c4.fill(image,color,8);
    if(g_0db2) enable();
}

void render_0ead(int x0,int y0,int x1,int y1,Image *image,int color)
{
    int width,height;
    Image view;
    g_40c4.clip(x0,y0,x1,y1,image,&view,&width,&height,3);
    if(g_0db2) disable();
    g_40c4.fill(&view,color,8);
    if(g_0db2) enable();
}

void render_0f00(char *name,Image **image,int mode)
{
    unsigned segment;
    render_0958(name,image);
    f_0def_0007(&segment,f_0d9f_005b(FP_SEG(*image)));
    g_40c4.convert(*image,mode,segment,0);
}

void render_0f4f(Image *src,Image *dest,int *x,int *y)
{ f_0d9f_0317(src,dest,x,y); }

void render_0f74(void)
{
    g_40b8=g_40bc;
    ++g_40b6; g_40b6%=2;
    g_40bc=g_409c[g_40b6];
    g_409a=0;
}

void render_0fb1(void)
{
    if(!g_409a) {
        g_409a=1;
        g_19bf=0;
        f_0c41_002c(g_40b6);
        f_0ed3_0000();
        render_0670(g_40bc);
    }
}

void render_0fe1(void)
{
    render_0fb1();
    render_0f74();
    render_0b83(0,0,g_40b8,g_40bc);
    render_0fb1();
}

void render_1009(void)
{
    g_0db2=0;
    f_0d9f_0018(f_0ed6_0000);
    g_40c4.create(640,350,1,0,3,0,&g_407a,0xa000,2);
    g_40c4.create(640,350,1,0,3,0,&g_405a,0xa800,2);
    g_409c[0]=&g_407a;
    g_409c[1]=&g_405a;
    g_40b6=0;
    g_409a=0;
    g_40bc=g_409c[g_40b6];
    g_40b8=g_409c[1];
    g_40a4=f_0c41_0050();
    f_11db_0006(g_0e42);
    render_05dc();
    f_0c41_000b(16);
    f_03f2_0288();
    srand(time(0));
    f_0431_0077();
}

void render_10ee(void)
{
    f_03f2_02fe();
    f_0c41_000b(g_40a4);
    f_11db_0052();
    f_0431_01c0();
}

void render_1108(void)
{
    int color,x=0,y=0,width=30,height=20;
    char text[10];
    Image view;
    for(color=0;color<16;++color) {
        render_0b4f(x,y,x+width,y+height,g_40bc,&view);
        render_0e87(&view,color);
        sprintf(text,g_0e27,color);
        render_049d(g_40bc,x,y+height+5,text);
        x+=width;
    }
}

/* Recovered DATA at DS:0DD9, 115 bytes. */
typedef struct SB_SB_RENDER_STRINGS {
    char text_0dd9[13];
    char text_0de6[13];
    char text_0df3[13];
    char text_0e00[13];
    char text_0e0d[13];
    char text_0e1a[13];
    char text_0e27[3];
    char text_0e2a[11];
    char text_0e35[13];
    char text_0e42[10];
} SB_SB_RENDER_STRINGS;
typedef char CHECK_sb_render_strings[(sizeof(SB_SB_RENDER_STRINGS) == 115) ? 1 : -1];
SB_SB_RENDER_STRINGS sb_render_strings = {
    "rshrif_1.blo",
    "swshri_1.blo",
    "shrift_1.blo",
    "rshrif_2.blo",
    "swshri_2.blo",
    "shrift_2.blo",
    "%d",
    "kursor.blo",
    "puzzle error",
    "snake.gpf"
};
