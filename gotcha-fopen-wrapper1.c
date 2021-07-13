#include "gotcha/gotcha_types.h"
#include "gotcha/gotcha.h"
#include <unistd.h>
#include <stdio.h>
#include <string.h>
#include <stdarg.h>

static gotcha_wrappee_handle_t wrappee_fopen_handle;
static FILE* gotcha_fopen_wrapper(const char *filename, const char *mode);
struct gotcha_binding_t fopen_wrap_actions [] = {
    {"fopen", gotcha_fopen_wrapper, &wrappee_fopen_handle}
};

int fopen1_init(int priority) {
    printf("fopen gotcha wrapper 1 initializing with priority = %d\n", priority);
    enum gotcha_error_t result;
    result = gotcha_set_priority("fopen-wrapper1", priority);
    if (result != GOTCHA_SUCCESS) {
      printf("Error: fopen-wrapper1 gotcha_set_priority returned %d\n", (int) result);
      return -1;
    } 
    result = gotcha_wrap(fopen_wrap_actions, sizeof(fopen_wrap_actions)/sizeof(struct gotcha_binding_t), "fopen-wrapper1");
    if (result != GOTCHA_SUCCESS) {
      fprintf(stderr, "Error: fopen-wrapper1 gotcha_wrap returned %d\n", (int) result);
      return -1;
    }
    return 0;
}

static FILE* gotcha_fopen_wrapper(const char *filename, const char *mode) {
    printf("In fopen gotcha wrapper1 opening %s\n", filename);
    //sleep(1);
    typeof(&gotcha_fopen_wrapper) __real_fopen = gotcha_get_wrappee(wrappee_fopen_handle);
    return __real_fopen(filename, mode);
}

#ifdef WITH_INIT_FINI
static void init(void) __attribute__((constructor));
static void fini(void) __attribute__((destructor));

static void init(void)
{
    fopen1_init(PRIORITY);
}

static void fini(void)
{
    printf("fopen gotcha wrapper1 finalizing\n");
}
#endif
