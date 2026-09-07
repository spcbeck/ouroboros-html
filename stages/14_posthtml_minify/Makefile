.PHONY: all clean

all: output.html
	mkdir -p ../15_assertion
	cp output.html ../15_assertion/output.html

output.xhtml: ../13_dom_xhtml/output.xhtml
	cp ../13_dom_xhtml/output.xhtml output.xhtml

output.html: output.xhtml minify.js
	node minify.js output.xhtml output.html

clean:
	rm -f output.html output.xhtml
