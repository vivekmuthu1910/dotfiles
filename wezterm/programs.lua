local wezterm = require("wezterm")

-- TODO: use lua function to check if executable is in path
local function is_executable_in_path(executable)
	local command
	if wezterm.target_triple:find("linux") ~= nil then
		command = "command -v " .. executable
	elseif wezterm.target_triple:find("windows") ~= nil then
		command = "where " .. executable
	else
		return false
	end
	return os.execute(command)
end

local function setup_programs(config)
	local launch_menu = {}

	if is_executable_in_path("nu") then
		table.insert(launch_menu, {
			label = "Nushell",
			args = { "nu" },
		})
		config.default_prog = { "nu" }
	end

	if is_executable_in_path("bash") then
		table.insert(launch_menu, {
			label = "Bash",
			args = { "bash" },
		})
	end

	if is_executable_in_path("pwsh") then
		table.insert(launch_menu, {
			label = "PowerShell-core",
			args = { "pwsh" },
		})
	end

	if wezterm.target_triple:find("windows") then
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
