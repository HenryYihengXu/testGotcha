#define _GNU_SOURCE
#include <unistd.h>
#include <stdio.h>
#include <string.h>
#include <stdarg.h>
#include <dlfcn.h>
#include <stdlib.h>

ssize_t fwrite (int fd, const void *buf, size_t count) {
    printf("In write dlsym wrapper 1\n");
    //sleep(1);
    typeof(&write) __real_fwrite = dlsym(RTLD_NEXT, "write");
    return __real_fwrite(fd, buf, count);
}

#ifdef WITH_INIT_FINI
static void init(void) __attribute__((constructor));
static void fini(void) __attribute__((destructor));

static void init(void)
{
    printf("write dlsym wrapper 1 initializing\n");
}

static void fini(void)
{
    printf("write dlsym wrapper 1 finalizing\n");
}
#endif