#include <stdio.h>
#include <mpi.h>

int main(int argc, char *argv[]) {
    MPI_Init(&argc, &argv);
    // int rank, np;
    // MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    // MPI_Comm_size(MPI_COMM_WORLD, &np);
    // printf("This is rank [%d] in total %d ranks\n", rank, np);
    printf("Hello World!\n");
    MPI_Finalize();
    return 0;
}
