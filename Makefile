CC=gcc
CFLAGES=
GOTCHA_LIB=/g/g92/xu23/apps/GOTCHA-1.0.3/lib64
GOTCHA_INCLUDE=/g/g92/xu23/apps/GOTCHA-1.0.3/include

all: multiple-fopen-fread-main

multiple-fopen-fread-main: multiple-fopen-fread-main.c multiple-fopen-wrapper.c multiple-fread-wrapper.c
	$(CC) $(CFLAGS) -o $@ $^ -L$(GOTCHA_LIB) -lgotcha -I$(GOTCHA_INCLUDE)
