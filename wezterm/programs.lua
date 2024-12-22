local wezterm = require("wezterm")

local function setup_programs(config)
	local launch_menu = {}

	if wezterm.target_triple == "x86_64-pc-windows-msvc" then
		config.default_prog = { "C:\\Program Files\\PowerShell\\7\\pwsh.exe" }
		table.insert(launch_menu, {
			label = "PowerShell",
			args = { "powershell.exe", "-NoLogo" },
		})

		table.insert(launch_menu, {
			label = "Nushell",
			args = { "nu" },
		})
		-- Find installed visual studio version(s) and add their compilation
		-- environment command prompts to the menu
		for _, vsvers in ipairs(wezterm.glob("Microsoft Visual Studio/20*", "C:/Program Files (x86)")) do
			local year = vsvers:gsub("Microsoft Visual Studio/", "")
			table.insert(launch_menu, {
				label = "x64 Native Tools VS " .. year,
				args = {
					"cmd.exe",
					"/k",
					"C:/Program Files (x86)/" .. vsvers .. "/BuildTools/VC/Auxiliary/Build/vcvars64.bat",
				},
			})
		end
	end
	config.launch_menu = launch_menu
end

return {
	setup_programs = setup_programs,
}

