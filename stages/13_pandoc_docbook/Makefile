.PHONY: all clean

all: output.xml
	mkdir -p ../14_xslt_pug
	cp output.xml ../14_xslt_pug/output.xml
	@echo "[Stage 13] Pandoc converted LaTeX -> Org-mode -> DocBook XML (output.xml)"

output.tex: ../12_postgres_plpgsql/output.tex
	cp ../12_postgres_plpgsql/output.tex output.tex

output.org: output.tex
	pandoc -f latex -t org --wrap=none -s output.tex -o output.org

output.xml: output.org
	pandoc -f org -t docbook --wrap=none -s output.org -o output.xml

clean:
	rm -f output.xml output.org output.tex
