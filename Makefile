CC=gcc
BUILDDIR=build
CFLAGS=-I${PWD}/env/include -L${PWD}/env/lib -L${PWD}/env/lib64 -fPIC -L${PWD}/${BUILDDIR} -g -O0
MPICC=mpicc
GOTCHA_LIB=${PWD}/env/lib
GOTCHA_INCLUDE=${PWD}/env/include
MPI_LIB=${PWD}/env/lib
MPI_INCLUDE=${PWD}/env/include

all: dir fopen-fread-main-no-links \
	fopen-fread-fwrite-main-no-links \
	fopen-fread-fwrite-main-with-mpi-no-links \
	mpi-main-no-links \
	MPI_File_open-main-no-links \
	append-no-links \
	write-append-no-links \
	write-append-mix \
	\
	dlsym-fopen-wrapper1 \
	dlsym-fopen-wrapper2 \
	dlsym-fopen-wrapper-that-init-gotcha-fwrite-wrapper2 \
	dlsym-fread-wrapper-that-init-gotcha-fwrite-wrapper2 \
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
	gotcha-fread-wrapper1 \
	gotcha-fread-wrapper2 \
	gotcha-fread-wrapper1-with-init-fini \
	gotcha-fread-wrapper2-with-init-fini \
	gotcha-fwrite-wrapper1 \
	gotcha-fwrite-wrapper2 \
	gotcha-fwrite-wrapper1-with-init-fini \
	gotcha-fwrite-wrapper2-with-init-fini \
	gotcha-fread-fwrite-wrapper \
	gotcha-fread-fwrite-wrapper-with-init-fini \
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

dir:
	mkdir -p ${BUILDDIR}

fopen-fread-main-no-links: fopen-fread-main.c
	$(CC) $(CFLAGS) -o ${BUILDDIR}/$@ $^

fopen-fread-fwrite-main-no-links: fopen-fread-fwrite-main.c
	$(CC) $(CFLAGS) -o ${BUILDDIR}/$@ $^

fopen-fread-fwrite-main-with-mpi-no-links: fopen-fread-fwrite-main-with-mpi.c
	$(MPICC) $(CFLAGS) -o ${BUILDDIR}/$@ $^

mpi-main-no-links: mpi-main.c
	$(MPICC) $(CFLAGS) -o ${BUILDDIR}/$@ $^

MPI_File_open-main-no-links: MPI_File_open-main.c
	$(MPICC) $(CFLAGS) -o ${BUILDDIR}/$@ $^

append-no-links: append-main.c
	$(CC) $(CFLAGS) -o ${BUILDDIR}/$@ $^

write-append-no-links: write-append-main.c
	$(CC) $(CFLAGS) -o ${BUILDDIR}/$@ $^

write-append-mix: write-append-mix-main.c gotcha-write-wrapper2.c
	$(CC) $(CFLAGS) -o ${BUILDDIR}/$@ $^ -L$(GOTCHA_LIB) -lgotcha -I$(GOTCHA_INCLUDE)

# ========================= dlsym fopen fread =======================

dlsym-fopen-wrapper1: dlsym-fopen-wrapper1.c
	$(CC) $(CFLAGS) -o ${BUILDDIR}/$@.o -c $^
	$(CC) $(CFLAGS) -shared -o ${BUILDDIR}/lib$@.so ${BUILDDIR}/$@.o -ldl

dlsym-fopen-wrapper2: dlsym-fopen-wrapper2.c
	$(CC) $(CFLAGS) -o ${BUILDDIR}/$@.o -c $^
	$(CC) $(CFLAGS) -shared -o ${BUILDDIR}/lib$@.so ${BUILDDIR}/$@.o -ldl

dlsym-fopen-wrapper-that-init-gotcha-fwrite-wrapper2: dlsym-fopen-wrapper-that-init-gotcha-fwrite-wrapper2.c
	$(MPICC) $(CFLAGS) -o ${BUILDDIR}/$@.o -c $^ -L$(GOTCHA_LIB) -lgotcha -I$(GOTCHA_INCLUDE)
	$(MPICC) $(CFLAGS) -shared -o ${BUILDDIR}/lib$@.so ${BUILDDIR}/$@.o -ldl

dlsym-fread-wrapper-that-init-gotcha-fwrite-wrapper2: dlsym-fread-wrapper-that-init-gotcha-fwrite-wrapper2.c
	$(MPICC) $(CFLAGS) -o ${BUILDDIR}/$@.o -c $^ -L$(GOTCHA_LIB) -lgotcha -I$(GOTCHA_INCLUDE)
	$(MPICC) $(CFLAGS) -shared -o ${BUILDDIR}/lib$@.so ${BUILDDIR}/$@.o -ldl

dlsym-fopen-wrapper1-with-init-fini: dlsym-fopen-wrapper1.c
#	$(CC) $(CFLAGS) -o ${BUILDDIR}/$@.o -c $^
	$(CC) $(CFLAGS) -shared -o ${BUILDDIR}/lib$@.so $^ -DWITH_INIT_FINI -ldl

dlsym-fopen-wrapper2-with-init-fini: dlsym-fopen-wrapper2.c
#	$(CC) $(CFLAGS) -o ${BUILDDIR}/$@.o -c $^
	$(CC) $(CFLAGS) -shared -o ${BUILDDIR}/lib$@.so $^ -DWITH_INIT_FINI -ldl

dlsym-fread-wrapper: dlsym-fread-wrapper.c
	$(CC) $(CFLAGS) -o ${BUILDDIR}/$@.o -c $^
	$(CC) $(CFLAGS) -shared -o ${BUILDDIR}/lib$@.so ${BUILDDIR}/$@.o -ldl

dlsym-fread-wrapper-with-init-fini: dlsym-fread-wrapper.c
#	$(CC) $(CFLAGS) -o ${BUILDDIR}/$@.o -c $^
	$(CC) $(CFLAGS) -shared -o ${BUILDDIR}/lib$@.so $^ -DWITH_INIT_FINI -ldl

dlsym-fopen-fread-wrapper: dlsym-fopen-fread-wrapper.c
	$(CC) $(CFLAGS) -o ${BUILDDIR}/$@.o -c $^
	$(CC) $(CFLAGS) -shared -o ${BUILDDIR}/lib$@.so ${BUILDDIR}/$@.o -ldl

dlsym-fwrite-wrapper1: dlsym-fwrite-wrapper1.c
	$(CC) $(CFLAGS) -o ${BUILDDIR}/$@.o -c $^
	$(CC) $(CFLAGS) -shared -o ${BUILDDIR}/lib$@.so ${BUILDDIR}/$@.o -ldl

dlsym-fwrite-wrapper2: dlsym-fwrite-wrapper2.c
	$(CC) $(CFLAGS) -o ${BUILDDIR}/$@.o -c $^
	$(CC) $(CFLAGS) -shared -o ${BUILDDIR}/lib$@.so ${BUILDDIR}/$@.o -ldl

dlsym-fwrite-wrapper1-with-init-fini: dlsym-fwrite-wrapper1.c
#	$(CC) $(CFLAGS) -o ${BUILDDIR}/$@.o -c $^
	$(CC) $(CFLAGS) -shared -o ${BUILDDIR}/lib$@.so $^ -DWITH_INIT_FINI -ldl

dlsym-fwrite-wrapper2-with-init-fini: dlsym-fwrite-wrapper2.c
#	$(CC) $(CFLAGS) -o ${BUILDDIR}/$@.o -c $^
	$(CC) $(CFLAGS) -shared -o ${BUILDDIR}/lib$@.so $^ -DWITH_INIT_FINI -ldl

dlsym-write-wrapper1: dlsym-write-wrapper1.c
	$(CC) $(CFLAGS) -o ${BUILDDIR}/$@.o -c $^
	$(CC) $(CFLAGS) -shared -o ${BUILDDIR}/lib$@.so ${BUILDDIR}/$@.o -ldl

dlsym-write-wrapper2: dlsym-write-wrapper2.c
	$(CC) $(CFLAGS) -o ${BUILDDIR}/$@.o -c $^
	$(CC) $(CFLAGS) -shared -o ${BUILDDIR}/lib$@.so ${BUILDDIR}/$@.o -ldl

dlsym-write-wrapper1-with-init-fini: dlsym-write-wrapper1.c
#	$(CC) $(CFLAGS) -o ${BUILDDIR}/$@.o -c $^
	$(CC) $(CFLAGS) -shared -o ${BUILDDIR}/lib$@.so $^ -DWITH_INIT_FINI -ldl

dlsym-write-wrapper2-with-init-fini: dlsym-write-wrapper2.c
#	$(CC) $(CFLAGS) -o ${BUILDDIR}/$@.o -c $^
	$(CC) $(CFLAGS) -shared -o ${BUILDDIR}/lib$@.so $^ -DWITH_INIT_FINI -ldl

dlsym-fopen-fread-main: fopen-fread-main.c dlsym-fopen-fread-wrapper.o
	$(CC) $(CFLAGS) -o ${BUILDDIR}/$@ $^ -ldl

dlsym-fopen-fread-main-using-so: fopen-fread-main.c
	$(CC) $(CFLAGS) -o ${BUILDDIR}/$@ $^ -L/g/g92/xu23/summer-2021/testGotcha -ldlsym-fopen-fread-wrapper -ldl

dlsym-write-append-main: write-append-main.c dlsym-write-wrapper1.o
	$(CC) $(CFLAGS) -o ${BUILDDIR}/$@ $^ -ldl

# ========================= dlsym mpi =======================

dlsym-mpi-wrapper1: dlsym-mpi-wrapper1.c
	$(MPICC) $(CFLAGS) -o ${BUILDDIR}/$@.o -c $^
	$(CC) $(CFLAGS) -shared -o ${BUILDDIR}/lib$@.so ${BUILDDIR}/$@.o -ldl

dlsym-mpi-wrapper2: dlsym-mpi-wrapper2.c
	$(MPICC) $(CFLAGS) -o ${BUILDDIR}/$@.o -c $^
	$(CC) $(CFLAGS) -shared -o ${BUILDDIR}/lib$@.so ${BUILDDIR}/$@.o -ldl

dlsym-mpi-wrapper1-with-init-fini: dlsym-mpi-wrapper1.c
	$(MPICC) $(CFLAGS) -shared -o ${BUILDDIR}/lib$@.so $^ -DWITH_INIT_FINI -ldl

dlsym-mpi-wrapper2-with-init-fini: dlsym-mpi-wrapper2.c
	$(MPICC) $(CFLAGS) -shared -o ${BUILDDIR}/lib$@.so $^ -DWITH_INIT_FINI -ldl

dlsym-mpi-main: mpi-main.c ${BUILDDIR}/dlsym-mpi-wrapper1.o
	$(MPICC) $(CFLAGS) -o ${BUILDDIR}/$@ $^ -ldl

dlsym-mpi-main-using-so: mpi-main.c
	$(MPICC) $(CFLAGS) -o ${BUILDDIR}/$@ $^ -L/g/g92/xu23/summer-2021/testGotcha -ldlsym-mpi-wrapper1 -ldl

# ========================= gotcha fopen fread =======================

gotcha-fopen-wrapper1: gotcha-fopen-wrapper1.c
	$(CC) $(CFLAGS) -o ${BUILDDIR}/$@.o -c $^ -L$(GOTCHA_LIB) -lgotcha -I$(GOTCHA_INCLUDE)
	$(CC) $(CFLAGS) -shared -o ${BUILDDIR}/lib$@.so ${BUILDDIR}/$@.o

gotcha-fopen-wrapper2: gotcha-fopen-wrapper2.c
	$(CC) $(CFLAGS) -o ${BUILDDIR}/$@.o -c $^ -L$(GOTCHA_LIB) -lgotcha -I$(GOTCHA_INCLUDE)
	$(CC) $(CFLAGS) -shared -o ${BUILDDIR}/lib$@.so ${BUILDDIR}/$@.o

gotcha-fopen-wrapper1-with-init-fini: gotcha-fopen-wrapper1.c
	$(CC) $(CFLAGS) -shared -o ${BUILDDIR}/lib$@.so $^ -DWITH_INIT_FINI -L$(GOTCHA_LIB) -lgotcha -I$(GOTCHA_INCLUDE) -DPRIORITY=1

gotcha-fopen-wrapper2-with-init-fini: gotcha-fopen-wrapper2.c
	$(CC) $(CFLAGS) -shared -o ${BUILDDIR}/lib$@.so $^ -DWITH_INIT_FINI -L$(GOTCHA_LIB) -lgotcha -I$(GOTCHA_INCLUDE) -DPRIORITY=2

gotcha-fread-wrapper1: gotcha-fread-wrapper1.c
	$(CC) $(CFLAGS) -o ${BUILDDIR}/$@.o -c $^ -L$(GOTCHA_LIB) -lgotcha -I$(GOTCHA_INCLUDE)
	$(CC) $(CFLAGS) -shared -o ${BUILDDIR}/lib$@.so ${BUILDDIR}/$@.o

gotcha-fread-wrapper2: gotcha-fread-wrapper2.c
	$(CC) $(CFLAGS) -o ${BUILDDIR}/$@.o -c $^ -L$(GOTCHA_LIB) -lgotcha -I$(GOTCHA_INCLUDE)
	$(CC) $(CFLAGS) -shared -o ${BUILDDIR}/lib$@.so ${BUILDDIR}/$@.o

gotcha-fread-wrapper1-with-init-fini: gotcha-fread-wrapper1.c
	$(CC) $(CFLAGS) -shared -o ${BUILDDIR}/lib$@.so $^ -DWITH_INIT_FINI -L$(GOTCHA_LIB) -lgotcha -I$(GOTCHA_INCLUDE) -DPRIORITY=1

gotcha-fread-wrapper2-with-init-fini: gotcha-fread-wrapper2.c
	$(CC) $(CFLAGS) -shared -o ${BUILDDIR}/lib$@.so $^ -DWITH_INIT_FINI -L$(GOTCHA_LIB) -lgotcha -I$(GOTCHA_INCLUDE) -DPRIORITY=2

gotcha-fwrite-wrapper1: gotcha-fwrite-wrapper1.c
	$(CC) $(CFLAGS) -o ${BUILDDIR}/$@.o -c $^ -L$(GOTCHA_LIB) -lgotcha -I$(GOTCHA_INCLUDE)
	$(CC) $(CFLAGS) -shared -o ${BUILDDIR}/lib$@.so ${BUILDDIR}/$@.o

gotcha-fwrite-wrapper2: gotcha-fwrite-wrapper2.c
	$(CC) $(CFLAGS) -o ${BUILDDIR}/$@.o -c $^ -L$(GOTCHA_LIB) -lgotcha -I$(GOTCHA_INCLUDE)
	$(CC) $(CFLAGS) -shared -o ${BUILDDIR}/lib$@.so ${BUILDDIR}/$@.o

gotcha-fwrite-wrapper1-with-init-fini: gotcha-fwrite-wrapper1.c
	$(CC) $(CFLAGS) -shared -o ${BUILDDIR}/lib$@.so $^ -DWITH_INIT_FINI -L$(GOTCHA_LIB) -lgotcha -I$(GOTCHA_INCLUDE) -DPRIORITY=3

gotcha-fwrite-wrapper2-with-init-fini: gotcha-fwrite-wrapper2.c
	$(CC) $(CFLAGS) -shared -o ${BUILDDIR}/lib$@.so $^ -DWITH_INIT_FINI -L$(GOTCHA_LIB) -lgotcha -I$(GOTCHA_INCLUDE) -DPRIORITY=2

gotcha-fread-fwrite-wrapper: gotcha-fread-fwrite-wrapper.c
	$(CC) $(CFLAGS) -o ${BUILDDIR}/$@.o -c $^ -L$(GOTCHA_LIB) -lgotcha -I$(GOTCHA_INCLUDE)
	$(CC) $(CFLAGS) -shared -o ${BUILDDIR}/lib$@.so ${BUILDDIR}/$@.o

gotcha-fread-fwrite-wrapper-with-init-fini: gotcha-fread-fwrite-wrapper.c
	$(CC) $(CFLAGS) -shared -o ${BUILDDIR}/lib$@.so $^ -DWITH_INIT_FINI -L$(GOTCHA_LIB) -lgotcha -I$(GOTCHA_INCLUDE) -DPRIORITY=3

gotcha-write-wrapper1: gotcha-write-wrapper1.c
	$(CC) $(CFLAGS) -o ${BUILDDIR}/$@.o -c $^ -L$(GOTCHA_LIB) -lgotcha -I$(GOTCHA_INCLUDE)
	$(CC) $(CFLAGS) -shared -o ${BUILDDIR}/lib$@.so ${BUILDDIR}/$@.o

gotcha-write-wrapper2: gotcha-write-wrapper2.c
	$(CC) $(CFLAGS) -o ${BUILDDIR}/$@.o -c $^ -L$(GOTCHA_LIB) -lgotcha -I$(GOTCHA_INCLUDE)
	$(CC) $(CFLAGS) -shared -o ${BUILDDIR}/lib$@.so ${BUILDDIR}/$@.o

gotcha-write-wrapper1-with-init-fini: gotcha-write-wrapper1.c
	$(CC) $(CFLAGS) -shared -o ${BUILDDIR}/lib$@.so $^ -DWITH_INIT_FINI -L$(GOTCHA_LIB) -lgotcha -I$(GOTCHA_INCLUDE) -DPRIORITY=1

gotcha-write-wrapper2-with-init-fini: gotcha-write-wrapper2.c
	$(CC) $(CFLAGS) -shared -o ${BUILDDIR}/lib$@.so $^ -DWITH_INIT_FINI -L$(GOTCHA_LIB) -lgotcha -I$(GOTCHA_INCLUDE) -DPRIORITY=2

gotcha-multiple-fopen-wrapper: gotcha-multiple-fopen-wrapper.c
	$(CC) $(CFLAGS) -o ${BUILDDIR}/$@.o -c $^ -L$(GOTCHA_LIB) -lgotcha -I$(GOTCHA_INCLUDE)
	$(CC) $(CFLAGS) -shared -o ${BUILDDIR}/lib$@.so ${BUILDDIR}/$@.o

gotcha-multiple-fread-wrapper: gotcha-multiple-fread-wrapper.c
	$(CC) $(CFLAGS) -o ${BUILDDIR}/$@.o -c $^ -L$(GOTCHA_LIB) -lgotcha -I$(GOTCHA_INCLUDE)
	$(CC) $(CFLAGS) -shared -o ${BUILDDIR}/lib$@.so ${BUILDDIR}/$@.o

gotcha-multiple-fopen-wrapper-with-init-fini: gotcha-multiple-fopen-wrapper.c
	$(CC) $(CFLAGS) -shared -o ${BUILDDIR}/lib$@.so $^ -DWITH_INIT_FINI -L$(GOTCHA_LIB) -lgotcha -I$(GOTCHA_INCLUDE)

gotcha-multiple-fread-wrapper-with-init-fini: gotcha-multiple-fread-wrapper.c
	$(CC) $(CFLAGS) -shared -o ${BUILDDIR}/lib$@.so $^ -DWITH_INIT_FINI -L$(GOTCHA_LIB) -lgotcha -I$(GOTCHA_INCLUDE)

gotcha-multiple-fopen-fread-main: gotcha-multiple-fopen-fread-main.c gotcha-multiple-fopen-wrapper.c gotcha-multiple-fread-wrapper.c
	$(CC) $(CFLAGS) -o ${BUILDDIR}/$@ $^ -L$(GOTCHA_LIB) -lgotcha -I$(GOTCHA_INCLUDE)

# ========================= gotcha mpi =======================

gotcha-mpi-wrapper: gotcha-mpi-wrapper.c
	$(MPICC) $(CFLAGS) -o ${BUILDDIR}/$@.o -c $^ -L$(GOTCHA_LIB) -lgotcha -I$(GOTCHA_INCLUDE)
	$(MPICC) $(CFLAGS) -shared -o ${BUILDDIR}/lib$@.so ${BUILDDIR}/$@.o

gotcha-mpi-wrapper-with-init-fini: gotcha-mpi-wrapper.c
	$(MPICC) $(CFLAGS) -shared -o ${BUILDDIR}/lib$@.so $^ -DWITH_INIT_FINI -L$(GOTCHA_LIB) -lgotcha -I$(GOTCHA_INCLUDE) -DPRIORITY=1

gotcha-mpi-main: gotcha-mpi-main.c gotcha-mpi-wrapper.c
	$(MPICC) $(CFLAGS) -o ${BUILDDIR}/$@ $^ -L$(GOTCHA_LIB) -lgotcha -I$(GOTCHA_INCLUDE)

# ========================= others =======================

gotcha-mknod-mknodat-main: gotcha-mknod-mknodat-main.c gotcha-mknod-mknodat-wrapper.c
	$(CC) $(CFLAGS) -o ${BUILDDIR}/$@ $^ -L$(GOTCHA_LIB) -lgotcha -I$(GOTCHA_INCLUDE)

gotcha-__xmknod-__xmknodat-main: gotcha-__xmknod-__xmknodat-main.c gotcha-__xmknod-__xmknodat-wrapper.c
	$(CC) $(CFLAGS) -o ${BUILDDIR}/$@ $^ -L$(GOTCHA_LIB) -lgotcha -I$(GOTCHA_INCLUDE)

clean:
	rm -f ${BUILDDIR}/*

