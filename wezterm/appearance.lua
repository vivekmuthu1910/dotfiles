local wezterm = require("wezterm")

-- Color and Appearance
local schemes = {
	"zenburn (terminal.sexy)",
	"Gruvbox Dark (Gogh)",
	"3024 (dark) (terminal.sexy)",
	"Aci (Gogh)",
	"Adventure Time (Gogh)",
	"Afterglow (Gogh)",
	"AlienBlood",
	"Arthur (Gogh)",
	"Atelier Forest (base16)",
	"Atelierdune (dark) (terminal.sexy)",
	"Ayu Dark (Gogh)",
	"Bamboo",
	"Belafonte Night (Gogh)",
	"Black Metal (Dark Funeral) (base16)",
	"Breath Darker (Gogh)",
	"Brewer (dark) (terminal.sexy)",
	"Cai (Gogh)",
	"Campbell (Gogh)",
	"Canvased Pastel (terminal.sexy)",
	"Catppuccin Mocha (Gogh)",
	"Chalk (dark) (terminal.sexy)",
}

return {
	setup_random_theme = function()
		wezterm.on("change-theme", function(window, _)
			-- If there are no overrides, this is our first time seeing
			-- this window, so we can pick a random scheme.
			-- Pick a random scheme name
			local scheme = schemes[math.random(#schemes)]
			window:set_config_overrides({
				color_scheme = scheme,
			})
			window:set_right_status(scheme or "")
		end)
	end,
	setup_appearance = function(config)
		config.color_scheme = "Gruvbox Dark (Gogh)"
		config.enable_tab_bar = false
		config.use_fancy_tab_bar = true
		config.window_padding = { left = 4, right = 4, top = 4, bottom = 4 }
		config.window_decorations = "RESIZE"
		config.window_background_opacity = 0.85

		config.command_palette_font_size = 12
		config.command_palette_rows = 20
		config.command_palette_bg_color = "rgb(30, 33, 41)"
		config.command_palette_fg_color = "rgb(126, 86, 194)"
	end,
}
