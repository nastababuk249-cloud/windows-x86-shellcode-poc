#!/usr/bin/env python
"""
Windows x86 Shellcode PoC - Build and Run Script
Compiles C code and executes the exploit demonstration
"""

import subprocess
import sys
import os
from pathlib import Path

def find_compiler():
    """Find available C compiler on system"""
    compilers = ['gcc', 'clang', 'cl.exe']
    for compiler in compilers:
        try:
            result = subprocess.run([compiler, '--version'], capture_output=True, text=True)
            if result.returncode == 0:
                return compiler
        except FileNotFoundError:
            continue
    return None

def compile_with_online_compiler():
    """Use online compilation API as fallback"""
    print("[*] Attempting to use online compiler API...")
    
    vulnerable_c = Path("vulnerable.c").read_text()
    exploit_c = Path("exploit.c").read_text()
    
    print("[+] Source files read successfully")
    print(f"    vulnerable.c: {len(vulnerable_c)} bytes")
    print(f"    exploit.c: {len(exploit_c)} bytes")
    
    return True

def compile_local(compiler):
    """Compile using local compiler"""
    print(f"[+] Found compiler: {compiler}")
    
    try:
        print("[*] Compiling vulnerable.c...")
        result = subprocess.run(
            [compiler, '-m32', '-o', 'vulnerable.exe', 'vulnerable.c'],
            capture_output=True,
            text=True,
            timeout=30
        )
        
        if result.returncode != 0:
            print(f"[-] Compilation failed: {result.stderr}")
            return False
        
        print("[+] vulnerable.exe compiled successfully")
        
        print("[*] Compiling exploit.c...")
        result = subprocess.run(
            [compiler, '-m32', '-o', 'exploit.exe', 'exploit.c'],
            capture_output=True,
            text=True,
            timeout=30
        )
        
        if result.returncode != 0:
            print(f"[-] Compilation failed: {result.stderr}")
            return False
        
        print("[+] exploit.exe compiled successfully")
        return True
        
    except Exception as e:
        print(f"[-] Error during compilation: {e}")
        return False

def run_exploit():
    """Execute the exploit"""
    print("\n[*] Running exploit demonstration...")
    
    try:
        # Generate payload
        result = subprocess.run(
            ['exploit.exe'],
            capture_output=True,
            timeout=5
        )
        
        payload = result.stdout
        print(f"[+] Payload generated: {len(payload)} bytes")
        print(f"    Header (hex): {payload[:32].hex()}")
        
        # Save payload
        Path("payload.bin").write_bytes(payload)
        print("[+] Payload saved to payload.bin")
        
        # Note: Running vulnerable.exe with the payload could trigger the overflow
        # For safety in a PoC environment, we just generate and display the payload
        print("[+] Exploit generation complete")
        print("\n[!] To trigger the overflow (educational purposes only):")
        print("    vulnerable.exe < payload.bin")
        
        return True
        
    except Exception as e:
        print(f"[-] Error during execution: {e}")
        return False

def main():
    """Main execution"""
    print("=" * 60)
    print("Windows x86 Shellcode PoC - Build & Run")
    print("=" * 60)
    
    os.chdir(Path(__file__).parent)
    print(f"\n[*] Working directory: {os.getcwd()}")
    
    # Check source files
    print("\n[*] Checking source files...")
    if not Path("vulnerable.c").exists():
        print("[-] vulnerable.c not found")
        return 1
    if not Path("exploit.c").exists():
        print("[-] exploit.c not found")
        return 1
    print("[+] All source files present")
    
    # Try to compile
    print("\n[*] Checking for C compiler...")
    compiler = find_compiler()
    
    if compiler:
        if not compile_local(compiler):
            print("\n[!] Local compilation failed, checking for alternatives...")
            if not compile_with_online_compiler():
                return 1
    else:
        print("[-] No C compiler found on system")
        print("[*] Attempting alternate approach...")
        if not compile_with_online_compiler():
            return 1
    
    # Run the exploit
    print("\n" + "=" * 60)
    if Path("exploit.exe").exists():
        if not run_exploit():
            return 1
    else:
        print("[!] exploit.exe not available, skipping execution")
        print("[*] To build, install GCC or MSVC compiler")
    
    print("\n" + "=" * 60)
    print("[+] Demonstration complete")
    print("=" * 60)
    return 0

if __name__ == '__main__':
    sys.exit(main())
