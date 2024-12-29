lastTranscript = ""
lastSpeechFrame = GameGetFrameNum()
function ExtractSliders(data)
    local sliders = {}
    for key, slider in pairs(data.sliders) do
        sliders[slider.key] = slider.value
    end
    if (sliders.max ~= nil) then
        if (sliders.min > sliders.max) then sliders.max = sliders.min + 1 end
    end
    return sliders
end

function ExtractCheckboxes(data, props)
    local ret = {}
    if (#data > 0) then
        for index, checkbox in ipairs(data) do
            if (props[checkbox] ~= nil) then
                for key, value in pairs(props[checkbox]) do
                    table.insert(ret, value)
                end
            end
        end
    else
        for key, value in pairs(props) do
            for k, v in pairs(value) do
                table.insert(ret, v)
            end
        end
    end
    return ret
end

function CheckEventActivationsLimitReached(event, max)
    local activations = tonumber(GlobalsGetValue("PWORDS_ACTIVATION_" .. event, "1"))
    if (max == 0) then return false end
    if (activations > max) then
        return true
    end
    return false
end

function UpdateEventActivations(event)
    local activations = tonumber(GlobalsGetValue("PWORDS_ACTIVATION_" .. event, "1"))
    GlobalsSetValue("PWORDS_ACTIVATION_" .. event, tostring(activations + 1))
end

function CheckEventIsOnCooldown(event, cooldown)
    local cd_frames = cooldown * 60
    local frame = GameGetFrameNum()
    local last_frame = tonumber(GlobalsGetValue("PWORDS_COOLDOWN_" .. event, "-1000000"))
    if (frame < last_frame + cd_frames) then
        return true
    end
    return false
end

function UpdateEventCooldown(event)
    local frame = GameGetFrameNum()
    GlobalsSetValue("PWORDS_COOLDOWN_" .. event, tostring(frame))
end

function IsPlayerDead()
    return StatsGetValue("dead")
end

wsEvents = {
    _speech = function(data)
        setrandom()

        local transcript = data.transcript
        local show_transcript = ModSettingGet("powerwords.PW_TRANSCRIPT")
        if (not show_transcript) then return end
        if (lastTranscript == transcript) then return end
        --GamePrint(transcript)
        lastTranscript = transcript
        lastSpeechFrame = GameGetFrameNum()
    end,
    Garbage = function(data)
        setrandom()

        local sliders = data._sliders
        local min = sliders.min
        local max = sliders.max

        local boxes = {
            ["Chairs"] = { "data/entities/props/physics_chair_1.xml", "data/entities/props/physics_chair_2.xml" },
            ["Boxes"] = { "data/entities/props/physics_box_harmless.xml" },
            ["Minecarts"] = { "data/entities/props/physics_cart.xml", "data/entities/props/physics_minecart.xml" },
            ["Stones"] = { "data/entities/props/stonepile.xml" },
            ["Oil Barrels"] = { "data/entities/props/physics_barrel_oil.xml" },
            ["TNT Boxes"] = { "data/entities/props/physics_box_explosive.xml" },
            ["Toxic Barrels"] = { "data/entities/props/physics_barrel_radioactive.xml" },
            ["Acid Barrels"] = { "data/entities/props/physics_pressure_tank.xml" },
            ["Propane Tanks"] = { "data/entities/props/physics_propane_tank.xml" }
        }

        local props = ExtractCheckboxes(data.checkboxes, boxes)
        for i = 1, Random(min, max) do
            local prop = random_from_array(props)
            spawn_entity_in_view_random_angle(prop, 40, 200)
        end
        return true
    end,
    Zoo = function(data)
        setrandom()

        local sliders = data._sliders
        local min = sliders.min
        local max = sliders.max
        local animals = {
            ["Deers"] = { "data/entities/animals/deer.xml" },
            ["Ducks"] = { "data/entities/animals/duck.xml" },
            ["Rats"] = { "data/entities/animals/rat.xml" },
            ["Wolves"] = { "data/entities/animals/wolf.xml" },
            ["Elks"] = { "data/entities/animals/elk.xml" },
            ["Frogs"] = { "data/entities/animals/frog.xml" },
            ["Sheep"] = { "data/entities/animals/sheep.xml" }
        }
        local props = ExtractCheckboxes(data.checkboxes, animals)
        for i = 1, Random(min, max) do
            local prop = random_from_array(props)
            spawn_entity_in_view_random_angle(prop, 40, 200)
        end
        return true
    end,
    Bee = function(data)
        setrandom()

        local sliders = data._sliders
        local min = sliders.min
        local max = sliders.max
        for i = 1, Random(min, max) do
            spawn_entity_in_view_random_angle("data/entities/animals/fly.xml", 10, 280)
        end
        return true
    end,
    GoldTouchy = function(data)
        setrandom()

        for i = 1, 10 do
            spawn_entity_in_view_random_angle("data/entities/projectiles/deck/touch_gold.xml", 10, 280)
        end
        return true
    end,
    Acid = function(data)
        setrandom()

        local sliders = data._sliders
        local min = sliders.min
        local max = sliders.max
        for i = 1, Random(min, max) do
            spawn_entity_in_view_random_angle("data/entities/projectiles/deck/acidshot.xml", 5, 180)
        end
        return true
    end,
    Hentai = function(data)
        setrandom()

        local sliders = data._sliders
        local min = sliders.min
        local max = sliders.max
        for i = 1, Random(min, max) do
            spawn_entity_in_view_random_angle("data/entities/projectiles/deck/tentacle_portal.xml", 25, 200)
        end
        return true
    end,
    WormLauncher = function(data)
        setrandom()

        local sliders = data._sliders
        local min = sliders.min
        local max = sliders.max
        for i = 1, Random(min, max) do
            spawn_entity_in_view_random_angle("data/entities/projectiles/deck/worm_shot.xml", 25, 200)
        end
        return true
    end,
    Ukko = function(data)
        setrandom()

        local sliders = data._sliders
        local min = sliders.min
        local max = sliders.max
        local r = Random(min, max)
        local animals = {
            ["Ukko"] = { "data/entities/animals/thundermage.xml" },
            ["Bicc Ukko"] = { "data/entities/animals/thundermage_big.xml" },
            ["Thunder Spirit"] = { "data/entities/animals/thunderskull.xml" }
        }
        local props = ExtractCheckboxes(data.checkboxes, animals)
        for i = 1, r do
            local prop = random_from_array(props)
            spawn_entity_in_view_random_angle(prop, 40, 200, 0, function(eid)
                entity_attack_timer(eid, 20000)
            end)
        end
        return true
    end,
    Steve = function(data)
        setrandom()

        local sliders = data._sliders
        local min = sliders.min
        local max = sliders.max
        local r = Random(min, max)
        for i = 1, r do
            spawn_entity_in_view_random_angle("data/entities/animals/necromancer_shop.xml", 40, 200)
        end
        return true
    end,
    Trip = function(data)
        setrandom()

        local player = get_player()
        local fungi = CellFactory_GetType("fungi")
        local frame = GameGetFrameNum()
        local last_frame = tonumber(GlobalsGetValue("fungal_shift_last_frame", "-1000000"))
        EntityIngestMaterial(player, fungi, 600)
        return true
    end,
    Tanks = function(data)
        setrandom()

        local sliders = data._sliders
        local min = sliders.min
        local max = sliders.max
        local r = Random(min, max)
        local animals = {
            ["Turrets"] = { "data/entities/animals/turret_left.xml", "data/entities/animals/turret_right.xml" },
            ["Tanks"] = { "data/entities/animals/tank.xml" },
            ["Rocket Tank"] = { "data/entities/animals/tank_rocket.xml" },
            ["Laser Tank"] = { "data/entities/animals/tank_super.xml" },
            ["Healer Bot"] = { "data/entities/animals/healerdrone_physics.xml" },
            ["Shield Bot"] = { "data/entities/animals/drone_shield.xml" },
            ["Bot"] = { "data/entities/animals/drone_physics.xml" }
        }
        local props = ExtractCheckboxes(data.checkboxes, animals)
        for i = 1, r do
            local prop = random_from_array(props)
            spawn_entity_in_view_random_angle(prop, 40, 200)
        end
        return true
    end,
    Cocktail = function(data)
        setrandom()

        local sliders = data._sliders
        local min = sliders.min
        local max = sliders.max
        local r = Random(min, max)
        for i = 1, r do
            spawn_entity_in_view_random_angle("data/entities/animals/goblin_bomb.xml", 40, 200)
        end
        return true
    end,
    LavaShift = function(data)
        setrandom()

        local player = get_player()
        if (player == nil or player <= 0) then return end
        local x, y = EntityGetTransform(player)
        local lavashit = EntityLoad("data/entities/misc/runestone_lava.xml", x, y)
        local magicComp = EntityGetFirstComponentIncludingDisabled(lavashit, "MagicConvertMaterialComponent")
        if (magicComp ~= nil and magicComp > 0) then
            ComponentSetValue2(magicComp, "loop", true)
        end
        EntityRemoveComponent(lavashit, EntityGetFirstComponentIncludingDisabled(lavashit, "LifetimeComponent"))
        EntityAddComponent(lavashit, "LifetimeComponent", {
            lifetime = "600"
        })
        EntityAddComponent(lavashit, "InheritTransformComponent", {
            _tags = "enabled_in_world",
            use_root_parent = "1"
        })
        EntityAddChild(player, lavashit)
        return true
    end,

    Goblins = function(data)
        setrandom()

        local sliders = data._sliders
        local min = sliders.min
        local max = sliders.max
        local r = Random(min, max)
        for i = 1, r do
            spawn_entity_in_view_random_angle("data/entities/animals/shotgunner.xml", 40, 200)
        end
        return true
    end,
    Toasters = function(data)
        setrandom()

        local sliders = data._sliders
        local min = sliders.min
        local max = sliders.max
        local r = Random(min, max)
        for i = 1, r do
            spawn_entity_in_view_random_angle("data/entities/animals/drone_lasership.xml", 40, 200)
        end
        return true
    end,
    Sweaty = function(data)
        setrandom()

        local x, y = get_player_pos()
        local emitter = EntityLoad("data/entities/projectiles/deck/sea_water.xml", x, y - 75)
        local emitterComp = EntityGetFirstComponentIncludingDisabled(emitter, "ParticleEmitterComponent")
        local seaComp = EntityGetFirstComponentIncludingDisabled(emitter, "MaterialSeaSpawnerComponent")
        if ((emitterComp ~= nil and emitterComp > 0) and (seaComp ~= nil and seaComp > 0)) then
            ComponentSetValue2(seaComp, "material", CellFactory_GetType("water_salt"))
            ComponentSetValue2(emitterComp, "emitted_material_name", "brine")
        end
        local r = Random(4, 69)
        for i = 1, r do
            spawn_entity_in_view_random_angle("data/entities/animals/fish.xml", 0, 200)
        end
        return true
    end,
    Byebye = function(data)
        setrandom()

        local player = get_player()
        if (player == nil) then return true end
        local game_effect = GetGameEffectLoadTo(player, "TELEPORTATION", true);
        if game_effect ~= nil then ComponentSetValue(game_effect, "frames", 60); end
        return true
    end,
    BlazeIt = function(data)
        setrandom()

        local x, y = get_player_pos()
        EntityLoad("data/entities/projectiles/deck/sea_acid_gas.xml", x, y - 75)
        return true
    end,
    ThisIsFine = function(data)
        setrandom()

        local x, y = get_player_pos()
        for _, entity in pairs(EntityGetInRadiusWithTag(x, y, 5000, "enemy") or {}) do
            --GamePrint(tostring(entity))
            GetGameEffectLoadTo(entity, "PROTECTION_FIRE", true);
            EntityAddComponent2(entity, "ShotEffectComponent", { extra_modifier = "BURN_TRAIL" });
            EntityAddComponent2(entity, "ParticleEmitterComponent",
                {
                    emitted_material_name = "fire",
                    count_min = "6",
                    count_max = "8",
                    x_pos_offset_min = "-4",
                    y_pos_offset_min = "-4",
                    x_pos_offset_max = "4",
                    y_pos_offset_max = "4",
                    x_vel_min = "-10",
                    x_vel_max = "10",
                    y_vel_min = "-10",
                    y_vel_max = "10",
                    lifetime_min = "1.1",
                    lifetime_max = "2.8",
                    create_real_particles = "1",
                    emit_cosmetic_particles = "0",
                    emission_interval_min_frames = "1",
                    emission_interval_max_frames = "1",
                    delay_frames = "2",
                    is_emitting = "1",
                })
            EntityAddComponent2(entity, "ParticleEmitterComponent",
                {
                    emitted_material_name = "fire",
                    custom_style = "FIRE",
                    count_min = "1",
                    count_max = "1",
                    x_pos_offset_min = "0",
                    y_pos_offset_min = "0",
                    x_pos_offset_max = "0",
                    y_pos_offset_max = "0",
                    is_trail = "1",
                    trail_gap = "1.0",
                    x_vel_min = "-5",
                    x_vel_max = "5",
                    y_vel_min = "-10",
                    y_vel_max = "10",
                    lifetime_min = "1.1",
                    lifetime_max = "2.8",
                    create_real_particles = "1",
                    emit_cosmetic_particles = "0",
                    emission_interval_min_frames = "1",
                    emission_interval_max_frames = "1",
                    delay_frames = "2",
                    is_emitting = "1",
                })
        end
        return true
    end,
    Coolio = function(data)
        setrandom()

        local sliders = data._sliders
        local min = sliders.min
        local max = sliders.max
        local r = Random(min, max)
        local animals = {
            ["Ice Spirit"] = { "data/entities/animals/iceskull.xml" },
            ["Ice Mage"] = { "data/entities/animals/icemage.xml" }
        }
        local props = ExtractCheckboxes(data.checkboxes, animals)
        for i = 1, r do
            local prop = random_from_array(props)
            spawn_entity_in_view_random_angle("data/entities/animals/iceskull.xml", 60, 200)
        end
        return true
    end,
    Twitch = function(data)
        setrandom()

        local player = get_player()
        if (player == nil) then return false end
        local effect = EntityLoad("data/entities/misc/effect_twitchy.xml")
        EntityAddChild(player, effect)
        return true
    end,
    Shrooms = function(data)
        setrandom()

        local sliders = data._sliders
        local min = sliders.min
        local max = sliders.max
        local r = Random(min, max)

        local animals = {
            ["Big Shrooms"] = { "data/entities/animals/fungus_big.xml" },
            ["Normal Shrooms"] = { "data/entities/animals/fungus.xml" },
            ["Tiny Shrooms"] = { "data/entities/animals/fungus_tiny_b.xml", "data/entities/animals/fungus_tiny.xml" },
            ["Giga Shrooms"] = { "data/entities/animals/fungus_giga.xml" }
        }
        local props = ExtractCheckboxes(data.checkboxes, animals)
        for i = 1, r do
            local prop = random_from_array(props)
            spawn_entity_in_view_random_angle(prop, 80, 240)
        end
        return true
    end,
    Eggy = function(data)
        setrandom()

        local sliders = data._sliders
        local min = sliders.min
        local max = sliders.max
        local r = Random(min, max)
        for i = 1, r do
            spawn_entity_in_view_random_angle("data/entities/items/pickup/egg_monster.xml", 60, 200)
        end
        return true
    end,
    Raid = function(data)
        setrandom()

        local sliders = data._sliders
        local min = sliders.min
        local max = sliders.max
        local r = Random(min, max)
        for i = 1, r do
            spawn_entity_in_view_random_angle("data/entities/animals/miner_chef.xml", 60, 250)
        end
        local r2 = Random(min, max)
        for i = 1, r2 do
            spawn_entity_in_view_random_angle("data/entities/animals/miner_fire.xml", 60, 250)
        end
        return true
    end,
    Gamba = function(data)
        setrandom()

        local sliders = data._sliders
        local balance = sliders.BALANCE
        local good = false
        local r = Random(1, 100)

        if (balance == 1) then
            good = r >= 90
        elseif (balance == 2) then
            good = r >= 75
        elseif (balance == 3) then
            good = r <= 50
        elseif (balance == 4) then
            good = r >= 35
        elseif (balance == 5) then
            good = r >= 10
        end

        if (good) then
            spawn_entity_in_view_random_angle("data/entities/projectiles/deck/regeneration_field_long.xml", 1, 20)
        else
            spawn_entity_in_view_random_angle("data/entities/projectiles/circle_acid_die.xml", 1, 20)
        end
        return true
    end,
    HolyBomb = function(data)
        setrandom()

        local sliders = data._sliders
        local min = sliders.min
        local max = sliders.max
        local balance = sliders.BALANCE --"No Duds", "Rare Duds", "50/50", "Dud Sometimes", "Mostly Duds"
        local rand = Random(min, max)
        for i = 1, rand do
            spawn_entity_in_view_random_angle("data/entities/projectiles/bomb_holy.xml", 10, 200, 20, function(eid)
                local dud = false
                local r = Random(1, 100)
                if (balance == 2) then
                    dud = r >= 80
                elseif (balance == 3) then
                    dud = r >= 50
                elseif (balance == 4) then
                    dud = r >= 25
                elseif (balance == 5) then
                    dud = r >= 10
                end

                if (dud) then
                    local proj_comp = EntityGetFirstComponentIncludingDisabled(eid, "ProjectileComponent")
                    if (proj_comp ~= nil) then
                        EntityRemoveComponent(eid, proj_comp)
                    end
                end
            end)
        end
        return true
    end,
    BeegSteve = function(data)
        setrandom()

        local sliders = data._sliders
        local min = sliders.min
        local max = sliders.max
        local rand = Random(min, max)
        for i = 1, max do
            spawn_entity_in_view_random_angle("data/entities/animals/necromancer_super.xml", 100, 300)
        end
        return true
    end,
    Cheapskate = function(data)
        setrandom()

        local sliders = data._sliders
        local balance = sliders.BALANCE
        local player = get_player()
        if (player == nil) then return end
        local wallet = EntityGetFirstComponent(player, "WalletComponent")
        if (wallet ~= nil) then
            local cur_mons = ComponentGetValue2(wallet, "money")
            local add = 0
            local remove = 0
            if (balance == 1) then
                ComponentSetValue2(wallet, "money", 0)
            elseif (balance == 2) then
                remove = math.floor(cur_mons * 0.75)
                ComponentSetValue2(wallet, "money", cur_mons - remove)
            elseif (balance == 3) then
                remove = math.floor(cur_mons * 0.50)
                ComponentSetValue2(wallet, "money", cur_mons - remove)
            elseif (balance == 4) then
                remove = math.floor(cur_mons * 0.25)
                ComponentSetValue2(wallet, "money", cur_mons - remove)
            elseif (balance == 5) then
                remove = math.floor(cur_mons * 0.10)
                ComponentSetValue2(wallet, "money", cur_mons - remove)
            elseif (balance == 6) then
                add = math.floor(cur_mons * 0.10)
                ComponentSetValue2(wallet, "money", cur_mons + add)
            elseif (balance == 7) then
                add = math.floor(cur_mons * 0.25)
                ComponentSetValue2(wallet, "money", cur_mons + add)
            elseif (balance == 8) then
                add = math.floor(cur_mons * 0.50)
                ComponentSetValue2(wallet, "money", cur_mons + add)
            elseif (balance == 9) then
                add = math.floor(cur_mons * 0.75)
                ComponentSetValue2(wallet, "money", cur_mons + add)
            elseif (balance == 10) then
                ComponentSetValue2(wallet, "money", cur_mons + cur_mons)
            end
        end
        return true
    end,
    RogueBH = function(data)
        setrandom()

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
            local lifetime = 60 * 15;
            for _, c in ipairs(ability) do
                if ComponentGetTypeName(c) == "VelocityComponent" then
                    ComponentSetValue(c, "gravity_x", tostring(math.cos(angle) * (-grav)))
                    ComponentSetValue(c, "gravity_y", tostring(math.sin(angle) * (-grav)))
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
        return true
    end,
    Flend = function(data)
        setrandom()

        local sliders = data._sliders
        local min = sliders.min
        local max = sliders.max
        local r = Random(min, max)
        for i = 1, r do
            spawn_entity_in_view_random_angle("data/entities/animals/ultimate_killer.xml", 10, 250)
        end
        return true
    end,
    Cop = function(data)
        setrandom()

        local sliders = data._sliders
        local min = sliders.min
        local max = sliders.max
        local animals = {
            ["Robocop"] = { "data/entities/animals/roboguard.xml" },
            ["Assassin"] = { "data/entities/animals/assassin.xml" },
            ["Hand Bot"] = { "data/entities/animals/monk.xml" },
            ["Lance Bot"] = { "data/entities/animals/spearbot.xml" },
            ["Flame Bot"] = { "data/entities/animals/flamer.xml" },
            ["Ice Flame Bot"] = { "data/entities/animals/icer.xml" }
        }
        local r = Random(min, max)
        local props = ExtractCheckboxes(data.checkboxes, animals)
        for i = 1, r do
            local prop = random_from_array(props)
            spawn_entity_in_view_random_angle(prop, 60, 250)
        end
        return true
    end,
    Loose = function(data)
        setrandom()
        --TODO UPDATE IT
        async(function()
            local x, y = get_player_pos()
            local hit, hx, hy = RaytracePlatforms(x, y, x, y - 500)
            local yy = (y + hy) / 2;
            EntityLoad("data/entities/particles/image_emitters/magical_symbol.xml", hx, yy)
            wait(45)
            EntityLoad("data/entities/projectiles/deck/crumbling_earth.xml", hx, yy)
        end)
        return true
    end,
    Grounded = function(data)
        setrandom()

        async(function()
            local duration = 60 * 6
            local player_data = EntityGetFirstComponent(get_player(), "CharacterDataComponent")

            while player_data == nil do
                wait(60)
                player_data = EntityGetFirstComponent(get_player(), "CharacterDataComponent")
            end

            local flytime = ComponentGetValue2(player_data, "mFlyingTimeLeft")
            local recharge = ComponentGetValue2(player_data, "fly_recharge_spd_ground")
            local recharge2 = ComponentGetValue2(player_data, "fly_recharge_spd")
            ComponentSetValue2(player_data, "mFlyingTimeLeft", 0)
            while recharge == 0 do
                wait(60)
                recharge = ComponentGetValue2(player_data, "fly_recharge_spd_ground")
            end
            if (get_player() ~= nil) then
                ComponentSetValue2(player_data, "fly_recharge_spd_ground", 0)
                ComponentSetValue2(player_data, "fly_recharge_spd", 0)
            end
            wait(duration)
            if (get_player() ~= nil) then
                ComponentSetValue2(player_data, "fly_recharge_spd_ground", recharge)
                ComponentSetValue(player_data, "fly_recharge_spd", recharge2)
            end
        end)
        return true
    end,
    PlayerGhost = function(data)
        setrandom()

        local sliders = data._sliders
        local min = sliders.min
        local max = sliders.max
        local r = Random(min, max)
        for i = 1, r do
            spawn_entity_in_view_random_angle("data/entities/animals/playerghost.xml", 10, 250)
        end
        return true
    end,
    MoistMob = function(data)
        setrandom()

        local sliders = data._sliders
        local min = sliders.min
        local max = sliders.max
        local animals = {
            ["Big Frogs"] = { "data/entities/animals/frog_big.xml" },
            ["Frogs"] = { "data/entities/animals/frog.xml" }
        }
        local r = Random(min, max)
        local props = ExtractCheckboxes(data.checkboxes, animals)
        for i = 1, r do
            local prop = random_from_array(props)
            spawn_entity_in_view_random_angle(prop, 60, 250)
        end
        return true
    end,
    RatKing = function(data)
        setrandom()

        local sliders = data._sliders
        local balance = sliders.BALANCE --"Angry", "Normal", "Random", "Helpful"
        local min = sliders.min
        local max = sliders.max
        local r = Random(min, max)
        for i = 1, r do
            spawn_entity_in_view_random_angle("data/entities/animals/rat.xml", 10, 250, 10, function(eid)
                --TODO UPDATE IT
            end)
        end
        return true
    end,
    DoughDeer = function(data)
        setrandom()

        local sliders = data._sliders
        local balance = sliders.BALANCE --"Explosive", "Random", "Normal"
        local min = sliders.min
        local max = sliders.max
        local r = Random(min, max)
        for i = 1, r do
            spawn_entity_in_view_random_angle("data/entities/animals/deer.xml", 10, 250, 10, function(eid)
                --TODO UPDATE IT
            end)
        end
        return true
    end,
    Quack = function(data)
        setrandom()

        local sliders = data._sliders
        local balance = sliders.BALANCE --"Explosive", "Random", "Normal"
        local min = sliders.min
        local max = sliders.max
        local r = Random(min, max)
        for i = 1, r do
            spawn_entity_in_view_random_angle("data/entities/animals/duck.xml", 10, 250, 10, function(eid)
                --TODO UPDATE IT
            end)
        end
        return true
    end,
    Blessed = function(data)
        setrandom()

        local player = get_player()
        if (player == nil) then return end
        local x, y = EntityGetTransform(player)
        local halo = EntityGetWithName("halo")
        if (halo ~= nil) then
            EntityKill(halo)
        end
        local child_halo = EntityLoad("data/entities/misc/perks/player_halo_light.xml", x, y)
        EntityAddChild(player, child_halo)
        return true
    end,
    Cursed = function(data)
        setrandom()

        local player = get_player()
        if (player == nil) then return end
        local x, y = EntityGetTransform(player)
        local halo = EntityGetWithName("halo")
        if (halo ~= nil) then
            EntityKill(halo)
        end
        local child_halo = EntityLoad("data/entities/misc/perks/player_halo_dark.xml", x, y)
        EntityAddChild(player, child_halo)
        return true
    end,
    BigLove = function(data)
        setrandom()

        local x, y = get_player_pos()
        local charm = CellFactory_GetType("magic_liquid_charm")
        for _, entity in pairs(EntityGetInRadiusWithTag(x, y, 5000, "enemy") or {}) do
            local r = Random(1, 100)
            if (r >= 80) then
                EntityAddRandomStains(entity, charm, 1000)
            end
        end
        return true
    end,
    HankHill = function(data)
        setrandom()

        local sliders = data._sliders
        local min = sliders.min
        local max = sliders.max
        local player = get_player()
        if (player == nil) then return false end
        local pos_x, pos_y, rot = EntityGetTransform(player)
        local how_many = Random(min, max)
        local angle_inc = (2 * 3.14159) / how_many
        local theta = rot
        local length = 600

        for i = 1, how_many do
            local vel_x = math.cos(theta) * length
            local vel_y = 0 - math.sin(theta) * length

            local bid = shoot_projectile(entity_id, "data/entities/projectiles/propane_tank.xml",
                pos_x + math.cos(theta) * 12, pos_y - math.sin(theta) * 12, vel_x, vel_y)

            theta = theta + angle_inc
        end
        return true
    end,
    Antiquing = function(data)
        setrandom()

        local x, y = get_player_pos()
        EntityLoad("data/entities/projectiles/deck/explosion_giga.xml", x, y)
        return true
    end,
    Yeet = function(data)
        setrandom()
        --FIX LATER HEE HEE HAA HAa
        local player = get_player()
        if (player == nil) then return false end
        local x, y = EntityGetTransform(player)
        local sz = 100
        PhysicsApplyForceOnArea(function(entity, body_mass, body_x, body_y, body_vel_x, body_vel_y, body_vel_angular)
            local fx, fy = calculate_force_at(body_x, body_y)

            fx = fx * 0.2 * body_mass
            fy = fy * 0.2 * body_mass

            return body_x, body_y, fx, fy, 0 -- forcePosX,forcePosY,forceX,forceY,forceAngular
        end, nil, x - sz, y - sz, x + sz, y + sz)
        return true
    end, --calculate_force_for_body_fn:function, ignore_this_entity:int, area_min_x:number, area_min_y:number,area_max_x:number, area_max_y:number
    SpikeDrinks = function(data)
        setrandom()

        local sliders = data._sliders
        local min = sliders.min
        local max = sliders.max
        local mats = {
            ["Lava"] = { "lava" },
            ["Alcohol"] = { "alcohol" },
            ["Acid"] = { "acid" },
            ["Toxic"] = { "radioactive_liquid" },
            ["Poly"] = { "magic_liquid_polymorph" },
            ["Random Poly"] = { "magic_liquid_random_polymorph" },
            ["Freezing Liquid"] = { "blood_cold" },
            ["Purifying Powder"] = { "purifying_powder" }
        }
        local drinks = ExtractCheckboxes(data.checkboxes, mats)
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
        return true
    end,
    Follower = function(data)
        setrandom()

        local sliders = data._sliders
        local balance = sliders.BALANCE
        local min = sliders.min
        local max = sliders.max
        local rand = Random(min, max)
        local speed = 30
        if (balance == 1) then
            speed = 45
        elseif (balance == 2) then
            speed = 30
        elseif (balance == 3) then
            speed = 20
        end
        for i = 1, rand do
            spawn_entity_in_view_random_angle("data/entities/animals/ghost.xml", 140, 250, false, function(eId)
                local player = get_player()
                if player ~= nil then
                    edit_all_components(eId, "GhostComponent", function(comp, vars)
                        vars.mEntityHome = player
                        vars.speed = tostring(speed)
                        EntityAddComponent(eId, "LifetimeComponent", {
                            lifetime = "3600"
                        })
                    end)
                end
            end)
        end
        return true
    end,
    AlchemicCircle = function(data)
        setrandom()

        local sliders = data._sliders
        local min = sliders.min
        local max = sliders.max
        local opts = {
            ["Void"] = { "void_liquid" },
            ["Oil"] = { "oil" },
            ["Fire"] = { "fire" },
            ["Blood"] = { "blood" },
            ["Water"] = { "water" },
            ["Acid"] = { "acid" },
            ["Alcohol"] = { "alcohol" },
            ["Flummoxium"] = { "material_confusion" },
            ["Acceleratium"] = { "magic_liquid_movement_faster" },
            ["Worm Attractor"] = { "magic_liquid_worm_attractor" },
            ["Ambrosia"] = { "magic_liquid_protection_all" },
            ["Concentrated Mana"] = { "magic_liquid_mana_regeneration" },
            ["Teleportatium"] = { "magic_liquid_teleportation" },
            ["Healthium"] = { "magic_liquid_hp_regeneration" }
        }
        local mats = ExtractCheckboxes(data.checkboxes, opts)
        spawn_entity_in_view_random_angle("data/entities/projectiles/circle_acid_die.xml", 80, 200, false,
            function(circle)
                async(function()
                    ComponentSetValue2(EntityGetFirstComponentIncludingDisabled(circle, "ParticleEmitterComponent"), "image_animation_file", "data/particles/image_emitters/circle_16.png")
                    ComponentSetValue2(EntityGetFirstComponent(circle, "LifetimeComponent"), "lifetime", 900)
                    ComponentSetValue2(EntityGetFirstComponent(circle, "ParticleEmitterComponent"), "airflow_force",0.01);
                    ComponentSetValue2(EntityGetFirstComponent(circle, "ParticleEmitterComponent"),"image_animation_speed", 0.75);
                    for i = 1, 90 do
                        ComponentSetValue(EntityGetFirstComponent(circle, "ParticleEmitterComponent"),
                            "emitted_material_name", random_from_array(mats));
                        wait(20)
                        setrandom()
                    end
                end)
            end)
        return true
    end,
    WeHuffing = function(data)
        setrandom()

        local sliders = data._sliders
        local min = sliders.min
        local max = sliders.max
        async(function()
            for ii = 1, 5 do
                for i = min, max do
                    spawn_entity_in_view_random_angle("data/entities/projectiles/deck/glue_shot.xml", 5, 180)
                end
                wait(25)
            end
        end)
        return true
    end,
    Birthday = function(data)
        setrandom()
        --TODO UPDATE THIS SHIT
        local x, y = get_player_pos()
        EntityLoad("data/entities/items/pickup/chest_random.xml", x, y)
        return true
    end,
    Berserk = function(data)
        setrandom()

        local player = get_player()
        local berserk = CellFactory_GetType("magic_liquid_berserk")
        EntityAddRandomStains(player, berserk, 1000)
        return true
    end,
    Nolla = function(data)
        setrandom()

        async(function()
            for i = 1, 60 * 3 do
                local projectiles = EntityGetWithTag("projectile")
                if (#projectiles > 0) then
                    for _, projectile_id in ipairs(projectiles) do
                        EntityKill(projectile_id)
                    end
                end
                wait(1)
            end
        end)
        return true
    end,
    BackToTheBeginning = function(data)
        setrandom()

        local player = get_player()
        local x = MagicNumbersGetValue("DESIGN_PLAYER_START_POS_X")
        local y = MagicNumbersGetValue("DESIGN_PLAYER_START_POS_Y")
        if (player ~= nil) then
            EntitySetTransform(player, x, y)
        end
        return true
        --[[ dunno why this part stopped working
            BiomeMapLoad_KeepPlayer( "mods/powerwords/files/noop.lua", "data/biome/_pixel_scenes.xml" )

            LoadPixelScene( "data/biome_impl/clean_entrance.png", "", 128, 1534, "", true, true )
            LoadPixelScene( "data/biome_impl/clean_entrance.png", "", 128, 3070, "", true, true )
            LoadPixelScene( "data/biome_impl/clean_entrance.png", "", 128, 6655, "", true, true )
            LoadPixelScene( "data/biome_impl/clean_entrance.png", "", 128, 10750, "", true, true )
            ]]
    end
}
