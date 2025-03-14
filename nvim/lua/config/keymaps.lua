-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local opts = { noremap = true, silent = true }

vim.keymap.set({ "x", "v" }, "p", "P", opts)

if vim.g.vscode then
  local vscode = require("vscode")

  vim.g.mapleader = " "
  vim.g.maplocalleader = ","

  vim.notify = vscode.notify

  local print_test = function()
    print("------------------ i was pressed -------------------")
  end

  local action = function(command)
    return "<cmd>lua require('vscode').action('" .. command .. "')<cr>"
  end

  -- vim.keymap.set("n", "<C-s>", action("workbench.action.files.save"), opts)
  -- vim.keymap.set("n", "<C-h>", action("workbench.action.navigateLeft"), opts)
  -- vim.keymap.set("n", "<C-j>", action("workbench.action.navigateDown"), opts)
  -- vim.keymap.set("n", "<C-k>", action("workbench.action.navigateUp"), opts)
  -- vim.keymap.set("n", "<C-l>", action("workbench.action.navigateRight"), opts)

  -- vim.keymap.set({ "n", "i", "v" }, "<A-j>", ":m .+1<cr>", opts)

  -- editorTextFocus && neovim.ctrlKeysNormal.s && neovim.init && neovim.mode != 'insert' && editorLangId not in 'neovim.editorLangIdExclusions'
  -- vscode-neovim.send

  -- move line up
  -- move line down
  -- open command pallet
  -- set x to undo checkout in magit
  -- set k to move to next line in magit
  -- correct terminal space
  -- close all editors
  -- in explorer on enter close explorer
  -- close explorer is open and pressed <leader>-e
  -- list projects
  -- in explorer when pressing h show/hide hidden files
  -- search in all files <leader>-s {something else}

  vim.keymap.set("n", "<leader>gg", action("magit.status"), opts)
  -- vim.keymap.set({ "i", "x", "n", "s" }, "<C-s>", print_test, opts)
  vim.keymap.set("n", "<leader>K", print_test, opts) -- TODO should send Keywordprg
  vim.keymap.set({ "n", "i", "v" }, "<A-j>", action("editor.action.moveLinesDownAction"), opts)
  vim.keymap.set({ "n", "i", "v" }, "<A-k>", action("editor.action.moveLinesUpAction"), opts)
  vim.keymap.set("n", "<leader>e", action("workbench.files.action.showActiveFileInExplorer"), opts)

  vim.keymap.set({ "n", "v" }, "gcc", action("editor.action.commentLine"), opts)

  vim.keymap.set("n", "gco", function()
    vscode.action("editor.action.insertLineAfter")
    vscode.action("editor.action.commentLine")
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("i", true, false, true), "n", false)
  end, opts)

  vim.keymap.set("n", "gcO", function()
    vscode.action("editor.action.insertLineBefore")
    vscode.action("editor.action.commentLine")
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("i", true, false, true), "n", false)
  end, opts)

  vim.keymap.set({ "n", "v" }, "<leader>sg", action("search.action.openNewEditor"), opts)
  vim.keymap.set("n", "<leader>fn", action("workbench.action.files.newUntitledFile"), opts)
  vim.keymap.set("n", "<leader>bd", action("workbench.action.closeActiveEditor"), opts)

  vim.keymap.set("n", "<leader>fp", action("workbench.action.openRecent"), opts)

  vim.keymap.set({ "n", "v" }, "<leader>ca", action("editor.action.quickFix"), opts)

  vim.keymap.set("n", "<leader>cr", action("editor.action.rename"), opts)

  vim.keymap.set("n", "<leader>tl", action("testing.reRunLastRun"), opts)
  vim.keymap.set("n", "<leader>to", action("testing.showMostRecentOutput"), opts)
  vim.keymap.set("n", "<leader>tO", action("testing.openOutputPeek"), opts)
  vim.keymap.set("n", "<leader>tR", action("testing.refreshTests"), opts)
  vim.keymap.set("n", "<leader>tr", action("testing.runAtCursor"), opts)
  vim.keymap.set("n", "<leader>ts", action("workbench.view.testing.focus"), opts)
  vim.keymap.set("n", "<leader>tt", action("testing.runCurrentFile"), opts)
  vim.keymap.set("n", "<leader>tT", action("testing.runAll"), opts)
  vim.keymap.set("n", "<leader>td", action("testing.debugAtCursor"), opts)

  vim.keymap.set("n", "<leader>db", action("editor.debug.action.toggleBreakpoint"), opts)
  vim.keymap.set("n", "<leader>dc", action("workbench.action.debug.continue"), opts)
  vim.keymap.set("n", "<leader>dC", action("editor.debug.action.runToCursor"), opts)
  vim.keymap.set("n", "<leader>di", action("workbench.action.debug.stepInto"), opts)
  vim.keymap.set("n", "<leader>do", action("workbench.action.debug.stepOut"), opts)
  vim.keymap.set("n", "<leader>dO", action("workbench.action.debug.stepOver"), opts)
  vim.keymap.set("n", "<leader>dP", action("workbench.action.debug.pause"), opts)

  return
end

local map = LazyVim.safe_keymap_set

map("n", "<leader>Q", "<cmd>qa<cr>", { desc = "Quit All" })

map({ "n", "v" }, "<Up>", ":resize -2<CR>", {})
map({ "n", "v" }, "<Down>", ":resize +2<CR>", {})
map({ "n", "v" }, "<Right>", ":vertical resize +2<CR>", {})
map({ "n", "v" }, "<Left>", ":vertical resize -2<CR>", {})

map("n", "<C-t>", ":ToggleTerm<cr>", {})

-- Dap
map("n", "<F5>", "<cmd>lua require'dap'.continue()<cr>", {})
map("n", "<F10>", "<cmd>lua require'dap'.step_over()<cr>", {})
map("n", "<F11>", "<cmd>lua require'dap'.step_into()<cr>", {})
map("n", "<F12>", "<cmd>lua require'dap'.step_out()<cr>", {})
map("n", "<F9>", "<cmd>lua require'dap'.toggle_breakpoint()<cr>", {})
