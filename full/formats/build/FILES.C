/* Recovered 0B33 file/UI utility module. */
#include <alloc.h>
#include <dir.h>
#include <dos.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "fmtabi.h"

/* Original initialized DGROUP contribution, 0CFE..0D31. */
int fmt_caps = 1;
char fmt_error_format[] = "\n%s\n";
char fmt_error_memory[] = "not enough memory";
char fmt_date_format[13] = "%2d.%2d.%4d";
char fmt_snk_glob[] = "*.snk";
char fmt_dot[] = ".";
char fmt_rb[] = "rb";
char fmt_wb[] = "wb";

void far fmt_fatal(char far *message)
{
    f_0c85_10ee();
    printf(fmt_error_format, message);
    exit(1);
}

void far *far fmt_alloc(unsigned size)
{
    void far *p;
    p = farcalloc(size, 1);
    if (!p)
        fmt_fatal(fmt_error_memory);
    return p;
}

void far fmt_free(void far *p)
{
    farfree(p);
}

void far fmt_date(char far *out)
{
    struct date date;
    char buffer[12];
    getdate(&date);
    sprintf(buffer, fmt_date_format, date.da_day, date.da_mon, date.da_year);
    if (buffer[0] == ' ')
        buffer[0] = '0';
    if (buffer[3] == ' ')
        buffer[3] = '0';
    buffer[6] = 0;
    strcpy(out, buffer);
    strcat(out, buffer + 8);
}

int far fmt_snk_list(SnkFile far *far *out)
{
    int status;
    int length;
    int count = 0;
    SnkFile far *p;
    struct ffblk found;
    *out = 0;
    for (status = findfirst(fmt_snk_glob, &found, 1); status == 0;
         status = findnext(&found)) {
        count++;
        p = fmt_alloc(sizeof(SnkFile));
        p->next = *out;
        p->selected = -1;
        p->score = 0;
        *out = p;
        length = strcspn(found.ff_name, fmt_dot);
        p->name = fmt_alloc(length + 1);
        strncpy(p->name, found.ff_name, length);
        p->name[length] = 0;
    }
    p = *out;
    for (status = 1; p; p = p->next) {
        p->number = status;
        status++;
    }
    return count;
}

int far fmt_key(int timed, int timeout, int letter_case)
{
    Byte key;
    Byte modifiers;
    int buttons;
    int result;
    unsigned long start;
    int shifted;
again:
        start = tick_now();
        buttons = 0;
        modifiers = 0;
        key = 0;
        result = 0;
        while (key == 0 && buttons == 0) {
            if (timed)
                if (!tick_active(start, timeout))
                    goto done;
            key = input_key;
            modifiers = input_modifiers;
            buttons = input_buttons;
        }
        input_key = 0;
        input_buttons = 0;
        if (key == 0x1c || key == 1) {
            result = 0x104;
            goto done;
        }
        if (buttons) {
            result = 0x20;
            goto done;
        }
        if (key == 0x48) {
            result = 0x109;
            goto done;
        }
        if (key == 0x50) {
            result = 0x10a;
            goto done;
        }
        if (key == 0x4b) {
            result = 0x107;
            goto done;
        }
        if (key == 0x4d) {
            result = 0x108;
            goto done;
        }
        if (key == 0x53) {
            result = 0x105;
            goto done;
        }
        if (key == 0x0e) {
            result = 0x106;
            goto done;
        }
        if (key == 1) {
            result = 0x10b;
            goto done;
        }
        if (key == 0x3a) {
            fmt_caps = !fmt_caps;
            goto again;
        }
        if (key > 0x35) {
            input_error_beep();
            goto again;
        }
        {
            shifted = (modifiers != 0) != 0;
            if ((letter_case && ((fmt_caps && !shifted) || (!fmt_caps && shifted)))
                || (!shifted && key >= 1 && key <= 14))
                key += 0x35;
            result = fmt_keymap[key];
            if (result != 0x20)
                goto done;
        }
        input_error_beep();
        goto again;
done:
    return result;
}

#define RESTORE_CELL(index) \
    f_0c85_0bb2(back_x + (index) * 8, back_y, \
        back_x + ((index) + 1) * 8 - 1, back_y + height - 1, back, \
        x + (index) * 8, y, dest)
#define DRAW_CELL(index) \
    if (display && (index) < length) \
        f_0c85_0562(dest, x + (index) * 8, y, text[index])

int far fmt_edit(void far *dest, int x, int y, void far *back,
    int back_x, int back_y, int allow_space, int display, int letter_case,
    int modal, int far *position, int far *exit_key, char far *text,
    int capacity)
{
    int length;
    int pos = *position;
    int height = 13;
    int changed;
    int key;
    int visible;
    int i;
    int timeout;
    length = strlen(text);
    pos = pos < length ? pos : length;
    if (display)
        f_0c85_049d(dest, x, y, text);
    changed = 0;
    if (modal)
        fmt_cursor_enabled = 0;
    for (;;) {
        key = 0;
        visible = 1;
        while (!key) {
            if (visible) {
                f_0c85_0562(dest, x + pos * 8, y, '_');
                timeout = 5;
            } else {
                RESTORE_CELL(pos);
                DRAW_CELL(pos);
                timeout = 1;
            }
            key = fmt_key(1, timeout, letter_case);
            visible = !visible;
        }
        RESTORE_CELL(pos);
        DRAW_CELL(pos);
        if (key == 0x10b && !modal)
            key = 0x104;
        *exit_key = key;
        if (key == 0x104 || key == 0x109 || key == 0x10a || key == 0x10b)
            break;
        if (key == ' ' && !allow_space) {
            input_error_beep();
            continue;
        }
        if (key == 0x106) {
            if (pos > 0) {
                changed = 1;
                for (i = pos - 1; i < length; i++) {
                    text[i] = text[i + 1];
                    RESTORE_CELL(i);
                    DRAW_CELL(i);
                }
                pos--;
                length--;
                continue;
            } else {
                input_error_beep();
                continue;
            }
            break;
        } else if (key == 0x105) {
            if (pos < length) {
                changed = 1;
                for (i = pos; i < length; i++) {
                    text[i] = text[i + 1];
                    RESTORE_CELL(i);
                    DRAW_CELL(i);
                }
                length--;
                continue;
            } else {
                input_error_beep();
                continue;
            }
            break;
        } else if (key == 0x107) {
            if (pos > 0) {
                RESTORE_CELL(pos);
                DRAW_CELL(pos);
                pos--;
            } else
                input_error_beep();
            continue;
        } else if (key == 0x108) {
            if (pos < length) {
                RESTORE_CELL(pos);
                DRAW_CELL(pos);
                pos++;
            } else
                input_error_beep();
            continue;
        } else {
            if (length >= capacity - 1) {
                input_error_beep();
                continue;
            }
            changed = 1;
            length++;
            for (i = length; i > pos; i--) {
                text[i] = text[i - 1];
                RESTORE_CELL(i);
                DRAW_CELL(i);
            }
            text[pos] = key;
            RESTORE_CELL(pos);
            DRAW_CELL(pos);
            if (!modal || length < capacity - 1)
                pos++;
        }
    }
    *position = pos;
    fmt_cursor_enabled = 1;
    return changed;
}

#undef RESTORE_CELL
#undef DRAW_CELL

void far fmt_pause(unsigned seconds)
{
    unsigned long start;
    unsigned long count;
    start = tick_now();
    count = seconds * 18;
    do {
        if (input_buttons != 0 || input_key != 0) {
            input_buttons = 0;
            input_key = 0;
            break;
        }
    } while (tick_active(start, count));
}

int far fmt_load(char far *name, Snake far *far *out)
{
    FILE *fp;
    int result;
    int size;
    int status;
    int allocated;
    Byte seed;
    Byte trailer;
    Byte previous;
    char filename[13];
    SnkHeader header;
    strcpy(filename, name);
    strcat(filename, fmt_snk_suffix);
    fp = fopen(filename, fmt_rb);
    if (fp == NULL)
        goto failed;
        status = fread(&seed, 1, 1, fp);
        if (status == 1)
            status = fread(&header, sizeof(SnkHeader), 1, fp);
        if (status == 1) {
            snk_decode((Byte far *)&header, sizeof(SnkHeader), seed);
            if (header.version == 1) {
                if (header.card_count <= 0 || header.card_count > 9)
                    header.card_count = 1;
                rewind(fp);
                size = sizeof(Snake) - (9 - header.card_count) * sizeof(SnkCard);
                if (!*out) {
                    *out = fmt_alloc(size);
                    allocated = 1;
                } else
                    allocated = 0;
                status = fread(&seed, 1, 1, fp);
                if (status == 1)
                    status = fread(*out, size, 1, fp);
                if (status == 1) {
                    previous = snk_decode((Byte far *)*out, size, seed);
                    status = fread(&trailer, 1, 1, fp);
                    if (status != 1 || previous != trailer)
                        status = 0;
                }
                if (status == 1)
                    result = 1;
                else {
                    result = 0;
                    if (allocated) {
                        farfree(*out);
                        *out = 0;
                    }
                }
            } else
                result = 0;
        } else {
failed:
        result = 0;
        }
    fclose(fp);
    if (result)
        strcpy((*out)->header.name, name);
    return result;
}

int far fmt_save(char far *name, Snake far *snake)
{
    FILE *fp;
    int result;
    int size;
    int status;
    Byte seed;
    Byte trailer;
    Byte previous;
    char filename[13];
    strcpy(filename, name);
    strcat(filename, fmt_snk_suffix);
    fp = fopen(filename, fmt_wb);
    if (fp != NULL) {
        seed = fmt_random(128);
        status = fwrite(&seed, 1, 1, fp);
        if (status == 1) {
            size = sizeof(Snake) - (9 - snake->header.card_count) * sizeof(SnkCard);
            trailer = snk_encode((Byte far *)snake, size, seed);
            status = fwrite(snake, size, 1, fp);
            previous = snk_decode((Byte far *)snake, size, seed);
            if (status == 1)
                status = fwrite(&trailer, 1, 1, fp);
        }
        if (status == 1) {
            result = 1;
            goto done;
        }
    }
    result = 0;
done:
    fclose(fp);
    return result;
}

int far fmt_random(int limit)
{
    int result;
    result = (long)rand() * limit / 32768L;
    if (result < 0)
        result = 0;
    if (result >= limit)
        result = limit - 1;
    return result;
}
