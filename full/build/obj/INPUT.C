
#include <dos.h>
#include "INPUT.H"


/* Recovered BSS at DS:19AA, 22 bytes. */
typedef struct SB_SB_INPUT_STATE {
    int sound;
    InputState mouse;
    int buttons;
    unsigned char modifiers;
    unsigned char key;
} SB_SB_INPUT_STATE;
typedef char CHECK_sb_input_state[(sizeof(SB_SB_INPUT_STATE) == 22) ? 1 : -1];
SB_SB_INPUT_STATE sb_input_state;


/* Original module at image 03F23..0430F, 1005 bytes. */
void input_event(unsigned event, unsigned *scan)
{
    int key = *scan;
    if (event & 0x54)
        input_buttons = 0;
    else if (event & 0x2a)
        input_buttons = 1;
    else if (event == 0x80) {
        if (key == 0x36 || key == 0x2a)
            input_modifiers |= 2;
        else if (key == 0x38)
            input_modifiers |= 1;
        else if (key == 0x1d)
            input_modifiers |= 4;
        else {
            input_key = key;
            if (key == 0x1c)
                input_buttons = 1;
        }
    }
    else if (event == 0x100) {
        if (key == 0x36 || key == 0x2a)
            input_modifiers &= ~2;
        else if (key == 0x38)
            input_modifiers &= ~1;
        else if (key == 0x1d)
            input_modifiers &= ~4;
        else {
            input_key = 0;
            if (key == 0x1c)
                input_buttons = 0;
        }
    }
}

void input_save(InputState *saved)
{
    *saved = input_state;
}

void input_restore(InputState *saved)
{
    input_hide();
    input_state = *saved;
    f_0df6_01cc(input_state.left, input_state.top,
                input_state.right, input_state.bottom);
    f_0df6_0152(input_state.x, input_state.y);
    if (input_state.visible)
        input_poll(0);
}

void input_set_state_bounds(InputState *saved)
{
    input_state.left = saved->left;
    input_state.right = saved->right;
    input_state.top = saved->top;
    input_state.bottom = saved->bottom;
    f_0df6_01cc(input_state.left, input_state.top,
                input_state.right, input_state.bottom);
}

void input_set_bounds(int left, int top, int right, int bottom)
{
    input_state.left = left;
    input_state.right = right;
    input_state.top = top;
    input_state.bottom = bottom;
    f_0df6_01cc(input_state.left, input_state.top,
                input_state.right, input_state.bottom);
}

int input_poll(int wait)
{
    int x, y, moved;
    if (input_state.visible)
        input_draw();
    do {
        input_state.button = input_buttons;
        f_0df6_01b5(&x, &y);
        moved = 0;
        if (!input_state.visible ||
            x < input_state.x || x > input_state.x ||
            y < input_state.y || y > input_state.y) {
            moved = 1;
            input_state.x = x;
            input_state.y = y;
            input_state.visible = 1;
            f_0c85_0670(screen_front);
            input_draw();
            f_0c85_0687(cursor_image, input_state.x, input_state.y);
        }
    } while ((!input_state.button && wait) || moved);
    return input_state.button;
}

void input_draw(void)
{
    f_0c85_0670(screen_front);
    f_0c85_07d3(cursor_image);
}

void input_hide(void)
{
    if (input_state.visible) {
        input_state.visible = !input_state.visible;
        f_0c85_078a(cursor_image);
    }
}

void input_init(void)
{
    input_key = 0;
    input_buttons = 0;
    input_modifiers = 0;
    f_0df6_0005(input_event);
    f_0df6_0293(0x39, 0x39, 0x39);
    input_state.visible = 0;
    f_0df6_01b5(&input_state.x, &input_state.y);
    input_state.left = 0;
    input_state.right = 620;
    input_state.top = 0;
    input_state.bottom = 340;
    f_0df6_01cc(input_state.left, input_state.top,
                input_state.right, input_state.bottom);
}

void input_done(void)
{
    f_0df6_02ad();
}

void input_error_beep(void)
{
    int repeats, frequency, first, last, step, on_time, off_time;
    input_buttons = 0;
    if (sound_enabled) {
        repeats = 1;
        first = 111;
        last = 222;
        step = 13;
        on_time = 1;
        off_time = 0;
        while (repeats) {
            --repeats;
            for (frequency = first; frequency < last; frequency += step) {
                sound(frequency);
                delay(on_time);
            }
            nosound();
            delay(off_time);
        }
    }
}

void input_click_beep(void)
{
    int repeats, frequency, first, last, step, on_time, off_time;
    input_buttons = 0;
    if (sound_enabled) {
        repeats = 1;
        first = 111;
        last = 112;
        step = 13;
        on_time = 1;
        off_time = 0;
        while (repeats) {
            --repeats;
            for (frequency = first; frequency < last; frequency += step) {
                sound(frequency);
                delay(on_time);
            }
            nosound();
            delay(off_time);
        }
    }
}

