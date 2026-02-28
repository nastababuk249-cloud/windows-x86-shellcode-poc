# Windows x86 Shellcode & Buffer Overflow PoC

A technical Proof of Concept (PoC) demonstrating a stack-based buffer overflow and custom x86 shellcode injection on Windows. This project was developed in March 2017 as part of low-level programming and security research.

## ⚠️ Overview
This repository serves as a legacy archive. It demonstrates how unsafe memory handling in C (specifically the `gets()` function) can be exploited to hijack program control flow and execute arbitrary code.

## 🛠 Methodology & Exploit Chain
The exploitation process followed a structured four-stage "exploit chain":

1. **Vulnerability Identification:** Analyzed a target binary to locate the buffer overflow vulnerability in the `gets()` function. Calculated the exact offset required to overwrite the Instruction Pointer (EIP).
2. **Environment Analysis:** Used a custom helper utility to resolve absolute memory addresses for critical Windows API functions (such as `LoadLibraryA` and `MessageBoxA`) within the target system's memory space.
3. **Payload Construction:** Authored custom x86 Assembly shellcode (`messageBox.asm`). The assembly was then manually translated into hexadecimal opcodes for injection.
4. **Execution:** Implemented the final exploit in C (`exploit.c`). The payload was delivered via character injection, carefully bypassing null-byte string termination constraints to ensure successful execution on the stack.



## 💻 Tech Stack
- **Languages:** C, x86 Assembly (Intel syntax)
- **Environment:** Windows x86 (Legacy architecture research)
- **Tools:** Custom address resolvers, Debuggers

## 📝 Project Components
- `exploit.c`: The final delivery mechanism for the shellcode.
- `messageBox.asm`: The original assembly source for the payload.

---
*Disclaimer: This project is for educational and historical purposes only. It demonstrates legacy vulnerabilities that are mitigated in modern environments by ASLR, DEP, and stack canaries.*
