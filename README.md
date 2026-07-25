# Kaotic Zombies

A TikTok/Tikfinity integration mod for Black Ops 3 Zombies that allows viewers to trigger interactive events in-game.

## Features

- **TikTok/Tikfinity Integration**: Connect your TikTok live streams to BO3 Zombies gameplay
- **Local HTTP Listener**: Lightweight Windows application that receives TikFinity webhooks
- **File-Based IPC**: Reliable communication between listener and game without RCON
- **Interactive Events**: Multiple viewer-triggerable events across categories:
  - **Weapons**: Random weapons, wall weapons, wonder weapons, ray gun spawns
  - **Player Effects**: Ammo refill, instant kill, double points, weapon changes
  - **Enemy Events**: Zombie swarms, boss rounds, special enemies, speed modifiers
  - **Chaos Events**: Jump scares, screen shake, teleportation, gravity changes
  - **Fun Events**: Confetti, sounds, disco mode, voice lines

## Requirements

- Black Ops 3 (PC)
- **BO3 Mod Tools** (free on Steam - required to build the mod)
- TikTok/Tikfinity account with interactive capabilities

## Installation

### Windows Installer (Recommended)

1. Download `KaoticZombiesMod-Setup.exe` from [GitHub Releases](https://github.com/KaoticKricket/kaotic-zombies-mod/releases/latest)
2. Run the installer as Administrator
3. The installer will automatically detect your Black Ops 3 installation folder
4. If detection fails, browse to your BO3 installation folder manually
5. Click Install - the installer copies all files automatically
6. Launch Black Ops 3
7. Open Zombies
8. Load the Kaotic Zombies mod
9. Start KaoticListener.exe (included with the mod)
10. Configure TikFinity webhooks (see below)

### Manual Installation

1. Download the mod files from [GitHub Releases](https://github.com/KaoticKricket/kaotic-zombies-mod/releases/latest)
2. Extract to your BO3 mods directory: `<BO3 Path>\mods\kaotic_zombies\`
3. **Build the mod using BO3 Mod Tools** (see "Building the Mod" below)
4. Add launch parameters (see below)
5. Start Black Ops 3 Zombies
6. Start KaoticListener.exe from the mod directory

### Adding Launch Parameters (Manual Install Only)

**Option 1: Steam Launch Options**
1. Open Steam Library
2. Right-click "Call of Duty: Black Ops III"
3. Select "Properties"
4. Click "Set Launch Options"
5. Add: `+set fs_game mods/kaotic_zombies`
6. Click OK

**Option 2: Desktop Shortcut**
1. Right-click your Black Ops 3 desktop shortcut
2. Select "Properties"
3. Find the "Target" field
4. Add to the end of the path: ` +set fs_game mods/kaotic_zombies`
5. Click OK

## Building the Mod

**IMPORTANT:** The mod must be built with BO3 Mod Tools before it will work in-game. The GSC scripts won't execute without being compiled.

### Installing BO3 Mod Tools
1. Open Steam
2. Search for "Call of Duty: Black Ops III - Mod Tools"
3. Install the free Mod Tools DLC
4. Launch the Mod Tools Launcher

### Building the Mod

**Note:** The BO3 Mod Tools interface may vary. Look for any tool that can compile/link zone files or build mods.

**General Approach:**
1. Open BO3 Mod Tools Launcher
2. Look for any of these options: "Linker", "Builder", "Compiler", or "Zone Builder"
3. Select your kaotic_zombies mod directory as the source
4. Select the zone file: `zm_mod\zone_source\kaotic_zombies.zone`
5. Set the output to your mod directory
6. Run the build/compile/link process
7. Wait for completion and check for .ff files in your mod directory

**If you can't find build tools:**
- The Mod Tools interface may have changed or you may have a different version
- Try searching for "zone" or "build" in the Mod Tools interface
- Check the Mod Tools documentation for your specific version
- Consider using community modding tools or scripts

**Alternative: Pre-built Mod**
- If you cannot build the mod yourself, look for pre-built releases
- Check the GitHub Releases page for compiled versions
- Pre-built mods include the necessary .ff files and don't require building

**Verification:**
- After building, check that `.ff` files exist in your mod directory
- Look for files like `kaotic_zombies.ff` or similar in the mod directory
- If build fails, check the Mod Tools console for error messages

### Troubleshooting
- If the mod doesn't appear in the game menu, ensure it was built successfully
- Check that the .ff files exist in the mod directory after building
- Rebuild the mod after making any GSC script changes

## TikFinity Setup

### HTTP Listener

The mod includes `KaoticListener.exe`, a lightweight Windows application that:
- Listens for HTTP requests on `http://127.0.0.1:8080/`
- Queues events and communicates with the game via file-based IPC
- Writes events to `zm_mod/events.json` in the mod directory
- Logs all activity to `%LOCALAPPDATA%\KaoticZombies\listener.log`
- Shows a console window with real-time activity

**Starting the Listener:**
- Run `KaoticListener.exe` from the mod directory
- A console window will open showing the listener status and activity
- You should see: `[HH:mm:ss] Listener started` and `Listening on http://127.0.0.1:8080/`
- Keep the console window open while playing
- The console will show all incoming webhook requests and event delivery status

### Webhook Configuration

Configure TikFinity webhooks to point to the local HTTP listener:

1. Open TikFinity
2. Go to **Settings** → **Webhooks**
3. Click **Add New Webhook** for each event you want to use
4. Configure each webhook:
   - **Webhook URL**: `http://127.0.0.1:8080/[event_name]` (replace `[event_name]` with the actual event, e.g., `http://127.0.0.1:8080/give_random_weapon`)
   - **Method**: POST

**Important**: The event name must be part of the URL path, not a query parameter. The URL should look like `http://127.0.0.1:8080/give_random_weapon`, NOT `http://127.0.0.1:8080/` or `http://127.0.0.1:8080/?event=give_random_weapon`.

### Available Endpoints

**Weapons**
- `http://127.0.0.1:8080/give_random_weapon` - Spawns a random weapon
- `http://127.0.0.1:8080/give_wall_weapon` - Gives a wall weapon
- `http://127.0.0.1:8080/give_wonder_weapon` - Spawns a wonder weapon
- `http://127.0.0.1:8080/spawn_ray_gun` - Drops a Ray Gun pickup
- `http://127.0.0.1:8080/give_pap_weapon` - Gives a Pack-a-Punched weapon

**Player Effects**
- `http://127.0.0.1:8080/change_weapon` - Swaps to a random weapon
- `http://127.0.0.1:8080/refill_ammo` - Refills current weapon ammo
- `http://127.0.0.1:8080/empty_magazine` - Empties current weapon magazine
- `http://127.0.0.1:8080/max_ammo` - Refills ammo for all weapons
- `http://127.0.0.1:8080/insta_kill` - One-hit kill zombies for 30 seconds
- `http://127.0.0.1:8080/double_points` - 2x score multiplier for 30 seconds

**Enemy Events**
- `http://127.0.0.1:8080/zombie_swarm` - Spawns additional zombies
- `http://127.0.0.1:8080/boss_round` - Spawns a boosted boss zombie
- `http://127.0.0.1:8080/special_enemy` - Spawns a special zombie type
- `http://127.0.0.1:8080/speed_up_zombies` - Increases zombie movement speed
- `http://127.0.0.1:8080/slow_down_zombies` - Decreases zombie movement speed

**Chaos Events**
- `http://127.0.0.1:8080/jump_scare` - Sudden camera shake and sound
- `http://127.0.0.1:8080/screen_shake` - Shakes the player's screen
- `http://127.0.0.1:8080/random_teleport` - Teleports player to random location
- `http://127.0.0.1:8080/low_gravity` - Reduces gravity for players
- `http://127.0.0.1:8080/reverse_controls` - Inverts player controls temporarily
- `http://127.0.0.1:8080/fire_sale` - All mystery boxes are 10 points
- `http://127.0.0.1:8080/carpenter` - Rebuilds all barriers
- `http://127.0.0.1:8080/nuke` - Kills all zombies on the map
- `http://127.0.0.1:8080/random_perk` - Gives a random perk

**Fun Events**
- `http://127.0.0.1:8080/confetti` - Visual confetti effect
- `http://127.0.0.1:8080/funny_sound` - Plays a random sound effect
- `http://127.0.0.1:8080/voice_line` - Plays a random character voice line
- `http://127.0.0.1:8080/disco_mode` - Activates disco lighting effects

### Gift-to-Event Mapping Guide

Assign gifts to events based on their value:

**Low-Value Gifts (Rose, TikTok, Finger Hearts)**
- Confetti
- Funny Sound
- Random Voice Line
- Refill Ammo
- Empty Magazine

**Mid-Value Gifts (Shares, Comments, Small Gifts)**
- Give Random Weapon
- Give Wall Weapon
- Change Current Weapon
- Screen Shake
- Jump Scare
- Slow Down Zombies
- Speed Up Zombies

**High-Value Gifts (Medium Gifts)**
- Max Ammo
- Instant Kill
- Double Points
- Random Teleport
- Low Gravity
- Spawn Mini Horde
- Random Perk

**Premium Gifts (Expensive Gifts)**
- Give Wonder Weapon
- Spawn Ray Gun Pickup
- Spawn Pack-a-Punched Weapon
- Spawn Heavy Zombie
- Spawn Special Enemy
- Reverse Controls
- Fire Sale
- Carpenter
- Nuke
- Disco Mode

## Usage

1. Start KaoticListener.exe
2. Start Black Ops 3 Zombies with the mod loaded
3. Start your TikTok live stream with Tikfinity enabled
4. Viewers send gifts to trigger events
5. Events trigger instantly in-game

### In-Game Verification

When the mod loads successfully, you'll see:
```
KAOTIC INTERACTIVE LOADED
```

When an event is triggered:
```
KAOTIC: [event_name]
```

### Listener Logs

Check the listener log at `%LOCALAPPDATA%\KaoticZombies\listener.log` for troubleshooting:
```
[12:41:15] Listener started
[12:41:20] POST /jump_scare
[12:41:20] Queued: jump_scare
[12:41:20] Delivered to BO3
```

## Verification Checklist

A successful setup should look like this:

1. ✅ Install Kaotic Zombies mod
2. ✅ Launch Black Ops 3 Zombies with the mod loaded
3. ✅ Start KaoticListener.exe
4. ✅ Verify listener logs show "Listener started"
5. ✅ Open TikFinity
6. ✅ Configure webhooks to point to `http://127.0.0.1:8080/[event]`
7. ✅ Connect TikFinity to TikTok LIVE
8. ✅ Click "Test" on an Action in TikFinity
9. ✅ Verify listener receives the request in logs
10. ✅ Verify the game executes the event immediately
11. ✅ A viewer sends a gift
12. ✅ The mapped event executes in-game

## Troubleshooting

### Mod Not Loading

- **Verify installation**: Ensure installer completed successfully or files are in correct directory
- **Check launch parameters**: Ensure `+set fs_game mods/kaotic_zombies` is in launch parameters (manual install only)
- **Check console**: Look for "KAOTIC INTERACTIVE LOADED" message
- **Verify files**: Ensure all mod files are in the correct directory

### Events Not Triggering

- **Check listener is running**: Verify KaoticListener.exe is running
- **Check listener logs**: Look for "Listener started" in `%LOCALAPPDATA%\KaoticZombies\listener.log`
- **Verify webhook URLs**: Ensure webhooks point to `http://127.0.0.1:8080/[event]`
- **Test webhooks**: Use TikFinity's "Test" button to verify listener receives requests
- **Check game console**: Look for error messages when events are triggered

### Listener Issues

- **Port already in use**: If port 8080 is already in use, the listener will fail to start
- **Permission denied**: Run KaoticListener.exe as Administrator if needed
- **Check logs**: Review `%LOCALAPPDATA%\KaoticZombies\listener.log` for error messages
- **Invalid endpoint errors**: If you see "Invalid endpoint:" in the logs, your TikFinity webhook URL is incorrect. Ensure the URL includes the event name in the path (e.g., `http://127.0.0.1:8080/give_random_weapon`), not just `http://127.0.0.1:8080/`

### Installer Issues

- **Run as Administrator**: Ensure installer is run with admin privileges
- **Check BO3 path**: Ensure the correct BO3 installation folder is selected
- **Verify disk space**: Ensure sufficient disk space for installation

## License

This mod is provided as-is for educational and entertainment purposes. Respect TikTok's Terms of Service and BO3's modding guidelines.
