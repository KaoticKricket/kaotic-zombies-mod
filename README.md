# Kaotic Zombies Interactive Mod

[![GitHub Release](https://img.shields.io/github/v/release/your-username/kaotic-zombies-mod)](https://github.com/your-username/kaotic-zombies-mod/releases)
[![License](https://img.shields.io/github/license/your-username/kaotic-zombies-mod)](LICENSE)
[![Python](https://img.shields.io/badge/python-3.8+-blue.svg)](https://www.python.org/downloads/)

A TikTok/Tikfinity integration mod for Black Ops 3 Zombies that allows viewers to trigger interactive events in-game through creator network access control.

## Features

- **TikTok/Tikfinity Integration**: Connect your TikTok live streams to BO3 Zombies gameplay
- **Creator Network Access Control**: Only authorized creators in your network can trigger events
- **Interactive Events**: Multiple viewer-triggerable events including:
  - `zombie_swarm` - Spawns additional zombies scaled to current round
  - `boss_round` - Spawns a boosted boss zombie
  - `powerup_drop` - Drops random power-ups near all players
  - `max_ammo` - Refills ammo for all weapons
  - `insta_kill` - Activates insta-kill for 30 seconds
  - `double_points` - Activates double points for 30 seconds
- **Windows Installer**: One-click installer for easy setup
- **Auto-Updates**: Built-in update checker for GitHub releases
- **Python Bridge**: Flask-based webhook server for TikTok integration
- **RCON Protocol**: Uses BO3's built-in RCON for server communication

## Download

### Windows Installer (Recommended)

Download the latest Windows installer from [GitHub Releases](https://github.com/your-username/kaotic-zombies-mod/releases/latest):

1. Download `KaoticZombiesMod-Setup.exe`
2. Run the installer
3. Follow the setup wizard
4. Configure your BO3 path and RCON settings
5. Complete installation

### Manual Installation

See [Installation](#installation) section below for manual setup instructions.

### Updating

The mod includes an auto-update checker:
- Run "Check for Updates" from the Start Menu
- Or manually: `python update_checker.py`
- Or download the latest installer from [GitHub Releases](https://github.com/your-username/kaotic-zombies-mod/releases)

## Requirements

- Black Ops 3 (PC)
- Black Ops 3 Mod Tools (for building the mod)
- TikTok/Tikfinity account with interactive capabilities
- BO3 Dedicated Server (for multiplayer functionality)

## Installation

### Windows Installer (Recommended)

1. Download `KaoticZombiesMod-Setup.exe` from [GitHub Releases](https://github.com/your-username/kaotic-zombies-mod/releases/latest)
2. Run the installer as Administrator
3. Select your Black Ops 3 installation directory
4. Configure RCON settings (password, port, webhook port)
5. Complete the installation
6. The installer will:
   - Copy all mod files to your BO3 directory
   - Create Start Menu shortcuts
   - Generate configuration files
   - Set up the TikTok Bridge (standalone executable, no Python required)

### PowerShell Installer (Alternative)

1. **Download the mod files** from GitHub
2. **Run PowerShell as Administrator**
3. **Navigate to the mod directory**:
   ```powershell
   cd "path\to\kaotic_zombies"
   ```
4. **Run the installer**:
   ```powershell
   .\install.ps1
   ```
5. **Follow the prompts**

### Manual Install

If the installer fails, follow these steps:

1. **Create mod directory structure**:
   ```
   <BO3 Path>\mods\kaotic_zombies\zm_mod\scripts\zm\
   <BO3 Path>\mods\kaotic_zombies\zm_mod\zone_source\
   ```

2. **Copy mod files**:
   - `kaotic_zombies.gsc` → `zm_mod\scripts\zm\`
   - `kaotic_zombies.csc` → `zm_mod\scripts\zm\`
   - `mod.csv` → `zm_mod\`
   - `kaotic_zombies.zone` → `zm_mod\zone_source\`

3. **Copy TikTok Bridge executable**:
   - `TikTokBridge.exe` → `mods\kaotic_zombies\`
   - `creator_network.json` → `mods\kaotic_zombies\`

4. **Build the mod** using BO3 Mod Tools:
   - Open BO3 Mod Tools Launcher
   - Select "Zone Builder"
   - Build `kaotic_zombies.zone`

## Configuration

### BO3 Dedicated Server Setup

1. **Configure RCON** in your server config file:
   ```
   set rcon_password "your_password"
   set rcon_port 27015
   set sv_rcon_banPenalty 0
   set sv_rcon_maxfailures 10
   set sv_rcon_minfailuretime 5
   ```

2. **Enable the mod** in your server launch parameters:
   ```
   +set fs_game mods/kaotic_zombies
   ```

3. **Start your dedicated server**

### TikTok Bridge Configuration

The TikTok Bridge is now a standalone executable - no Python installation required!

1. **Configuration is set during installation** via the installer wizard
2. **Start the bridge**:
   - Double-click the desktop shortcut "Kaotic TikTok Bridge"
   - Or use Start Menu → **Kaotic Zombies Interactive Mod** → **TikTok Bridge**
   - Or run: `TikTokBridge.exe` from the installation directory

The bridge reads configuration from the settings you provided during installation.

### TikTok/Tikfinity Setup

1. **Configure TikTok/Tikfinity** to send webhooks to:
   ```
   http://localhost:5000/webhook/tiktok
   ```
   (Replace `localhost` with your public IP if streaming from a different machine)

2. **Webhook payload format**:
   ```json
   {
     "creator_id": "your_tiktok_username",
     "event_name": "zombie_swarm",
     "event_id": "unique_event_id"
   }
   ```

## Creator Network Management

### Adding Creators

**Edit the creator network file directly**:
1. Open `creator_network.json` in the installation directory
2. Add your TikTok username to the creators array:
```json
{
  "creators": ["@your_username"],
  "description": "Authorized TikTok creator IDs for interactive events",
  "version": "1.0"
}
```

**Or via HTTP API** (while bridge is running):
```bash
curl -X POST http://localhost:5000/creator/add \
  -H "Content-Type: application/json" \
  -d "{\"creator_id\": \"@creator_username\"}"
```

### Removing Creators

Edit `creator_network.json` and remove the username from the creators array.

### Listing Authorized Creators

Check the `creator_network.json` file or use the HTTP API:
```bash
curl http://localhost:5000/creator/list
```
```json
{
  "creators": ["@creator1", "@creator2", "@creator3"],
  "description": "Authorized TikTok creator IDs for interactive events",
  "version": "1.0"
}
```

## Usage

### Starting the System

1. **Start your BO3 dedicated server** with the mod loaded
2. **Start the TikTok Bridge** (desktop shortcut or `TikTokBridge.exe`)
3. **Start your TikTok live stream** with Tikfinity enabled
4. **Viewers can now trigger events** by sending gifts/interactions

### In-Game Verification

When the mod loads successfully, you'll see:
```
KAOTIC INTERACTIVE LOADED
KAOTIC: LOADED X AUTHORIZED CREATORS
```

When an event is triggered:
```
KAOTIC: ZOMBIE SWARM ACTIVATED
KAOTIC: SPAWNED 12 ZOMBIES
```

### Event Types

| Event Name | Description | Duration |
|------------|-------------|----------|
| `zombie_swarm` | Spawns (5 + round_number) zombies near players | Instant |
| `boss_round` | Spawns a 5x health, 2x damage boss zombie | Until killed |
| `powerup_drop` | Drops random power-up near each player | Instant |
| `max_ammo` | Refills ammo for all player weapons | Instant |
| `insta_kill` | One-hit kill zombies | 30 seconds |
| `double_points` | 2x score multiplier | 30 seconds |

## Distribution to Creators

### Sharing the Mod

Share the mod with creators by directing them to:

1. **GitHub Repository**: https://github.com/your-username/kaotic-zombies-mod
2. **Latest Release**: https://github.com/your-username/kaotic-zombies-mod/releases/latest
3. **Windows Installer**: Direct link to `KaoticZombiesMod-Setup.exe`

### Creator Setup Instructions

Provide creators with these simple steps:

1. Download the Windows installer from GitHub Releases
2. Run the installer and follow the setup wizard
3. Configure their BO3 path and RCON settings during installation
4. Add their TikTok username to the creator network using the Start Menu shortcut
5. Start the TikTok Bridge before going live
6. Configure TikTok/Tikfinity to send webhooks to their configured webhook port

### For TikTok/Tikfinity Configuration

Provide creators with:
- **Webhook URL**: `http://their-server-ip:5000/webhook/tiktok` (default port 5000)
- **Required payload format** (see API Reference below)
- **List of supported events** (see Event Types section)
- **Their creator ID** (TikTok username with @ symbol)

## Troubleshooting

### Mod Not Loading

- **Check mod is built**: Run BO3 Mod Tools and rebuild the zone file
- **Verify server config**: Ensure `+set fs_game mods/kaotic_zombies` is in launch parameters
- **Check console**: Look for "KAOTIC INTERACTIVE LOADED" message

### Bridge Not Connecting

- **Check RCON settings**: Ensure password, port, and IP match server config
- **Test RCON manually**: Use RCON tool to verify connection
- **Check firewall**: Allow TikTokBridge.exe through Windows Firewall
- **Verify executable**: Ensure TikTokBridge.exe is not blocked by antivirus

### Events Not Triggering

- **Verify creator authorization**: Check `creator_network.json`
- **Check webhook format**: Ensure payload includes `creator_id`, `event_name`, and `event_id`
- **Check bridge is running**: Look for TikTokBridge.exe in Task Manager
- **Verify Dvar values**: In-game console: `GetDvarString("kaotic_event_name")`

### Unauthorized Creator Errors

- **Add creator to network**: Edit `creator_network.json` and add your username
- **Check creator ID format**: Must match exactly (including @ symbol)
- **Restart bridge**: After modifying creator network

## API Reference

### Webhook Endpoints

#### POST /webhook/tiktok
Receive TikTok interactive events.

**Request Body**:
```json
{
  "creator_id": "@username",
  "event_name": "zombie_swarm",
  "event_id": "unique_id"
}
```

**Response**:
```json
{
  "status": "success",
  "event": "zombie_swarm"
}
```

#### POST /creator/add
Add creator to authorized network.

**Request Body**:
```json
{
  "creator_id": "@username"
}
```

#### POST /creator/remove
Remove creator from authorized network.

**Request Body**:
```json
{
  "creator_id": "@username"
}
```

#### GET /creator/list
List all authorized creators.

**Response**:
```json
{
  "status": "success",
  "creators": ["@creator1", "@creator2"]
}
```

#### GET /health
Health check endpoint.

**Response**:
```json
{
  "status": "healthy",
  "creators_count": 2
}
```

## Security Considerations

- **RCON Password**: Use a strong, unique password for RCON
- **Firewall**: Only expose necessary ports (webhook port) to the internet
- **Creator Verification**: Only add trusted creators to your network
- **Rate Limiting**: Consider implementing rate limiting for events (not included by default)
- **Network Isolation**: Run bridge on same machine as BO3 server when possible

## Advanced Configuration

### Custom Event Implementation

To add custom events, edit `kaotic_zombies.gsc`:

```gsc
function kaotic_dispatch_event(event_name)
{
    if(event_name == "my_custom_event")
    {
        level thread kaotic_my_custom_event();
        return;
    }
    // ... existing events
}

function kaotic_my_custom_event()
{
    // Your custom logic here
    iprintlnbold("KAOTIC: CUSTOM EVENT");
}
```

### Event Cooldowns

Add cooldowns to prevent spam:

```gsc
level.kaotic_last_event_time = 0;
level.kaotic_cooldown = 5; // 5 seconds

// In event receiver:
if(time < level.kaotic_last_event_time + level.kaotic_cooldown)
{
    return; // Ignore event during cooldown
}
level.kaotic_last_event_time = time;
```

### Custom RCON Implementation

If the default RCON implementation doesn't work with your server, modify `tiktok_bridge.py`:

```python
def send_rcon_command(command):
    # Your custom RCON implementation
    pass
```

## Support

For issues or questions:
- Check the troubleshooting section
- Review BO3 Mod Tools documentation
- Verify TikTok/Tikfinity API documentation
- Test components individually (bridge, mod, server)

## Credits

- Built for Black Ops 3 Zombies Modding Community
- Uses BO3's RCON protocol for server communication
- Flask-based webhook server for TikTok integration
- Creator network access control for security

## License

This mod is provided as-is for educational and entertainment purposes. Respect TikTok's Terms of Service and BO3's modding guidelines.

## Version History

- **v1.0** - Initial release
  - TikTok/Tikfinity integration
  - Creator network access control
  - 6 interactive events
  - PowerShell installer
  - Python bridge server
