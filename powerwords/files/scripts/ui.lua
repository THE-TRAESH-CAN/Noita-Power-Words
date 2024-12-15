if initialized == nil then initialized = false; end

if not initialized then
    initialized = true
    dofile_once( "data/scripts/lib/utilities.lua" )
    local gui = gui or GuiCreate();
    local gui_id = 6969
    GuiStartFrame( gui );
    local screen_width, screen_height = GuiGetScreenDimensions(gui)
    local function reset_id()
        gui_id = 6969
    end
    
    local function next_id()
        local id = gui_id
        gui_id = gui_id + 1
        return id
    end


    function draw_gui()
        --local frame = GameGetFrameNum()
        reset_id()
        GuiStartFrame(gui)
        GuiIdPushString( gui, "powerwords")

        GuiText( gui, 18, 5, lastTranscript)
        GuiIdPop(gui)
    end
end

draw_gui()