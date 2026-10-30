/* Recovered DATA at DS:0D3A, 60 bytes. */
typedef struct SB_SB_ASSERT_STRINGS {
    char text_0d3a[4];
    char text_0d3e[17];
    char text_0d4f[8];
    char text_0d57[7];
    char text_0d5e[6];
    char text_0d64[18];
} SB_SB_ASSERT_STRINGS;
typedef char CHECK_sb_assert_strings[(sizeof(SB_SB_ASSERT_STRINGS) == 60) ? 1 : -1];
SB_SB_ASSERT_STRINGS sb_assert_strings = {
    "%s\n",
    "%s violation: %s",
    "REQUIRE",
    "ENSURE",
    "CHECK",
    "Exception : %s %s"
};
