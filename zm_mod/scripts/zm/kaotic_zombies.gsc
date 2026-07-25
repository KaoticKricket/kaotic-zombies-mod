function main()
{
    level thread kaotic_interactive_init();
}

// File-based IPC protocol:
// HTTP listener writes event names to events.json in the zm_mod directory
// GSC polls this file every frame and executes events
function kaotic_interactive_init()
{
    wait(5);
    iprintlnbold("KAOTIC INTERACTIVE LOADED");
    iprintlnbold("Event file: events.json");
    level.kaotic_last_event = "";
    level.kaotic_event_file_path = "zm_mod/events.json";
    level thread kaotic_event_receiver();
}

function kaotic_event_receiver()
{
    for(;;)
    {
        event_name = kaotic_read_event_file();
        if(event_name != "" && event_name != level.kaotic_last_event)
        {
            level.kaotic_last_event = event_name;
            level thread kaotic_dispatch_event(event_name);
        }
        wait(0.05); // Poll every 50ms
    }
}

function kaotic_read_event_file()
{
    file_path = level.kaotic_event_file_path;
    
    // Check if file exists
    if(!FileExists(file_path))
    {
        return "";
    }
    
    // Read file content
    file_handle = fopen(file_path, "r");
    if(!isdefined(file_handle))
    {
        return "";
    }
    
    content = fread(file_handle, 256);
    fclose(file_handle);
    
    if(!isdefined(content) || content == "")
    {
        return "";
    }
    
    // Remove any whitespace/newlines
    event_name = StrTok(content, "\n")[0];
    event_name = StrTok(event_name, "\r")[0];
    
    return event_name;
}

function kaotic_dispatch_event(event_name)
{
    iprintlnbold("KAOTIC: " + event_name);
    
    // Weapons
    if(event_name == "give_random_weapon")
    {
        level thread kaotic_give_random_weapon();
        return;
    }
    if(event_name == "give_wall_weapon")
    {
        level thread kaotic_give_wall_weapon();
        return;
    }
    if(event_name == "give_wonder_weapon")
    {
        level thread kaotic_give_wonder_weapon();
        return;
    }
    if(event_name == "spawn_ray_gun")
    {
        level thread kaotic_spawn_ray_gun();
        return;
    }
    if(event_name == "give_pap_weapon")
    {
        level thread kaotic_give_pap_weapon();
        return;
    }

    // Player Effects
    if(event_name == "change_weapon")
    {
        level thread kaotic_change_weapon();
        return;
    }
    if(event_name == "refill_ammo")
    {
        level thread kaotic_refill_ammo();
        return;
    }
    if(event_name == "empty_magazine")
    {
        level thread kaotic_empty_magazine();
        return;
    }
    if(event_name == "max_ammo")
    {
        level thread kaotic_max_ammo();
        return;
    }
    if(event_name == "insta_kill")
    {
        level thread kaotic_insta_kill();
        return;
    }
    if(event_name == "double_points")
    {
        level thread kaotic_double_points();
        return;
    }

    // Enemy Events
    if(event_name == "zombie_swarm")
    {
        level thread kaotic_zombie_swarm();
        return;
    }
    if(event_name == "boss_round")
    {
        level thread kaotic_boss_round();
        return;
    }
    if(event_name == "special_enemy")
    {
        level thread kaotic_special_enemy();
        return;
    }
    if(event_name == "speed_up_zombies")
    {
        level thread kaotic_speed_up_zombies();
        return;
    }
    if(event_name == "slow_down_zombies")
    {
        level thread kaotic_slow_down_zombies();
        return;
    }

    // Chaos Events
    if(event_name == "jump_scare")
    {
        level thread kaotic_jump_scare();
        return;
    }
    if(event_name == "screen_shake")
    {
        level thread kaotic_screen_shake();
        return;
    }
    if(event_name == "random_teleport")
    {
        level thread kaotic_random_teleport();
        return;
    }
    if(event_name == "low_gravity")
    {
        level thread kaotic_low_gravity();
        return;
    }
    if(event_name == "reverse_controls")
    {
        level thread kaotic_reverse_controls();
        return;
    }
    if(event_name == "fire_sale")
    {
        level thread kaotic_fire_sale();
        return;
    }
    if(event_name == "carpenter")
    {
        level thread kaotic_carpenter();
        return;
    }
    if(event_name == "nuke")
    {
        level thread kaotic_nuke();
        return;
    }
    if(event_name == "random_perk")
    {
        level thread kaotic_random_perk();
        return;
    }

    // Fun Events
    if(event_name == "confetti")
    {
        level thread kaotic_confetti();
        return;
    }
    if(event_name == "funny_sound")
    {
        level thread kaotic_funny_sound();
        return;
    }
    if(event_name == "voice_line")
    {
        level thread kaotic_voice_line();
        return;
    }
    if(event_name == "disco_mode")
    {
        level thread kaotic_disco_mode();
        return;
    }

    iprintlnbold("KAOTIC: UNKNOWN EVENT " + event_name);
}

function kaotic_zombie_swarm()
{
    iprintlnbold("KAOTIC: ZOMBIE SWARM ACTIVATED");
    
    // Spawn additional zombies based on current round
    if(!isdefined(level.zombie_vars))
    {
        return;
    }
    
    current_round = level.round_number;
    zombie_count = 5 + current_round; // Scale with round
    
    // Get player positions to spawn near them
    players = GetPlayers();
    if(players.size == 0)
    {
        return;
    }
    
    for(i = 0; i < zombie_count; i++)
    {
        player = players[i % players.size];
        spawn_pos = player.origin + (RandomFloatRange(-200, 200), RandomFloatRange(-200, 200), 0);
        
        // Spawn zombie using BO3 API
        ai = SpawnZombie(spawn_pos);
        if(isdefined(ai))
        {
            ai.goalradius = 1000;
            ai.ignoreme = false;
        }
        
        wait(0.1);
    }
    
    iprintlnbold("KAOTIC: SPAWNED " + zombie_count + " ZOMBIES");
}

function kaotic_boss_round()
{
    iprintlnbold("KAOTIC: BOSS ROUND ACTIVATED");
    
    // Trigger a mini boss round
    if(!isdefined(level.zombie_vars))
    {
        return;
    }
    
    // Spawn a special zombie (Margwa or similar boss-type)
    players = GetPlayers();
    if(players.size == 0)
    {
        return;
    }
    
    player = players[0];
    spawn_pos = player.origin + (0, 200, 0);
    
    // Try to spawn a Margwa if available, otherwise spawn a regular zombie with boosted stats
    ai = SpawnZombie(spawn_pos);
    if(isdefined(ai))
    {
        ai.health = ai.health * 5; // 5x health
        ai.damage_multiplier = 2; // 2x damage
        ai.goalradius = 2000;
        ai.ignoreme = false;
        
        // Mark as boss
        ai.is_kaotic_boss = true;
        
        iprintlnbold("KAOTIC: BOSS SPAWNED");
    }
}

function kaotic_powerup_drop()
{
    iprintlnbold("KAOTIC: POWER-UP DROP");
    
    // Drop random powerup near each player
    players = GetPlayers();
    if(players.size == 0)
    {
        return;
    }
    
    powerups = array("zombie_max_ammo", "zombie_nuke", "zombie_insta_kill", "zombie_double_points", "zombie_fire_sale", "zombie_free_perk");
    
    foreach(player in players)
    {
        // Drop random powerup
        powerup = powerups[RandomInt(powerups.size)];
        drop_pos = player.origin + (RandomFloatRange(-100, 100), RandomFloatRange(-100, 100), 0);
        
        // Use BO3 powerup drop function
        if(isdefined(level.powerup_drop))
        {
            level.powerup_drop(powerup, drop_pos);
        }
        else
        {
            // Fallback: spawn powerup directly
            powerup_ent = Spawn("script_model", drop_pos);
            powerup_ent SetModel("tag_origin");
            powerup_ent.powerup_name = powerup;
        }
        
        wait(0.2);
    }
}

function kaotic_max_ammo()
{
    iprintlnbold("KAOTIC: MAX AMMO");
    
    players = GetPlayers();
    foreach(player in players)
    {
        // Give max ammo to all weapons
        weapons = player GetWeaponsList();
        foreach(weapon in weapons)
        {
            player GiveMaxAmmo(weapon);
        }
    }
}

function kaotic_insta_kill()
{
    iprintlnbold("KAOTIC: INSTA-KILL");
    
    // Activate insta-kill for 30 seconds
    if(!isdefined(level.zombie_vars))
    {
        return;
    }
    
    level.zombie_vars["zombie_insta_kill"] = 30;
    
    // Visual indicator
    players = GetPlayers();
    foreach(player in players)
    {
        player PlaySound("zmb_ann_insta_kill");
    }
    
    // Timer to deactivate
    level thread kaotic_timer_function(30, "INSTA-KILL");
}

function kaotic_double_points()
{
    iprintlnbold("KAOTIC: DOUBLE POINTS");
    
    // Activate double points for 30 seconds
    if(!isdefined(level.zombie_vars))
    {
        return;
    }
    
    level.zombie_vars["zombie_score_factor"] = 2;
    
    // Visual indicator
    players = GetPlayers();
    foreach(player in players)
    {
        player PlaySound("zmb_ann_double_points");
    }
    
    // Timer to deactivate
    level thread kaotic_timer_function(30, "DOUBLE POINTS");
}

function kaotic_timer_function(duration, powerup_name)
{
    wait(duration);
    
    if(powerup_name == "INSTA-KILL")
    {
        level.zombie_vars["zombie_insta_kill"] = 0;
    }
    else if(powerup_name == "DOUBLE POINTS")
    {
        level.zombie_vars["zombie_score_factor"] = 1;
    }
    
    iprintlnbold("KAOTIC: " + powerup_name + " ENDED");
}

// Weapons
function kaotic_give_random_weapon()
{
    iprintlnbold("KAOTIC: RANDOM WEAPON");
    
    players = GetPlayers();
    foreach(player in players)
    {
        weapons = array("ar_standard", "smg_standard", "shotgun_standard", "lmg_standard", "pistol_standard");
        random_weapon = weapons[RandomInt(weapons.size)];
        player GiveWeapon(random_weapon);
        player SwitchToWeapon(random_weapon);
    }
}

function kaotic_give_wall_weapon()
{
    iprintlnbold("KAOTIC: WALL WEAPON");
    
    players = GetPlayers();
    foreach(player in players)
    {
        // Give a common wall weapon
        player GiveWeapon("ar_standard");
        player SwitchToWeapon("ar_standard");
    }
}

function kaotic_give_wonder_weapon()
{
    iprintlnbold("KAOTIC: WONDER WEAPON");
    
    players = GetPlayers();
    foreach(player in players)
    {
        // Try to give a wonder weapon (ray gun if available)
        player GiveWeapon("ray_gun");
        player SwitchToWeapon("ray_gun");
    }
}

function kaotic_spawn_ray_gun()
{
    iprintlnbold("KAOTIC: RAY GUN PICKUP");
    
    players = GetPlayers();
    foreach(player in players)
    {
        drop_pos = player.origin + (RandomFloatRange(-50, 50), RandomFloatRange(-50, 50), 0);
        weapon_ent = Spawn("script_model", drop_pos);
        weapon_ent SetModel("tag_origin");
        weapon_ent.weapon_name = "ray_gun";
    }
}

function kaotic_give_pap_weapon()
{
    iprintlnbold("KAOTIC: PACK-A-PUNCHED WEAPON");
    
    players = GetPlayers();
    foreach(player in players)
    {
        // Give a Pack-a-Punched weapon
        player GiveWeapon("ar_standard_upgraded");
        player SwitchToWeapon("ar_standard_upgraded");
    }
}

// Player Effects
function kaotic_change_weapon()
{
    iprintlnbold("KAOTIC: CHANGE WEAPON");
    
    players = GetPlayers();
    foreach(player in players)
    {
        weapons = player GetWeaponsList();
        if(weapons.size > 1)
        {
            current_weapon = player GetCurrentWeapon();
            new_weapon = weapons[RandomInt(weapons.size)];
            if(new_weapon != current_weapon)
            {
                player SwitchToWeapon(new_weapon);
            }
        }
    }
}

function kaotic_refill_ammo()
{
    iprintlnbold("KAOTIC: REFILL AMMO");
    
    players = GetPlayers();
    foreach(player in players)
    {
        current_weapon = player GetCurrentWeapon();
        player GiveMaxAmmo(current_weapon);
    }
}

function kaotic_empty_magazine()
{
    iprintlnbold("KAOTIC: EMPTY MAGAZINE");
    
    players = GetPlayers();
    foreach(player in players)
    {
        current_weapon = player GetCurrentWeapon();
        player SetWeaponAmmoClip(current_weapon, 0);
    }
}

// Enemy Events
function kaotic_special_enemy()
{
    iprintlnbold("KAOTIC: SPECIAL ENEMY");
    
    players = GetPlayers();
    if(players.size == 0)
    {
        return;
    }
    
    player = players[0];
    spawn_pos = player.origin + (0, 200, 0);
    
    ai = SpawnZombie(spawn_pos);
    if(isdefined(ai))
    {
        ai.health = ai.health * 3;
        ai.goalradius = 1500;
        ai.ignoreme = false;
    }
}

function kaotic_speed_up_zombies()
{
    iprintlnbold("KAOTIC: SPEED UP ZOMBIES");
    
    level.zombie_move_speed_multiplier = 1.5;
    level thread kaotic_timer_function(15, "SPEED UP");
}

function kaotic_slow_down_zombies()
{
    iprintlnbold("KAOTIC: SLOW DOWN ZOMBIES");
    
    level.zombie_move_speed_multiplier = 0.5;
    level thread kaotic_timer_function(15, "SLOW DOWN");
}

// Chaos Events
function kaotic_jump_scare()
{
    iprintlnbold("KAOTIC: JUMP SCARE");
    
    players = GetPlayers();
    foreach(player in players)
    {
        player PlaySound("zmb_announcer_warning");
        // Screen shake effect
        Earthquake(0.5, 1, player.origin, 100);
    }
}

function kaotic_screen_shake()
{
    iprintlnbold("KAOTIC: SCREEN SHAKE");
    
    players = GetPlayers();
    foreach(player in players)
    {
        Earthquake(0.3, 2, player.origin, 100);
    }
}

function kaotic_random_teleport()
{
    iprintlnbold("KAOTIC: RANDOM TELEPORT");
    
    players = GetPlayers();
    foreach(player in players)
    {
        // Teleport to random location near current position
        new_origin = player.origin + (RandomFloatRange(-500, 500), RandomFloatRange(-500, 500), 0);
        player SetOrigin(new_origin);
    }
}

function kaotic_low_gravity()
{
    iprintlnbold("KAOTIC: LOW GRAVITY");
    
    players = GetPlayers();
    foreach(player in players)
    {
        player SetClientDvar("jump_height", "150");
    }
    
    level thread kaotic_timer_function(20, "LOW GRAVITY");
}

function kaotic_reverse_controls()
{
    iprintlnbold("KAOTIC: REVERSE CONTROLS");
    
    // Reverse controls for 10 seconds
    level thread kaotic_timer_function(10, "REVERSE CONTROLS");
}

function kaotic_fire_sale()
{
    iprintlnbold("KAOTIC: FIRE SALE");
    
    if(!isdefined(level.zombie_vars))
    {
        return;
    }
    
    level.zombie_vars["zombie_fire_sale_time"] = 30;
    level thread kaotic_timer_function(30, "FIRE SALE");
}

function kaotic_carpenter()
{
    iprintlnbold("KAOTIC: CARPENTER");
    
    // Rebuild all barriers
    if(isdefined(level.barrier_rebuild_all))
    {
        level.barrier_rebuild_all();
    }
}

function kaotic_nuke()
{
    iprintlnbold("KAOTIC: NUKE");
    
    // Kill all zombies
    zombies = GetAISpeciesArray("axis");
    foreach(zombie in zombies)
    {
        zombie DoDamage(zombie.health + 100, zombie.origin);
    }
}

function kaotic_random_perk()
{
    iprintlnbold("KAOTIC: RANDOM PERK");
    
    perks = array("specialty_armorvest", "specialty_fastreload", "specialty_additionalprimaryweapon", "specialty_longersprint");
    
    players = GetPlayers();
    foreach(player in players)
    {
        random_perk = perks[RandomInt(perks.size)];
        player GivePerk(random_perk);
    }
}

// Fun Events
function kaotic_confetti()
{
    iprintlnbold("KAOTIC: CONFETTI");
    
    players = GetPlayers();
    foreach(player in players)
    {
        // Visual effect - could be enhanced with FX
        player PlaySound("zmb_announcer_complete");
    }
}

function kaotic_funny_sound()
{
    iprintlnbold("KAOTIC: FUNNY SOUND");
    
    players = GetPlayers();
    foreach(player in players)
    {
        player PlaySound("zmb_zombie_laugh");
    }
}

function kaotic_voice_line()
{
    iprintlnbold("KAOTIC: VOICE LINE");
    
    players = GetPlayers();
    foreach(player in players)
    {
        player PlaySound("zmb_vox_richtofen_laugh");
    }
}

function kaotic_disco_mode()
{
    iprintlnbold("KAOTIC: DISCO MODE");
    
    // Disco lighting effect
    level thread kaotic_disco_mode_thread();
    level thread kaotic_timer_function(30, "DISCO MODE");
}

function kaotic_disco_mode_thread()
{
    colors = array((1, 0, 0), (0, 1, 0), (0, 0, 1), (1, 1, 0), (1, 0, 1), (0, 1, 1));
    
    for(i = 0; i < 60; i++)
    {
        color = colors[i % colors.size];
        // Set lighting color (implementation depends on BO3 lighting system)
        wait(0.5);
    }
}
