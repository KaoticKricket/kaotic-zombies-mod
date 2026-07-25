# Kaotic Zombies Interactive Mod Installer
# For Black Ops 3 Zombies + TikTok/Tikfinity Integration

param(
    [string]$Bo3Path = "",
    [string]$RconPassword = "",
    [string]$RconPort = "27015",
    [string]$WebhookPort = "5000"
)

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Kaotic Zombies Interactive Mod Installer" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check if running as administrator
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    Write-Host "ERROR: This script must be run as Administrator" -ForegroundColor Red
    Write-Host "Right-click PowerShell and select 'Run as Administrator'" -ForegroundColor Yellow
    exit 1
}

# Detect BO3 path if not provided
if ([string]::IsNullOrEmpty($Bo3Path)) {
    Write-Host "Detecting Black Ops 3 installation path..." -ForegroundColor Yellow
    
    # Check common Steam locations
    $steamPaths = @(
        "${env:ProgramFiles(x86)}\Steam\steamapps\common\Call of Duty Black Ops III",
        "${env:ProgramFiles}\Steam\steamapps\common\Call of Duty Black Ops III",
        "C:\Program Files (x86)\Steam\steamapps\common\Call of Duty Black Ops III",
        "C:\Program Files\Steam\steamapps\common\Call of Duty Black Ops III"
    )
    
    $Bo3Path = $steamPaths | Where-Object { Test-Path $_ } | Select-Object -First 1
    
    if ([string]::IsNullOrEmpty($Bo3Path)) {
        Write-Host "ERROR: Could not find Black Ops 3 installation" -ForegroundColor Red
        Write-Host "Please provide the path using -Bo3Path parameter" -ForegroundColor Yellow
        exit 1
    }
}

Write-Host "BO3 Path: $Bo3Path" -ForegroundColor Green
Write-Host ""

# Verify BO3 installation
if (-not (Test-Path "$Bo3Path\mods")) {
    Write-Host "ERROR: Invalid BO3 installation path (mods folder not found)" -ForegroundColor Red
    exit 1
}

# Check Python installation
Write-Host "Checking Python installation..." -ForegroundColor Yellow
try {
    $pythonVersion = python --version 2>&1
    Write-Host "Python found: $pythonVersion" -ForegroundColor Green
} catch {
    Write-Host "ERROR: Python is not installed or not in PATH" -ForegroundColor Red
    Write-Host "Please install Python 3.8+ from https://www.python.org/" -ForegroundColor Yellow
    exit 1
}

# Create mod directory structure
Write-Host "Creating mod directory structure..." -ForegroundColor Yellow
$modPath = "$Bo3Path\mods\kaotic_zombies\zm_mod"

$directories = @(
    "$modPath\scripts\zm",
    "$modPath\zone_source"
)

foreach ($dir in $directories) {
    if (-not (Test-Path $dir)) {
        New-Item -ItemType Directory -Path $dir -Force | Out-Null
        Write-Host "Created: $dir" -ForegroundColor Green
    }
}

# Copy mod files
Write-Host "Copying mod files..." -ForegroundColor Yellow

$scriptPath = $PSScriptRoot

# Copy GSC script
if (Test-Path "$scriptPath\zm_mod\scripts\zm\kaotic_zombies.gsc") {
    Copy-Item "$scriptPath\zm_mod\scripts\zm\kaotic_zombies.gsc" "$modPath\scripts\zm\" -Force
    Write-Host "Copied: kaotic_zombies.gsc" -ForegroundColor Green
} else {
    Write-Host "WARNING: kaotic_zombies.gsc not found in source" -ForegroundColor Yellow
}

# Copy CSC script
if (Test-Path "$scriptPath\zm_mod\scripts\zm\kaotic_zombies.csc") {
    Copy-Item "$scriptPath\zm_mod\scripts\zm\kaotic_zombies.csc" "$modPath\scripts\zm\" -Force
    Write-Host "Copied: kaotic_zombies.csc" -ForegroundColor Green
} else {
    Write-Host "WARNING: kaotic_zombies.csc not found in source" -ForegroundColor Yellow
}

# Create mod.csv
$modCsvContent = @"
>modtools
>scriptable

scriptparsetree,scripts/zm/kaotic_zombies.gsc
scriptparsetree,scripts/zm/kaotic_zombies.csc
"@
Set-Content "$modPath\mod.csv" $modCsvContent -Encoding ASCII
Write-Host "Created: mod.csv" -ForegroundColor Green

# Create zone file
$zoneContent = @"
>game,zm
>name,kaotic_zombies

scriptparsetree,scripts/zm/kaotic_zombies.gsc
scriptparsetree,scripts/zm/kaotic_zombies.csc
"@
Set-Content "$modPath\zone_source\kaotic_zombies.zone" $zoneContent -Encoding ASCII
Write-Host "Created: kaotic_zombies.zone" -ForegroundColor Green

# Copy Python bridge files
Write-Host "Setting up Python bridge..." -ForegroundColor Yellow

$bridgeFiles = @(
    "tiktok_bridge.py",
    "requirements.txt",
    "creator_network.json"
)

foreach ($file in $bridgeFiles) {
    if (Test-Path "$scriptPath\$file") {
        Copy-Item "$scriptPath\$file" "$Bo3Path\mods\kaotic_zombies\" -Force
        Write-Host "Copied: $file" -ForegroundColor Green
    }
}

# Install Python dependencies
Write-Host "Installing Python dependencies..." -ForegroundColor Yellow
try {
    & python -m pip install -r "$Bo3Path\mods\kaotic_zombies\requirements.txt" --quiet
    Write-Host "Python dependencies installed successfully" -ForegroundColor Green
} catch {
    Write-Host "ERROR: Failed to install Python dependencies" -ForegroundColor Red
    Write-Host "Run manually: python -m pip install -r requirements.txt" -ForegroundColor Yellow
}

# Configure bridge
Write-Host "Configuring TikTok bridge..." -ForegroundColor Yellow

$bridgeConfig = @"
# TikTok Bridge Configuration
# Edit these values as needed

RCON_HOST = "127.0.0.1"
RCON_PORT = $RconPort
RCON_PASSWORD = "$RconPassword"
WEBHOOK_PORT = $WebhookPort
"@

Set-Content "$Bo3Path\mods\kaotic_zombies\bridge_config.py" $bridgeConfig -Encoding ASCII
Write-Host "Created: bridge_config.py" -ForegroundColor Green

# Update tiktok_bridge.py to use config
$bridgeScript = Get-Content "$Bo3Path\mods\kaotic_zombies\tiktok_bridge.py" -Raw
$bridgeScript = $bridgeScript -replace 'RCON_HOST = "127.0.0.1"', 'from bridge_config import *'
$bridgeScript = $bridgeScript -replace 'RCON_PORT = 27015', ''
$bridgeScript = $bridgeScript -replace 'RCON_PASSWORD = ""', ''
$bridgeScript = $bridgeScript -replace 'TIKTOK_WEBHOOK_PORT = 5000', ''
Set-Content "$Bo3Path\mods\kaotic_zombies\tiktok_bridge.py" $bridgeScript -Encoding ASCII

# Build the mod
Write-Host "Building mod (requires BO3 Mod Tools)..." -ForegroundColor Yellow
Write-Host "Note: If Mod Tools are not installed, skip this step and build manually" -ForegroundColor Yellow

$linkerPath = "$Bo3Path\bin\linker_pc.exe"
if (Test-Path $linkerPath) {
    Write-Host "Running linker to build mod..." -ForegroundColor Yellow
    try {
        & $linkerPath -f "$modPath\zone_source\kaotic_zombies.zone" -i "$Bo3Path" -o "$Bo3Path\zone"
        Write-Host "Mod built successfully" -ForegroundColor Green
    } catch {
        Write-Host "WARNING: Mod build failed. Build manually using BO3 Mod Tools" -ForegroundColor Yellow
    }
} else {
    Write-Host "Linker not found. Build mod manually using BO3 Mod Tools" -ForegroundColor Yellow
}

# Create desktop shortcut
Write-Host "Creating desktop shortcuts..." -ForegroundColor Yellow

$desktop = [Environment]::GetFolderPath("Desktop")

# Bridge shortcut
$bridgeShortcut = "$desktop\Kaotic TikTok Bridge.lnk"
$WshShell = New-Object -ComObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut($bridgeShortcut)
$Shortcut.TargetPath = "pythonw.exe"
$Shortcut.Arguments = "`"$Bo3Path\mods\kaotic_zombies\tiktok_bridge.py`""
$Shortcut.WorkingDirectory = "$Bo3Path\mods\kaotic_zombies"
$Shortcut.Description = "Kaotic TikTok Interactive Bridge"
$Shortcut.Save()
Write-Host "Created: Desktop shortcut for TikTok Bridge" -ForegroundColor Green

# Create startup script
$startupScript = @"
@echo off
cd /d "$Bo3Path\mods\kaotic_zombies"
pythonw tiktok_bridge.py
"@
Set-Content "$Bo3Path\mods\kaotic_zombies\start_bridge.bat" $startupScript -Encoding ASCII
Write-Host "Created: start_bridge.bat" -ForegroundColor Green

# Create management script
$manageScript = @"
@echo off
title Kaotic Creator Network Manager
cd /d "$Bo3Path\mods\kaotic_zombies"
python manage_creators.py
"@
Set-Content "$Bo3Path\mods\kaotic_zombies\manage_creators.bat" $manageScript -Encoding ASCII
Write-Host "Created: manage_creators.bat" -ForegroundColor Green

# Create creator management script
$managePy = @"
#!/usr/bin/env python3
"""
Creator Network Management Script
"""

import requests
import json
import sys

BRIDGE_URL = "http://127.0.0.1:5000"

def add_creator(creator_id):
    try:
        response = requests.post(f"{BRIDGE_URL}/creator/add", json={"creator_id": creator_id})
        print(response.json())
    except Exception as e:
        print(f"Error: {e}")

def remove_creator(creator_id):
    try:
        response = requests.post(f"{BRIDGE_URL}/creator/remove", json={"creator_id": creator_id})
        print(response.json())
    except Exception as e:
        print(f"Error: {e}")

def list_creators():
    try:
        response = requests.get(f"{BRIDGE_URL}/creator/list")
        print(response.json())
    except Exception as e:
        print(f"Error: {e}")

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python manage_creators.py [add|remove|list] [creator_id]")
        sys.exit(1)
    
    command = sys.argv[1].lower()
    
    if command == "add":
        if len(sys.argv) < 3:
            print("Usage: python manage_creators.py add <creator_id>")
            sys.exit(1)
        add_creator(sys.argv[2])
    elif command == "remove":
        if len(sys.argv) < 3:
            print("Usage: python manage_creators.py remove <creator_id>")
            sys.exit(1)
        remove_creator(sys.argv[2])
    elif command == "list":
        list_creators()
    else:
        print("Unknown command. Use: add, remove, or list")
"@
Set-Content "$Bo3Path\mods\kaotic_zombies\manage_creators.py" $managePy -Encoding ASCII
Write-Host "Created: manage_creators.py" -ForegroundColor Green

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Installation Complete!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Next Steps:" -ForegroundColor Yellow
Write-Host "1. Build the mod using BO3 Mod Tools (if not already done)" -ForegroundColor White
Write-Host "2. Configure your BO3 dedicated server RCON settings" -ForegroundColor White
Write-Host "3. Start the TikTok Bridge using the desktop shortcut" -ForegroundColor White
Write-Host "4. Add creators to your network using manage_creators.bat" -ForegroundColor White
Write-Host "5. Configure TikTok/Tikfinity to send webhooks to http://localhost:$WebhookPort/webhook/tiktok" -ForegroundColor White
Write-Host ""
Write-Host "For detailed instructions, see README.md" -ForegroundColor Yellow
Write-Host ""
