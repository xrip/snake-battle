#ifndef SNAKE_FULL_FMTABI_H
#define SNAKE_FULL_FMTABI_H

/* Borland C++ 3.1, DOS large model, byte-aligned structures.
 * These declarations describe the recovered ABI, not a replacement API.
 * Original module addresses and DGROUP offsets are in bindings.json.
 */
typedef unsigned char Byte;

typedef struct SnkCard {
    char group;
    int anchor_x;
    int anchor_y;
    char cell[7][7][3];
} SnkCard;

typedef struct SnkHeader {
    int version;
    int editor_level;
    int card_count;
    int rounds;
    int rating;
    char password[11];
    char name[9];
    char date[10];
    char comment[3][21];
    int color;
} SnkHeader;

typedef struct Snake {
    SnkHeader header;
    SnkCard cards[9];
} Snake;

typedef struct SnkFile {
    char far *name;
    int selected;
    int score;
    int number;
    struct SnkFile far *next;
} SnkFile;

extern int rec_phase;
extern Byte rec_buffer;
extern int rec_mode;
extern int rec_handle;
extern Byte rec_previous;
extern Byte rec_pushed;
extern int rec_push_flag;
extern char rec_error_write[];
extern char rec_error_read[];
extern char rec_error_packed[];

void far fmt_fatal(char far *message);
void far *far fmt_alloc(unsigned size);
void far fmt_free(void far *p);
void far fmt_date(char far *out);
int far fmt_snk_list(SnkFile far *far *out);
int far fmt_key(int timed, int timeout, int letter_case);
int far fmt_edit(void far *dest, int x, int y, void far *back,
    int back_x, int back_y, int allow_space, int display, int letter_case,
    int modal, int far *position, int far *exit_key, char far *text,
    int capacity);
void far fmt_pause(unsigned seconds);
int far fmt_load(char far *name, Snake far *far *out);
int far fmt_save(char far *name, Snake far *snake);
int far fmt_random(int limit);
Byte far snk_encode(Byte far *p, int length, Byte seed);
Byte far snk_decode(Byte far *p, int length, Byte seed);

int far rec_open_read(char far *filename);
void far rec_close_read(void);
int far rec_open_write(char far *filename);
void far rec_close_write(void);
void far rec_packed(void);
void far rec_write_stream(Byte far *p, int count);
void far rec_unget(Byte far *p);
void far rec_read_stream(Byte far *p, int count);
void far rec_write_bytes(Byte far *p, int count);
void far rec_read_bytes(Byte far *p, int count);

extern unsigned long far *tick_pointer;
unsigned long far tick_now(void);
void far tick_wait(unsigned long start, unsigned long count);
int far tick_active(unsigned long start, unsigned long count);

extern int input_buttons;
extern Byte input_modifiers;
extern Byte input_key;
void far input_error_beep(void);
int far input_poll(int wait);
void far input_hide(void);
extern void far *screen_front;
extern void far *screen_back;
extern char far *resource_names[];

extern char fmt_error_format[];
extern char fmt_error_memory[];
extern char fmt_date_format[];
extern char fmt_snk_glob[];
#define fmt_snk_suffix (fmt_snk_glob + 1)
extern char fmt_dot[];
extern char fmt_rb[];
extern char fmt_wb[];
extern char fmt_number_format[];
extern int fmt_caps;
extern char far *fmt_keymap;
extern int fmt_cursor_enabled;

void far f_0c85_10ee(void);
void far f_0c85_0fb1(void);
void far f_0c85_0f74(void);
void far f_0c85_0ead(int, int, int, int, void far *, int);
void far f_0c85_0467(int);
void far f_0c85_049d(void far *, int, int, char far *);
void far f_0c85_0562(void far *, int, int, Byte);
void far f_0c85_0bb2(int, int, int, int, void far *, int, int, void far *);
void far f_0c85_0c0e(int, int, int, int, void far *, int, int, void far *, int);
int far f_0c31_004b(char far *, char far *, ...);
char far *far fmt_number(int value, int width);
void far fmt_about(void);

#endif
