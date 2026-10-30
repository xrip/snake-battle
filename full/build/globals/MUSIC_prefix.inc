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
