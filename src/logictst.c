/* Run original-machine-code test vectors with the reconstructed C core.
 * Borland C++ 3.1: bcc -ml -a- -k -elogictst.exe logictst.c logic.c
 * The vectors are produced by tools/make_logic_vectors.py from SNAKE.EXE.
 */
#include "logic.h"
#include <stdio.h>
#include <string.h>

static SB_Card card, expected_card;
static SB_View view;
static SB_Match result, expected_result, left, right;

static int read_exact(FILE *fp, void *p, unsigned n)
{
    return fread(p, 1, n, fp) == n;
}

int main(int argc, char **argv)
{
    FILE *fp;
    char magic[4];
    unsigned short total, i, expected_comparison;
    int kind, ok, actual_comparison;
    if (argc != 2) { puts("Usage: logictst LOGIC.VEC"); return 2; }
    fp = fopen(argv[1], "rb");
    if (!fp) return 3;
    if (!read_exact(fp, magic, 4) || memcmp(magic, "SBV1", 4) ||
        !read_exact(fp, &total, 2)) { fclose(fp); return 4; }
    for (i = 0; i < total; ++i) {
        kind = fgetc(fp); ok = 0;
        if (kind == 1 || kind == 2) {
            if (!read_exact(fp, &card, 152) ||
                !read_exact(fp, &expected_card, 152)) break;
            if (kind == 1) sb_mirror_x(&card);
            else sb_rotate_clockwise(&card);
            ok = memcmp(&card, &expected_card, 152) == 0;
        } else if (kind == 3) {
            if (!read_exact(fp, view, 507) || !read_exact(fp, &card, 152) ||
                !read_exact(fp, &expected_result, 4)) break;
            sb_match_card(view, &card, &result);
            ok = memcmp(&result, &expected_result, 4) == 0;
        } else if (kind == 4) {
            if (!read_exact(fp, &left, 4) || !read_exact(fp, &right, 4) ||
                !read_exact(fp, &expected_comparison, 2)) break;
            actual_comparison = sb_compare_matches(&left, &right);
            ok = (unsigned short)actual_comparison == expected_comparison;
        }
        if (!ok) {
            printf("FAIL vector %u kind %d\n", i, kind);
            fclose(fp); return 1;
        }
    }
    if (i != total || fgetc(fp) != EOF || ferror(fp)) {
        printf("FAIL vector stream at %u\n", i); fclose(fp); return 1;
    }
    fclose(fp);
    printf("PASS %u vectors against original 16-bit machine code.\n", total);
    return 0;
}
