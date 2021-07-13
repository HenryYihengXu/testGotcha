#define _GNU_SOURCE
#include <unistd.h>
#include <stdio.h>
#include <string.h>
#include <stdarg.h>
#include <stdlib.h>
#include <dlfcn.h>
#include <mpi.h>

int main(int argc, char *argv[]) {
    MPI_Init(&argc, &argv);
    int rank, np;
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &np);
    printf("This is rank [%d] in total %d ranks\n", rank, np);
    FILE *f;
    f = fopen("./a.txt", "w");
    char* write_buf = "aaaaaaaaa\n";
    fwrite(write_buf, sizeof(char), 10, f);
    char read_buf[1024];
    fread(read_buf, 1024, 1, f);
    write_buf = "bbbbbbbbb\n";
    fwrite(write_buf, sizeof(char), 10, f);
    MPI_Finalize();
    return 0;
}
