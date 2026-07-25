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

## Installation

1. Download the mod files from [GitHub Releases](https://github.com/KaoticKricket/kaotic-zombies-mod/releases/latest)
2. Extract to your BO3 mods directory: `<BO3 Path>\mods\kaotic_zombies\`
3. Add launch parameters (see below)
4. Start Black Ops 3 Zombies

### Adding Launch Parameters

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

**Example Target:**
```
"C:\Program Files (x86)\Steam\steamapps\common\Call of Duty Black Ops III\blackops3.exe" +set fs_game mods/kaotic_zombies
```

## Tikfinity Setup

### How to Configure Webhooks

1. Open Tikfinity and go to **Settings** → **Webhooks**
2. Click **Add New Webhook**
3. Configure the webhook for your desired event (example: Finger Hearts)

### Example: Trigger zombie_swarm on Finger Hearts

**Webhook Configuration:**
- **Event**: Finger Hearts
- **Webhook URL**: Leave blank (Tikfinity handles this internally)
- **Action**: Set Dvar
- **Dvar Name**: `kaotic_event_name`
- **Dvar Value**: `zombie_swarm`

**Alternative Method - Console Command:**
- **Event**: Finger Hearts
- **Action**: Execute Console Command
- **Command**: `set kaotic_event_name zombie_swarm`

### Available Events

Configure these Dvar values for different events:

| Event Name | Dvar Value | Description |
|------------|------------|-------------|
| Finger Hearts | `zombie_swarm` | Spawns (5 + round_number) zombies near players |
| Rose | `boss_round` | Spawns a 5x health, 2x damage boss zombie |
| TikTok | `powerup_drop` | Drops random power-up near each player |
| Gifts | `max_ammo` | Refills ammo for all player weapons |
| Shares | `insta_kill` | One-hit kill zombies for 30 seconds |
| Comments | `double_points` | 2x score multiplier for 30 seconds |

## Usage

1. **Start Black Ops 3 Zombies** with the mod loaded
2. **Start your TikTok live stream** with Tikfinity enabled
3. **Viewers can now trigger events** by sending the configured interactions

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

- **Verify launch parameters**: Ensure `+set fs_game mods/kaotic_zombies` is in launch parameters
- **Check console**: Look for "KAOTIC INTERACTIVE LOADED" message
- **Verify files**: Ensure all mod files are in the correct directory

### Events Not Triggering

- **Check Tikfinity configuration**: Ensure Dvar name is exactly `kaotic_event_name`
- **Verify Dvar value**: Use exact event names from the list above
- **Check game console**: Look for error messages when events are triggered

## License

This mod is provided as-is for educational and entertainment purposes. Respect TikTok's Terms of Service and BO3's modding guidelines.
