dofile("data/scripts/lib/mod_settings.lua")

local mod_id = "powerwords"
mod_settings_version = 2
mod_settings = 
{
	{
		id = "PW_TRANSCRIPT",
		ui_name = "Show transcript",
		value_default = true,
        scope=MOD_SETTING_SCOPE_RUNTIME
	},
	{
		id = "PW_PUNISHMENT",
		ui_name = "Punish silence after",
		value_default = 0.0,
		value_min = 0.0,
		value_max = 60.0,
		value_display_multiplier = 1,
		value_display_formatting = " $0 seconds",
        scope=MOD_SETTING_SCOPE_RUNTIME
	},
	{
		id = "PW_DEAD_EVENTS",
		ui_name = "Allow events in death screen",
		value_default = false,
		scope=MOD_SETTING_SCOPE_RUNTIME
	},
	{
		id = "PW_ADVANCED_SPAWNS",
		ui_name = "Advanced spawns (nemesis like)",
		value_default = false,
		scope=MOD_SETTING_SCOPE_RUNTIME
	}
}

function ModSettingsUpdate( init_scope )
	local old_version = mod_settings_get_version( mod_id )
	mod_settings_update( mod_id, mod_settings, init_scope )
end

function ModSettingsGuiCount()
	return mod_settings_gui_count( mod_id, mod_settings )
end

function ModSettingsGui( gui, in_main_menu )
	mod_settings_gui( mod_id, mod_settings, gui, in_main_menu )
end
