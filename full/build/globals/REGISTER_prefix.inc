/* Recovered DATA at DS:0D76, 6 bytes. */
typedef struct SB_SB_REGISTER_DEFAULTS {
    char *filename;
    int enabled;
} SB_SB_REGISTER_DEFAULTS;
typedef char CHECK_sb_register_defaults[(sizeof(SB_SB_REGISTER_DEFAULTS) == 6) ? 1 : -1];
extern char sb_psw_name[10];
SB_SB_REGISTER_DEFAULTS sb_register_defaults = {
    sb_psw_name,
    1
};
