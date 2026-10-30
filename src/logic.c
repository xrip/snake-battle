/* Recovered C89 semantics; see docs/ARCHITECTURE.md for evidence boundaries.
 * Build for original pointer/int layout with 16-bit Borland large model -ml
 * and byte structure alignment -a-. Four pure routines have verified Borland
 * code generation (matching/README.md); the entire EXE is not reconstructed.
 * No inline assembler, executable byte arrays or binary-embedding shortcuts.
 */
#include "logic.h"
#include <string.h>

static SB_Match sb_no_match = { 0, 0 };
static int sb_dx[4] = { 0, 1, 0, -1 };
static int sb_dy[4] = { -1, 0, 1, 0 };

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

/* Extracted from 0729:1493..1527. The executable only writes symbol bytes;
 * group and negate members of the temporary vision are not consulted. */
void SB_FAR sb_make_view(SB_BoardCell SB_FAR board[37][37], int slot,
                         int head_x, int head_y, SB_Cell SB_FAR view[13][13])
{
    int x, y;
    SB_BoardCell SB_FAR *cell;
    for (x = 0; x < 13; ++x)
        for (y = 0; y < 13; ++y) {
            cell = &board[head_x-6+x][head_y-6+y];
            view[x][y].symbol = (SB_Byte)cell->kind;
            if (cell->kind >= 4 && cell->owner != slot)
                --view[x][y].symbol;
        }
}

/* Decision extraction from 0729:1527..1800.
 * The original caches all orientations (0729:015B). This readable extraction
 * computes two cards locally. Selection order, tie preference and biased
 * circular random search preserve the observed procedure.
 */
int SB_FAR sb_choose_direction(SB_Cell SB_FAR view[13][13], int previous,
                               SB_Card SB_FAR *cards, int card_count,
                               int random_start, int SB_FAR *selected_card,
                               int SB_FAR *selected_reflection)
{
    int eligible[4] = { 1, 1, 1, 1 };
    int reflected[4] = { 0, 0, 0, 0 };
    int d, k, j, candidates, kind, comparison;
    SB_Match normal_score, mirror_score, candidate, best;
    SB_Card normal, mirror;

    *selected_card = -1;
    *selected_reflection = 0;
    eligible[(previous+2)%4] = 0;
    candidates = 3;
    for (d = 0; d < 4; ++d) {
        if (eligible[d]) {
            kind = view[6+sb_dx[d]][6+sb_dy[d]].symbol;
            if (kind == 1 || kind == 5 || kind == 6 || kind == 7) {
                eligible[d] = 0;
                --candidates;
            }
        }
    }
    if (candidates == 0)
        return -1;
    best = sb_no_match;
    for (k = 0; k < card_count; ++k) {
        candidates = 0;
        normal = cards[k];
        mirror = cards[k];
        sb_mirror_x(&mirror);
        for (d = 0; d < 4; ++d) {
            if (eligible[d]) {
                sb_match_card(view, &normal, &normal_score);
                sb_match_card(view, &mirror, &mirror_score);
                if (sb_compare_matches(&normal_score, &mirror_score) == 0) {
                    candidate = mirror_score;
                    reflected[d] = 1;
                } else {
                    candidate = normal_score;
                    reflected[d] = 0;
                }
                comparison = sb_compare_matches(&candidate, &best);
                if (comparison == 0) {
                    eligible[d] = 0;
                } else if (comparison == 1) {
                    ++candidates;
                } else {
                    candidates = 1;
                    best = candidate;
                    for (j = 0; j < d; ++j)
                        eligible[j] = 0;
                }
            }
            sb_rotate_clockwise(&normal);
            sb_rotate_clockwise(&mirror);
        }
        if (sb_compare_matches(&sb_no_match, &best) != 1) {
            *selected_card = k;
            break;
        }
    }
    d = (candidates > 1) ? random_start%4 : 0;
    while (!eligible[d])
        d = (d+1)%4;
    *selected_reflection = reflected[d];
    return d;
}

/* Board-state part of 0729:081C. Drawing the backing surface is excluded. */
void SB_FAR sb_make_board(SB_BoardCell SB_FAR board[37][37],
                          int x0, int y0, int x1, int y1)
{
    int x, y;
    for (x = 0; x <= 36; ++x)
        for (y = 0; y <= 36; ++y)
            board[x][y].kind = (x < x0 || x > x1 || y < y0 || y > y1) ? 1 : 0;
}

/* State portion of 0729:0A8B. 41 is the original circular-buffer capacity. */
void SB_FAR sb_relabel_tail(SB_Battle SB_FAR *battle, int slot)
{
    SB_SnakeState SB_FAR *snake;
    SB_Segment SB_FAR *before;
    SB_Segment SB_FAR *tail;
    int index;
    snake = &battle->snakes[slot];
    index = (snake->head_index + snake->length - 2) % 41;
    before = &snake->body[index];
    tail = &snake->body[(index+1)%41];
    battle->board[tail->x][tail->y].kind = 4;
    tail->direction = before->direction;
}

/* State portion of 0729:0B44; empty-cell owner is deliberately left intact. */
void SB_FAR sb_trim_tail(SB_Battle SB_FAR *battle, int slot)
{
    SB_SnakeState SB_FAR *snake;
    SB_Segment SB_FAR *tail;
    snake = &battle->snakes[slot];
    tail = &snake->body[(snake->head_index+snake->length-1)%41];
    battle->board[tail->x][tail->y].kind = 0;
    --snake->length;
    --snake->score;
    sb_relabel_tail(battle, slot);
}

/* Logical updates in 0729:0BEC..0F26; rendering, timing, sound and teaching
 * UI toggles excluded. Caller must have validated direction/target as the
 * original chooser does. A lone head becomes a nonmoving tail-like residue.
 */
void SB_FAR sb_apply_move(SB_Battle SB_FAR *battle, int slot,
                          int direction, int trim_if_empty)
{
    SB_SnakeState SB_FAR *snake;
    SB_SnakeState SB_FAR *victim;
    SB_Segment SB_FAR *old_head;
    SB_Segment SB_FAR *head;
    SB_Segment SB_FAR *victim_head;
    SB_BoardCell SB_FAR *target;
    int victim_slot;

    snake = &battle->snakes[slot];
    old_head = &snake->body[snake->head_index];
    battle->moved = 1;
    ++snake->length;
    ++snake->score;
    battle->board[old_head->x][old_head->y].kind = 6;
    snake->head_index = (snake->head_index+40)%41;
    head = &snake->body[snake->head_index];
    head->x = (SB_Byte)(old_head->x+sb_dx[direction]);
    head->y = (SB_Byte)(old_head->y+sb_dy[direction]);
    head->direction = (SB_Byte)direction;
    target = &battle->board[head->x][head->y];
    if (target->kind == 4) {
        victim_slot = target->owner;
        victim = &battle->snakes[victim_slot];
        --victim->length;
        --victim->score;
        if (victim->length <= 1) {
            if (victim->length == 1) {
                victim_head = &victim->body[victim->head_index];
                battle->board[victim_head->x][victim_head->y].kind = 4;
            } else {
                --battle->alive_count;
            }
            if (battle->active[victim_slot]) {
                --battle->active_count;
                battle->active[victim_slot] = 0;
            }
            if (battle->pending[victim_slot]) {
                --battle->pending_count;
                battle->pending[victim_slot] = 0;
            }
        }
        if (victim->length > 0)
            sb_relabel_tail(battle, victim_slot);
    } else if (trim_if_empty) {
        sb_trim_tail(battle, slot);
    }
    target->owner = (SB_Word)slot;
    target->kind = 8;
}

/* State part of 0729:18EB: initial entry grows a snake to ten segments. */
int SB_FAR sb_seed_snake_step(SB_Battle SB_FAR *battle, int slot,
                              int direction, int x, int y)
{
    SB_SnakeState SB_FAR *snake;
    SB_Segment SB_FAR *head;
    snake = &battle->snakes[slot];
    if (snake->length == 0) {
        snake->length = 1;
        ++snake->score;
        snake->head_index = 40;
        head = &snake->body[40];
        head->x = (SB_Byte)x;
        head->y = (SB_Byte)y;
        head->direction = (SB_Byte)direction;
    }
    if (snake->length < 10) {
        sb_apply_move(battle, slot, direction, 0);
        return 1;
    }
    sb_relabel_tail(battle, slot);
    return 0;
}

/* Selection portion of 0729:0F27, excluding tick waits and replay I/O.
 * A start index is randomized, then advanced circularly to an eligible slot.
 * A complete sweep schedules each active snake at most once.
 */
int SB_FAR sb_select_pending_slot(SB_Battle SB_FAR *battle, int random_start)
{
    int slot;
    if (!battle->pending_count) {
        for (slot = 0; slot < 4; ++slot)
            battle->pending[slot] = battle->active[slot];
        battle->pending_count = battle->active_count;
    }
    if (!battle->pending_count)
        return -1;
    slot = random_start%4;
    while (!battle->pending[slot])
        slot = (slot+1)%4;
    battle->pending[slot] = 0;
    --battle->pending_count;
    return slot;
}
