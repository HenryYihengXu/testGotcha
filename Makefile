CC=gcc
CFLAGES=
MPICC=mpicc
GOTCHA_LIB=/g/g92/xu23/apps/GOTCHA-1.0.3/lib64
GOTCHA_INCLUDE=/g/g92/xu23/apps/GOTCHA-1.0.3/include

all: gotcha-multiple-fopen-fread-main gotcha-mpi-main

gotcha-multiple-fopen-fread-main: gotcha-multiple-fopen-fread-main.c gotcha-multiple-fopen-wrapper.c gotcha-multiple-fread-wrapper.c
	$(CC) $(CFLAGS) -o $@ $^ -L$(GOTCHA_LIB) -lgotcha -I$(GOTCHA_INCLUDE)

gotcha-mpi-main: gotcha-mpi-main.c gotcha-mpi-wrapper.c
	$(MPICC) $(CFLAGS) -o $@ $^ -L$(GOTCHA_LIB) -lgotcha -I$(GOTCHA_INCLUDE)

dlsym-fopen-fread-wrapper: dlsym-fopen-fread-wrapper.c
	$(CC) $(CFLAGS) -o $@ $^

clean:
	rm -f gotcha-multiple-fopen-fread-main gotcha-mpi-main
