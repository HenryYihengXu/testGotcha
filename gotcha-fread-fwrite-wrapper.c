#include "gotcha/gotcha_types.h"
#include "gotcha/gotcha.h"
#include <unistd.h>
#include <stdio.h>
#include <string.h>
#include <stdarg.h>

static gotcha_wrappee_handle_t wrappee_fread_handle;
static gotcha_wrappee_handle_t wrappee_fwrite_handle;
static size_t gotcha_fread_wrapper(void *ptr, size_t size, size_t nmemb, FILE *stream);
static size_t gotcha_fwrite_wrapper(const void * ptr, size_t size, size_t count, FILE * stream);
struct gotcha_binding_t fread_fwrite_wrap_actions [] = {
    {"fread", gotcha_fread_wrapper, &wrappee_fread_handle},
    {"fwrite", gotcha_fwrite_wrapper, &wrappee_fwrite_handle}
};

int fread_fwrite_init(int priority) {
    printf("fread-fwrite gotcha wrapper initializing with priority = %d\n", priority);
    enum gotcha_error_t result;
    result = gotcha_set_priority("fread-fwrite-wrapper", priority);
    if (result != GOTCHA_SUCCESS) {
      printf("Error: fread-fwrite gotcha_set_priority returned %d\n", (int) result);
      return -1;
    } 
    result = gotcha_wrap(fread_fwrite_wrap_actions, sizeof(fread_fwrite_wrap_actions)/sizeof(struct gotcha_binding_t), "fread-fwrite-wrapper");
    if (result != GOTCHA_SUCCESS) {
      fprintf(stderr, "Error: fread-fwrite gotcha_wrap returned %d\n", (int) result);
      return -1;
    }
    return 0;
}

static size_t gotcha_fread_wrapper(void *ptr, size_t size, size_t nmemb, FILE *stream) {
    printf("In fread-fwrite fread gotcha wrapper\n");
    //sleep(1);
    typeof(&gotcha_fread_wrapper) __real_fread = gotcha_get_wrappee(wrappee_fread_handle);
    return __real_fread(ptr, size, nmemb, stream);
}

static size_t gotcha_fwrite_wrapper(const void * ptr, size_t size, size_t count, FILE * stream) {
    printf("In fread-fwrite fwrite gotcha wrapper\n");
    //sleep(1);
    typeof(&gotcha_fwrite_wrapper) __real_fwrite = gotcha_get_wrappee(wrappee_fwrite_handle);
    return __real_fwrite(ptr, size, count, stream);
}

#ifdef WITH_INIT_FINI
static void init(void) __attribute__((constructor));
static void fini(void) __attribute__((destructor));

static void init(void)
{
    fread_fwrite_init(PRIORITY);
}

static void fini(void)
{
    printf("fread-fwrite gotcha wrapper finalizing\n");
}
#endif
