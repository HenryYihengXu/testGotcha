#include "gotcha/gotcha_types.h"
#include "gotcha/gotcha.h"
#include <unistd.h>
#include <stdio.h>
#include <string.h>
#include <stdarg.h>
#include <stdlib.h>
#include <errno.h>
#include <assert.h>

static gotcha_wrappee_handle_t wrappee_write_handle;
static ssize_t gotcha_write_wrapper(int fd, const void *buf, size_t count);
struct gotcha_binding_t write_wrap_actions [] = {
    {"write", gotcha_write_wrapper, &wrappee_write_handle}
};

#ifdef SHMEM
#include <sys/shm.h>
int shm_id;
void *shm_addr;
#elif SINGLETON
#include <pthread.h>
typedef struct Singleton {
    char sharedData[256];
    int counter;    
} Singleton_t;
 
static Singleton_t *singleton = NULL;
static pthread_mutex_t lock = PTHREAD_MUTEX_INITIALIZER;

Singleton_t *getInstance(){
    pthread_mutex_lock(&lock);
    if(singleton != NULL) {
        singleton->counter++;
        fprintf(stderr, "pid [%d]: singleton already initialized. singleton->counter = %d, the address of the counter is %p", 
            getpid(), singleton->couner, &(singleton->counter));
        pthread_mutex_unlock(&lock);
        return singleton;
    } else {
        singleton = (Singleton_t *)malloc(sizeof(Singleton_t));
        singleton->counter = 1;
        assert(singleton != NULL);
        fprintf(stderr, "pid [%d]: singleton initializing. singleton->counter = %d, the address of the counter is %p", 
            getpid(), singleton->couner, &(singleton->counter));
        pthread_mutex_unlock(&lock);
        return singleton;
    }
}
#endif

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
    fprintf(stderr, "In write gotcha wrapper 1\n");
    //sleep(1);
    typeof(&gotcha_write_wrapper) __real_write = gotcha_get_wrappee(wrappee_write_handle);
    return __real_write(fd, buf, count);
}

#ifdef WITH_INIT_FINI
static void init(void) __attribute__((constructor));
static void fini(void) __attribute__((destructor));

static void init(void)
{
    #ifdef SHMEM
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
    fprintf(stderr, "pid [%d] ", getpid());
    if (shmctl_struct->shm_nattch < 1) {
        fprintf(stderr, "write gotcha wrapper 1 initializing\n");
        write1_init(PRIORITY);
    } else {
        fprintf(stderr, "write gotcha wrapper 1 already initialized\n");
    }
    #elif SINGLETON
    Singleton_t *initialized = getInstance();
    if (initialized->counter == 1) {
        write1_init(PRIORITY);
        fprintf(stderr, "write gotcha wrapper 1 initializing\n");
    } else {
        fprintf(stderr, "write gotcha wrapper 1 already initialized\n");
    }
    #else
    write1_init(PRIORITY);
    fprintf(stderr, "write gotcha wrapper 1 initializing\n");
    #endif /* SHMEM */
}

static void fini(void)
{
    #ifdef SHMEM
    int res = shmdt(shm_addr);
    if (res == -1) {
        fprintf(stderr, "shmdt failed %d\n", errno);
        return;
    }
    #else /* SHMEM */
    fprintf(stderr, "write gotcha wrapper 1 finalizing\n");
    #endif /* SHMEM */
}
#endif
