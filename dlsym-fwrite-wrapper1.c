#define _GNU_SOURCE
#include <unistd.h>
#include <stdio.h>
#include <string.h>
#include <stdarg.h>
#include <dlfcn.h>
#include <stdlib.h>

size_t fwrite ( const void * ptr, size_t size, size_t count, FILE * stream ) {
    printf("In fwrite dlsym wrapper 1\n");
    //sleep(1);
    typeof(&fwrite) __real_fwrite = dlsym(RTLD_NEXT, "fwrite");
    return __real_fwrite(ptr, size, count, stream);
}

#ifdef WITH_INIT_FINI
static void init(void) __attribute__((constructor));
static void fini(void) __attribute__((destructor));

static void init(void)
{
    printf("fwrite dlsym wrapper 1 initializing\n");
}

static void fini(void)
{
    printf("fwrite dlsym wrapper 1 finalizing\n");
}
#endif