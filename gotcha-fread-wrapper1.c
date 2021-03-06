#include "gotcha/gotcha_types.h"
#include "gotcha/gotcha.h"
#include <unistd.h>
#include <stdio.h>
#include <string.h>
#include <stdarg.h>

static gotcha_wrappee_handle_t wrappee_fread_handle;
static size_t gotcha_fread_wrapper(void *ptr, size_t size, size_t nmemb, FILE *stream);
struct gotcha_binding_t fread_wrap_actions [] = {
    {"fread", gotcha_fread_wrapper, &wrappee_fread_handle}
};

int fread1_init(int priority) {
    printf("fread gotcha wrapper 1 initializing with priority = %d\n", priority);
    enum gotcha_error_t result;
    result = gotcha_set_priority("fread-wrapper1", priority);
    if (result != GOTCHA_SUCCESS) {
      printf("Error: fread-wrapper1 gotcha_set_priority returned %d\n", (int) result);
      return -1;
    } 
    result = gotcha_wrap(fread_wrap_actions, sizeof(fread_wrap_actions)/sizeof(struct gotcha_binding_t), "fread-wrapper1");
    if (result != GOTCHA_SUCCESS) {
      fprintf(stderr, "Error: fread-wrapper1 gotcha_wrap returned %d\n", (int) result);
      return -1;
    }
    return 0;
}

static size_t gotcha_fread_wrapper(void *ptr, size_t size, size_t nmemb, FILE *stream) {
    printf("In fread gotcha wrapper 1\n");
    //sleep(1);
    typeof(&gotcha_fread_wrapper) __real_fread = gotcha_get_wrappee(wrappee_fread_handle);
    return __real_fread(ptr, size, nmemb, stream);
}

#ifdef WITH_INIT_FINI
static void init(void) __attribute__((constructor));
static void fini(void) __attribute__((destructor));

static void init(void)
{
    fread1_init(PRIORITY);
}

static void fini(void)
{
    printf("fread gotcha wrapper 1 finalizing\n");
}
#endif
