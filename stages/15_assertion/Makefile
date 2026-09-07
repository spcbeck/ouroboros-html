.PHONY: all clean verify

all: verify

output.html: ../14_posthtml_minify/output.html
	cp ../14_posthtml_minify/output.html output.html

verify: output.html
	node ../../scripts/verify_dom.js ../00_input/input.html output.html

clean:
	rm -f output.html
