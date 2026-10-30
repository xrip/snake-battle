
#include "fmtabi.h"




Byte far snk_encode(Byte far *p, int length, Byte seed)
{
    int i;
    Byte previous;
    previous = seed;
    for (i = 0; i < length; i++) {
        *p ^= previous;
        previous = *p;
        p++;
    }
    return previous;
}

Byte far snk_decode(Byte far *p, int length, Byte seed)
{
    int i;
    Byte previous;
    Byte temporary;
    previous = seed;
    for (i = 0; i < length; i++) {
        temporary = previous;
        previous = *p;
        *p ^= temporary;
        p++;
    }
    return previous;
}

