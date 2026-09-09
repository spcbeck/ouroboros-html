.PHONY: all stages-0-6 stage0 stage1 stage2 stage3 stage4 stage5 stage6 stage7 stage8 stage9 stage10 stage11 stage12 stage13 stage14 stage15 stage16 stage17 stage18 stage19 clean docker-build docker-run ouroboros docker-ouroboros test-suite docker-test-suite example docker-example

IMAGE_NAME ?= ouroboros-html:latest
CYCLES ?= 3

example:
	@echo "=========================================================="
	@echo " [OUROBOROS-HTML] COMPILING EXAMPLE APP (example/index.html)"
	@echo "=========================================================="
	mkdir -p example/dist
	cp example/index.html stages/00_input/input.html
	$(MAKE) clean
	$(MAKE) all
	cp stages/19_assertion/output.html example/dist/index.html
	cp fixtures/01_canonical.html stages/00_input/input.html
	@echo ""
	@echo "=========================================================="
	@echo " [OUROBOROS-HTML] EXAMPLE COMPILED -> example/dist/index.html"
	@echo " Payload: $$(cat example/dist/index.html)"
	@echo "=========================================================="

docker-example:
	docker run --rm -v "$$(pwd):/workspace" -w /workspace $(IMAGE_NAME) make example

all: stage0 stage1 stage2 stage3 stage4 stage5 stage6 stage7 stage8 stage9 stage10 stage11 stage12 stage13 stage14 stage15 stage16 stage17 stage18 stage19
	@echo "=========================================================="
	@echo " ALL STAGES (0-19) EXECUTED"
	@echo "=========================================================="

test-suite:
	python3 scripts/test_suite.py

docker-test-suite:
	docker run --rm -v "$$(pwd):/workspace" -w /workspace $(IMAGE_NAME) make test-suite

ouroboros:
	python3 scripts/ouroboros_cycle.py --cycles $(CYCLES)

docker-ouroboros:
	docker run --rm -v "$$(pwd):/workspace" -w /workspace $(IMAGE_NAME) make ouroboros CYCLES=$(CYCLES)

stages-0-6: stage0 stage1 stage2 stage3 stage4 stage5 stage6
	@echo ""
	@echo "=========================================================="
	@echo " [OUROBOROS-HTML] STAGES 0-6 PIPELINE VERIFIED!"
	@echo " Input:  $$(cat stages/00_input/input.html)"
	@echo " Output: $$(cat stages/06_rust_wasmtime/output.txt)"
	@echo "=========================================================="

stage0:
	@echo "\n===> [Stage 0] Input HTML5"
	$(MAKE) -C stages/00_input

stage1: stage0
	@echo "\n===> [Stage 1] Python (Jinja2) template AST parsing & evaluation"
	$(MAKE) -C stages/01_python_jinja2

stage2: stage1
	@echo "\n===> [Stage 2] PHP 8.3 CLI Hypertext Preprocessor execution"
	$(MAKE) -C stages/02_php_preprocessor

stage3: stage2
	@echo "\n===> [Stage 3] Go (templ) component generation"
	$(MAKE) -C stages/03_go_templ

stage4: stage3
	@echo "\n===> [Stage 4] Go c-archive exported C headers & bridge"
	$(MAKE) -C stages/04_go_carchive

stage5: stage4
	@echo "\n===> [Stage 5] C wrapper compiled to WebAssembly via Emscripten (emcc)"
	$(MAKE) -C stages/05_emcc_wasm

stage6: stage5
	@echo "\n===> [Stage 6] Rust binary ingesting Wasm bytecode via wasmtime"
	$(MAKE) -C stages/06_rust_wasmtime

stage7: stage6
	@echo "\n===> [Stage 7] Brainfuck generator"
	$(MAKE) -C stages/07_brainfuck_gen

stage8: stage7
	@echo "\n===> [Stage 8] Brainfuck runtime"
	$(MAKE) -C stages/08_brainfuck_runtime

stage9: stage8
	@echo "\n===> [Stage 9] Babel AST pipeline"
	$(MAKE) -C stages/09_babel_ast

stage10: stage9
	@echo "\n===> [Stage 10] Svelte component AST compiler & SSR execution"
	$(MAKE) -C stages/10_svelte_ast

stage11: stage10
	@echo "\n===> [Stage 11] JSX to XML compiler"
	$(MAKE) -C stages/11_jsx_to_xml

stage12: stage11
	@echo "\n===> [Stage 12] PostgreSQL PL/pgSQL XML recursive query"
	$(MAKE) -C stages/12_postgres_plpgsql

stage13: stage12
	@echo "\n===> [Stage 13] Pandoc LaTeX to Org-Mode to DocBook XML"
	$(MAKE) -C stages/13_pandoc_docbook

stage14: stage13
	@echo "\n===> [Stage 14] XSLT DocBook to Pug (Jade)"
	$(MAKE) -C stages/14_xslt_pug

stage15: stage14
	@echo "\n===> [Stage 15] Handlebars template AST compilation & execution"
	$(MAKE) -C stages/15_handlebars

stage16: stage15
	@echo "\n===> [Stage 16] HTMX headless DOM harness"
	$(MAKE) -C stages/16_htmx_dom

stage17: stage16
	@echo "\n===> [Stage 17] DOM serialization to XHTML 1.0 Strict"
	$(MAKE) -C stages/17_dom_xhtml

stage18: stage17
	@echo "\n===> [Stage 18] PostHTML / HTML minifier"
	$(MAKE) -C stages/18_posthtml_minify

stage19: stage18
	@echo "\n===> [Stage 19] Automated DOM assertion step"
	$(MAKE) -C stages/19_assertion

docker-build:
	docker build -t $(IMAGE_NAME) -f Dockerfile .

docker-run:
	docker run --rm -v "$$(pwd):/workspace" -w /workspace $(IMAGE_NAME) make all

clean:
	$(MAKE) -C stages/00_input clean
	$(MAKE) -C stages/01_python_jinja2 clean
	$(MAKE) -C stages/02_php_preprocessor clean
	$(MAKE) -C stages/03_go_templ clean
	$(MAKE) -C stages/04_go_carchive clean
	$(MAKE) -C stages/05_emcc_wasm clean
	$(MAKE) -C stages/06_rust_wasmtime clean
	$(MAKE) -C stages/07_brainfuck_gen clean
	$(MAKE) -C stages/08_brainfuck_runtime clean
	$(MAKE) -C stages/09_babel_ast clean
	$(MAKE) -C stages/10_svelte_ast clean
	$(MAKE) -C stages/11_jsx_to_xml clean
	$(MAKE) -C stages/12_postgres_plpgsql clean
	$(MAKE) -C stages/13_pandoc_docbook clean
	$(MAKE) -C stages/14_xslt_pug clean
	$(MAKE) -C stages/15_handlebars clean
	$(MAKE) -C stages/16_htmx_dom clean
	$(MAKE) -C stages/17_dom_xhtml clean
	$(MAKE) -C stages/18_posthtml_minify clean
	$(MAKE) -C stages/19_assertion clean
