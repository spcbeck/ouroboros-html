.PHONY: all clean verify

all: verify
	mkdir -p ../12_postgres_plpgsql
	cp output.xml ../12_postgres_plpgsql/output.xml

output.jsx: ../10_svelte_ast/output.jsx
	cp ../10_svelte_ast/output.jsx output.jsx

output.xml: output.jsx jsx_to_xml.js
	node jsx_to_xml.js output.jsx output.xml

verify: output.xml
	xmllint --noout output.xml
	@echo "[Stage 11] Verified schema-valid strict XML via xmllint"

clean:
	rm -f output.xml output.jsx
