/* Recovered AdLib parts, voice arbitration and software envelopes.
 * This is reconstructed C, not the historical author's source text.
 * The source follows the original behavior, including its edge cases.
 */
#include "ADLIB.H"

void near snd_1E1A(void)
{
    ALVoice near *v;
    int count;
    snd_voice_tick += 3;
    if (snd_voice_tick < 10) return;
    snd_voice_tick -= 10;
    v = snd_voices;
    count = 9;
    do {
        if (!v->owner) goto next_voice;
        if (v->timeout) {
            v->timeout -= 17;
            if (v->timeout <= 0) {
                snd_2BC4(v);
                return;
            }
        }
        if (v->envelope1.state)
            snd_28FB(v, &v->envelope1, &v->work1);
        if (v->envelope2.state)
            snd_28FB(v, &v->envelope2, &v->work2);
next_voice:
        ++v;
    } while (--count);
}

void near snd_1E83(ALPlayer near *player, ALByte near *preset)
{
    ALPart near *p;
    ALByte priority;
    priority = snd_04D9((signed char)preset[2] + player->priority, 0, 255);
    p = snd_2129(priority);
    if (p) {
        snd_2102(player, p);
        p->channel = preset[0];
        p->enabled = preset[1] & 1;
        p->priority_offset = preset[2];
        p->priority = priority;
        p->volume = preset[3];
        p->effective_volume = ((p->volume + 1) * player->volume) >> 7;
        p->pan = preset[4];
        p->effective_pan = snd_04D9(p->pan + player->pan, -64, 63);
        p->transpose = preset[5];
        p->effective_transpose = p->transpose == -128 ? 0 :
            snd_04F4(player->transpose + p->transpose, -12, 12);
        p->modulation = 0;
        p->sustain = 0;
        p->bend_range = preset[7];
        p->bend = 0;
        p->detune = preset[6];
        p->effective_detune = snd_04D9(player->detune + p->detune, -128, 127);
        p->pitch = snd_04D9(p->effective_transpose * 128 + p->effective_detune, -2048, 2047);
        snd_2277(player, p->channel, preset[8]);
    }
}

void near snd_1FA2(ALPart near *p, ALByte channel)
{
    if (p) {
        snd_1FA2(p->next, channel);
        if (p->channel == channel) snd_20AA(p);
    }
}

void near snd_1FCC(void)
{
    ALPart near *p;
    for (p = snd_parts; p < snd_parts + 32; ++p) snd_20AA(p);
    snd_1DC6();
}

ALPart near * near snd_1FE4(ALPlayer near *player, ALByte channel)
{
    ALPart near *p, near *old;
    for (p = player->parts; p; p = p->next)
        if (p->channel == channel) return p;
    p = snd_2129(player->priority);
    if (!p) return 0;
    p->owner = player;
    p->previous = 0;
    old = player->parts;
    p->next = old;
    player->parts = p;
    if (old) old->previous = p;
    p->channel = channel;
    p->uninitialized = 1;
    p->enabled = 1;
    p->priority = player->priority;
    p->volume = 127;
    p->effective_volume = player->volume;
    p->effective_pan = snd_04D9(player->pan, -64, 63);
    p->priority_offset = 0;
    p->pan = 0;
    p->transpose = 0;
    p->detune = 0;
    p->bend_range = 2;
    p->bend = 0;
    p->effective_detune = player->detune;
    p->effective_transpose = player->transpose;
    p->pitch = snd_04D9(p->effective_detune + p->effective_transpose * 128, -2048, 2047);
    p->modulation = 0;
    p->sustain = 0;
    p->program = 0;
    return p;
}

void near snd_20AA(ALPart near *p)
{
    ALPart near *previous, near *next;
    if (p->owner) {
        snd_2772(p);
        previous = p->previous;
        next = p->next;
        if (next) next->previous = previous;
        if (previous) previous->next = next;
        else p->owner->parts = next;
        p->owner = 0;
        p->previous = 0;
        p->next = 0;
    }
}

void near snd_20E7(ALPlayer near *player)
{
    while (player->parts) snd_20AA(player->parts);
}

void near snd_2102(ALPlayer near *player, ALPart near *p)
{
    ALPart near *old;
    p->previous = 0;
    p->owner = player;
    old = player->parts;
    p->next = old;
    player->parts = p;
    if (old) old->previous = p;
}

ALPart near * near snd_2129(ALByte priority)
{
    ALPart near *p, near *candidate;
    int count;
    candidate = 0;
    for (p = snd_parts, count = 0; count < 32; ++p, ++count) {
        if (!p->owner) return p;
        if (p->priority <= priority) {
            priority = p->priority;
            candidate = p;
        }
    }
    if (candidate) snd_20AA(candidate);
    return candidate;
}

void near snd_216C(ALPlayer near *player, ALByte channel, ALByte note, ALByte velocity)
{
    ALPart near *p = snd_1FE4(player, channel);
    if (p && p->enabled && !p->uninitialized) snd_2709(p, note, velocity);
}

void near snd_21A2(ALPlayer near *player, ALByte channel, ALByte note)
{
    ALPart near *p;
    for (p = player->parts; p; p = p->next) {
        if (p->channel == channel && p->enabled && !p->uninitialized) {
            if (p->sustain) snd_28BD(p->voices, note);
            else snd_2750(p->voices, note);
        }
    }
}

void near snd_21EF(ALPart near *p)
{
    for (; p; p = p->next) snd_2772(p);
}

void near snd_2209(ALPart near *p)
{
    for (; p; p = p->next)
        if (p->sustain) {
            p->sustain = 0;
            snd_28DB(p->voices);
        }
}

void near snd_222F(ALPart near *p, ALWord near *notes, int near *count)
{
    ALVoice near *v;
    ALWord mask;
    for (; p; p = p->next) {
        v = p->voices;
        if (v) {
            mask = snd_channel_masks[p->channel];
            do {
                if (!(notes[v->note] & mask)) {
                    notes[v->note] |= mask;
                    ++*count;
                }
                v = v->next;
            } while (v);
        }
    }
}

void near snd_2277(ALPlayer near *player, ALByte channel, ALByte program)
{
    ALPart near *p = snd_1FE4(player, channel);
    if (p) {
        p->program = program;
        snd_269B(p, program);
        p->uninitialized = 0;
    }
}

void near snd_22A4(ALPlayer near *player, ALByte channel, ALByte near *instrument)
{
    ALPart near *p = snd_1FE4(player, channel);
    if (p) {
        snd_2665(p, instrument);
        p->uninitialized = 0;
    }
}

void near snd_22CD(ALPlayer near *player, ALByte channel, int parameter, int value)
{
    ALPart near *p = snd_1FE4(player, channel);
    if (p) snd_26C3(p, parameter, value);
}

void near snd_22F1(ALPlayer near *player, ALByte channel, ALByte priority)
{
    ALPart near *p;
    if (channel == 16) {
        for (p = player->parts; p; p = p->next)
            p->priority = snd_04D9(p->priority_offset + priority, 0, 255);
    } else {
        p = snd_1FE4(player, channel);
        if (p) {
            p->priority_offset = priority;
            p->priority = snd_04D9((signed char)priority + p->owner->priority, 0, 255);
        }
    }
}

int near snd_235A(ALPlayer near *player, ALByte channel, ALByte volume)
{
    ALPart near *p;
    if (channel == 16) {
        for (p = player->parts; p; p = p->next) {
            p->effective_volume = ((p->volume + 1) * volume) >> 7;
            snd_2A87(p->voices, p->effective_volume);
        }
    } else {
        p = snd_1FE4(player, channel);
        if (!p) return -1;
        p->volume = volume;
        p->effective_volume = ((volume + 1) * p->owner->volume) >> 7;
        snd_2A87(p->voices, p->effective_volume);
    }
    return 0;
}

void near snd_23D1(void) { }

void near snd_23D2(ALPlayer near *player, ALByte channel, char relative, signed char transpose)
{
    ALPart near *p;
    if (transpose < 25 && transpose > -25) {
        if (channel == 16) {
            for (p = player->parts; p; p = p->next) {
                p->effective_transpose = snd_04F4(transpose + p->transpose, -24, 24);
                snd_2AD9(p->voices, p->effective_transpose);
            }
        } else {
            p = snd_1FE4(player, channel);
            if (p) {
                if (relative) transpose = snd_04F4(transpose + p->transpose, -7, 7);
                p->transpose = transpose;
                p->effective_transpose = snd_04F4(transpose + p->owner->transpose, -24, 24);
                snd_2AD9(p->voices, p->effective_transpose);
            }
        }
    }
}

void near snd_247E(ALPlayer near *player, ALByte channel, signed char detune)
{
    ALPart near *p;
    if (channel == 16) {
        for (p = player->parts; p; p = p->next) {
            p->effective_detune = snd_04D9(detune + p->detune, -128, 127);
            p->pitch = p->effective_detune + p->bend;
            snd_2B3F(p->voices, p->pitch);
        }
    } else {
        p = snd_1FE4(player, channel);
        if (p) {
            p->detune = detune;
            p->effective_detune = snd_04D9(p->owner->detune + detune, -128, 127);
            p->pitch = p->effective_detune + p->bend;
            snd_2B3F(p->voices, p->pitch);
        }
    }
}

int near snd_2509(ALPlayer near *player, ALByte channel, char enabled)
{
    ALPart near *p = snd_1FE4(player, channel);
    if (!p) return -1;
    p->enabled = enabled;
    if (!enabled) snd_2772(p);
    return 0;
}

void near snd_253C(ALPlayer near *player, ALByte channel, ALByte value)
{
    ALPart near *p = snd_1FE4(player, channel);
    if (p) {
        p->modulation = value;
        snd_2B03(p->voices, value);
    }
}

void near snd_2567(ALPlayer near *player, ALByte channel, char sustain)
{
    ALPart near *p = snd_1FE4(player, channel);
    if (p) {
        p->sustain = sustain;
        if (!sustain) snd_28DB(p->voices);
    }
}

void near snd_2594(ALPlayer near *player, ALByte channel, int bend)
{
    ALPart near *p = snd_1FE4(player, channel);
    if (p) {
        p->bend = ((long)p->bend_range * bend) >> 6;
        p->pitch = p->bend + p->effective_detune;
        snd_2B3F(p->voices, p->pitch);
    }
}

void near snd_25E7(ALPlayer near *player, ALByte channel, ALByte range)
{
    ALPart near *p;
    if (range < 13) {
        p = snd_1FE4(player, channel);
        if (p) {
            /* Original passes the low byte of the part pointer as channel. */
            snd_2594(player, (ALByte)(unsigned)p, 0);
            p->bend_range = range;
        }
    }
}

ALByte near snd_261A(ALPlayer near *player, char parameter, ALByte channel)
{
    ALPart near *p;
    for (p = player->parts; p; p = p->next)
        if (p->channel == channel) break;
    if (!p) return 0x81;
    switch (parameter) {
    case 14: return p->enabled;
    case 15: return p->volume;
    case 16: return p->program;
    case 17: return p->transpose;
    }
    return 0xff;
}

void near snd_2665(ALPart near *p, ALByte near *instrument)
{
    snd_053D(p->instrument, instrument, 30);
}

void near snd_2679(ALByte number, ALByte near *instrument)
{
    if (number < 32) snd_053D(snd_global_instruments[number], instrument, 30);
}

void near snd_269B(ALPart near *p, ALByte number)
{
    ALByte near *instrument;
    if (number < 32) instrument = snd_global_instruments[number];
    else instrument = snd_default_instrument;
    snd_053D(p->instrument, instrument, 30);
}

void near snd_26C3(ALPart near *p, int parameter, int value)
{
    ALField near *field = snd_instrument_fields + parameter;
    p->instrument[field->field] =
        (p->instrument[field->field] & ~(ALByte)field->mask) |
        ((ALByte)value << field->shift);
    snd_2A5E(p->voices, parameter, value);
}

void near snd_2709(ALPart near *p, ALByte note, ALByte velocity)
{
    ALVoice near *v, near *old;
    v = snd_2B6C(p->priority);
    if (v) {
        v->owner = p;
        old = p->voices;
        v->next = old;
        v->previous = 0;
        p->voices = v;
        if (old) old->previous = v;
        snd_278D(p, v, note, velocity);
    }
}

void near snd_2750(ALVoice near *v, ALByte note)
{
    for (; v; v = v->next) if (v->note == note) snd_2BC4(v);
}

void near snd_2772(ALPart near *p)
{
    while (p->voices) snd_2BC4(p->voices);
}

void near snd_278D(ALPart near *p, ALVoice near *v, ALByte note, ALByte velocity)
{
    ALByte near *instrument = p->instrument;
    ALByte level, carrier, modulator;
    ALByte near *volume_row;
    unsigned volume;
    v->additive = instrument[10] & 1;
    v->note = note;
    v->held = 0;
    v->timeout = instrument[29];
    if (v->timeout) v->timeout *= 63;
    volume_row = snd_volume_products[velocity >> 1];
    level = (instrument[1] & 63) + volume_row[instrument[4] >> 2];
    if (level > 63) level = 63;
    v->modulator_level = level;
    level = (instrument[6] & 63) + volume_row[instrument[9] >> 2];
    if (level > 63) level = 63;
    v->carrier_level = level;
    volume = p->effective_volume >> 2;
    carrier = snd_volume_products[level][volume];
    modulator = v->modulator_level;
    if (v->additive == 1) modulator = snd_volume_products[modulator][volume];
    snd_2E9B(v, instrument, modulator, carrier);
    snd_2F48(v->channel, note + p->effective_transpose, p->pitch);
    if (instrument[11] & 128)
        snd_29A1(v, &v->envelope1, &v->work1, instrument[11], instrument + 12);
    else v->envelope1.state = 0;
    if (instrument[20] & 128)
        snd_29A1(v, &v->envelope2, &v->work2, instrument[20], instrument + 21);
    else v->envelope2.state = 0;
}

void near snd_28BD(ALVoice near *v, ALByte note)
{
    for (; v; v = v->next) if (v->note == note) v->held = 1;
}

void near snd_28DB(ALVoice near *v)
{
    for (; v; v = v->next) if (v->held) snd_2BC4(v);
}

void near snd_28FB(ALVoice near *v, ALEnvelope near *e, ALWork near *w)
{
    ALByte changes = snd_2D33(e, w);
    int value;
    if (changes & 1) {
        switch (w->parameter) {
        case 0:
            v->carrier_level = e->base + w->value;
            value = snd_volume_products[v->carrier_level][v->owner->effective_volume >> 2];
            break;
        case 13:
            v->modulator_level = e->base + w->value;
            value = v->modulator_level;
            if (v->additive == 1)
                value = snd_volume_products[v->modulator_level][v->owner->effective_volume >> 2];
            break;
        case 30:
            w->peer->scale = w->value;
            goto done;
        case 31:
            w->peer->rate_scale = w->value;
            goto done;
        default:
            value = e->base + w->value;
        }
        snd_2FB1(v, w->parameter, value);
    }
done:
    if ((changes & 2) && w->retrigger) {
        _asm {
            mov bx, v
            mov ah, [bx+7]
            call snd_2FA0
        }
    }
}

void near snd_29A1(ALVoice near *v, ALEnvelope near *e, ALWork near *w, ALByte flags, ALByte near *data)
{
    w->value = 0;
    w->modulation = flags & 64;
    e->loop = flags & 32;
    w->retrigger = flags & 16;
    w->parameter = snd_parameter_map[flags & 15];
    e->maximum = snd_max_values[flags & 15];
    e->rate_scale = 31;
    e->scale = w->modulation ? v->owner->modulation >> 2 : 31;
    switch (w->parameter) {
    case 0: e->base = v->carrier_level; break;
    case 13: e->base = v->modulator_level; break;
    case 30: e->base = 31; w->peer->scale = 0; break;
    case 31: e->base = 0; w->peer->rate_scale = 0; break;
    default: e->base = snd_304C(v->channel, w->parameter);
    }
    snd_2BF6(e, data);
}

void near snd_2A5E(ALVoice near *v, int parameter, int value)
{
    if (parameter < 28)
        for (; v; v = v->next) snd_2FB1(v, parameter, value);
}

void near snd_2A87(ALVoice near *v, ALByte volume)
{
    for (; v; v = v->next) {
        snd_2FB1(v, 0, snd_volume_products[v->carrier_level][volume >> 2]);
        if (v->additive == 1)
            snd_2FB1(v, 13, snd_volume_products[v->modulator_level][volume >> 2]);
    }
}

void near snd_2AD9(ALVoice near *v, signed char transpose)
{
    for (; v; v = v->next)
        snd_2F6F(v->channel, v->note + transpose, v->owner->pitch);
}

void near snd_2B03(ALVoice near *v, ALByte value)
{
    for (; v; v = v->next) {
        if (v->envelope1.state && v->work1.modulation) v->envelope1.scale = value >> 2;
        if (v->envelope2.state && v->work2.modulation) v->envelope2.scale = value >> 2;
    }
}

void near snd_2B3F(ALVoice near *v, int pitch)
{
    for (; v; v = v->next)
        snd_2F6F(v->channel, v->owner->effective_transpose + v->note, pitch);
}

ALVoice near * near snd_2B6C(ALByte priority)
{
    ALVoice near *v, near *candidate = 0;
    int count = 9;
    do {
        if (++snd_voice_counter > 8) snd_voice_counter = 0;
        v = snd_voices + snd_voice_counter;
        if (!v->owner) return v;
        if (!v->next && v->owner->priority <= priority) {
            priority = v->owner->priority;
            candidate = v;
        }
    } while (--count);
    if (candidate) snd_2BC4(candidate);
    return candidate;
}

void near snd_2BC4(ALVoice near *v)
{
    ALVoice near *previous, near *next;
    _asm {
        mov bx, v
        mov ah, [bx+7]
        call snd_2F94
    }
    previous = v->previous;
    next = v->next;
    if (next) next->previous = previous;
    if (previous) previous->next = next;
    else v->owner->voices = next;
    v->owner = 0;
}

void near snd_2BF6(ALEnvelope near *e, ALByte near *data)
{
    e->state = 1;
    e->value = 0;
    e->previous_scale = 31;
    e->timeout = data[0];
    if (e->timeout) e->timeout *= 63;
    e->times[0] = data[1];
    e->times[1] = data[3];
    e->times[2] = data[5];
    e->times[3] = data[6];
    e->levels[0] = data[2];
    e->levels[1] = data[4];
    e->levels[2] = 0;
    e->levels[3] = data[7];
    snd_2C59(e);
}

void near snd_2C59(ALEnvelope near *e)
{
    ALByte stage = e->state - 1;
    int ticks, difference, maximum, base;
    ALByte level;
    int remainder;
    signed char direction;
    ticks = snd_step_counts[snd_volume_products[e->times[stage] & 127][e->rate_scale]];
    if (e->times[stage] & 128) ticks = snd_2E7A(ticks);
    if (!ticks) ticks = 1;
    e->total = e->ticks = ticks;
    if (stage == 2) difference = 0;
    else {
        maximum = e->maximum;
        base = e->base;
        level = e->levels[stage];
        difference = snd_2DD3(maximum, (level & 127) - 31);
        if (level & 128) difference = snd_2E7A(difference);
        if (difference + base > maximum) difference = maximum - base;
        else if (difference + base < 0) difference = -base;
        difference -= e->value;
    }
    e->step = difference / ticks;
    remainder = difference % ticks;
    direction = 1;
    if (difference < 0) {
        remainder = -remainder;
        direction = -direction;
    }
    e->direction = direction;
    e->remainder = remainder;
    e->accumulator = 0;
}

ALWord near snd_2D33(ALEnvelope near *e, ALWork near *w)
{
    ALWord changed = 0, total;
    int value;
    if (e->timeout) {
        e->timeout -= 17;
        if (e->timeout <= 0) {
            e->state = 0;
            return 0;
        }
    }
    value = e->value + e->step;
    total = e->total;
    e->accumulator += e->remainder;
    if (e->accumulator >= total) {
        e->accumulator -= total;
        value += e->direction;
    }
    if (e->value != value || e->scale != e->previous_scale) {
        e->value = value;
        e->previous_scale = e->scale;
        value = snd_2DD3(value, e->scale);
        if (value != w->value) {
            w->value = value;
            changed = 1;
        }
    }
    if (!--e->ticks) {
        if (++e->state > 4) {
            if (e->loop) {
                e->state = 1;
                changed |= 2;
            } else {
                e->state = 0;
                return changed;
            }
        }
        snd_2C59(e);
    }
    return changed;
}

int near snd_2DD3(int value, signed char scale)
{
    if (!scale) return 0;
    if (scale == 31) return value;
    if (value <= 63 && value >= -63) {
        if (scale < 0) {
            if (value < 0) return snd_volume_products[-value][-scale];
            return -snd_volume_products[value][-scale];
        } else {
            if (value < 0) return -snd_volume_products[-value][scale];
            return snd_volume_products[value][scale];
        }
    }
    return ((long)(value + 1) * scale) >> 5;
}

int near snd_2E7A(int value)
{
    ALByte bit, state;
    /* DS:1100 is also the low byte of the last snd_max_values element. */
    state = snd_random_seed;
    bit = state & 1;
    state >>= 1;
    if (bit) state ^= 0xb8;
    snd_random_seed = state;
    return ((long)state * value) >> 8;
}
