


/* Recovered BSS at DS:1826, 388 bytes. */
typedef struct SB_SB_MAIN_STATE {
    char *text[84];
    void *button_background;
    void *passport;
    void *level[3];
    void *game_board;
    void *slot;
    void *tiles;
    void *menu;
    void *panel;
    void *cassette;
    void *button_off;
    void *button_on;
} SB_SB_MAIN_STATE;
typedef char CHECK_sb_main_state[(sizeof(SB_SB_MAIN_STATE) == 388) ? 1 : -1];
SB_SB_MAIN_STATE sb_main_state;

/* Main translation unit; original image entry 03EF:0003. */
extern int game_quit;
extern char resource_names[];
void f_0c85_1009(void);
void f_0c85_01a2(void *, int);
void f_0c85_0449(void);
void f_044d_2333(void);
void f_0c85_10ee(void);

void main(void)
{
    game_quit = 0;
    f_0c85_1009();
    f_0c85_01a2(resource_names, 84);
    f_0c85_0449();
    f_044d_2333();
    f_0c85_10ee();
}

