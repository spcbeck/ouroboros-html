.PHONY: all clean

all: payload.bf
	mkdir -p ../06_brainfuck_runtime
	cp payload.bf ../06_brainfuck_runtime/payload.bf

payload.bf: ../04_rust_wasmtime/output.txt text2bf.py
	python3 text2bf.py ../04_rust_wasmtime/output.txt payload.bf

clean:
	rm -f payload.bf
