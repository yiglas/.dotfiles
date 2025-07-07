local wezterm = require("wezterm")

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
		tabline_a = { "mode" },
		tabline_b = { "" },
		tabline_c = { "" },
		tab_active = { { "index" }, { "cwd", padding = { left = 0, right = 1 } } },
		tab_inactive = { { "index" }, { "cwd", padding = { left = 0, right = 1 } } },
		tabline_x = { "" },
		tabline_y = { "datetime" },
		tabline_z = { "" },
	},
	extensions = {},
})

return tabline
