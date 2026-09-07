# ouroboros-html

[![CI & Container Publish](https://github.com/spcbeck/ouroboros-html/actions/workflows/ci.yml/badge.svg)](https://github.com/spcbeck/ouroboros-html/actions/workflows/ci.yml)
[![GHCR Image](https://img.shields.io/badge/GHCR-ouroboros--html-blue?logo=docker)](https://github.com/spcbeck/ouroboros-html/pkgs/container/ouroboros-html)
[![License: MIT](https://img.shields.io/badge/License-MIT-black.svg)](LICENSE)

An intentionally absurd, Rube Goldberg compiler pipeline where input HTML5 is transpiled, compiled, decompiled, and transformed through 16 incompatible programming languages and historical runtime environments, terminating in functionally identical HTML5 output.

---

## Inviolable Rules

1. **Zero Cheating / String Hacking**: Every transformation must use an actual, legitimate parser, AST converter, compiler, or runtime (e.g., Go `templ`, Emscripten, Wasmtime in Rust, Postgres stored procedures, Pandoc, Babel, Brainfuck interpreters, etc.). No bash regex (`sed`/`awk`) to fake output.
2. **Lossless Determinism**: The payload must survive the complete pipeline and match the input DOM tree on output.
3. **Reproducibility**: Everything executes via a top-level `Makefile` inside a reproducible, self-contained `Dockerfile`.

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
[Stage 7]  Babel AST pipeline converting JS string to JSX AST
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

## Run Instantly with Docker / GHCR

Pre-built multi-runtime container images are automatically published to the GitHub Container Registry. No local toolchain installation required.

### 1. Run All 16 Compiler Stages
```bash
docker run --rm ghcr.io/spcbeck/ouroboros-html:latest
```

### 2. Run Comprehensive HTML5 Fixture Suite
Empirically verifies that the pipeline compiles diverse HTML structures (nested lists, multi-paragraphs, blockquotes):
```bash
docker run --rm ghcr.io/spcbeck/ouroboros-html:latest make test-suite
```

### 3. Run Recursive Ouroboros Idempotency Loop
Demonstrates mathematical idempotency ($\forall k \in [1..N], \text{DOM}(\text{Pipeline}^k(S_0)) \equiv \text{DOM}(S_0)$) by feeding the output of Stage 14 back into Stage 0 for $N$ generations:
```bash
docker run --rm ghcr.io/spcbeck/ouroboros-html:latest make ouroboros CYCLES=3
```

---

## Local Development

If you prefer building or mounting your local workspace:

```bash
# Build local Docker image
make docker-build

# Run all 16 stages mounted locally
make docker-run

# Run fixture test suite
make docker-test-suite

# Run 3-cycle Ouroboros loop
make docker-ouroboros CYCLES=3
```

---

## Fixture Suite & AST Generalization

The test harness in `scripts/test_suite.py` exercises multiple distinct HTML5 payloads:

| Fixture | Structure Tested | Runtimes Exercised |
| :--- | :--- | :--- |
| `01_canonical.html` | Base `<article><h1>...</h1><p>...</p></article>` | All 16 runtimes |
| `02_multi_paragraph.html` | Sibling `<p>` paragraph nodes | PL/pgSQL recursive, Pandoc, DocBook XSLT |
| `03_unordered_list.html` | Nested `<ul><li>...</li></ul>` structures | LaTeX `itemize` $\to$ DocBook `itemizedlist` $\to$ Pug |
| `04_blockquote.html` | Semantic `<blockquote><p>...</p></blockquote>` | LaTeX `quote` $\to$ DocBook `blockquote` $\to$ Pug |

---

## Mathematical Idempotency Guarantee

$$\forall k \ge 1, \quad \operatorname{DOM}\left(\mathcal{P}^k\left(S_0\right)\right) \equiv \operatorname{DOM}\left(S_0\right)$$

Where $\mathcal{P}$ represents the composition of all 16 stages:
$$\mathcal{P} = \mathcal{S}_{15} \circ \mathcal{S}_{14} \circ \dots \circ \mathcal{S}_1 \circ \mathcal{S}_0$$

Every generation is stored as an immutable snapshot in `artifacts/gen_NN_output.html` and verified via recursive JSDOM tree assertions.

---

## License

[MIT](LICENSE) © 2026 Sean Beck
