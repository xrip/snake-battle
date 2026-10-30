/* Recovered DATA at DS:0D8E, 35 bytes. */
typedef struct SB_SB_REGISTER_STRINGS {
    char text_0d8e[3];
    char text_0d91[6];
    char text_0d97[3];
    char text_0d9a[10];
    char text_0da4[10];
    char text_0dae[3];
} SB_SB_REGISTER_STRINGS;
typedef char CHECK_sb_register_strings[(sizeof(SB_SB_REGISTER_STRINGS) == 35) ? 1 : -1];
char sb_psw_name[10] = "snake.psw";
SB_SB_REGISTER_STRINGS sb_register_strings = {
    "\\*",
    "*.exe",
    "rb",
    "passw.rus",
    "passw.eng",
    "wb"
};
