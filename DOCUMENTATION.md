никитос
# Complete Documentation

## Project Overview
This is an educational Windows x86 buffer overflow proof-of-concept designed to teach stack-based exploitation.

## File Structure
```
windows-x86-shellcode-poc/
├── vulnerable.c          # Target program with vulnerability
├── exploit.c             # Payload generator
├── messageBox.asm        # Assembly shellcode
├── Makefile              # Build configuration
├── README.md             # Quick start and concept explanation
├── REQUIREMENTS.md       # System and tool requirements
├── BUILD.md              # Detailed build instructions
├── LEARNING_PATH.md      # Educational progression
├── DOCUMENTATION.md      # This file
├── LICENSE               # MIT License
├── .gitignore            # Git ignore rules
├── images/               # Reference diagrams and images
└── .github/
    └── workflows/
        └── build.yml     # CI/CD pipeline
```

## Component Details

### vulnerable.c
**Purpose**: Educational target demonstrating unsafe input handling

**Key Code**:
```c
char buffer[128];
fgets(buffer, sizeof(buffer), stdin);  // Currently safe for demo
```

**Vulnerability**: In a real scenario, this would use `gets()` which has no bounds checking.

**Built as**: `vulnerable.exe` (32-bit executable)

### exploit.c
**Purpose**: Generate shellcode payload with padding

**Components**:
1. NOP sled (padding) - 100 bytes of 0x90 instructions
2. Shellcode payload bytes - encoded x86 instructions
3. Binary output to stdout - redirectable to file or pipe

**Key Instructions**:
- `push` - Push values onto stack
- `mov` - Move data to registers
- `call` - Call functions at hardcoded addresses
- Exit via `ExitProcess`

**Built as**: `exploit.exe` (32-bit executable)

**Output**: Binary payload suitable for overflow attack

### messageBox.asm
**Purpose**: Assembly source for potential Windows API calls

**Calls**:
1. `LoadLibraryA` - Load USER32.DLL
2. `MessageBoxA` - Display message box
3. `ExitProcess` - Clean shutdown

**Hardcoded Addresses**:
- MessageBoxA: 0x751D8830 (example, system-specific)
- ExitProcess: 0x7437ADB0 (example, system-specific)
- LoadLibraryA: 0x00743785 (example, system-specific)

**Note**: These addresses vary per Windows version and machine

## Building

### Requirements
- GCC with 32-bit support (`-m32` flag)
- GNU Make
- Windows 7 SP1 or later (for 32-bit executable support)

### Build Process
```bash
make all      # Compile both executables
make test     # Generate payload and pipe to vulnerable program
make clean    # Remove build artifacts
```

## Security Notes

**Educational Purpose Only**
This project is designed for learning exploitation concepts. 

**Real-World Differences**:
- Modern Windows has ASLR (Address Space Layout Randomization)
- DEP/NX bit prevents execution from data sections
- Stack canaries detect buffer overflows
- Control Flow Guard (CFG) validates function pointers

**Ethical Use**:
- Only use on systems you own or have explicit permission to test
- Never use against systems without authorization
- This is for educational cybersecurity training only

## Testing

### Manual Test
```bash
exploit.exe > payload.bin
vulnerable.exe < payload.bin
```

### Makefile Test
```bash
make test
```

### With Debugging
```bash
# Generate payload
exploit.exe > payload.bin

# Load in debugger
x64dbg vulnerable.exe

# Single-step through or set breakpoints
# Watch stack changes during input processing
```

## Customization

### Change the Shellcode
Edit `messageBox.asm`:
- Modify message text
- Change function calls
- Update hardcoded addresses

### Adjust Payload Size
Edit `exploit.c`:
- Change `sizeof(padding)` to vary NOP sled length
- Modify `payload[]` bytes for different shellcode

### Build Flags
Edit `Makefile`:
- Add `-Wall -Wextra` for more compiler warnings
- Add `-g` for debug symbols
- Add `-O2` for optimizations

## Troubleshooting

### Build Fails
1. Check gcc supports 32-bit: `gcc -m32 --version`
2. Install 32-bit development tools
3. Verify Make is in PATH: `make --version`

### Executable Won't Run
1. 32-bit programs need 32-bit runtime
2. Check Windows version compatibility
3. Verify antivirus doesn't block execution

### Address Resolution Issues
1. Hardcoded addresses are system-specific
2. Use debugger to find correct addresses
3. May differ between Windows versions

## Learning Resources

**In This Project**:
- README.md - Vulnerability explanation
- LEARNING_PATH.md - Educational progression
- Code comments - Inline explanations

**External Resources**:
- "Smashing the Stack for Fun and Profit" - Classic paper
- OWASP Buffer Overflow prevention
- x86 assembly language tutorials
- GDB/x64dbg debugging guides
- Windows internals documentation

## Contributing

This is an educational project. Improvements welcome:
- Better comments and documentation
- Additional shellcode examples
- Defense mechanisms documentation
- Cross-platform variants

## Disclaimer

This software is provided for educational and authorized security testing purposes only. Unauthorized access to computer systems is illegal. The authors disclaim all liability for misuse.
