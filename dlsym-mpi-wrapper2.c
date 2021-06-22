#define _GNU_SOURCE
#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <dlfcn.h>
#include <stdarg.h>
#include <mpi.h>

int MPI_Init(int *argc, char ***argv) {
    printf("In MPI_Init dlsym wrapper 2\n");
    //sleep(1);
    typeof(&MPI_Init) __real_MPI_Init = dlsym(RTLD_NEXT, "MPI_Init");
    return __real_MPI_Init(argc, argv);
}

int MPI_Finalize(void) {
    printf("In MPI_Finalize dlsym wrapper 2\n");
    //sleep(1);
    typeof(&MPI_Finalize) __real_MPI_Finalize = dlsym(RTLD_NEXT, "MPI_Finalize");
    return __real_MPI_Finalize();
}

#ifdef WITH_INIT_FINI
static void init(void) __attribute__((constructor));
static void fini(void) __attribute__((destructor));

static void init(void)
{
    printf("mpi dlsym wrapper 2 initializing\n");
}

static void fini(void)
{
    printf("mpi dlsym wrapper 2 finalizing\n");
}
#endif
