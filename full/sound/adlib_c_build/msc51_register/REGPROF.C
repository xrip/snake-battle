#include "ADLIB.H"

void near part1(void)
{
    ALPart near *p;
    for (p = snd_parts; p < snd_parts + 32; ++p) snd_20AA(p);
    snd_1DC6();
}

void near part2(void)
{
    register ALPart near *p;
    for (p = snd_parts; p < snd_parts + 32; ++p) snd_20AA(p);
    snd_1DC6();
}

void near part3(void)
{
    register ALPart near *p = snd_parts;
    do { snd_20AA(p); ++p; } while (p < snd_parts + 32);
    snd_1DC6();
}

void near part4(void)
{
    register ALPart near *p = snd_parts;
    while (p < snd_parts + 32) { snd_20AA(p); ++p; }
    snd_1DC6();
}

void near part5(void)
{
    register char near *p = (char near *)snd_parts;
    do { snd_20AA((ALPart near *)p); p += 32; }
    while (p < (char near *)snd_parts + 1024);
    snd_1DC6();
}

void near player1(ALPlayer near *p)
{
    while (((volatile ALPlayer near *)p)->parts)
        snd_20AA(((volatile ALPlayer near *)p)->parts);
}

void near player2(register ALPlayer near *p)
{
    while (((volatile ALPlayer near *)p)->parts)
        snd_20AA(((volatile ALPlayer near *)p)->parts);
}

void near player3(register ALPlayer near *p)
{
    while (p->parts) snd_20AA(p->parts);
}

void near player4(ALPlayer near *input)
{
    register ALPlayer near *p = input;
    while (((volatile ALPlayer near *)p)->parts)
        snd_20AA(((volatile ALPlayer near *)p)->parts);
}

void near player5(register ALPlayer near *p)
{
    goto check;
loop:
    snd_20AA(p->parts);
check:
    if (p->parts) goto loop;
}
