
/* Reconstructed initialized data and zero-fill storage of sound module 1341.
 * These are resource tables and runtime state, never executable instructions.
 * Field names record verified uses; state[] areas retain known record extents
 * until their complete per-field semantics have been independently established.
 * Compile with byte packing. Original DS origins are shown at each definition.
 */
#include "SNDATA.H"




extern int near snd_0158();
extern int near snd_01A7();
extern int near snd_01CB();
extern int near snd_01D5();
extern int near snd_01DC();
extern int near snd_0217();
extern int near snd_021C();
extern int near snd_0269();
extern int near snd_029B();
extern int near snd_02B7();
extern int near snd_066B();
extern int near snd_0857();
extern int near snd_0C3D();
extern int near snd_235A();

/* DS:0F08, 28 bytes. */
SndProc snd_basic_commands[14] = {
    (SndProc)snd_0158, (SndProc)snd_01A7, (SndProc)snd_01CB, (SndProc)snd_01D5, 0, 0, (SndProc)snd_01DC, (SndProc)snd_0217,
    (SndProc)snd_021C, (SndProc)snd_0269, 0, (SndProc)snd_029B, 0, (SndProc)snd_02B7
};

/* DS:0F24, 8 bytes. */
SndByte snd_midi_tags[8] = {
    'M', 'T', 'h', 'd', 'M', 'T', 'r', 'k'
};

/* DS:0F2C, 2 bytes. */
int snd_paused = 1;
/* DS:0F2E, 2 bytes. */
int snd_disabled = 1;
/* DS:0F30, 48 bytes. */
SndProc snd_extended_commands[24] = {
    (SndProc)snd_066B, 0, 0, 0, 0, 0, 0, (SndProc)snd_0857,
    0, 0, 0, 0, 0, (SndProc)snd_0C3D, 0, 0,
    0, 0, 0, 0, 0, 0, (SndProc)snd_235A, 0
};

/* DS:0F60, 24 bytes. */
SndByte snd_command_kinds[24] = {
    1, 1, 1, 1, 1, 1, 2, 2,
    2, 2, 2, 3, 4, 1, 0, 0,
    0, 0, 0, 5, 6, 1, 3, 0
};

/* DS:0F78, 8 bytes. */
SndByte snd_midi_lengths[8] = {
    2, 2, 2, 2, 1, 1, 2, 0
};

/* DS:0F80, 32 bytes. */
SndWord snd_channel_masks[16] = {
    0x0001, 0x0002, 0x0004, 0x0008, 0x0010, 0x0020, 0x0040, 0x0080,
    0x0100, 0x0200, 0x0400, 0x0800, 0x1000, 0x2000, 0x4000, 0x8000
};

/* DS:0FA0, 30 bytes. */
SndByte snd_default_instrument[30] = {
    0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0
};

/* DS:0FBE, 276 bytes. */
SndField snd_instrument_fields[69] = {
    {6, 0, 0x003F}, {9, 2, 0x007C}, {6, 6, 0x00C0}, {5, 0, 0x000F}, {7, 4, 0x00F0}, {7, 0, 0x000F}, {8, 4, 0x00F0}, {8, 0, 0x000F},
    {9, 0, 0x0003}, {5, 7, 0x0080}, {5, 6, 0x0040}, {5, 5, 0x0020}, {5, 4, 0x0010}, {1, 0, 0x003F}, {4, 2, 0x007C}, {1, 6, 0x00C0},
    {0, 0, 0x000F}, {2, 4, 0x00F0}, {2, 0, 0x000F}, {3, 4, 0x00F0}, {3, 0, 0x000F}, {4, 0, 0x0003}, {0, 7, 0x0080}, {0, 6, 0x0040},
    {0, 5, 0x0020}, {0, 4, 0x0010}, {10, 0, 0x0001}, {10, 1, 0x000E}, {11, 7, 0x0080}, {11, 6, 0x0040}, {11, 5, 0x0020}, {11, 4, 0x0010},
    {11, 0, 0x000F}, {12, 0, 0x00FF}, {13, 0, 0x007F}, {14, 0, 0x007F}, {15, 0, 0x007F}, {16, 0, 0x007F}, {17, 0, 0x007F}, {18, 0, 0x007F},
    {19, 0, 0x007F}, {13, 7, 0x0080}, {14, 7, 0x0080}, {15, 7, 0x0080}, {16, 7, 0x0080}, {17, 7, 0x0080}, {18, 7, 0x0080}, {19, 7, 0x0080},
    {20, 7, 0x0080}, {20, 6, 0x0040}, {20, 5, 0x0020}, {20, 4, 0x0010}, {20, 0, 0x000F}, {21, 0, 0x00FF}, {22, 0, 0x007F}, {23, 0, 0x007F},
    {24, 0, 0x007F}, {25, 0, 0x007F}, {26, 0, 0x007F}, {27, 0, 0x007F}, {28, 0, 0x007F}, {22, 7, 0x0080}, {23, 7, 0x0080}, {24, 7, 0x0080},
    {25, 7, 0x0080}, {26, 7, 0x0080}, {27, 7, 0x0080}, {28, 7, 0x0080}, {29, 0, 0x00FF}
};

/* DS:10D2, 16 bytes. */
SndByte snd_parameter_map[16] = {
    29, 28, 27, 0, 3, 4, 7, 8,
    13, 16, 17, 20, 21, 30, 31, 0
};

/* DS:10E2, 32 bytes. The first 15 words are parameter maxima.
 * The last two bytes at DS:1100 are the mutable PRNG seed (initially 1)
 * and a zero pad. The reserved parameter index 15 reads the same storage.
 * Link metadata exports the interior byte as _snd_random_seed; retaining
 * this contiguous object preserves both observed access patterns. */
SndWord snd_max_values[16] = {
    0x02FF, 0x001F, 0x0007, 0x003F, 0x000F, 0x000F, 0x000F, 0x0003,
    0x003F, 0x000F, 0x000F, 0x000F, 0x0003, 0x003E, 0x001F, 0x0001
};

/* DS:1102, 64 bytes. */
SndWord snd_step_counts[32] = {
    0x0001, 0x0002, 0x0004, 0x0005, 0x0006, 0x0007, 0x0008, 0x0009,
    0x000A, 0x000C, 0x000E, 0x0010, 0x0012, 0x0015, 0x0018, 0x001E,
    0x0024, 0x0032, 0x0040, 0x0052, 0x0064, 0x0088, 0x00A0, 0x00C0,
    0x00F0, 0x0114, 0x0154, 0x01CC, 0x0258, 0x035C, 0x04B0, 0x0640
};

/* DS:1142, 2 bytes. */
SndWord snd_opl_index_delay = 0x000A;
/* DS:1144, 2 bytes. */
SndWord snd_opl_data_delay = 0x0050;
/* DS:1146, 9 bytes. */
SndByte snd_modulator_slots[9] = {
    0, 1, 2, 8, 9, 10, 16, 17,
    18
};

/* DS:114F, 9 bytes. */
SndByte snd_carrier_slots[9] = {
    3, 4, 5, 11, 12, 13, 19, 20,
    21
};

/* DS:1158, 36 bytes. */
SndWord snd_channel_frequency[18] = {
    0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,
    0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,
    0x0000, 0x0000
};

/* DS:117C, 60 bytes. */
SndRegField snd_register_fields[15] = {
    {0x40, 0, 0x3F, 63}, {0xE0, 2, 0x00, 0}, {0x40, 6, 0xC0, 0}, {0x20, 0, 0x0F, 0}, {0x60, 4, 0xF0, 15}, {0x60, 0, 0x0F, 15}, {0x80, 4, 0xF0, 15}, {0x80, 0, 0x0F, 15},
    {0xE0, 0, 0x03, 0}, {0x20, 7, 0x80, 0}, {0x20, 6, 0x40, 0}, {0x20, 5, 0x20, 0}, {0x20, 4, 0x10, 0}, {0xC0, 0, 0x01, 0}, {0xC0, 1, 0x0E, 0}
};

/* DS:11B8, 144 bytes. */
SndByte snd_frequencies[144] = {
    90, 91, 92, 92, 93, 94, 94, 95,
    96, 96, 97, 98, 98, 99, 100, 101,
    101, 102, 103, 104, 104, 105, 106, 107,
    107, 108, 109, 110, 111, 111, 112, 113,
    114, 115, 115, 116, 117, 118, 119, 120,
    121, 121, 122, 123, 124, 125, 126, 127,
    128, 129, 130, 131, 132, 132, 133, 134,
    135, 136, 137, 138, 139, 140, 141, 142,
    143, 145, 146, 147, 148, 149, 150, 151,
    152, 153, 154, 155, 157, 158, 159, 160,
    161, 162, 163, 165, 166, 167, 168, 169,
    171, 172, 173, 174, 176, 177, 178, 180,
    181, 182, 184, 185, 186, 188, 189, 190,
    192, 193, 194, 196, 197, 199, 200, 202,
    203, 205, 206, 208, 209, 211, 212, 214,
    215, 217, 218, 220, 222, 223, 225, 226,
    228, 230, 231, 233, 235, 236, 238, 240,
    242, 243, 245, 247, 249, 251, 252, 254
};

/* DS:1248, 128 bytes. */
SndByte snd_octaves[128] = {
    0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 1, 1, 1, 1,
    1, 1, 1, 1, 1, 1, 1, 1,
    2, 2, 2, 2, 2, 2, 2, 2,
    2, 2, 2, 2, 3, 3, 3, 3,
    3, 3, 3, 3, 3, 3, 3, 3,
    4, 4, 4, 4, 4, 4, 4, 4,
    4, 4, 4, 4, 5, 5, 5, 5,
    5, 5, 5, 5, 5, 5, 5, 5,
    6, 6, 6, 6, 6, 6, 6, 6,
    6, 6, 6, 6, 7, 7, 7, 7,
    7, 7, 7, 7, 7, 7, 7, 7,
    7, 7, 7, 7, 7, 7, 7, 7,
    7, 7, 7, 7, 7, 7, 7, 7,
    7, 7, 7, 7, 7, 7, 7, 7,
    7, 7, 7, 7, 7, 7, 7, 7
};

/* DS:12C8, 132 bytes. */
SndByte snd_semitones[132] = {
    3, 4, 5, 6, 7, 8, 9, 10,
    11, 12, 13, 14, 3, 4, 5, 6,
    7, 8, 9, 10, 11, 12, 13, 14,
    3, 4, 5, 6, 7, 8, 9, 10,
    11, 12, 13, 14, 3, 4, 5, 6,
    7, 8, 9, 10, 11, 12, 13, 14,
    3, 4, 5, 6, 7, 8, 9, 10,
    11, 12, 13, 14, 3, 4, 5, 6,
    7, 8, 9, 10, 11, 12, 13, 14,
    3, 4, 5, 6, 7, 8, 9, 10,
    11, 12, 13, 14, 3, 4, 5, 6,
    7, 8, 9, 10, 11, 12, 13, 14,
    3, 4, 5, 6, 7, 8, 9, 10,
    11, 12, 13, 14, 3, 4, 5, 6,
    7, 8, 9, 10, 11, 12, 13, 14,
    3, 4, 5, 6, 7, 8, 9, 10,
    11, 12, 13, 14
};

/* Uninitialized state: exactly 8378 bytes, DS:413C..61F6.
 * Borland emits tentative definitions in reverse declaration order. */
SndByte snd_volume_products[64][32]; /* DS:59F6, 2048 bytes. */
SndByte snd_opl_cache[256]; /* DS:58F6, 256 bytes. */
SndByte snd_voice_counter_pad; /* DS:58F5, 1 unused byte. */
SndByte snd_voice_counter; /* DS:58F4, byte round-robin counter. */
SndByte snd_voice_tick_pad; /* DS:58F3, 1 unused byte. */
SndByte snd_voice_tick; /* DS:58F2, modulo-10 tick accumulator. */
SndVoice snd_voices[9]; /* DS:5580, 882 bytes. */
SndInstrument snd_global_instruments[32]; /* DS:51C0, 960 bytes. */
SndInstrument snd_part_instruments[32]; /* DS:4E00, 960 bytes. */
SndPart snd_parts[32]; /* DS:4A00, 1024 bytes. */
SndWord snd_scanning; /* DS:49FE, 2 bytes. */
SndWord snd_trigger_count; /* DS:49FC, 2 bytes. */
SndWord snd_queued_sound; /* DS:49FA, 2 bytes. */
SndByte snd_queued_marker; /* DS:49F9, 1 bytes. */
SndByte snd_building_queue; /* DS:49F8, 1 bytes. */
SndWord snd_queue_write; /* DS:49F6, 2 bytes. */
SndCommand snd_queue[64]; /* DS:45F6, 1024 bytes. */
SndWord snd_queue_read; /* DS:45F4, 2 bytes. */
SndFade snd_fades[2]; /* DS:45D4, 32 bytes. */
SndWord snd_fade_state; /* DS:45D2, 2 bytes. */
SndWord snd_fade_tick_scale; /* DS:45D0, 2 bytes. */
SndHeldNote near * snd_held_cursor; /* DS:45CE, 2 bytes. */
SndHeldNote near * snd_held_free; /* DS:45CC, 2 bytes. */
SndHeldNote near * snd_held_active; /* DS:45CA, 2 bytes. */
SndHeldNote snd_held_notes[24]; /* DS:43EA, 480 bytes. */
SndHooks snd_hooks[2]; /* DS:4366, 132 bytes. */
SndSequence snd_sequences[2]; /* DS:42FE, 104 bytes. */
SndPlayer snd_players[2]; /* DS:42DA, 36 bytes. */
SndByte snd_sysex_buffer[128]; /* DS:425A, 128 bytes. */
SndWord snd_note_channels[128]; /* DS:415A, 256 bytes. */
SndDword snd_scan_end_tick; /* DS:4156, 4 bytes. */
SndWord snd_scan_note_count; /* DS:4154, 2 bytes. */
SndWord snd_event_velocity; /* DS:4152, 2 bytes. */
SndWord snd_event_note; /* DS:4150, 2 bytes. */
SndWord snd_event_channel; /* DS:414E, 2 bytes. */
SndByte far * snd_parse_cursor; /* DS:414A, 4 bytes. */
SndByte snd_parse_finished; /* DS:4149, 1 bytes. */
SndByte snd_parse_nesting; /* DS:4148, 1 bytes. */
SndDword snd_tick_period; /* DS:4144, 4 bytes. */
SndWord snd_timer_accumulator; /* DS:4142, 2 bytes. */
SndByte far * far * snd_resources; /* DS:413E, 4 bytes. */
int snd_master_volume; /* DS:413C, 2 bytes. */

