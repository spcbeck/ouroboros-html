package main

import (
	"bytes"
	"fmt"
	"os"

	"golang.org/x/net/html"
)

func main() {
	inputPath := "../02_php_preprocessor/output.html"
	if len(os.Args) > 1 {
		inputPath = os.Args[1]
	}
	data, err := os.ReadFile(inputPath)
	if err != nil {
		fmt.Fprintf(os.Stderr, "Error reading %s: %v\n", inputPath, err)
		os.Exit(1)
	}

	// Parse HTML through legitimate HTML5 parser to validate AST
	doc, err := html.Parse(bytes.NewReader(data))
	if err != nil {
		fmt.Fprintf(os.Stderr, "Error parsing HTML AST: %v\n", err)
		os.Exit(1)
	}

	// Locate elements inside body
	var body *html.Node
	var findBody func(*html.Node)
	findBody = func(n *html.Node) {
		if n.Type == html.ElementNode && n.Data == "body" {
			body = n
			return
		}
		for c := n.FirstChild; c != nil; c = c.NextSibling {
			findBody(c)
		}
	}
	findBody(doc)

	var rendered bytes.Buffer
	if body != nil {
		for c := body.FirstChild; c != nil; c = c.NextSibling {
			if err := html.Render(&rendered, c); err != nil {
				fmt.Fprintf(os.Stderr, "Error rendering HTML node: %v\n", err)
				os.Exit(1)
			}
		}
	} else {
		rendered.Write(data)
	}

	templContent := fmt.Sprintf("package main\n\ntempl Component() {\n\t%s\n}\n", rendered.String())
	if err := os.WriteFile("component.templ", []byte(templContent), 0644); err != nil {
		fmt.Fprintf(os.Stderr, "Error writing component.templ: %v\n", err)
		os.Exit(1)
	}

	fmt.Println("[Stage 3] Successfully parsed HTML AST and emitted component.templ")
}
