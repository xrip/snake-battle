/* Reconstructed C control layer of the original 1341 sound segment.
 * Addresses in names are original CS offsets, not source provenance claims.
 * The corresponding native comparison report distinguishes exact functions
 * from unresolved compiler differences and original assembly interventions.
 */
#include "SOUND.H"

long far snd_000C(SoundBytes far *resources) { return snd_0158(resources); }
long far snd_001E(void) { return snd_01A7(); }
long far snd_0022(void) { return snd_01CB(); }
long far snd_0026(void) { return snd_01D5(); }
long far snd_002A(SW sound) { return snd_021C(sound); }
long far snd_0039(SW sound) { return snd_0269(sound); }
long far snd_0048(SW sound) { return snd_02B7(sound); }
int far snd_0057(SW sound, SW volume, SW time) {
    return ((int (near *)())snd_02E4)(13, sound, volume, time);
}

long far snd_00FE(SW command, SW a, SW b, SW c, SW d, SW e, SW f, SW g) {
    int index = command & 255;
    switch (command >> 8) {
    case 0:
        if (index < 14 && snd_basic_commands[index])
            return snd_basic_commands[index](a, b, c);
        break;
    case 1:
        return snd_02E4(index, a, b, c, d, e, f, g);
    }
    return -1;
}

long near snd_0158(SoundBytes far *resources) {
    if (snd_320A() == 0) {
        snd_resources = resources;
        snd_master_volume = 127;
        snd_3283();
        snd_32AF();
        snd_3362();
        snd_32CF();
        snd_32EB();
        snd_3303();
        snd_332F();
        snd_scanning = 0;
        snd_paused = 0;
        snd_disabled = 0;
        snd_00B4();
        snd_basic_commands[0] = 0;
        return 0;
    }
    return -1;
}

long near snd_01A7(void) {
    snd_paused = 1;
    snd_disabled = 1;
    snd_00E7();
    snd_1FCC();
    snd_167E();
    snd_parse_nesting = 100;
    snd_029B();
    snd_basic_commands[0] = (BasicCommand)snd_0158;
    return 0;
}
long near snd_01CB(void) { snd_paused = 1; return 0; }
long near snd_01D5(void) { snd_paused = 0; return 0; }

long near snd_01DC(signed char volume) {
    Player near *player;
    int count;
    if ((SB)volume > 127) volume = 127;
    snd_master_volume = volume;
    player = snd_players;
    count = 2;
    do {
        if (player->state) snd_075E(player, player->volume);
        ++player;
    } while (--count);
    return 0;
}
long near snd_0217(void) { return snd_master_volume; }

long near snd_021C(SW sound) {
    Player near *player;
    if (snd_0406(sound, snd_midi_tags[0], 0)) {
        player = snd_05A6(128);
        if (player) {
            snd_0643(player);
            if (snd_05E8(player, sound)) return 0;
        }
    }
    return -1;
}

long near snd_0269(SW sound) {
    Player near *player = snd_players;
    int result = -1;
    do {
        if (player->state == 1 && player->sound == sound) {
            snd_0643(player);
            result = 0;
        }
        ++player;
    } while (player < snd_players + 2);
    return result;
}

long near snd_029B(void) {
    Player near *player;
    snd_0DA8();
    player = snd_players;
    do {
        snd_0643(player);
        ++player;
    } while (player < snd_players + 2);
    return 0;
}

long near snd_02B7(SW sound) {
    Player near *player = snd_players;
    int count = 2;
    do {
        if (player->state == 1 && player->sound == sound) return 1;
        ++player;
    } while (--count);
    return snd_17FC(sound);
}

int near snd_02E4(int command, SW a, SW b, SW c, SW d, SW e, SW f, SW g) {
    ExtendedCommand function;
    Player near *player;
    if (command >= 24) return -1;
    function = snd_extended_commands[command];
    if (!function) return -1;
    switch (snd_command_kinds[command]) {
    case 0:
        return function(a, b, c, d, e, f, g);
    case 1:
        player = snd_0574(a);
        if (!player) return -1;
        return function(player, b, c);
    case 2:
        player = snd_0574(a);
        if (!player) return -1;
        return function(player->sequence, b, c, d, e, f, g);
    case 3:
        player = snd_0574(a);
        if (!player) return -1;
        return function(player, b, c);
    case 4:
        player = snd_0574(a);
        if (!player) return -1;
        return function(player->hooks, b, c, d);
    case 5:
        /* The native driver replaces the player lookup with XOR AX,AX,
         * but keeps the dead call sequence. Its assembly is recorded below
         * in the coverage report; ordinary C eliminates this dead block. */
        player = 0;
        if (!player) return -1;
        return function(player, a, b);
    case 6:
        player = 0;
        if (!player) return -1;
        return function(player->hooks, a, b, c);
    }
    return -1;
}

SoundBytes near snd_0406(SW sound, SD tag, SW index) {
    SoundBytes chunk = snd_resources[sound];
    if (chunk && *(SD far *)chunk == 0x6468544dUL) {
        if ((SW)(tag >> 16) == 0x6468) return chunk + 8;
        if (((SW)((SW far *)chunk)[5] >> 8 |
             (SW)((SW far *)chunk)[5] << 8) <= index) index = 0;
        do {
            chunk += 4;
            chunk += (SW)snd_04B8(chunk) + 4;
        } while ((int)--index >= 0);
        if (*(SD far *)chunk == tag) return chunk + 8;
    }
    return 0;
}

SD near snd_04B8(const void far *p) {
    const SW far *words = (const SW far *)p;
    SW high = words[0], low = words[1];
    return ((SD)((high >> 8) | (high << 8)) << 16) |
           (SW)((low >> 8) | (low << 8));
}
SW near snd_04CC(const void near *p) {
    SW word = *(const SW near *)p;
    return (word >> 8) | (word << 8);
}
int near snd_04D9(int value, int low, int high) {
    if (value < low) value = low;
    else if (value > high) value = high;
    return value;
}
int near snd_04F4(int value, int low, int high) {
    if (value <= low) value += ((unsigned)(low - value + 11) / 12) * 12;
    if (value > high) value -= ((unsigned)(value - high + 11) / 12) * 12;
    return value;
}

/* The separate 053D routine is an assembler copy primitive, with return AX=0. */
void near snd_055E(void) {
    if (!(snd_disabled | snd_paused)) {
        snd_0E7C();
        snd_1263();
        snd_1E1A();
        snd_16A5();
    }
}
Player near * near snd_0574(SW sound) {
    Player near *player = snd_players, near *found;
    int count = 2, matches = -1;
    do {
        if (player->state == 1 && player->sound == sound) {
            found = player;
            ++matches;
        }
        ++player;
    } while (--count);
    if (matches) return 0;
    return found;
}
Player near * near snd_05A6(SB priority) {
    Player near *player = snd_players, near *candidate = 0;
    int i = 0;
    SB lowest = 255;
    do {
        if (!player->state) return player;
        if (player->state == 1 && player->priority <= lowest) {
            lowest = player->priority;
            candidate = player;
        }
        ++player;
    } while (++i < 2);
    if (priority >= lowest) return candidate;
    return 0;
}
int near snd_05E8(Player near *player, SW sound) {
    int result;
    player->parts = 0;
    player->state = 1;
    player->sound = sound;
    player->priority = 128;
    player->volume = 127;
    player->volume_channel = -1;
    player->effective_volume = ((player->volume + 1) * snd_master_volume) >> 7;
    player->pan = 0;
    player->transpose = 0;
    player->detune = 0;
    snd_1086(player->hooks);
    result = snd_0DB9(player->sequence, sound);
    if (!result) player->state = 0;
    return result;
}
void near snd_0643(Player near *player) {
    if (player->state == 1) {
        snd_0E6A(player->sequence);
        snd_1684(player);
        snd_20E7(player);
        player->state = 0;
    }
}

int near snd_066B(Player near *player, SW parameter, SB channel) {
    switch (parameter) {
    case 0: return player->priority;
    case 1: return player->volume;
    case 2: return (SB)player->pan;
    case 3: return (SB)player->transpose;
    case 4: return (SB)player->detune;
    case 5: return player->sequence->speed;
    case 6: return player->sequence->track;
    case 7: return player->sequence->beat;
    case 8: return player->sequence->tick;
    case 9: return player->sequence->loop_count;
    case 10: return player->sequence->start_beat;
    case 11: return player->sequence->start_tick;
    case 12: return player->sequence->end_beat;
    case 13: return player->sequence->end_tick;
    case 14: case 15: case 16: case 17:
        return snd_261A(player, parameter, channel);
    case 18: case 19: case 20: case 21: case 22: case 23:
        return snd_11F0(player->hooks, parameter, channel);
    }
    return -1;
}
int near snd_0743(Player near *player, SB priority) {
    player->priority = priority;
    snd_22F1(player, 16, priority);
    return 0;
}
int near snd_075E(Player near *player, signed char volume) {
    if ((SB)volume > 127) volume = 127;
    player->volume = volume;
    player->effective_volume = ((volume + 1) * snd_master_volume) >> 7;
    snd_235A(player, 16, player->effective_volume);
    return 0;
}
int near snd_078F(Player near *player, signed char pan) {
    player->pan = pan;
    snd_23D1(player, 16, pan);
    return 0;
}
int near snd_07AA(Player near *player, SB relative, signed char transpose) {
    if (transpose > 24 || transpose < -24 || relative > 1) return -1;
    if (relative) transpose = snd_04F4(transpose + player->transpose, -7, 7);
    player->transpose = transpose;
    snd_23D2(player, 16, relative, transpose);
    return 0;
}
int near snd_07F9(Player near *player, signed char detune) {
    player->detune = detune;
    snd_247E(player, 16, detune);
    return 0;
}
int near snd_0814(Sequence near *sequence, SB speed) {
    sequence->speed = speed;
    sequence->tick_rate = (sequence->rate * speed) >> 7;
    return 0;
}

int near snd_0857(Sequence near *sequence, SW track, SW beat, SW tick) {
    SoundBytes new_track, old_track;
    SD target, next, offset;
    if (!sequence->active) return -1;
    new_track = snd_0406(sequence->sound, snd_midi_tags[1], track);
    if (!new_track) return -1;
    old_track = snd_0406(sequence->sound, snd_midi_tags[1], sequence->track);
    if (!old_track) return -1;
    ++snd_parse_nesting;
    if (!beat) beat = 1;
    target = (SD)(beat - 1) * 480U + tick;
    if (sequence->track == track && sequence->time <= target) {
        snd_parse_cursor = new_track + (SW)sequence->offset;
        next = sequence->next;
    } else {
        snd_parse_cursor = new_track;
        next = snd_101E(&snd_parse_cursor);
    }
    while (next < target) {
        snd_1D6D(&snd_parse_cursor);
        if (!snd_parse_cursor) {
            --snd_parse_nesting;
            return -1;
        }
        next += snd_101E(&snd_parse_cursor);
    }
    offset = snd_1041(snd_parse_cursor, new_track);
    snd_2209(sequence->owner->parts);
    snd_12D8(sequence, old_track + (SW)sequence->offset,
             new_track + (SW)offset, next - target);
    sequence->beat = beat;
    sequence->tick = tick;
    sequence->time = target;
    sequence->next = next;
    sequence->fraction = 0;
    sequence->offset = offset;
    if (sequence->track != track) {
        sequence->track = track;
        sequence->loop_count = 0;
    }
    snd_parse_finished = 1;
    --snd_parse_nesting;
    return 0;
}

int near snd_09F4(Sequence near *sequence, SW track, SW beat, SW tick) {
    /* C candidate limitation: native 0A02 complements the incoming AX with
     * XOR AX,0FFFFh. The inactive-sequence error path does not first define
     * AX, so the logical -1 returns here do not reproduce every register
     * state. exact/CONTROL.ASM preserves the observed instruction behavior. */
    SoundBytes track_data;
    SD target, next, offset;
    if (!sequence->active) return -1;
    track_data = snd_0406(sequence->sound, snd_midi_tags[1], track);
    if (!track_data) return -1;
    ++snd_parse_nesting;
    if (!beat) beat = 1;
    target = (SD)(beat - 1) * 480U + tick;
    snd_21EF(sequence->owner->parts);
    snd_15DF();
    snd_scanning = 1;
    snd_parse_cursor = track_data;
    next = snd_101E(&snd_parse_cursor);
    while (target > next) {
        snd_183E(sequence->owner, &snd_parse_cursor);
        if (!snd_parse_cursor) {
            --snd_parse_nesting;
            snd_scanning = 0;
            return -1;
        }
        next += snd_101E(&snd_parse_cursor);
    }
    offset = snd_1041(snd_parse_cursor, track_data);
    snd_scanning = 0;
    snd_162A(sequence->owner);
    sequence->beat = beat;
    sequence->tick = tick;
    sequence->time = target;
    sequence->next = next;
    sequence->fraction = 0;
    sequence->offset = offset;
    if (sequence->track != track) sequence->track = track;
    --snd_parse_nesting;
    return 0;
}

int near snd_0B2E(Sequence near *sequence, SW count, SW beat1, SW tick1, SW beat2, SW tick2) {
    if (beat1 + 1U >= beat2) return -1;
    if (!beat1) ++beat1;
    sequence->loop_count = 0;
    sequence->start_beat = beat1;
    sequence->start_tick = tick1;
    sequence->end_beat = beat2;
    sequence->end_tick = tick2;
    sequence->loop_count = count;
    return 0;
}
int near snd_0B6E(Sequence near *sequence) {
    sequence->loop_count = 0;
    return 0;
}

int near snd_0B7E(Hooks near *hooks, SB kind, SB value, SB channel) {
    SB near *bytes;
    SW near *words;
    SW segment;
    int count;
    switch (kind) {
    case 0: hooks->jump = value; return 0;
    case 1: hooks->transpose = value; return 0;
    case 2: bytes = hooks->part_enable; break;
    case 3: bytes = hooks->part_volume; break;
    case 4: bytes = hooks->part_program; break;
    case 5: bytes = hooks->part_transpose; break;
    default: return -1;
    }
    if (channel > 16) return -1;
    if (channel < 16) bytes[channel] = value;
    else {
        /* Preserve the observed native register-clobber behavior: the
         * original prepares AH=AL=value, then overwrites AX with DS while
         * setting ES, and fills eight words with DS, not the requested byte.
         * This typed reconstruction retains that behavior explicitly. */
        _asm mov segment,ds
        words = (SW near *)bytes;
        count = 8;
        do { *words++ = segment; } while (--count);
    }
    return 0;
}

int near snd_0C3D(Player near *player, SB target, SW duration) {
    Fade near *fade;
    int count, difference, quotient, remainder;
    snd_1684(player);
    if (!duration) snd_075E(player, target);
    else {
        snd_fade_state = 1;
        fade = snd_fades;
        count = 2;
        do {
            if (!fade->active) break;
            ++fade;
        } while (--count);
        if (!count) return -1;
        fade->player = player;
        fade->remaining = fade->total = duration;
        fade->active = 1;
        fade->volume = ((int (near *)())snd_066B)(player, 1);
        difference = target - fade->volume;
        quotient = difference / (int)duration;
        remainder = difference % (int)duration;
        fade->step = quotient;
        fade->direction = 1;
        if (difference < 0) {
            remainder = -remainder;
            fade->direction = -1;
        }
        fade->remainder = remainder;
        fade->accumulator = 0;
    }
    return 0;
}
int near snd_0CC3(SW sound, SB marker) {
    int write = snd_queue_write;
    snd_queue[write].args[0] = 0;
    snd_queue[write].args[1] = sound;
    snd_queue[write].args[2] = marker;
    if (++write >= 64) write = 0;
    if (snd_queue_read == write) {
        snd_queue_write = --write;
        if (write < 0) snd_queue_write = 63;
        return -1;
    }
    snd_queue_write = write;
    snd_queued_sound = sound;
    snd_queued_marker = marker;
    snd_building_queue = 1;
    return 0;
}
int near snd_0D1F(int command, SW a, SW b, SW c, SW d, SW e, SW f) {
    int write = snd_queue_write;
    if (write == snd_queue_read) return -1;
    if (command == -1) {
        snd_building_queue = 0;
        ++snd_trigger_count;
    } else {
        snd_queue[write].args[0] = 1;
        snd_queue[write].args[1] = command;
        snd_queue[write].args[2] = a;
        snd_queue[write].args[3] = b;
        snd_queue[write].args[4] = c;
        snd_queue[write].args[5] = d;
        snd_queue[write].args[6] = e;
        snd_queue[write].args[7] = f;
        if (++write >= 64) write = 0;
        if (write == snd_queue_read) {
            snd_queue_write = --write;
            if (write < 0) snd_queue_write = 63;
            return -1;
        }
        snd_queue_write = write;
    }
    return 0;
}
int near snd_0DA8(void) {
    snd_building_queue = 0;
    snd_queue_write = 0;
    snd_queue_read = 0;
    snd_trigger_count = 0;
    return 0;
}

void near snd_3283(void) {
    Player near *player = snd_players;
    unsigned i = 0;
    do {
        player->state = 0;
        player->sequence = snd_sequences + (SB)i;
        player->sequence->owner = player;
        player->hooks = snd_hooks + (SB)i;
        ++player;
    } while (++i < 2);
}
void near snd_32AF(void) {
    Sequence near *sequence = snd_sequences;
    int count = 2;
    do {
        sequence->active = 0;
        ++sequence;
    } while (--count);
    snd_tick_period = 0x00248c77UL;
    snd_parse_nesting = 0;
}
void near snd_32CF(void) {
    HeldNote near *node = snd_held_notes, near *previous = 0;
    int count = 24;
    snd_held_cursor = snd_held_active = 0;
    do {
        node->next = previous;
        previous = node;
        ++node;
    } while (--count);
    snd_held_free = previous;
}
void near snd_32EB(void) {
    Fade near *fade = snd_fades;
    int count = 2;
    do { fade->active = 0; ++fade; } while (--count);
    snd_fade_state = 0;
    snd_fade_tick_scale = 1;
}
void near snd_3303(void) {
    Part near *part = snd_parts;
    unsigned i = 0;
    do {
        part->owner = 0;
        part->previous = 0;
        part->next = 0;
        part->voices = 0;
        part->instrument = snd_part_instruments[(SB)i];
        ++part;
    } while (++i < 32);
    snd_1DDB();
}
void near snd_332F(void) {
    int x, y, product;
    for (x = 0; x < 64; ++x) {
        product = x;
        for (y = 0; y < 32; ++y) {
            snd_volume_products[x][y] = product >> 5;
            product += x;
        }
    }
    for (x = 0; x < 64; ++x) snd_volume_products[x][0] = 0;
}
void near snd_3362(void) {
    snd_building_queue = 0;
    snd_queue_write = 0;
    snd_queue_read = 0;
    snd_trigger_count = 0;
}
