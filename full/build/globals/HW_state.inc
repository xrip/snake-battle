/* Recovered BSS at DS:40C8.  The odd word offsets are intentional. */
typedef struct SB_HW_STATE {
    unsigned char scan;
    int x, y;
    int left_count, middle_count, right_count, buttons;
    int min_x, min_y, max_x, max_y;
    int height, width;
    unsigned keyboard_flags;
    int e3, e5, e7, e9, eb, ed, ef;
    void interrupt (*previous_keyboard)(void);
} SB_HW_STATE;
typedef char CHECK_sb_hw_state[(sizeof(SB_HW_STATE) == 45) ? 1 : -1];
SB_HW_STATE sb_hw_state;
