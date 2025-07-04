local wezterm = require("wezterm")
local config = {}

if wezterm.config_builder then
	config = wezterm.config_builder()
end

local username = os.getenv("USER")

if not username then
	username = os.getenv("USERNAME")
end

local function get_random_file(dir)
	local files = {}

	-- Run 'ls' (Unix/macOS) or 'dir /b' (Windows)
	local handle = io.popen('ls "' .. dir .. '"')
	if handle then
		for file in handle:lines() do
			table.insert(files, file)
		end
		handle:close()
	end

	-- Seed and pick random file
	if #files > 0 then
		math.randomseed(os.time())
		local index = math.random(1, #files)
		return dir .. "/" .. files[index]
	end

	return nil
end

math.randomseed(os.time())
local background = math.random(1, 9)

-- wezterm.on("update-status", function(window, pane)
-- 	local time = wezterm.strftime("🕒 %H:%M ")
-- 	window:set_right_status(time)
-- end)

-- wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
-- 	return {
-- 		{ Text = "" }, -- Empty text = invisible tab title
-- 	}
-- end)

config = {
	status_update_interval = 1,
	window_frame = {
		font_size = 10.0,
	},
	color_scheme = "nord",
	show_new_tab_button_in_tab_bar = false,
	tab_and_split_indices_are_zero_based = true,
	colors = {
		tab_bar = {
			background = "#000000",
		},
	},

	default_cursor_style = "SteadyBar",
	automatically_reload_config = true,
	window_close_confirmation = "NeverPrompt",
	adjust_window_size_when_changing_font_size = false,
	window_decorations = "RESIZE",
	check_for_updates = false,
	use_fancy_tab_bar = true,
	tab_bar_at_bottom = false,
	font_size = 10,
	line_height = 1.2,
	font = wezterm.font("JetBrains Mono", { weight = "Bold" }),

	background = {
		{
			source = {
				File = tostring(get_random_file("/Users/" .. username .. "/.dotfiles/backgrounds")),
			},
			hsb = {
				hue = 1.0,
				saturation = 1.02,
				brightness = 0.25,
			},
		},
		{
			source = {
				Color = "#282c35",
			},
			width = "100%",
			height = "100%",
			opacity = 0.55,
		},
	},
	-- from: https://akos.ma/blog/adopting-wezterm/
	hyperlink_rules = {
		-- Matches: a URL in parens: (URL)
		{
			regex = "\\((\\w+://\\S+)\\)",
			format = "$1",
			highlight = 1,
		},
		-- Matches: a URL in brackets: [URL]
		{
			regex = "\\[(\\w+://\\S+)\\]",
			format = "$1",
			highlight = 1,
		},
		-- Matches: a URL in curly braces: {URL}
		{
			regex = "\\{(\\w+://\\S+)\\}",
			format = "$1",
			highlight = 1,
		},
		-- Matches: a URL in angle brackets: <URL>
		{
			regex = "<(\\w+://\\S+)>",
			format = "$1",
			highlight = 1,
		},
		-- Then handle URLs not wrapped in brackets
		{
			-- Before
			--regex = '\\b\\w+://\\S+[)/a-zA-Z0-9-]+',
			--format = '$0',
			-- After
			regex = "[^(]\\b(\\w+://\\S+[)/a-zA-Z0-9-]+)",
			format = "$1",
			highlight = 1,
		},
		-- implicit mailto link
		{
			regex = "\\b\\w+@[\\w-]+(\\.[\\w-]+)+\\b",
			format = "mailto:$0",
		},
	},
}

-- plugins
config.leader = { key = "b", mods = "CTRL" }
wezterm.plugin.require("https://github.com/sei40kr/wez-tmux").apply_to_config(config, {})

local tabline = wezterm.plugin.require("https://github.com/michaelbrusegard/tabline.wez")
tabline.setup({
	options = {
		icons_enabled = true,
		tabs_enabled = true,
		section_separators = "",
		component_separators = "",
		tab_separators = "",
		theme_overrides = {},
	},
	sections = {
		tabline_a = { "" },
		tabline_b = { "" },
		tabline_c = { "" },
		tab_active = { { "index", zero_indexed = true }, { "process", padding = { left = 0, right = 1 } } },
		tab_inactive = { { "index", zero_indexed = true }, { "process", padding = { left = 0, right = 1 } } },
		tabline_x = { "" },
		tabline_y = { "datetime" },
		tabline_z = { "" },
	},
	extensions = {},
})
tabline.apply_to_config(config)

local smart_splits = wezterm.plugin.require("https://github.com/mrjones2014/smart-splits.nvim")
smart_splits.apply_to_config(config, {
	-- the default config is here, if you'd like to use the default keys,
	-- you can omit this configuration table parameter and just use
	-- smart_splits.apply_to_config(config)

	-- directional keys to use in order of: left, down, up, right
	-- if you want to use separate direction keys for move vs. resize, you
	-- can also do this:
	direction_keys = {
		move = { "h", "j", "k", "l" },
		resize = { "LeftArrow", "DownArrow", "UpArrow", "RightArrow" },
	},
	-- modifier keys to combine with direction_keys
	modifiers = {
		move = "CTRL", -- modifier to use for pane movement, e.g. CTRL+h to move left
		resize = "META", -- modifier to use for pane resize, e.g. META+h to resize to the left
	},
	-- log level to use: info, warn, error
	log_level = "info",
})

if wezterm.target_triple == "x86_64-pc-windows-msvc" then
	config.default_prog = { "nu" }
	config.keys = {
		{ key = "c", mods = "CTRL", action = wezterm.action.CopyTo("ClipboardAndPrimarySelection") },
		{ key = "v", mods = "CTRL", action = wezterm.action.PasteFrom("Clipboard") },
		{ key = "v", mods = "CTRL", action = wezterm.action.PasteFrom("PrimarySelection") },
	}
end

config.window_padding = {
	left = 5,
	right = 5,
	top = 10,
	bottom = 10,
}

return config
