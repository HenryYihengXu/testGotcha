#define _GNU_SOURCE
#include <unistd.h>
#include <stdio.h>
#include <string.h>
#include <stdarg.h>
#include <stdlib.h>
#include <dlfcn.h>

// int fwrite2_init(int priority);

// FILE* fopen(const char *filename, const char *mode) {
//     printf("In fopen executable wrapper\n");
//     int result = fwrite2_init(2);
//     if (result != 0) {
//         printf("fwrite2_init failed\n");
//         return -1;
//     }
//     typeof(&fopen) __real_fopen = dlsym(RTLD_NEXT, "fopen");
//     return __real_fopen(filename, mode);
// }

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
