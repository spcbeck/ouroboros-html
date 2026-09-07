#!/usr/bin/env node

/**
 * Stage 12: Pug rendering to an HTMX fragment (hx-get) executed
 * in an ephemeral headless Node DOM harness.
 */

const fs = require('fs');
const pug = require('pug');
const { JSDOM } = require('jsdom');

function main() {
  const inputPugFile = process.argv[2] || 'output.pug';
  const outputFile = process.argv[3] || 'resolved_dom.html';

  // 1. Pug compiles the template into HTML markup
  const pugSource = fs.readFileSync(inputPugFile, 'utf8');
  const renderedPayload = pug.render(pugSource);

  // 2. Headless DOM host document defining the HTMX dynamic fragment
  const hostHtml = `<!DOCTYPE html>
<html>
<body>
  <main id="app">
    <div id="target" hx-get="/article" hx-trigger="load" hx-swap="outerHTML">
      <!-- Ephemeral HTMX placeholder -->
    </div>
  </main>
</body>
</html>`;

  const dom = new JSDOM(hostHtml);
  const doc = dom.window.document;

  // 3. Ephemeral headless HTMX runner lifecycle
  const htmxElement = doc.querySelector('[hx-get]');
  if (!htmxElement) {
    console.error('Missing HTMX fragment element');
    process.exit(1);
  }

  const endpoint = htmxElement.getAttribute('hx-get');
  const swap = htmxElement.getAttribute('hx-swap') || 'innerHTML';

  // Resolve HTMX endpoint and perform DOM swap
  if (endpoint === '/article') {
    if (swap === 'outerHTML') {
      htmxElement.outerHTML = renderedPayload;
    } else {
      htmxElement.innerHTML = renderedPayload;
    }
  }

  // 4. Extract resolved DOM element
  const resolvedArticle = doc.querySelector('article');
  if (!resolvedArticle) {
    console.error('Failed to resolve article element in DOM after HTMX swap');
    process.exit(1);
  }

  fs.writeFileSync(outputFile, resolvedArticle.outerHTML + '\n', 'utf8');
  console.log(`[Stage 12] Pug compiled & HTMX fragment swapped in headless DOM -> ${outputFile}`);
}

main();
