#ifndef SB_INPUT_H
#define SB_INPUT_H

/* The original large-model ABI.  Names are recovered descriptive names;
   addresses are recorded separately in ui_symbols.json. */
typedef struct InputState {
    int visible;
    int x, y;
    int button;
    int left, top, right, bottom;
} InputState;

extern InputState input_state;
extern int input_buttons;
extern unsigned char input_modifiers, input_key;
extern int sound_enabled;
extern void *screen_front, *cursor_image;

void input_event(unsigned event, unsigned *scan);
void input_save(InputState *saved);
void input_restore(InputState *saved);
void input_set_state_bounds(InputState *saved);
void input_set_bounds(int left, int top, int right, int bottom);
int input_poll(int wait);
void input_draw(void);
void input_hide(void);
void input_init(void);
void input_done(void);
void input_error_beep(void);
void input_click_beep(void);

/* External driver/render interfaces, retained with address-based names until
   their own source modules supply the final semantic names. */
int f_0df6_0005(void (*callback)(unsigned, unsigned *));
void f_0df6_0152(int, int);
void f_0df6_01b5(int *, int *);
void f_0df6_01cc(int, int, int, int);
int f_0df6_0293(int, int, int);
int f_0df6_02ad(void);
void f_0c85_0670(void *);
void f_0c85_0687(void *, int, int);
void f_0c85_078a(void *);
void f_0c85_07d3(void *);

#endif
