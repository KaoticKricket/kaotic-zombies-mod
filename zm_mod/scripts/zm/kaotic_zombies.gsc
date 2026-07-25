function main()
{
    level thread kaotic_interactive_init();
}

// RCON bridge protocol:
// 1. set kaotic_event_name <event id>
// 2. set kaotic_event_id <unique id>
// 3. set kaotic_creator_id <creator id>
// The event id must change for every gift. RCON sends the name first, then the id.
// This works with the supported BO3 dedicated-server console and requires no client injection.
function kaotic_interactive_init()
{
    wait(5);
    iprintlnbold("KAOTIC INTERACTIVE LOADED");
    level.kaotic_last_event_id = "";
    level.kaotic_authorized_creators = [];
    level.kaotic_creator_whitelist_loaded = false;
    level thread kaotic_load_creator_whitelist();
    level thread kaotic_event_receiver();
}

function kaotic_load_creator_whitelist()
{
    // Load authorized creators from Dvar (set by Python bridge)
    for(;;)
    {
        creator_list = GetDvarString("kaotic_creator_whitelist", "");
        if(creator_list != "" && !level.kaotic_creator_whitelist_loaded)
        {
            level.kaotic_authorized_creators = StrTok(creator_list, ",");
            level.kaotic_creator_whitelist_loaded = true;
            iprintlnbold("KAOTIC: LOADED " + level.kaotic_authorized_creators.size + " AUTHORIZED CREATORS");
        }
        wait(1);
    }
}

function kaotic_is_creator_authorized(creator_id)
{
    if(!level.kaotic_creator_whitelist_loaded)
    {
        return false;
    }
    
    foreach(creator in level.kaotic_authorized_creators)
    {
        if(creator == creator_id)
        {
            return true;
        }
    }
    return false;
}

function kaotic_event_receiver()
{
    for(;;)
    {
        event_id = GetDvarString("kaotic_event_id", "");
        if(event_id != "" && event_id != level.kaotic_last_event_id)
        {
            level.kaotic_last_event_id = event_id;
            event_name = GetDvarString("kaotic_event_name", "");
            creator_id = GetDvarString("kaotic_creator_id", "");
            
            if(kaotic_is_creator_authorized(creator_id))
            {
                level thread kaotic_dispatch_event(event_name);
            }
            else
            {
                iprintlnbold("KAOTIC: UNAUTHORIZED CREATOR - " + creator_id);
            }
        }
        wait(0.1);
    }
}

function kaotic_dispatch_event(event_name)
{
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

    if(event_name == "powerup_drop")
    {
        level thread kaotic_powerup_drop();
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
