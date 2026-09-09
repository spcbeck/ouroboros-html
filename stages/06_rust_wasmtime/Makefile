.PHONY: all clean verify

all: verify

stage3.wasm: ../05_emcc_wasm/stage3.wasm
	cp ../05_emcc_wasm/stage3.wasm stage3.wasm

output.txt: stage3.wasm src/main.rs Cargo.toml
	cargo run --release
	@echo "[Stage 6] Output written to output.txt"

verify: output.txt
	@diff -u ../00_input/input.html output.txt
	@echo "[Stage 6 Verification] SUCCESS! Payload byte-for-byte matches Stage 0 input HTML."

clean:
	rm -f output.txt stage3.wasm
