#include <unistd.h>
#include <stdio.h>
#include <string.h>
#include <stdarg.h>
#include <stdlib.h>
#include <dlfcn.h>

int fwrite2_init(int priority);

FILE* fopen(const char *filename, const char *mode) {
    int result = fwrite2_init(2);
    if (result != 0) {
        printf("fwrite2_init failed\n");
        return -1;
    }
    typeof(&fopen) __real_fopen = dlsym(RTLD_NEXT, fopen);
    return __real_fopen(filename, mode);
}

int main() {
    FILE *f;
    f = fopen("./a.txt", "w");
    char* buf = "aaaaaaaaa\n";
    fwrite(buf, sizeof(char), 10, f);
    return 0;
}
