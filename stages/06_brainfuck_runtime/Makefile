.PHONY: all clean

CC ?= gcc

# Use beef if installed in PATH, otherwise compile and run local fallback interpreter
BEEF_BIN ?= $(shell command -v beef 2>/dev/null || echo "./bf")

all: output.js
	mkdir -p ../07_babel_ast
	cp output.js ../07_babel_ast/output.js
	@echo "[Stage 6] Executed Brainfuck tape in beef/fallback runtime -> output.js"

bf: bf.c
	$(CC) -O3 bf.c -o bf

payload.bf: ../05_brainfuck_gen/payload.bf
	cp ../05_brainfuck_gen/payload.bf payload.bf

output.js: payload.bf $(if $(filter ./bf,$(BEEF_BIN)),bf)
	$(BEEF_BIN) payload.bf > output.js

clean:
	rm -f payload.bf output.js bf
