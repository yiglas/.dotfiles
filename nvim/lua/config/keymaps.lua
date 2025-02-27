-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

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
