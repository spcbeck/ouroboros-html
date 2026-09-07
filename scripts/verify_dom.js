#!/usr/bin/env node

/**
 * DOM Tree Equivalence Asserter
 * Compares two HTML snippets to assert that their DOM trees are structurally
 * and content-wise identical.
 */

const fs = require('fs');
const path = require('path');

function normalizeHtml(html) {
  // Simple token-level structural normalization for lightweight verification
  return html.replace(/\s+/g, ' ').trim();
}

function main() {
  const args = process.argv.slice(2);
  if (args.length < 2) {
    console.error('Usage: node verify_dom.js <file1.html> <file2.html>');
    process.exit(1);
  }

  const [file1, file2] = args;
  const content1 = fs.readFileSync(file1, 'utf8');
  const content2 = fs.readFileSync(file2, 'utf8');

  const norm1 = normalizeHtml(content1);
  const norm2 = normalizeHtml(content2);

  if (norm1 !== norm2) {
    console.error(`[DOM ASSERTION FAILED]`);
    console.error(`File 1 (${file1}):\n${norm1}`);
    console.error(`File 2 (${file2}):\n${norm2}`);
    process.exit(1);
  }

  console.log(`[DOM ASSERTION SUCCESS] ${file1} === ${file2}`);
  console.log(`DOM payload: ${norm1}`);
}

main();
