
#include "fmtabi.h"




char fmt_number_format[] = "%*d";

/* Original returns its stack buffer. This lifetime error is preserved. */
char far *far fmt_number(int value, int width)
{
    char buffer[256];
    f_0c31_004b(buffer, fmt_number_format, width, value);
    return buffer;
}

