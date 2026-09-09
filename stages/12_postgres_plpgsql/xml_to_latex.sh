#!/usr/bin/env bash
set -euo pipefail

INPUT_XML="${1:-output.xml}"
OUTPUT_TEX="${2:-output.tex}"

# Execute psql using the appropriate connection method:
# 1. Direct psql connection (macOS Homebrew, local user cluster, or explicit PG* env vars)
# 2. su - postgres fallback (Debian/Ubuntu containers running as root)
# 3. Direct psql fallback (surfacing standard connection diagnostics)
execute_psql() {
    if command -v psql >/dev/null 2>&1 && psql -q -t -A -c "SELECT 1;" >/dev/null 2>&1; then
        psql -q -t -A
    elif command -v su >/dev/null 2>&1 && id -u postgres >/dev/null 2>&1; then
        if ! su - postgres -c "pg_isready" >/dev/null 2>&1; then
            if command -v service >/dev/null 2>&1; then
                service postgresql start >/dev/null 2>&1 || true
            fi
        fi
        su - postgres -c "psql -q -t -A"
    else
        psql -q -t -A
    fi
}

# Read XML content
XML_CONTENT=$(cat "${INPUT_XML}")

execute_psql << EOF > "${OUTPUT_TEX}"
CREATE TEMPORARY TABLE IF NOT EXISTS xml_store (payload xml);
DELETE FROM xml_store;
INSERT INTO xml_store (payload) VALUES ('${XML_CONTENT}'::xml);

CREATE OR REPLACE FUNCTION xml_node_to_latex(n xml) RETURNS text LANGUAGE plpgsql AS \$\$
DECLARE
    tag_name text;
    child_node xml;
    child_str text;
    inner_content text := '';
    res text := '';
BEGIN
    tag_name := (xpath('name(/*)', n))[1]::text;

    -- Collect rendered children (both element and text nodes in document order)
    FOREACH child_node IN ARRAY xpath('/*/node()', n) LOOP
        child_str := child_node::text;
        IF child_str LIKE '<%>' THEN
            inner_content := inner_content || xml_node_to_latex(child_str::xml);
        ELSE
            inner_content := inner_content || child_str;
        END IF;
    END LOOP;

    IF tag_name = 'article' THEN
        res := '\documentclass{article}' || chr(10) || '\begin{document}' || chr(10) || inner_content || '\end{document}' || chr(10);
    ELSIF tag_name = 'h1' THEN
        res := '\section{' || inner_content || '}' || chr(10) || chr(10);
    ELSIF tag_name = 'h2' THEN
        res := '\subsection{' || inner_content || '}' || chr(10) || chr(10);
    ELSIF tag_name = 'h3' THEN
        res := '\subsubsection{' || inner_content || '}' || chr(10) || chr(10);
    ELSIF tag_name = 'p' THEN
        res := inner_content || chr(10) || chr(10);
    ELSIF tag_name = 'strong' THEN
        res := '\textbf{' || inner_content || '}';
    ELSIF tag_name = 'em' THEN
        res := '\textit{' || inner_content || '}';
    ELSIF tag_name = 'code' THEN
        res := '\texttt{' || inner_content || '}';
    ELSIF tag_name = 'ul' THEN
        res := '\begin{itemize}' || chr(10) || inner_content || '\end{itemize}' || chr(10) || chr(10);
    ELSIF tag_name = 'li' THEN
        res := '\item ' || inner_content || chr(10);
    ELSIF tag_name = 'blockquote' THEN
        res := '\begin{quote}' || chr(10) || inner_content || '\end{quote}' || chr(10) || chr(10);
    ELSE
        res := inner_content;
    END IF;

    RETURN res;
END;
\$\$;

SELECT xml_node_to_latex(payload) FROM xml_store;
EOF

echo "[Stage 12] PostgreSQL PL/pgSQL recursive tree query emitted LaTeX -> ${OUTPUT_TEX}"
