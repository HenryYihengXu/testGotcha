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
    printf("fwrite-wrapper2-init-by-dlsym-fopen initializing with priority = %d\n", priority);
    enum gotcha_error_t result;
    result = gotcha_set_priority("fwrite-wrapper2-init-by-dlsym-fopen", priority);
    if (result != GOTCHA_SUCCESS) {
      printf("Error: fwrite-wrapper2-init-by-dlsym-fopen gotcha_set_priority returned %d\n", (int) result);
      return -1;
    } 
    if (result != GOTCHA_SUCCESS) {
      fprintf(stderr, "Error: fwrite-wrapper2-init-by-dlsym-fopen gotcha_wrap returned %d\n", (int) result);
      return -1;
    }
    return 0;
}

static size_t gotcha_fwrite_wrapper(const void * ptr, size_t size, size_t count, FILE * stream) {
    printf("In fwrite gotcha wrapper 2\n");
    //sleep(1);
    typeof(&gotcha_fwrite_wrapper) __real_fwrite = gotcha_get_wrappee(wrappee_fwrite_handle);
    return __real_fwrite(ptr, size, count, stream);
}

FILE* fopen(const char *filename, const char *mode) {
    printf("In fopen dlsym wrapper opening %s\n", filename);
    //sleep(1);
    typeof(&fopen) __real_fopen = dlsym(RTLD_NEXT, "fopen");
    int result = fwrite2_init(3);
    if (result != 0) {
        printf("fwrite2_init failed\n");
        return NULL;
    }
    return __real_fopen(filename, mode);
}
