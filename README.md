# Windows x86 Buffer Overflow PoC for Beginners

This is a simple, self-contained tutorial on stack-based buffer overflow exploits for 32-bit Windows.
No external guides required—everything you need is here.

## What is this repository?
- `vulnerable.c`: A simple program with an unsafe `gets()` function.
- `messageBox.asm`: A small assembly payload that would execute after the overflow.
- `exploit.c`: An example of how the overflow might be triggered.

This project teaches one core idea: unsafe input reading can let an attacker overwrite the return address and redirect execution.

## The Vulnerability: `gets()` has no size limit

In `vulnerable.c`, the program does this:

```c
char buffer[32];
gets(buffer);
```

The program reserves 32 bytes for `buffer`, then calls `gets()` to read input.
The problem: `gets()` does not check the buffer size.
It keeps reading characters until it encounters a newline.
If the user types 40 or 50 characters, the extra characters overflow past the 32-byte buffer.

## The Stack Memory Layout

The stack stores local variables stacked on top of each other. After the buffer, there's the return address—the address where the CPU should jump back to when the function ends.

```
[  buffer (32 bytes)  ]
[  return address (4 bytes)  ]  ← This is what we overwrite
```

When `gets()` reads more than 32 bytes, the extra bytes overflow past the buffer and overwrite the return address. If we put a specific address there, the CPU will jump to it when the function returns.

## How the exploit works

1. The program allocates `buffer[32]` on the stack.
2. It calls `gets(buffer)` to read user input.
3. We send more than 32 bytes (e.g., 50 bytes).
4. `gets()` has no size check, so it writes all 50 bytes into the buffer.
5. The extra 18 bytes overflow and overwrite the return address.
6. We construct the overflow so the return address points to shellcode on the stack.
7. When the function returns, the CPU jumps to the shellcode.
8. The shellcode runs and displays a message box.

This is how arbitrary code execution happens through a buffer overflow.

## What happens in the shellcode: The payload

`messageBox.asm` is a small piece of code designed to run after the overflow. It:

1. Loads `USER32.DLL` (the Windows library for message boxes).
2. Calls `MessageBoxA` to display a message box with "CAN I HACK THE PC?".
3. Calls `ExitProcess` to safely exit the program.

When the message box appears, it proves:
1. The buffer overflow worked and rewrote the return address.
2. Execution jumped to the shellcode on the stack.
3. Arbitrary code ran successfully.

In a real attack, this payload could do anything: steal data, create a user, download malware, etc. The message box is just a safe way to demonstrate code execution.

**Note:** This payload uses hardcoded memory addresses (`MessageBoxA` at 0x751D8830, `ExitProcess` at 0x7437ADB0). These are specific to one Windows system. Different Windows versions have different addresses.

## How to build and run

### Step 1: Compile vulnerable.c
On Windows with MSVC, disable security protections:

```batch
cl /GS- /c vulnerable.c
link /DYNAMICBASE:NO /NXCOMPAT:NO vulnerable.obj /OUT:vulnerable.exe
```

These flags disable stack canaries (`/GS-`), ASLR (`/DYNAMICBASE:NO`), and DEP (`/NXCOMPAT:NO`). Modern Windows prevents this exploit, so we disable those protections for this learning exercise.

### Step 2: Compile exploit.c
```batch
cl /GS- /c exploit.c
link /DYNAMICBASE:NO /NXCOMPAT:NO exploit.obj /OUT:exploit.exe
```

### Step 3: Run the exploit
Pipe the output of `exploit.exe` into `vulnerable.exe`:

```batch
exploit.exe | vulnerable.exe
```

If successful, a message box will appear with "CAN I HACK THE PC?" on screen. This proves the overflow worked and executed the shellcode.

## Important safety notice
This example is for learning only.
Do not use this technique against systems you do not own or have explicit permission to test.
Unauthorized access to computer systems is illegal.
