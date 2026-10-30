/* Recovered C implementation of the MIDI sequencer (1341:0DB9..1E1A).
 * The low-level ES:SI readers are separately documented original assembler
 * fragments. No executable bytes are used as source data.
 */
#include "MIDISND.H"
extern void *memset(void *, int, unsigned);
#pragma intrinsic(memset)
#define HIGH_WORD(x) (((MWord *)&(x))[1])
#define TRACK_TAG (*(MLong *)(snd_midi_tags + 4))

int near snd_0DB9(MSequence *seq, MWord sound)
{
    MByte far *base;
    seq->sound = sound;
    seq->track = 0;
    seq->fraction = 0;
    seq->loop_count = 0;
    seq->start_tick = 0;
    seq->end_tick = 0;
    seq->start_beat = 1;
    seq->end_beat = 1;
    snd_0FBE(seq, 500000UL);
    snd_0814(seq, 128);
    snd_parse_cursor = snd_0406(sound, TRACK_TAG, seq->track);
    if (!snd_parse_cursor) return 0;
    base = snd_parse_cursor;
    seq->time = seq->next = snd_101E(&snd_parse_cursor);
    seq->offset = snd_1041(snd_parse_cursor, base);
    seq->beat = (MWord)seq->next / 480 + 1;
    seq->tick = (MWord)seq->next % 480;
    return seq->active = 1;
}

void near snd_0E6A(MSequence *seq)
{
    seq->active = 0;
    snd_parse_finished = 1;
}

void near snd_0E7C(void)
{
    MByte far *base;
    MSequence *seq;
    int count;
    if (snd_parse_nesting) return;
    seq = snd_sequences;
    count = 2;
    do {
        if (seq->active == 1) {
            seq->fraction += seq->tick_rate;
            seq->time += HIGH_WORD(seq->fraction);
            seq->tick += HIGH_WORD(seq->fraction);
            HIGH_WORD(seq->fraction) = 0;
            if (seq->tick >= 480) {
                seq->beat += seq->tick / 480;
                seq->tick %= 480;
            }
            if (seq->loop_count && seq->beat >= seq->end_beat &&
                seq->tick >= seq->end_tick) {
                --seq->loop_count;
                snd_0857(seq, seq->track, seq->start_beat, seq->start_tick);
            }
            if (seq->next <= seq->time) {
                base = snd_0406(seq->sound, TRACK_TAG, seq->track);
                if (!base) snd_0643(seq->owner);
                snd_parse_cursor = base + (MWord)seq->offset;
                snd_parse_finished = 0;
                while (seq->next <= seq->time) {
                    snd_183E(seq->owner, &snd_parse_cursor);
                    if (!snd_parse_cursor || snd_parse_finished) goto next_sequence;
                    seq->next += snd_101E(&snd_parse_cursor);
                }
                if (snd_parse_cursor && !snd_parse_finished)
                    seq->offset = snd_1041(snd_parse_cursor, base);
            }
        }
next_sequence:
        ++seq;
    } while (--count);
}

void near snd_0FBE(MSequence *seq, MLong tempo)
{
    seq->tempo = tempo;
    seq->rate = (snd_tick_period << 10) / (MWord)(tempo >> 6);
    snd_0814(seq, (MByte)seq->speed);
}

/* snd_101E: carry-based ES:SI VLQ reader, see MIDIASM.ASM. */

MLong near snd_1041(MByte far *a, MByte far *b)
{
    long distance;
    distance = (((MLong)*(MWord *)((MByte *)&a + 2) << 4) + (MWord)a) -
               (((MLong)*(MWord *)((MByte *)&b + 2) << 4) + (MWord)b);
    return distance < 0 ? -distance : distance;
}

void near snd_1086(MHooks *hooks)
{
    memset(hooks, 0, sizeof(*hooks));
}

void near snd_109C(MPlayer *player, MByte *data)
{
    if (data[0]) {
        if (player->hooks->jump != data[0]) return;
        player->hooks->jump = 0;
    }
    snd_0857(player->sequence, snd_04CC(data + 1), snd_04CC(data + 3), snd_04CC(data + 5));
}

void near snd_10E7(MPlayer *player, MByte *data)
{
    if (data[0]) {
        if (player->hooks->transpose != data[0]) return;
        player->hooks->transpose = 0;
    }
    snd_07AA(player, data[1], data[2]);
}

void near snd_1118(MPlayer *player, MByte *data)
{
    MByte channel = data[0];
    MHooks *hooks = (MHooks *)((MByte *)player->hooks + channel);
    if (data[1]) {
        if (hooks->on[0] != data[1]) return;
        hooks->on[0] = 0;
    }
    snd_2509(player, channel, data[2]);
}

void near snd_114D(MPlayer *player, MByte *data)
{
    MByte channel = data[0];
    MHooks *hooks = (MHooks *)((MByte *)player->hooks + channel);
    if (data[1]) {
        if (hooks->volume[0] != data[1]) return;
        hooks->volume[0] = 0;
    }
    snd_235A(player, channel, data[2]);
}

void near snd_1182(MPlayer *player, MByte *data)
{
    MByte channel = data[0];
    MHooks *hooks = (MHooks *)((MByte *)player->hooks + channel);
    if (data[1]) {
        if (hooks->instrument[0] != data[1]) return;
        hooks->instrument[0] = 0;
    }
    snd_2277(player, channel, data[2]);
}

void near snd_11B7(MPlayer *player, MByte *data)
{
    MByte channel = data[0];
    MHooks *hooks = (MHooks *)((MByte *)player->hooks + channel);
    if (data[1]) {
        if (hooks->part_transpose[0] != data[1]) return;
        hooks->part_transpose[0] = 0;
    }
    snd_23D2(player, channel, data[2], data[3]);
}

int near snd_11F0(MHooks *hooks, MByte kind, MByte channel)
{
    switch (kind) {
    case 18: return hooks->jump;
    case 19: return hooks->transpose;
    case 20: return hooks->on[channel];
    case 21: return hooks->volume[channel];
    case 22: return hooks->instrument[channel];
    case 23: return hooks->part_transpose[channel];
    default: return -1;
    }
}

void near snd_1263(void)
{
    MHeld *note, *next;
    MSequence *seq;
    note = snd_held_active;
    while (note) {
        next = note->next;
        seq = note->sequence;
        note->fraction += seq->tick_rate;
        note->time += HIGH_WORD(note->fraction);
        HIGH_WORD(note->fraction) = 0;
        if (note->duration <= note->time) {
            snd_21A2(seq->owner, note->channel, note->note);
            if (next) next->previous = note->previous;
            if (note->previous) note->previous->next = next;
            else snd_held_active = next;
            note->next = snd_held_free;
            snd_held_free = note;
        }
        note = next;
    }
}

void near snd_12D8(MSequence *seq, MByte far *from, MByte far *to, MLong delta)
{
    MLong time;
    MWord mask, *bits;
    MHeld *note, *next, *tail;
    snd_15DF();
    snd_scan_note_count = 0;
    snd_222F(seq->owner->parts, snd_note_channels, &snd_scan_note_count);
    snd_parse_cursor = from;
    time = seq->next - seq->time;
    if ((long)time < 0) time = 0;
    while (snd_scan_note_count) {
        if (snd_1537(&snd_parse_cursor) == 1) {
            mask = snd_channel_masks[snd_event_channel];
            bits = &snd_note_channels[snd_event_note];
            if (*bits & mask) {
                *bits &= ~mask;
                --snd_scan_note_count;
                note = snd_held_free;
                if (!note) return;
                snd_held_free = note->next;
                next = note->next = snd_held_cursor;
                snd_held_cursor = note;
                note->previous = 0;
                if (next) next->previous = note;
                note->note = snd_event_note;
                note->channel = snd_event_channel;
                note->sequence = seq;
                note->duration = time;
                note->time = 0;
                note->fraction = 0;
            }
        }
        time += snd_101E(&snd_parse_cursor);
    }
    snd_scan_end_tick = 0;
    for (note = snd_held_cursor; note; note = note->next) {
        snd_note_channels[note->note] |= snd_channel_masks[note->channel];
        if (note->duration > snd_scan_end_tick) snd_scan_end_tick = note->duration;
    }
    snd_parse_cursor = to;
    time = delta;
    while (time < snd_scan_end_tick) {
        if (snd_1537(&snd_parse_cursor) == 2) {
            mask = snd_channel_masks[snd_event_channel];
            bits = &snd_note_channels[snd_event_note];
            if (*bits & mask) {
                note = snd_held_cursor;
                while (note) {
                    next = note->next;
                    if (note->note == snd_event_note &&
                        note->channel == snd_event_channel && note->duration > time) {
                        *bits &= ~mask;
                        if (next) next->previous = note->previous;
                        if (note->previous) note->previous->next = next;
                        else snd_held_cursor = next;
                        note->next = snd_held_free;
                        snd_held_free = note;
                    }
                    note = next;
                }
            }
        }
        time += snd_101E(&snd_parse_cursor);
    }
    if (!snd_held_active) {
        snd_held_active = snd_held_cursor;
        snd_held_cursor = 0;
        return;
    }
    for (tail = snd_held_active; tail->next; tail = tail->next) ;
    note = tail->next = snd_held_cursor;
    snd_held_cursor = 0;
    if (note) note->previous = tail;
}

/* snd_1537: note-only ES:SI event parser, see MIDIASM.ASM. */

void near snd_15DF(void)
{
    memset(snd_note_channels, 0, sizeof(snd_note_channels));
}

void near snd_15F0(MByte channel, MByte note)
{
    snd_note_channels[note] |= snd_channel_masks[channel];
}

void near snd_160C(MByte channel, MByte note)
{
    snd_note_channels[note] &= ~snd_channel_masks[channel];
}

void near snd_162A(MPlayer *player)
{
    MByte note, channel;
    MWord bits;
    for (note = 0; note < 128; ++note) {
        bits = snd_note_channels[note];
        if (bits) {
            for (channel = 0; channel < 16; ++channel)
                if (snd_channel_masks[channel] & bits)
                    snd_216C(player, channel, note, 80);
        }
    }
}

int near snd_167E(void)
{
    return snd_fade_state = 0;
}

void near snd_1684(MPlayer *player)
{
    MFade *fade = snd_fades;
    int count = 2;
    do {
        if (fade->active && fade->player == player) fade->active = 0;
        ++fade;
    } while (--count);
}

void near snd_16A5(void)
{
    MFade *fade;
    int count;
    MByte volume;
    if (!snd_fade_state) return;
    ++snd_fade_tick_scale;
    snd_fade_tick_scale &= 3;
    if (snd_fade_tick_scale) return;
    fade = snd_fades;
    snd_fade_state = 0;
    count = 2;
    do {
        if (fade->active) {
            snd_fade_state = 1;
            volume = fade->volume + fade->step;
            fade->accumulated += fade->remainder;
            if (fade->accumulated >= fade->total) {
                fade->accumulated -= fade->total;
                volume += fade->direction;
            }
            if (volume != fade->volume) {
                if (volume) {
                    fade->volume = volume;
                    snd_075E(fade->player, volume);
                } else {
                    snd_0643(fade->player);
                    fade->active = 0;
                }
            }
            if (!--fade->remaining) fade->active = 0;
        }
        ++fade;
    } while (--count);
}

void near snd_171D(MPlayer *player, MByte marker)
{
    int index;
    MWord sound;
    MCommand *command;
    if (snd_queue_read == snd_queue_write) return;
    sound = player->sound;
    if (snd_building_queue && snd_queued_sound == sound && snd_queued_marker == marker) return;
    command = &snd_queue[snd_queue_read];
    if (command->kind || command->args[0] != sound || command->args[1] != marker) return;
    --snd_trigger_count;
    for (;;) {
        index = snd_queue_read + 1;
        if (index >= 64) index = 0;
        if (index == snd_queue_write) break;
        command = &snd_queue[index];
        if (command->kind != 1) break;
        snd_queue_read = index;
        snd_00FE(command->args[0], command->args[1], command->args[2], command->args[3],
                 command->args[4], command->args[5], command->args[6], 0);
    }
    snd_queue_read = index;
}

int near snd_17BB(int what)
{
    switch (what) {
    case 0: return snd_trigger_count;
    case 1:
        if (snd_queue_write != snd_queue_read) return snd_queue[snd_queue_read].args[0];
        break;
    case 2:
        if (snd_queue_write != snd_queue_read) return snd_queue[snd_queue_read].args[1];
        break;
    }
    return -1;
}

int near snd_17FC(MWord sound)
{
    int index = snd_queue_read;
    int end = snd_queue_write;
    while (index != end) {
        if (snd_queue[index].kind == 1 && snd_queue[index].args[0] == 8 &&
            snd_queue[index].args[1] == sound) return 2;
        if (++index >= 64) index = 0;
    }
    return 0;
}

/* snd_183E / snd_1A4A: original ES:SI event/SysEx readers.
 * snd_1D49: original nibble packing routine. See MIDIASM.ASM.
 */

void near snd_1D6D(MByte far **cursor)
{
    MByte code = *(*cursor)++;
    if (code < 0x80) {
        *cursor += 1;
    } else if (code < 0xf0) {
        *cursor += snd_midi_lengths[(code & 0x70) >> 4];
    } else if (code == 0xf0 || code == 0xf7) {
        *cursor += (MWord)snd_101E(cursor);
    } else if (code == 0xff && *(*cursor)++ != 0x2f) {
        *cursor += (MWord)snd_101E(cursor);
    } else {
        *cursor = 0;
    }
}

/* snd_1DC6 / snd_1DDB: register-ABI OPL reset/init, see MIDIASM.ASM. */
