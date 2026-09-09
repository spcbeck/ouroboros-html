.PHONY: all clean

all: output.jsx
	mkdir -p ../10_svelte_ast
	cp output.jsx ../10_svelte_ast/output.jsx

output.js: ../08_brainfuck_runtime/output.js
	cp ../08_brainfuck_runtime/output.js output.js

output.jsx: output.js transform.js
	node transform.js output.js output.jsx

clean:
	rm -f output.jsx output.js
