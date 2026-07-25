#!/usr/bin/env python3
"""
Auto-update checker for Kaotic Zombies Interactive Mod
Checks GitHub releases for updates and downloads new versions
"""

import requests
import json
import sys
import os
import subprocess
from pathlib import Path

GITHUB_REPO = "your-username/kaotic-zombies-mod"  # Update with your repo
CURRENT_VERSION = "1.0.0"
VERSION_FILE = "version.json"

def get_current_version():
    """Get current installed version"""
    try:
        if os.path.exists(VERSION_FILE):
            with open(VERSION_FILE, 'r') as f:
                data = json.load(f)
                return data.get('version', CURRENT_VERSION)
        return CURRENT_VERSION
    except:
        return CURRENT_VERSION

def get_latest_release():
    """Get latest release from GitHub"""
    try:
        url = f"https://api.github.com/repos/{GITHUB_REPO}/releases/latest"
        response = requests.get(url, timeout=10)
        response.raise_for_status()
        return response.json()
    except Exception as e:
        print(f"Error checking for updates: {e}")
        return None

def compare_versions(current, latest):
    """Compare version strings"""
    current_parts = [int(x) for x in current.split('.')]
    latest_parts = [int(x) for x in latest.split('.')]
    
    for i in range(max(len(current_parts), len(latest_parts))):
        c = current_parts[i] if i < len(current_parts) else 0
        l = latest_parts[i] if i < len(latest_parts) else 0
        
        if l > c:
            return 1  # Update available
        elif l < c:
            return -1  # Current is newer
    return 0  # Same version

def download_update(release_data):
    """Download latest release"""
    try:
        # Find Windows installer asset
        installer_asset = None
        for asset in release_data.get('assets', []):
            if asset['name'].endswith('.exe'):
                installer_asset = asset
                break
        
        if not installer_asset:
            print("No Windows installer found in release")
            return False
        
        download_url = installer_asset['browser_download_url']
        filename = installer_asset['name']
        
        print(f"Downloading {filename}...")
        response = requests.get(download_url, stream=True, timeout=30)
        response.raise_for_status()
        
        with open(filename, 'wb') as f:
            for chunk in response.iter_content(chunk_size=8192):
                f.write(chunk)
        
        print(f"Downloaded: {filename}")
        return filename
    except Exception as e:
        print(f"Error downloading update: {e}")
        return False

def run_installer(installer_path):
    """Run the downloaded installer"""
    try:
        print(f"Launching installer: {installer_path}")
        subprocess.Popen([installer_path], shell=True)
        return True
    except Exception as e:
        print(f"Error launching installer: {e}")
        return False

def check_for_updates(auto_install=False):
    """Main update check function"""
    print(f"Kaotic Zombies Mod - Update Checker")
    print(f"Current version: {get_current_version()}")
    print("Checking for updates...")
    
    release = get_latest_release()
    if not release:
        print("Could not check for updates")
        return False
    
    latest_version = release['tag_name'].lstrip('v')
    print(f"Latest version: {latest_version}")
    
    comparison = compare_versions(get_current_version(), latest_version)
    
    if comparison == 1:
        print(f"Update available: {latest_version}")
        print(f"Release notes: {release.get('body', 'No release notes')}")
        
        if auto_install:
            choice = 'y'
        else:
            choice = input("Download and install update? (y/n): ").lower()
        
        if choice == 'y':
            installer = download_update(release)
            if installer:
                if auto_install or input("Install now? (y/n): ").lower() == 'y':
                    run_installer(installer)
                    return True
    elif comparison == -1:
        print("You are running a pre-release version")
    else:
        print("You are running the latest version")
    
    return False

def save_version(version):
    """Save current version to file"""
    try:
        with open(VERSION_FILE, 'w') as f:
            json.dump({'version': version}, f, indent=2)
    except Exception as e:
        print(f"Error saving version: {e}")

if __name__ == "__main__":
    if len(sys.argv) > 1 and sys.argv[1] == "--auto":
        check_for_updates(auto_install=True)
    else:
        check_for_updates()
