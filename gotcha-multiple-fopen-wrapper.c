#include "gotcha/gotcha_types.h"
#include "gotcha/gotcha.h"
#include <unistd.h>
#include <stdio.h>
#include <string.h>
#include <stdarg.h>

static gotcha_wrappee_handle_t wrappee_fopen_handle1;
static gotcha_wrappee_handle_t wrappee_fopen_handle2;
static FILE* gotcha_fopen_wrapper1(const char *filename, const char *mode);
static FILE* gotcha_fopen_wrapper2(const char *filename, const char *mode);
struct gotcha_binding_t fopen_wrap_actions1 [] = {
    {"fopen", gotcha_fopen_wrapper1, &wrappee_fopen_handle1}
};
struct gotcha_binding_t fopen_wrap_actions2 [] = {
    {"fopen", gotcha_fopen_wrapper2, &wrappee_fopen_handle2}
};

int fopen_init() {
    printf("multiple-fopen-wrapper1 initializing with priority = %d\n", 3);
    printf("multiple-fopen-wrapper2 initializing with priority = %d\n", 2);
    enum gotcha_error_t result; 
    result = gotcha_set_priority("multiple-fopen-wrapper1", 3);
    if (result != GOTCHA_SUCCESS) {
      printf("Error: multiple-fopen-wrapper1 gotcha_set_priority returned %d\n", (int) result);
      return -1;
    }
    result = gotcha_set_priority("multiple-fopen-wrapper2", 2);
    if (result != GOTCHA_SUCCESS) {
      printf("Error: multiple-fopen-wrapper2 gotcha_set_priority returned %d\n", (int) result);
      return -1;
    }
    result = gotcha_wrap(fopen_wrap_actions1, sizeof(fopen_wrap_actions1)/sizeof(struct gotcha_binding_t), "multiple-fopen-wrapper1");
    if (result != GOTCHA_SUCCESS) {
      fprintf(stderr, "Error: multiple-fopen-wrapper1 gotcha_wrap returned %d\n", (int) result);
      return -1;
    }
    result = gotcha_wrap(fopen_wrap_actions2, sizeof(fopen_wrap_actions2)/sizeof(struct gotcha_binding_t), "multiple-fopen-wrapper2");
    if (result != GOTCHA_SUCCESS) {
      fprintf(stderr, "Error: multiple-fopen-wrapper2 gotcha_wrap returned %d\n", (int) result);
      return -1;
    }
    return 0;
}

static FILE* gotcha_fopen_wrapper1(const char *filename, const char *mode) {
    printf("In multiple-fopen-wrapper1 opening %s\n", filename);
    //sleep(1);
    typeof(&gotcha_fopen_wrapper1) __real_fopen = gotcha_get_wrappee(wrappee_fopen_handle1);
    return __real_fopen(filename, mode);
}

static FILE* gotcha_fopen_wrapper2(const char *filename, const char *mode) {
    printf("In multiple-fopen-wrapper2 opening %s\n", filename);
    //sleep(1);
    typeof(&gotcha_fopen_wrapper2) __real_fopen = gotcha_get_wrappee(wrappee_fopen_handle2);
    return __real_fopen(filename, mode);
}

#ifdef WITH_INIT_FINI
static void init(void) __attribute__((constructor));
static void fini(void) __attribute__((destructor));

static void init(void)
{
    fopen_init();
}

static void fini(void)
{
    printf("fopen gotcha wrapper finalizing\n");
}
#endif
