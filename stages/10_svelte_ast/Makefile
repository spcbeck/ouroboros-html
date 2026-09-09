.PHONY: all clean

all: output.jsx
	mkdir -p ../11_jsx_to_xml
	cp output.jsx ../11_jsx_to_xml/output.jsx

output.jsx: ../09_babel_ast/output.jsx compile.mjs
	node compile.mjs ../09_babel_ast/output.jsx output.jsx

clean:
	rm -f output.jsx Component.svelte Component.mjs
