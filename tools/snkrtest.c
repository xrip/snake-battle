/* Portable C89 verification driver; also buildable with 16-bit Borland.
 * Usage: snkrtest snk|rec input output
 * The output is a reconstruction through the typed format API.
 */
#include "snkrec.h"
#include <string.h>

int main(int argc, char **argv)
{
    FILE *input;
    FILE *output;
    SNK_Data snake;
    SNK_Byte seed;
    REC_Header header;
    REC_Stream reader;
    REC_Stream writer;
    SNK_Word scores[4];
    int token;
    int rc;
    int finished;
    int rounds;
    if (argc != 4)
        return 2;
    input = fopen(argv[2], "rb");
    if (!input)
        return 3;
    output = fopen(argv[3], "wb");
    if (!output) {
        fclose(input);
        return 4;
    }
    rc = 0;
    if (strcmp(argv[1], "snk") == 0) {
        rc = snk_read(input, &snake, &seed);
        if (!rc)
            rc = snk_write(output, &snake, seed);
        if (!rc)
            printf("SNK cards=%u rating=%u\n",
                    snake.header.card_count, snake.header.rating);
    } else if (strcmp(argv[1], "rec") == 0) {
        rc = rec_read_header(&reader, input, &header);
        if (!rc)
            rc = rec_write_header(&writer, output, &header);
        finished = 0;
        rounds = 0;
        while (!rc && (token = rec_read_token(&reader)) >= 0) {
            rc = rec_write_token(&writer, token);
            if (!rc && token == 14 && !finished) {
                rc = rec_read_scores(&reader, header.present, scores);
                if (!rc)
                    rc = rec_write_scores(&writer, header.present, scores);
                rounds++;
            } else if (token == 13) {
                finished = 1;
            }
            /* After the first end marker, storage can contain stale bytes.
             * Those are copied as uninterpreted nibbles, not live events. */
        }
        if (!rc && reader.error)
            rc = -1;
        if (!rc)
            rc = rec_finish_write(&writer);
        if (!rc)
            printf("REC participants=%u live_score_records=%d\n",
                    header.count, rounds);
    } else {
        rc = -2;
    }
    if (fclose(input) != 0)
        rc = -1;
    if (fclose(output) != 0)
        rc = -1;
    return rc ? 1 : 0;
}
