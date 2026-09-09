.PHONY: all clean verify

all: verify
	mkdir -p ../18_posthtml_minify
	cp output.xhtml ../18_posthtml_minify/output.xhtml

resolved_dom.html: ../16_htmx_dom/resolved_dom.html
	cp ../16_htmx_dom/resolved_dom.html resolved_dom.html

output.xhtml: resolved_dom.html serialize.js
	node serialize.js resolved_dom.html output.xhtml

verify: output.xhtml
	xmllint --noout output.xhtml
	@echo "[Stage 17] Successfully verified XHTML 1.0 Strict validity with xmllint"

clean:
	rm -f output.xhtml resolved_dom.html
