#include <stdio.h>
#include <stdlib.h>

#define TAPE_SIZE 65536

int main(int argc, char** argv) {
    if (argc < 2) {
        fprintf(stderr, "Usage: %s <file.bf>\n", argv[0]);
        return 1;
    }

    FILE* f = fopen(argv[1], "rb");
    if (!f) {
        perror("Error opening Brainfuck source file");
        return 1;
    }

    fseek(f, 0, SEEK_END);
    long sz = ftell(f);
    fseek(f, 0, SEEK_SET);

    if (sz < 0) {
        fclose(f);
        fprintf(stderr, "Invalid file size\n");
        return 1;
    }

    char* code = (char*)malloc(sz + 1);
    if (!code) {
        fclose(f);
        fprintf(stderr, "Memory allocation failed for Brainfuck code\n");
        return 1;
    }

    size_t read_bytes = fread(code, 1, sz, f);
    code[read_bytes] = '\0';
    fclose(f);

    unsigned char tape[TAPE_SIZE] = {0};
    int ptr = 0;

    for (long pc = 0; pc < (long)read_bytes; pc++) {
        switch (code[pc]) {
            case '>':
                if (ptr < TAPE_SIZE - 1) ptr++;
                break;
            case '<':
                if (ptr > 0) ptr--;
                break;
            case '+':
                tape[ptr]++;
                break;
            case '-':
                tape[ptr]--;
                break;
            case '.':
                putchar(tape[ptr]);
                break;
            case ',': {
                int c = getchar();
                tape[ptr] = (c == EOF) ? 0 : (unsigned char)c;
                break;
            }
            case '[':
                if (!tape[ptr]) {
                    int depth = 1;
                    while (depth > 0 && ++pc < (long)read_bytes) {
                        if (code[pc] == '[') depth++;
                        else if (code[pc] == ']') depth--;
                    }
                }
                break;
            case ']':
                if (tape[ptr]) {
                    int depth = 1;
                    while (depth > 0 && --pc >= 0) {
                        if (code[pc] == ']') depth++;
                        else if (code[pc] == '[') depth--;
                    }
                }
                break;
            default:
                break;
        }
    }

    free(code);
    return 0;
}
