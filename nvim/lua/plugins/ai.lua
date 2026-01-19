return {
  -- { import = "lazyvim.plugins.extras.ai.claudecode" },
  { import = "lazyvim.plugins.extras.ai.copilot" },

  -- Claude Code integration (disabled)
  {
    "coder/claudecode.nvim",
    enabled = false,
    dependencies = { "folke/snacks.nvim" },
    config = true,
    keys = {
      { "<leader>a", nil, desc = "AI/Claude Code" },
      { "<leader>ac", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude" },
      { "<leader>af", "<cmd>ClaudeCodeFocus<cr>", desc = "Focus Claude" },
      { "<leader>ar", "<cmd>ClaudeCode --resume<cr>", desc = "Resume Claude" },
      { "<leader>aC", "<cmd>ClaudeCode --continue<cr>", desc = "Continue Claude" },
      { "<leader>am", "<cmd>ClaudeCodeSelectModel<cr>", desc = "Select Claude model" },
      { "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add current buffer" },
      { "<leader>as", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send to Claude" },
      {
        "<leader>as",
        "<cmd>ClaudeCodeTreeAdd<cr>",
        desc = "Add file",
        ft = { "NvimTree", "neo-tree", "oil", "minifiles", "netrw" },
      },
      { "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
      { "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Deny diff" },
    },
  },

  -- OpenCode
  {
    "NickvanDyke/opencode.nvim",
    dependencies = {
      ---@module 'snacks'
      "folke/snacks.nvim",
    },
    lazy = false,
    config = function()
      -- Detect OS and set provider accordingly
      local is_windows = vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1
      local provider_name = is_windows and "wezterm" or "tmux"

      ---@type opencode.Opts
      vim.g.opencode_opts = {
        provider = {
          enabled = provider_name,
          snacks = {
            win = {
              position = "right",
              width = 0.3, -- 30%
            },
          },
          wezterm = {
            direction = "right",
            percent = 30,
          },
          tmux = {
            options = "-h -l 30%", -- horizontal split at 30% width
          },
        },
      }

      vim.o.autoread = true

      -- Custom keymaps
      vim.keymap.set("n", "<leader>aa", function()
        require("opencode").toggle()
      end, { desc = "Open OpenCode window" })
      vim.keymap.set({ "n", "x" }, "<leader>ae", function()
        require("opencode").ask("@this: ")
      end, { desc = "Ask OpenCode about code" })
      vim.keymap.set({ "n", "t" }, "<M-o>", function()
        require("opencode").toggle()
      end, { desc = "Toggle OpenCode panel" })
      vim.keymap.set("n", "<S-C-u>", function()
        require("opencode").command("session.half.page.up")
      end, { desc = "OpenCode half page up" })
      vim.keymap.set("n", "<S-C-d>", function()
        require("opencode").command("session.half.page.down")
      end, { desc = "OpenCode half page down" })
    end,
  },
}
