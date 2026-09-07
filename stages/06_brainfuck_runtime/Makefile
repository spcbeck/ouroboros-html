.PHONY: all clean

all: output.js
	mkdir -p ../07_babel_ast
	cp output.js ../07_babel_ast/output.js
	@echo "[Stage 6] Executed Brainfuck tape in beef runtime -> output.js"

payload.bf: ../05_brainfuck_gen/payload.bf
	cp ../05_brainfuck_gen/payload.bf payload.bf

output.js: payload.bf
	beef payload.bf > output.js

clean:
	rm -f payload.bf output.js
