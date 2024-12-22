-- This is where you actually apply your config choices

-- For example, changing the color scheme:
-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

config.automatically_reload_config = true

config.front_end = 'WebGpu'
config.webgpu_power_preference = 'HighPerformance'
config.enable_wayland = false

-- Color and Appearance
local appearance = require("appearance")
-- appearance.setup_random_theme()
appearance.setup_appearance(config)

-- Fonts
config.font =  wezterm.font('FantasqueSansM Nerd Font Mono')
config.font_size = 12.0

-- Programs
local programs = require("programs")
programs.setup_programs(config)

-- Keys
local keys = require("keys")
keys.setup_keys(config)

return config

