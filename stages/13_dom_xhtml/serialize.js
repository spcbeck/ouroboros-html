#!/usr/bin/env node

/**
 * Stage 13: DOM serialization to XHTML 1.0 Strict
 * Wraps and serializes the resolved DOM node using XMLSerializer into
 * an authentic, schema-valid XHTML 1.0 Strict document.
 */

const fs = require('fs');
const { JSDOM } = require('jsdom');

function main() {
  const inputFile = process.argv[2] || 'resolved_dom.html';
  const outputFile = process.argv[3] || 'output.xhtml';

  const innerHtml = fs.readFileSync(inputFile, 'utf8').trim();

  // Create an authentic XHTML 1.0 Strict document DOM
  const xhtmlTemplate = `<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
  <head>
    <title>Ouroboros XHTML</title>
  </head>
  <body>
    ${innerHtml}
  </body>
</html>`;

  const dom = new JSDOM(xhtmlTemplate, {
    contentType: 'application/xhtml+xml'
  });

  const serializer = new dom.window.XMLSerializer();
  const serialized = serializer.serializeToString(dom.window.document);

  fs.writeFileSync(outputFile, serialized + '\n', 'utf8');
  console.log(`[Stage 13] DOM serialized to XHTML 1.0 Strict -> ${outputFile}`);
}

main();
