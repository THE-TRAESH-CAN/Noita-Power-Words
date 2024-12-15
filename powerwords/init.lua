if not async then
    dofile("mods/powerwords/files/scripts/coroutines.lua")
end

function is_valid_entity(entity_id)
    return entity_id ~= nil and entity_id ~= 0
end

function OnWorldPostUpdate()
    local world_state = GameGetWorldStateEntity()
    if (GamePaused) then
        GamePaused = false
    end
    
    if (_ws_main and is_valid_entity(world_state)) then
        _ws_main()
    end
    local frame = GameGetFrameNum()
    local seconds = ModSettingGet("powerwords.PW_PUNISHMENT")
    if (seconds == 0) then return end
    if (frame - lastSpeechFrame >= (seconds * 60)) then
        spawn_entity_in_view_random_angle("data/entities/animals/necromancer_super.xml", 69, 269)
        lastSpeechFrame = frame
    end
end

function OnWorldPreUpdate()
    dofile("mods/powerwords/files/scripts/ui.lua")
end

function OnPausePreUpdate()
    if (not GamePaused) then
        GamePaused = true
        --SendWsEvent({event="paused", payload = {}})
    end
    if (_ws_main) then
        _ws_main()
    end
end

dofile("mods/powerwords/files/ws/ws.lua")