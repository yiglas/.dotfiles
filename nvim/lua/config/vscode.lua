local vscode = require("vscode")
local keymap = vim.keymap
local opts = { noremap = true, silent = true }
local set_keymap = vim.api.nvim_set_keymap

vim.g.mapleader = " "
vim.g.maplocalleader = ","

vim.notify = vscode.notify

-- past wihout overwriting
keymap.set("v", "p", "P")

-- redo
keymap.set("n", "U", "<C-r>")

-- clear search highlighting
keymap.set("n", "<Esc>", ":nohlsearch<CR>")

-- skip folds (down, up)
vim.cmd("nmap j gj")
vim.cmd("nmap k gk")

-- sync system clipboard:
vim.opt.clipboard = "unnamedplus"

-- search case sensitive settings
vim.opt.ignorecase = true
vim.opt.smartcase = true

function dump(o)
  if type(o) == "table" then
    local s = "{ "
    for k, v in pairs(o) do
      if type(k) ~= "number" then
        k = '"' .. k .. '"'
      end
      s = s .. "[" .. k .. "] = " .. dump(v) .. ","
    end
    return s .. "} "
  else
    return tostring(o)
  end
end


keymap.set('n', '<C-e><C-e>', function()
  vim.api.nvim_input('G')
  vscode.action('calva.evaluateStartOfFileToCursor')
  -- vscode.action('workbench.action.navigateBack')
end, opts)