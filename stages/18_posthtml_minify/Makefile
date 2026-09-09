.PHONY: all clean

all: output.html
	mkdir -p ../19_assertion
	cp output.html ../19_assertion/output.html

output.xhtml: ../17_dom_xhtml/output.xhtml
	cp ../17_dom_xhtml/output.xhtml output.xhtml

output.html: output.xhtml minify.js
	node minify.js output.xhtml output.html

clean:
	rm -f output.html output.xhtml
