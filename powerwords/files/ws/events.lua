lastTranscript = ""
lastSpeechFrame = GameGetFrameNum()
wsEvents = {
    _speech = function(transcript)
        local show_transcript = ModSettingGet("powerwords.PW_TRANSCRIPT")
        if (not show_transcript) then return end
        if (lastTranscript == transcript) then return end
        --GamePrint(transcript)
        lastTranscript = transcript
        lastSpeechFrame = GameGetFrameNum()
    end,
    Garbage = function()
        for i = 1, Random(10, 20) do
            local prop = random_from_array(props)
            spawn_entity_in_view_random_angle(prop, 40, 200)
        end
    end,
    Zoo = function()
        for i = 1, Random(5, 20) do
            local prop = random_from_array(animals)
            spawn_entity_in_view_random_angle(prop, 40, 200)
        end
    end,
    Bee = function ()
        for i=1, 3 do 
            spawn_entity_in_view_random_angle("data/entities/animals/fly.xml", 10, 280)
        end
    end,
    GoldTouchy = function ()
        for i=1, 10 do 
            spawn_entity_in_view_random_angle("data/entities/projectiles/deck/touch_gold.xml", 10, 280)
        end
    end,
    Acid = function ()
        for i=1, 10 do 
            spawn_entity_in_view_random_angle("data/entities/projectiles/deck/acidshot.xml", 5, 180)
        end
    end,
    Hentai = function ()
        for i=1, 5 do 
            spawn_entity_in_view_random_angle("data/entities/projectiles/deck/tentacle_portal.xml", 25, 200)
        end
    end,
    WormLauncher = function ()
        for i=1, 5 do 
            spawn_entity_in_view_random_angle("data/entities/projectiles/deck/worm_shot.xml", 25, 200)
        end
    end,
    Ukko = function ()
        local r = Random(1, 2)
        for i=1, r do 
            spawn_entity_in_view_random_angle("data/entities/animals/thundermage.xml", 40, 200, 0, function(eid)
                entity_attack_timer(eid, 20000)
            end)
        end
    end,
    Steve = function ()
        local r = Random(1, 2)
        for i=1, r do 
            spawn_entity_in_view_random_angle("data/entities/animals/necromancer_shop.xml", 40, 200)
        end
    end,
    Trip = function ()
        local player = get_player()
        local fungi = CellFactory_GetType("fungi")
        local frame = GameGetFrameNum()
        local last_frame = tonumber( GlobalsGetValue( "fungal_shift_last_frame", "-1000000" ) )
        EntityIngestMaterial( player, fungi, 600 )
    end,
    Tanks = function ()
        local r = Random(1, 4)
        for i=1, r do 
            spawn_entity_in_view_random_angle("data/entities/animals/tank.xml", 40, 200)
        end
    end,
    Cocktail = function ()
        local r = Random(5, 15)
        for i=1, r do 
            spawn_entity_in_view_random_angle("data/entities/animals/goblin_bomb.xml", 40, 200)
        end
    end,
    LavaShift = function ()
        local player = get_player()
        if (player == nil or player <= 0) then return end
        local x, y = EntityGetTransform(player)
        local lavashit = EntityLoad( "data/entities/misc/runestone_lava.xml", x, y )
        local magicComp = EntityGetFirstComponentIncludingDisabled(lavashit, "MagicConvertMaterialComponent")
        if (magicComp ~= nil and magicComp > 0 ) then
            ComponentSetValue2(magicComp, "loop", true)
        end
        EntityRemoveComponent( lavashit, EntityGetFirstComponentIncludingDisabled(lavashit, "LifetimeComponent") )
        EntityAddComponent(lavashit, "LifetimeComponent", {
            lifetime = "600"
        })
        EntityAddComponent(lavashit, "InheritTransformComponent", {
            _tags = "enabled_in_world",
            use_root_parent = "1"
        })
        EntityAddChild(player, lavashit)
    end,
     
    Goblins = function ()
        local r = Random(1, 20)
        for i=1, r do 
            spawn_entity_in_view_random_angle("data/entities/animals/shotgunner.xml", 40, 200)
        end
    end,
    Toasters = function ()
        local r = Random(1, 5)
        for i=1, r do 
            spawn_entity_in_view_random_angle("data/entities/animals/drone_lasership.xml", 40, 200)
        end
    end,
    Sweaty = function()
        local x, y = get_player_pos()
        local emitter = EntityLoad("data/entities/projectiles/deck/sea_water.xml", x, y - 75)
        local emitterComp = EntityGetFirstComponentIncludingDisabled(emitter, "ParticleEmitterComponent")
        local seaComp = EntityGetFirstComponentIncludingDisabled(emitter, "MaterialSeaSpawnerComponent")
        if ((emitterComp ~= nil and emitterComp > 0) and (seaComp ~= nil and seaComp > 0)) then
            ComponentSetValue2(seaComp, "material", CellFactory_GetType("water_salt"))
            ComponentSetValue2(emitterComp, "emitted_material_name", "brine")
        end
        local r = Random(4, 69)
        for i=1, r do 
            spawn_entity_in_view_random_angle("data/entities/animals/fish.xml", 0, 200)
        end
    end,
    Byebye = function()
        local player = get_player()
        if (player == nil) then return end
        local game_effect = GetGameEffectLoadTo(player, "TELEPORTATION", true);
        if game_effect ~= nil then ComponentSetValue(game_effect, "frames", 60); end
    end,
    BlazeIt = function()
        local x, y = get_player_pos()
        EntityLoad("data/entities/projectiles/deck/sea_acid_gas.xml", x, y - 75)
    end,
    ThisIsFine = function()
        local x, y = get_player_pos()
        for _, entity in pairs(EntityGetInRadiusWithTag(x, y, 5000, "enemy") or {}) do
            --GamePrint(tostring(entity))
            GetGameEffectLoadTo( entity, "PROTECTION_FIRE", true );
            EntityAddComponent2( entity, "ShotEffectComponent", { extra_modifier = "BURN_TRAIL" } );
            EntityAddComponent2( entity, "ParticleEmitterComponent", 
                { 
                    emitted_material_name="fire",
                    count_min="6",
                    count_max="8",
                    x_pos_offset_min="-4",
                    y_pos_offset_min="-4",
                    x_pos_offset_max="4",
                    y_pos_offset_max="4",
                    x_vel_min="-10",
                    x_vel_max="10",
                    y_vel_min="-10",
                    y_vel_max="10",
                    lifetime_min="1.1",
                    lifetime_max="2.8",
                    create_real_particles="1",
                    emit_cosmetic_particles="0",
                    emission_interval_min_frames="1",
                    emission_interval_max_frames="1",
                    delay_frames="2",
                    is_emitting="1",
                }) 
            EntityAddComponent2( entity, "ParticleEmitterComponent", 
                { 
                    emitted_material_name="fire",
                    custom_style="FIRE",
                    count_min="1",
                    count_max="1",
                    x_pos_offset_min="0",
                    y_pos_offset_min="0",
                    x_pos_offset_max="0",
                    y_pos_offset_max="0",
                    is_trail="1",
                    trail_gap="1.0",
                    x_vel_min="-5",
                    x_vel_max="5",
                    y_vel_min="-10",
                    y_vel_max="10",
                    lifetime_min="1.1",
                    lifetime_max="2.8",
                    create_real_particles="1",
                    emit_cosmetic_particles="0",
                    emission_interval_min_frames="1",
                    emission_interval_max_frames="1",
                    delay_frames="2",
                    is_emitting="1",
                }) 
        end
    end,
    Coolio = function()
        local r = Random(1, 4)
        for i=1, r do 
            spawn_entity_in_view_random_angle("data/entities/animals/iceskull.xml", 60, 200)
        end
    end,
    Twitch = function()
        local player = get_player()
        if (player == nil) then return end
        local effect = EntityLoad("data/entities/misc/effect_twitchy.xml")
        EntityAddChild(player, effect)
    end,
    Shrooms = function()
        local player = get_player()
        if (player == nil) then return end 
        local pos_x, pos_y, rot = EntityGetTransform( player )
        local how_many = 4
        local angle_inc = ( 2 * 3.14159 ) / how_many
        local theta = rot
        local length = 600
        local name = "fungus"

        for i=1,how_many do
            local vel_x = math.cos( theta ) * length
            local vel_y = 0 - math.sin( theta ) * length

            local bid = shoot_projectile( entity_id, "data/entities/projectiles/" .. name .. ".xml", pos_x + math.cos( theta ) * 12, pos_y - math.sin( theta ) * 12, vel_x, vel_y )
            
            
            theta = theta + angle_inc
        end
    end,
    Eggy = function()
        local r = Random(5, 20)
        for i=1, r do 
            spawn_entity_in_view_random_angle("data/entities/items/pickup/egg_monster.xml", 60, 200)
        end
    end,
    Raid = function()
        local r = Random(1, 10)
        for i=1, r do 
            spawn_entity_in_view_random_angle("data/entities/animals/miner_chef.xml", 60, 250)
        end
        local r2 = Random(1, 10)
        for i=1, r2 do 
            spawn_entity_in_view_random_angle("data/entities/animals/miner_fire.xml", 60, 250)
        end
    end,
    Gamba = function()
        local r = Random(1, 100)
        if (r >= 80) then
            spawn_entity_in_view_random_angle("data/entities/projectiles/deck/regeneration_field_long.xml", 1, 20)
        elseif (r <= 25) then
            return
        elseif (r <= 79) then
            spawn_entity_in_view_random_angle("data/entities/projectiles/circle_acid_die.xml", 1, 20)
        end
    end,
    HolyBomb = function()
        local r = Random(1, 100)
        if (r >= 80) then 
            spawn_entity_in_view_random_angle("data/entities/projectiles/bomb_holy.xml", 1, 20)
        end
    end,
    BeegSteve = function()
        spawn_entity_in_view_random_angle("data/entities/animals/necromancer_super.xml", 100, 300)
    end,
    Cheapskate = function()
        local player = get_player()
        if (player == nil) then return end 
        local wallet = EntityGetFirstComponent(player, "WalletComponent")
        if (wallet ~= nil) then 
            local cur_mons = ComponentGetValue2(wallet, "money")
            local ass = cur_mons >= 100 and cur_mons - 100 or 0
            ComponentSetValue2(wallet, "money", ass)
        end
    end,
    RogueBH = function()
        async(function()
            local distance = 180;
            local samples = 20;
            
            local x, y = get_player_pos()		
            local tx, ty, angle = GetTunelDirectionFromPoint2(x, y, distance, samples)
            
            local bhc = 0;
            local sx, sy = tx + math.cos(angle) * distance,
                           ty + math.sin(angle) * distance;
    
            local black_hole = EntityLoad(
                                   "data/entities/projectiles/deck/black_hole_big.xml",
                                   sx, sy);
            wait(0)
            local ability = EntityGetAllComponents(black_hole)
            
            local grav = 100;
            local max_speed = 50;
            local lifetime = 60*15;
            for _, c in ipairs(ability) do
                if ComponentGetTypeName(c) == "VelocityComponent" then
                    ComponentSetValue(c, "gravity_x", tostring(math.cos(angle)*(-grav)))
                    ComponentSetValue(c, "gravity_y", tostring(math.sin(angle)*(-grav)))
                    ComponentSetValue(c, "terminal_velocity", tostring(max_speed))
                end
                if ComponentGetTypeName(c) == "ProjectileComponent" then
                    ComponentSetValue(c, "lifetime", tostring(lifetime))
                    ComponentSetValue(c, "collide_with_world", tostring(0))
                end
                if ComponentGetTypeName(c) == "ParticleEmitterComponent" then
                    ComponentSetValue(c, "attractor_force", tostring(0))
                end
                if ComponentGetTypeName(c) == "BlackHoleComponent" then
                    bhc = c;
                end
            end
            
            async(function()
                while EntityGetIsAlive(black_hole) do
                    ComponentSetValue(bhc, "particle_attractor_force", tostring(3.75))
                    wait(2)
                end
            end)
        end)
    end,
    Flend = function()
        local r = Random(1, 2)
        for i=1, r do 
            spawn_entity_in_view_random_angle("data/entities/animals/ultimate_killer.xml", 10, 250)
        end
    end,
    Cop = function()
        local r = Random(1, 2)
        for i=1, r do 
            spawn_entity_in_view_random_angle("data/entities/animals/roboguard.xml", 60, 250)
        end
    end,
    Loose = function()
        async(function()
            local x, y = get_player_pos()
            local hit, hx, hy = RaytracePlatforms(x, y, x, y - 500)
            local yy = (y+hy)/2;
            EntityLoad("data/entities/particles/image_emitters/magical_symbol.xml", hx, yy)
            wait(45)
            EntityLoad("data/entities/projectiles/deck/crumbling_earth.xml", hx, yy)
        end)
    end,
    Grounded = function()
        async(function()
            local duration = 60 * 6
            local player_data = EntityGetFirstComponent( get_player(), "CharacterDataComponent")
        
            while player_data == nil do
                wait(60)
                player_data = EntityGetFirstComponent( get_player(), "CharacterDataComponent")
            end
            
            local flytime = ComponentGetValue2(player_data, "mFlyingTimeLeft")
            local recharge = ComponentGetValue2(player_data, "fly_recharge_spd_ground")
            local recharge2 = ComponentGetValue2(player_data, "fly_recharge_spd")
            ComponentSetValue2(player_data, "mFlyingTimeLeft",0)
            while recharge == 0 do
                wait(60)
                recharge = ComponentGetValue2(player_data, "fly_recharge_spd_ground")
            end
            if (get_player() ~= nil) then
                ComponentSetValue2(player_data, "fly_recharge_spd_ground", 0)
                ComponentSetValue2(player_data, "fly_recharge_spd",0)
            end
            wait(duration)
            if (get_player() ~= nil) then
                ComponentSetValue2(player_data, "fly_recharge_spd_ground", recharge)
                ComponentSetValue(player_data, "fly_recharge_spd", recharge2)
            end
        end)
    end,
    PlayerGhost = function()
        spawn_entity_in_view_random_angle("data/entities/animals/playerghost.xml", 10, 250)
    end,
    MoistMob = function()
        local r = Random(1, 15)
        for i=1, r do 
            spawn_entity_in_view_random_angle("data/entities/animals/frog.xml", 10, 250)
        end
        spawn_entity_in_view_random_angle("data/entities/animals/frog_big.xml", 10, 250)
    end,
    RatKing = function()
        local r = Random(1, 30)
        for i=1, r do 
            spawn_entity_in_view_random_angle("data/entities/animals/rat.xml", 10, 250)
        end
    end,
    DoughDeer = function()
        local r = Random(1, 20)
        for i=1, r do 
            spawn_entity_in_view_random_angle("data/entities/animals/deer.xml", 10, 250)
        end
    end,
    Quack = function()
        local r = Random(1, 20)
        for i=1, r do 
            spawn_entity_in_view_random_angle("data/entities/animals/duck.xml", 10, 250)
        end
    end,
    Blessed = function()
        local player = get_player()
        if (player == nil) then return end
        local x, y = EntityGetTransform(player)
        local halo = EntityGetWithName("halo")
        if (halo ~= nil) then
            EntityKill(halo)
        end
        local child_halo = EntityLoad( "data/entities/misc/perks/player_halo_light.xml", x, y )
        EntityAddChild(player, child_halo)
    end,
    Cursed = function()
        local player = get_player()
        if (player == nil) then return end
        local x, y = EntityGetTransform(player)
        local halo = EntityGetWithName("halo")
        if (halo ~= nil) then
            EntityKill(halo)
        end
        local child_halo = EntityLoad( "data/entities/misc/perks/player_halo_dark.xml", x, y )
        EntityAddChild(player, child_halo)
    end,
    BigLove = function()
        local x, y = get_player_pos()
        local charm = CellFactory_GetType("magic_liquid_charm")
        for _, entity in pairs(EntityGetInRadiusWithTag(x, y, 5000, "enemy") or {}) do
            local r = Random(1, 100)
            if (r >= 80) then 
                EntityAddRandomStains(entity, charm, 1000)
            end
        end
    end,
    HankHill = function()
        local player = get_player()
        if (player == nil) then return end 
        local pos_x, pos_y, rot = EntityGetTransform( player )
        local how_many = 4
        local angle_inc = ( 2 * 3.14159 ) / how_many
        local theta = rot
        local length = 600

        for i=1,how_many do
            local vel_x = math.cos( theta ) * length
            local vel_y = 0 - math.sin( theta ) * length

            local bid = shoot_projectile( entity_id, "data/entities/projectiles/propane_tank.xml", pos_x + math.cos( theta ) * 12, pos_y - math.sin( theta ) * 12, vel_x, vel_y )
            
            theta = theta + angle_inc
        end
    end,
    Antiquing = function()
        local x,y  = get_player_pos()
        EntityLoad("data/entities/projectiles/deck/explosion_giga.xml")
    end,
    Yeet = function() --FIX LATER HEE HEE HAA HAa
        local player = get_player()
        if (player == nil) then return end 
        local x,y = EntityGetTransform(player)
        local sz=100
        PhysicsApplyForceOnArea(function(entity, body_mass, body_x, body_y, body_vel_x, body_vel_y, body_vel_angular)
          local fx, fy = calculate_force_at(body_x, body_y)
      
          fx = fx * 0.2 * body_mass
          fy = fy * 0.2 * body_mass
      
          return body_x,body_y,fx,fy,0 -- forcePosX,forcePosY,forceX,forceY,forceAngular
        end, nil, x-sz, y-sz, x+sz, y+sz )
    end,--calculate_force_for_body_fn:function, ignore_this_entity:int, area_min_x:number, area_min_y:number,area_max_x:number, area_max_y:number
    SpikeDrinks = function()
        local drinks = {
            "lava",
            "alcohol",
            "acid",
            "radioactive_liquid",
            "magic_liquid_polymorph",
            "magic_liquid_random_polymorph",
            "blood_cold"
        }
        local inventory = GetInven()
        local items = EntityGetAllChildren(inventory)
        if items ~= nil then
            for _, item_id in ipairs(items) do
                local flask_comp = EntityGetFirstComponentIncludingDisabled(item_id, "MaterialInventoryComponent")
                if flask_comp ~= nil then
                    local potion_material = random_from_array(drinks)
                    AddMaterialInventoryMaterial(item_id, potion_material, 150)
                end
            end
        end
    end,
    Follower = function()
        spawn_entity_in_view_random_angle("data/entities/animals/ghost.xml", 140, 250, false, function(eId)
            local player = get_player()
            if player ~= nil then
                edit_all_components(eId, "GhostComponent", function(comp,vars)
                    vars.mEntityHome = player
                    vars.speed = 30
                    EntityAddComponent( eId, "LifetimeComponent", {
                        lifetime = "3600"
                    } )
                end)
            end
        end)
    end,
    AlchemicCircle = function()
        local mats = {
            "void_liquid",
            "oil",
            "fire",
            "blood",
            "water",
            "acid",
            "alcohol",
            "material_confusion",
            "magic_liquid_movement_faster",
            "magic_liquid_worm_attractor",
            "magic_liquid_protection_all",
            "magic_liquid_mana_regeneration",
            "magic_liquid_teleportation",
            "magic_liquid_hp_regeneration"
        };
        spawn_entity_in_view_random_angle("data/entities/projectiles/deck/circle_acid.xml", 80, 200, false, function(circle)
            async(function()
                ComponentSetValue( EntityGetFirstComponent( circle, "LifetimeComponent" ), "lifetime", "900" )
                ComponentSetValue( EntityGetFirstComponent( circle, "ParticleEmitterComponent" ), "airflow_force", "0.01" );
                ComponentSetValue( EntityGetFirstComponent( circle, "ParticleEmitterComponent" ), "image_animation_speed", "3" );
                for i = 1, 10 do
                    ComponentSetValue( EntityGetFirstComponent( circle, "ParticleEmitterComponent" ), "emitted_material_name", mats[ Random( 1, #mats ) ] );
                    wait(20)
                end
            end)
        end)
    end,
    WeHuffing = function()
        async(function()
            for ii = 1, 10 do
                for i=1, 6 do 
                    spawn_entity_in_view_random_angle("data/entities/projectiles/deck/glue_shot.xml", 5, 180)
                end
                wait(25)
            end
        end)
    end,
    Birthday = function()
        local x,y = get_player_pos()
        EntityLoad("data/entities/items/pickup/chest_random.xml", x, y)
    end,
    Berserk = function()
        local player = get_player()
        local berserk = CellFactory_GetType("magic_liquid_berserk")
        EntityAddRandomStains(player, berserk, 1000)
    end,
    Nolla = function()
        async(function()
            for i=1, 60*3 do
                local projectiles = EntityGetWithTag( "projectile" )
                if ( #projectiles > 0 ) then
                    for _,projectile_id in ipairs( projectiles ) do
                        EntityKill(projectile_id)
                    end
                end
                wait(1)
            end
        end)
    end,
    BackToTheBeginning = function()
        local player = get_player()
        local x = MagicNumbersGetValue("DESIGN_PLAYER_START_POS_X")
        local y = MagicNumbersGetValue("DESIGN_PLAYER_START_POS_Y")
        if (player ~= nil) then
            EntitySetTransform(player, x, y)
        end

        BiomeMapLoad_KeepPlayer( "mods/powerwords/files/noop.lua", "data/biome/_pixel_scenes.xml" )
    
        -- clean up entrances to biomes
        LoadPixelScene( "data/biome_impl/clean_entrance.png", "", 128, 1534, "", true, true )
        LoadPixelScene( "data/biome_impl/clean_entrance.png", "", 128, 3070, "", true, true )
        LoadPixelScene( "data/biome_impl/clean_entrance.png", "", 128, 6655, "", true, true )
        LoadPixelScene( "data/biome_impl/clean_entrance.png", "", 128, 10750, "", true, true )
    end
}