.PHONY: all stages-0-4 stage0 stage1 stage2 stage3 stage4 stage5 stage6 stage7 stage8 stage9 stage10 stage11 stage12 stage13 stage14 stage15 clean docker-build docker-run

IMAGE_NAME ?= ouroboros-html:latest

all: stage0 stage1 stage2 stage3 stage4 stage5 stage6 stage7 stage8 stage9 stage10 stage11 stage12 stage13 stage14 stage15
	@echo "=========================================================="
	@echo " ALL STAGES (0-15) EXECUTED"
	@echo "=========================================================="

stages-0-4: stage0 stage1 stage2 stage3 stage4
	@echo ""
	@echo "=========================================================="
	@echo " [OUROBOROS-HTML] STAGES 0-4 PIPELINE VERIFIED!"
	@echo " Input:  $$(cat stages/00_input/input.html)"
	@echo " Output: $$(cat stages/04_rust_wasmtime/output.txt)"
	@echo "=========================================================="

stage0:
	@echo "\n===> [Stage 0] Input HTML5"
	$(MAKE) -C stages/00_input

stage1: stage0
	@echo "\n===> [Stage 1] Go (templ) component generation"
	$(MAKE) -C stages/01_go_templ

stage2: stage1
	@echo "\n===> [Stage 2] Go c-archive exported C headers & bridge"
	$(MAKE) -C stages/02_go_carchive

stage3: stage2
	@echo "\n===> [Stage 3] C wrapper compiled to WebAssembly via Emscripten (emcc)"
	$(MAKE) -C stages/03_emcc_wasm

stage4: stage3
	@echo "\n===> [Stage 4] Rust binary ingesting Wasm bytecode via wasmtime"
	$(MAKE) -C stages/04_rust_wasmtime

stage5: stage4
	@echo "\n===> [Stage 5] Brainfuck generator"
	$(MAKE) -C stages/05_brainfuck_gen

stage6: stage5
	@echo "\n===> [Stage 6] Brainfuck runtime"
	$(MAKE) -C stages/06_brainfuck_runtime

stage7: stage6
	@echo "\n===> [Stage 7] Babel AST pipeline"
	$(MAKE) -C stages/07_babel_ast

stage8: stage7
	@echo "\n===> [Stage 8] JSX to XML compiler"
	$(MAKE) -C stages/08_jsx_to_xml

stage9: stage8
	@echo "\n===> [Stage 9] PostgreSQL PL/pgSQL XML recursive query"
	$(MAKE) -C stages/09_postgres_plpgsql

stage10: stage9
	@echo "\n===> [Stage 10] Pandoc LaTeX to DocBook XML"
	$(MAKE) -C stages/10_pandoc_docbook

stage11: stage10
	@echo "\n===> [Stage 11] XSLT DocBook to Pug (Jade)"
	$(MAKE) -C stages/11_xslt_pug

stage12: stage11
	@echo "\n===> [Stage 12] Pug to HTMX headless DOM harness"
	$(MAKE) -C stages/12_pug_htmx_dom

stage13: stage12
	@echo "\n===> [Stage 13] DOM serialization to XHTML 1.0 Strict"
	$(MAKE) -C stages/13_dom_xhtml

stage14: stage13
	@echo "\n===> [Stage 14] PostHTML / HTML minifier"
	$(MAKE) -C stages/14_posthtml_minify

stage15: stage14
	@echo "\n===> [Stage 15] Automated DOM assertion step"
	$(MAKE) -C stages/15_assertion

docker-build:
	docker build -t $(IMAGE_NAME) -f Dockerfile .

docker-run:
	docker run --rm -v "$$(pwd):/workspace" -w /workspace $(IMAGE_NAME) make stages-0-4

clean:
	$(MAKE) -C stages/00_input clean
	$(MAKE) -C stages/01_go_templ clean
	$(MAKE) -C stages/02_go_carchive clean
	$(MAKE) -C stages/03_emcc_wasm clean
	$(MAKE) -C stages/04_rust_wasmtime clean
	$(MAKE) -C stages/05_brainfuck_gen clean
	$(MAKE) -C stages/06_brainfuck_runtime clean
	$(MAKE) -C stages/07_babel_ast clean
	$(MAKE) -C stages/08_jsx_to_xml clean
	$(MAKE) -C stages/09_postgres_plpgsql clean
	$(MAKE) -C stages/10_pandoc_docbook clean
	$(MAKE) -C stages/11_xslt_pug clean
	$(MAKE) -C stages/12_pug_htmx_dom clean
	$(MAKE) -C stages/13_dom_xhtml clean
	$(MAKE) -C stages/14_posthtml_minify clean
	$(MAKE) -C stages/15_assertion clean
