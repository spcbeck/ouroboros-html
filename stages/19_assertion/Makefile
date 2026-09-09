.PHONY: all clean verify

all: verify

output.html: ../18_posthtml_minify/output.html
	cp ../18_posthtml_minify/output.html output.html

verify: output.html
	node ../../scripts/verify_dom.js ../00_input/input.html output.html

clean:
	rm -f output.html
