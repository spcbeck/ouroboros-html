.PHONY: all clean

all: output.html

output.html: ../01_python_jinja2/output.html
	php render.php ../01_python_jinja2/output.html output.html

clean:
	rm -f output.html template.php
