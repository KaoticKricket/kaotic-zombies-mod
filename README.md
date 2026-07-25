# Kaotic Zombies

A TikTok/Tikfinity integration mod for Black Ops 3 Zombies that allows viewers to trigger interactive events in-game.

## Features

- **TikTok/Tikfinity Integration**: Connect your TikTok live streams to BO3 Zombies gameplay
- **Creator Network Access Control**: Only authorized creators can trigger events
- **Interactive Events**: Multiple viewer-triggerable events including:
  - `zombie_swarm` - Spawns additional zombies scaled to current round
  - `boss_round` - Spawns a boosted boss zombie
  - `powerup_drop` - Drops random power-ups near all players
  - `max_ammo` - Refills ammo for all weapons
  - `insta_kill` - Activates insta-kill for 30 seconds
  - `double_points` - Activates double points for 30 seconds

## Requirements

- Black Ops 3 (PC)
- TikTok/Tikfinity account with interactive capabilities
- BO3 Dedicated Server (for multiplayer functionality)

## Installation

### Windows Installer (Recommended)

1. Download `KaoticZombiesMod-Setup.exe` from [GitHub Releases](https://github.com/KaoticKricket/kaotic-zombies-mod/releases/latest)
2. Run the installer as Administrator
3. Select your Black Ops 3 installation directory
4. Configure TikTok Bridge settings:
   - **RCON Password**: Choose a secure password (you'll use this in your BO3 server config)
   - **RCON Port**: Enter `27015` (default BO3 RCON port, change only if your server uses a different port)
   - **Webhook Port**: Enter `5000` (default, change only if this port is already in use)
5. Complete the installation

The installer will:
- Copy all mod files to your BO3 directory
- Copy the pre-compiled mod zone file
- Create Start Menu shortcuts
- Generate configuration files
- Set up the TikTok Bridge (standalone executable, no Python required)

## Configuration

### BO3 Dedicated Server Setup

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

### Add Your TikTok Username

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

### Configure TikTok/Tikfinity

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

1. **Start your BO3 dedicated server** with the mod loaded
2. **Start the TikTok Bridge**:
   - Double-click the desktop shortcut "Kaotic TikTok Bridge"
   - Or use Start Menu → **Kaotic Zombies Interactive Mod** → **TikTok Bridge**
   - Or run: `TikTokBridge.exe` from the installation directory
3. **Start your TikTok live stream** with Tikfinity enabled
4. **Viewers can now trigger events** by sending gifts/interactions

### In-Game Verification

When the mod loads successfully, you'll see:
```
KAOTIC INTERACTIVE LOADED
KAOTIC: LOADED 1 AUTHORIZED CREATORS
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

## Troubleshooting

### Mod Not Loading

- **Verify server config**: Ensure `+set fs_game mods/kaotic_zombies` is in launch parameters
- **Check console**: Look for "KAOTIC INTERACTIVE LOADED" message
- **Verify files**: Ensure all mod files are in the correct directory

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

## License

This mod is provided as-is for educational and entertainment purposes. Respect TikTok's Terms of Service and BO3's modding guidelines.
