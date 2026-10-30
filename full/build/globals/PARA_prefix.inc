/* Recovered DATA at DS:0E78, 39 bytes. */
typedef struct SB_SB_PARA_STRINGS {
    char text_0e78[16];
    char text_0e88[23];
} SB_SB_PARA_STRINGS;
typedef char CHECK_sb_para_strings[(sizeof(SB_SB_PARA_STRINGS) == 39) ? 1 : -1];
SB_SB_PARA_STRINGS sb_para_strings = {
    "not free memory",
    "error in allocmemblock"
};
