#include "gotcha/gotcha_types.h"
#include "gotcha/gotcha.h"
#include <unistd.h>
#include <stdio.h>
#include <sys/stat.h>
#include <errno.h>

static gotcha_wrappee_handle_t wrappee___x__xmknod_handle;
static gotcha_wrappee_handle_t wrappee___x__xmknodat_handle;
int gotcha___x__xmknod_wrapper(const char *pathname, mode_t mode, dev_t dev);
int gotcha___x__xmknodat_wrapper(int dirfd, const char *pathname, mode_t mode, dev_t dev);
struct gotcha_binding_t __x__xmknod___x__xmknodat_wrap_actions [] = {
    {"__x__xmknod", gotcha___x__xmknod_wrapper, &wrappee___x__xmknod_handle},
    {"__x__xmknodat", gotcha___x__xmknodat_wrapper, &wrappee___x__xmknodat_handle},
};

int __x__xmknod___x__xmknodat_gotcha_init() {
    enum gotcha_error_t result; 
    result = gotcha_wrap(__x__xmknod___x__xmknodat_wrap_actions, sizeof(__x__xmknod___x__xmknodat_wrap_actions)/sizeof(struct gotcha_binding_t), "MPI");
    if (result != GOTCHA_SUCCESS) {
        fprintf(stderr, "gotcha_wrap() returned %d\n", (int) result);
        if (result == GOTCHA_FUNCTION_NOT_FOUND) {
            /* one or more functions were not found */
            void* fn;
            gotcha_wrappee_handle_t* hdlptr;
            for (int i = 0; i < 2; i++) {
                hdlptr = __x__xmknod___x__xmknodat_wrap_actions[i].function_handle;
                fn = gotcha_get_wrappee(*hdlptr);
                if (NULL == fn) {
                    fprintf(stderr, "Gotcha failed to wrap function '%s'\n",
                            __x__xmknod___x__xmknodat_wrap_actions[i].name);
                }
            }
            return -1;
        }
    }
}

int gotcha___xmknod_wrapper(const char *pathname, mode_t mode, dev_t dev) {
    printf("In __xmknod gotcha wrapper\n");
    //sleep(1);
    typeof(&gotcha___xmknod_wrapper) __real___xmknod = gotcha_get_wrappee(wrappee___xmknod_handle);
    return __real___xmknod(pathname, mode, dev);
}

int gotcha___xmknodat_wrapper(int dirfd, const char *pathname, mode_t mode, dev_t dev) {
    printf("In __xmknodat gotcha wrapper\n");
    //sleep(1);
    typeof(&gotcha___xmknodat_wrapper) __real___xmknodat = gotcha_get_wrappee(wrappee___xmknodat_handle);
    return __real___xmknodat(dirfd, pathname, mode, dev);
}

