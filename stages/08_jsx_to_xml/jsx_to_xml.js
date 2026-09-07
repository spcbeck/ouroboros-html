#!/usr/bin/env node

/**
 * Stage 8: JSX to Strict XML compiler
 * Ingests JSX AST from Babel and recursively transforms it into strict XML.
 */

const fs = require('fs');
const parser = require('@babel/parser');
const traverse = require('@babel/traverse').default;
const t = require('@babel/types');

function jsxToXml(node) {
  if (t.isJSXElement(node)) {
    const tagName = node.openingElement.name.name;
    const children = node.children.map(jsxToXml).join('');
    return `<${tagName}>${children}</${tagName}>`;
  } else if (t.isJSXText(node)) {
    return node.value;
  }
  return '';
}

function main() {
  const inputFile = process.argv[2] || 'output.jsx';
  const outputFile = process.argv[3] || 'output.xml';

  const jsxCode = fs.readFileSync(inputFile, 'utf8');
  const ast = parser.parse(jsxCode, { plugins: ['jsx'] });

  let xmlBody = '';
  traverse(ast, {
    JSXElement(path) {
      if (!xmlBody) {
        xmlBody = jsxToXml(path.node);
      }
    }
  });

  if (!xmlBody) {
    console.error('No JSXElement found in AST');
    process.exit(1);
  }

  const strictXml = `<?xml version="1.0" encoding="UTF-8"?>\n${xmlBody}\n`;
  fs.writeFileSync(outputFile, strictXml, 'utf8');
  console.log(`[Stage 8] JSX compiled to strict XML -> ${outputFile}`);
}

main();
