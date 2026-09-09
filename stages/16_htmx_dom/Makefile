.PHONY: all clean

all: resolved_dom.html
	mkdir -p ../17_dom_xhtml
	cp resolved_dom.html ../17_dom_xhtml/resolved_dom.html

output.html: ../15_handlebars/output.html
	cp ../15_handlebars/output.html output.html

resolved_dom.html: output.html harness.js
	node harness.js output.html resolved_dom.html

clean:
	rm -f resolved_dom.html output.html output.pug
