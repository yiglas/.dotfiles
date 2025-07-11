_G.Utils = require("utils")

local M = {}

function M.setup(opts)
	require("config.options")
	require("config.lazy")
	require("config.keymaps")
end

return M
