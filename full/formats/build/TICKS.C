#include "fmtabi.h"

unsigned long far *tick_pointer = (unsigned long far *)0x0000046cUL;

unsigned long far tick_now(void)
{
    return *tick_pointer;
}

void far tick_wait(unsigned long start, unsigned long count)
{
    while (tick_active(start, count))
        ;
}

int far tick_active(unsigned long start, unsigned long count)
{
    unsigned long end;
    if (start < 0xffffffffUL - count) {
        end = start + count;
        if (*tick_pointer >= start && *tick_pointer < end)
            return 1;
        else
            return 0;
    } else {
        end = count - (0xffffffffUL - start);
        if (*tick_pointer >= start || *tick_pointer < end)
            return 1;
        else
            return 0;
    }
}
