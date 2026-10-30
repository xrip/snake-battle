#ifndef SNAKE_GPF_CODEC_H
#define SNAKE_GPF_CODEC_H
/* Reconstructed GAMOS GPF codec. C89; Borland C++ 3.1: bcc -ml.
 * Disk integers are decoded explicitly; host struct packing is never used.
 * Canonical compressor reproduces all 94 streams in supplied SNAKE.GPF.
 */
#include <stdio.h>
#include <limits.h>
#if defined(__BORLANDC__) || defined(__TURBOC__)
# define GPF_FAR far
#else
# define GPF_FAR
#endif
#if USHRT_MAX != 65535U
# error This codec needs a 16-bit unsigned short
#endif
typedef unsigned char GpfU8;
typedef unsigned short GpfU16;
/* Arithmetic is bounded to 32 bits; unsigned long is at least 32 bits. */
typedef unsigned long GpfU32;

#define GPF_HEADER_BYTES 33
#define GPF_ENTRY_BYTES 22
#define GPF_PLANE_BYTES 28000U

typedef struct GpfHeader {
    GpfU8 raw[GPF_HEADER_BYTES];
    GpfU16 member_count;
} GpfHeader;

typedef struct GpfEntry {
    char name[13];
    GpfU8 method;
    GpfU32 file_offset;
    GpfU16 packed_size;
    GpfU16 decoded_size;
} GpfEntry;

/* Return zero on success, -1 for malformed data, capacity or allocation errors.
 * All block sizes fit a single real-mode data segment. Screens are four blocks.
 */
int gpf_lzss_decode(const GpfU8 GPF_FAR *source, GpfU16 source_size,
                    GpfU8 GPF_FAR *target, GpfU16 target_capacity,
                    GpfU16 *target_size);
int gpf_lzss_encode(const GpfU8 GPF_FAR *source, GpfU16 source_size,
                    GpfU8 GPF_FAR *target, GpfU16 target_capacity,
                    GpfU16 *target_size);
/* Pixel read from a file-form .BLO (relative plane paragraphs).
 * Matches original decoded driver operation 4; color index 0..15. */
int gpf_blo_pixel(const GpfU8 GPF_FAR *data, GpfU16 data_size,
                  GpfU16 x, GpfU16 y, GpfU8 *color);
int gpf_read_header(FILE *input, GpfHeader *header);
int gpf_read_entry(FILE *input, GpfEntry *entry);
void gpf_write_entry_bytes(const GpfEntry *entry, GpfU8 target[GPF_ENTRY_BYTES]);
int gpf_find_entry(FILE *input, const GpfHeader *header,
                   const char *name, GpfEntry *entry);
int gpf_extract_entry(FILE *input, const GpfEntry *entry, FILE *output);
#endif
