.PHONY: all clean

all: output.html

output.html: ../00_input/input.html
	python3 render.py ../00_input/input.html output.html

clean:
	rm -f output.html
