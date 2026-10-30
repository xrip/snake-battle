
#include <string.h>

/* Recovered DATA at DS:0094, 52 bytes. */
typedef struct SB_SB_MUSIC_DEFAULTS {
    int available;
    int playing;
    char resource_error[24];
    char suffix[5];
    char error[19];
} SB_SB_MUSIC_DEFAULTS;
typedef char CHECK_sb_music_defaults[(sizeof(SB_SB_MUSIC_DEFAULTS) == 52) ? 1 : -1];
SB_SB_MUSIC_DEFAULTS sb_music_defaults = {
    0,
    0,
    "File isn't in archive: ",
    ".mid",
    "Can not play music"
};

/* Recovered BSS at DS:19C0, 8 bytes. */
typedef struct SB_SB_MUSIC_STATE {
    unsigned hardware[2];
    void *data;
} SB_SB_MUSIC_STATE;
typedef char CHECK_sb_music_state[(sizeof(SB_SB_MUSIC_STATE) == 8) ? 1 : -1];
SB_SB_MUSIC_STATE sb_music_state;


typedef struct GpfEntry {
    char name[13];
    unsigned char method;
    unsigned long offset;
    unsigned packed_size, decoded_size;
} GpfEntry;

extern int music_available, music_playing;
extern unsigned music_hardware[2];
extern void *music_data;
extern char resource_error[], music_suffix[], music_error[];

void f_0b33_0003(char *message);
void *f_0b33_002a(unsigned size);
void f_0b33_0063(void *buffer);
int f_11db_006d(char *name, GpfEntry *entry);
void f_11db_01fa(char *name, int mode, void *buffer);
int f_1341_000c(void *hardware);
void f_1341_001e(void);
void f_1341_0022(void);
void f_1341_0026(void);
int f_1341_002a(int track);
void f_1341_0039(int track);
void f_1341_0057(int track, int fade, int unused);

/* 0431:0000. The original fatal error handler does not return. */
void *music_load_resource(char *name)
{
    void *buffer;
    char message[100];
    GpfEntry entry;
    if (f_11db_006d(name, &entry)) {
        buffer = f_0b33_002a(entry.decoded_size);
        f_11db_01fa(name, 1, buffer);
    } else {
        f_0b33_0003(strcat(strcpy(message, resource_error), name));
    }
    return buffer;
}

void music_detect(void)
{
    if (!f_1341_000c(music_hardware))
        music_available = 1;
}

void music_start(char *name)
{
    char filename[64];
    if (music_available == 1) {
        strcat(strcpy(filename, name), music_suffix);
        music_data = music_load_resource(filename);
        if (f_1341_002a(1) == -1)
            f_0b33_0003(music_error);
        f_1341_0057(1, 0, 0);
        f_1341_0022();
        music_playing = 1;
    }
}

void music_pause(void)
{
    if (music_available == 1) {
        if (music_playing) {
            f_1341_0026();
            music_playing = 0;
        }
        f_1341_0057(1, 101, 0);
    }
}

void music_resume(void)
{
    if (music_available == 1 && !music_playing) {
        f_1341_0057(1, 0, 0);
        f_1341_0022();
        music_playing = 1;
    }
}

/* Separate original function, identical body, retained for link layout. */
void music_stop(void)
{
    if (music_available == 1) {
        if (music_playing) {
            f_1341_0026();
            music_playing = 0;
        }
        f_1341_0057(1, 101, 0);
    }
}

void music_release(void)
{
    if (music_available == 1) {
        if (music_playing) {
            music_playing = 0;
            f_1341_0026();
        }
        f_1341_0039(1);
        f_0b33_0063(music_data);
    }
}

void music_done(void)
{
    if (music_available == 1)
        f_1341_001e();
}

