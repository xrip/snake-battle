/* Snake Battle: recovered, independently named C89 game data and AI routines.
 * Original machine evidence: SNAKE.EXE CS 0729, DS 1679 (MZ-relative).
 * This file does not claim to be the original author's source text.
 */
#ifndef SB_LOGIC_H
#define SB_LOGIC_H

#ifdef __BORLANDC__
# define SB_FAR far
# pragma option -a-
#else
# define SB_FAR
# pragma pack(push, 1)
#endif

typedef signed char SB_Byte;
typedef short SB_Word;

typedef struct SB_Cell {
    SB_Byte group;
    SB_Byte negate;
    SB_Byte symbol;
} SB_Cell;

typedef struct SB_Card {
    SB_Byte group;
    SB_Word anchor_x;
    SB_Word anchor_y;
    SB_Cell cell[7][7];       /* x first, y second; offset 5 + 21*x + 3*y */
} SB_Card;

typedef struct SB_Match {
    SB_Word matched;
    SB_Word score;
} SB_Match;

typedef SB_Cell SB_View[13][13];

typedef struct SB_BoardCell {
    SB_Word owner;
    SB_Word kind;             /* 0 empty,1 wall,4 tail,6 body,8 head */
} SB_BoardCell;

typedef struct SB_Segment {
    SB_Byte x;
    SB_Byte y;
    SB_Byte direction;
} SB_Segment;

typedef struct SB_SnakeState {
    SB_Word length;
    SB_Word score;
    SB_Word unknown_04;
    SB_Word head_index;
    SB_Segment body[41];
    SB_Word color_index;
    unsigned char sprite_description[32];
} SB_SnakeState;

typedef struct SB_Battle {
    SB_BoardCell board[37][37];
    SB_SnakeState snakes[4];
    SB_Word alive_count;
    SB_Word active_count;
    SB_Word pending_count;
    SB_Word active[4];
    SB_Word pending[4];
    SB_Word moved;
} SB_Battle;

/* Compile-time structure checks work in C89 and original 16-bit Borland. */
typedef char SB_check_cell_size[(sizeof(SB_Cell)==3)?1:-1];
typedef char SB_check_card_size[(sizeof(SB_Card)==152)?1:-1];
typedef char SB_check_match_size[(sizeof(SB_Match)==4)?1:-1];
typedef char SB_check_snake_size[(sizeof(SB_SnakeState)==165)?1:-1];

#ifndef __BORLANDC__
# pragma pack(pop)
#endif

void SB_FAR sb_mirror_x(SB_Card SB_FAR *card);
void SB_FAR sb_rotate_clockwise(SB_Card SB_FAR *card);
void SB_FAR sb_match_card(SB_Cell SB_FAR view[13][13],
                         SB_Card SB_FAR *card, SB_Match SB_FAR *result);
int SB_FAR sb_compare_matches(SB_Match SB_FAR *left, SB_Match SB_FAR *right);

/* Pure decision extraction: excludes original drawing/replay/UI side effects.
 * returns -1 if blocked, otherwise 0 up,1 right,2 down,3 left. */
int SB_FAR sb_choose_direction(SB_Cell SB_FAR view[13][13], int previous,
                               SB_Card SB_FAR *cards, int card_count,
                               int random_start, int SB_FAR *selected_card,
                               int SB_FAR *selected_reflection);
void SB_FAR sb_make_view(SB_BoardCell SB_FAR board[37][37], int slot,
                         int head_x, int head_y, SB_Cell SB_FAR view[13][13]);
void SB_FAR sb_make_board(SB_BoardCell SB_FAR board[37][37],
                          int x0, int y0, int x1, int y1);
void SB_FAR sb_relabel_tail(SB_Battle SB_FAR *battle, int slot);
void SB_FAR sb_trim_tail(SB_Battle SB_FAR *battle, int slot);
void SB_FAR sb_apply_move(SB_Battle SB_FAR *battle, int slot,
                          int direction, int trim_if_empty);
int SB_FAR sb_seed_snake_step(SB_Battle SB_FAR *battle, int slot,
                              int direction, int x, int y);
int SB_FAR sb_select_pending_slot(SB_Battle SB_FAR *battle, int random_start);

#endif
