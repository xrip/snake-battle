/* Recovered BSS at DS:19C8, 304 bytes. */
typedef struct SB_SB_UI_STATE {
    unsigned char reserved_image[32];
    void *saved_screen;
    int selection_values[7];
    FileNode *files;
    int menu_y[2];
    unsigned char saved_images[6][32];
    void *up;
    void *down;
    void *highlight;
    void *held;
    void *released;
    void *panels[6];
    void *colors;
    int game_mode;
    int unlocked;
    int quit;
} SB_SB_UI_STATE;
typedef char CHECK_sb_ui_state[(sizeof(SB_SB_UI_STATE) == 304) ? 1 : -1];
SB_SB_UI_STATE sb_ui_state;
