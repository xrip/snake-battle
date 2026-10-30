/* Rebuild SNAKE.GPF entirely from extracted uncompressed resources using the
 * reconstructed original-compatible encoder. Does not read the original GPF.
 * Borland: bcc -ml -egpfbuild.exe gpfbuild.c gpfcodec.c
 * Usage: gpfbuild assets\resources rebuilt\SNAKE.GPF
 */
#include "gpfcodec.h"
#include <stdlib.h>
#include <string.h>
#include "gpfindex.h"
#if defined(__BORLANDC__) || defined(__TURBOC__)
# define SEP "\\"
#else
# define SEP "/"
#endif
int main(int argc, char **argv)
{
    unsigned char header[33] = "\032GAMOS PACKED FILE";
    unsigned char record[22], sizes[2];
    char path[260];
    FILE *input, *output;
    GpfU8 *plain, *packed;
    GpfEntry entries[GPF_MEMBER_COUNT];
    GpfU16 i, plane, count, length, packed_length;
    long size, start;
    int status;
    if (argc != 3) { puts("Usage: gpfbuild resource-directory output.gpf"); return 2; }
    if (strlen(argv[1]) > 240) return 1;
    plain = (GpfU8 *)malloc(60000U); packed = (GpfU8 *)malloc(60000U);
    if (plain == NULL || packed == NULL) return 1;
    output = fopen(argv[2], "wb");
    if (output == NULL) return 1;
    input = NULL; status = 1;
    header[19] = 1; header[20] = 0; header[21] = 0; header[22] = 1;
    header[23] = (unsigned char)GPF_MEMBER_COUNT;
    header[24] = (unsigned char)(GPF_MEMBER_COUNT >> 8);
    if (fwrite(header, 1, 33, output) != 33) goto done;
    memset(record, 0, sizeof(record));
    for (i = 0; i < GPF_MEMBER_COUNT; ++i)
        if (fwrite(record, 1, 22, output) != 22) goto done;
    for (i = 0; i < GPF_MEMBER_COUNT; ++i) {
        strcpy(path, argv[1]); strcat(path, SEP); strcat(path, gpf_members[i].name);
        input = fopen(path, "rb");
        if (input == NULL) { printf("Cannot open %s\n", path); goto done; }
        if (fseek(input, 0, SEEK_END) != 0) goto done;
        size = ftell(input);
        if (size <= 0 || fseek(input, 0, SEEK_SET) != 0) goto done;
        memset(&entries[i], 0, sizeof(entries[i]));
        strcpy(entries[i].name, gpf_members[i].name);
        entries[i].method = gpf_members[i].method;
        start = ftell(output); entries[i].file_offset = (GpfU32)start;
        count = entries[i].method == 2 ? 4 : 1;
        if ((count == 1 && size > 60000L) || (count == 4 && size != 112000L)) goto done;
        length = count == 4 ? GPF_PLANE_BYTES : (GpfU16)size;
        entries[i].decoded_size = count == 4 ? 0 : length;
        for (plane = 0; plane < count; ++plane) {
            if (fread(plain, 1, length, input) != length ||
                gpf_lzss_encode(plain, length, packed, 60000U, &packed_length) != 0) goto done;
            if (count == 4) {
                sizes[0] = (GpfU8)packed_length; sizes[1] = (GpfU8)(packed_length >> 8);
                if (fwrite(sizes, 1, 2, output) != 2) goto done;
            }
            if (fwrite(packed, 1, packed_length, output) != packed_length) goto done;
        }
        size = ftell(output) - start;
        if (size > 65535L) goto done;
        entries[i].packed_size = (GpfU16)size;
        fclose(input); input = NULL;
    }
    if (fseek(output, 33, SEEK_SET) != 0) goto done;
    for (i = 0; i < GPF_MEMBER_COUNT; ++i) {
        gpf_write_entry_bytes(&entries[i], record);
        if (fwrite(record, 1, 22, output) != 22) goto done;
    }
    printf("Rebuilt %u resources from uncompressed data.\n", (unsigned)GPF_MEMBER_COUNT);
    status = 0;
done:
    if (input != NULL) fclose(input);
    fclose(output); free(packed); free(plain);
    return status;
}
