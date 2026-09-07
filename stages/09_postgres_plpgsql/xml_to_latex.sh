#!/usr/bin/env bash
set -euo pipefail

INPUT_XML="${1:-output.xml}"
OUTPUT_TEX="${2:-output.tex}"

# Ensure PostgreSQL service is active
if ! su - postgres -c "pg_isready" >/dev/null 2>&1; then
    service postgresql start >/dev/null 2>&1 || true
fi

# Read XML content
XML_CONTENT=$(cat "${INPUT_XML}")

su - postgres -c "psql -q -t -A" << EOF > "${OUTPUT_TEX}"
CREATE TEMPORARY TABLE IF NOT EXISTS xml_store (payload xml);
DELETE FROM xml_store;
INSERT INTO xml_store (payload) VALUES ('${XML_CONTENT}'::xml);

CREATE OR REPLACE FUNCTION xml_node_to_latex(n xml) RETURNS text LANGUAGE plpgsql AS \$\$
DECLARE
    tag_name text;
    child_node xml;
    child_text text;
    res text := '';
BEGIN
    tag_name := (xpath('name(/*)', n))[1]::text;
    IF tag_name = 'article' THEN
        res := '\documentclass{article}' || chr(10) || '\begin{document}' || chr(10);
        FOREACH child_node IN ARRAY xpath('/*/*', n) LOOP
            res := res || xml_node_to_latex(child_node);
        END LOOP;
        res := res || '\end{document}' || chr(10);
    ELSIF tag_name = 'h1' THEN
        child_text := (xpath('string(/*)', n))[1]::text;
        res := '\section{' || child_text || '}' || chr(10) || chr(10);
    ELSIF tag_name = 'p' THEN
        child_text := (xpath('string(/*)', n))[1]::text;
        res := child_text || chr(10) || chr(10);
    ELSIF tag_name = 'ul' THEN
        res := '\begin{itemize}' || chr(10);
        FOREACH child_node IN ARRAY xpath('/*/*', n) LOOP
            res := res || xml_node_to_latex(child_node);
        END LOOP;
        res := res || '\end{itemize}' || chr(10) || chr(10);
    ELSIF tag_name = 'li' THEN
        child_text := (xpath('string(/*)', n))[1]::text;
        res := '\item ' || child_text || chr(10);
    ELSIF tag_name = 'blockquote' THEN
        res := '\begin{quote}' || chr(10);
        FOREACH child_node IN ARRAY xpath('/*/*', n) LOOP
            res := res || xml_node_to_latex(child_node);
        END LOOP;
        res := res || '\end{quote}' || chr(10) || chr(10);
    ELSE
        FOREACH child_node IN ARRAY xpath('/*/*', n) LOOP
            res := res || xml_node_to_latex(child_node);
        END LOOP;
    END IF;
    RETURN res;
END;
\$\$;

SELECT xml_node_to_latex(payload) FROM xml_store;
EOF

echo "[Stage 9] PostgreSQL PL/pgSQL recursive tree query emitted LaTeX -> ${OUTPUT_TEX}"
