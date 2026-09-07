.PHONY: all clean

EMCC ?= emcc

all: stage3.wasm
	mkdir -p ../04_rust_wasmtime
	cp stage3.wasm ../04_rust_wasmtime/stage3.wasm
	@echo "[Stage 3] Successfully compiled C wrapper -> WebAssembly bytecode (stage3.wasm)"

stage3.wasm: wrapper.c
	$(EMCC) wrapper.c -O2 -s STANDALONE_WASM=1 -s EXPORTED_FUNCTIONS="['_get_payload', '_main']" -o stage3.wasm

clean:
	rm -f stage3.wasm wrapper.c
