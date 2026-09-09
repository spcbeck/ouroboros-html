#!/usr/bin/env python3
"""
Stage 1: Python Jinja2 Template Engine
Parses input HTML into formal Jinja2 AST, verifies template tree,
and renders output via Jinja2 template engine.
"""

import sys
import jinja2

def main():
    input_file = sys.argv[1] if len(sys.argv) > 1 else "../00_input/input.html"
    output_file = sys.argv[2] if len(sys.argv) > 2 else "output.html"

    with open(input_file, "r", encoding="utf-8") as f:
        content = f.read()

    env = jinja2.Environment(autoescape=False)

    # 1. Parse into formal Jinja2 AST
    ast = env.parse(content)
    if not ast or not ast.body:
        print("Warning: Empty Jinja AST generated", file=sys.stderr)

    # 2. Compile and render template
    template = env.from_string(content)
    rendered = template.render()

    with open(output_file, "w", encoding="utf-8") as f:
        f.write(rendered)

    print(f"[Stage 1] Jinja2 parsed AST ({len(ast.body)} nodes) & rendered -> {output_file}")

if __name__ == "__main__":
    main()
