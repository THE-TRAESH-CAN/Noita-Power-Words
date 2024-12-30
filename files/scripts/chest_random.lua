function spawnstuff()
    local eid = GetUpdatedEntityID()
    local x, y = EntityGetTransform(eid)
    local string_val = ""
    local value_int = 0
    local comps = EntityGetComponent(eid, "VariableStorageComponent")
    for _, compId in pairs(comps) do
        if (ComponentGetValue2(compId, "name") == "CHEST_STUFF") then
            string_val = ComponentGetValue2(compId, "value_string")

            value_int = ComponentGetValue2(compId, "value_int")
        end
    end

    if (string_val == nil or value_int == 0) then return end

    if (value_int > 0) then
        for _, entity in pairs(EntityGetInRadiusWithTag(x, y, 1024, "enemy") or {}) do
            if (EntityHasTag(entity, "boss_centipede") == false or EntityHasTag(entity, "boss_centipede_active") == true) then
                local ex, ey = EntityGetTransform(entity)
                EntityLoad(string_val, ex, ey)
                EntityKill(entity)
            end
        end
    elseif (value_int < 0) then
        print(string_val)
        EntityLoad(string_val, x, y)
    end

end

function item_pickup(entity_item, entity_who_picked, name)
    spawnstuff()
    EntityKill(entity_item)
end

function physics_body_modified(is_destroyed)
    local entity_item = GetUpdatedEntityID()

    spawnstuff()
    EntityKill(entity_item)
end
