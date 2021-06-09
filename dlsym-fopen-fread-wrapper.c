#include <unistd.h>
#include <stdio.h>
#include <string.h>
#include <stdarg.h>
#include <dlfcn.h>
#include <stdlib.h>

char *recover_filename(FILE *f)
{
    char fd_path[256];
    int fd = fileno(f);
    sprintf(fd_path, "/proc/self/fd/%d", fd);
    char *filename = malloc(256);
    int n;
    if ((n = readlink(fd_path, filename, 255)) < 0)
        return NULL;
    filename[n] = '\0';
    return filename;
}

FILE* fopen(const char *filename, const char *mode) {
    printf("In fopen wrapper opening %s\n", filename);
    //sleep(1);
    typeof(&fopen) __real_fopen = dlsym(RTLD_NEXT, "fopen");
    return __real_fopen(filename, mode);
}

size_t fread(void *ptr, size_t size, size_t nmemb, FILE *stream) {
    char* filename = recover_filename(stream);
    printf("In fread wrapper reading %s\n", filename);
    typeof(&fread) __real_fread = dlsym(RTLD_NEXT, "fread");
    return __real_fread(ptr, size, nmemb, stream);
}

int main() {
    FILE *f;
    f = fopen("./a.txt", "rb");
    char buf[1024];
    fread(buf, 1024, 1, f);
    return 0;
}

