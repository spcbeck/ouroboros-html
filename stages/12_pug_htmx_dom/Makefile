.PHONY: all clean

all: resolved_dom.html
	mkdir -p ../13_dom_xhtml
	cp resolved_dom.html ../13_dom_xhtml/resolved_dom.html

output.pug: ../11_xslt_pug/output.pug
	cp ../11_xslt_pug/output.pug output.pug

resolved_dom.html: output.pug harness.js
	node harness.js output.pug resolved_dom.html

clean:
	rm -f resolved_dom.html output.pug
