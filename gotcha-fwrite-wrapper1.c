#include "gotcha/gotcha_types.h"
#include "gotcha/gotcha.h"
#include <unistd.h>
#include <stdio.h>
#include <string.h>
#include <stdarg.h>

static gotcha_wrappee_handle_t wrappee_fwrite_handle;
static size_t gotcha_fwrite_wrapper(const void * ptr, size_t size, size_t count, FILE * stream);
struct gotcha_binding_t fwrite_wrap_actions [] = {
    {"fwrite", gotcha_fwrite_wrapper, &wrappee_fwrite_handle}
};

int fwrite1_init(int priority) {
    gotcha_set_priority("wrapper1", priority);

    enum gotcha_error_t result; 
    result = gotcha_wrap(fwrite_wrap_actions, sizeof(fwrite_wrap_actions)/sizeof(struct gotcha_binding_t), "wrapper1");
    if (result != GOTCHA_SUCCESS) {
      fprintf(stderr, "gotcha_wrap returned %d\n", (int) result);
      return -1;
    }
}

static size_t gotcha_fwrite_wrapper(const void * ptr, size_t size, size_t count, FILE * stream) {
    printf("In fwrite gotcha wrapper 1\n");
    //sleep(1);
    typeof(&gotcha_fwrite_wrapper) __real_fwrite = gotcha_get_wrappee(wrappee_fwrite_handle);
    return __real_fwrite(ptr, size, count, stream);
}

#ifdef WITH_INIT_FINI
static void init(void) __attribute__((constructor));
static void fini(void) __attribute__((destructor));

static void init(void)
{
    fwrite1_init(PRIORITY);
    printf("fwrite gotcha wrapper 1 initializing\n");
}

static void fini(void)
{
    printf("fwrite gotcha wrapper 1 finalizing\n");
}
#endif
