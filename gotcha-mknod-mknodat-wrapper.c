#include "gotcha/gotcha_types.h"
#include "gotcha/gotcha.h"
#include <unistd.h>
#include <stdio.h>
#include <sys/stat.h>
#include <errno.h>

static gotcha_wrappee_handle_t wrappee_mknod_handle;
static gotcha_wrappee_handle_t wrappee_mknodat_handle;
int gotcha_mknod_wrapper(const char *pathname, mode_t mode, dev_t dev);
int gotcha_mknodat_wrapper(int dirfd, const char *pathname, mode_t mode, dev_t dev);
struct gotcha_binding_t mknod_mknodat_wrap_actions [] = {
    {"mknod", gotcha_mknod_wrapper, &wrappee_mknod_handle},
    {"mknodat", gotcha_mknodat_wrapper, &wrappee_mknodat_handle},
};

int mknod_mknodat_gotcha_init(int priority) {
    printf("mknod-mknodat gotcha wrapper initializing with priority = %d\n", priority);
    enum gotcha_error_t result;
    result = gotcha_set_priority("mknod-mknodat", priority);
    if (result != GOTCHA_SUCCESS) {
      printf("Error: mknod-mknodat gotcha_set_priority returned %d\n", (int) result);
      return -1;
    } 
    result = gotcha_wrap(mknod_mknodat_wrap_actions, sizeof(mknod_mknodat_wrap_actions)/sizeof(struct gotcha_binding_t), "mknod-mknodat");
    if (result != GOTCHA_SUCCESS) {
        fprintf(stderr, "Error: mknod-mknodat gotcha_wrap() returned %d\n", (int) result);
        if (result == GOTCHA_FUNCTION_NOT_FOUND) {
            /* one or more functions were not found */
            void* fn;
            gotcha_wrappee_handle_t* hdlptr;
            for (int i = 0; i < 2; i++) {
                hdlptr = mknod_mknodat_wrap_actions[i].function_handle;
                fn = gotcha_get_wrappee(*hdlptr);
                if (NULL == fn) {
                    fprintf(stderr, "Error: mknod-mknodat gotcha wrapper failed to wrap function '%s'\n",
                            mknod_mknodat_wrap_actions[i].name);
                }
            }
            return -1;
        }
    }
    return 0;
}

int gotcha_mknod_wrapper(const char *pathname, mode_t mode, dev_t dev) {
    printf("In mknod gotcha wrapper\n");
    //sleep(1);
    typeof(&gotcha_mknod_wrapper) __real_mknod = gotcha_get_wrappee(wrappee_mknod_handle);
    return __real_mknod(pathname, mode, dev);
}

int gotcha_mknodat_wrapper(int dirfd, const char *pathname, mode_t mode, dev_t dev) {
    printf("In mknodat gotcha wrapper\n");
    //sleep(1);
    typeof(&gotcha_mknodat_wrapper) __real_mknodat = gotcha_get_wrappee(wrappee_mknodat_handle);
    return __real_mknodat(dirfd, pathname, mode, dev);
}

