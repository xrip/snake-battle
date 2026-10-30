#include "fmtabi.h"

void far fmt_about(void)
{
    char far *far *text;
    int x;
    int y;
    input_buttons = 0;
    f_0c85_0fb1();
    f_0c85_0f74();
    f_0c85_0ead(22, 14, 442, 309, screen_front, 0);
    text = resource_names + 56;
    x = 63;
    y = 25;
    f_0c85_0467(2);
    do {
        f_0c85_049d(screen_front, x, y, *text);
        text++;
        y += 14;
    } while (**text != '%' && y < 309);
    f_0c85_0467(1);
    f_0c85_0c0e(22, 14, 442, 309, screen_front, 22, 14, screen_back, 20);
    f_0c85_0fb1();
    input_poll(1);
    input_hide();
    input_buttons = 0;
}
