CC=gcc
CFLAGS=-I./include
MPICC=mpicc
GOTCHA_LIB=/g/g92/xu23/apps/GOTCHA-1.0.3/lib64
GOTCHA_INCLUDE=/g/g92/xu23/apps/GOTCHA-1.0.3/include
MPI_LIB=/usr/tce/packages/spectrum-mpi/ibm/spectrum-mpi-rolling-release/lib
MPI_INCLUDE=/usr/tce/packages/spectrum-mpi/ibm/spectrum-mpi-rolling-release/include

all: gotcha-multiple-fopen-fread-main gotcha-mpi-main \
	 dlsym-fopen-fread-wrapper dlsym-fopen-fread-main \
	 dlsym-mpi-wrapper dlsym-mpi-main \
	 dlsym-fopen-fread-main-using-so dlsym-mpi-main-using-so \
	 gotcha-mknod-mknodat-main gotcha-__xmknod-__xmknodat-main \
	 dlsym-fopen-wrapper1 dlsym-fopen-wrapper2 dlsym-fread-wrapper \
	 fopen-fread-main-no-links dlsym-fopen-wrapper1-with-init-fini \
	 dlsym-fopen-wrapper2-with-init-fini gotcha-mpi-wrapper \
	 gotcha-mpi-wrapper-with-init-fini mpi-main-no-links \
	 dlsym-mpi-wrapper-with-init-fini gotcha-multiple-fopen-wrapper \
	 gotcha-multiple-fread-wrapper gotcha-multiple-fopen-wrapper-with-init-fini \
	 gotcha-multiple-fread-wrapper-with-init-fini

gotcha-multiple-fopen-fread-main: ./src/gotcha-multiple-fopen-fread-main.c ./src/gotcha-multiple-fopen-wrapper.c ./src/gotcha-multiple-fread-wrapper.c
	mkdir bin
	$(CC) $(CFLAGS) -o ./bin/$@ $^ -L$(GOTCHA_LIB) -lgotcha -I$(GOTCHA_INCLUDE)

gotcha-multiple-fopen-wrapper: ./src/gotcha-multiple-fopen-wrapper.c
	$(CC) $(CFLAGS) -o ./bin/$@.o -c $^ -L$(GOTCHA_LIB) -lgotcha -I$(GOTCHA_INCLUDE)
	$(CC) $(CFLAGS) -shared -o ./bin/lib$@.so ./bin/$@.o -fPIC

gotcha-multiple-fread-wrapper: ./src/gotcha-multiple-fread-wrapper.c
	$(CC) $(CFLAGS) -o ./bin/$@.o -c $^ -L$(GOTCHA_LIB) -lgotcha -I$(GOTCHA_INCLUDE)
	$(CC) $(CFLAGS) -shared -o ./bin/lib$@.so ./bin/$@.o -fPIC

gotcha-multiple-fopen-wrapper-with-init-fini: ./src/gotcha-multiple-fopen-wrapper.c
	$(CC) $(CFLAGS) -shared -o ./bin/lib$@.so $^ -DWITH_INIT_FINI -L$(GOTCHA_LIB) -lgotcha -I$(GOTCHA_INCLUDE) -fPIC

gotcha-multiple-fread-wrapper-with-init-fini: ./src/gotcha-multiple-fread-wrapper.c
	$(CC) $(CFLAGS) -shared -o ./bin/lib$@.so $^ -DWITH_INIT_FINI -L$(GOTCHA_LIB) -lgotcha -I$(GOTCHA_INCLUDE) -fPIC

gotcha-mpi-main: ./src/gotcha-mpi-main.c ./src/gotcha-mpi-wrapper.c
	$(MPICC) $(CFLAGS) -o ./bin/$@ $^ -L$(GOTCHA_LIB) -lgotcha -I$(GOTCHA_INCLUDE)

gotcha-mpi-wrapper: ./src/gotcha-mpi-wrapper.c
	$(MPICC) $(CFLAGS) -o ./bin/$@.o -c $^ -L$(GOTCHA_LIB) -lgotcha -I$(GOTCHA_INCLUDE)
	$(MPICC) $(CFLAGS) -shared -o ./bin/lib$@.so ./bin/$@.o -fPIC

gotcha-mpi-wrapper-with-init-fini: ./src/gotcha-mpi-wrapper.c
	$(MPICC) $(CFLAGS) -shared -o ./bin/lib$@.so $^ -DWITH_INIT_FINI -L$(GOTCHA_LIB) -lgotcha -I$(GOTCHA_INCLUDE) -fPIC

dlsym-fopen-fread-wrapper: ./src/dlsym-fopen-fread-wrapper.c
	$(CC) $(CFLAGS) -o ./bin/$@.o -c $^
	$(CC) $(CFLAGS) -shared -o ./bin/lib$@.so ./bin/$@.o -fPIC

dlsym-fopen-wrapper1: ./src/dlsym-fopen-wrapper1.c
	$(CC) $(CFLAGS) -o ./bin/$@.o -c $^
	$(CC) $(CFLAGS) -shared -o ./bin/lib$@.so ./bin/$@.o -fPIC

dlsym-fopen-wrapper1-with-init-fini: ./src/dlsym-fopen-wrapper1.c
#	$(CC) $(CFLAGS) -o $@.o -c $^
	$(CC) $(CFLAGS) -shared -o ./bin/lib$@.so $^ -DWITH_INIT_FINI -fPIC

dlsym-fopen-wrapper2: ./src/dlsym-fopen-wrapper2.c
	$(CC) $(CFLAGS) -o ./bin/$@.o -c $^
	$(CC) $(CFLAGS) -shared -o ./bin/lib$@.so ./bin/$@.o -fPIC

dlsym-fopen-wrapper2-with-init-fini: ./src/dlsym-fopen-wrapper2.c
#	$(CC) $(CFLAGS) -o $@.o -c $^
	$(CC) $(CFLAGS) -shared -o ./bin/lib$@.so $^ -DWITH_INIT_FINI -fPIC

dlsym-fread-wrapper: ./src/dlsym-fread-wrapper.c
	$(CC) $(CFLAGS) -o ./bin/$@.o -c $^
	$(CC) $(CFLAGS) -shared -o ./bin/lib$@.so ./bin/$@.o -fPIC

dlsym-fopen-fread-main: ./src/fopen-fread-main.c ./src/dlsym-fopen-fread-wrapper.o
	$(CC) $(CFLAGS) -o ./bin/$@ $^ -ldl

dlsym-fopen-fread-main-using-so: ./src/fopen-fread-main.c
	$(CC) $(CFLAGS) -o ./bin/$@ $^ -L/g/g92/xu23/summer-2021/testGotcha -ldlsym-fopen-fread-wrapper -ldl

fopen-fread-main-no-links: ./src/fopen-fread-main.c
	$(CC) $(CFLAGS) -o ./bin/$@ $^

dlsym-mpi-wrapper: ./src/dlsym-mpi-wrapper.c
	$(MPICC) $(CFLAGS) -o ./bin/$@.o -c $^
	$(CC) $(CFLAGS) -shared -o ./bin/lib$@.so ./bin/$@.o -fPIC

dlsym-mpi-wrapper-with-init-fini: ./src/dlsym-mpi-wrapper.c
	$(MPICC) $(CFLAGS) -shared -o ./bin/lib$@.so $^ -DWITH_INIT_FINI -fPIC

dlsym-mpi-main: ./src/mpi-main.c ./src/dlsym-mpi-wrapper.o
	$(MPICC) $(CFLAGS) -o ./bin/$@ $^ -ldl

dlsym-mpi-main-using-so: ./src/mpi-main.c
	$(MPICC) $(CFLAGS) -o ./bin/$@ $^ -L/g/g92/xu23/summer-2021/testGotcha -ldlsym-mpi-wrapper -ldl

mpi-main-no-links: ./src/mpi-main.c
	$(MPICC) $(CFLAGS) -o ./bin/$@ $^

gotcha-mknod-mknodat-main: ./src/gotcha-mknod-mknodat-main.c ./src/gotcha-mknod-mknodat-wrapper.c
	$(CC) $(CFLAGS) -o ./bin/$@ $^ -L$(GOTCHA_LIB) -lgotcha -I$(GOTCHA_INCLUDE)

gotcha-__xmknod-__xmknodat-main: ./src/gotcha-__xmknod-__xmknodat-main.c ./src/gotcha-__xmknod-__xmknodat-wrapper.c
	$(CC) $(CFLAGS) -o ./bin/$@ $^ -L$(GOTCHA_LIB) -lgotcha -I$(GOTCHA_INCLUDE)

clean:
	rm -rf ./bin*
