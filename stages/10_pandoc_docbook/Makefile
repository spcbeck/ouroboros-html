.PHONY: all clean

all: output.xml
	mkdir -p ../11_xslt_pug
	cp output.xml ../11_xslt_pug/output.xml
	@echo "[Stage 10] Pandoc converted LaTeX -> DocBook XML (output.xml)"

output.tex: ../09_postgres_plpgsql/output.tex
	cp ../09_postgres_plpgsql/output.tex output.tex

output.xml: output.tex
	pandoc -f latex -t docbook --wrap=none -s output.tex -o output.xml

clean:
	rm -f output.xml output.tex
