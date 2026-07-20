local wezterm = require("wezterm")
local config = wezterm.config_builder()
local act = wezterm.action

config.automatically_reload_config = true
config.default_prog = { "wsl", "tmux", "new", "-A" }
config.window_close_confirmation = "NeverPrompt"

config.font_size = 11
-- Run `wezterm ls-fonts --list-system` to find all possible options.
config.font = wezterm.font("SauceCodePro Nerd Font Mono", { weight = "Regular", stretch = "Normal", style = "Normal" })
config.font_rules = {
	{
		intensity = "Normal",
		italic = true,
		font = wezterm.font(
			"SauceCodePro Nerd Font Mono",
			{ weight = "Regular", stretch = "Normal", style = "Italic" }
		),
	},
	{
		intensity = "Bold",
		italic = false,
		font = wezterm.font("SauceCodePro Nerd Font Mono", { weight = "Bold", stretch = "Normal", style = "Normal" }),
	},
	{
		intensity = "Bold",
		italic = true,
		font = wezterm.font("SauceCodePro Nerd Font Mono", { weight = "Bold", stretch = "Normal", style = "Italic" }),
	},
	{
		intensity = "Half",
		italic = false,
		font = wezterm.font("SauceCodePro Nerd Font Mono", { weight = "Light", stretch = "Normal", style = "Normal" }),
	},
	{
		intensity = "Half",
		italic = true,
		font = wezterm.font("SauceCodePro Nerd Font Mono", { weight = "Light", stretch = "Normal", style = "Italic" }),
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
config.keys = {
	{ key = "V", mods = "CTRL", action = act.PasteFrom("Clipboard") },
	{ key = "V", mods = "CTRL", action = act.PasteFrom("PrimarySelection") },
	{ key = "C", mods = "CTRL", action = act.CopyTo("Clipboard") },
	{ key = "-", mods = "CTRL", action = act.DecreaseFontSize },
	{ key = "=", mods = "CTRL", action = act.IncreaseFontSize },
	{ key = "0", mods = "CTRL", action = act.ResetFontSize },
	{ key = "L", mods = "CTRL", action = act.ShowDebugOverlay },
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
		"#eb746b",
		"#37d77f",
		"#f0d399",
		"#8fb8ff",
		"#c6a3ff",
		"#7ad5d6",
		"#e5e5e6",
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
