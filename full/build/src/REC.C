/* Two replay control flags follow the nibble reader state. */
int sb_replay_flags[2];

/* Complete recovered module 0E92, original image E928..ED2F.
 * Source control flow deliberately preserves the original behaviors,
 * including the mode-zero recursive branch in rec_read_bytes.
 */
#include <io.h>
#include "fmtabi.h"




/* Original initialized contribution 0EBA..0F05. */
char rec_error_write[] = "error in protocol write";
char rec_error_read[] = "error in protocol read";
char rec_error_packed[] = "error in packed read/write";
int rec_push_flag = 0;

/* Borland emits these uninitialized symbols in reverse declaration order.
 * The resulting contribution is DS:40F6..40FE, without word alignment. */
int rec_phase;
Byte rec_buffer;
int rec_mode;
int rec_handle;
Byte rec_previous;
Byte rec_pushed;

int far rec_open_read(char far *filename)
{
    rec_mode = 0;
    rec_handle = open(filename, 0x8004);
    if (rec_handle == -1)
        return 0;
    if (read(rec_handle, &rec_previous, 1) != 1)
        fmt_fatal(rec_error_read);
    return rec_handle;
}

void far rec_close_read(void)
{
    close(rec_handle);
}

int far rec_open_write(char far *filename)
{
    rec_mode = 0;
    rec_handle = open(filename, 0x8104, 0x180);
    rec_previous = fmt_random(128);
    if (write(rec_handle, &rec_previous, 1) == -1)
        fmt_fatal(rec_error_write);
    return rec_handle;
}

void far rec_close_write(void)
{
    Byte token;
    if (rec_mode != 0 && rec_phase == 2) {
        token = 13;
        rec_write_stream(&token, 1);
    }
    close(rec_handle);
}

void far rec_packed(void)
{
    rec_mode = 1;
    rec_phase = 1;
    rec_buffer = 0;
}

void far rec_write_stream(Byte far *p, int count)
{
    int error = 0;
    if (rec_mode == 0) {
        snk_encode(p, count, rec_previous);
        error = write(rec_handle, p, count) == -1;
        rec_previous = snk_decode(p, count, rec_previous);
    } else {
        while (count--) {
            if (rec_phase == 1) {
                rec_phase = 2;
                rec_buffer |= *p << 4;
                p++;
            } else {
                rec_phase = 1;
                rec_buffer |= *p;
                p++;
                error = write(rec_handle, &rec_buffer, 1) == -1;
                if (error)
                    break;
                rec_buffer = 0;
            }
        }
    }
    if (error)
        fmt_fatal(rec_error_write);
}

void far rec_unget(Byte far *p)
{
    rec_push_flag = 1;
    rec_pushed = *p;
}

void far rec_read_stream(Byte far *p, int count)
{
    int error = 0;
    if (rec_mode == 0) {
        error = read(rec_handle, p, count) != count;
        if (!error)
            rec_previous = snk_decode(p, count, rec_previous);
    } else {
        while (count--) {
            if (rec_push_flag) {
                rec_push_flag = 0;
                *p = rec_pushed;
            } else {
                if (rec_phase == 1) {
                    if ((error = read(rec_handle, &rec_buffer, 1) != 1))
                        break;
                    rec_phase = 2;
                    *p = rec_buffer >> 4;
                } else {
                    rec_phase = 1;
                    *p = rec_buffer & 15;
                }
            }
            p++;
        }
    }
    if (error)
        fmt_fatal(rec_error_read);
}

void far rec_write_bytes(Byte far *p, int count)
{
    int n;
    Byte far *q;
    Byte temp[100];
    if (rec_mode == 0)
        rec_write_stream(p, count);
    else {
        n = count * 2;
        q = temp;
        if (n > 100)
            fmt_fatal(rec_error_packed);
        while (n--) {
            if (n & 1)
                *q = *p >> 4;
            else {
                *q = *p & 15;
                p++;
            }
            q++;
        }
        rec_write_stream(temp, count * 2);
    }
}

void far rec_read_bytes(Byte far *p, int count)
{
    int n;
    Byte far *q;
    Byte temp[100];
    if (rec_mode == 0)
        rec_read_bytes(p, count);
    else {
        n = count * 2;
        q = temp;
        if (n > 100)
            fmt_fatal(rec_error_packed);
        rec_read_stream(temp, n);
        while (n--) {
            if (n & 1) {
                *p = *q << 4;
                q++;
            } else {
                *p |= *q;
                q++;
                p++;
            }
        }
    }
}

