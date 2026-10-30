#ifndef SB_HW_H
#define SB_HW_H
#include <dos.h>
typedef void (*HwCallback)(unsigned, unsigned *);
extern unsigned char g0ea0, g0ea1, g0ea2, g0ea5;
extern int g0ea3, g0eaa, g0eac, g0eae, g0eb0, g0eb2;
extern unsigned char g0eb4, g0eb5, g0eb6, g0eb7, g0eb8;
extern HwCallback g0ea6;
extern unsigned char g40c8;
extern int g40c9, g40cb, g40cd, g40cf, g40d1, g40d3;
extern int g40d5, g40d7, g40d9, g40db, g40dd, g40df;
extern unsigned g40e1;
extern int g40e3, g40e5, g40e7, g40e9, g40eb, g40ed, g40ef;
extern void interrupt (*g40f1)(void);
int hw_init(HwCallback);
HwCallback hw_callback(HwCallback);
void hw_video(void);
void hw_position(int, int);
void hw_get_position(int *, int *);
void hw_bounds(int, int, int, int);
int hw_buttons(unsigned char, unsigned char, unsigned char);
int hw_done(void);
void interrupt hw_keyboard(void);
void interrupt hw_mouse(unsigned, unsigned, unsigned, unsigned, unsigned,
                        unsigned, unsigned, unsigned, unsigned);
unsigned char hw_lock(unsigned char);
#define HW_MAX(a,b) ((a) > (b) ? (a) : (b))
#define HW_MIN(a,b) ((a) < (b) ? (a) : (b))
#endif
