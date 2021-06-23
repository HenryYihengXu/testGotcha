#define _GNU_SOURCE
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

size_t fread(void *ptr, size_t size, size_t nmemb, FILE *stream) {
    char* filename = recover_filename(stream);
    printf("In fread dlsym wrapper reading %s\n", filename);
    typeof(&fread) __real_fread = dlsym(RTLD_NEXT, "fread");
    return __real_fread(ptr, size, nmemb, stream);
}

#ifdef WITH_INIT_FINI
static void init(void) __attribute__((constructor));
static void fini(void) __attribute__((destructor));

static void init(void)
{
    printf("fread dlsym wrapper initializing\n");
}

static void fini(void)
{
    printf("fread dlsym wrapper finalizing\n");
}
#endif

