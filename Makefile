CC=gcc
CFLAGES=
MPICC=mpicc
GOTCHA_LIB=/g/g92/xu23/installs/gotcha-quartz/lib64
GOTCHA_INCLUDE=/g/g92/xu23/installs/gotcha-quartz/include
MPI_LIB=/usr/tce/packages/spectrum-mpi/ibm/spectrum-mpi-rolling-release/lib
MPI_INCLUDE=/usr/tce/packages/spectrum-mpi/ibm/spectrum-mpi-rolling-release/include

all: fopen-fread-main-no-links \
	mpi-main-no-links \
	dlsym-fopen-wrapper1 \
	dlsym-fopen-wrapper2 \
	dlsym-fopen-wrapper1-with-init-fini \
	dlsym-fopen-wrapper2-with-init-fini \
	dlsym-fread-wrapper \
	dlsym-fopen-fread-wrapper \
	dlsym-fopen-fread-main \
	dlsym-fopen-fread-main-using-so \
	\
	dlsym-mpi-wrapper \
	dlsym-mpi-wrapper-with-init-fini \
	dlsym-mpi-main \
	dlsym-mpi-main-using-so \
	\
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

# ========================= dlsym fopen fread =======================

dlsym-fopen-wrapper1: dlsym-fopen-wrapper1.c
	$(CC) $(CFLAGS) -o $@.o -c $^ -fPIC
	$(CC) $(CFLAGS) -shared -o lib$@.so $@.o

dlsym-fopen-wrapper2: dlsym-fopen-wrapper2.c
	$(CC) $(CFLAGS) -o $@.o -c $^ -fPIC
	$(CC) $(CFLAGS) -shared -o lib$@.so $@.o

dlsym-fopen-wrapper1-with-init-fini: dlsym-fopen-wrapper1.c
#	$(CC) $(CFLAGS) -o $@.o -c $^
	$(CC) $(CFLAGS) -shared -o lib$@.so $^ -DWITH_INIT_FINI -fPIC

dlsym-fopen-wrapper2-with-init-fini: dlsym-fopen-wrapper2.c
#	$(CC) $(CFLAGS) -o $@.o -c $^
	$(CC) $(CFLAGS) -shared -o lib$@.so $^ -DWITH_INIT_FINI -fPIC

dlsym-fread-wrapper: dlsym-fread-wrapper.c
	$(CC) $(CFLAGS) -o $@.o -c $^ -fPIC
	$(CC) $(CFLAGS) -shared -o lib$@.so $@.o

dlsym-fopen-fread-wrapper: dlsym-fopen-fread-wrapper.c
	$(CC) $(CFLAGS) -o $@.o -c $^ -fPIC
	$(CC) $(CFLAGS) -shared -o lib$@.so $@.o

dlsym-fopen-fread-main: fopen-fread-main.c dlsym-fopen-fread-wrapper.o
	$(CC) $(CFLAGS) -o $@ $^ -ldl

dlsym-fopen-fread-main-using-so: fopen-fread-main.c
	$(CC) $(CFLAGS) -o $@ $^ -L/g/g92/xu23/summer-2021/testGotcha -ldlsym-fopen-fread-wrapper -ldl

# ========================= dlsym mpi =======================

dlsym-mpi-wrapper: dlsym-mpi-wrapper.c
	$(MPICC) $(CFLAGS) -o $@.o -c $^ -fPIC
	$(CC) $(CFLAGS) -shared -o lib$@.so $@.o

dlsym-mpi-wrapper-with-init-fini: dlsym-mpi-wrapper.c
	$(MPICC) $(CFLAGS) -shared -o lib$@.so $^ -DWITH_INIT_FINI -fPIC

dlsym-mpi-main: mpi-main.c dlsym-mpi-wrapper.o
	$(MPICC) $(CFLAGS) -o $@ $^

dlsym-mpi-main-using-so: mpi-main.c
	$(MPICC) $(CFLAGS) -o $@ $^ -L/g/g92/xu23/summer-2021/testGotcha -ldlsym-mpi-wrapper

# ========================= gotcha fopen fread =======================

gotcha-multiple-fopen-wrapper: gotcha-multiple-fopen-wrapper.c
	$(CC) $(CFLAGS) -o $@.o -c $^ -L$(GOTCHA_LIB) -lgotcha -I$(GOTCHA_INCLUDE) -fPIC
	$(CC) $(CFLAGS) -shared -o lib$@.so $@.o

gotcha-multiple-fread-wrapper: gotcha-multiple-fread-wrapper.c
	$(CC) $(CFLAGS) -o $@.o -c $^ -L$(GOTCHA_LIB) -lgotcha -I$(GOTCHA_INCLUDE) -fPIC
	$(CC) $(CFLAGS) -shared -o lib$@.so $@.o

gotcha-multiple-fopen-wrapper-with-init-fini: gotcha-multiple-fopen-wrapper.c
	$(CC) $(CFLAGS) -shared -o lib$@.so $^ -DWITH_INIT_FINI \
	-L$(GOTCHA_LIB) -lgotcha -I$(GOTCHA_INCLUDE) -fPIC

gotcha-multiple-fread-wrapper-with-init-fini: gotcha-multiple-fread-wrapper.c
	$(CC) $(CFLAGS) -shared -o lib$@.so $^ -DWITH_INIT_FINI \
	-L$(GOTCHA_LIB) -lgotcha -I$(GOTCHA_INCLUDE) -fPIC

gotcha-multiple-fopen-fread-main: gotcha-multiple-fopen-fread-main.c gotcha-multiple-fopen-wrapper.c gotcha-multiple-fread-wrapper.c
	$(CC) $(CFLAGS) -o $@ $^ -L$(GOTCHA_LIB) -lgotcha -I$(GOTCHA_INCLUDE)

# ========================= gotcha mpi =======================

gotcha-mpi-wrapper: gotcha-mpi-wrapper.c
	$(MPICC) $(CFLAGS) -o $@.o -c $^ -L$(GOTCHA_LIB) -lgotcha -I$(GOTCHA_INCLUDE) -fPIC
	$(MPICC) $(CFLAGS) -shared -o lib$@.so $@.o

gotcha-mpi-wrapper-with-init-fini: gotcha-mpi-wrapper.c
	$(MPICC) $(CFLAGS) -shared -o lib$@.so $^ -DWITH_INIT_FINI \
	-L$(GOTCHA_LIB) -lgotcha -I$(GOTCHA_INCLUDE) -fPIC

gotcha-mpi-main: gotcha-mpi-main.c gotcha-mpi-wrapper.c
	$(MPICC) $(CFLAGS) -o $@ $^ -L$(GOTCHA_LIB) -lgotcha -I$(GOTCHA_INCLUDE)

# ========================= others =======================

gotcha-mknod-mknodat-main: gotcha-mknod-mknodat-main.c gotcha-mknod-mknodat-wrapper.c
	$(CC) $(CFLAGS) -o $@ $^ -L$(GOTCHA_LIB) -lgotcha -I$(GOTCHA_INCLUDE)

gotcha-__xmknod-__xmknodat-main: gotcha-__xmknod-__xmknodat-main.c gotcha-__xmknod-__xmknodat-wrapper.c
	$(CC) $(CFLAGS) -o $@ $^ -L$(GOTCHA_LIB) -lgotcha -I$(GOTCHA_INCLUDE)

clean:
	rm -f gotcha-multiple-fopen-fread-main gotcha-mpi-main \
	dlsym-fopen-fread-wrapper dlsym-fopen-fread-main \
	dlsym-mpi-wrapper dlsym-mpi-main \
	dlsym-fopen-fread-main-using-so dlsym-mpi-main-using-so \
	gotcha-mknod-mknodat-main gotcha-__xmknod-__xmknodat-main \
	fopen-fread-main-no-links dlsym-fopen-wrapper1 dlsym-fopen-wrapper2 \
	dlsym-fread-wrapper \
	*.so *.o
