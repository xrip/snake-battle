/* Recovered DATA at DS:0E4C, 43 bytes. */
typedef struct SB_SB_BLO_STRINGS {
    char text_0e4c[3];
    char text_0e4f[21];
    char text_0e64[16];
    char text_0e74[3];
} SB_SB_BLO_STRINGS;
typedef char CHECK_sb_blo_strings[(sizeof(SB_SB_BLO_STRINGS) == 43) ? 1 : -1];
SB_SB_BLO_STRINGS sb_blo_strings = {
    "rb",
    "game not full. file ",
    "wrong game file",
    "wb"
};
