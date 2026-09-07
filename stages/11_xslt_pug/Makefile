.PHONY: all clean

all: output.pug
	mkdir -p ../12_pug_htmx_dom
	cp output.pug ../12_pug_htmx_dom/output.pug
	@echo "[Stage 11] XSLT transformed DocBook XML -> Pug template (output.pug)"

output.xml: ../10_pandoc_docbook/output.xml
	cp ../10_pandoc_docbook/output.xml output.xml

output.pug: output.xml docbook_to_pug.xslt
	xsltproc docbook_to_pug.xslt output.xml > output.pug

clean:
	rm -f output.pug output.xml
