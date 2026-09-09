#!/usr/bin/env python3
"""
Brainfuck Stream Generator (text2bf)
Encodes an input stream into standard Brainfuck tape instructions (+ - < > [ ] . ,).
"""

import sys

def encode_stream_to_bf(text: str) -> str:
    bf_ops = []
    cur_cell_val = 0

    for char in text:
        target_val = ord(char)
        diff = target_val - cur_cell_val

        if diff > 0:
            bf_ops.append("+" * diff)
        elif diff < 0:
            bf_ops.append("-" * (-diff))

        bf_ops.append(".")
        cur_cell_val = target_val

    return "".join(bf_ops) + "\n"

def main():
    input_path = sys.argv[1] if len(sys.argv) > 1 else "../06_rust_wasmtime/output.txt"
    output_path = sys.argv[2] if len(sys.argv) > 2 else "payload.bf"

    with open(input_path, "r", encoding="utf-8") as f:
        content = f.read().strip()

    # Wrap payload in ES5 JavaScript declaration for Stage 8 / Stage 9
    # Note: escape double quotes in content if any
    escaped_content = content.replace('"', '\\"')
    es5_js = f'var html = "{escaped_content}";\n'

    bf_code = encode_stream_to_bf(es5_js)

    with open(output_path, "w", encoding="utf-8") as f:
        f.write(bf_code)

    print(f"[Stage 7] Successfully encoded stream into Brainfuck memory tape ({len(bf_code)} instructions) -> {output_path}")

if __name__ == "__main__":
    main()
