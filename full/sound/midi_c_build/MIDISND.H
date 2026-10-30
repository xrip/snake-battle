/* Sequencer and MIDI state, recovered from the 16-bit sound driver.
 * Offsets are part of the driver ABI. Compile with one-byte packing.
 */
#ifndef MIDISND_H
#define MIDISND_H
typedef unsigned char MByte;
typedef unsigned short MWord;
typedef unsigned long MLong;
typedef struct MSequence MSequence;
typedef struct MPlayer MPlayer;
typedef struct MHooks MHooks;
typedef struct MHeld MHeld;
struct MHooks {
    MByte jump, transpose;
    MByte on[16], volume[16], instrument[16], part_transpose[16];
};
struct MPlayer {
    MSequence *sequence;
    MHooks *hooks;
    void *parts;
    MByte active, reserved7;
    MWord sound;
    MWord volume_channel;
    MByte priority, volume, effective_volume, pan, transpose, detune;
};
struct MSequence {
    MPlayer *owner;                       /* 00 */
    MByte active, reserved3;               /* 02 */
    MWord sound;                         /* 04 */
    MLong offset;                        /* 06 */
    MWord track, beat, tick;              /* 0a */
    MLong time, next, fraction;            /* 10 */
    MLong tempo, rate;                    /* 1c */
    MByte speed, reserved25;              /* 24, 25 */
    MLong tick_rate;                      /* 26 */
    MWord loop_count, start_beat, start_tick, end_beat, end_tick;
};
struct MHeld {
    MHeld *previous, *next;
    MByte note, channel;
    MSequence *sequence;
    MLong duration, time, fraction;
};
typedef struct {
    MByte active, pad1;
    MPlayer *player;
    MByte volume, pad5;
    MWord total, remaining;
    signed char step, direction, remainder;
    MByte pad13;
    MWord accumulated;
} MFade;
typedef struct { MWord kind, args[7]; } MCommand;

typedef char MPlayer_size_check[sizeof(MPlayer) == 18 ? 1 : -1];
typedef char MSequence_size_check[sizeof(MSequence) == 52 ? 1 : -1];
typedef char MHooks_size_check[sizeof(MHooks) == 66 ? 1 : -1];
typedef char MHeld_size_check[sizeof(MHeld) == 20 ? 1 : -1];
typedef char MFade_size_check[sizeof(MFade) == 16 ? 1 : -1];
typedef char MCommand_size_check[sizeof(MCommand) == 16 ? 1 : -1];

extern MByte snd_midi_tags[8], snd_midi_lengths[8];
extern MWord snd_channel_masks[16];
extern MLong snd_tick_period;
extern MByte snd_parse_nesting, snd_parse_finished;
extern MByte far *snd_parse_cursor;
extern MByte snd_event_channel, snd_event_note, snd_event_velocity;
extern MWord snd_scan_note_count, snd_note_channels[128];
extern MLong snd_scan_end_tick;
extern MByte snd_sysex_buffer[128];
extern MSequence snd_sequences[2];
extern MHeld *snd_held_active, *snd_held_free, *snd_held_cursor;
extern MWord snd_fade_tick_scale;
extern MByte snd_fade_state;
extern MFade snd_fades[2];
extern int snd_queue_read, snd_queue_write;
extern MCommand snd_queue[64];
extern MByte snd_building_queue, snd_queued_marker;
extern MWord snd_queued_sound, snd_trigger_count;
extern int snd_scanning, snd_disabled;

extern MByte far * near snd_0406(MWord, MLong, MWord);
extern MWord near snd_04CC(MByte *);
extern void near snd_0643(MPlayer *);
extern void near snd_075E(MPlayer *, MByte);
extern void near snd_07AA(MPlayer *, MByte, MByte);
extern void near snd_0814(MSequence *, MByte);
extern int near snd_0857(MSequence *, MWord, MWord, MWord);
extern void near snd_216C(MPlayer *, MByte, MByte, MByte);
extern void near snd_21A2(MPlayer *, MByte, MByte);
extern void near snd_222F(void *, MWord *, MWord *);
extern void near snd_2277(MPlayer *, MByte, MByte);
extern void near snd_235A(MPlayer *, MByte, MByte);
extern void near snd_23D2(MPlayer *, MByte, MByte, MByte);
extern void near snd_2509(MPlayer *, MByte, MByte);
extern int far snd_00FE(MWord, MWord, MWord, MWord, MWord, MWord, MWord, MWord);

int near snd_0DB9(MSequence *, MWord);
void near snd_0E6A(MSequence *);
void near snd_0E7C(void);
void near snd_0FBE(MSequence *, MLong);
MLong near snd_101E(MByte far **);
MLong near snd_1041(MByte far *, MByte far *);
void near snd_1086(MHooks *);
void near snd_109C(MPlayer *, MByte *);
void near snd_10E7(MPlayer *, MByte *);
void near snd_1118(MPlayer *, MByte *);
void near snd_114D(MPlayer *, MByte *);
void near snd_1182(MPlayer *, MByte *);
void near snd_11B7(MPlayer *, MByte *);
int near snd_11F0(MHooks *, MByte, MByte);
void near snd_1263(void);
void near snd_12D8(MSequence *, MByte far *, MByte far *, MLong);
int near snd_1537(MByte far **);
void near snd_15DF(void);
void near snd_15F0(MByte, MByte);
void near snd_160C(MByte, MByte);
void near snd_162A(MPlayer *);
int near snd_167E(void);
void near snd_1684(MPlayer *);
void near snd_16A5(void);
void near snd_171D(MPlayer *, MByte);
int near snd_17BB(int);
int near snd_17FC(MWord);
void near snd_183E(MPlayer *, MByte far **);
void near snd_1A4A(MPlayer *, MByte far *, int);
void near snd_1D49(MByte far *, MByte *, unsigned);
void near snd_1D6D(MByte far **);
int near snd_1DC6(void);
int far snd_1DDB(void);
#endif
