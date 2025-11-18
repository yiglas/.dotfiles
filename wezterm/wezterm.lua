local wezterm = require("wezterm")
local config = {}
local mux = wezterm.mux

local is_windows = string.match(wezterm.target_triple, "^.*%-windows%-.+$")
local font_size = (is_windows and 9 or 11)

if wezterm.config_builder then
	config = wezterm.config_builder()
end

local username = os.getenv("USER")
username = username and username or os.getenv("USERNAME")

config = {
	status_update_interval = 1,
	use_fancy_tab_bar = false,
	window_close_confirmation = "NeverPrompt",

	font = wezterm.font("JetBrainsMono Nerd Font", { weight = "Bold" }),
	font_size = font_size,
	line_height = 1.2,

	automatically_reload_config = true,

	show_new_tab_button_in_tab_bar = false,

	colors = {
		tab_bar = {
			background = "#000000",
		},
	},

	window_background_opacity = 0.9,
}

-- plugins
require("keymaps").apply_to_config(config, {})
require("plugins.smart-splits").apply_to_config(config, {})
require("plugins.tabline").apply_to_config(config, {})

if is_windows then
	config.default_prog = { "nu" }
	table.insert(
		config.keys,
		{ key = "c", mods = "WIN", action = wezterm.action.CopyTo("ClipboardAndPrimarySelection") }
	)

	table.insert(config.keys, { key = "v", mods = "CTRL", action = wezterm.action.PasteFrom("Clipboard") })
	table.insert(config.keys, { key = "v", mods = "CTRL", action = wezterm.action.PasteFrom("PrimarySelection") })
end

config.window_padding = {
	left = 5,
	right = 5,
	top = 10,
	bottom = 10,
}

config.window_decorations = "TITLE | RESIZE"

wezterm.on("gui-startup", function()
	local tab, pane, window = mux.spawn_window({})
	window:gui_window():maximize()
end)

return config
