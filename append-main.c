#include <unistd.h>
#include <stdio.h>
#include <string.h>
#include <stdarg.h>
#include <stdlib.h>

int main() {
    FILE *f;
    f = fopen("./a.txt", "a");
    char* buf = "aaaaaaaa\n";
    write(f, buf, 10);
    return 0;
}
