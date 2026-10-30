#!/usr/bin/env python3
"""Build and verify the recovered C89 format implementation on this host.

This is not a Borland codegen assertion. See separate Borland build evidence.
Every supplied file is parsed and serialized through snkrec.c and compared.
"""
import argparse
import hashlib
import json
import os
from pathlib import Path
import subprocess
import tempfile


def main():
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("directory", type=Path)
    ap.add_argument("--report", type=Path)
    args = ap.parse_args()
    root = Path(__file__).resolve().parent.parent
    cc = os.environ.get("CC", "cc")
    version = subprocess.check_output([cc, "--version"], text=True).splitlines()[0]
    result = {"compiler": version, "language": "C89", "files": []}
    with tempfile.TemporaryDirectory(prefix="snake-c89-") as temporary:
        temp = Path(temporary)
        executable = temp / "snkrtest"
        command = [cc, "-std=c89", "-pedantic", "-Wall", "-Wextra", "-Werror",
                   "-I", str(root/"src"), str(root/"src/snkrec.c"),
                   str(root/"tools/snkrtest.c"), "-o", str(executable)]
        subprocess.run(command, check=True, capture_output=True, text=True)
        for file in sorted(args.directory.iterdir()):
            suffix = file.suffix.upper()
            if suffix not in (".SNK", ".REC"):
                continue
            output = temp / file.name
            run = subprocess.run([str(executable), "snk" if suffix == ".SNK" else "rec",
                                  str(file), str(output)], check=True,
                                 capture_output=True, text=True)
            raw = file.read_bytes()
            rebuilt = output.read_bytes()
            if rebuilt != raw:
                raise AssertionError(file.name + ": C reconstruction differs")
            result["files"].append({"filename": file.name, "size": len(raw),
                                    "sha256": hashlib.sha256(raw).hexdigest(),
                                    "byte_exact": True, "driver": run.stdout.strip()})
    result["file_count"] = len(result["files"])
    result["all_byte_exact"] = True
    text = json.dumps(result, ensure_ascii=False, indent=2)+"\n"
    if args.report:
        args.report.write_text(text, encoding="utf-8")
    print(text)


if __name__ == "__main__":
    main()
