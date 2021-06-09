#include "gotcha/gotcha_types.h"
#include "gotcha/gotcha.h"
#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdarg.h>
#include <mpi.h>

static gotcha_wrappee_handle_t wrappee_MPI_Init_handle;
static gotcha_wrappee_handle_t wrappee_MPI_Finalize_handle;
int gotcha_MPI_Init_wrapper(int *argc, char ***argv);
int gotcha_MPI_Finalize_wrapper(void);
struct gotcha_binding_t MPI_wrap_actions [] = {
    {"MPI_Init", gotcha_MPI_Init_wrapper, &wrappee_MPI_Init_handle},
    {"MPI_Finalize", gotcha_MPI_Finalize_wrapper, &wrappee_MPI_Finalize_handle},
};

int mpi_gotcha_init() {
    enum gotcha_error_t result; 
    result = gotcha_wrap(MPI_wrap_actions, sizeof(MPI_wrap_actions)/sizeof(struct gotcha_binding_t), "MPI");
    if (result != GOTCHA_SUCCESS) {
      fprintf(stderr, "gotcha_wrap returned %d\n", (int) result);
      return -1;
    }
}

int gotcha_MPI_Init_wrapper(int *argc, char ***argv) {
    printf("In MPI_Init gotcha wrapper\n");
    //sleep(1);
    typeof(&gotcha_MPI_Init_wrapper) __real_MPI_Init = gotcha_get_wrappee(wrappee_MPI_Init_handle);
    return __real_MPI_Init(argc, argv);
}

int gotcha_MPI_Finalize_wrapper(void) {
    printf("In MPI_Finalize gotcha wrapper\n");
    //sleep(1);
    typeof(&gotcha_MPI_Finalize_wrapper) __real_MPI_Finalize = gotcha_get_wrappee(wrappee_MPI_Finalize_handle);
    return __real_MPI_Finalize();
}

