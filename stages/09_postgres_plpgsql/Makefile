.PHONY: all clean

all: output.tex
	mkdir -p ../10_pandoc_docbook
	cp output.tex ../10_pandoc_docbook/output.tex

output.xml: ../08_jsx_to_xml/output.xml
	cp ../08_jsx_to_xml/output.xml output.xml

output.tex: output.xml xml_to_latex.sh
	./xml_to_latex.sh output.xml output.tex

clean:
	rm -f output.tex output.xml
