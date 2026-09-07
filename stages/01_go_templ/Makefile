.PHONY: all clean

all: component_templ.go

component.templ: ../00_input/input.html gen.go
	go run gen.go ../00_input/input.html

component_templ.go: component.templ
	templ generate component.templ
	@echo "[Stage 1] Successfully compiled component.templ -> component_templ.go"

clean:
	rm -f component.templ component_templ.go
