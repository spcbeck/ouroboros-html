#!/usr/bin/env node

/**
 * Stage 15: Deep DOM Tree Equivalence Asserter
 * Parses both input.html and output.html into independent JSDOM instances
 * and recursively compares node types, tag names, attribute sets, and text content.
 */

const fs = require('fs');
const { JSDOM } = require('jsdom');

function assertNodesEqual(node1, node2, path = 'root') {
  if (node1.nodeType !== node2.nodeType) {
    throw new Error(`Node type mismatch at ${path}: ${node1.nodeType} !== ${node2.nodeType}`);
  }

  // Text node comparison
  if (node1.nodeType === 3) {
    const t1 = node1.textContent.trim();
    const t2 = node2.textContent.trim();
    if (t1 !== t2) {
      throw new Error(`Text mismatch at ${path}: "${t1}" !== "${t2}"`);
    }
    return;
  }

  // Element node comparison
  if (node1.nodeType === 1) {
    if (node1.tagName.toLowerCase() !== node2.tagName.toLowerCase()) {
      throw new Error(`Tag name mismatch at ${path}: <${node1.tagName}> !== <${node2.tagName}>`);
    }

    // Compare attributes
    const attrs1 = Array.from(node1.attributes || {}).sort((a, b) => a.name.localeCompare(b.name));
    const attrs2 = Array.from(node2.attributes || {}).sort((a, b) => a.name.localeCompare(b.name));

    if (attrs1.length !== attrs2.length) {
      throw new Error(`Attribute count mismatch on <${node1.tagName}> at ${path}`);
    }

    for (let i = 0; i < attrs1.length; i++) {
      if (attrs1[i].name !== attrs2[i].name || attrs1[i].value !== attrs2[i].value) {
        throw new Error(`Attribute mismatch at ${path}: ${attrs1[i].name}="${attrs1[i].value}" !== ${attrs2[i].name}="${attrs2[i].value}"`);
      }
    }

    // Filter meaningful children (ignore whitespace text nodes between tags)
    const filterChildren = (n) => Array.from(n.childNodes).filter((c) => {
      if (c.nodeType === 3 && !c.textContent.trim()) return false;
      return true;
    });

    const children1 = filterChildren(node1);
    const children2 = filterChildren(node2);

    if (children1.length !== children2.length) {
      throw new Error(`Child count mismatch on <${node1.tagName}> at ${path}: ${children1.length} !== ${children2.length}`);
    }

    for (let i = 0; i < children1.length; i++) {
      assertNodesEqual(children1[i], children2[i], `${path} > ${node1.tagName.toLowerCase()}[${i}]`);
    }
  }
}

function main() {
  const file1 = process.argv[2] || '../00_input/input.html';
  const file2 = process.argv[3] || 'output.html';

  if (!fs.existsSync(file1)) {
    console.error(`Input file not found: ${file1}`);
    process.exit(1);
  }
  if (!fs.existsSync(file2)) {
    console.error(`Output file not found: ${file2}`);
    process.exit(1);
  }

  const content1 = fs.readFileSync(file1, 'utf8');
  const content2 = fs.readFileSync(file2, 'utf8');

  const dom1 = new JSDOM(content1);
  const dom2 = new JSDOM(content2);

  const root1 = dom1.window.document.body.firstElementChild;
  const root2 = dom2.window.document.body.firstElementChild;

  if (!root1) {
    console.error(`No root element in ${file1}`);
    process.exit(1);
  }
  if (!root2) {
    console.error(`No root element in ${file2}`);
    process.exit(1);
  }

  try {
    assertNodesEqual(root1, root2, 'article');
    console.log('\n================================================================');
    console.log(' [STAGE 19 ASSERTION PASSED] DEEP DOM EQUIVALENCE VERIFIED!');
    console.log('----------------------------------------------------------------');
    console.log(` Input DOM:  ${root1.outerHTML}`);
    console.log(` Output DOM: ${root2.outerHTML}`);
    console.log(' Structural, Tag, Attribute, and Text Content identical across 20 stages.');
    console.log('================================================================\n');
  } catch (err) {
    console.error('\n[STAGE 19 ASSERTION FAILED]', err.message);
    console.error(`Input DOM:  ${root1.outerHTML}`);
    console.error(`Output DOM: ${root2.outerHTML}`);
    process.exit(1);
  }
}

main();
