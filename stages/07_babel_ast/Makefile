.PHONY: all clean

all: output.jsx
	mkdir -p ../08_jsx_to_xml
	cp output.jsx ../08_jsx_to_xml/output.jsx

output.js: ../06_brainfuck_runtime/output.js
	cp ../06_brainfuck_runtime/output.js output.js

output.jsx: output.js transform.js
	node transform.js output.js output.jsx

clean:
	rm -f output.jsx output.js
