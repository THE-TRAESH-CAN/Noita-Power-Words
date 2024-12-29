dofile("mods/powerwords/files/scripts/utils.lua")
dofile("mods/powerwords/files/scripts/json.lua")
if not async then
    dofile("mods/powerwords/files/scripts/coroutines.lua")
end
dofile_once("mods/powerwords/files/lib/pollnet.lua")
dofile("mods/powerwords/files/ws/host.lua")

dofile("mods/powerwords/files/ws/events.lua")
local main_socket = wslib.listen_ws(HOST_URL)
local client = nil
main_socket:on_connection(function(sock)
    client = sock
  GamePrint("PowerWords connected.")
end)
local reconnect = false
local count = 0

SendWsEvent = function(data)
    if main_socket then
        if main_socket:status() == "open" then
            local encoded = json.encode(data)
            main_socket:send(encoded)
        end
    end
end

local function increase_count()
    wake_up_waiting_threads(1)
    count = count + 1
end

_ws_main = function()
    if not main_socket then
        increase_count()
        return
    end

    local a, b = main_socket:poll()

    if client then
        for i=1, 3 do
            local happy, msg = client:poll()
            if (not happy and count % 1200 == 0) then
                client = nil
            end
            local decoded, data = pcall(json.decode, msg)
            local evt = wsEvents[data.event] or nil
            local eee = data.event or nil
            if (decoded and eee == "_speech") then
                local e, res = pcall(evt, data)
            elseif (decoded) then
                local sliders = ExtractSliders(data)
                local onCooldown = CheckEventIsOnCooldown(data.event, sliders.COOLDOWN)
                local reachedActivationLimit = CheckEventActivationsLimitReached(data.event, sliders.LIMIT)
                local isDead = IsPlayerDead()
                local death_screen_events = ModSettingGet("powerwords.PW_DEAD_EVENTS")
                --GamePrint(tostring(isDead) .. " " .. tostring(death_screen_events) .. type(isDead))
                --GamePrint("onCooldown: " .. tostring(onCooldown) .. " LimitReached: " .. tostring(reachedActivationLimit))
                if (not death_screen_events and isDead == "1")then
                elseif (evt ~= nil and not onCooldown and not reachedActivationLimit) then
                    data._sliders = sliders
                    local e, res = pcall(evt, data)
                    if (res) then
                        UpdateEventActivations(data.event)
                        UpdateEventCooldown(data.event)
                    end
                end
            end
        end
    end
    increase_count()
end