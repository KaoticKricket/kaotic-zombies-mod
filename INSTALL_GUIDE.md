# Kaotic Zombies Interactive Mod - Installation Guide for Creators

## Quick Start

1. **Download the installer**: `KaoticZombiesMod-Setup.exe`
2. **Run as Administrator**: Right-click and select "Run as administrator"
3. **Follow the setup wizard**:
   - Accept the license agreement
   - Select your Black Ops 3 installation directory
   - Configure TikTok Bridge settings (RCON password, ports)
   - Complete installation

## System Requirements

- **Black Ops 3** (PC version)
- **TikTok/Tikfinity account** (for interactive features)
- **BO3 Dedicated Server** (for multiplayer)

## Installation Steps

### Step 1: Download and Run Installer

1. Download `KaoticZombiesMod-Setup.exe`
2. Right-click the file and select "Run as administrator"
3. Click "Yes" if Windows asks for permission

### Step 2: License Agreement

Read the license and click "I Agree" to continue.

### Step 3: Select Black Ops 3 Directory

The installer will automatically try to detect your Black Ops 3 installation:
- It checks common Steam installation paths
- If not found, browse to your BO3 directory manually
- Typical path: `C:\Program Files (x86)\Steam\steamapps\common\Call of Duty Black Ops III`

**Validation**: The installer verifies the directory contains:
- `mods\` folder
- `bin\` folder

### Step 4: Configure TikTok Bridge Settings

The installer will ask for three configuration settings. Here's what each one means and what to enter:

#### RCON Password
- **What it is**: A password that allows the TikTok Bridge to send commands to your BO3 server
- **What to enter**: Choose any secure password you want (e.g., `MySecurePass123`)
- **Important**: You'll need to use this same password in your BO3 server configuration file later
- **Example**: `MySecretPassword456`

#### RCON Port
- **What it is**: The port number your BO3 server uses for RCON connections
- **What to enter**: Usually `27015` (default BO3 RCON port)
- **When to change**: Only if your server uses a different RCON port
- **Example**: `27015`

#### Webhook Port
- **What it is**: The port the TikTok Bridge uses to receive events from TikTok/Tikfinity
- **What to enter**: Usually `5000` (default)
- **When to change**: Only if port 5000 is already used by another application on your computer
- **Example**: `5000` or `5001` if 5000 is in use

**Summary**: For most users, you can use:
- RCON Password: Any secure password you choose
- RCON Port: `27015`
- Webhook Port: `5000`

### Step 5: Installation Progress

The installer will:
- Copy mod files to your BO3 directory
- Copy the pre-compiled mod zone file
- Create configuration files
- Add Start Menu shortcuts
- Add desktop shortcut for TikTok Bridge
- Set up the standalone TikTok Bridge executable (no Python required)

### Step 6: Complete Installation

- Click "Finish" to complete the installation
- The README file will open automatically for reference

## Post-Installation Setup

### 1. Configure BO3 Dedicated Server

You need to configure your BO3 server to use the same RCON settings you chose during installation.

**Find your BO3 server configuration file** (usually `server.cfg` or similar):
- Look in your BO3 dedicated server directory
- Common location: `<BO3 Path>\players2\` or your server config folder

**Add these RCON settings** to your server config file:
```
set rcon_password "your_password"     // Use the EXACT password you set during installation
set rcon_port 27015                   // Use the EXACT port you set during installation
set sv_rcon_banPenalty 0
set sv_rcon_maxfailures 10
set sv_rcon_minfailuretime 5
```

**Important**: The `rcon_password` and `rcon_port` must match exactly what you entered in the installer!

**Add to your server launch parameters**:
```
+set fs_game mods/kaotic_zombies
```

**Example**: If you set `MySecretPass123` as your RCON password during installation, your server config should have:
```
set rcon_password "MySecretPass123"
set rcon_port 27015
```

### 3. Add Your TikTok Username

Add yourself to the creator network:

1. Open `creator_network.json` in the installation directory
2. Add your TikTok username to the creators array:
```json
{
  "creators": ["@your_tiktok_username"],
  "description": "Authorized TikTok creator IDs for interactive events",
  "version": "1.0"
}
```
3. Save the file
4. Your username is now authorized to trigger events

### 4. Configure TikTok/Tikfinity

In your TikTok/Tikfinity settings:

1. Set webhook URL to: `http://localhost:5000/webhook/tiktok`
   - Replace `localhost` with your server's public IP if streaming from a different machine
   - Use the webhook port you set during installation (default: 5000)

2. Configure webhook payload format:
```json
{
  "creator_id": "@your_tiktok_username",
  "event_name": "zombie_swarm",
  "event_id": "unique_event_id"
}
```

## Usage

### Starting the System

1. **Start BO3 Dedicated Server** with the mod loaded
2. **Start TikTok Bridge**:
   - Double-click the desktop shortcut "Kaotic TikTok Bridge"
   - Or use Start Menu → **Kaotic Zombies Interactive Mod** → **TikTok Bridge**
   - Or run: `TikTokBridge.exe` from the installation directory
3. **Start your TikTok live stream** with Tikfinity enabled
4. **Viewers can now trigger events** by sending gifts/interactions

### Verification

When the mod loads successfully, you'll see in-game:
```
KAOTIC INTERACTIVE LOADED
KAOTIC: LOADED 1 AUTHORIZED CREATORS
```

When an event is triggered:
```
KAOTIC: ZOMBIE SWARM ACTIVATED
KAOTIC: SPAWNED 12 ZOMBIES
```

## Available Events

| Event Name | Description | Duration |
|------------|-------------|----------|
| `zombie_swarm` | Spawns additional zombies near players | Instant |
| `boss_round` | Spawns a boosted boss zombie | Until killed |
| `powerup_drop` | Drops random power-ups near players | Instant |
| `max_ammo` | Refills ammo for all weapons | Instant |
| `insta_kill` | One-hit kill zombies | 30 seconds |
| `double_points` | 2x score multiplier | 30 seconds |

## Managing Creators

### Add a Creator
```bash
python manage_creators.py add @creator_username
```

### Remove a Creator
```bash
python manage_creators.py remove @creator_username
```

### List All Creators
```bash
python manage_creators.py list
```

## Troubleshooting

### Installer Won't Run

- **Run as Administrator**: Right-click and select "Run as administrator"
- **Check Windows Defender**: May block the installer temporarily
- **Disable antivirus temporarily**: Some antivirus software blocks installers

### Python Not Detected

The installer will warn you if Python is not found:
1. Download Python from https://www.python.org/
2. Install Python 3.8 or higher
3. During Python installation, check "Add Python to PATH"
4. Re-run the installer or manually install dependencies:
   ```bash
   cd "<BO3 Path>\mods\kaotic_zombies"
   pip install -r requirements.txt
   ```

### BO3 Path Not Found

- **Manual Selection**: Click "Browse" and navigate to your BO3 directory
- **Typical Locations**:
  - `C:\Program Files (x86)\Steam\steamapps\common\Call of Duty Black Ops III`
  - `C:\Program Files\Steam\steamapps\common\Call of Duty Black Ops III`
  - `D:\Steam\steamapps\common\Call of Duty Black Ops III`

### Mod Won't Load in BO3

- **Build the mod**: Use BO3 Mod Tools to build the zone file
- **Check server config**: Ensure `+set fs_game mods/kaotic_zombies` is in launch parameters
- **Verify files**: Check that all files are in `<BO3 Path>\mods\kaotic_zombies\`

### TikTok Bridge Won't Start

- **Check Python**: Ensure Python is installed and in PATH
- **Check dependencies**: Run `pip install -r requirements.txt`
- **Check configuration**: Verify `bridge_config.py` exists with correct settings
- **Check firewall**: Allow Python through Windows Firewall

### Events Not Triggering

- **Verify creator authorization**: Run `python manage_creators.py list`
- **Check webhook format**: Ensure payload includes `creator_id`, `event_name`, `event_id`
- **Check bridge is running**: Look for the bridge in system tray or Task Manager
- **Check RCON connection**: Verify RCON password and port match server settings

## Uninstallation

To remove the mod:

1. Open **Control Panel** → **Programs and Features**
2. Find **Kaotic Zombies Interactive Mod**
3. Click **Uninstall**
4. Follow the uninstall wizard

The uninstaller will:
- Remove all mod files from your BO3 directory
- Remove Start Menu shortcuts
- Remove desktop shortcut
- Clean up Python cache files

**Note**: Your BO3 dedicated server configuration and TikTok/Tikfinity settings will not be removed.

## Support

For issues or questions:
- Check this installation guide
- Review the README.md file in your installation directory
- Verify your BO3 and Python installations
- Test components individually (bridge, mod, server)

## File Locations After Installation

After installation, files will be located at:

```
<BO3 Path>\mods\kaotic_zombies\
├── tiktok_bridge.py           # Main TikTok integration server
├── bridge_config.py           # Configuration file (created during install)
├── requirements.txt           # Python dependencies
├── manage_creators.py         # Creator management tool
├── manage_creators.bat        # Quick launcher for creator manager
├── start_bridge.bat           # Quick launcher for TikTok Bridge
├── creator_network.json       # Authorized creators list
├── README.md                  # Full documentation
├── LICENSE                    # License file
├── CHANGELOG.md               # Version history
└── zm_mod\                    # BO3 mod files
    ├── scripts\zm\
    │   ├── kaotic_zombies.gsc # Main game script
    │   └── kaotic_zombies.csc # Client script
    ├── mod.csv                # Mod definition
    └── zone_source\
        └── kaotic_zombies.zone # Zone file (to be built)
```

## Security Notes

- **RCON Password**: Use a strong, unique password
- **Firewall**: Only expose the webhook port if necessary
- **Creator Network**: Only add trusted creators to your network
- **Network Isolation**: Run the bridge on the same machine as BO3 when possible
