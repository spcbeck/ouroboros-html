#!/usr/bin/env node

/**
 * Stage 7: Babel AST pipeline
 * Parses ES5 JS AST, extracts HTML string, parses into JSX AST,
 * and emits a valid JSX file.
 */

const fs = require('fs');
const parser = require('@babel/parser');
const traverse = require('@babel/traverse').default;
const generator = require('@babel/generator').default;
const t = require('@babel/types');

function main() {
  const inputFile = process.argv[2] || 'output.js';
  const outputFile = process.argv[3] || 'output.jsx';

  const jsCode = fs.readFileSync(inputFile, 'utf8');
  const ast = parser.parse(jsCode);

  let transformed = false;

  traverse(ast, {
    VariableDeclarator(path) {
      if (t.isStringLiteral(path.node.init)) {
        const rawHtml = path.node.init.value;
        const jsxAst = parser.parseExpression(rawHtml, { plugins: ['jsx'] });
        path.node.init = jsxAst;
        transformed = true;
      }
    }
  });

  if (!transformed) {
    console.error('Failed to locate string literal in JS AST');
    process.exit(1);
  }

  const outputJsx = generator(ast).code;
  fs.writeFileSync(outputFile, outputJsx + '\n', 'utf8');
  console.log(`[Stage 7] Babel AST pipeline converted JS string -> JSX AST -> ${outputFile}`);
}

main();
