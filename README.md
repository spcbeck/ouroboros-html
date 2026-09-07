# ouroboros-html

An intentionally absurd, Rube Goldberg compiler pipeline where input HTML5 is transpiled, compiled, decompiled, and transformed through incompatible programming languages and historical runtime environments, terminating in functionally identical HTML5 output.

---

## Inviolable Rules

1. **Zero Cheating / String Hacking**: Every transformation must use an actual, legitimate parser, AST converter, compiler, or runtime (e.g., Go `templ`, Emscripten, Wasmtime in Rust, Postgres stored procedures, Pandoc, Babel, Brainfuck interpreters, etc.). No bash regex (`sed`/`awk`) to fake output.
2. **Lossless Determinism**: The payload (`<article><h1>Hello World</h1><p>Test</p></article>`) must survive the complete pipeline and match the input DOM tree on output.
3. **Reproducibility**: Everything executes via a top-level `Makefile` inside a reproducible `Dockerfile`.

---

## Pipeline Architecture

```
[Stage 0]  HTML5 (input.html)
   │
   ▼
[Stage 1]  Go (templ) component AST generation & compilation
   │
   ▼
[Stage 2]  Go c-archive exported C headers & native C bridge execution
   │
   ▼
[Stage 3]  C wrapper compiled to WebAssembly via Emscripten (emcc)
   │
   ▼
[Stage 4]  Rust binary ingesting Wasm bytecode via wasmtime & memory extraction
   │
   ▼
[Stage 5]  Brainfuck generator encoding the stream onto a memory tape
   │
   ▼
[Stage 6]  Brainfuck runtime (beef/interpreter) executing tape to ES5 JavaScript
   │
   ▼
[Stage 7]  Babel AST pipeline converting JS string to JSX/TSX
   │
   ▼
[Stage 8]  JSX compiled down to strict XML
   │
   ▼
[Stage 9]  PostgreSQL stored procedure (PL/pgSQL) XML recursive query emitting LaTeX
   │
   ▼
[Stage 10] Pandoc converting LaTeX to DocBook XML
   │
   ▼
[Stage 11] XSLT transforming DocBook to Pug (Jade)
   │
   ▼
[Stage 12] Pug rendering to HTMX fragment executed in ephemeral headless DOM harness
   │
   ▼
[Stage 13] DOM serialization to XHTML 1.0 Strict
   │
   ▼
[Stage 14] PostHTML / HTML minifier outputting output.html (HTML5)
   │
   ▼
[Stage 15] Automated assertion step verifying input.html DOM === output.html DOM
```

---

## Current Status

- **Stages 0–15**: Fully implemented, connected, and verified end-to-end with deep DOM assertion.

---

## Quickstart

### Prerequisites
- Docker (recommended for reproducible multi-runtime toolchains: Go, Rust, Emscripten, Node, Postgres, Pandoc, beef)

### Run via Docker
```bash
./docker/run.sh
```

Or manually:
```bash
make docker-build
make docker-run
```

### Run Locally (if toolchains installed)
```bash
make stages-0-4
```

---

## License

[MIT](LICENSE) © 2026 Sean Beck
