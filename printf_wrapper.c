#include "gotcha/gotcha_types.h"
#include "gotcha/gotcha.h"
#include <unistd.h>
#include <stdio.h>
#include <string.h>
#include <stdarg.h>

static gotcha_wrappee_handle_t wrappee_printf_handle;
static int printf_wrapper(const char *str);
struct gotcha_binding_t wrap_actions [] = {
    {"printf", printf_wrapper, &wrappee_printf_handle}
}

int init() {
    enum gotcha_error_t result;
    result = gotcha_wrap(wrap_actions, sizeof(wrap_actions)/sizeof(struct gotcha_binding_t) "whatever");
    if (result != GOTCHA_SUCCESS) {
      fprintf(stderr, "gotcha_wrap returned %d\n", (int) result);
      return -1;
   }
}

static int printf_wrapper(const char *str) {
    const char *s = "I'm wrapped: ";
    typeof(&printf_wrapper) wrappee_printf = gotcha_get_wrappee(wrappee_printf_handle);
    return wrappee_printf(s + str);
}

int main() {
    int result;
    result = init();
    if (result != 0) {
        return -1;
    }

    printf("test\n");
    return 0;
}

