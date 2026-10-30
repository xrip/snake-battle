/* AdLib part/voice ABI recovered from segment 1341. Compile byte-packed. */
#ifndef ADLIB_H
#define ADLIB_H

typedef unsigned char ALByte;
typedef unsigned short ALWord;
typedef struct ALPlayer ALPlayer;
typedef struct ALPart ALPart;
typedef struct ALVoice ALVoice;
typedef struct ALEnvelope ALEnvelope;
typedef struct ALWork ALWork;

struct ALPlayer {
    ALByte prefix[4];
    ALPart near *parts;             /* +04 */
    ALByte middle[6];
    ALByte priority, unused0d, volume;
    signed char pan, transpose, detune;
};
struct ALPart {
    ALPlayer near *owner;
    ALPart near *previous, near *next;
    ALVoice near *voices;
    ALByte near *instrument;
    ALByte program, channel, uninitialized, enabled;
    signed char priority_offset;
    ALByte priority, volume, effective_volume;
    signed char pan, effective_pan, transpose, effective_transpose;
    signed char detune, effective_detune;
    ALByte modulation, sustain, bend_range, unused1b;
    int bend, pitch;
};
struct ALEnvelope {
    ALByte state, unused01;
    int value, timeout, maximum, base;
    ALByte loop, times[4], levels[4];
    signed char rate_scale, scale, previous_scale;
    ALWord total;
    int ticks, step;
    signed char direction;
    ALByte unused1d;
    ALWord remainder, accumulator;
};
struct ALWork {
    int value;
    ALByte parameter, modulation, retrigger, unused05;
    ALEnvelope near *peer;
};
struct ALVoice {
    ALPart near *owner;
    ALVoice near *previous, near *next;
    ALByte additive, channel, note, carrier_level, modulator_level, held;
    int timeout;
    ALEnvelope envelope1;
    ALWork work1;
    ALEnvelope envelope2;
    ALWork work2;
};
typedef struct {
    ALByte field, shift;
    ALWord mask;
} ALField;

typedef char ALPlayer_size_check[sizeof(ALPlayer)==18 ? 1 : -1];
typedef char ALPart_size_check[sizeof(ALPart)==32 ? 1 : -1];
typedef char ALVoice_size_check[sizeof(ALVoice)==98 ? 1 : -1];
typedef char ALEnvelope_size_check[sizeof(ALEnvelope)==34 ? 1 : -1];
typedef char ALWork_size_check[sizeof(ALWork)==8 ? 1 : -1];

extern ALPart snd_parts[32];
extern ALVoice snd_voices[9];
extern ALByte snd_voice_tick; /* low byte of 2-byte storage at DS:58F2 */
extern ALWord snd_voice_counter;
extern ALByte snd_random_seed; /* overlaps DS:1100, reserved max-values slot */
extern ALByte snd_default_instrument[30];
extern ALByte snd_global_instruments[32][30];
extern ALField snd_instrument_fields[69];
extern ALByte snd_parameter_map[16];
extern ALWord snd_max_values[16], snd_step_counts[32], snd_channel_masks[16];
extern ALByte snd_volume_products[64][32];

extern int near snd_04D9(int, int, int);
extern int near snd_04F4(int, int, int);
extern void near snd_053D(void near *, const void near *, unsigned);
extern void near snd_1DC6(void);
void near snd_1E1A(void);
void near snd_1E83(ALPlayer near *, ALByte near *);
void near snd_1FA2(ALPart near *, ALByte);
void near snd_1FCC(void);
ALPart near * near snd_1FE4(ALPlayer near *, ALByte);
void near snd_20AA(ALPart near *);
void near snd_20E7(ALPlayer near *);
void near snd_2102(ALPlayer near *, ALPart near *);
ALPart near * near snd_2129(ALByte);
void near snd_216C(ALPlayer near *, ALByte, ALByte, ALByte);
void near snd_21A2(ALPlayer near *, ALByte, ALByte);
void near snd_21EF(ALPart near *);
void near snd_2209(ALPart near *);
void near snd_222F(ALPart near *, ALWord near *, int near *);
void near snd_2277(ALPlayer near *, ALByte, ALByte);
void near snd_22A4(ALPlayer near *, ALByte, ALByte near *);
void near snd_22CD(ALPlayer near *, ALByte, int, int);
void near snd_22F1(ALPlayer near *, ALByte, ALByte);
int near snd_235A(ALPlayer near *, ALByte, ALByte);
void near snd_23D1(void);
void near snd_23D2(ALPlayer near *, ALByte, char, signed char);
void near snd_247E(ALPlayer near *, ALByte, signed char);
int near snd_2509(ALPlayer near *, ALByte, char);
void near snd_253C(ALPlayer near *, ALByte, ALByte);
void near snd_2567(ALPlayer near *, ALByte, char);
void near snd_2594(ALPlayer near *, ALByte, int);
void near snd_25E7(ALPlayer near *, ALByte, ALByte);
ALByte near snd_261A(ALPlayer near *, char, ALByte);
void near snd_2665(ALPart near *, ALByte near *);
void near snd_2679(ALByte, ALByte near *);
void near snd_269B(ALPart near *, ALByte);
void near snd_26C3(ALPart near *, int, int);
void near snd_2709(ALPart near *, ALByte, ALByte);
void near snd_2750(ALVoice near *, ALByte);
void near snd_2772(ALPart near *);
void near snd_278D(ALPart near *, ALVoice near *, ALByte, ALByte);
void near snd_28BD(ALVoice near *, ALByte);
void near snd_28DB(ALVoice near *);
void near snd_28FB(ALVoice near *, ALEnvelope near *, ALWork near *);
void near snd_29A1(ALVoice near *, ALEnvelope near *, ALWork near *, ALByte, ALByte near *);
void near snd_2A5E(ALVoice near *, int, int);
void near snd_2A87(ALVoice near *, ALByte);
void near snd_2AD9(ALVoice near *, signed char);
void near snd_2B03(ALVoice near *, ALByte);
void near snd_2B3F(ALVoice near *, int);
ALVoice near * near snd_2B6C(ALByte);
void near snd_2BC4(ALVoice near *);
void near snd_2BF6(ALEnvelope near *, ALByte near *);
void near snd_2C59(ALEnvelope near *);
ALWord near snd_2D33(ALEnvelope near *, ALWork near *);
int near snd_2DD3(int, signed char);
int near snd_2E7A(int);

/* The hardware-facing procedures are original register-ABI assembler. */
void near snd_2E9B(ALVoice near *, ALByte near *, ALByte, ALByte);
void near snd_2F48(ALByte, ALByte, int);
void near snd_2F6F(ALByte, ALByte, int);
void near snd_2F94(void); /* AH=channel */
void near snd_2FA0(void); /* AH=channel */
void near snd_2FB1(ALVoice near *, ALByte, int);
int near snd_304C(ALByte, ALByte);
#endif
