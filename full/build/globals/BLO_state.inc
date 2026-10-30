/* Recovered BSS at DS:40C0, 8 bytes. */
typedef struct SB_SB_BLO_STATE {
    DriverEntry original;
    DriverEntry current;
} SB_SB_BLO_STATE;
typedef char CHECK_sb_blo_state[(sizeof(SB_SB_BLO_STATE) == 8) ? 1 : -1];
SB_SB_BLO_STATE sb_blo_state;
