#define _GNU_SOURCE
#include <unistd.h>
#include <stdio.h>
#include <string.h>
#include <stdarg.h>
#include <stdlib.h>
#include <dlfcn.h>

int main() {
    FILE *f;
    f = fopen("./a.txt", "w");
    char* write_buf = "aaaaaaaaa\n";
    fwrite(write_buf, sizeof(char), 10, f);
    char read_buf[1024];
    fread(read_buf, 1024, 1, f);
    write_buf = "bbbbbbbbb\n";
    fwrite(write_buf, sizeof(char), 10, f);
    return 0;
}
