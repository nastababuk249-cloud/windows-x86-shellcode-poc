# Learning Path: Windows x86 Buffer Overflow

## Module 1: Understanding Memory Layout
**Concepts**: Stack, EBP, EIP, buffer, padding
**Files**: `README.md` (first section)
**Exercise**: Draw a stack diagram for `vulnerable.c`

## Module 2: The Vulnerability
**Concepts**: Buffer overflow, unsafe functions, input validation
**Files**: `vulnerable.c`, `README.md`
**Exercise**: Change buffer size in vulnerable.c and analyze overflow window

## Module 3: Shellcode Basics
**Concepts**: Machine code, registers, function calls, x86 assembly
**Files**: `messageBox.asm`, `exploit.c`
**Exercise**: Modify the message text in messageBox.asm

## Module 4: Payload Generation
**Concepts**: Padding, NOP sled, byte arrays, binary output
**Files**: `exploit.c`
**Exercise**: Adjust padding size and observe binary output size

## Module 5: Integration
**Concepts**: Payload delivery, exploitation chain, testing
**Files**: `Makefile`
**Exercise**: Create a test script that varies overflow sizes

## Module 6: Defenses
**Concepts**: ASLR, DEP/NX, stack canaries, SMEP
**Exercise**: Research and document modern protections

---

## Key Concepts Map

```
Memory Layout ──→ Vulnerability ──→ Shellcode ──→ Payload ──→ Exploit
   (Module 1)      (Module 2)       (Module 3)   (Module 4)  (Module 5)
                                                                    ↓
                                                            Defenses (Module 6)
```

## Hands-On Exercises

### 1. Modify the Shellcode
Edit `messageBox.asm`:
- Change message text from "CAN I HACK THE PC?" to something else
- Recompile and observe binary changes

### 2. Adjust Padding
Edit `exploit.c`:
- Change `memset(padding, 0x90, sizeof(padding))` size
- Generate new payload and compare sizes

### 3. Analyze Binary Output
```bash
make test
hexdump -C payload.bin | head -20
```

### 4. Debug with x64dbg
- Load `vulnerable.exe` in x64dbg
- Follow the stack during payload execution
- Set breakpoints at return address

### 5. Defense Research
- Document how ASLR would break this exploit
- Research stack canaries and how they prevent this
- Study DEP/NX bit protection

---

## Resources for Further Learning

### Windows Security
- Microsoft's security learning path
- x64dbg documentation and tutorials
- Reverse engineering resources (IDA, Ghidra)

### x86 Assembly
- Intel x86 instruction reference
- "Smashing the Stack for Fun and Profit" (classic paper)
- YouTube: x86 assembly tutorials

### Exploit Development
- OWASP buffer overflow resources
- CWE-120: Buffer Copy without Checking Size of Input
- MITRE ATT&CK: Exploitation for Privilege Escalation
