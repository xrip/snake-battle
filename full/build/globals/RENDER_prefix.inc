/* Recovered DATA at DS:0DB2, 4 bytes. */
typedef struct SB_SB_RENDER_DEFAULTS {
    int update;
    int active;
} SB_SB_RENDER_DEFAULTS;
typedef char CHECK_sb_render_defaults[(sizeof(SB_SB_RENDER_DEFAULTS) == 4) ? 1 : -1];
SB_SB_RENDER_DEFAULTS sb_render_defaults = {
    0,
    1
};
