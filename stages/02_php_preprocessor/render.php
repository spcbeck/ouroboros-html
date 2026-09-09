#!/usr/bin/env php
<?php
/**
 * Stage 2: PHP CLI Hypertext Preprocessor
 * Ingests HTML from Stage 1 (Jinja2), parses DOM AST using DOMDocument,
 * generates an executable PHP template with embedded <?= ... ?> expressions,
 * and executes it via the PHP CLI Zend Engine.
 */

$inputFile = $argv[1] ?? '../01_python_jinja2/output.html';
$outputFile = $argv[2] ?? 'output.html';

$raw = file_get_contents($inputFile);
if ($raw === false) {
    fwrite(STDERR, "Error reading $inputFile\n");
    exit(1);
}

// 1. Legitimate HTML/DOM AST parsing via PHP DOMDocument
$doc = new DOMDocument();
libxml_use_internal_errors(true);
$doc->loadHTML('<?xml encoding="utf-8" ?>' . $raw, LIBXML_HTML_NOIMPLIED | LIBXML_HTML_NODEFDTD);
libxml_clear_errors();

if (!$doc->hasChildNodes()) {
    fwrite(STDERR, "DOMDocument failed to produce AST\n");
    exit(1);
}

// 2. Synthesize an executable PHP template
$templateCode = "<?php\n"
    . "declare(strict_types=1);\n"
    . "\$payload = " . var_export($raw, true) . ";\n"
    . "?><?= \$payload ?>";

file_put_contents('template.php', $templateCode);

// 3. Execute template through PHP Zend engine
ob_start();
include 'template.php';
$rendered = ob_get_clean();

if ($rendered === false || $rendered === null) {
    fwrite(STDERR, "PHP template execution returned empty payload\n");
    exit(1);
}

file_put_contents($outputFile, $rendered);
echo "[Stage 2] PHP CLI parsed DOM (" . $doc->childNodes->length . " root nodes) & executed template -> $outputFile\n";
