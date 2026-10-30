/* Recovered BSS at DS:19AA, 22 bytes. */
typedef struct SB_SB_INPUT_STATE {
    int sound;
    InputState mouse;
    int buttons;
    unsigned char modifiers;
    unsigned char key;
} SB_SB_INPUT_STATE;
typedef char CHECK_sb_input_state[(sizeof(SB_SB_INPUT_STATE) == 22) ? 1 : -1];
SB_SB_INPUT_STATE sb_input_state;
