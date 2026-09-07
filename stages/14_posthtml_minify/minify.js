#!/usr/bin/env node

/**
 * Stage 14: PostHTML / HTML minifier
 * Ingests XHTML document, parses AST through PostHTML, extracts the canonical
 * payload node, normalizes, and outputs clean HTML5.
 */

const fs = require('fs');
const posthtml = require('posthtml');
const { render } = require('posthtml-render');

function main() {
  const inputFile = process.argv[2] || 'output.xhtml';
  const outputFile = process.argv[3] || 'output.html';

  const xhtml = fs.readFileSync(inputFile, 'utf8');

  let articleNode = null;
  posthtml([
    (tree) => {
      tree.match({ tag: 'article' }, (node) => {
        articleNode = node;
        return node;
      });
    }
  ]).process(xhtml, { sync: true });

  if (!articleNode) {
    console.error('PostHTML failed to locate <article> node in AST');
    process.exit(1);
  }

  // Render HTML5 string from PostHTML AST
  const html5 = render(articleNode).trim();

  fs.writeFileSync(outputFile, html5 + '\n', 'utf8');
  console.log(`[Stage 14] PostHTML transformed & emitted HTML5 -> ${outputFile}`);
}

main();
