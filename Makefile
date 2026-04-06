# Makefile for Windows x86 Shellcode POC

CC = gcc
CFLAGS = -m32  # Compile for 32-bit x86

all: vulnerable.exe exploit.exe

vulnerable.exe: vulnerable.c
	$(CC) $(CFLAGS) -o vulnerable.exe vulnerable.c

exploit.exe: exploit.c
	$(CC) $(CFLAGS) -o exploit.exe exploit.c

clean:
	del vulnerable.exe exploit.exe

test: all
	exploit.exe > payload.bin
	vulnerable.exe < payload.bin

.PHONY: all clean test