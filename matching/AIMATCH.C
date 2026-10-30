/* Recovered C89 semantics; see docs/ARCHITECTURE.md for evidence boundaries.
 * Build for original pointer/int layout with 16-bit Borland large model -ml
 * and byte structure alignment -a-. Four pure routines have verified Borland
 * code generation (matching/README.md); the entire EXE is not reconstructed.
 * No inline assembler, executable byte arrays or binary-embedding shortcuts.
 */
#include "logic.h"
#include <string.h>

static SB_Match sb_no_match = { 0, 0 };

/* 0729:000D (file 0x829D), complete routine. */
void SB_FAR sb_mirror_x(SB_Card SB_FAR *card)
{
    int x, y;
    SB_Card temporary;
    temporary.group = card->group;
    temporary.anchor_y = card->anchor_y;
    temporary.anchor_x = 6 - card->anchor_x;
    for (x = 0; x < 7; ++x)
        for (y = 0; y < 7; ++y)
            temporary.cell[x][y] = card->cell[6-x][y];
    memcpy(card, &temporary, sizeof(SB_Card));
}

/* 0729:00B4 (file 0x8344), complete routine. */
void SB_FAR sb_rotate_clockwise(SB_Card SB_FAR *card)
{
    int x, y;
    SB_Card temporary;
    temporary.group = card->group;
    temporary.anchor_x = 6 - card->anchor_y;
    temporary.anchor_y = card->anchor_x;
    for (x = 0; x < 7; ++x)
        for (y = 0; y < 7; ++y)
            temporary.cell[6-x][y] = card->cell[y][x];
    memcpy(card, &temporary, sizeof(SB_Card));
}

/* 0729:1002 (file 0x9292), complete routine. */
int SB_FAR sb_compare_matches(SB_Match SB_FAR *left, SB_Match SB_FAR *right)
{
    int difference;
    if (left->matched) {
        if (right->matched) {
            if ((difference = left->score - right->score) < 0)
                return 0;
            else if (difference == 0)
                return 1;
            else
                return 2;
        } else {
            return 2;
        }
    } else {
        if (right->matched)
            return 0;
        return 1;
    }
}

/* 0729:1058 (file 0x92E8), complete routine for valid game cards.
 * Locals deliberately follow observed stack order, simplifying compiler work.
 * Input values have groups 0..4, negate 0/1, anchors 0..6, symbols 0..9.
 */
void SB_FAR sb_match_card(SB_Cell SB_FAR view[13][13],
                         SB_Card SB_FAR *card, SB_Match SB_FAR *result)
{
    int x, y, require_all;
    SB_Cell SB_FAR *rule_cell;
    SB_Cell SB_FAR *observed;
    int seen[5] = { 0, 0, 0, 0, 0 };
    int scores[5] = { 0, 0, 0, 0, 0 };
    int is_and[5] = { 1, 0, 0, 1, 1 };
    SB_Byte group;
    SB_Byte symbol;

    *result = sb_no_match;
    require_all = is_and[card->group];
    rule_cell = &card->cell[0][0];
    for (x = 0; x < 7; ++x) {
        observed = &view[6-card->anchor_x+x][6-card->anchor_y];
        for (y = 0; y < 7; ++y) {
            symbol = rule_cell->symbol;
            if (symbol != 9 && symbol != 8) {
                group = rule_cell->group;
                if ((observed->symbol == symbol) ^ rule_cell->negate) {
                    if (!(is_and[group] && seen[group] && scores[group] == 0))
                        ++scores[group];
                } else if (is_and[group]) {
                    if (require_all)
                        return;
                    scores[group] = 0;
                }
                seen[group] = 1;
            }
            ++rule_cell;
            ++observed;
        }
    }
    y = 0;
    for (x = 0; x < 5; ++x) {
        if (seen[x]) {
            if (require_all && scores[x] == 0)
                return;
            result->score += scores[x];
            ++y;
        }
    }
    if (y == 0 || result->score != 0)
        result->matched = 1;
}

