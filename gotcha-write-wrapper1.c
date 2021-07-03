#include "gotcha/gotcha_types.h"
#include "gotcha/gotcha.h"
#include <unistd.h>
#include <stdio.h>
#include <string.h>
#include <stdarg.h>
#include <stdlib.h>
#include <sys/shm.h>
#include <errno.h>

static gotcha_wrappee_handle_t wrappee_write_handle;
static ssize_t gotcha_write_wrapper(int fd, const void *buf, size_t count);
struct gotcha_binding_t write_wrap_actions [] = {
    {"write", gotcha_write_wrapper, &wrappee_write_handle}
};
int shm_id;
void *shm_addr;

int write1_init(int priority) {
    gotcha_set_priority("wrapper1", priority);

    enum gotcha_error_t result; 
    result = gotcha_wrap(write_wrap_actions, sizeof(write_wrap_actions)/sizeof(struct gotcha_binding_t), "wrapper1");
    if (result != GOTCHA_SUCCESS) {
      fprintf(stderr, "gotcha_wrap returned %d\n", (int) result);
      return -1;
    }
}

static ssize_t gotcha_write_wrapper(int fd, const void *buf, size_t count) {
    printf("In write gotcha wrapper 1\n");
    //sleep(1);
    typeof(&gotcha_write_wrapper) __real_write = gotcha_get_wrappee(wrappee_write_handle);
    return __real_write(fd, buf, count);
}

#ifdef WITH_INIT_FINI
static void init(void) __attribute__((constructor));
static void fini(void) __attribute__((destructor));

static void init(void)
{
    struct shmid_ds *shmctl_struct = (struct shmid_ds*) malloc(sizeof(struct shmid_ds));
    shm_id = shmget(1, getpagesize(), IPC_CREAT | 0777);
    if (shm_id == -1) {
        fprintf(stderr, "shmget failed %d\n", errno);
        return;
    }
    shm_addr = shmat(shm_id, 0, 0);
    if (shm_addr == -1) {
        fprintf(stderr, "shmat failed %d\n", errno);
        return;
    }
    int res = shmctl(shm_id, IPC_STAT, shmctl_struct);
    if (res == -1) {
        fprintf(stderr, "shmctl failed %d\n", errno);
        return;
    }
    if (shmctl_struct->shm_nattch <= 1) {
        fprintf(stderr, "write gotcha wrapper 1 initializing\n");
        write1_init(PRIORITY);
    } else {
        fprintf(stderr, "write gotcha wrapper 1 already initialized\n");
    }
}

static void fini(void)
{
    int res = shmdt(shm_addr);
    if (res == -1) {
        fprintf(stderr, "shmdt failed %d\n", errno);
        return;
    }
}
#endif
