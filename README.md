# Kaotic Zombies

A TikTok/Tikfinity integration mod for Black Ops 3 Zombies that allows viewers to trigger interactive events in-game.

## Features

- **TikTok/Tikfinity Integration**: Connect your TikTok live streams to BO3 Zombies gameplay
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

### Option 1: Windows Installer (Recommended)

1. Download `KaoticZombiesMod-Setup.exe` from [GitHub Releases](https://github.com/KaoticKricket/kaotic-zombies-mod/releases/latest)
2. Run the installer as Administrator
3. Select your Black Ops 3 installation directory
4. Complete the installation

### Option 2: Manual Installation

1. Download the mod files from [GitHub Releases](https://github.com/KaoticKricket/kaotic-zombies-mod/releases/latest)
2. Extract to your BO3 mods directory: `<BO3 Path>\mods\kaotic_zombies\`
3. Add to your server launch parameters: `+set fs_game mods/kaotic_zombies`
4. Start your BO3 dedicated server

## Configuration

### TikTok/Tikfinity Setup

In your TikTok/Tikfinity settings, configure webhooks to call these in-game events:

**Webhook URL**: Use Tikfinity's built-in webhook system to trigger events directly in-game

**Available Events**:
- `zombie_swarm` - Spawns (5 + round_number) zombies near players
- `boss_round` - Spawns a 5x health, 2x damage boss zombie
- `powerup_drop` - Drops random power-up near each player
- `max_ammo` - Refills ammo for all player weapons
- `insta_kill` - One-hit kill zombies for 30 seconds
- `double_points` - 2x score multiplier for 30 seconds

## Usage

1. **Start your BO3 dedicated server** with the mod loaded
2. **Start your TikTok live stream** with Tikfinity enabled
3. **Configure Tikfinity webhooks** to trigger the events listed above
4. **Viewers can now trigger events** by sending gifts/interactions

### In-Game Verification

When the mod loads successfully, you'll see:
```
KAOTIC INTERACTIVE LOADED
```

When an event is triggered:
```
KAOTIC: ZOMBIE SWARM ACTIVATED
KAOTIC: SPAWNED 12 ZOMBIES
```

## Troubleshooting

### Mod Not Loading

- **Verify server config**: Ensure `+set fs_game mods/kaotic_zombies` is in launch parameters
- **Check console**: Look for "KAOTIC INTERACTIVE LOADED" message
- **Verify files**: Ensure all mod files are in the correct directory

### Events Not Triggering

- **Check Tikfinity configuration**: Ensure webhooks are properly configured
- **Verify event names**: Use exact event names from the list above
- **Check server console**: Look for error messages when events are triggered

## License

This mod is provided as-is for educational and entertainment purposes. Respect TikTok's Terms of Service and BO3's modding guidelines.
