/* GAMOS Packed File / Snake Battle 2.3 codec.
 * Original decoder: SNAKE.EXE file 1438D..1441A, image 1338D..1341A.
 * Entry reader: file12E1D; screen framing: file132AA.
 * Recovered C implementation, not the original author's source text.
 * Uses only C89 and an at-least-32-bit unsigned long for file offsets.
 */
#include "gpfcodec.h"
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

#define N 4096U
#define F 18U
#define NIL N
#define MASK 4095U

static GpfU16 get16(const GpfU8 *p)
{
    return (GpfU16)(p[0] | ((GpfU16)p[1] << 8));
}
static GpfU32 get32(const GpfU8 *p)
{
    return (GpfU32)p[0] | ((GpfU32)p[1] << 8) |
           ((GpfU32)p[2] << 16) | ((GpfU32)p[3] << 24);
}
static void put16(GpfU8 *p, GpfU16 v)
{
    p[0] = (GpfU8)v; p[1] = (GpfU8)(v >> 8);
}
static void put32(GpfU8 *p, GpfU32 v)
{
    p[0] = (GpfU8)v; p[1] = (GpfU8)(v >> 8);
    p[2] = (GpfU8)(v >> 16); p[3] = (GpfU8)(v >> 24);
}

int gpf_lzss_decode(const GpfU8 GPF_FAR *source, GpfU16 source_size,
                    GpfU8 GPF_FAR *target, GpfU16 target_capacity,
                    GpfU16 *target_size)
{
    GpfU8 *ring;
    GpfU16 r, in_pos, out_pos, flags, bit, token, length, pos, i;
    GpfU8 value;
    ring = (GpfU8 *)malloc(N);
    if (ring == NULL) return -1;
    memset(ring, 32, N - F);
    memset(ring + N - F, 0, F);
    /* Original initializes only N-F bytes; supplied streams do not refer to
       the final F bytes before writing them during the same decoder call. */
    r = N - F; in_pos = out_pos = 0;
    while (in_pos < source_size) {
        flags = source[in_pos++];
        for (bit = 1; bit <= 128U && in_pos < source_size; bit <<= 1) {
            if ((flags & bit) != 0) {
                if (out_pos == target_capacity) { free(ring); return -1; }
                value = source[in_pos++];
                target[out_pos++] = value;
                ring[r] = value; r = (r + 1) & MASK;
            } else {
                if ((GpfU32)in_pos + 2UL > source_size) { free(ring); return -1; }
                token = (GpfU16)(source[in_pos] | ((GpfU16)source[in_pos + 1] << 8));
                in_pos += 2;
                pos = token & MASK; length = (token >> 12) + 3;
                if ((GpfU32)out_pos + length > target_capacity) { free(ring); return -1; }
                for (i = 0; i < length; ++i) {
                    value = ring[(pos + i) & MASK];
                    target[out_pos++] = value;
                    ring[r] = value; r = (r + 1) & MASK;
                }
            }
        }
    }
    *target_size = out_pos;
    free(ring);
    return 0;
}

/* Match-tree workspace is heap allocated: fits one 16-bit segment and avoids
 * overflowing a typical DOS stack. The ordered search/tie rules are part of
 * the byte-exact compressed representation, not only decoding semantics. */
typedef struct MatchTree {
    GpfU8 text[N + F - 1];
    GpfU16 left[N + 1], right[N + 257], parent[N + 1];
    GpfU16 match_position, match_length;
} MatchTree;

static void insert_node(MatchTree *t, GpfU16 r)
{
    GpfU16 p, i;
    int comparison;
    comparison = 1; p = N + 1 + t->text[r];
    t->right[r] = t->left[r] = NIL; t->match_length = 0;
    for (;;) {
        if (comparison >= 0) {
            if (t->right[p] != NIL) p = t->right[p];
            else { t->right[p] = r; t->parent[r] = p; return; }
        } else {
            if (t->left[p] != NIL) p = t->left[p];
            else { t->left[p] = r; t->parent[r] = p; return; }
        }
        for (i = 1; i < F; ++i) {
            comparison = (int)t->text[r + i] - (int)t->text[p + i];
            if (comparison != 0) break;
        }
        if (i > t->match_length) {
            t->match_position = p; t->match_length = i;
            if (i >= F) break;
        }
    }
    t->parent[r] = t->parent[p];
    t->left[r] = t->left[p]; t->right[r] = t->right[p];
    t->parent[t->left[p]] = t->parent[t->right[p]] = r;
    if (t->right[t->parent[p]] == p) t->right[t->parent[p]] = r;
    else t->left[t->parent[p]] = r;
    t->parent[p] = NIL;
}

static void delete_node(MatchTree *t, GpfU16 p)
{
    GpfU16 q;
    if (t->parent[p] == NIL) return;
    if (t->right[p] == NIL) q = t->left[p];
    else if (t->left[p] == NIL) q = t->right[p];
    else {
        q = t->left[p];
        if (t->right[q] != NIL) {
            do { q = t->right[q]; } while (t->right[q] != NIL);
            t->right[t->parent[q]] = t->left[q];
            t->parent[t->left[q]] = t->parent[q];
            t->left[q] = t->left[p]; t->parent[t->left[p]] = q;
        }
        t->right[q] = t->right[p]; t->parent[t->right[p]] = q;
    }
    t->parent[q] = t->parent[p];
    if (t->right[t->parent[p]] == p) t->right[t->parent[p]] = q;
    else t->left[t->parent[p]] = q;
    t->parent[p] = NIL;
}

int gpf_lzss_encode(const GpfU8 GPF_FAR *source, GpfU16 source_size,
                    GpfU8 GPF_FAR *target, GpfU16 target_capacity,
                    GpfU16 *target_size)
{
    MatchTree *tree;
    GpfU8 group[17], c;
    GpfU16 r, s, i, in_pos, out_pos, available, mask, group_size, last, token;
    if (source_size == 0) { *target_size = 0; return 0; }
    tree = (MatchTree *)malloc(sizeof(MatchTree));
    if (tree == NULL) return -1;
    memset(tree->text, 0, sizeof(tree->text));
    memset(tree->text, 32, N - F);
    for (i = 0; i <= N; ++i) tree->left[i] = tree->parent[i] = NIL;
    for (i = 0; i < N + 257; ++i) tree->right[i] = NIL;
    tree->match_position = tree->match_length = 0;
    r = N - F; s = 0;
    available = source_size < F ? source_size : F;
    for (i = 0; i < available; ++i) tree->text[r + i] = source[i];
    in_pos = available; out_pos = 0;
    for (i = 1; i <= F; ++i) insert_node(tree, r - i);
    insert_node(tree, r);
    group[0] = 0; group_size = mask = 1;
    while (available != 0) {
        if (tree->match_length > available) tree->match_length = available;
        if (tree->match_length <= 2) {
            tree->match_length = 1; group[0] |= (GpfU8)mask;
            group[group_size++] = tree->text[r];
        } else {
            token = tree->match_position | ((tree->match_length - 3) << 12);
            group[group_size++] = (GpfU8)token;
            group[group_size++] = (GpfU8)(token >> 8);
        }
        mask <<= 1;
        if (mask == 256) {
            if ((GpfU32)out_pos + group_size > target_capacity) { free(tree); return -1; }
            for (i = 0; i < group_size; ++i) target[out_pos++] = group[i];
            group[0] = 0; group_size = mask = 1;
        }
        last = tree->match_length; i = 0;
        while (i < last && in_pos < source_size) {
            c = source[in_pos++]; delete_node(tree, s); tree->text[s] = c;
            if (s < F - 1) tree->text[s + N] = c;
            s = (s + 1) & MASK; r = (r + 1) & MASK;
            insert_node(tree, r); ++i;
        }
        while (i < last) {
            delete_node(tree, s); s = (s + 1) & MASK; r = (r + 1) & MASK;
            --available;
            if (available != 0) insert_node(tree, r);
            ++i;
        }
    }
    if (group_size > 1 && (GpfU32)out_pos + group_size > target_capacity) { free(tree); return -1; }
    if (group_size > 1)
        for (i = 0; i < group_size; ++i) {
            if (out_pos == target_capacity) { free(tree); return -1; }
            target[out_pos++] = group[i];
        }
    *target_size = out_pos; free(tree); return 0;
}

int gpf_blo_pixel(const GpfU8 GPF_FAR *data, GpfU16 data_size,
                  GpfU16 x, GpfU16 y, GpfU8 *color)
{
    GpfU16 width, height, stride, plane, bit, value, origin;
    GpfU32 address;
    if (data_size < 32) return -1;
    width = (GpfU16)(data[0] | ((GpfU16)data[1] << 8));
    height = (GpfU16)(data[2] | ((GpfU16)data[3] << 8));
    stride = (GpfU16)(data[4] | ((GpfU16)data[5] << 8));
    if (x >= width || y >= height || (data[6] & 0xD8) != 0x18) return -1;
    x += data[6] & 7; bit = 7 - (x & 7); value = 0;
    for (plane = 0; plane < 4; ++plane) {
        origin = (GpfU16)(data[8 + 2 * plane] | ((GpfU16)data[9 + 2 * plane] << 8));
        address = (GpfU32)origin * 16UL + (GpfU32)y * stride + x / 8 + data[7];
        if (address >= data_size) return -1;
        value = (value << 1) | ((data[(GpfU16)address] >> bit) & 1);
    }
    *color = (GpfU8)value; return 0;
}

int gpf_read_header(FILE *input, GpfHeader *header)
{
    static const unsigned char magic[19] = "\032GAMOS PACKED FILE";
    if (fseek(input, 0L, SEEK_SET) != 0 ||
        fread(header->raw, 1, GPF_HEADER_BYTES, input) != GPF_HEADER_BYTES ||
        memcmp(header->raw, magic, 19) != 0) return -1;
    header->member_count = get16(header->raw + 23);
    return 0;
}
int gpf_read_entry(FILE *input, GpfEntry *entry)
{
    GpfU8 raw[GPF_ENTRY_BYTES];
    if (fread(raw, 1, GPF_ENTRY_BYTES, input) != GPF_ENTRY_BYTES) return -1;
    memcpy(entry->name, raw, 13); entry->method = raw[13];
    entry->file_offset = get32(raw + 14);
    entry->packed_size = get16(raw + 18); entry->decoded_size = get16(raw + 20);
    return 0;
}
void gpf_write_entry_bytes(const GpfEntry *entry, GpfU8 target[GPF_ENTRY_BYTES])
{
    memcpy(target, entry->name, 13); target[13] = entry->method;
    put32(target + 14, entry->file_offset);
    put16(target + 18, entry->packed_size); put16(target + 20, entry->decoded_size);
}
int gpf_find_entry(FILE *input, const GpfHeader *header,
                   const char *name, GpfEntry *entry)
{
    GpfU16 i, j;
    if (fseek(input, GPF_HEADER_BYTES, SEEK_SET) != 0) return -1;
    for (i = 0; i < header->member_count; ++i) {
        if (gpf_read_entry(input, entry) != 0) return -1;
        for (j = 0; j < 13; ++j) {
            if (toupper((unsigned char)name[j]) != toupper((unsigned char)entry->name[j])) break;
            if (name[j] == 0) return 0;
        }
    }
    return -1;
}
int gpf_extract_entry(FILE *input, const GpfEntry *entry, FILE *output)
{
    GpfU8 *packed, *decoded;
    GpfU16 pos, length, got, plane, capacity;
    int status;
    if (entry->method > 2 || entry->packed_size == 0) return -1;
    packed = (GpfU8 *)malloc(entry->packed_size);
    capacity = entry->method == 2 ? GPF_PLANE_BYTES : entry->decoded_size;
    if (capacity == 0) capacity = entry->packed_size;
    decoded = (GpfU8 *)malloc(capacity);
    if (packed == NULL || decoded == NULL) { free(packed); free(decoded); return -1; }
    status = -1;
    if (fseek(input, (long)entry->file_offset, SEEK_SET) != 0 ||
        fread(packed, 1, entry->packed_size, input) != entry->packed_size) goto done;
    if (entry->method == 0) {
        status = fwrite(packed, 1, entry->packed_size, output) == entry->packed_size ? 0 : -1;
    } else if (entry->method == 1) {
        if (gpf_lzss_decode(packed, entry->packed_size, decoded, capacity, &got) != 0 ||
            got != entry->decoded_size) goto done;
        status = fwrite(decoded, 1, got, output) == got ? 0 : -1;
    } else {
        pos = 0;
        for (plane = 0; plane < 4; ++plane) {
            if ((GpfU32)pos + 2UL > entry->packed_size) goto done;
            length = get16(packed + pos); pos += 2;
            if ((GpfU32)pos + length > entry->packed_size) goto done;
            if (gpf_lzss_decode(packed + pos, length, decoded, capacity, &got) != 0 ||
                got != GPF_PLANE_BYTES || fwrite(decoded, 1, got, output) != got) goto done;
            pos += length;
        }
        status = pos == entry->packed_size ? 0 : -1;
    }
done:
    free(decoded); free(packed); return status;
}

#ifdef GPF_STANDALONE
/* bcc -ml -DGPF_STANDALONE gpfcodec.c
 * GPFcodec archive.gpf MEMBER output.file */
int main(int argc, char **argv)
{
    FILE *input, *output;
    GpfHeader header;
    GpfEntry entry;
    int status;
    if (argc != 4) { fprintf(stderr, "Usage: gpfcodec archive.gpf MEMBER output.file\n"); return 2; }
    input = fopen(argv[1], "rb");
    if (input == NULL) return 1;
    if (gpf_read_header(input, &header) != 0 ||
        gpf_find_entry(input, &header, argv[2], &entry) != 0) { fclose(input); return 1; }
    output = fopen(argv[3], "wb");
    if (output == NULL) { fclose(input); return 1; }
    status = gpf_extract_entry(input, &entry, output);
    fclose(output); fclose(input);
    return status == 0 ? 0 : 1;
}
#endif
