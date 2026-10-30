/* Recovered BSS at DS:3AC0, 2 bytes. */
typedef struct SB_SB_ASSERT_STATE {
    int enabled;
} SB_SB_ASSERT_STATE;
typedef char CHECK_sb_assert_state[(sizeof(SB_SB_ASSERT_STATE) == 2) ? 1 : -1];
SB_SB_ASSERT_STATE sb_assert_state;
