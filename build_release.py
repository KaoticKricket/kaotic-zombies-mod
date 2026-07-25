#!/usr/bin/env python3
"""
Local build script for creating Windows installer
Run this locally to build the installer without GitHub Actions
"""

import subprocess
import sys
import os
from pathlib import Path

def check_inno_setup():
    """Check if Inno Setup is installed"""
    try:
        result = subprocess.run(['iscc', '/?'], capture_output=True, text=True)
        return result.returncode == 0
    except FileNotFoundError:
        return False

def build_installer():
    """Build the Windows installer"""
    print("Building Kaotic Zombies Mod Installer...")
    
    if not check_inno_setup():
        print("ERROR: Inno Setup (ISCC.exe) not found in PATH")
        print("Download from: https://jrsoftware.org/isdl.php")
        return False
    
    # Run Inno Setup compiler
    try:
        result = subprocess.run(['iscc', 'installer.iss'], check=True)
        print("Installer built successfully!")
        print(f"Output: Output/KaoticZombiesMod-Setup.exe")
        return True
    except subprocess.CalledProcessError as e:
        print(f"ERROR: Build failed with code {e.returncode}")
        return False

def main():
    if len(sys.argv) > 1 and sys.argv[1] == '--help':
        print("Usage: python build_release.py")
        print("Builds the Windows installer using Inno Setup")
        print("Requires Inno Setup to be installed and in PATH")
        return
    
    success = build_installer()
    sys.exit(0 if success else 1)

if __name__ == "__main__":
    main()
