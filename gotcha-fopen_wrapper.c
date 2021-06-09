#include "gotcha/gotcha_types.h"
#include "gotcha/gotcha.h"
#include <unistd.h>
#include <stdio.h>
#include <string.h>
#include <stdarg.h>

static gotcha_wrappee_handle_t wrappee_fopen_handle;
static int gotcha_fopen_wrapper(const char *filename, const char *mode);
struct gotcha_binding_t wrap_actions [] = {
    {"fopen", gotcha_fopen_wrapper, &wrappee_fopen_handle}
};

int init() {
    enum gotcha_error_t result;
    result = gotcha_wrap(wrap_actions, sizeof(wrap_actions)/sizeof(struct gotcha_binding_t), "whatever");
    if (result != GOTCHA_SUCCESS) {
      fprintf(stderr, "gotcha_wrap returned %d\n", (int) result);
      return -1;
   }
}

static int gotcha_fopen_wrapper(const char *filename, const char *mode) {
    printf("opening %s\n", filename);
    typeof(&gotcha_fopen_wrapper) wrappee_fopen = gotcha_get_wrappee(wrappee_fopen_handle);
    return wrappee_fopen(filename, mode);
}

int main() {
    int result;
    result = init();
    if (result != 0) {
        return -1;
    }

    fopen("./a.txt", "w");
    return 0;
}

