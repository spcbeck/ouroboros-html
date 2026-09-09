.PHONY: all clean

all: output.pug
	mkdir -p ../15_handlebars
	cp output.pug ../15_handlebars/output.pug
	@echo "[Stage 14] XSLT transformed DocBook XML -> Pug template (output.pug)"

output.xml: ../13_pandoc_docbook/output.xml
	cp ../13_pandoc_docbook/output.xml output.xml

output.pug: output.xml docbook_to_pug.xslt
	xsltproc docbook_to_pug.xslt output.xml > output.pug

clean:
	rm -f output.pug output.xml
