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
