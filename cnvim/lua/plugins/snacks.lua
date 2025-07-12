vim.api.nvim_set_hl(0, "SnacksPicker", { bg = "NONE" })
vim.api.nvim_set_hl(0, "SnackNormal", { bg = "NONE" })
vim.api.nvim_set_hl(0, "SnackBorder", { bg = "NONE" })
vim.api.nvim_set_hl(0, "SnackPromptNormal", { bg = "NONE" })
vim.api.nvim_set_hl(0, "SnackResultsNormal", { bg = "NONE" })
vim.api.nvim_set_hl(0, "SnackPreviewNormal", { bg = "NONE" })


return {{
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
    bigfile = { enabled = true },
		bufdelete = { enabled = true },
		dim = { enabled = true },
		explorer = { enabled = true },
		indent = { enabled = true },
		input = { enabled = true },
		picker = { 
			enabled = true,
			sources = {
				explorer = {
					-- auto_close = true,
					layout = {
						auto_hide = { "input" }
					}
				}
			}
		},
    notifier = { enabled = true },
    quickfile = { enabled = true },
    scope = { enabled = true },
    scroll = { enabled = true },
    statuscolumn = { enabled = true },
    words = { enabled = true },
  },
	keys = {
		{ "<leader>e", function() Snacks.picker.explorer() end, { desc = "File Explorer" } }
	}
}
}

