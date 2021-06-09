CC=gcc
CFLAGES=
MPICC=mpicc
GOTCHA_LIB=/g/g92/xu23/apps/GOTCHA-1.0.3/lib64
GOTCHA_INCLUDE=/g/g92/xu23/apps/GOTCHA-1.0.3/include

all: gotcha-multiple-fopen-fread-main gotcha-mpi-main \
	 dlsym-fopen-fread-wrapper dlsym-fopen-fread-main \
	 dlsym-mpi-wrapper dlsym-mpi-main

gotcha-multiple-fopen-fread-main: gotcha-multiple-fopen-fread-main.c gotcha-multiple-fopen-wrapper.c gotcha-multiple-fread-wrapper.c
	$(CC) $(CFLAGS) -o $@ $^ -L$(GOTCHA_LIB) -lgotcha -I$(GOTCHA_INCLUDE)

gotcha-mpi-main: gotcha-mpi-main.c gotcha-mpi-wrapper.c
	$(MPICC) $(CFLAGS) -o $@ $^ -L$(GOTCHA_LIB) -lgotcha -I$(GOTCHA_INCLUDE)

dlsym-fopen-fread-wrapper: dlsym-fopen-fread-wrapper.c
	$(CC) $(CFLAGS) -o $@.o -c $^ -D_GNU_SOURCE

dlsym-fopen-fread-main: dlsym-fopen-fread-main.c dlsym-fopen-fread-wrapper.o
	$(CC) $(CFLAGS) -o $@ $^ -ldl

dlsym-mpi-wrapper: dlsym-mpi-wrapper.c
	$(CC) $(CFLAGS) -o $@.o -c $^ -D_GNU_SOURCE

dlsym-fopen-fread-main: dlsym-mpi-main.c dlsym-mpi-wrapper.o
	$(MPICC) $(CFLAGS) -o $@ $^ -ldl

clean:
	rm -f gotcha-multiple-fopen-fread-main gotcha-mpi-main \
	dlsym-fopen-fread-main dlsym-mpi-main *.o
