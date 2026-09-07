#include "libstage2.h"
#include <stdio.h>
#include <stdlib.h>

int main(void) {
    char* payload = RenderPayload();
    if (!payload) {
        fprintf(stderr, "Error: RenderPayload returned NULL\n");
        return 1;
    }

    FILE* out = fopen("wrapper.c", "w");
    if (!out) {
        perror("Error creating wrapper.c");
        FreePayload(payload);
        return 1;
    }

    fprintf(out, "#include <stdio.h>\n");
    fprintf(out, "#ifdef __EMSCRIPTEN__\n");
    fprintf(out, "#include <emscripten.h>\n");
    fprintf(out, "#define EXPORT EMSCRIPTEN_KEEPALIVE\n");
    fprintf(out, "#else\n");
    fprintf(out, "#define EXPORT\n");
    fprintf(out, "#endif\n\n");
    fprintf(out, "static const char PAYLOAD[] = \"");
    for (const char* p = payload; *p; p++) {
        if (*p == '"') fputs("\\\"", out);
        else if (*p == '\\') fputs("\\\\", out);
        else if (*p == '\n') fputs("\\n", out);
        else if (*p == '\r') fputs("\\r", out);
        else if (*p == '\t') fputs("\\t", out);
        else fputc(*p, out);
    }
    fprintf(out, "\";\n\n");
    fprintf(out, "EXPORT const char* get_payload(void) {\n");
    fprintf(out, "    return PAYLOAD;\n");
    fprintf(out, "}\n\n");
    fprintf(out, "int main(void) {\n");
    fprintf(out, "    fputs(get_payload(), stdout);\n");
    fprintf(out, "    return 0;\n");
    fprintf(out, "}\n");

    fclose(out);
    FreePayload(payload);
    printf("[Stage 2] bridge successfully linked libstage2.a and generated wrapper.c\n");
    return 0;
}
