#!/usr/bin/env python3
"""Semantic inventories for extracted GPF music, timbres, language and word grids.

Only extraction/inspection; original resource bytes remain in assets/resources.
AdLib MUS/SND field names cross-checked with AdPlug's independent player:
https://github.com/adplug/adplug/blob/master/src/mus.cpp
https://github.com/adplug/adplug/blob/master/src/composer.cpp
"""
import argparse
import json
import struct
from pathlib import Path

OPERATOR_FIELDS = ["key_scale_level", "frequency_multiplier", "feedback", "attack_rate",
                   "sustain_level", "sustaining_sound", "decay_rate", "release_rate",
                   "output_level", "amplitude_vibrato", "frequency_vibrato", "envelope_scaling", "fm_type"]


def snd(data):
    major, minor, count, offset = struct.unpack_from("<BBHH", data)
    if offset != 6 + 9 * count or len(data) != offset + count * 56:
        raise ValueError("unexpected SND bank layout")
    instruments = []
    for i in range(count):
        name = data[6 + 9 * i:15 + 9 * i].split(b"\0", 1)[0].decode("ascii")
        values = struct.unpack_from("<28H", data, offset + i * 56)
        instruments.append({"index": i, "name": name,
                            "modulator": dict(zip(OPERATOR_FIELDS, values[:13])),
                            "carrier": dict(zip(OPERATOR_FIELDS, values[13:26])),
                            "modulator_waveform": values[26], "carrier_waveform": values[27]})
    return {"format": "AdLib timbre bank", "version": [major, minor], "count": count,
            "definition_offset": offset, "instruments": instruments}


def mus(data):
    if len(data) < 70:
        raise ValueError("short AdLib MUS header")
    major, minor, tune_id = struct.unpack_from("<BBI", data)
    name = data[6:36].split(b"\0", 1)[0].decode("cp866")
    tick_beat, beat_measure, total_tick, data_size, commands = struct.unpack_from("<BBIII", data, 36)
    mode, pitch, tempo = struct.unpack_from("<BBH", data, 58)
    if len(data) != data_size + 70:
        raise ValueError("MUS dataSize mismatch")
    stream = data[70:]
    pos, clock, running = 0, 0, None
    events = []
    while pos < len(stream):
        start, delay = pos, 0
        while stream[pos] == 0xF8:
            delay += 240
            pos += 1
        delay += stream[pos]
        pos += 1
        clock += delay
        explicit = stream[pos] >= 0x80
        if explicit:
            status = stream[pos]
            pos += 1
        else:
            if running is None:
                raise ValueError("MUS running status before first status")
            status = running
        if status == 0xFC:
            payload = []
        elif status == 0xF0:
            end = stream.index(0xF7, pos)
            payload = list(stream[pos:end + 1])
            pos = end + 1
        else:
            running = status
            size = {0x80: 2, 0x90: 2, 0xA0: 1, 0xB0: 2, 0xC0: 1, 0xD0: 1, 0xE0: 2}.get(status & 0xF0)
            if size is None:
                raise ValueError(f"unknown MUS opcode {status:02X}")
            payload = list(stream[pos:pos + size])
            if len(payload) != size:
                raise ValueError("truncated MUS event")
            pos += size
        events.append({"offset": 70 + start, "ticks": clock, "delta": delay,
                       "status": status, "explicit_status": explicit, "data": payload})
        if status == 0xFC:
            break
    if pos != len(stream):
        raise ValueError("trailing bytes after MUS stop")
    return {"format": "AdLib MUS 1.0", "version": [major, minor], "tune_id": tune_id,
            "name": name, "ticks_per_beat": tick_beat, "beats_per_measure": beat_measure,
            "declared_total_ticks": total_tick, "observed_total_ticks": clock,
            "data_size": data_size, "declared_command_count": commands,
            "observed_command_count": len(events), "sound_mode": mode,
            "pitch_bend_range": pitch, "base_tempo": tempo, "events": events}


def vlq(data, pos):
    result = 0
    for _ in range(4):
        value = data[pos]
        pos += 1
        result = (result << 7) | (value & 127)
        if not value & 128:
            return result, pos
    raise ValueError("overlong MIDI VLQ")


def midi(data):
    if data[:4] != b"MThd":
        raise ValueError("no MIDI header")
    size = struct.unpack_from(">I", data, 4)[0]
    format_id, tracks, division = struct.unpack_from(">HHH", data, 8)
    offset, parsed = 8 + size, []
    for _ in range(tracks):
        if data[offset:offset + 4] != b"MTrk":
            raise ValueError("no MIDI track")
        length = struct.unpack_from(">I", data, offset + 4)[0]
        start = offset + 8
        end = start + length
        pos, clock, running, events = start, 0, None, []
        while pos < end:
            event_start = pos
            delta, pos = vlq(data, pos)
            clock += delta
            if data[pos] >= 128:
                status = data[pos]
                pos += 1
            elif running is not None:
                status = running
            else:
                raise ValueError("MIDI missing running status")
            subtype = None
            if status == 255:
                subtype = data[pos]
                pos += 1
                size, pos = vlq(data, pos)
            elif status in (240, 247):
                size, pos = vlq(data, pos)
            elif status < 240:
                running = status
                size = 1 if (status & 240) in (192, 208) else 2
            else:
                raise ValueError("unexpected MIDI system command")
            payload = data[pos:pos + size]
            pos += size
            if pos > end:
                raise ValueError("MIDI event beyond track")
            events.append({"offset": event_start, "ticks": clock, "delta": delta,
                           "status": status, "meta_type": subtype, "data_hex": payload.hex()})
        parsed.append({"offset": offset, "length": length, "total_ticks": clock, "events": events})
        offset = end
    if offset != len(data):
        raise ValueError("trailing MIDI chunks")
    return {"format": "Standard MIDI File", "midi_format": format_id,
            "track_count": tracks, "division": division, "tracks": parsed}


def password_grid(data):
    count = struct.unpack_from("<H", data)[0]
    if len(data) != 2 + count * 18:
        raise ValueError("word-grid length mismatch")
    records = []
    for i in range(count):
        record = data[2 + 18 * i:20 + 18 * i]
        prior = record[0] ^ record[1]
        decoded = bytearray()
        for value in record[2:]:
            decoded.append(value ^ prior)
            prior = value
        records.append({"index": i, "column": chr(record[0]), "row": record[1],
                        "decoded_16_hex": decoded.hex(), "repeated_word": decoded[:-1].decode("cp866"),
                        "word": decoded[:5].decode("cp866")})
    return {"format": "GAMOS five-column word grid", "count": count, "records": records}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("resources", type=Path)
    parser.add_argument("output", type=Path)
    args = parser.parse_args()
    args.output.mkdir(parents=True, exist_ok=True)
    inventory = []
    for path in sorted(args.resources.iterdir()):
        data = path.read_bytes()
        result = None
        if path.suffix == ".SND": result = snd(data)
        elif path.suffix == ".MUS": result = mus(data)
        elif path.suffix == ".MID": result = midi(data)
        elif path.name.startswith("PASSW."): result = password_grid(data)
        elif path.suffix == ".TXT":
            lines = data.decode("cp866").split("\r\n")
            result = {"format": "DOS CP866 CRLF text", "lines": [
                {"index": i, "characters": len(line), "text": line} for i, line in enumerate(lines)]}
            (args.output / (path.name + ".utf8.txt")).write_text(data.decode("cp866"))
        if result is not None:
            (args.output / (path.name + ".json")).write_text(json.dumps(result, ensure_ascii=False, indent=2) + "\n")
            item = {"name": path.name, "format": result["format"], "size": len(data)}
            for key in ("count", "observed_command_count", "observed_total_ticks", "declared_command_count", "declared_total_ticks", "track_count"):
                if key in result: item[key] = result[key]
            inventory.append(item)
    (args.output / "metadata-index.json").write_text(json.dumps(inventory, ensure_ascii=False, indent=2) + "\n")
    print(json.dumps(inventory, ensure_ascii=False, indent=2))


if __name__ == "__main__":
    main()
