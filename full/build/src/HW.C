
/* Original DOS keyboard/mouse module, recovered as C with its hardware
   interrupt and port sequences retained as inline assembler. */
#include "HW.H"

/* Recovered initialized hardware state at DS:0EA0; packed by BCC -a-. */
typedef struct SB_HW_DATA {
    unsigned char left_key, middle_key, right_key;
    int mouse_installed;
    unsigned char locked;
    HwCallback callback;
    int left_held, middle_held, right_held, button_mask;
    int cursor_enabled;
    unsigned char modifier, scan, scan_ready, extended, active;
} SB_HW_DATA;
typedef char CHECK_sb_hw_data[(sizeof(SB_HW_DATA) == 25) ? 1 : -1];
SB_HW_DATA sb_hw_data = {
    0x52, 0, 0x53, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1
};

/* Recovered BSS at DS:40C8.  The odd word offsets are intentional. */
typedef struct SB_HW_STATE {
    unsigned char scan;
    int x, y;
    int left_count, middle_count, right_count, buttons;
    int min_x, min_y, max_x, max_y;
    int height, width;
    unsigned keyboard_flags;
    int e3, e5, e7, e9, eb, ed, ef;
    void interrupt (*previous_keyboard)(void);
} SB_HW_STATE;
typedef char CHECK_sb_hw_state[(sizeof(SB_HW_STATE) == 45) ? 1 : -1];
SB_HW_STATE sb_hw_state;


int hw_init(HwCallback callback)
{
    unsigned segment = FP_SEG(hw_mouse);
    unsigned callback_offset = FP_OFF(hw_mouse);
    g0eb2 = 1;
    g0ea6 = callback;
    asm mov ax, 0;
    asm int 33h;
    asm mov g0ea3, ax;
    if (g0ea3 == -1) {
        asm mov ax, 0ch;
        asm mov cx, 7fh;
        asm push es;
        asm mov dx, segment;
        asm mov es, dx;
        asm mov dx, callback_offset;
        asm int 33h;
        asm pop es;
        asm mov ax, 2;
        asm int 33h;
    }
    hw_video();
    g40f1 = getvect(9);
    setvect(9, hw_keyboard);
    return g0ea3;
}

HwCallback hw_callback(HwCallback callback)
{
    HwCallback old = g0ea6;
    g0ea6 = callback;
    return old;
}

void hw_video(void)
{
    unsigned char mode;
    asm mov ah, 0fh;
    asm int 10h;
    asm mov mode, al;
    switch (mode) {
    case 13:
    case 19:
        g40df = 320;
        g40dd = 200;
        break;
    case 16:
        g40df = 640;
        g40dd = 350;
        break;
    case 18:
        g40df = 640;
        g40dd = 480;
    }
    g40db = g40d7 = 0;
    g40d9 = g40df;
    g40d5 = g40dd;
    if (g0ea3 == -1) {
        asm mov ax, 7;
        asm mov cx, 0;
        asm mov dx, g40df;
        asm int 33h;
        asm mov ax, 8;
        asm mov cx, 0;
        asm mov dx, g40dd;
        asm int 33h;
    }
    hw_position(g40df / 2, g40dd / 2);
}

void hw_position(int x, int y)
{
    x = HW_MAX(g40db, x);
    x = HW_MIN(g40d9, x);
    y = HW_MAX(g40d7, y);
    y = HW_MIN(g40d5, y);
    g40e9 = x;
    g40eb = y;
    if (g0ea3 == -1) {
        asm mov ax, 4;
        asm mov cx, x;
        asm mov dx, y;
        asm int 33h;
    }
}

void hw_get_position(int *x, int *y)
{
    *x = g40e9;
    *y = g40eb;
}

void hw_bounds(int left, int top, int right, int bottom)
{
    int old_x, old_y;
    g40db = HW_MAX(0, left);
    g40d9 = HW_MIN(g40df, right);
    g40d7 = HW_MAX(0, top);
    g40d5 = HW_MIN(g40dd, bottom);
    old_x = g40e9;
    old_y = g40eb;
    g40e9 = HW_MAX(g40e9, g40db);
    g40e9 = HW_MIN(g40e9, g40d9);
    g40eb = HW_MAX(g40eb, g40d7);
    g40eb = HW_MIN(g40eb, g40d5);
    g40ed = g40e9 - old_x;
    g40ef = g40eb - old_y;
    if (g0ea3 == -1) {
        asm mov ax, 7;
        asm mov cx, g40db;
        asm mov dx, g40d9;
        asm int 33h;
        asm mov ax, 8;
        asm mov cx, g40d7;
        asm mov dx, g40d5;
        asm int 33h;
    }
}

int hw_buttons(unsigned char left, unsigned char middle, unsigned char right)
{
    g0ea0 = left;
    g0ea1 = middle;
    g0ea2 = right;
    return 1;
}

int hw_done(void)
{
    unsigned segment = FP_SEG(hw_mouse);
    unsigned callback_offset = FP_OFF(hw_mouse);
    if (g0ea3 == -1) {
        asm mov ax, 0ch;
        asm mov cx, 0;
        asm push es;
        asm mov dx, segment;
        asm mov es, dx;
        asm mov dx, callback_offset;
        asm int 33h;
        asm pop es;
    }
    setvect(9, g40f1);
    return 1;
}

void interrupt hw_keyboard(void)
{
    asm in al, 60h;
    asm mov g40c8, al;
    g40cb = 0;
    if (g0eb4 == 1) {
        g0eb4 = 0;
        g40c9 = 0;
        switch (g40c8) {
        case 0xd3: g40c9 = 1;
        case 0x53: g40c8 = 0x53; goto translated;
        }
        if (!g0eb2) {
            switch (g40c8) {
            case 0xcb: g40c9 = 1;
            case 0x4b: g40c8 = 0x4b; goto translated;
            case 0xcd: g40c9 = 1;
            case 0x4d: g40c8 = 0x4d; goto translated;
            case 0xc8: g40c9 = 1;
            case 0x48: g40c8 = 0x48; goto translated;
            case 0xd0: g40c9 = 1;
            case 0x50: g40c8 = 0x50; goto translated;
            default: goto acknowledge;
            }
        } else {
            switch (g40c8) {
            case 0xcb: g40c9 = 1;
            case 0x4b: g0eaa = !g40c9; break;
            case 0xcd: g40c9 = 1;
            case 0x4d: g0eac = !g40c9; break;
            case 0xc8: g40c9 = 1;
            case 0x48: g0eae = !g40c9; break;
            case 0xd0: g40c9 = 1;
            case 0x50: g0eb0 = !g40c9; break;
            default: goto acknowledge;
            }
            if (g0eaa) {
                if (g0eae) g40c8 = 0x47;
                else if (g0eb0) g40c8 = 0x4f;
                else if (g0eac) g40c8 = 0;
                else {
left:               g40c8 = 0x4b;
                }
            } else if (g0eac) {
                if (g0eae) g40c8 = 0x49;
                else if (g0eb0) g40c8 = 0x51;
                else {
right:              g40c8 = 0x4d;
                }
            } else if (g0eae) {
                if (g0eb0) g40c8 = 0;
                else {
up:                 g40c8 = 0x48;
                }
            } else if (g0eb0) {
down:           g40c8 = 0x50;
            } else g40c8 = g0eb7;
        }
    } else {
        if (g0eb5 == 1) {
            if (g0eb8 < 2) {
                g0eb8++;
                goto acknowledge;
            }
            g0eb5 = 0;
            g0eb8 = 0;
        }
        if (g40c8 == 0xe0) {
            g0eb4 = 1;
            goto acknowledge;
        }
        if (g40c8 == 0xe1) {
            g0eb5 = 1;
            g0eb6 = 0;
        }
        g40c9 = g40c8 & 0x80 ? 1 : 0;
        g40c8 &= 0x7f;
    }
translated:
    if ((g40c8 > 0x46 && g40c8 < 0x52 && (g40c8 & 3) != 2 && g0eb2) ||
        g40c8 == g0ea0 || g40c8 == g0ea1 || g40c8 == g0ea2) {
        switch (hw_lock(1)) { case 0:
        g40cd = g40cf = 0;
        if (g40c9) {
            if (g40c8 == g0ea0 && g40e3 == 1) {
                --g40e3; g40cb = 4;
            }
            if (g40c8 == g0ea1 && g40e5 == 1) {
                --g40e5; g40cb = 64;
            }
            if (g40c8 == g0ea2 && g40e7 == 1) {
                --g40e7; g40cb = 16;
            }
            if (g0eb7 == g40c8) g0eb8 = 1;
            goto acknowledge;
        } else {
            g0eb8 = g0eb8 < 16 ? g0eb8 + 1 : g0eb8;
            g0eb8 = g0eb7 == g40c8 ? g0eb8 : 1;
            g40cb = 1;
            switch (g40c8) {
            case 0x47:
                if (g40e9 - g0eb8 >= g40db) {
                    g40cd = -g0eb8;
                    g40e9 -= g0eb8;
                }
            case 0x48:
                if (g40eb - g0eb8 >= g40d7) {
                    g40cf = -g0eb8;
                    g40eb -= g0eb8;
                }
                break;
            case 0x49:
                if (g40e9 + g0eb8 <= g40d9) {
                    g40cd = g0eb8;
                    g40e9 += g0eb8;
                }
                if (g40eb - g0eb8 >= g40d7) {
                    g40cf = -g0eb8;
                    g40eb -= g0eb8;
                }
                break;
            case 0x4f:
                if (g40e9 - g0eb8 >= g40db) {
                    g40cd = -g0eb8;
                    g40e9 -= g0eb8;
                }
            case 0x50:
                if (g40eb + g0eb8 <= g40d5) {
                    g40cf = g0eb8;
                    g40eb += g0eb8;
                }
                break;
            case 0x4b:
                if (g40e9 - g0eb8 >= g40db) {
                    g40cd = -g0eb8;
                    g40e9 -= g0eb8;
                }
                break;
            case 0x51:
                if (g40eb + g0eb8 <= g40d5) {
                    g40cf = g0eb8;
                    g40eb += g0eb8;
                }
            case 0x4d:
                if (g40e9 + g0eb8 <= g40d9) {
                    g40cd = g0eb8;
                    g40e9 += g0eb8;
                }
                break;
            default:
                if (g40c8 == g0ea0 && g40e3 == 0) { ++g40e3; g40cb = 2; }
                if (g40c8 == g0ea1 && g40e5 == 0) { ++g40e5; g40cb = 32; }
                if (g40c8 == g0ea2 && g40e7 == 0) { ++g40e7; g40cb = 8; }
            }
            g0eb7 = g40c8;
        }
        }
    } else {
        g40e1 = g40c8;
        g40cb = g40c9 ? 0x100 : 0x80;
    }
acknowledge:
    asm in al, 61h;
    asm mov ah, al;
    asm or al, 80h;
    asm out 61h, al;
    asm xchg ah, al;
    asm out 61h, al;
    asm mov al, 20h;
    asm out 20h, al;
    if (g40cb) {
        if (g40cb == 1) {
            g40ed = g40cd;
            g40ef = g40cf;
            hw_position(g40e9, g40eb);
        }
        g0ea6(g40cb, &g40e1);
    }
    hw_lock(0);
    asm sti;
}

void interrupt hw_mouse(unsigned saved_bp, unsigned saved_di, unsigned saved_si,
                        unsigned saved_ds, unsigned saved_es, unsigned saved_dx,
                        unsigned saved_cx, unsigned saved_bx, unsigned saved_ax)
{
    switch (hw_lock(1)) { case 0:
    g40d1 = g40d3 = 0;
    switch (saved_ax) {
    case 2: if (!g40e3) ++g40e3; break;
    case 4: if (g40e3 == 1) --g40e3; break;
    case 8: if (!g40e7) ++g40e7; break;
    case 16: if (g40e7 == 1) --g40e7; break;
    case 32: if (!g40e5) ++g40e5; break;
    case 64: if (g40e5 == 1) --g40e5; break;
    case 1:
        g40d1 = g40e9;
        g40d3 = g40eb;
        g40e9 = saved_cx;
        g40eb = saved_dx;
        g40ed = saved_cx - g40d1;
        g40ef = saved_dx - g40d3;
        break;
    }
    g0ea6(saved_ax, &g40e1);
    hw_lock(0);
    }
    /* INT33 calls this entry with FAR CALL, not a processor interrupt. */
    asm mov ax, saved_ax;
    asm mov bx, saved_bx;
    asm mov cx, saved_cx;
    asm mov dx, saved_dx;
    asm mov es, saved_es;
    asm mov si, saved_si;
    asm mov di, saved_di;
    asm mov ds, saved_ds;
    asm mov sp, bp;
    asm mov bp, saved_bp;
    asm add sp, 18;
    asm retf;
}

unsigned char hw_lock(unsigned char value)
{
    asm xor ah, ah;
    asm mov al, value;
    asm xchg al, g0ea5;
    return _AL;
}

