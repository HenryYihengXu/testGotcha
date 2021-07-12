#define _GNU_SOURCE
#include <unistd.h>
#include <stdio.h>
#include <string.h>
#include <stdarg.h>
#include <dlfcn.h>
#include <stdlib.h>
#include "gotcha/gotcha_types.h"
#include "gotcha/gotcha.h"

static gotcha_wrappee_handle_t wrappee_fopen_handle;
static FILE* gotcha_fopen_wrapper(const char *filename, const char *mode);
struct gotcha_binding_t fopen_wrap_actions [] = {
    {"fopen", gotcha_fopen_wrapper, &wrappee_fopen_handle}
};

int fopen1_init(int priority) {
    gotcha_set_priority("wrapper1", priority);

    enum gotcha_error_t result; 
    result = gotcha_wrap(fopen_wrap_actions, sizeof(fopen_wrap_actions)/sizeof(struct gotcha_binding_t), "wrapper1");
    if (result != GOTCHA_SUCCESS) {
      fprintf(stderr, "gotcha_wrap returned %d\n", (int) result);
      return -1;
    }
}

static FILE* gotcha_fopen_wrapper(const char *filename, const char *mode) {
    printf("In fopen gotcha wrapper1 opening %s\n", filename);
    //sleep(1);
    typeof(&gotcha_fopen_wrapper) __real_fopen = gotcha_get_wrappee(wrappee_fopen_handle);
    return __real_fopen(filename, mode);
}

FILE* fopen(const char *filename, const char *mode) {
    printf("In fopen dlsym wrapper opening %s\n", filename);
    //sleep(1);
    typeof(&fopen) __real_fopen = dlsym(RTLD_NEXT, "fopen");
    printf("In fopen executable wrapper\n");
    int result = fopen1_init(2);
    if (result != 0) {
        printf("fopen1_init failed\n");
        return -1;
    }
    return __real_fopen(filename, mode);
}
