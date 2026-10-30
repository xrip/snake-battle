/* Snake Battle SNK/REC formats, recovered from supplied SNAKE.EXE.
 * Names and API are reconstructed; this is not the author's source text.
 * Borland 16-bit large model: bcc -ml -a- -c snkrec.c
 */
#ifndef SNKREC_H
#define SNKREC_H

#include <stdio.h>

#ifdef __BORLANDC__
# define SNK_FAR far
# pragma option -a-
#else
# define SNK_FAR
# pragma pack(push, 1)
#endif

typedef unsigned char SNK_Byte;
typedef unsigned short SNK_Word;

#define SNK_HEADER_SIZE 105
#define SNK_CARD_SIZE 152
#define SNK_MAX_CARDS 9

typedef struct SNK_Header {
    SNK_Word version;
    SNK_Word editor_level;
    SNK_Word card_count;
    SNK_Word battle_count;        /* Completed rounds, not number of sessions. */
    SNK_Word rating;
    SNK_Byte password[11];        /* Nonzero text bytes are complemented. */
    char name[9];
    char date[10];
    char comments[3][21];
    SNK_Word color;
} SNK_Header;

typedef struct SNK_Cell {
    SNK_Byte group;
    SNK_Byte negate;
    SNK_Byte tile;
} SNK_Cell;

typedef struct SNK_Card {
    SNK_Byte group;
    short head_x;
    short head_y;
    SNK_Cell cell[7][7];          /* x first: byte offset 5 + 21*x + 3*y. */
} SNK_Card;

typedef struct SNK_Data {
    SNK_Header header;
    SNK_Card cards[SNK_MAX_CARDS];
} SNK_Data;

typedef char SNK_check_word[(sizeof(SNK_Word) == 2) ? 1 : -1];
typedef char SNK_check_header[(sizeof(SNK_Header) == 105) ? 1 : -1];
typedef char SNK_check_cell[(sizeof(SNK_Cell) == 3) ? 1 : -1];
typedef char SNK_check_card[(sizeof(SNK_Card) == 152) ? 1 : -1];
typedef char SNK_check_data[(sizeof(SNK_Data) == 1473) ? 1 : -1];

#ifndef __BORLANDC__
# pragma pack(pop)
#endif

/* These two loops preserve original operation/local-variable order.
 * Both return the final encrypted byte, or seed for zero length.
 * The original routines take a signed 16-bit length; valid SNK payloads
 * are <= 1473 bytes and do not cross a 64-K offset boundary.
 */
SNK_Byte SNK_FAR snk_encode(SNK_Byte SNK_FAR *p, int length, SNK_Byte seed);
SNK_Byte SNK_FAR snk_decode(SNK_Byte SNK_FAR *p, int length, SNK_Byte seed);
void SNK_FAR snk_complement_password(SNK_Byte SNK_FAR *p);

/* FILE must be opened in binary mode. The file methods preserve every
 * stored string byte, including bytes after the first NUL. Return 0 on
 * success, -1 on I/O error, -2 for invalid structure, -3 for bad trailer.
 * This reader deliberately does not overwrite header.name with filename,
 * unlike the original game's user-facing load routine.
 */
int SNK_FAR snk_read(FILE *fp, SNK_Data SNK_FAR *data, SNK_Byte *seed);
int SNK_FAR snk_write(FILE *fp, SNK_Data SNK_FAR *data, SNK_Byte seed);

/* REC stream state is an implementation structure, not an on-disk struct.
 * Mode 0 is cumulative-XOR byte I/O; mode 1 stores high nibble first.
 */
typedef struct REC_Stream {
    FILE *fp;
    int mode;
    SNK_Byte previous;
    SNK_Byte partial;
    int pending;
    int pushed;
    int error;
} REC_Stream;

typedef struct REC_Header {
    SNK_Byte seed;
    SNK_Byte count;
    SNK_Byte order[4];
    SNK_Byte present[4];
    SNK_Header snake[4];
} REC_Header;

int SNK_FAR rec_begin_read(REC_Stream *stream, FILE *fp, SNK_Byte *seed);
int SNK_FAR rec_begin_write(REC_Stream *stream, FILE *fp, SNK_Byte seed);
void SNK_FAR rec_set_packed(REC_Stream *stream);
int SNK_FAR rec_read_token(REC_Stream *stream);
int SNK_FAR rec_write_token(REC_Stream *stream, int token);
int SNK_FAR rec_unget_token(REC_Stream *stream, int token);
int SNK_FAR rec_read_bytes(REC_Stream *stream, SNK_Byte SNK_FAR *data, int count);
int SNK_FAR rec_write_bytes(REC_Stream *stream, const SNK_Byte SNK_FAR *data, int count);
int SNK_FAR rec_finish_write(REC_Stream *stream);
int SNK_FAR rec_read_header(REC_Stream *stream, FILE *fp, REC_Header SNK_FAR *header);
int SNK_FAR rec_write_header(REC_Stream *stream, FILE *fp, const REC_Header SNK_FAR *header);
/* Score helpers read/write the payload after marker 0xE, in slot order.
 * They do not consume/emit that marker. No C struct is dumped here.
 */
int SNK_FAR rec_read_scores(REC_Stream *stream, const SNK_Byte *present, SNK_Word *scores);
int SNK_FAR rec_write_scores(REC_Stream *stream, const SNK_Byte *present, const SNK_Word *scores);

#endif
