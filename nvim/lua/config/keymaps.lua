-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local opts = { noremap = true, silent = true }

vim.keymap.set({ "x", "v" }, "p", "P", opts)

vim.keymap.set("n", "<C-a>", "gg<S-v>G")

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

  vim.keymap.set("n", "<leader>gg", action("magit.status"), opts)
  -- vim.keymap.set({ "i", "x", "n", "s" }, "<C-s>", print_test, opts)
  vim.keymap.set("n", "<leader>K", print_test, opts) -- TODO should send Keywordprg
  vim.keymap.set({ "n", "i", "v" }, "<A-j>", action("editor.action.moveLinesDownAction"), opts)
  vim.keymap.set({ "n", "i", "v" }, "<A-k>", action("editor.action.moveLinesUpAction"), opts)
  vim.keymap.set("n", "<leader>e", action("workbench.files.action.showActiveFileInExplorer"), opts)

  vim.keymap.set("n", "gcc", action("editor.action.commentLine"), opts)
  vim.keymap.set("v", "gc", action("editor.action.commentLine"), opts)

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
  vim.keymap.set("n", "<leader>du", action("workbench.view.debug"), opts)

  vim.keymap.set("n", "<leader><leader>", action("workbench.action.quickOpen"), opts)

  vim.keymap.set("n", "<Up>", action("workbench.action.increaseViewHeight"), opts)
  vim.keymap.set("n", "<Down>", action("workbench.action.decreaseViewHeight"), opts)
  vim.keymap.set("n", "<Left>", action("workbench.action.decreaseViewWidth"), opts)
  vim.keymap.set("n", "<Right>", action("workbench.action.increaseViewWidth"), opts)

  vim.keymap.set("n", "<leader>cf", action("editor.action.formatDocument"), opts)
  vim.keymap.set("v", "<leader>cf", action("editor.action.formatSelection"), opts)

  vim.keymap.set("n", "<leader>aa", action("augment-chat.focus"), opts)

  vim.keymap.set("n", "<leader>su", action("workbench.view.extension.objectExplorer"), opts)
  vim.keymap.set({ "n", "v" }, "<leader>sr", action("mssql.runCurrentStatement"), opts)
  vim.keymap.set({ "n", "v" }, "<leader>sc", action("mssql.runQuery"), opts)

  return
end

local map = LazyVim.safe_keymap_set

map({ "n", "v" }, "<leader>Q", "<cmd>qa<cr>", { desc = "Quit All" })

map({ "n", "v" }, "<Up>", ":resize -2<CR>", {})
map({ "n", "v" }, "<Down>", ":resize +2<CR>", {})
map({ "n", "v" }, "<Right>", ":vertical resize +2<CR>", {})
map({ "n", "v" }, "<Left>", ":vertical resize -2<CR>", {})

-- Dap
map("n", "<F5>", "<cmd>lua require'dap'.continue()<cr>", {})
map("n", "<F10>", "<cmd>lua require'dap'.step_over()<cr>", {})
map("n", "<F11>", "<cmd>lua require'dap'.step_into()<cr>", {})
map("n", "<F12>", "<cmd>lua require'dap'.step_out()<cr>", {})
map("n", "<F9>", "<cmd>lua require'dap'.toggle_breakpoint()<cr>", {})

-- terminal
map({ "n", "v", "i" }, "<C-/>", "<cmd>ToggleTerm<cr>", { desc = "Toogle Terminal" })
map({ "n", "t", "i" }, "<C-_>", "<cmd>ToggleTerm<CR>", { desc = "Toggle Terminal" })

-- dadbod
-- map({ "n", "v" }, "<C-c><C-c>", function()
--   -- Save current position
--   local start_pos = vim.fn.getpos(".")
--
--   -- Select paragraph and yank to register a
--   vim.cmd('normal! vip"ay')
--
--   -- Get yanked SQL query
--   local sql = vim.fn.getreg("a")
--
--   -- Execute SQL via :DB
--   vim.cmd("DB " .. sql)
--
--   -- Restore cursor
--   vim.fn.setpos(".", start_pos)
-- end, { desc = "Execute SQL at point" })

-- conform
map({ "n", "v" }, "<leader>cf", function()
  require("conform").format({ async = true, lsp_fallback = true })
end, { desc = "Format file or selection" })

-- neotest
map("n", "<leader>ta", function()
  local neotest = require("neotest")
  neotest.run.run(vim.fn.expand("%"))
  neotest.summary.open()
end, { desc = "Run all tests" })
