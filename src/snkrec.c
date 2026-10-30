/* Recovered C89 implementation. See docs/SNK_REC.md for exact evidence.
 * Codec loops follow original 0B2B:000F / 0B2B:0046 operation order.
 * File/stream APIs are newly named, validated implementations of the
 * recovered format, not a claim of identical whole-program codegen.
 */
#include "snkrec.h"
#include <string.h>

SNK_Byte SNK_FAR snk_encode(SNK_Byte SNK_FAR *p, int length, SNK_Byte seed)
{
    int i;
    SNK_Byte previous;
    previous = seed;
    for (i = 0; i < length; i++) {
        *p ^= previous;
        previous = *p;
        p++;
    }
    return previous;
}

SNK_Byte SNK_FAR snk_decode(SNK_Byte SNK_FAR *p, int length, SNK_Byte seed)
{
    int i;
    SNK_Byte previous;
    SNK_Byte temporary;
    previous = seed;
    for (i = 0; i < length; i++) {
        temporary = previous;
        previous = *p;
        *p ^= temporary;
        p++;
    }
    return previous;
}

void SNK_FAR snk_complement_password(SNK_Byte SNK_FAR *p)
{
    while (*p) {
        *p = (SNK_Byte)(255 - *p);
        p++;
    }
}

int SNK_FAR snk_read(FILE *fp, SNK_Data SNK_FAR *data, SNK_Byte *seed)
{
    int first;
    int trailer;
    int card_bytes;
    SNK_Byte state;
    first = fgetc(fp);
    if (first == EOF)
        return -1;
    *seed = (SNK_Byte)first;
    if (fread(&data->header, 1, SNK_HEADER_SIZE, fp) != SNK_HEADER_SIZE)
        return -1;
    state = snk_decode((SNK_Byte SNK_FAR *)&data->header,
                       SNK_HEADER_SIZE, *seed);
    if (data->header.version != 1 || data->header.card_count < 1 ||
        data->header.card_count > SNK_MAX_CARDS)
        return -2;
    card_bytes = data->header.card_count * SNK_CARD_SIZE;
    if (fread(data->cards, 1, card_bytes, fp) != (unsigned)card_bytes)
        return -1;
    state = snk_decode((SNK_Byte SNK_FAR *)data->cards, card_bytes, state);
    trailer = fgetc(fp);
    if (trailer == EOF)
        return -1;
    if (trailer != state)
        return -3;
    if (fgetc(fp) != EOF)
        return -2;
    return ferror(fp) ? -1 : 0;
}

int SNK_FAR snk_write(FILE *fp, SNK_Data SNK_FAR *data, SNK_Byte seed)
{
    int size;
    int written;
    SNK_Byte trailer;
    if (data->header.version != 1 || data->header.card_count < 1 ||
        data->header.card_count > SNK_MAX_CARDS)
        return -2;
    size = SNK_HEADER_SIZE + data->header.card_count * SNK_CARD_SIZE;
    if (fputc(seed, fp) == EOF)
        return -1;
    trailer = snk_encode((SNK_Byte SNK_FAR *)data, size, seed);
    written = (int)fwrite(data, 1, size, fp);
    snk_decode((SNK_Byte SNK_FAR *)data, size, seed);
    if (written != size || fputc(trailer, fp) == EOF)
        return -1;
    return 0;
}

static void rec_init(REC_Stream *stream, FILE *fp, SNK_Byte seed)
{
    stream->fp = fp;
    stream->mode = 0;
    stream->previous = seed;
    stream->partial = 0;
    stream->pending = 0;
    stream->pushed = -1;
    stream->error = 0;
}

int SNK_FAR rec_begin_read(REC_Stream *stream, FILE *fp, SNK_Byte *seed)
{
    int value;
    value = fgetc(fp);
    if (value == EOF)
        return -1;
    *seed = (SNK_Byte)value;
    rec_init(stream, fp, *seed);
    return 0;
}

int SNK_FAR rec_begin_write(REC_Stream *stream, FILE *fp, SNK_Byte seed)
{
    rec_init(stream, fp, seed);
    if (fputc(seed, fp) == EOF) {
        stream->error = 1;
        return -1;
    }
    return 0;
}

void SNK_FAR rec_set_packed(REC_Stream *stream)
{
    stream->mode = 1;
    stream->pending = 0;
    stream->pushed = -1;
}

int SNK_FAR rec_read_token(REC_Stream *stream)
{
    int value;
    int decoded;
    if (stream->pushed >= 0) {
        value = stream->pushed;
        stream->pushed = -1;
        return value;
    }
    if (stream->mode == 1 && stream->pending) {
        stream->pending = 0;
        return stream->partial;
    }
    value = fgetc(stream->fp);
    if (value == EOF) {
        if (ferror(stream->fp))
            stream->error = 1;
        return -1;
    }
    if (stream->mode == 0) {
        decoded = value ^ stream->previous;
        stream->previous = (SNK_Byte)value;
        return decoded;
    }
    stream->partial = (SNK_Byte)(value & 15);
    stream->pending = 1;
    return value >> 4;
}

int SNK_FAR rec_write_token(REC_Stream *stream, int token)
{
    int value;
    if (token < 0 || token > (stream->mode ? 15 : 255)) {
        stream->error = 1;
        return -1;
    }
    if (stream->mode == 0) {
        value = token ^ stream->previous;
        stream->previous = (SNK_Byte)value;
    } else if (!stream->pending) {
        stream->partial = (SNK_Byte)(token << 4);
        stream->pending = 1;
        return 0;
    } else {
        value = stream->partial | token;
        stream->pending = 0;
    }
    if (fputc(value, stream->fp) == EOF) {
        stream->error = 1;
        return -1;
    }
    return 0;
}

int SNK_FAR rec_unget_token(REC_Stream *stream, int token)
{
    if (stream->pushed >= 0 || token < 0 || token > 15)
        return -1;
    stream->pushed = token;
    return 0;
}

int SNK_FAR rec_read_bytes(REC_Stream *stream, SNK_Byte SNK_FAR *data, int count)
{
    int i;
    int high;
    int low;
    for (i = 0; i < count; i++) {
        high = rec_read_token(stream);
        if (high < 0)
            return -1;
        if (stream->mode == 1) {
            low = rec_read_token(stream);
            if (low < 0)
                return -1;
            high = (high << 4) | low;
        }
        data[i] = (SNK_Byte)high;
    }
    return 0;
}

int SNK_FAR rec_write_bytes(REC_Stream *stream, const SNK_Byte SNK_FAR *data, int count)
{
    int i;
    for (i = 0; i < count; i++) {
        if (stream->mode == 1) {
            if (rec_write_token(stream, data[i] >> 4) < 0 ||
                rec_write_token(stream, data[i] & 15) < 0)
                return -1;
        } else if (rec_write_token(stream, data[i]) < 0)
            return -1;
    }
    return 0;
}

int SNK_FAR rec_finish_write(REC_Stream *stream)
{
    if (stream->mode == 1 && stream->pending)
        return rec_write_token(stream, 13);
    return stream->error ? -1 : 0;
}

int SNK_FAR rec_read_header(REC_Stream *stream, FILE *fp, REC_Header SNK_FAR *header)
{
    int slot;
    int i;
    if (rec_begin_read(stream, fp, &header->seed) < 0)
        return -1;
    header->count = 0;
    for (i = 0; i < 4; i++)
        header->present[i] = 0;
    for (;;) {
        slot = rec_read_token(stream);
        if (slot < 0)
            return -1;
        if (slot == 12)
            break;
        if (slot > 3 || header->present[slot])
            return -2;
        header->order[header->count++] = (SNK_Byte)slot;
        header->present[slot] = 1;
        if (rec_read_bytes(stream, (SNK_Byte SNK_FAR *)&header->snake[slot],
                           SNK_HEADER_SIZE) < 0)
            return -1;
    }
    rec_set_packed(stream);
    return 0;
}

int SNK_FAR rec_write_header(REC_Stream *stream, FILE *fp, const REC_Header SNK_FAR *header)
{
    int i;
    int slot;
    int seen;
    if (header->count > 4)
        return -2;
    seen = 0;
    for (i = 0; i < header->count; i++) {
        slot = header->order[i];
        if (slot > 3 || (seen & (1 << slot)))
            return -2;
        seen |= 1 << slot;
    }
    if (rec_begin_write(stream, fp, header->seed) < 0)
        return -1;
    for (i = 0; i < header->count; i++) {
        slot = header->order[i];
        if (rec_write_token(stream, slot) < 0 ||
            rec_write_bytes(stream,
                (const SNK_Byte SNK_FAR *)&header->snake[slot],
                SNK_HEADER_SIZE) < 0)
            return -1;
    }
    if (rec_write_token(stream, 12) < 0)
        return -1;
    rec_set_packed(stream);
    return 0;
}

int SNK_FAR rec_read_scores(REC_Stream *stream, const SNK_Byte *present, SNK_Word *scores)
{
    int slot;
    SNK_Byte pair[2];
    for (slot = 0; slot < 4; slot++) {
        if (present[slot]) {
            if (rec_read_bytes(stream, pair, 2) < 0)
                return -1;
            scores[slot] = (SNK_Word)(pair[0] | ((SNK_Word)pair[1] << 8));
        }
    }
    return 0;
}

int SNK_FAR rec_write_scores(REC_Stream *stream, const SNK_Byte *present, const SNK_Word *scores)
{
    int slot;
    SNK_Byte pair[2];
    for (slot = 0; slot < 4; slot++) {
        if (present[slot]) {
            pair[0] = (SNK_Byte)scores[slot];
            pair[1] = (SNK_Byte)(scores[slot] >> 8);
            if (rec_write_bytes(stream, pair, 2) < 0)
                return -1;
        }
    }
    return 0;
}
