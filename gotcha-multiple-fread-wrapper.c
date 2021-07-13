#include "gotcha/gotcha_types.h"
#include "gotcha/gotcha.h"
#include <unistd.h>
#include <stdio.h>
#include <string.h>
#include <stdarg.h>

static gotcha_wrappee_handle_t wrappee_fread_handle1;
static gotcha_wrappee_handle_t wrappee_fread_handle2;
static FILE* gotcha_fread_wrapper1(const char *filename, const char *mode);
static FILE* gotcha_fread_wrapper2(const char *filename, const char *mode);
struct gotcha_binding_t fread_wrap_actions1 [] = {
    {"fread", gotcha_fread_wrapper1, &wrappee_fread_handle1}
};
struct gotcha_binding_t fread_wrap_actions2 [] = {
    {"fread", gotcha_fread_wrapper2, &wrappee_fread_handle2}
};

int fread_init() {
    printf("multiple-fread-wrapper1 initializing with priority = %d\n", 3);
    printf("multiple-fread-wrapper2 initializing with priority = %d\n", 2);
    enum gotcha_error_t result; 
    result = gotcha_set_priority("multiple-fread-wrapper1", 1);
    if (result != GOTCHA_SUCCESS) {
      printf("Error: multiple-fread-wrapper1 gotcha_set_priority returned %d\n", (int) result);
      return -1;
    }
    result = gotcha_set_priority("multiple-fread-wrapper2", 2);
    if (result != GOTCHA_SUCCESS) {
      printf("Error: multiple-fread-wrapper2 gotcha_set_priority returned %d\n", (int) result);
      return -1;
    }
    result = gotcha_wrap(fread_wrap_actions1, sizeof(fread_wrap_actions1)/sizeof(struct gotcha_binding_t), "multiple-fread-wrapper1");
    if (result != GOTCHA_SUCCESS) {
      fprintf(stderr, "Error: multiple-fread-wrapper1 gotcha_wrap returned %d\n", (int) result);
      return -1;
    }
    result = gotcha_wrap(fread_wrap_actions2, sizeof(fread_wrap_actions2)/sizeof(struct gotcha_binding_t), "multiple-fread-wrapper2");
    if (result != GOTCHA_SUCCESS) {
      fprintf(stderr, "Error: multiple-fread-wrapper2 gotcha_wrap returned %d\n", (int) result);
      return -1;
    }
    return 0;
}

static FILE* gotcha_fread_wrapper1(const char *filename, const char *mode) {
    printf("In multiple-fread-wrapper1 opening %s\n", filename);
    //sleep(1);
    typeof(&gotcha_fread_wrapper1) __real_fread = gotcha_get_wrappee(wrappee_fread_handle1);
    return __real_fread(filename, mode);
}

static FILE* gotcha_fread_wrapper2(const char *filename, const char *mode) {
    printf("In multiple-fread-wrapper2 opening %s\n", filename);
    //sleep(1);
    typeof(&gotcha_fread_wrapper2) __real_fread = gotcha_get_wrappee(wrappee_fread_handle2);
    return __real_fread(filename, mode);
}

#ifdef WITH_INIT_FINI
static void init(void) __attribute__((constructor));
static void fini(void) __attribute__((destructor));

static void init(void)
{
    fread_init();
}

static void fini(void)
{
    printf("fread gotcha wrapper finalizing\n");
}
#endif
