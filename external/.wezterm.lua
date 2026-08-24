local wezterm = require("wezterm")
local config = wezterm.config_builder()
local act = wezterm.action

config.automatically_reload_config = true
config.default_prog = { "wsl", "tmux", "new", "-A" }
config.window_close_confirmation = "NeverPrompt"

-- Run `wezterm ls-fonts --list-system` to find all possible options.

-- config.font_size = 11
-- config.font = wezterm.font("SauceCodePro Nerd Font Mono", { weight = "Regular", stretch = "Normal", style = "Normal" })
-- config.font_rules = {
-- 	{
-- 		intensity = "Normal",
-- 		italic = true,
-- 		font = wezterm.font(
-- 			"SauceCodePro Nerd Font Mono",
-- 			{ weight = "Regular", stretch = "Normal", style = "Italic" }
-- 		),
-- 	},
-- 	{
-- 		intensity = "Bold",
-- 		italic = false,
-- 		font = wezterm.font("SauceCodePro Nerd Font Mono", { weight = "Bold", stretch = "Normal", style = "Normal" }),
-- 	},
-- 	{
-- 		intensity = "Bold",
-- 		italic = true,
-- 		font = wezterm.font("SauceCodePro Nerd Font Mono", { weight = "Bold", stretch = "Normal", style = "Italic" }),
-- 	},
-- 	{
-- 		intensity = "Half",
-- 		italic = false,
-- 		font = wezterm.font("SauceCodePro Nerd Font Mono", { weight = "Light", stretch = "Normal", style = "Normal" }),
-- 	},
-- 	{
-- 		intensity = "Half",
-- 		italic = true,
-- 		font = wezterm.font("SauceCodePro Nerd Font Mono", { weight = "Light", stretch = "Normal", style = "Italic" }),
-- 	},
-- }

config.font_size = 9.5
config.font = wezterm.font("Monocraft Nerd Font", { weight = "Regular", stretch = "Normal", style = "Normal" })
config.font_rules = {
	{
		intensity = "Normal",
		italic = true,
		font = wezterm.font(
			"Monocraft Nerd Font",
			{ weight = "Regular", stretch = "Normal", style = "Italic" }
		),
	},
	{
		intensity = "Bold",
		italic = false,
		font = wezterm.font("Monocraft Nerd Font", { weight = "Bold", stretch = "Normal", style = "Normal" }),
	},
	{
		intensity = "Bold",
		italic = true,
		font = wezterm.font("Monocraft Nerd Font", { weight = "Bold", stretch = "Normal", style = "Italic" }),
	},
	{
		intensity = "Half",
		italic = false,
		font = wezterm.font("Monocraft Nerd Font", { weight = "Light", stretch = "Normal", style = "Normal" }),
	},
	{
		intensity = "Half",
		italic = true,
		font = wezterm.font("Monocraft Nerd Font", { weight = "Light", stretch = "Normal", style = "Italic" }),
	},
}

config.hide_tab_bar_if_only_one_tab = true
config.max_fps = 240
config.window_padding = {
	left = 0,
	right = 0,
	top = 0,
	bottom = 0,
}
config.cursor_blink_ease_in = "Constant"
config.cursor_blink_ease_out = "Constant"
config.adjust_window_size_when_changing_font_size = false

config.disable_default_key_bindings = true
-- https://wezterm.org/config/default-keys.html
config.keys = {
	{ key = "V", mods = "CTRL", action = act.PasteFrom("Clipboard") },
	{ key = "V", mods = "CTRL", action = act.PasteFrom("PrimarySelection") },
	{ key = "C", mods = "CTRL", action = act.CopyTo("Clipboard") },
	{ key = "-", mods = "CTRL", action = act.DecreaseFontSize },
	{ key = "=", mods = "CTRL", action = act.IncreaseFontSize },
	{ key = "0", mods = "CTRL", action = act.ResetFontSize },
	{ key = "L", mods = "CTRL", action = act.ShowDebugOverlay },
	-- https://github.com/wezterm/wezterm/issues/7187#issuecomment-3241365756
	{ key = "Enter", mods = "SHIFT", action = act.SendString("\n") },
}

config.colors = {
	background = "#0c0c0c",
	foreground = "#f2f2f2",
	cursor_bg = "#f2f2f2",
	cursor_border = "#f2f2f2",
	cursor_fg = "#0c0c0c",
	selection_bg = "#2a2a2a",
	ansi = {
		"#282828",
		"#e85c51",
		"#25be6a",
		"#ebcb8b",
		"#78a9ff",
		"#be95ff",
		"#63cdcf",
		"#dfdfe0",
	},
	brights = {
		"#4a4a4a",
		"#ef8c85",
		"#5ddf98",
		"#f1daac",
		"#a3c5ff",
		"#d9c2ff",
		"#92dcdd",
		"#eaeaeb",
	},
}

for _, gpu in pairs(wezterm.gui.enumerate_gpus()) do
	-- "Vulkan" is also an option.
	if gpu.backend == "Dx12" and gpu.device_type == "DiscreteGpu" then
		config.webgpu_preferred_adapter = gpu
		config.front_end = "WebGpu"
		config.webgpu_power_preference = "HighPerformance"
	end
end

return config
