#include "gotcha/gotcha_types.h"
#include "gotcha/gotcha.h"
#include <unistd.h>
#include <stdio.h>
#include <string.h>
#include <stdarg.h>

static gotcha_wrappee_handle_t wrappee_write_handle;
static ssize_t gotcha_write_wrapper(int fd, const void *buf, size_t count);
struct gotcha_binding_t write_wrap_actions [] = {
    {"write", gotcha_write_wrapper, &wrappee_write_handle}
};

int write2_init(int priority) {
    printf("write gotcha wrapper 2 initializing with priority = %d\n", priority);
    enum gotcha_error_t result;
    result = gotcha_set_priority("write-wrapper2", priority);
    if (result != GOTCHA_SUCCESS) {
      printf("Error: write-wrapper2 gotcha_set_priority returned %d\n", (int) result);
      return -1;
    } 
    result = gotcha_wrap(write_wrap_actions, sizeof(write_wrap_actions)/sizeof(struct gotcha_binding_t), "write-wrapper2");
    if (result != GOTCHA_SUCCESS) {
      printf("Error: write-wrapper2 gotcha_wrap returned %d\n", (int) result);
      return -1;
    }
    return 0;
}

static ssize_t gotcha_write_wrapper(int fd, const void *buf, size_t count) {
    printf("In write gotcha wrapper 2\n");
    //sleep(1);
    typeof(&gotcha_write_wrapper) __real_write = gotcha_get_wrappee(wrappee_write_handle);
    return __real_write(fd, buf, count);
}

#ifdef WITH_INIT_FINI
static void init(void) __attribute__((constructor));
static void fini(void) __attribute__((destructor));

static void init(void)
{
    write2_init(PRIORITY);
}

static void fini(void)
{
    printf("write gotcha wrapper 2 finalizing\n");
}
#endif
