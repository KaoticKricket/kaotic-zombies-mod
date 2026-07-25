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
9. Configure TikFinity webhooks (see below)

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

### Manual Webhook Configuration

Since the mod uses direct Dvar integration, you'll need to configure webhooks in TikFinity manually. Here's how:

1. Open TikFinity
2. Go to **Settings** → **Webhooks**
3. Click **Add New Webhook** for each event you want to use
4. Configure each webhook using the settings below

### Webhook Configuration Format

For each webhook, use these settings:
- **Webhook URL**: Leave blank (Tikfinity handles this internally)
- **Action**: Set Dvar
- **Dvar Name**: `kaotic_event_name`
- **Dvar Value**: Use the event name from the list below

**Alternative Method - Console Command:**
- **Action**: Execute Console Command
- **Command**: `set kaotic_event_name [event_name]`

### Available Events

Configure these Dvar values for different events:

**Weapons**
| Event Name | Dvar Value | Description |
|------------|------------|-------------|
| Give Random Weapon | `give_random_weapon` | Spawns a random weapon for the player |
| Give Wall Weapon | `give_wall_weapon` | Gives a weapon from the current map's wall buys |
| Give Wonder Weapon | `give_wonder_weapon` | Spawns a powerful wonder weapon |
| Spawn Ray Gun Pickup | `spawn_ray_gun` | Drops a Ray Gun pickup |
| Spawn Pack-a-Punched Weapon | `give_pap_weapon` | Gives a Pack-a-Punched weapon |

**Player Effects**
| Event Name | Dvar Value | Description |
|------------|------------|-------------|
| Change Current Weapon | `change_weapon` | Swaps to a random weapon |
| Refill Ammo | `refill_ammo` | Refills current weapon ammo |
| Empty Magazine | `empty_magazine` | Empties current weapon magazine |
| Max Ammo | `max_ammo` | Refills ammo for all weapons |
| Instant Kill | `insta_kill` | One-hit kill zombies for 30 seconds |
| Double Points | `double_points` | 2x score multiplier for 30 seconds |

**Enemy Events**
| Event Name | Dvar Value | Description |
|------------|------------|-------------|
| Spawn Mini Horde | `zombie_swarm` | Spawns additional zombies |
| Spawn Heavy Zombie | `boss_round` | Spawns a boosted boss zombie |
| Spawn Special Enemy | `special_enemy` | Spawns a special zombie type |
| Speed Up Zombies | `speed_up_zombies` | Increases zombie movement speed |
| Slow Down Zombies | `slow_down_zombies` | Decreases zombie movement speed |

**Chaos Events**
| Event Name | Dvar Value | Description |
|------------|------------|-------------|
| Jump Scare | `jump_scare` | Sudden camera shake and sound |
| Screen Shake | `screen_shake` | Shakes the player's screen |
| Random Teleport | `random_teleport` | Teleports player to random location |
| Low Gravity | `low_gravity` | Reduces gravity for players |
| Reverse Controls | `reverse_controls` | Inverts player controls temporarily |
| Fire Sale | `fire_sale` | All mystery boxes are 10 points |
| Carpenter | `carpenter` | Rebuilds all barriers |
| Nuke | `nuke` | Kills all zombies on the map |
| Random Perk | `random_perk` | Gives a random perk |

**Fun Events**
| Event Name | Dvar Value | Description |
|------------|------------|-------------|
| Confetti | `confetti` | Visual confetti effect |
| Funny Sound | `funny_sound` | Plays a random sound effect |
| Random Voice Line | `voice_line` | Plays a random character voice line |
| Disco Mode | `disco_mode` | Activates disco lighting effects |

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

### Customizing Gift Assignments

To change which gifts trigger which events:

1. Open TikFinity
2. Go to **Settings** → **Gifts**
3. Select a gift from the list
4. Click **Edit** or **Assign Webhook**
5. Select the webhook you want to assign
6. Save the changes

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
