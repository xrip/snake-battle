/* Recovered BSS at DS:3BC2, 128 bytes. */
typedef struct SB_SB_REGISTER_STATE {
    Stamp cache[15];
    Challenge *challenge;
    ChallengeList *list;
} SB_SB_REGISTER_STATE;
typedef char CHECK_sb_register_state[(sizeof(SB_SB_REGISTER_STATE) == 128) ? 1 : -1];
SB_SB_REGISTER_STATE sb_register_state;
