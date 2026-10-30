/* Recovered initialized hardware state at DS:0EA0; packed by BCC -a-. */
typedef struct SB_HW_DATA {
    unsigned char left_key, middle_key, right_key;
    int mouse_installed;
    unsigned char locked;
    HwCallback callback;
    int left_held, middle_held, right_held, button_mask;
    int cursor_enabled;
    unsigned char modifier, scan, scan_ready, extended, active;
} SB_HW_DATA;
typedef char CHECK_sb_hw_data[(sizeof(SB_HW_DATA) == 25) ? 1 : -1];
SB_HW_DATA sb_hw_data = {
    0x52, 0, 0x53, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1
};
