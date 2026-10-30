"""Readable reconstruction of selected Snake Battle 16-bit routines.

This is an independently named translation, not recovered original C text and
not a complete replacement executable. The byte-exact program is the NASM tree.
Evidence addresses are relative MZ CS:IP; add 0x1000+16*CS+IP for a file offset.
The card layout is x-major: index = 7*x+y, with screen y increasing downward.
"""
from __future__ import annotations

from dataclasses import dataclass
import struct
from typing import Sequence


# DS:043C and DS:0444; initialized DS = load-segment + 1679h.
DIRECTIONS = ((0, -1), (1, 0), (0, 1), (-1, 0))
# DS:04B7. 0,3,4 are AND groups; 1,2 are OR groups.
GROUP_IS_AND = (True, False, False, True, True)
IGNORED_SYMBOLS = (8, 9)  # Own head and unconstrained cell.


@dataclass(frozen=True)
class RuleCell:
    group: int
    negate: int
    symbol: int


@dataclass(frozen=True)
class RuleCard:
    group: int
    anchor_x: int
    anchor_y: int
    cells: tuple[RuleCell, ...]

    @classmethod
    def from_bytes(cls, data: bytes) -> "RuleCard":
        if len(data) != 152:
            raise ValueError("A rule card is exactly 152 bytes")
        group, x, y = struct.unpack_from("<Bhh", data)
        cells = tuple(RuleCell(*data[i:i+3]) for i in range(5, 152, 3))
        return cls(group, x, y, cells)

    def to_bytes(self) -> bytes:
        if len(self.cells) != 49:
            raise ValueError("A rule card contains 49 cells")
        return struct.pack("<Bhh", self.group, self.anchor_x, self.anchor_y) + bytes(
            v for c in self.cells for v in (c.group, c.negate, c.symbol))

    def at(self, x: int, y: int) -> RuleCell:
        return self.cells[7*x+y]


@dataclass(frozen=True)
class MatchScore:
    matched: bool = False
    score: int = 0


def mirror_card_x(card: RuleCard) -> RuleCard:
    """0729:000D, file 00829D: reflect x, copy all triplet bytes verbatim."""
    return RuleCard(card.group, 6-card.anchor_x, card.anchor_y,
                    tuple(card.at(6-x, y) for x in range(7) for y in range(7)))


def rotate_card_clockwise(card: RuleCard) -> RuleCard:
    """0729:00B4, file 008344: new[x,y] = old[y,6-x]."""
    return RuleCard(card.group, 6-card.anchor_y, card.anchor_x,
                    tuple(card.at(y, 6-x) for x in range(7) for y in range(7)))


def card_orientations(card: RuleCard) -> tuple[tuple[RuleCard, RuleCard], ...]:
    """0729:015B: normal/mirrored pairs for four clockwise rotations.

    Memory organization in the EXE: 4 slots * 4 rotations * 2 reflections *
    9 cards * 152 = 43,776 bytes. The mirrored half is offset 0x558, one
    rotation 0xAB0 and one snake 0x2AC0.
    """
    normal, mirrored = card, mirror_card_x(card)
    result = []
    for _ in range(4):
        result.append((normal, mirrored))
        normal = rotate_card_clockwise(normal)
        mirrored = rotate_card_clockwise(mirrored)
    return tuple(result)


def match_card(vision: Sequence[Sequence[int]], card: RuleCard) -> MatchScore:
    """0729:1058, file 0092E8: match one oriented card to a 13x13 view.

    vision[x][y] contains symbols relative to the observing snake. The head
    lies at (6,6); the card anchor can be anywhere in its 7x7 area. Only
    the symbol byte of the original 3-byte vision cell is accessed here.
    Valid game data have groups 0..4, negate 0 or 1 and anchors 0..6.
    """
    if not (0 <= card.group < 5 and 0 <= card.anchor_x < 7
            and 0 <= card.anchor_y < 7):
        raise ValueError("Invalid card header")
    if len(vision) != 13 or any(len(column) != 13 for column in vision):
        raise ValueError("Expected a 13x13 x-major vision grid")

    group_seen = [False]*5
    group_scores = [0]*5
    all_groups_required = GROUP_IS_AND[card.group]
    for x in range(7):
        for y in range(7):
            cell = card.at(x, y)
            if cell.symbol in IGNORED_SYMBOLS:
                continue
            if not (0 <= cell.group < 5 and cell.negate in (0, 1)):
                raise ValueError("Invalid rule cell")
            g = cell.group
            actual = vision[6-card.anchor_x+x][6-card.anchor_y+y]
            succeeds = bool((actual == cell.symbol) ^ cell.negate)
            if succeeds:
                # Failure of an AND group is sticky, even if later cells match.
                if not (GROUP_IS_AND[g] and group_seen[g] and group_scores[g] == 0):
                    group_scores[g] += 1
            elif GROUP_IS_AND[g]:
                if all_groups_required:
                    return MatchScore()
                group_scores[g] = 0
            group_seen[g] = True

    total = 0
    for g in range(5):
        if group_seen[g]:
            if all_groups_required and group_scores[g] == 0:
                # The real routine may already have accumulated earlier groups.
                return MatchScore(False, total)
            total += group_scores[g]
    if any(group_seen) and total == 0:
        return MatchScore(False, total)
    # A card containing only ignored symbols is a successful zero-score rule.
    return MatchScore(True, total)


def compare_matches(left: MatchScore, right: MatchScore) -> int:
    """0729:1002: return 0 for worse, 1 for equal, 2 for better.

    Scores of unsuccessful matches are ignored. This detail matters because
    match_card can return an unsuccessful result with a partial positive score.
    """
    if left.matched:
        if right.matched:
            return 0 if left.score < right.score else 1 if left.score == right.score else 2
        return 2
    return 0 if right.matched else 1


def permitted_directions(vision: Sequence[Sequence[int]], previous: int) -> list[bool]:
    """0729:1527..15C3: reject reverse movement and blocked neighbor symbols."""
    result = [True]*4
    result[(previous+2) % 4] = False
    # switch at CS:18DD rejects symbols 1,5,6,7. Codes 2,3,4 are traversable.
    # 0 or >=8 are not rejected by that switch; valid states do not put a head
    # directly ahead except in explicitly blocked configurations.
    for d, (dx, dy) in enumerate(DIRECTIONS):
        if vision[6+dx][6+dy] in (1, 5, 6, 7):
            result[d] = False
    return result


def choose_direction(vision: Sequence[Sequence[int]], previous: int,
                     cards: Sequence[RuleCard], random_start: int = 0) -> tuple[int | None, int | None, bool]:
    """Pure decision part of 0729:143C, excluding replay, rendering and movement.

    Returns (direction, matched-card index or None, reflected). The caller
    supplies the 0..3 random start. The original uses a random starting index
    then scans clockwise to the next eligible direction: this is not uniform
    selection over eligible directions when there are gaps.
    """
    eligible = permitted_directions(vision, previous)
    if not any(eligible):
        return None, None, False
    best = MatchScore()
    matched_card = None
    reflection = [False]*4
    finalists = sum(eligible)
    for card_index, card in enumerate(cards):
        finalists = 0
        for d, pair in enumerate(card_orientations(card)):
            if not eligible[d]:
                continue
            normal, reflected = (match_card(vision, variant) for variant in pair)
            if compare_matches(normal, reflected) == 0:
                candidate, reflection[d] = reflected, True
            else:
                candidate, reflection[d] = normal, False
            order = compare_matches(candidate, best)
            if order == 0:
                eligible[d] = False
            elif order == 1:
                finalists += 1
            else:
                finalists = 1
                best = candidate
                for earlier in range(d):
                    eligible[earlier] = False
        if compare_matches(MatchScore(), best) != 1:
            matched_card = card_index
            break
    # No card match leaves the legal directions eligible.
    d = random_start % 4 if finalists > 1 else 0
    while not eligible[d]:
        d = (d+1) % 4
    return d, matched_card, reflection[d]
