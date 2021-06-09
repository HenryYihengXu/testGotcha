#include <stdio.h>
#include <stdlib.h>

int main() {
    FILE *f;
    f = fopen("./a.txt", "w");
    char buf[1024];
    fread(buf, 1024, 1, f);
    return 0;
}

