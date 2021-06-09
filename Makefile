CC=gcc
CFLAGES=

all: multiple-fopen-fread-main

multiple-fopen-fread-main: multiple-fopen-fread-main.c multiple-fopen-wrapper.c multiple-fread-wrapper.c
	$(CC) $(CFLAGS) -o $@ $^
