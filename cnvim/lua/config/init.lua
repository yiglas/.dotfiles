_G.Utils = require("utils")

local M = {}

function M.setup(opts)
	require("config.options")
	require("config.lazy")
	require("config.keymaps")
	vim.cmd("colorscheme tokyonight-storm")
end

return M
