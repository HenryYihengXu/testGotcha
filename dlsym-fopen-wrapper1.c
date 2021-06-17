#define _GNU_SOURCE
#include <unistd.h>
#include <stdio.h>
#include <string.h>
#include <stdarg.h>
#include <dlfcn.h>
#include <stdlib.h>

FILE* fopen(const char *filename, const char *mode) {
    printf("In fopen dlsym wrapper 1 opening %s\n", filename);
    //sleep(1);
    typeof(&fopen) __real_fopen = dlsym(RTLD_NEXT, "fopen");
    return __real_fopen(filename, mode);
}
