# Kaotic Zombies

A TikTok/Tikfinity integration mod for Black Ops 3 Zombies that allows viewers to trigger interactive events in-game.

## Features

- **TikTok/Tikfinity Integration**: Connect your TikTok live streams to BO3 Zombies gameplay
- **Interactive Events**: Multiple viewer-triggerable events across categories:
  - **Weapons**: Random weapons, wall weapons, wonder weapons, ray gun spawns
  - **Player Effects**: Ammo refill, instant kill, double points, weapon changes
  - **Enemy Events**: Zombie swarms, boss rounds, special enemies, speed modifiers
  - **Chaos Events**: Jump scares, screen shake, teleportation, gravity changes
  - **Fun Events**: Confetti, sounds, disco mode, voice lines

## Requirements

- Black Ops 3 (PC)
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

### Manual Installation

1. Download the mod files from [GitHub Releases](https://github.com/KaoticKricket/kaotic-zombies-mod/releases/latest)
2. Extract to your BO3 mods directory: `<BO3 Path>\mods\kaotic_zombies\`
3. Add launch parameters (see below)
4. Start Black Ops 3 Zombies

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

## TikFinity Setup

### Quick Setup (Plug-and-Play)

1. Open TikFinity
2. Import the included profile: `TikFinity/kaotic_zombies_profile.tfc`
3. Connect your TikTok LIVE
4. Press Start
5. That's it!

No additional software. No servers. No bridge. No RCON. No networking configuration.

### Customizing Gift Assignments

The included profile comes with pre-configured gift-to-event assignments. To customize:

1. Open TikFinity
2. Open the imported Kaotic Zombies profile
3. Select a gift from the list
4. Change the webhook assignment to a different event
5. Save the profile

### Available Webhook Events

**Weapons**
- Give Random Weapon - Spawns a random weapon for the player
- Give Wall Weapon - Gives a weapon from the current map's wall buys
- Give Wonder Weapon - Spawns a powerful wonder weapon
- Spawn Ray Gun Pickup - Drops a Ray Gun pickup
- Spawn Pack-a-Punched Weapon - Gives a Pack-a-Punched weapon

**Player Effects**
- Change Current Weapon - Swaps to a random weapon
- Refill Ammo - Refills current weapon ammo
- Empty Magazine - Empties current weapon magazine
- Max Ammo - Refills ammo for all weapons
- Instant Kill - One-hit kill zombies for 30 seconds
- Double Points - 2x score multiplier for 30 seconds

**Enemy Events**
- Spawn Mini Horde - Spawns additional zombies
- Spawn Heavy Zombie - Spawns a boosted boss zombie
- Spawn Special Enemy - Spawns a special zombie type
- Speed Up Zombies - Increases zombie movement speed
- Slow Down Zombies - Decreases zombie movement speed

**Chaos Events**
- Jump Scare - Sudden camera shake and sound
- Screen Shake - Shakes the player's screen
- Random Teleport - Teleports player to random location
- Low Gravity - Reduces gravity for players
- Reverse Controls - Inverts player controls temporarily
- Fire Sale - All mystery boxes are 10 points
- Carpenter - Rebuilds all barriers
- Nuke - Kills all zombies on the map
- Random Perk - Gives a random perk

**Fun Events**
- Confetti - Visual confetti effect
- Funny Sound - Plays a random sound effect
- Random Voice Line - Plays a random character voice line
- Disco Mode - Activates disco lighting effects

## Usage

1. Start Black Ops 3 Zombies with the mod loaded
2. Start your TikTok live stream with Tikfinity enabled
3. Viewers send gifts to trigger events
4. Events trigger instantly in-game

### In-Game Verification

When the mod loads successfully, you'll see:
```
KAOTIC INTERACTIVE LOADED
```

When an event is triggered:
```
KAOTIC: EVENT ACTIVATED
```

## Troubleshooting

### Mod Not Loading

- **Verify installation**: Ensure installer completed successfully or files are in correct directory
- **Check launch parameters**: Ensure `+set fs_game mods/kaotic_zombies` is in launch parameters (manual install only)
- **Check console**: Look for "KAOTIC INTERACTIVE LOADED" message
- **Verify files**: Ensure all mod files are in the correct directory

### Events Not Triggering

- **Check Tikfinity profile**: Ensure the profile is imported and active
- **Verify webhook assignments**: Ensure gifts are assigned to webhooks
- **Check game console**: Look for error messages when events are triggered
- **Restart Tikfinity**: Try restarting Tikfinity after importing the profile

### Installer Issues

- **Run as Administrator**: Ensure installer is run with admin privileges
- **Check BO3 path**: Ensure the correct BO3 installation folder is selected
- **Verify disk space**: Ensure sufficient disk space for installation

## License

This mod is provided as-is for educational and entertainment purposes. Respect TikTok's Terms of Service and BO3's modding guidelines.
