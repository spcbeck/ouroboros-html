.PHONY: all clean

CC ?= gcc

# Use beef if installed in PATH, otherwise compile and run local fallback interpreter
BEEF_BIN ?= $(shell command -v beef 2>/dev/null || echo "./bf")

all: output.js
	mkdir -p ../09_babel_ast
	cp output.js ../09_babel_ast/output.js
	@echo "[Stage 8] Executed Brainfuck tape in beef/fallback runtime -> output.js"

bf: bf.c
	$(CC) -O3 bf.c -o bf

payload.bf: ../07_brainfuck_gen/payload.bf
	cp ../07_brainfuck_gen/payload.bf payload.bf

output.js: payload.bf $(if $(filter ./bf,$(BEEF_BIN)),bf)
	$(BEEF_BIN) payload.bf > output.js

clean:
	rm -f payload.bf output.js bf
