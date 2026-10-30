typedef struct { char bytes[32]; } ALPart;
typedef struct { char prefix[4]; ALPart near *parts; } ALPlayer;
extern ALPart snd_parts[32];
extern void near snd_20AA();
extern void near snd_1DC6();

void near part3()
{
    register ALPart near *p = snd_parts;
    do { snd_20AA(p); ++p; } while (p < snd_parts + 32);
    snd_1DC6();
}

void near player2(p)
register ALPlayer near *p;
{
    while (p->parts) snd_20AA(p->parts);
}
