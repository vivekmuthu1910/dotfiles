local wezterm = require("wezterm")

local function setup(config)
	config.use_dead_keys = false
	config.leader = { key = ' ', mods = 'CTRL', timeout_milliseconds = 1000 }

	local act = wezterm.action
	config.keys = {
		{
			key = "h",
			mods = "LEADER",
			action = act.ActivatePaneDirection("Left"),
		},
		{
			key = "l",
			mods = "LEADER",
			action = act.ActivatePaneDirection("Right"),
		},
		{
			key = "k",
			mods = "LEADER",
			action = act.ActivatePaneDirection("Up"),
		},
		{
			key = "j",
			mods = "LEADER",
			action = act.ActivatePaneDirection("Down"),
		},
		{
			key = "t",
			mods = "CTRL|ALT|SHIFT",
			action = act.EmitEvent("change-theme"),
		},
	}
end

return {
	setup_keys = setup,
}

