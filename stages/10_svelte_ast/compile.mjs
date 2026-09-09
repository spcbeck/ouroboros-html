#!/usr/bin/env node

/**
 * Stage 10: Svelte Component AST Compiler
 * Ingests JSX AST payload from Babel, wraps into a Svelte component AST,
 * compiles via svelte/compiler in SSR mode, executes Component.render(),
 * and outputs validated JSX/HTML for Stage 11.
 */

import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';
import * as parser from '@babel/parser';
import babelTraverse from '@babel/traverse';
import babelGenerator from '@babel/generator';
import * as svelte from 'svelte/compiler';

const traverse = babelTraverse.default || babelTraverse;
const generator = babelGenerator.default || babelGenerator;

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

async function main() {
  const inputFile = process.argv[2] || '../09_babel_ast/output.jsx';
  const outputFile = process.argv[3] || 'output.jsx';

  const jsxCode = fs.readFileSync(inputFile, 'utf8');
  const ast = parser.parse(jsxCode, { plugins: ['jsx'] });

  let jsxRaw = '';
  traverse(ast, {
    JSXElement(p) {
      if (!jsxRaw) {
        jsxRaw = generator(p.node).code;
      }
    }
  });

  if (!jsxRaw) {
    console.error('No JSXElement found in Babel AST');
    process.exit(1);
  }

  // 1. Synthesize Svelte single-file component
  const svelteSource = jsxRaw;
  fs.writeFileSync(path.join(__dirname, 'Component.svelte'), svelteSource, 'utf8');

  // 2. Parse & Compile Svelte AST in SSR mode
  const svelteResult = svelte.compile(svelteSource, {
    generate: 'ssr'
  });

  if (!svelteResult.ast || !svelteResult.ast.html) {
    console.error('Svelte compiler failed to produce HTML AST');
    process.exit(1);
  }

  // 3. Write compiled SSR module
  const svelteJsPath = path.join(__dirname, 'Component.mjs');
  fs.writeFileSync(svelteJsPath, svelteResult.js.code, 'utf8');

  // 4. Dynamically import & execute SSR render
  const Component = (await import(svelteJsPath)).default;
  const { html: renderedHtml } = Component.render();

  // 5. Wrap rendered output back into JSX declaration for Stage 11
  const outputJsx = `var html = ${renderedHtml};\n`;
  fs.writeFileSync(outputFile, outputJsx, 'utf8');

  const astChildren = svelteResult.ast.html.children ? svelteResult.ast.html.children.length : 0;
  console.log(`[Stage 10] Svelte AST parsed & SSR compiled (${astChildren} AST nodes) -> ${outputFile}`);
}

main().catch(err => {
  console.error('[Stage 10 Error]:', err);
  process.exit(1);
});
