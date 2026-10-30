#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <dos.h>
#include "UI.H"

/* Definitions are kept in their original source order. Unrecovered functions
   are not supplied as dummy bodies; their absence is tracked by the verifier. */

void f_044d_000d(int active)
{
    int y = g19fe[g40b6];
    if (active)
        f_0c85_0b83(476, y, g1ace, screen_front);
    else
        f_0c85_0b83(476, y, g1ad2, screen_front);
}

void f_044d_005b(int x, int y, SnakeHeader *snake)
{
    int i, card_x, card_y;
    f_0c85_0b83(x, y, g197a, g40b8);
    f_0c85_0458();
    f_0c85_049d(g40b8, x + 48, y + 2, snake->name);
    f_0c85_0449();
    f_0c85_05a5(g40b8, x + 14, y + 33, snake->rating);
    f_0c85_049d(g40b8, x + 13, y + 62, snake->comments[0]);
    f_0c85_049d(g40b8, x + 13, y + 73, snake->comments[1]);
    f_0c85_049d(g40b8, x + 13, y + 84, snake->comments[2]);
    f_0c85_0b83(x + 159, y + 7, g197e[snake->level], g40b8);
    for (i = 0; i < snake->cards; ++i) {
        card_x = i % 3 * 20 + 88;
        card_y = i / 3 * 13 + 20;
        f_0c85_0bb2(88, 20, 107, 33, g197a, x + card_x, y + card_y, g40b8);
    }
    f_0c85_0c0e(x, y, x + 186, y + 107, g40b8, x, y, screen_front, 20);
}

void f_044d_022f(char *p)
{
    while (*p) {
        *p = 255 - *p;
        ++p;
    }
}

void f_044d_024d(int editable)
{
    int choice, i, field;
    Rect *rect;
    int line_y[3] = {62, 73, 84};
    f_044d_005b(36, 30, &g34ff.header);
    if (editable) {
        Rect *initial = &g0218[0];
        input_state.x = initial->left;
        input_state.y = initial->top;
        goto process_click;
    }
    for (;;) {
next_event:
    input_poll(1);
process_click:
    input_buttons = 0;
    choice = -1;
    rect = g0218;
    for (i = 0; i <= 4; ++i) {
        if (rect->left <= input_state.x && rect->right >= input_state.x &&
            rect->top <= input_state.y && rect->bottom >= input_state.y) {
            choice = i;
            break;
        }
        ++rect;
    }
    if (choice == -1) {
        input_error_beep();
        input_buttons = 0;
        continue;
    }
    switch (choice) {
    case 0: field = 0; break;
    case 1: field = 1; break;
    case 2: field = 2; break;
    case 4: goto finished;
    case 3:
    default: input_error_beep(); continue;
    }
    if (editable) {
        int position = 1000, key;
        f_0c85_078a(cursor_image);
edit_again:
            if (f_0b33_038b(screen_front, 49, 30 + line_y[field],
                            g197a, 13, line_y[field], 1, 1, 1, 1,
                            &position, &key, g34ff.header.comments[field], 21))
                g34fb = 1;
            switch (key) {
            case 0x109:
                if (--field < 0) field = 2;
                goto edit_again;
            case 0x104:
                if (field == 2) goto done_edit;
            case 0x10a:
                if (++field > 2) field = 0;
                goto edit_again;
            }
done_edit:
        input_draw();
        continue;
    }
invalid:
    input_error_beep();
    continue;
    }
finished:
    f_0c85_078a(cursor_image);
}

Rect g0246[4] = {
    {205, 167, 216, 182},
    {205, 244, 216, 259},
    {36, 156, 221, 273},
    {0, 0, 640, 350}
};

void f_044d_0436(int choice)
{
    int x = g0246[choice].left;
    int y = g0246[choice].top;
    f_0c85_078a(cursor_image);
    f_0c85_0b83(x, y, g1ac2, screen_front);
    while (input_buttons) ;
    f_0c85_0b83(x, y, g1ac6, screen_front);
    input_draw();
}

void f_044d_04b1(int editable)
{
    Cell head = {0, 0, 6};
    Cell blank = {0, 0, 0};
    Rect *rect;
    int choice, color, i, old_cards, snake;
    unsigned long tick;
    int j, history[10];
    Card saved;
    snake = 0;
    f_0729_220a();
    g34d3 = 0;
    color = 0;
    g34d5 = 0;
    old_cards = g34ff.header.cards;
    g34ff.header.cards = 1;
    memcpy(&saved, &g34ff.cards[0], 152);
    memcpy(&g34ff.cards[0], &g057a, 152);
    g34ff.cards[0].cells[3][4] = head;
    g34ff.cards[0].cells[3][2] = blank;
    f_0729_21bf(snake);
    color = g34ff.header.color;
    f_0729_081c(6, 6, 15, 13, 41, 169);
    f_0729_015b();
    f_0729_07c7(snake, color);
    f_0729_198e(snake, 1, 6, 9, 0);
    for (i = 0; i < 10; ++i)
        history[i] = color;
    tick = 0;
redraw:
    f_0729_07c7(snake, color);
next_event:
    choice = input_poll(0);
    if (!choice) {
        if (f_0c10_0033(tick, 2L))
            goto next_event;
        if (f_0c85_087c(cursor_image, 41, 169, 200, 264))
            input_hide();
        f_0729_143c(snake, 1);
        tick = f_0c10_000a();
        for (j = 9; j > 0; --j)
            history[j] = history[j - 1];
        history[0] = color;
        if ((j = history[9]) != color) {
            f_0729_07c7(snake, j);
            f_0729_0a8b(snake);
            goto redraw;
        }
        goto next_event;
    } else {
        choice = -1;
        rect = g0246;
        for (i = 0; i <= 3; ++i) {
            if (rect->left <= input_state.x && rect->right >= input_state.x &&
                rect->top <= input_state.y && rect->bottom >= input_state.y) {
                choice = i;
                break;
            }
            ++rect;
        }
        if (choice == -1) {
            input_error_beep();
            input_buttons = 0;
            goto next_event;
        }
        switch (choice) {
        case 0:
            if (editable) {
                f_044d_0436(choice);
                color = (color + 19) % 20;
                if (color < 4) color = 19;
                g34fb = 1;
                g34ff.header.color = color;
            } else {
                input_error_beep();
                input_buttons = 0;
            }
            goto redraw;
        case 1:
            if (editable) {
                f_044d_0436(choice);
                color = (color + 1) % 20;
                if (color < 4) color = 4;
                g34fb = 1;
                g34ff.header.color = color;
            } else {
                input_error_beep();
                input_buttons = 0;
            }
            goto redraw;
        case 3:
            if (g34ff.header.color != color) {
                g34fb = 1;
                g34ff.header.color = color;
            }
            break;
        default:
            input_buttons = 0;
            input_error_beep();
            goto next_event;
        }
    }
    g34ff.header.cards = old_cards;
    memcpy(&g34ff.cards[0], &saved, 152);
    f_0c85_078a(cursor_image);
    f_0729_2289();
    f_0729_03c7();
}

void f_044d_07fd(int row)
{
    Rect *rect = &g0128[row];
    f_0c85_0b83(22, rect->top, g1996, g1aca);
}

void f_044d_083a(int row, char *name)
{
    Rect *rect = &g0128[row];
    int x;
    x = ((12 - strlen(name)) >> 1) * 8 + 6;
    f_0c85_049d(g1aca, 22 + x, rect->top + 1, name);
}

FileNode *f_044d_0898(int row)
{
    Slot *slot = &g01a0[row];
    FileNode *file = slot->file;
    if (row < 4) {
        --g34e7;
        if (row != 0) {
            f_0b33_0063(g34d7[row]);
        } else {
            g1af2 = 0;
            g1af4 = 0;
        }
        g34d7[row] = 0;
        slot->file = 0;
    }
    slot->empty = 1;
    file->slot = -2;
    return file;
}

void f_044d_0931(int row, FileNode *file)
{
    Slot *slot = &g01a0[row];
    slot->empty = 0;
    slot->file = file;
    if (row < 4) {
        file->slot = row;
        ++g34e7;
        if (row == 0)
            g34d7[0] = &g34ff;
        else
            g34d7[row] = 0;
        if (!f_0b33_0a4c(file->name, &g34d7[row])) {
            if (!g34d7[row])
                g34d7[row] = f_0b33_002a(257);
            f_0a0b_04c8(g34d7[row]);
            strcpy(g34d7[row]->header.name, file->name);
            strcpy(g34d7[row]->header.comments[0], g18c6);
            file->unlocked = 1;
        }
        if (row == 0 && file->unlocked) {
            g1af2 = g1af4 = 1;
        }
    } else {
        file->slot = -1;
    }
}

int f_044d_0a7a(int n)
{
    int page;
    if (n <= 2)
        page = 1;
    else {
        page = (n - 1) / 9 + 1;
        if ((g19f8 - 1) / 9 + 1 == page && (g19f8 - 1) % 9 <= 1)
            --page;
    }
    return page;
}

void f_044d_0abe(int page)
{
    int i;
    FileNode *file;
    for (i = 0; i < g19f4; ++i)
        f_044d_07fd(g19f2 + i);
    if (g19ee != -1)
        f_044d_07fd(g19ee);
    if (g19ec != -1)
        f_044d_07fd(g19ec);
    g19f0 = page;
    if (page == 1) {
        g19f6 = 1;
        g19f2 = 4;
        g19ee = -1;
    } else {
        g19f6 = (page - 1) * 9 + 1;
        if (g19f8 - g19f6 + 1 < 10)
            g19f6 = g19f8 - 9;
        g19f2 = 5;
        g19ee = 4;
    }
    g19f4 = g19f8 - g19f6 + 1;
    if (g19f4 + g19f2 <= 15)
        g19ec = -1;
    else {
        g19f4 = 11 - (g19f2 - 4) - 1;
        g19ec = 14;
    }
    if (g19ec != -1) {
        file = (FileNode *)&g0128[14];
        f_0c85_0b83(55, ((Rect *)file)->top + 4, g199a, g1aca);
    }
    if (g19ee != -1) {
        file = (FileNode *)&g0128[4];
        f_0c85_0b83(55, ((Rect *)file)->top + 4, g199e, g1aca);
    }
    file = g19fa;
    for (i = 1; i < g19f6; ++i)
        file = file->next;
    for (i = 0; i < g19f4; ++i) {
        if (file->slot == -1) {
            f_044d_083a(g19f2 + i, file->name);
            f_044d_0931(g19f2 + i, file);
        } else {
            g01a0[g19f2 + i].empty = 1;
        }
        file = file->next;
    }
}

void f_044d_0c8f(int y)
{
    int *current = &g19fe[g40b6];
    f_0c85_0bb2(0, *current, 154, *current + 26, g1aca,
                476, *current, screen_front);
    *current = y;
}

int f_044d_0ce3(int y, int target, int active)
{
    unsigned long tick;
    int down, moving;
    f_0c85_0fb1();
    down = y > target;
    moving = 1;
    while (moving) {
        if (target == y)
            moving = 0;
        tick = f_0c10_000a();
        f_0c85_0f74();
        if (down) {
            y -= 12;
            if (y < target)
                y = target;
        } else {
            y += 12;
            if (y > target)
                y = target;
        }
        f_044d_0c8f(y);
        f_044d_000d(active);
        f_0c85_0fb1();
        input_click_beep();
        f_0c10_0016(tick, 1L);
    }
    return target;
}

void f_044d_0d88(int y, int row_y, int opening)
{
    int i, frame;
    unsigned long tick;
    for (i = 0; i < 6; ++i) {
        f_0c85_0f74();
        tick = f_0c10_000a();
        frame = opening ? i : 6 - i - 1;
        f_0c85_0b83(498, row_y, g1ad6[frame], screen_front);
        f_0c85_0b83(476, y, g1ad2, screen_front);
        f_0c85_0fb1();
        input_click_beep();
        f_0c10_0016(tick, 2L);
    }
}

void f_044d_0e2f(int y, int row_y, int closing)
{
    int height, target, cut, source_y;
    int moving;
    unsigned long tick;
    if (closing) {
        height = 18;
        target = 1;
    } else {
        height = 1;
        target = 18;
    }
    moving = 1;
    while (moving) {
        tick = f_0c10_000a();
        if (height == target)
            moving = 0;
        f_0c85_0f74();
        f_044d_0c8f(y);
        if (closing) {
            height -= 2;
            if (height < target)
                height = target;
        } else {
            height += 2;
            if (height > target)
                height = target;
        }
        f_0c85_0ead(498, row_y, 607, row_y + 17, screen_front, 0);
        if (height >= 12) {
            cut = 18 - height;
            source_y = row_y;
        } else {
            cut = 6;
            source_y = row_y + 17 - height - 5;
        }
        f_0c85_0bb2(22, source_y, 131, row_y + 17, g1aca,
                    498, row_y - cut, screen_front);
        f_0c85_0bb2(0, height + 1, 109, 17, g1ad6[0],
                    498, row_y + height + 1, screen_front);
        f_0c85_0b83(476, y, g1ad2, screen_front);
        f_0c85_0fb1();
        f_0c10_0016(tick, 1L);
    }
}

FileNode *f_044d_0fa2(int row)
{
    int y;
    FileNode *file;
    y = f_044d_0ce3(g19fe[g40b6], g0128[row].top - 7, 0);
    f_0c10_0016(f_0c10_000a(), 2L);
    f_044d_0e2f(y, y + 7, 1);
    f_0c10_0016(f_0c10_000a(), 2L);
    f_044d_0d88(y, y + 7, 1);
    f_044d_07fd(row);
    file = f_044d_0898(row);
    f_0c10_0016(f_0c10_000a(), 2L);
    return file;
}

void f_044d_105a(int row, FileNode *file)
{
    int y;
    y = f_044d_0ce3(g19fe[g40b6], g0128[row].top - 7, 1);
    f_0c10_0016(f_0c10_000a(), 2L);
    f_044d_0d88(y, y + 7, 0);
    f_0c10_0016(f_0c10_000a(), 2L);
    f_044d_083a(row, file->name);
    f_044d_0e2f(y, y + 7, 0);
    f_044d_0931(row, file);
    f_0c10_0016(f_0c10_000a(), 2L);
    y = f_044d_0ce3(y, 88, 0);
}

int f_044d_112d(int x, int y)
{
    void *surface;
    int i, choice;
    Rect *rect;
    char **name;
    int rx, ry;
    Point point;
    Rect hit[5] = {
        {12, 6, 166, 29}, {12, 31, 166, 54}, {12, 56, 166, 79},
        {0, 0, 184, 116}, {-640, -350, 640, 350}
    };
    f_0c85_0a6a(&surface, 185, 117, 0, 0, 0);
    f_0c85_0e87(surface, 0);
    rect = hit;
    name = g184a;
    for (i = 0; i <= 2; ++i) {
        rx = rect->left;
        ry = rect->top;
        f_0c85_0b83(rx, ry, g1976, surface);
        f_0c85_049d(surface, rx + 38, ry + 4, *name);
        f_0c85_0b83(rx + 7, ry + 5, g197e[i], surface);
        ++rect;
        ++name;
    }
    f_0c85_0c0e(0, 0, 184, 116, surface, x, y, screen_front, 20);
    f_0c85_0fe1();
select_again:
    {
        input_poll(1);
        choice = -1;
        rect = hit;
        for (i = 0; i <= 4; ++i) {
            if (input_state.x - x >= rect->left && rect->right >= input_state.x - x &&
                rect->top <= input_state.y - y && rect->bottom >= input_state.y - y) {
                choice = i;
                break;
            }
            ++rect;
        }
        if (choice == 3 || choice == -1) {
            input_error_beep();
            goto select_again;
        }
    }
    f_0c85_078a(cursor_image);
    if (choice <= 2) {
        point.x = rect->left + x;
        point.y = rect->top + y;
        f_0a0b_053f(&point, 0);
        while (input_buttons) ;
        f_0a0b_053f(&point, 1);
        g34ff.header.level = choice;
    }
    f_0c85_0b2f(&surface);
    if (choice <= 2)
        return 1;
    f_0c85_0c0e(0, 0, 185, 117, g19e8, x, y, screen_front, 20);
    f_0c85_0fe1();
    return 0;
}

void f_044d_136b(void)
{
    f_0c85_0fe1();
    f_0c85_0f74();
    f_0c85_0bb2(0, 88, 154, 350, g1aca, 476, 88, screen_front);
    f_0c85_0fb1();
    f_0c85_0bb2(0, 88, 154, 350, g1aca, 476, 88, g40b8);
}

int f_044d_13d9(int x, int y, int mode, int compact, int restore)
{
    int width, height, attempts;
    void *saved, *surface;
    int setting, position, key;
    char password[11];
    if (!g1af2 || !g1af4) {
        attempts = 0;
        setting = mode == 1;
        g1af2 = 1;
        if (compact) {
            width = 140;
            height = 98;
        } else {
            width = 184;
            height = 116;
        }
        if (restore) {
            f_0c85_0a6a(&saved, width + 1, height + 1, 0, 0, 0);
            f_0c85_0bb2(x, y, x + width, y + height, screen_front, 0, 0, saved);
        }
        f_0c85_0a6a(&surface, width + 1, height + 1, 0, 0, 0);
        f_0c85_0e87(surface, 0);
        f_0c85_0467(2);
        f_0c85_049d(surface, 12, 6, g18ba);
        f_0c85_0467(1);
        f_0c85_0c0e(0, 0, width, height, surface, x, y, screen_front, 20);
again:
        password[0] = 0;
        f_0c85_0458();
        f_0c85_0467(2);
        position = 1000;
        f_0b33_038b(screen_front, x + 12, y + 25, surface, 12, 25,
                    1, setting, 0, 0, &position, &key, password, 11);
        f_0c85_0467(1);
        f_0c85_0449();
        ++attempts;
        if (setting) {
            strcpy(g34ff.header.password, password);
            f_044d_022f(g34ff.header.password);
            g1af4 = 1;
            f_0b33_0c6b(g34ff.header.name, &g34ff);
        } else {
            f_044d_022f(g34ff.header.password);
            position = strcmp(g34ff.header.password, password);
            f_044d_022f(g34ff.header.password);
            if (position != 0) {
                input_error_beep();
                if (attempts < 3) goto again;
                g1af4 = 0;
            } else {
                g1af4 = 1;
            }
        }
        if (restore || !g1af4)
            f_0c85_0c0e(0, 0, width, height, saved, x, y, screen_front, 20);
        if (restore)
            f_0c85_0b2f(&saved);
        f_0c85_0b2f(&surface);
    }
    g01a0[0].file->unlocked = g1af4;
    if (mode == 4) {
        if (g1af4) return 3;
        else return 2;
    } else return 1;
}

/* The original compiler reuses these stack locations between the cursor
   animation, file-name parsing, list search, and creation phases. */
typedef union CreateWork {
    struct {
        int unused, step;
        unsigned long tick;
        int distance, target_y, target_x, y, x;
    } motion;
    struct {
        char unused[10];
        char *extension;
        int index, length;
    } parse;
    struct {
        Slot selected;
        int done;
        FileNode *last;
        int count, found;
    } search;
    struct {
        Rect *rect;
        int i;
        FileNode *created, *last;
        int count, found;
    } create;
} CreateWork;

int f_044d_167e(int x, int y)
{
    int text_x, text_y, source_x, source_y;
    CreateWork work;
    char filename[13];
    if (!g01a0[0].empty)
        return f_044d_13d9(x, y, 4, 0, 0);
    g1af2 = 0;
    text_x = g0128[0].left + 6;
    text_y = g0128[0].top + 1;
    work.motion.x = input_state.x;
    work.motion.y = input_state.y;
    work.motion.target_x = text_x;
    work.motion.target_y = text_y + 14;
    input_draw();
    while (work.motion.x != work.motion.target_x || work.motion.y != work.motion.target_y) {
        work.motion.tick = f_0c10_000a();
        work.motion.distance = abs(work.motion.y - work.motion.target_y) +
                               abs(work.motion.x - work.motion.target_x);
        if (work.motion.x != work.motion.target_x) {
            work.motion.step = abs(work.motion.x - work.motion.target_x) * 20 / work.motion.distance;
            if (work.motion.x > work.motion.target_x) {
                work.motion.x -= work.motion.step;
                if (work.motion.x < work.motion.target_x)
                    work.motion.x = work.motion.target_x;
            } else {
                work.motion.x += work.motion.step;
                if (work.motion.x > work.motion.target_x)
                    work.motion.x = work.motion.target_x;
            }
        }
        if (work.motion.y != work.motion.target_y) {
            work.motion.step = abs(work.motion.y - work.motion.target_y) * 20 / work.motion.distance;
            if (work.motion.y > work.motion.target_y) {
                work.motion.y -= work.motion.step;
                if (work.motion.y < work.motion.target_y)
                    work.motion.y = work.motion.target_y;
            } else {
                work.motion.y += work.motion.step;
                if (work.motion.y > work.motion.target_y)
                    work.motion.y = work.motion.target_y;
            }
        }
        f_0c85_0687(cursor_image, work.motion.x, work.motion.y);
        f_0c10_0016(work.motion.tick, 1L);
    }
    f_0c10_0016(work.motion.tick, 7L);
    f_0c85_078a(cursor_image);
    filename[0] = 0;
enter_name:
    source_x = 28;
    source_y = text_y;
    f_0c85_0bb2(source_x, source_y, source_x + 103, source_y + 13,
                g1aca, text_x, text_y, screen_front);
    f_0c85_0bb2(source_x, source_y, source_x + 103, source_y + 13,
                g1aca, text_x, text_y, g40b8);
    f_0c85_0458();
    work.parse.length = 1000;
    f_0b33_038b(screen_front, text_x, text_y, g1aca, source_x, source_y,
                0, 1, 0, 0, &work.parse.length, &work.parse.index, filename, 13);
    f_0c85_0449();
    if (filename[0]) {
        work.parse.length = strlen(filename);
        work.parse.extension = filename;
        for (work.parse.index = 0; work.parse.index < work.parse.length; ++work.parse.index) {
            if (*work.parse.extension++ == '.') {
                if (!(strcmp(work.parse.extension, g02ab) & strcmp(work.parse.extension, g02af) &
                      strcmp(work.parse.extension, g02b3) & strcmp(work.parse.extension, g02b7) &
                      strcmp(work.parse.extension, g02bb) & strcmp(work.parse.extension, g02bf) &
                      strcmp(work.parse.extension, g02c3) & strcmp(work.parse.extension, g02c7) &
                      strcmp(work.parse.extension, g02cb))) {
                    if (g34e7) goto bad_extension;
                    if (f_0e92_0008(filename)) {
                        g40ff = 1;
                        _ES = FP_SEG(f_0e92_0008);
                        f_0729_2327(filename);
                        g40ff = 0;
                        f_0e92_005c();
                        return 5;
                    } else input_error_beep();
                    goto enter_name;
                } else if (!strcmp(work.parse.extension, g02cf)) {
                    filename[work.parse.index] = 0;
                    f_0c85_0bb2(source_x, source_y, source_x + 103, source_y + 13,
                                g1aca, text_x, text_y, screen_front);
                    break;
                } else {
bad_extension:
                    input_error_beep();
                    goto enter_name;
                }
            }
        }
        if (strlen(filename) >= 9) {
            input_error_beep();
            filename[8] = 0;
            goto enter_name;
        }
    }
    if (filename[0]) {
        work.search.found = 0;
        work.search.count = 0;
        work.search.last = g19fa;
        if (work.search.last) {
            work.search.done = 0;
            while (!work.search.done) {
                ++work.search.count;
                if (!strcmp(filename, work.search.last->name)) {
                    work.search.done = 1;
                    work.search.found = 1;
                } else if (!work.search.last->next) {
                    work.search.done = 1;
                } else work.search.last = work.search.last->next;
            }
        }
        if (work.search.found) {
            f_0c85_0bb2(source_x, source_y, source_x + 103, source_y + 13,
                        g1aca, text_x, text_y, screen_front);
            f_0c85_0bb2(source_x, source_y, source_x + 103, source_y + 13,
                        g1aca, text_x, text_y, g40b8);
            if (work.search.last->slot >= 0) return 0;
            {
                if (work.search.count < g19f6 || work.search.count >= g19f6 + g19f4) {
                    f_044d_0abe(f_044d_0a7a(work.search.count));
                    f_044d_136b();
                }
                work.search.done = work.search.count - g19f6 + 4;
                work.search.selected = g01a0[work.search.done];
                f_044d_0fa2(work.search.done);
                f_044d_105a(0, work.search.selected.file);
                return 1;
            }
        } else {
            f_0a0b_04c8(&g34ff);
            if (!f_044d_112d(x, y)) goto enter_name;
            ++g19f8;
            work.create.created = f_0b33_002a(sizeof(FileNode));
            work.create.created->next = 0;
            work.create.created->slot = 0;
            work.create.created->unlocked = 0;
            if (!work.create.last) g19fa = work.create.created;
            else work.create.last->next = work.create.created;
            work.create.created->name = f_0b33_002a(strlen(filename) + 1);
            strcpy(work.create.created->name, filename);
            strcpy(g34ff.header.name, filename);
            f_0b33_0c6b(g34ff.header.name, &g34ff);
            f_044d_083a(0, work.create.created->name);
            f_044d_0931(0, work.create.created);
            work.create.rect = &g0128[0];
            f_0c85_0bb2(22, work.create.rect->top,
                        work.create.rect->right - work.create.rect->left, work.create.rect->bottom,
                        g1aca, work.create.rect->left, work.create.rect->top, screen_front);
            f_0c85_0bb2(22, work.create.rect->top,
                        work.create.rect->right - work.create.rect->left, work.create.rect->bottom,
                        g1aca, work.create.rect->left, work.create.rect->top, g40b8);
            f_044d_0abe(g19f0);
            for (work.create.i = 0; work.create.i < 2; ++work.create.i) {
                f_0c85_0f74();
                f_0c85_0b83(476, 0, g1aca, screen_front);
                f_044d_000d(0);
                f_0c85_0fb1();
            }
            return f_044d_13d9(x, y, 1, 0, 0);
        }
    } else return 0;
}

void f_044d_1dbb(void)
{
    char **text = g1826;
    Point *point = &g00c8[4];
    int i;
    text = g183a;
    for (i = 4; i <= 7; ++i) {
        if (i != 6)
            f_0c85_049d(screen_front, point->x, point->y - 3, *text);
        ++text;
        ++point;
    }
}

void f_044d_1e23(Slot *first, Slot *second)
{
    FileNode *b = second->file;
    FileNode *a = first->file;
    int i;
    Slot *slot;
    FileNode saved_b = *b;
    FileNode saved_a = *a;
    if (second->index >= 4 || first->index >= 4) {
        *b = saved_a;
        *a = saved_b;
        b->next = saved_b.next;
        b->unknown8 = saved_b.unknown8;
        a->next = saved_a.next;
        a->unknown8 = saved_a.unknown8;
        second->file = a;
        first->file = b;
        for (i = 0, slot = g01a0; i < 4; ++i, ++slot) {
            if (!slot->empty) {
                if (slot->file == b && second->index >= 4)
                    slot->file = a;
                else if (slot->file == a && first->index >= 4)
                    slot->file = b;
            }
        }
    }
}

void f_044d_1f7d(void *surface, Rect *rect, char *text)
{
    f_0c85_0e87(surface, 0);
    f_0c85_049d(surface, 8, 14, text);
    f_0c85_0c0e(0, 0, rect->right - rect->left, rect->bottom - rect->top,
                surface, rect->left, rect->top, screen_front, 20);
}

void f_044d_1fe8(Rect *rect)
{
    char extension[4];
    int position, key;
    FILE *file;
    unsigned char cipher;
    unsigned i;
    int length;
    unsigned char check;
    unsigned char surface[32];
    char filename[16], password[16];
    f_0c85_0467(2);
    f_0c85_0b4f(rect->left, rect->top, rect->right, rect->bottom, g40b8, surface);
    f_044d_1f7d(surface, rect, g18e2);
    filename[0] = 0;
    position = 0;
    f_0b33_038b(screen_front, rect->left + 8, rect->top + 28, surface, 8, 28,
                0, 1, 1, 1, &position, &key, filename, 10);
    if (key == 0x10b) return;
    f_044d_1f7d(surface, rect, g18e6);
    strcpy(extension, g02b1);
    position = 2;
    for (;;) {
        f_0b33_038b(screen_front, rect->left + 8, rect->top + 28, surface, 8, 28,
                    0, 1, 1, 1, &position, &key, extension, 4);
        if (!atoi(extension) && key != 0x10b)
            input_error_beep();
        else
            break;
    }
    if (key == 0x10b) return;
    f_044d_1f7d(surface, rect, g18ea);
    password[0] = 0;
    position = 0;
    f_0c85_0458();
    f_0b33_038b(screen_front, rect->left + 8, rect->top + 28, surface, 8, 28,
                0, 1, 1, 1, &position, &key, password, 15);
    f_0c85_0449();
    if (key == 0x10b) return;
    strcat(strcat(filename, g02d3), extension);
    f_044d_1f7d(surface, rect, g18ee);
    f_0c85_049d(screen_front, rect->left + 8, rect->top + 28, filename);
    file = fopen(filename, g02d5);
    if (!file) {
        f_0c85_049d(screen_front, rect->left + 8, rect->top + 42, g18f2);
        while (!input_buttons) ;
    } else {
        cipher = 0x7f;
        for (i = 0; i < strlen(password); ++i)
            cipher ^= password[i];
        length = sizeof(Snake) - (9 - g34ff.header.cards) * 152;
        check = f_0b2b_000f(&g34ff, length, cipher);
        fwrite(&g34ff, length, 1, file);
        fwrite(&check, 1, 1, file);
        f_0b2b_0046(&g34ff, length, cipher);
        while (!input_buttons) ;
    }
    fclose(file);
    f_0c85_0467(1);
}

void f_044d_2332(void)
{
}

typedef struct DefaultPlan { char name[10]; } DefaultPlan;
typedef struct AlternativePlan { char name[11]; } AlternativePlan;
int g0294 = 0;
static AlternativePlan alternative_plan = {"rplan2.blo"};
static DefaultPlan default_plan = {"plan2.blo"};

typedef union MenuWork {
    struct {
        InputState mouse;
        int source, y, destination;
        Slot selected;
    } drag;
    struct { char unused[26]; Rect *rect; } init;
    struct { char unused[16]; int result; Rect *rect; } create;
    struct { char unused[20]; void *surface; Rect *rect; int result; } dialog;
    struct { char unused[26]; int mode; } password;
} MenuWork;

void f_044d_2333(void)
{
    int choice, i;
    Rect *rect;
    int holding = 0;
    Slot held;
    char *plan;
    DefaultPlan normal;
    MenuWork work;
    AlternativePlan alternative;
    alternative = alternative_plan;
    normal = default_plan;
    g40ff = 0;
    g4101 = 0;
    sound_enabled = 1;
    music_start(g02d8);
    music_pause();
    f_0c85_0a6a(&g19e8, 185, 117, 0, 0, 0);
    f_0c85_0f00(g02dd, &g19a6, 5);
    f_0c85_0f00(g02e7, &g19a2, 5);
    f_0c85_0f00(g02f3, &g1992, 5);
    f_0c85_0f00(g02fe, &g197e[0], 5);
    f_0c85_0f00(g0309, &g197e[1], 5);
    f_0c85_0f00(g0316, &g197e[2], 5);
    f_0c85_0958(g0321, &g199e);
    f_0c85_0958(g032b, &g199a);
    f_0c85_0958(g0337, &g1976);
    if (!g1af6) {
        f_0c85_0958(g0342, &g197a);
        f_0c85_0958(g034f, &g198e);
        plan = alternative.name;
    } else {
        f_0c85_0958(g0343, &g197a);
        f_0c85_0958(g0350, &g198e);
        plan = normal.name;
    }
    f_0c85_0f00(g035c, &g1ac2, 5);
    f_0c85_0f00(g0368, &g1ac6, 5);
    f_0c85_0f00(g0373, &g1ad2, 5);
    f_0c85_0f00(g037f, &g1ace, 5);
    f_0c85_0958(g038c, &g1aee);
    for (i = 0; i < 6; ++i) {
        g1ad6[i] = g1a02[i];
        f_0c85_0b4f(0, i * 17, 109, (i + 1) * 17, g1aee, g1ad6[i]);
    }
    f_0c85_0fb1();
    f_0c85_0f74();
    f_0c85_09ea(g0398, screen_front);
    f_0c85_0c0e(0, 0, 640, 350, screen_front, 0, 0, g40b8, 20);
    f_0a0b_04c8(&g34ff);
    work.init.rect = &g0128[0];
    f_0c85_0a6a(&g1996, 110, 18, 0, 0, 0);
    f_0c85_0bb2(work.init.rect->left, work.init.rect->top,
                work.init.rect->right, work.init.rect->bottom,
                screen_front, 0, 0, g1996);
    f_0c85_0a6a(&g1aca, 155, 350, 0, 0, 0);
    f_0c85_0bb2(476, 0, 630, 350, screen_front, 0, 0, g1aca);
    g19f8 = f_0b33_00e8(&g19fa);
    g19fe[g40b6] = 350;
    g19fe[(g40b6 + 1) % 2] = 350;
    f_0729_0794();
    g19ee = -1;
    g19ec = -1;
    f_044d_0abe(1);
    f_044d_0ce3(350, 88, 0);
    f_0b33_09f4(5);
    /* Preserve Borland 3.1's explicit transfer into the redraw block. */
    do { break; } while (1);
redraw:
    f_0c85_0f74();
    f_0c85_09ea(plan, screen_front);
    f_044d_1dbb();
    f_0c85_0b83(476, 0, g1aca, screen_front);
    f_044d_000d(0);
    f_0c85_0c0e(22, 14, 442, 309, screen_front, 22, 14, g40b8, 20);
    f_0c10_0016(f_0c10_000a(), 2L);
    f_0c85_0fe1();
    f_0c85_0fb1();
    f_044d_2332();
    for (;;) {
next_event:
        input_poll(1);
        choice = -1;
        rect = g00e8;
        for (i = 0; i < 23; ++i) {
            if (rect->left <= input_state.x && rect->right >= input_state.x &&
                rect->top <= input_state.y && rect->bottom >= input_state.y) {
                choice = i;
                break;
            }
            ++rect;
        }
        if (choice == -1) { input_error_beep(); continue; }
        if (choice >= 8) {
            work.drag.selected = g01a0[choice - 8];
            if (choice == g19ee + 8 || choice == g19ec + 8) {
                input_buttons = 0;
                f_044d_0abe(choice == g19ee + 8 ? g19f0 - 1 : g19f0 + 1);
                f_0c85_078a(cursor_image);
                f_0c85_0f74();
                f_0c85_0b83(476, 0, g1aca, screen_front);
                f_044d_000d(holding);
                f_0c85_0fb1();
                f_0c85_0fe1();
                input_draw();
                continue;
            }
            if (choice - 8 >= g19f2 + g19f4) { input_error_beep(); continue; }
            if (holding) {
                work.drag.destination = choice - 8;
                if (work.drag.selected.empty) {
                    if (work.drag.selected.index >= 4)
                        f_044d_1e23(&work.drag.selected, &held);
                    f_0c85_078a(cursor_image);
                    f_044d_105a(work.drag.destination, held.file);
                } else {
                    work.drag.source = held.index;
                    f_0c85_078a(cursor_image);
                    work.drag.y = f_044d_0ce3(g19fe[g40b6], g00e8[choice].top - 7, 1);
                    f_0c10_0016(f_0c10_000a(), 2L);
                    f_044d_0d88(work.drag.y, work.drag.y + 7, 0);
                    f_0c10_0016(f_0c10_000a(), 2L);
                    f_044d_0d88(work.drag.y, work.drag.y + 7, 1);
                    f_0c10_0016(f_0c10_000a(), 2L);
                    f_044d_0898(work.drag.destination);
                    f_044d_1e23(&held, &work.drag.selected);
                    f_044d_07fd(work.drag.destination);
                    f_044d_083a(work.drag.destination, held.file->name);
                    f_044d_0931(work.drag.destination, held.file);
                    if (work.drag.source >= 4) {
                        work.drag.source = work.drag.selected.file->unknown8;
                        if (work.drag.source < g19f6 || work.drag.source >= g19f6 + g19f4) {
                            work.drag.y = f_044d_0ce3(work.drag.y, 88, 1);
                            f_044d_0abe(f_044d_0a7a(work.drag.source));
                            f_044d_136b();
                            f_0c10_0016(f_0c10_000a(), 2L);
                        }
                        work.drag.source = g19f2 + work.drag.source - g19f6;
                    }
                    f_044d_105a(work.drag.source, work.drag.selected.file);
                }
                input_draw();
                holding = 0;
                input_set_state_bounds(&work.drag.mouse);
                continue;
            } else {
                if (choice == 8 && work.drag.selected.empty) {
                    work.create.rect = &g00e8[1];
                    f_0c85_0bb2(work.create.rect->left, work.create.rect->top,
                                work.create.rect->right, work.create.rect->bottom,
                                screen_front, 0, 0, g19e8);
                    work.create.result = f_044d_167e(work.create.rect->left, work.create.rect->top);
                    if (work.create.result == 5) goto redraw;
                    else if (!work.create.result) continue;
                    else {
                        f_0c85_0c0e(0, 0, 185, 117, g19e8,
                                    work.create.rect->left, work.create.rect->top, screen_front, 20);
                        f_0c85_0fe1();
                    }
                } else if (!work.drag.selected.empty) {
                    held = work.drag.selected;
                    f_0c85_078a(cursor_image);
                    f_044d_0fa2(choice - 8);
                    if (choice >= 12)
                        f_044d_0ce3(g19fe[g40b6], 88, 1);
                    input_draw();
                    holding = 1;
                    input_save(&work.drag.mouse);
                    input_set_bounds(g0128[0].left, g0128[0].top, g0128[14].right, g0128[14].bottom);
                    continue;
                } else { input_error_beep(); continue; }
            }
            continue;
        } else {
            input_hide();
            switch (choice) {
            case 7: goto finished;
            case 1:
                if (g34e7) {
                    f_0729_2327((char *)work.dialog.rect);
                    g4101 = 0;
                    goto redraw;
                }
            case 0:
            case 2:
            case 3:
            case 6:
                if (choice == 6) work.dialog.rect = &g00e8[2];
                else work.dialog.rect = &g00e8[choice];
                f_0c85_0bb2(work.dialog.rect->left, work.dialog.rect->top,
                            work.dialog.rect->right, work.dialog.rect->bottom,
                            screen_front, 0, 0, g19e8);
                switch (work.dialog.result = f_044d_167e(work.dialog.rect->left, work.dialog.rect->top)) {
                case 0: input_error_beep(); continue;
                case 1: break;
                case 5: goto redraw;
                case 2:
                case 3:
                    switch (choice) {
                    case 3:
                        if (work.dialog.result == 3) {
                            f_0a0b_0619();
                            break;
                        } else goto restore_dialog;
                    case 2:
                        f_0c85_0958(g03a2, &work.dialog.surface);
                        f_0c85_0c0e(0, 0, 186, 107, work.dialog.surface, 36, 160, screen_front, 20);
                        f_044d_04b1(work.dialog.result == 3 ? 1 : 0);
                        f_0c85_0b2f(&work.dialog.surface);
                        break;
                    case 0:
                        f_044d_024d(work.dialog.result == 3 ? 1 : 0);
                        break;
                    case 6:
                        if (work.dialog.result != 3) input_error_beep();
                        else f_044d_1fe8(work.dialog.rect);
                        break;
                    }
                    if (g34fb) {
                        if (choice == 3) f_0a0b_0526();
                        f_0b33_0c6b(g34ff.header.name, &g34ff);
                        g34fb = 0;
                    }
                    if (choice == 3) goto redraw;
                    break;
                }
restore_dialog:
                f_0c85_0c0e(0, 0, 185, 117, g19e8,
                            work.dialog.rect->left, work.dialog.rect->top, screen_front, 20);
                f_0c85_0fe1();
                continue;
            case 4:
                f_0b1d_0003();
                goto redraw;
            case 5:
                work.password.mode = g1af2 && g1af4 ? 1 : 4;
                if (g01a0[0].empty || work.password.mode != 1) goto invalid;
                g1af2 = 0;
                f_044d_13d9(g00e8[3].left, g00e8[3].top, work.password.mode, 0, 1);
                continue;
invalid:
                input_error_beep();
                continue;
            }
        }
    }
finished:
    music_resume();
    music_release();
}
