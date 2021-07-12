CC=gcc
CFLAGES=
MPICC=mpicc
GOTCHA_LIB=/g/g92/xu23/apps/GOTCHA-1.0.3/lib64
GOTCHA_INCLUDE=/g/g92/xu23/apps/GOTCHA-1.0.3/include
MPI_LIB=/usr/tce/packages/spectrum-mpi/ibm/spectrum-mpi-rolling-release/lib
MPI_INCLUDE=/usr/tce/packages/spectrum-mpi/ibm/spectrum-mpi-rolling-release/include

all: fopen-fread-main-no-links \
	mpi-main-no-links \
	append-no-links \
	write-append-no-links \
	write-append-mix-no-links \
	\
	dlsym-fopen-wrapper1 \
	dlsym-fopen-wrapper2 \
	dlsym-fopen-wrapper1-with-init-fini \
	dlsym-fopen-wrapper2-with-init-fini \
	dlsym-fread-wrapper \
	dlsym-fread-wrapper-with-init-fini \
	dlsym-fopen-fread-wrapper \
	dlsym-fwrite-wrapper1 \
	dlsym-fwrite-wrapper2 \
	dlsym-fwrite-wrapper1-with-init-fini \
	dlsym-fwrite-wrapper2-with-init-fini \
	dlsym-write-wrapper1 \
	dlsym-write-wrapper2 \
	dlsym-write-wrapper1-with-init-fini \
	dlsym-write-wrapper2-with-init-fini \
	dlsym-fopen-fread-main \
	dlsym-fopen-fread-main-using-so \
	dlsym-write-append-main \
	\
	dlsym-mpi-wrapper1 \
	dlsym-mpi-wrapper1-with-init-fini \
	dlsym-mpi-wrapper2 \
	dlsym-mpi-wrapper2-with-init-fini \
	dlsym-mpi-main \
	dlsym-mpi-main-using-so \
	\
	gotcha-fopen-wrapper1 \
	gotcha-fopen-wrapper2 \
	gotcha-fopen-wrapper1-with-init-fini \
	gotcha-fopen-wrapper2-with-init-fini \
	gotcha-fwrite-wrapper1 \
	gotcha-fwrite-wrapper2 \
	gotcha-fwrite-wrapper1-with-init-fini \
	gotcha-fwrite-wrapper2-with-init-fini \
	gotcha-write-wrapper1 \
	gotcha-write-wrapper2 \
	gotcha-write-wrapper1-with-init-fini \
	gotcha-write-wrapper2-with-init-fini \
	gotcha-multiple-fopen-wrapper \
	gotcha-multiple-fread-wrapper \
	gotcha-multiple-fopen-wrapper-with-init-fini \
	gotcha-multiple-fread-wrapper-with-init-fini \
	gotcha-multiple-fopen-fread-main \
	\
	gotcha-mpi-wrapper \
	gotcha-mpi-wrapper-with-init-fini \
	gotcha-mpi-main \
	\
	gotcha-mknod-mknodat-main \
	gotcha-__xmknod-__xmknodat-main

fopen-fread-main-no-links: fopen-fread-main.c
	$(CC) $(CFLAGS) -o $@ $^

mpi-main-no-links: mpi-main.c
	$(MPICC) $(CFLAGS) -o $@ $^

append-no-links: append-main.c
	$(CC) $(CFLAGS) -o $@ $^

write-append-no-links: write-append-main.c
	$(CC) $(CFLAGS) -o $@ $^

write-append-mix-no-links: write-append-mix-main.c gotcha-write-wrapper2.c
	$(CC) $(CFLAGS) -o $@ $^ -L$(GOTCHA_LIB) -lgotcha -I$(GOTCHA_INCLUDE)

# ========================= dlsym fopen fread =======================

dlsym-fopen-wrapper1: dlsym-fopen-wrapper1.c
	$(CC) $(CFLAGS) -o $@.o -c $^
	$(CC) $(CFLAGS) -shared -o lib$@.so $@.o -ldl

dlsym-fopen-wrapper2: dlsym-fopen-wrapper2.c
	$(CC) $(CFLAGS) -o $@.o -c $^
	$(CC) $(CFLAGS) -shared -o lib$@.so $@.o -ldl

dlsym-fopen-wrapper1-with-init-fini: dlsym-fopen-wrapper1.c
#	$(CC) $(CFLAGS) -o $@.o -c $^
	$(CC) $(CFLAGS) -shared -o lib$@.so $^ -DWITH_INIT_FINI -ldl

dlsym-fopen-wrapper2-with-init-fini: dlsym-fopen-wrapper2.c
#	$(CC) $(CFLAGS) -o $@.o -c $^
	$(CC) $(CFLAGS) -shared -o lib$@.so $^ -DWITH_INIT_FINI -ldl

dlsym-fread-wrapper: dlsym-fread-wrapper.c
	$(CC) $(CFLAGS) -o $@.o -c $^
	$(CC) $(CFLAGS) -shared -o lib$@.so $@.o -ldl

dlsym-fread-wrapper-with-init-fini: dlsym-fread-wrapper.c
#	$(CC) $(CFLAGS) -o $@.o -c $^
	$(CC) $(CFLAGS) -shared -o lib$@.so $^ -DWITH_INIT_FINI -ldl

dlsym-fopen-fread-wrapper: dlsym-fopen-fread-wrapper.c
	$(CC) $(CFLAGS) -o $@.o -c $^
	$(CC) $(CFLAGS) -shared -o lib$@.so $@.o -ldl

dlsym-fwrite-wrapper1: dlsym-fwrite-wrapper1.c
	$(CC) $(CFLAGS) -o $@.o -c $^
	$(CC) $(CFLAGS) -shared -o lib$@.so $@.o -ldl

dlsym-fwrite-wrapper2: dlsym-fwrite-wrapper2.c
	$(CC) $(CFLAGS) -o $@.o -c $^
	$(CC) $(CFLAGS) -shared -o lib$@.so $@.o -ldl

dlsym-fwrite-wrapper1-with-init-fini: dlsym-fwrite-wrapper1.c
#	$(CC) $(CFLAGS) -o $@.o -c $^
	$(CC) $(CFLAGS) -shared -o lib$@.so $^ -DWITH_INIT_FINI -ldl

dlsym-fwrite-wrapper2-with-init-fini: dlsym-fwrite-wrapper2.c
#	$(CC) $(CFLAGS) -o $@.o -c $^
	$(CC) $(CFLAGS) -shared -o lib$@.so $^ -DWITH_INIT_FINI -ldl

dlsym-write-wrapper1: dlsym-write-wrapper1.c
	$(CC) $(CFLAGS) -o $@.o -c $^
	$(CC) $(CFLAGS) -shared -o lib$@.so $@.o -ldl

dlsym-write-wrapper2: dlsym-write-wrapper2.c
	$(CC) $(CFLAGS) -o $@.o -c $^
	$(CC) $(CFLAGS) -shared -o lib$@.so $@.o -ldl

dlsym-write-wrapper1-with-init-fini: dlsym-write-wrapper1.c
#	$(CC) $(CFLAGS) -o $@.o -c $^
	$(CC) $(CFLAGS) -shared -o lib$@.so $^ -DWITH_INIT_FINI -ldl

dlsym-write-wrapper2-with-init-fini: dlsym-write-wrapper2.c
#	$(CC) $(CFLAGS) -o $@.o -c $^
	$(CC) $(CFLAGS) -shared -o lib$@.so $^ -DWITH_INIT_FINI -ldl

dlsym-fopen-fread-main: fopen-fread-main.c dlsym-fopen-fread-wrapper.o
	$(CC) $(CFLAGS) -o $@ $^ -ldl

dlsym-fopen-fread-main-using-so: fopen-fread-main.c
	$(CC) $(CFLAGS) -o $@ $^ -L/g/g92/xu23/summer-2021/testGotcha -ldlsym-fopen-fread-wrapper -ldl

dlsym-write-append-main: write-append-main.c dlsym-write-wrapper1.o
	$(CC) $(CFLAGS) -o $@ $^ -ldl

# ========================= dlsym mpi =======================

dlsym-mpi-wrapper1: dlsym-mpi-wrapper1.c
	$(MPICC) $(CFLAGS) -o $@.o -c $^
	$(CC) $(CFLAGS) -shared -o lib$@.so $@.o -ldl

dlsym-mpi-wrapper2: dlsym-mpi-wrapper2.c
	$(MPICC) $(CFLAGS) -o $@.o -c $^
	$(CC) $(CFLAGS) -shared -o lib$@.so $@.o -ldl

dlsym-mpi-wrapper1-with-init-fini: dlsym-mpi-wrapper1.c
	$(MPICC) $(CFLAGS) -shared -o lib$@.so $^ -DWITH_INIT_FINI -ldl

dlsym-mpi-wrapper2-with-init-fini: dlsym-mpi-wrapper2.c
	$(MPICC) $(CFLAGS) -shared -o lib$@.so $^ -DWITH_INIT_FINI -ldl	

dlsym-mpi-main: mpi-main.c dlsym-mpi-wrapper1.o
	$(MPICC) $(CFLAGS) -o $@ $^ -ldl

dlsym-mpi-main-using-so: mpi-main.c
	$(MPICC) $(CFLAGS) -o $@ $^ -L/g/g92/xu23/summer-2021/testGotcha -ldlsym-mpi-wrapper1 -ldl

# ========================= gotcha fopen fread =======================

gotcha-fopen-wrapper1: gotcha-fopen-wrapper1.c
	$(CC) $(CFLAGS) -o $@.o -c $^ -L$(GOTCHA_LIB) -lgotcha -I$(GOTCHA_INCLUDE)
	$(CC) $(CFLAGS) -shared -o lib$@.so $@.o

gotcha-fopen-wrapper2: gotcha-fopen-wrapper2.c
	$(CC) $(CFLAGS) -o $@.o -c $^ -L$(GOTCHA_LIB) -lgotcha -I$(GOTCHA_INCLUDE)
	$(CC) $(CFLAGS) -shared -o lib$@.so $@.o

gotcha-fopen-wrapper1-with-init-fini: gotcha-fopen-wrapper1.c
	$(CC) $(CFLAGS) -shared -o lib$@.so $^ -DWITH_INIT_FINI -L$(GOTCHA_LIB) -lgotcha -I$(GOTCHA_INCLUDE) -DPRIORITY=1

gotcha-fopen-wrapper2-with-init-fini: gotcha-fopen-wrapper2.c
	$(CC) $(CFLAGS) -shared -o lib$@.so $^ -DWITH_INIT_FINI -L$(GOTCHA_LIB) -lgotcha -I$(GOTCHA_INCLUDE) -DPRIORITY=2

gotcha-fwrite-wrapper1: gotcha-fwrite-wrapper1.c
	$(CC) $(CFLAGS) -o $@.o -c $^ -L$(GOTCHA_LIB) -lgotcha -I$(GOTCHA_INCLUDE)
	$(CC) $(CFLAGS) -shared -o lib$@.so $@.o

gotcha-fwrite-wrapper2: gotcha-fwrite-wrapper2.c
	$(CC) $(CFLAGS) -o $@.o -c $^ -L$(GOTCHA_LIB) -lgotcha -I$(GOTCHA_INCLUDE)
	$(CC) $(CFLAGS) -shared -o lib$@.so $@.o

gotcha-fwrite-wrapper1-with-init-fini: gotcha-fwrite-wrapper1.c
	$(CC) $(CFLAGS) -shared -o lib$@.so $^ -DWITH_INIT_FINI -L$(GOTCHA_LIB) -lgotcha -I$(GOTCHA_INCLUDE) -DPRIORITY=1

gotcha-fwrite-wrapper2-with-init-fini: gotcha-fwrite-wrapper2.c
	$(CC) $(CFLAGS) -shared -o lib$@.so $^ -DWITH_INIT_FINI -L$(GOTCHA_LIB) -lgotcha -I$(GOTCHA_INCLUDE) -DPRIORITY=2

gotcha-write-wrapper1: gotcha-write-wrapper1.c
	$(CC) $(CFLAGS) -o $@.o -c $^ -L$(GOTCHA_LIB) -lgotcha -I$(GOTCHA_INCLUDE)
	$(CC) $(CFLAGS) -shared -o lib$@.so $@.o

gotcha-write-wrapper2: gotcha-write-wrapper2.c
	$(CC) $(CFLAGS) -o $@.o -c $^ -L$(GOTCHA_LIB) -lgotcha -I$(GOTCHA_INCLUDE)
	$(CC) $(CFLAGS) -shared -o lib$@.so $@.o

gotcha-write-wrapper1-with-init-fini: gotcha-write-wrapper1.c
	$(CC) $(CFLAGS) -shared -o lib$@.so $^ -DWITH_INIT_FINI -L$(GOTCHA_LIB) -lgotcha -I$(GOTCHA_INCLUDE) -DPRIORITY=1

gotcha-write-wrapper2-with-init-fini: gotcha-write-wrapper2.c
	$(CC) $(CFLAGS) -shared -o lib$@.so $^ -DWITH_INIT_FINI -L$(GOTCHA_LIB) -lgotcha -I$(GOTCHA_INCLUDE) -DPRIORITY=2

gotcha-multiple-fopen-wrapper: gotcha-multiple-fopen-wrapper.c
	$(CC) $(CFLAGS) -o $@.o -c $^ -L$(GOTCHA_LIB) -lgotcha -I$(GOTCHA_INCLUDE)
	$(CC) $(CFLAGS) -shared -o lib$@.so $@.o

gotcha-multiple-fread-wrapper: gotcha-multiple-fread-wrapper.c
	$(CC) $(CFLAGS) -o $@.o -c $^ -L$(GOTCHA_LIB) -lgotcha -I$(GOTCHA_INCLUDE)
	$(CC) $(CFLAGS) -shared -o lib$@.so $@.o

gotcha-multiple-fopen-wrapper-with-init-fini: gotcha-multiple-fopen-wrapper.c
	$(CC) $(CFLAGS) -shared -o lib$@.so $^ -DWITH_INIT_FINI -L$(GOTCHA_LIB) -lgotcha -I$(GOTCHA_INCLUDE)

gotcha-multiple-fread-wrapper-with-init-fini: gotcha-multiple-fread-wrapper.c
	$(CC) $(CFLAGS) -shared -o lib$@.so $^ -DWITH_INIT_FINI -L$(GOTCHA_LIB) -lgotcha -I$(GOTCHA_INCLUDE)

gotcha-multiple-fopen-fread-main: gotcha-multiple-fopen-fread-main.c gotcha-multiple-fopen-wrapper.c gotcha-multiple-fread-wrapper.c
	$(CC) $(CFLAGS) -o $@ $^ -L$(GOTCHA_LIB) -lgotcha -I$(GOTCHA_INCLUDE)

# ========================= gotcha mpi =======================

gotcha-mpi-wrapper: gotcha-mpi-wrapper.c
	$(MPICC) $(CFLAGS) -o $@.o -c $^ -L$(GOTCHA_LIB) -lgotcha -I$(GOTCHA_INCLUDE)
	$(MPICC) $(CFLAGS) -shared -o lib$@.so $@.o

gotcha-mpi-wrapper-with-init-fini: gotcha-mpi-wrapper.c
	$(MPICC) $(CFLAGS) -shared -o lib$@.so $^ -DWITH_INIT_FINI -L$(GOTCHA_LIB) -lgotcha -I$(GOTCHA_INCLUDE)

gotcha-mpi-main: gotcha-mpi-main.c gotcha-mpi-wrapper.c
	$(MPICC) $(CFLAGS) -o $@ $^ -L$(GOTCHA_LIB) -lgotcha -I$(GOTCHA_INCLUDE)

# ========================= others =======================

gotcha-mknod-mknodat-main: gotcha-mknod-mknodat-main.c gotcha-mknod-mknodat-wrapper.c
	$(CC) $(CFLAGS) -o $@ $^ -L$(GOTCHA_LIB) -lgotcha -I$(GOTCHA_INCLUDE)

gotcha-__xmknod-__xmknodat-main: gotcha-__xmknod-__xmknodat-main.c gotcha-__xmknod-__xmknodat-wrapper.c
	$(CC) $(CFLAGS) -o $@ $^ -L$(GOTCHA_LIB) -lgotcha -I$(GOTCHA_INCLUDE)

clean:
	rm -f fopen-fread-main-no-links \
	mpi-main-no-links \
	append-no-links \
	write-append-no-links \
	write-append-mix-no-links \
	\
	dlsym-fopen-wrapper1 \
	dlsym-fopen-wrapper2 \
	dlsym-fopen-wrapper1-with-init-fini \
	dlsym-fopen-wrapper2-with-init-fini \
	dlsym-fread-wrapper \
	dlsym-fread-wrapper-with-init-fini \
	dlsym-fopen-fread-wrapper \
	dlsym-fwrite-wrapper1 \
	dlsym-fwrite-wrapper2 \
	dlsym-fwrite-wrapper1-with-init-fini \
	dlsym-fwrite-wrapper2-with-init-fini \
	dlsym-write-wrapper1 \
	dlsym-write-wrapper2 \
	dlsym-write-wrapper1-with-init-fini \
	dlsym-write-wrapper2-with-init-fini \
	dlsym-fopen-fread-main \
	dlsym-fopen-fread-main-using-so \
	dlsym-write-append-main \
	\
	dlsym-mpi-wrapper1 \
	dlsym-mpi-wrapper1-with-init-fini \
	dlsym-mpi-wrapper2 \
	dlsym-mpi-wrapper2-with-init-fini \
	dlsym-mpi-main \
	dlsym-mpi-main-using-so \
	\
	gotcha-fopen1-wrapper \
	gotcha-fopen2-wrapper \
	gotcha-fopen1-wrapper-with-init-fini \
	gotcha-fopen2-wrapper-with-init-fini \
	gotcha-fwrite-wrapper1 \
	gotcha-fwrite-wrapper2 \
	gotcha-fwrite-wrapper1-with-init-fini \
	gotcha-fwrite-wrapper2-with-init-fini \
	gotcha-write-wrapper1 \
	gotcha-write-wrapper2 \
	gotcha-write-wrapper1-with-init-fini \
	gotcha-write-wrapper2-with-init-fini \
	gotcha-multiple-fopen-wrapper \
	gotcha-multiple-fread-wrapper \
	gotcha-multiple-fopen-wrapper-with-init-fini \
	gotcha-multiple-fread-wrapper-with-init-fini \
	gotcha-multiple-fopen-fread-main \
	\
	gotcha-mpi-wrapper \
	gotcha-mpi-wrapper-with-init-fini \
	gotcha-mpi-main \
	\
	gotcha-mknod-mknodat-main \
	gotcha-__xmknod-__xmknodat-main \
	*.so *.o

