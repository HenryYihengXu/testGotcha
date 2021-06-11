#include "gotcha/gotcha_types.h"
#include "gotcha/gotcha.h"
#include <unistd.h>
#include <stdio.h>
#include <sys/stat.h>

static gotcha_wrappee_handle_t wrappee_mknod_handle;
static gotcha_wrappee_handle_t wrappee_mknodat_handle;
int gotcha_mknod_wrapper(int *argc, char ***argv);
int gotcha_mknodat_wrapper(void);
struct gotcha_binding_t MPI_wrap_actions [] = {
    {"mknod", gotcha_mknod_wrapper, &wrappee_mknod_handle},
    {"mknodat", gotcha_mknodat_wrapper, &wrappee_mknodat_handle},
};

int mknod_mknodat_gotcha_init() {
    enum gotcha_error_t result; 
    result = gotcha_wrap(MPI_wrap_actions, sizeof(MPI_wrap_actions)/sizeof(struct gotcha_binding_t), "MPI");
    if (result != GOTCHA_SUCCESS) {
      fprintf(stderr, "gotcha_wrap returned %d\n", (int) result);
      return -1;
    }
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

