.PHONY: all clean

all: output.html
	mkdir -p ../16_htmx_dom
	cp output.html ../16_htmx_dom/output.html

output.html: ../14_xslt_pug/output.pug compile.js
	node compile.js ../14_xslt_pug/output.pug output.html

clean:
	rm -f output.html template.hbs
