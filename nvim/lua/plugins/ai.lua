return {
  -- { import = "lazyvim.plugins.extras.ai.claudecode" },
  { import = "lazyvim.plugins.extras.ai.copilot" },

  {
    "NickvanDyke/opencode.nvim",
    dependencies = {
      -- Recommended for `ask()` and `select()`.
      -- Required for `snacks` provider.
      ---@module 'snacks' <- Loads `snacks.nvim` types for configuration intellisense.
      { "folke/snacks.nvim", opts = { input = {}, picker = {}, terminal = {} } },
    },
    config = function()
      ---@type opencode.Opts
      vim.g.opencode_opts = {
        -- Don't specify port - let it auto-detect or find available port
        provider = {
          enabled = "wezterm",
          wezterm = {
            direction = "right",
            percent = 30,
          },
        },
      }

      -- Required for `opts.events.reload`.
      vim.o.autoread = true

      -- Custom keymaps
      vim.keymap.set("n", "<leader>aa", function()
        require("opencode").toggle()
      end, { desc = "Open OpenCode window" })
      vim.keymap.set({ "n", "x" }, "<leader>ae", function()
        require("opencode").ask("@this: ")
      end, { desc = "Ask OpenCode about code" })
      -- Map both <C-\> and <M-o> for toggle (WezTerm alternative)
      vim.keymap.set({ "n", "t" }, "<M-o>", function()
        require("opencode").toggle()
      end, { desc = "Toggle OpenCode panel" })
      -- Additional navigation keymaps
      vim.keymap.set("n", "<S-C-u>", function()
        require("opencode").command("session.half.page.up")
      end, { desc = "OpenCode half page up" })
      vim.keymap.set("n", "<S-C-d>", function()
        require("opencode").command("session.half.page.down")
      end, { desc = "OpenCode half page down" })
    end,
  },
}
