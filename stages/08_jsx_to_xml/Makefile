.PHONY: all clean verify

all: verify
	mkdir -p ../09_postgres_plpgsql
	cp output.xml ../09_postgres_plpgsql/output.xml

output.jsx: ../07_babel_ast/output.jsx
	cp ../07_babel_ast/output.jsx output.jsx

output.xml: output.jsx jsx_to_xml.js
	node jsx_to_xml.js output.jsx output.xml

verify: output.xml
	xmllint --noout output.xml
	@echo "[Stage 8] Verified schema-valid strict XML via xmllint"

clean:
	rm -f output.xml output.jsx
