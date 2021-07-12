#define _GNU_SOURCE
#include <unistd.h>
#include <stdio.h>
#include <string.h>
#include <stdarg.h>
#include <dlfcn.h>
#include <stdlib.h>
#include "gotcha/gotcha_types.h"
#include "gotcha/gotcha.h"

static gotcha_wrappee_handle_t wrappee_fwrite_handle;
static size_t gotcha_fwrite_wrapper(const void * ptr, size_t size, size_t count, FILE * stream);
struct gotcha_binding_t fwrite_wrap_actions [] = {
    {"fwrite", gotcha_fwrite_wrapper, &wrappee_fwrite_handle}
};

int fwrite2_init(int priority) {
    enum gotcha_error_t result; 
    result = gotcha_wrap(fwrite_wrap_actions, sizeof(fwrite_wrap_actions)/sizeof(struct gotcha_binding_t), "wrapper2");
    if (result != GOTCHA_SUCCESS) {
      fprintf(stderr, "gotcha_wrap returned %d\n", (int) result);
      return -1;
    }
    result = gotcha_set_priority("wrapper2", priority);
    if (result != GOTCHA_SUCCESS) {
      fprintf(stderr, "gotcha_set_priority returned %d\n", (int) result);
      return -1;
    }
    printf("gotcha fwrite2 wrapper in dlsym fread wrapper initializing with priority = %d\n", priority);
    return 0;
}

static size_t gotcha_fwrite_wrapper(const void * ptr, size_t size, size_t count, FILE * stream) {
    printf("In fwrite gotcha wrapper 2\n");
    //sleep(1);
    typeof(&gotcha_fwrite_wrapper) __real_fwrite = gotcha_get_wrappee(wrappee_fwrite_handle);
    return __real_fwrite(ptr, size, count, stream);
}

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
    int result = fwrite2_init(2);
    if (result != 0) {
        printf("fwrite2_init failed\n");
        return -1;
    }
    return __real_fread(ptr, size, nmemb, stream);
}
