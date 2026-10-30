#!/usr/bin/env python3
"""Compare Borland OMF runtime candidates against an MZ image.

The output distinguishes stable-byte matches, independently resolved call-target
checks, MZ relocation checks, equivalent module aliases and small generic wrappers.
It does not infer an exclusive compiler version from a compatible runtime library.
"""
import argparse
import hashlib
import json
import struct
from collections import defaultdict
from pathlib import Path

import omf


def digest(path):
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()


def actual_reference(image, origin, segment, f):
    p, width = f["offset"], f["width"]
    raw = image[origin+p:origin+p+width]
    inline = int.from_bytes(segment.data[p:p+min(width, 2)], "little")
    addend = inline + f["displacement"]
    if f["location_type"] == 3:
        if p and segment.data[p-1] in (0x9a, 0xea):
            call = image[origin+p-1:origin+p+4]
            opcode = segment.data[p-1]
            if opcode == 0x9a and call[:3] == b"\x90\x0e\xe8":
                displacement = int.from_bytes(call[3:5], "little", signed=True)
                return dict(kind="relaxed_near_call", image_target=origin+p+4+displacement,
                            addend=addend, segment_relocation=None, raw_hex=call.hex())
            if opcode == 0x9a and call[:2] == b"\x0e\xe8" and call[4] == 0x90:
                displacement = int.from_bytes(call[2:4], "little", signed=True)
                return dict(kind="relaxed_near_call", image_target=origin+p+3+displacement,
                            addend=addend, segment_relocation=None, raw_hex=call.hex())
            if opcode == 0xea and call[:3] == b"\x90\x90\xe9":
                displacement = int.from_bytes(call[3:5], "little", signed=True)
                return dict(kind="relaxed_near_jump", image_target=origin+p+4+displacement,
                            addend=addend, segment_relocation=None, raw_hex=call.hex())
            if opcode == 0xea and call[0] == 0xe9 and call[3:] == b"\x90\x90":
                displacement = int.from_bytes(call[1:3], "little", signed=True)
                return dict(kind="relaxed_near_jump", image_target=origin+p+2+displacement,
                            addend=addend, segment_relocation=None, raw_hex=call.hex())
        off, seg = struct.unpack("<HH", raw)
        return dict(kind="far_pointer", image_target=16*seg+off, segment_value=seg,
                    offset_value=off, addend=addend,
                    segment_relocation=origin+p+2, raw_hex=raw.hex())
    if f["location_type"] in (1, 5) and f["mode"] == "self_relative":
        displacement = int.from_bytes(raw, "little", signed=True)
        return dict(kind="relative_offset", image_target=origin+p+width+displacement,
                    addend=addend, segment_relocation=None, raw_hex=raw.hex())
    if f["location_type"] == 2:
        return dict(kind="segment", image_target=int.from_bytes(raw, "little")*16,
                    addend=inline*16+f["displacement"], segment_relocation=origin+p,
                    raw_hex=raw.hex())
    return dict(kind="offset", offset_value=int.from_bytes(raw, "little"), addend=addend,
                segment_relocation=None, raw_hex=raw.hex())


def infer_linked_labels(records, bykey, header_size, image_size):
    """Infer additional address labels from matching OMF relocation semantics.

    These are labelled *inferred*, not independent byte-match validations. A
    direct offset with a known DGROUP frame gives an address; subtracting the
    object's inline addend identifies the segment contribution or external symbol.
    A segment-only relocation is a frame, never a complete external address.
    """
    group_values, external_frames = defaultdict(set), defaultdict(set)
    values, evidence = defaultdict(set), defaultdict(list)

    def add(key, value, source):
        fresh = value not in values[key]
        values[key].add(value)
        if source not in evidence[key]:
            evidence[key].append(source)
        return fresh

    accepted = [r for r in records if r["accepted"] and r["candidates"][0]["stable_bytes"] >= 24]
    for rec in accepted:
        m, s = bykey[rec["key"]]
        origin = rec["candidates"][0]["image_offset"]
        add(("segment", rec["input"], m.file_offset, s.index), origin,
            dict(kind="CODE_stable_byte_match", module=m.name))
        for symbol in rec["symbols"]:
            add(("external", symbol["name"]), origin+symbol["offset"],
                dict(kind="PUBDEF_in_matching_CODE", module=m.name))
        for check in rec["candidates"][0]["fixup_checks"]:
            target, obs = check["target"], check["observed"]
            if obs["kind"] == "segment":
                if target["method"] == 1:
                    group_values[target["name"]].add(obs["image_target"]-obs["addend"])
                elif target["method"] == 2:
                    external_frames[target["name"]].add(obs["image_target"]-obs["addend"])
    for _ in range(8):
        changed = False
        for rec in accepted:
            m, s = bykey[rec["key"]]
            for f, check in zip(s.fixups, rec["candidates"][0]["fixup_checks"]):
                target, obs, frame = f["target"], check["observed"], f["frame"]
                address = None
                if obs["kind"] in ("far_pointer", "relaxed_near_call", "relaxed_near_jump", "relative_offset"):
                    address = obs["image_target"]-obs["addend"]
                elif obs["kind"] == "offset" and f["location_type"] in (1, 5):
                    frame_base = None
                    if frame["method"] == 1 and len(group_values[frame["name"]]) == 1:
                        frame_base = next(iter(group_values[frame["name"]]))
                    elif frame["method"] == 5 and target["method"] == 2:
                        frames = external_frames[target["name"]]
                        if len(frames) == 1:
                            frame_base = next(iter(frames))
                    if frame_base is not None:
                        # OMF 16-bit offset arithmetic wraps. Array-base-minus-one
                        # references in TZSET contain the inline addend 0xffff.
                        address = frame_base + ((obs["offset_value"]-obs["addend"]) & 0xffff)
                if address is None:
                    continue
                source = dict(kind="FIXUPP_operand_in_matching_CODE", module=m.name,
                              file_offset=check["file_offset"], location_type=f["location_type"])
                if target["method"] == 2:
                    changed |= add(("external", target["name"]), address, source)
                elif target["method"] == 0:
                    changed |= add(("segment", rec["input"], m.file_offset, target["datum"]), address, source)
            for symbol in m.publics:
                key = ("segment", rec["input"], m.file_offset, symbol["segment"])
                if symbol["segment"] and len(values[key]) == 1:
                    changed |= add(("external", symbol["name"]), next(iter(values[key]))+symbol["offset"],
                        dict(kind="PUBDEF_plus_inferred_segment_origin", module=m.name,
                             segment_index=symbol["segment"], object_offset=symbol["offset"]))
        if not changed:
            break
    labels, origins, conflicts = [], [], []
    for key in sorted(values, key=str):
        if not values[key]:
            continue
        if len(values[key]) != 1:
            conflicts.append(dict(key=list(key), candidate_image_offsets=sorted(values[key]), evidence=evidence[key]))
            continue
        value = next(iter(values[key]))
        item = dict(image_offset=value, file_offset=header_size+value if 0 <= value < image_size else None,
                    outside_file_backed_image=not (0 <= value < image_size),
                    evidence=evidence[key], status="inferred_from_OMF_link_references")
        if key[0] == "external":
            item["name"] = key[1]
            labels.append(item)
        else:
            item.update(input=key[1], module_file_offset=key[2], segment_index=key[3])
            origins.append(item)
    return dict(group_frames={k: sorted(v) for k, v in group_values.items()},
                external_segment_frames={k: sorted(v) for k, v in external_frames.items()},
                labels=sorted(labels, key=lambda x:(x["image_offset"], x["name"])),
                segment_origins=origins, conflicts=conflicts)


def compare(label, paths, image, header_size, relocations):
    records, bykey = [], {}
    inputs = []
    for path in paths:
        modules = omf.parse_omf(path)
        inputs.append(dict(path=str(path), sha256=digest(path), module_count=len(modules)))
        for entry in omf.match_modules(modules, image, header_size):
            m = next(m for m in modules if m.file_offset == entry["module_file_offset"])
            s = m.segments[entry["segment_index"]-1]
            key = str(path) + ":" + str(m.file_offset) + ":" + str(s.index)
            entry.update(input=str(path), key=key)
            bykey[key] = (m, s)
            records.append(entry)
    # Symbols whose stable-byte match is unique provide independent addresses for
    # far-pointer checks. Aliases sharing an address remain explicitly recorded.
    symbol_candidates = defaultdict(set)
    segment_origins = {}
    for rec in records:
        if rec["candidate_count"] != 1:
            continue
        origin = rec["candidates"][0]["image_offset"]
        m, s = bykey[rec["key"]]
        segment_origins[(rec["input"], m.file_offset, s.index)] = origin
        for symbol in rec["symbols"]:
            symbol_candidates[symbol["name"]].add(origin+symbol["offset"])
    symbols = {name: next(iter(values)) for name, values in symbol_candidates.items() if len(values) == 1}
    reloc_set = set(relocations)
    for rec in records:
        m, s = bykey[rec["key"]]
        for candidate in rec["candidates"]:
            origin = candidate["image_offset"]
            checks = []
            for f in s.fixups:
                observed = actual_reference(image, origin, s, f)
                target = f["target"]
                expected = None
                if target["method"] == 2:
                    expected = symbols.get(target.get("name"))
                elif target["method"] == 0:
                    expected = segment_origins.get((rec["input"], m.file_offset, target["datum"]))
                if expected is not None:
                    expected += observed["addend"]
                check = dict(fixup_offset=f["offset"], file_offset=header_size+origin+f["offset"],
                             location_type=f["location_type"], target=target, observed=observed,
                             expected_image_target=expected)
                if observed["kind"] in ("far_pointer", "relaxed_near_call", "relaxed_near_jump", "relative_offset") and expected is not None:
                    check["target_status"] = "match" if observed["image_target"] == expected else "mismatch"
                else:
                    check["target_status"] = "not_independently_resolved"
                relocation = observed["segment_relocation"]
                if relocation is not None:
                    check["mz_relocation_status"] = "present" if relocation in reloc_set else "missing"
                else:
                    check["mz_relocation_status"] = "not_required"
                checks.append(check)
            candidate["fixup_checks"] = checks
            candidate["independent_target_matches"] = sum(c["target_status"] == "match" for c in checks)
            candidate["target_mismatches"] = sum(c["target_status"] == "mismatch" for c in checks)
            candidate["missing_mz_relocations"] = sum(c["mz_relocation_status"] == "missing" for c in checks)
            candidate["accepted"] = not candidate["target_mismatches"] and not candidate["missing_mz_relocations"]
        rec["accepted"] = rec["candidate_count"] == 1 and rec["candidates"][0]["accepted"]
    groups = defaultdict(list)
    for rec in records:
        if rec["accepted"]:
            c = rec["candidates"][0]
            groups[(c["image_offset"], c["size"])].append(rec)
    mapped_symbols = []
    matched_ranges = bytearray(len(image))
    stable_bytes = bytearray(len(image))
    for (origin, size), group in sorted(groups.items()):
        matched_ranges[origin:origin+size] = b"\1" * size
        for rec in group:
            for start, end in rec["stable_ranges"]:
                stable_bytes[origin+start:origin+end] = b"\1" * (end-start)
        alternatives = [dict(input=r["input"], module=r["module"], module_file_offset=r["module_file_offset"])
                        for r in group]
        for rec in group:
            candidate = rec["candidates"][0]
            status = "long_unique_code_match" if candidate["stable_bytes"] >= 24 else "short_code_match"
            if len(group) > 1:
                status += "; module_aliases_not_distinguished"
            if size <= 24 and len(group) > 1:
                status = "generic_wrapper; identity_unproven"
            for symbol in rec["symbols"]:
                mapped_symbols.append(dict(name=symbol["name"], image_offset=origin+symbol["offset"],
                    file_offset=header_size+origin+symbol["offset"], input=rec["input"],
                    module=rec["module"], segment_index=rec["segment_index"],
                    segment_origin_image=origin, object_offset=symbol["offset"],
                    stable_bytes=candidate["stable_bytes"], status=status,
                    equivalent_module_candidates=alternatives))
    inferred_labels = infer_linked_labels(records, bykey, header_size, len(image))
    return dict(label=label, inputs=inputs, stable_match_count=len(records),
                accepted_module_segment_count=sum(r["accepted"] for r in records),
                distinct_accepted_ranges=len(groups), total_covered_image_bytes=sum(matched_ranges),
                total_independently_stable_bytes=sum(stable_bytes),
                covered_image_ranges=omf.ranges(matched_ranges),
                matches=records, symbols=sorted(mapped_symbols, key=lambda x:(x["image_offset"],x["name"])),
                inferred_link_labels=inferred_labels)


def main():
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument("--exe", type=Path, required=True)
    p.add_argument("--candidate", action="append", nargs="+", metavar="LABEL_AND_OMF_PATHS", required=True)
    p.add_argument("-o", "--output", type=Path, required=True)
    args = p.parse_args()
    image, header_size, relocs = omf.read_mz(args.exe)
    comparisons = []
    for candidate in args.candidate:
        comparisons.append(compare(candidate[0], [Path(p) for p in candidate[1:]], image, header_size, relocs))
    output = dict(exe=str(args.exe), exe_sha256=digest(args.exe), mz_header_size=header_size,
                  mz_relocations=relocs, notes=[
        "File offsets include the MZ header; image offsets exclude it.",
        "OMF FIXUPP operand bytes are masked. Far CALL/JMP opcodes are masked only with a type-3 fixup and accepted TLINK replacement.",
        "Accepted matches additionally require known call targets to agree and far segment operands to appear in the MZ relocation table.",
        "Aliased functions and generic wrappers do not prove which module was actually linked.",
        "A matching runtime library establishes compatibility; it does not identify one exclusive compiler frontend/version."],
                  candidates=comparisons)
    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(json.dumps(output, ensure_ascii=False, indent=2)+"\n", encoding="utf-8")
    for c in comparisons:
        print(c["label"], "stable matches", c["stable_match_count"], "accepted", c["accepted_module_segment_count"],
              "distinct ranges", c["distinct_accepted_ranges"], "covered bytes", c["total_covered_image_bytes"])


if __name__ == "__main__":
    main()
