local wezterm = require("wezterm")
local config = {}
local mux = wezterm.mux

local is_windows = wezterm.os == "Windows"
local font_size = (is_windows and 10 or 12)

if wezterm.config_builder then
	config = wezterm.config_builder()
end

local username = os.getenv((is_windows and "USERNAME" or "USER"))

local function get_random_file(dir)
	local files = {}

	-- Detect platform
	local command

	if is_windows then
		-- Windows: use dir /b and handle escaping
		command = 'dir /b "' .. dir:gsub("/", "\\") .. '"'
	else
		-- macOS/Linux: use ls
		command = 'ls "' .. dir .. '"'
	end

	local handle = io.popen(command)
	if handle then
		for file in handle:lines() do
			table.insert(files, file)
		end
		handle:close()
	end

	-- Seed and select random file
	if #files > 0 then
		math.randomseed(os.time())
		local index = math.random(1, #files)

		-- Use appropriate path separator
		local sep = is_windows and "\\" or "/"
		return dir .. sep .. files[index]
	end

	return nil
end

config = {
	status_update_interval = 1,
	window_frame = {
		font_size = font_size,
	},
	color_scheme = "nord",
	show_new_tab_button_in_tab_bar = false,
	tab_and_split_indices_are_zero_based = false,
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
	font_size = font_size,
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
require("keymaps").apply_to_config(config, {})
require("plugins.smart-splits").apply_to_config(config, {})
require("plugins.tabline").apply_to_config(config, {})

if is_windows then
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

wezterm.on("gui-startup", function()
	local tab, pane, window = mux.spawn_window({})
	window:gui_window():maximize()
end)

return config
