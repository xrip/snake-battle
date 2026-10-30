
/* Recovered card editor, original 0A0B. */
#include <string.h>
#include "cards.h"

/* Recovered DATA at DS:0570, 1653 bytes. */
typedef struct SB_SB_CARD_DEFAULTS {
    int group_and[5];
    SnkCard card;
    CardCell empty;
    CardCell head;
    int reserved_settings[6];
    Snake snake;
} SB_SB_CARD_DEFAULTS;
typedef char CHECK_sb_card_defaults[(sizeof(SB_SB_CARD_DEFAULTS) == 1653) ? 1 : -1];
SB_SB_CARD_DEFAULTS sb_card_defaults = {
    {1,0,0,1,1},
    {0,3,3,{{{3,0,9},{3,0,9},{3,0,9},{3,0,9},{3,0,9},{3,0,9},{3,0,9}},{{3,0,9},{3,0,9},{3,0,9},{3,0,9},{3,0,9},{3,0,9},{3,0,9}},{{3,0,9},{3,0,9},{3,0,9},{3,0,9},{3,0,9},{3,0,9},{3,0,9}},{{3,0,9},{3,0,9},{3,0,9},{3,0,8},{3,0,9},{3,0,9},{3,0,9}},{{3,0,9},{3,0,9},{3,0,9},{3,0,9},{3,0,9},{3,0,9},{3,0,9}},{{3,0,9},{3,0,9},{3,0,9},{3,0,9},{3,0,9},{3,0,9},{3,0,9}},{{3,0,9},{3,0,9},{3,0,9},{3,0,9},{3,0,9},{3,0,9},{3,0,9}}}},
    {3,0,9},
    {3,0,8},
    {111,333,13,1,1,0},
    {{1,0,1,0,1000,"","","",{"","",""},4},{{0}}}
};



int card_colors[5] = {0, 2, 9, 7, 4};
CardRect card_rects[22] = {
    {29,22,155,106}, {169,22,295,106}, {309,22,435,106},
    {29,120,155,204}, {169,120,295,204}, {309,120,435,204},
    {29,218,155,302}, {169,218,295,302}, {309,218,435,302},
    {477,11,631,34}, {477,36,631,59}, {477,61,631,84},
    {477,86,631,109}, {477,111,631,134}, {477,136,631,159},
    {477,161,631,184}, {477,186,631,209}, {477,211,631,234},
    {477,236,631,259}, {477,261,631,284}, {477,286,631,309},
    {477,311,631,334}
};
int card_actions[17] = {8,7,6,5,4,3,1,0,16,15,0,14,13,12,11,10,9};

Snake card_snake;
int card_current;
int card_modified;
void far *card_background;
void far *card_icons;
void far *card_numbers;
int card_mode;
CardCell card_tool;

void far card_flash_mode(void)
{
    char far *text;
    int x;
    int y;
    int source_x;
    CardRect far *rect;
    unsigned long started;
    started = tick_now();
    rect = &card_rects[20];
    x = rect->left;
    y = rect->top;
    f_0c85_0b83(x, y, button_background, screen_front);
    switch (card_mode) {
    case 0:
        text = resource_names[32];
        source_x = 270;
        break;
    case 1:
        text = resource_names[33];
        source_x = 252;
        break;
    case 2:
        text = resource_names[31];
        source_x = 234;
        break;
    }
    f_0c85_049d(screen_front, x + 38, y + 4, text);
    f_0c85_0bb2(source_x, 0, source_x + 16, 12, card_icons,
               x + 7, y + 5, screen_front);
    tick_wait(started, 5UL);
    card_button(rect, 0);
}

void far card_slot(int index)
{
    CardRect far *rect;
    int x;
    int y;
    rect = &card_rects[index];
    x = rect->left - 7;
    y = rect->top - 7;
    f_0c85_0b83(x, y, card_slot_image, screen_front);
    f_0c85_0bb2(0, index * 13, 42, index * 13 + 11, card_numbers,
               x + 47, y + 71, screen_front);
}

void far card_clear(int index)
{
    CardRect far *rect;
    rect = &card_rects[index];
    f_0c85_0b83(rect->left - 2, rect->top - 2, card_background, screen_front);
}

void far card_cell(int x, int y, int row, int column, char far *cell)
{
    int left;
    int top;
    int source_x;
    int tiles[14] = {13,6,0,3,2,5,4,1,0,8,9,11,10,12};
    left = x + column * 18;
    top = y + row * 12;
    source_x = tiles[cell[2]] * 18;
    if (cell[2] != 9) {
        f_0c85_0ead(left + 1, top + 1, left + 16, top + 10,
                   screen_front, card_colors[cell[0]]);
        f_0c85_0bb2(source_x + 1, 1, source_x + 17, 11, card_tiles,
                   left + 1, top + 1, screen_front);
        if (cell[1])
            source_x = 162;
        else
            return;
    }
    f_0c85_0bb2(source_x + 1, 1, source_x + 17, 11, card_tiles,
               left + 1, top + 1, screen_front);
}

void far card_outline(int x, int y, int group)
{
    int px;
    int py;
    int color;
    color = card_colors[group];
    y++;
    x++;
    px = x - 2;
    for (py = y - 2; py < y; py++) {
        f_0c85_000a(px, py, px + 128, py, color, screen_front);
        f_0c85_000a(px, py + 85, px + 128, py + 85, color, screen_front);
    }
    py = y - 2;
    for (; px < x; px++) {
        f_0c85_000a(px, py, px, py + 86, color, screen_front);
        f_0c85_000a(px + 127, py, px + 127, py + 86, color, screen_front);
    }
}

void far card_draw(int index)
{
    char far *cell;
    CardRect far *rect;
    int x;
    int y;
    int row;
    int column;
    rect = &card_rects[index];
    x = rect->left;
    y = rect->top;
    card_clear(index);
    card_outline(x, y, card_snake.cards[index].group);
    for (row = 0; row < 7; row++) {
        for (column = 0; column < 7; column++) {
            cell = card_snake.cards[index].cell[column][row];
            card_cell(x, y, row, column, cell);
        }
    }
}

void far card_draw_all(void)
{
    int i;
    for (i = 0; i < card_snake.header.card_count; i++)
        card_draw(i);
}

void far card_new(Snake far *snake)
{
    snake->header = default_header;
    fmt_date(snake->header.date);
    if (snake == &card_snake) {
        card_current = 0;
        card_modified = 0;
    }
    memcpy(snake->cards, &default_card, sizeof(SnkCard));
}

void far card_reset_stats(void)
{
    card_snake.header.rating = default_header.rating;
    card_snake.header.rounds = default_header.rounds;
    fmt_date(card_snake.header.date);
}

void far card_button(CardRect far *rect, int selected)
{
    void far *image;
    int x;
    int y;
    x = rect->left + 5;
    y = rect->top + 3;
    if (selected)
        image = button_on;
    else
        image = button_off;
    f_0c85_0b83(x, y, image, screen_front);
}

void far card_group(int group)
{
    int index;
    int x;
    int y;
    CardRect far *rect;
    if (group_and[group])
        index = 19;
    else
        index = 18;
    rect = &card_rects[index];
    x = rect->left + 9;
    y = rect->top + 7;
    f_0c85_0ead(x, y, x + 12, y + 8, screen_front, card_colors[group]);
    card_button(rect, 0);
}

static char card_background_name[] = "opncard.blo";
static char card_numbers_name[] = "1-9.blo";
static char card_icons_name[] = "15-pict.blo";

void far card_edit(void)
{
    int hit;
    int hit_index;
    CardRect far *hit_rect;
    input_hide();
    f_0c85_0f74();
    f_0c85_0958(card_background_name, &card_background);
    f_0c85_0958(card_numbers_name, &card_numbers);
    f_0c85_0958(card_icons_name, &card_icons);
    f_0c85_049d(card_icons, 38, 19, resource_names[34]);
    f_0c85_049d(card_icons, 38, 44, resource_names[34]);
    f_0c85_0ead(22, 14, 442, 309, screen_front, 6);
    card_panel();
    {
        int i;
        int level_icon;
        CardRect far *rect;
        int source_x;
        char far *far *texts;
        int x;
        int y;
        char far *text;
        for (i = 0; i < 9; i++)
            card_slot(i);
        texts = resource_names + 20;
        rect = card_rects + 9;
        source_x = 0;
        for (i = 0; i < 12; i++) {
            x = rect->left;
            y = rect->top;
            f_0c85_0b83(x, y, button_background, screen_front);
            text = *texts;
            level_icon = -1;
            switch (i + 9) {
            case 17:
                if (card_snake.header.editor_level == 0) {
                    text = resource_names[36];
                    level_icon = 1;
                }
                break;
            case 18:
                if (card_snake.header.editor_level == 0) {
                    text = resource_names[36];
                    level_icon = 1;
                }
                break;
            case 19:
                if (card_snake.header.editor_level != 2) {
                    if (card_snake.header.editor_level == 0) {
                        text = resource_names[36];
                        level_icon = 1;
                    } else {
                        text = resource_names[35];
                        level_icon = 2;
                    }
                    break;
                }
                break;
            }
            f_0c85_049d(screen_front, x + 38, y + 4, text);
            if (level_icon == -1)
                f_0c85_0bb2(source_x, 0, source_x + 16, 12, card_icons,
                           x + 7, y + 5, screen_front);
            else
                f_0c85_0b83(x + 7, y + 5, icons_by_level[level_icon], screen_front);
            texts++;
            rect++;
            source_x += 18;
        }
        f_0c85_0bb2(0, 15, 155, 38, card_icons,
                   rect->left, rect->top, screen_front);
    }
    card_mode = 2;
    card_flash_mode();
    card_tool.group = 3;
    card_tool.negate = 0;
    card_tool.tile = -1;
    if (card_snake.header.editor_level == 2)
        card_group(card_tool.group);
    card_draw_all();
    f_0c85_0c0e(22, 14, 442, 309, screen_front, 22, 14, screen_back, 20);
    tick_wait(tick_now(), 4UL);
    f_0c85_0fe1();
    f_0c85_0fb1();
    for (;;) {
    next_event:
        input_poll(1);
        hit = -1;
        hit_rect = card_rects;
        for (hit_index = 0; hit_index <= 21; hit_index++) {
            if (hit_rect->left <= input_state.x &&
                hit_rect->right >= input_state.x &&
                hit_rect->top <= input_state.y &&
                hit_rect->bottom >= input_state.y) {
                hit = hit_index;
                break;
            }
            hit_rect++;
        }
        if (hit == -1)
            goto error;
        if (hit != 21)
            input_buttons = 0;
        switch (hit) {
        case 0: case 1: case 2: case 3: case 4:
        case 5: case 6: case 7: case 8:
            if (hit > card_snake.header.card_count ||
                (hit == card_snake.header.card_count && card_mode != 0)) {
                input_error_beep();
                break;
            }
            switch (card_mode) {
            case 1:
                {
                    int i;
                    f_0c85_078a(cursor_image);
                    card_modified = 1;
                    if (card_snake.header.card_count == 1) {
                        memcpy(card_snake.cards, &default_card, sizeof(SnkCard));
                        card_draw(0);
                    } else {
                        for (i = hit; i < card_snake.header.card_count - 1; i++)
                            memcpy(&card_snake.cards[i], &card_snake.cards[i + 1], sizeof(SnkCard));
                        card_slot(card_snake.header.card_count - 1);
                        card_snake.header.card_count--;
                        for (i = hit; i < card_snake.header.card_count; i++)
                            card_draw(i);
                    }
                    card_mode = 2;
                    card_flash_mode();
                    input_draw();
                }
                break;
            case 0:
                {
                    int i;
                    card_modified = 1;
                    f_0c85_078a(cursor_image);
                    for (i = card_snake.header.card_count; i > hit; i--)
                        memcpy(&card_snake.cards[i], &card_snake.cards[i - 1], sizeof(SnkCard));
                    memcpy(&card_snake.cards[hit], &default_card, sizeof(SnkCard));
                    for (i = hit; i <= card_snake.header.card_count; i++)
                        card_draw(i);
                    card_snake.header.card_count++;
                    /* Preserve the original editor's unreachable back edge.
                     * BC3.1 retains it when lowering this exit to next_event. */
                    for (;;) {
                        card_mode = 2;
                        card_flash_mode();
                        input_draw();
                        goto next_event;
                    }
                }
            case 2:
                {
                    CardCell far *cell;
                    CardCell saved;
                    int anchor_x;
                    int anchor_y;
                    int column;
                    int row;
                    column = (input_state.x - card_rects[hit].left) / 18;
                    row = (input_state.y - card_rects[hit].top) / 12;
                    if (column >= 7) column = 6;
                    if (column < 0) column = 0;
                    if (row >= 7) row = 6;
                    if (row < 0) row = 0;
                    cell = (CardCell far *)card_snake.cards[hit].cell[column][row];
                    anchor_x = card_snake.cards[hit].anchor_x;
                    anchor_y = card_snake.cards[hit].anchor_y;
                    saved = *cell;
                    if (column == anchor_x && row == anchor_y) {
                        if (card_snake.header.editor_level == 2) {
                            SnkCard far *card;
                            char far *group;
                            card = &card_snake.cards[hit];
                            group = &card->group;
                            if (card_tool.tile == 8 || card_tool.tile == -1) {
                                if (*group == card_tool.group)
                                    *group = default_card.group;
                                else
                                    *group = card_tool.group;
                                cell->group = *group;
                            }
                            card_modified = 1;
                            f_0c85_078a(cursor_image);
                            card_outline(card_rects[hit].left, card_rects[hit].top, *group);
                            input_draw();
                        } else
                            input_error_beep();
                    } else if (card_tool.tile == -1) {
                        if (cell->tile != 9) {
                            cell->group = card_tool.group;
                            cell->negate = card_tool.negate;
                        } else
                            input_error_beep();
                    } else if (card_tool.tile != 8) {
                        if (cell->tile == card_tool.tile && cell->group == card_tool.group &&
                            cell->negate == card_tool.negate)
                            *cell = default_empty_cell;
                        else
                            *cell = card_tool;
                    } else if (card_snake.header.editor_level == 2) {
                        SnkCard far *card;
                        CardCell far *old_cell;
                        f_0c85_078a(cursor_image);
                        card = &card_snake.cards[hit];
                        old_cell = (CardCell far *)card->cell[anchor_x][anchor_y];
                        *old_cell = default_empty_cell;
                        card_cell(card_rects[hit].left, card_rects[hit].top,
                                  anchor_y, anchor_x, (char far *)old_cell);
                        card->anchor_x = anchor_x = column;
                        card->anchor_y = anchor_y = row;
                        cell->tile = 8;
                        cell->negate = 0;
                        cell->group = card->group;
                        if (card->group != card_tool.group) {
                            card->group = card_tool.group;
                            cell->group = card->group;
                            card_outline(card_rects[hit].left, card_rects[hit].top, card->group);
                        }
                        input_draw();
                    } else {
                        input_error_beep();
                    }
                    if (cell->tile != saved.tile || cell->group != saved.group ||
                        cell->negate != saved.negate) {
                        card_modified = 1;
                        f_0c85_078a(cursor_image);
                        card_cell(card_rects[hit].left, card_rects[hit].top,
                                  row, column, (char far *)cell);
                        input_draw();
                    }
                }
            }
            break;
        case 9:
            if (card_snake.header.editor_level != 2)
                goto error;
        case 10: case 11: case 12: case 13: case 14: case 15: case 16:
            {
                int tile;
                tile = card_actions[hit - 9];
                f_0c85_078a(cursor_image);
                if (card_tool.tile == tile) {
                    card_tool.tile = -1;
                    card_button(&card_rects[hit], 1);
                } else {
                    if (card_tool.tile != -1)
                        card_button(&card_rects[card_actions[card_tool.tile + 8]], 1);
                    card_button(&card_rects[hit], 0);
                    card_tool.tile = tile;
                }
                input_draw();
            }
            break;
        case 17:
            if (card_snake.header.editor_level == 0 || card_tool.tile == 8)
                input_error_beep();
            else {
                card_tool.negate = !card_tool.negate;
                f_0c85_078a(cursor_image);
                card_button(&card_rects[hit], !card_tool.negate);
                input_draw();
            }
            break;
        case 18: case 19:
            if ((hit == 19 && card_snake.header.editor_level != 2) ||
                (hit == 18 && card_snake.header.editor_level == 0)) {
            error:
                input_error_beep();
                break;
            }
            if (card_snake.header.editor_level == 1) {
                f_0c85_078a(cursor_image);
                if (card_tool.group == 3) {
                    card_tool.group = 2;
                    card_group(card_tool.group);
                } else {
                    card_tool.group = 3;
                    card_button(&card_rects[18], 1);
                }
                input_draw();
            } else {
                int want_and;
                int is_and;
                int index;
                want_and = hit == 19 ? 1 : 0;
                is_and = group_and[card_tool.group];
                if (is_and) index = 19; else index = 18;
                f_0c85_078a(cursor_image);
                card_button(&card_rects[index], 1);
                tick_wait(tick_now(), 2UL);
                do {
                    card_tool.group++;
                    card_tool.group %= 5;
                } while (group_and[card_tool.group] != want_and);
                card_group(card_tool.group);
                input_draw();
            }
            break;
        case 20:
            do {
                card_mode++;
                card_mode = card_mode % 3;
            } while (card_mode == 0 && card_snake.header.card_count >= 9);
            f_0c85_078a(cursor_image);
            card_flash_mode();
            input_draw();
            break;
        case 21:
            {
                CardRect far *rect;
                rect = card_rects + 21;
                f_0c85_078a(cursor_image);
                f_0c85_0bb2(0, 40, 155, 63, card_icons,
                           rect->left, rect->top, screen_front);
                while (input_buttons)
                    ;
                input_draw();
                f_0c85_078a(cursor_image);
                f_0c85_0bb2(0, 15, 155, 38, card_icons,
                           rect->left, rect->top, screen_front);
                input_draw();
                goto done;
            }
        }
    }
 done:
    input_hide();
    f_0c85_0b2f(&card_background);
    f_0c85_0b2f(&card_numbers);
    f_0c85_0b2f(&card_icons);
}


void far card_panel(void)
{
    f_0c85_0ead(468, 0, 636, 349, screen_front, 7);
}

