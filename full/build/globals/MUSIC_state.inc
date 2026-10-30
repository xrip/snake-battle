/* Recovered BSS at DS:19C0, 8 bytes. */
typedef struct SB_SB_MUSIC_STATE {
    unsigned hardware[2];
    void *data;
} SB_SB_MUSIC_STATE;
typedef char CHECK_sb_music_state[(sizeof(SB_SB_MUSIC_STATE) == 8) ? 1 : -1];
SB_SB_MUSIC_STATE sb_music_state;
