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

int fopen_init(int priority) {
    gotcha_set_priority("wrapper2", priority);

    enum gotcha_error_t result; 
    result = gotcha_wrap(fopen_wrap_actions, sizeof(fopen_wrap_actions)/sizeof(struct gotcha_binding_t), "wrapper2");
    if (result != GOTCHA_SUCCESS) {
      fprintf(stderr, "gotcha_wrap returned %d\n", (int) result);
      return -1;
    }
}

static FILE* gotcha_fopen_wrapper(const char *filename, const char *mode) {
    printf("In fopen gotcha wrapper2 opening %s\n", filename);
    //sleep(1);
    typeof(&gotcha_fopen_wrapper) __real_fopen = gotcha_get_wrappee(wrappee_fopen_handle);
    return __real_fopen(filename, mode);
}

#ifdef WITH_INIT_FINI
static void init(void) __attribute__((constructor));
static void fini(void) __attribute__((destructor));

static void init(void)
{
    fopen_init(PRIORITY);
    printf("fopen gotcha wrapper2 initializing\n");
}

static void fini(void)
{
    printf("fopen gotcha wrapper2 finalizing\n");
}
#endif
