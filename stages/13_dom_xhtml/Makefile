.PHONY: all clean verify

all: verify
	mkdir -p ../14_posthtml_minify
	cp output.xhtml ../14_posthtml_minify/output.xhtml

resolved_dom.html: ../12_pug_htmx_dom/resolved_dom.html
	cp ../12_pug_htmx_dom/resolved_dom.html resolved_dom.html

output.xhtml: resolved_dom.html serialize.js
	node serialize.js resolved_dom.html output.xhtml

verify: output.xhtml
	xmllint --noout output.xhtml
	@echo "[Stage 13] Successfully verified XHTML 1.0 Strict validity with xmllint"

clean:
	rm -f output.xhtml resolved_dom.html
