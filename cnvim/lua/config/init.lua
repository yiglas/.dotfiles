_G.Utils = require("utils")

local M = {}

function M.setup(_)
	require("config.options")
	require("config.lazy")
	require("config.keymaps")
	require("config.autocmds")
	vim.cmd("colorscheme tokyonight-storm")
end

return M
