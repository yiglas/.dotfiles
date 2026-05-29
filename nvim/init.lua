-- Patch nvim core unsafe libuv asserts before anything that uses them loads.
require("config.patch-nvim-core")

-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
