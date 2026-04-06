# Building the Project

## Quick Start

```bash
# Build all executables
make all

# Run the test (exploit > payload, then vulnerable < payload)
make test

# Clean build artifacts
make clean
```

## What Gets Built

### 1. `vulnerable.exe`
- Source: `vulnerable.c`
- Purpose: A program with intentional vulnerabilities
- Note: Currently uses `fgets()` which is safe (for educational purposes)

### 2. `exploit.exe`
- Source: `exploit.c`
- Purpose: Generates a shellcode payload with padding
- Output: Binary payload that can be fed to vulnerable program

## Build Steps Explained

### Manual Compilation (without Makefile)
```bash
# Compile vulnerable program (32-bit)
gcc -m32 -o vulnerable.exe vulnerable.c

# Compile exploit generator (32-bit)
gcc -m32 -o exploit.exe exploit.c

# Generate payload
exploit.exe > payload.bin

# Test the payload (in real exploit, this would trigger overflow)
vulnerable.exe < payload.bin
```

## Compiler Flags

- `-m32`: Compile for 32-bit x86 architecture
- `-o <name>`: Output file name
- `-Wall`: Show all warnings (recommended)
- `-g`: Include debug symbols (for debugging with debugger)
- `-O2`: Optimization level 2

## Troubleshooting

### Error: "gcc -m32 not supported" 
- Install 32-bit development libraries
- On MinGW: ensure 32-bit tools are installed
- On WSL/Linux: install gcc-multilib

### Error: "make not found"
- Install GNU Make
- Windows: download from https://www.gnu.org/software/make/
- Or use: `choco install make -y`

### Cannot read from file during test
- Ensure `exploit.exe` exists: `make all` first
- Check payload generation: `exploit.exe > payload.bin`
- Verify file permissions

## Advanced Building

### With Debug Symbols
```make
gcc -m32 -g -o vulnerable.exe vulnerable.c
```

### With Extra Warnings
```make
gcc -m32 -Wall -Wextra -o exploit.exe exploit.c
```

### For 64-bit Windows (running 32-bit executable)
- Just use `-m32` flag, same as above
- .exe will be 32-bit but run on 64-bit Windows
