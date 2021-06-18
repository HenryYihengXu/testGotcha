#include "gotcha/gotcha_types.h"
#include "gotcha/gotcha.h"
#include <unistd.h>
#include <stdio.h>
#include <sys/stat.h>
#include <errno.h>

static gotcha_wrappee_handle_t wrappee___xmknod_handle;
static gotcha_wrappee_handle_t wrappee___xmknodat_handle;
int gotcha___xmknod_wrapper(int ver, const char * path, mode_t mode, dev_t * dev);
int gotcha___xmknodat_wrapper(int ver, int dirfd, const char * path, mode_t mode, dev_t * dev);
struct gotcha_binding_t __xmknod___xmknodat_wrap_actions [] = {
    {"__xmknod", gotcha___xmknod_wrapper, &wrappee___xmknod_handle},
    {"__xmknodat", gotcha___xmknodat_wrapper, &wrappee___xmknodat_handle},
};

int __xmknod___xmknodat_gotcha_init() {
    enum gotcha_error_t result; 
    result = gotcha_wrap(__xmknod___xmknodat_wrap_actions, sizeof(__xmknod___xmknodat_wrap_actions)/sizeof(struct gotcha_binding_t), "MPI");
    if (result != GOTCHA_SUCCESS) {
        fprintf(stderr, "gotcha_wrap() returned %d\n", (int) result);
        if (result == GOTCHA_FUNCTION_NOT_FOUND) {
            /* one or more functions were not found */
            void* fn;
            gotcha_wrappee_handle_t* hdlptr;
            for (int i = 0; i < 2; i++) {
                hdlptr = __xmknod___xmknodat_wrap_actions[i].function_handle;
                fn = gotcha_get_wrappee(*hdlptr);
                if (NULL == fn) {
                    fprintf(stderr, "Gotcha failed to wrap function '%s'\n",
                            __xmknod___xmknodat_wrap_actions[i].name);
                }
            }
            return -1;
        }
    }
}

int gotcha___xmknod_wrapper(int ver, const char * path, mode_t mode, dev_t * dev) {
    printf("In __xmknod gotcha wrapper\n");
    //sleep(1);
    typeof(&gotcha___xmknod_wrapper) __real___xmknod = gotcha_get_wrappee(wrappee___xmknod_handle);
    return __real___xmknod(ver, path, mode, dev);
}

int gotcha___xmknodat_wrapper(int ver, int dirfd, const char * path, mode_t mode, dev_t * dev) {
    printf("In __xmknodat gotcha wrapper\n");
    //sleep(1);
    typeof(&gotcha___xmknodat_wrapper) __real___xmknodat = gotcha_get_wrappee(wrappee___xmknodat_handle);
    return __real___xmknodat(ver, dirfd, path, mode, dev);
}

