# Requirements

## System Requirements
- Windows (32-bit or 64-bit with 32-bit support)
- GCC with 32-bit support (`gcc -m32`)
- Minimal C runtime libraries

## Tools Required

### For Building
- **GCC** (MinGW or WSL): GNU C Compiler with 32-bit cross-compilation support
- **Make**: Build automation tool (included with MinGW or available separately)

### For Assembly (Optional)
- **NASM**: Netwide Assembler, if you want to assemble the `.asm` files separately
- **MASM**: Microsoft Macro Assembler (for native Windows assembly)

### For Debugging/Analysis
- **x64dbg** or **WinDbg**: Windows debugger for analyzing the exploit
- **Ollydbg**: Classic x86 debugger for studying shellcode
- **IDA Free**: Disassembler for reverse engineering
- **Ghidra**: Free reverse engineering suite

## Installation (Windows/MinGW)

### 1. Install MinGW with 32-bit Support
```bash
# Using chocolatey (if installed on Windows)
choco install mingw -y

# Or download from: https://www.mingw-w64.org/
```

### 2. Verify Installation
```bash
gcc --version
gcc -m32 --version  # Should support 32-bit
make --version
```

### 3. Install Make (if not included)
```bash
choco install make -y
# Or download: https://www.gnu.org/software/make/
```

## Environment Setup

### Windows PATH
Ensure your MinGW `bin` directory is in your system PATH:
```
C:\Program Files\mingw-w64\x86_64-w64-mingw32\bin
```

### Test Build
Run the Makefile to test your environment:
```bash
make clean
make all
make test
```

All `.exe` files should be generated without errors.
