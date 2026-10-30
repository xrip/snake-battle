#ifndef SNAKE_FULL_CARDS_H
#define SNAKE_FULL_CARDS_H
#include "fmtabi.h"

typedef struct CardRect {
    int left, top, right, bottom;
} CardRect;
typedef struct CardCell {
    char group, negate, tile;
} CardCell;
typedef struct InputState {
    int visible;
    int x, y;
    int button;
    int left, top, right, bottom;
} InputState;

extern int card_colors[5];
extern CardRect card_rects[22];
extern int card_actions[17];
/* BC3.1 emits uninitialized objects in reverse declaration order. */
extern Snake card_snake;
extern int card_current;
extern int card_modified;
extern void far *card_background;
extern void far *card_icons;
extern void far *card_numbers;
extern int card_mode;
extern CardCell card_tool;
extern SnkHeader default_header;
extern SnkCard default_card;
extern int group_and[5];
extern void far *button_background;
extern void far *card_slot_image;
extern void far *card_tiles;
extern void far *button_off;
extern void far *button_on;
extern void far *icons_by_level[];
extern void far *cursor_image;
extern InputState input_state;
extern CardCell default_empty_cell;

void far card_flash_mode(void);
void far card_slot(int index);
void far card_clear(int index);
void far card_cell(int x, int y, int row, int column, char far *cell);
void far card_outline(int x, int y, int group);
void far card_draw(int index);
void far card_draw_all(void);
void far card_new(Snake far *snake);
void far card_reset_stats(void);
void far card_button(CardRect far *rect, int selected);
void far card_group(int group);
void far card_edit(void);
void far card_panel(void);

void far f_0c85_0b83(int, int, void far *, void far *);
void far f_0c85_000a(int, int, int, int, int, void far *);
void far f_0c85_0958(char far *, void far *far *);
void far f_0c85_0b2f(void far *far *);
void far f_0c85_078a(void far *);
void far f_0c85_0fe1(void);
void far input_draw(void);
#endif
