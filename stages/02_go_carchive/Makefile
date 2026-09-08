.PHONY: all clean

CC ?= gcc

UNAME_S := $(shell uname -s)
ifeq ($(UNAME_S),Darwin)
    LDFLAGS ?= -pthread
else ifeq ($(UNAME_S),Linux)
    LDFLAGS ?= -lpthread -ldl
else
    LDFLAGS ?= -lpthread
endif

all: wrapper.c
	mkdir -p ../03_emcc_wasm
	cp wrapper.c ../03_emcc_wasm/wrapper.c
	@echo "[Stage 2] Exported C headers, archive built, and wrapper.c emitted for Stage 3"

component_templ.go: ../01_go_templ/component_templ.go
	cp ../01_go_templ/component_templ.go component_templ.go

libstage2.a libstage2.h: main.go component_templ.go
	go mod tidy
	go build -buildmode=c-archive -o libstage2.a main.go component_templ.go

bridge: bridge.c libstage2.a libstage2.h
	$(CC) -Wall -O2 bridge.c libstage2.a $(LDFLAGS) -o bridge

wrapper.c: bridge
	./bridge

clean:
	rm -f component_templ.go libstage2.a libstage2.h bridge wrapper.c
