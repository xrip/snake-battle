/* Test recovered C codec against the original GPF streams, not self-generated
 * examples. Borland: bcc -ml -egpftest.exe gpftest.c gpfcodec.c */
#include "gpfcodec.h"
#include <stdlib.h>
#include <string.h>
static unsigned read16(const unsigned char *p) { return p[0] | ((unsigned)p[1] << 8); }
int main(int argc, char **argv)
{
    FILE *input;
    GpfHeader header;
    GpfEntry entry;
    GpfU8 *stored, *plain, *encoded;
    GpfU16 i, pos, part, length, decoded, recoded, count;
    unsigned streams;
    int result;
    if (argc != 2) { puts("Usage: gpftest SNAKE.GPF"); return 2; }
    input = fopen(argv[1], "rb");
    if (input == NULL || gpf_read_header(input, &header) != 0) return 1;
    stored = (GpfU8 *)malloc(60000U); plain = (GpfU8 *)malloc(60000U);
    encoded = (GpfU8 *)malloc(60000U);
    if (stored == NULL || plain == NULL || encoded == NULL) return 1;
    result = 1; streams = 0;
    for (i = 0; i < header.member_count; ++i) {
        if (fseek(input, GPF_HEADER_BYTES + (long)i * GPF_ENTRY_BYTES, SEEK_SET) != 0 ||
            gpf_read_entry(input, &entry) != 0 || entry.packed_size > 60000U ||
            fseek(input, (long)entry.file_offset, SEEK_SET) != 0 ||
            fread(stored, 1, entry.packed_size, input) != entry.packed_size) goto finish;
        pos = 0; count = entry.method == 2 ? 4 : 1;
        if (entry.method != 1 && entry.method != 2) goto finish;
        for (part = 0; part < count; ++part) {
            length = entry.packed_size;
            if (entry.method == 2) {
                if ((GpfU32)pos + 2UL > entry.packed_size) goto finish;
                length = (GpfU16)read16(stored + pos); pos += 2;
            }
            if ((GpfU32)pos + length > entry.packed_size ||
                gpf_lzss_decode(stored + pos, length, plain, 60000U, &decoded) != 0 ||
                decoded != (entry.method == 2 ? GPF_PLANE_BYTES : entry.decoded_size) ||
                gpf_lzss_encode(plain, decoded, encoded, 60000U, &recoded) != 0 ||
                recoded != length || memcmp(stored + pos, encoded, length) != 0) {
                printf("FAIL member %.13s part %u\n", entry.name, part); goto finish;
            }
            pos += length; ++streams;
        }
        if (pos != entry.packed_size) goto finish;
    }
    printf("PASS %u members, %u streams: decoded sizes and recompressed bytes exact.\n",
           header.member_count, streams);
    result = 0;
finish:
    free(encoded); free(plain); free(stored); fclose(input); return result;
}
