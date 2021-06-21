#include <unistd.h>
#include <stdio.h>
#include <string.h>
#include <stdarg.h>
#include <stdlib.h>

int main() {
    FILE *f;
    f = fopen("./a.txt", "ab");
    char* buf = "aaaaaaaaa\n";
    fwrite(buf, sizeof(char), 10, f);
    return 0;
}
