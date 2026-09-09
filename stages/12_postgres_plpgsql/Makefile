.PHONY: all clean

all: output.tex
	mkdir -p ../13_pandoc_docbook
	cp output.tex ../13_pandoc_docbook/output.tex

output.xml: ../11_jsx_to_xml/output.xml
	cp ../11_jsx_to_xml/output.xml output.xml

output.tex: output.xml xml_to_latex.sh
	./xml_to_latex.sh output.xml output.tex

clean:
	rm -f output.tex output.xml
