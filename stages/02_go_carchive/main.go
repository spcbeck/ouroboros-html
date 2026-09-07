package main

/*
#include <stdlib.h>
*/
import "C"
import (
	"bytes"
	"context"
	"unsafe"
)

//export RenderPayload
func RenderPayload() *C.char {
	var buf bytes.Buffer
	if err := Component().Render(context.Background(), &buf); err != nil {
		return C.CString("")
	}
	return C.CString(buf.String())
}

//export FreePayload
func FreePayload(ptr *C.char) {
	if ptr != nil {
		C.free(unsafe.Pointer(ptr))
	}
}

func main() {}
