.PHONY: all clean

all: component_templ.go

component.templ: ../02_php_preprocessor/output.html gen.go
	go run gen.go ../02_php_preprocessor/output.html

component_templ.go: component.templ
	templ generate component.templ
	@echo "[Stage 3] Successfully compiled component.templ -> component_templ.go"

clean:
	rm -f component.templ component_templ.go
