"""Recover and re-encode the resident encrypted sprite-driver region.

Derived directly from SNAKE.EXE file 0x12D87..0x12DA0; this does not patch the
original executable or remove a gate. The distribution's wrapper decrypts this
same region on normal initialization. Refer to docs/ARCHITECTURE.md.
"""
from pathlib import Path
import argparse

START = 0xFE16
END = 0x12D36


def decode(cipher: bytes) -> bytes:
    result = bytearray()
    state = 0
    for value in cipher:
        state = ((state << 1) | (state >> 7)) & 255
        plain = value ^ state
        result.append(plain)
        state = (state + plain) & 255
    return bytes(result)


def encode(plain: bytes) -> bytes:
    result = bytearray()
    state = 0
    for value in plain:
        state = ((state << 1) | (state >> 7)) & 255
        result.append(value ^ state)
        state = (state + value) & 255
    return bytes(result)


def main():
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument("exe", type=Path)
    p.add_argument("output", type=Path)
    a = p.parse_args()
    exe = a.exe.read_bytes()
    if exe[0xFD66:0xFD6D] != bytes.fromhex("e8cd2f3412b000"):
        raise ValueError("Unsupported executable: expected driver header absent")
    decoded = decode(exe[START:END])
    assert encode(decoded) == exe[START:END]
    a.output.write_bytes(decoded)
    print(f"Decoded {len(decoded)} bytes; encode(decode(cipher)) is byte-exact.")


if __name__ == "__main__":
    main()
