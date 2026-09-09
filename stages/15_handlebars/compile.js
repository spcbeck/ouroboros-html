#!/usr/bin/env node

/**
 * Stage 15: Handlebars Template Engine
 * Compiles Pug template to HTML/Handlebars source, parses into formal Handlebars AST,
 * compiles AST to executable template, and renders payload for Stage 16 (HTMX).
 */

const fs = require('fs');
const pug = require('pug');
const Handlebars = require('handlebars');

function main() {
  const inputFile = process.argv[2] || '../14_xslt_pug/output.pug';
  const outputFile = process.argv[3] || 'output.html';

  // 1. Pug renders to markup
  const pugSource = fs.readFileSync(inputFile, 'utf8');
  const hbsSource = pug.render(pugSource);

  fs.writeFileSync('template.hbs', hbsSource, 'utf8');

  // 2. Handlebars parses into AST
  const ast = Handlebars.parse(hbsSource);
  if (!ast || !ast.body) {
    console.error('Handlebars failed to produce AST');
    process.exit(1);
  }

  // 3. Handlebars compiles AST into template function
  const template = Handlebars.compile(ast);
  const rendered = template({});

  fs.writeFileSync(outputFile, rendered + '\n', 'utf8');
  console.log(`[Stage 15] Handlebars parsed AST (${ast.body.length} statements) & rendered -> ${outputFile}`);
}

main();
