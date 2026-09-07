# Example App

A zero-config, dependency-free example application compiled via the **ouroboros-html** 16-stage pipeline.

---

## Architectural Principles

* **Radical Utility:** No runtime dependencies, no `node_modules`, and no `package.json` required.
* **Pure HTML5:** Semantic `<article>` structure compiled losslessly through Go `templ`, WebAssembly, Rust, Brainfuck, PostgreSQL, Pandoc, Pug, and headless DOM runtimes.
* **Deterministic Build:** The compiled artifact in `dist/index.html` matches the source DOM tree exactly.

---

## Structure

```
example/
├── index.html        # Source HTML5 template payload
├── dist/             # Compiled HTML5 artifact (output of Stage 15)
│   └── index.html
└── README.md         # Documentation
```

---

## Compilation

### Local Toolchain
```bash
make example
```

### Docker
```bash
make docker-example
```

The compiled output will be placed in `example/dist/index.html` and can be opened directly in any modern browser.
