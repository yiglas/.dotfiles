-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.opt.laststatus = 0
vim.o.cursorline = false

vim.g.lazyvim_check_order = false
vim.g.lazyvim_picker = "telescope"

vim.g.augment_disable_tab_mapping = true

vim.g.root_spec = { "cwd" }
