-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

vim.api.nvim_create_autocmd("FileType", {
  group = "lazyvim_wrap_spell",
  pattern = { "text", "plaintex", "typst", "gitcommit", "markdown" },
  callback = function()
    if vim.g.vscode then
      vim.opt_local.wrap = false
      vim.opt_local.spell = false
    else
      vim.opt_local.wrap = true
      vim.opt_local.spell = true
    end
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "dbui",
  callback = function()
    local opts = { buffer = true, noremap = true, silent = true }
    vim.keymap.set("n", "l", "<Plug>(DBUI_SelectLine)", opts)
  end,
})

local notifier = require("snacks.notifier")
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client then
      notifier.notify("LSP starting: " .. client.name, "info", { spinner = "dots" })
    end
  end,
})

vim.api.nvim_create_autocmd("LspDetach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client then
      notifier.notify("LSP stopped: " .. client.name)
    end
  end,
})
