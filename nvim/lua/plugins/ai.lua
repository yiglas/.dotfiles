return {
  -- { import = "lazyvim.plugins.extras.ai.claudecode" },
  { import = "lazyvim.plugins.extras.ai.copilot" },

  -- Claude Code integration (disabled)
  {
    "coder/claudecode.nvim",
    -- enabled = false,
    dependencies = { "folke/snacks.nvim" },
    opts = {
      terminal = {
        provider = "none", -- Use external tmux pane instead of built-in terminal
      },
    },
    keys = {
      {
        "<leader>ac",
        function()
          vim.fn.system("tmux split-window -h -l 30% 'claude'")
        end,
        desc = "Open Claude in tmux",
      },
      {
        "<leader>ar",
        function()
          vim.fn.system("tmux split-window -h -l 30% 'claude --resume'")
        end,
        desc = "Resume Claude in tmux",
      },
      {
        "<leader>aC",
        function()
          vim.fn.system("tmux split-window -h -l 30% 'claude --continue'")
        end,
        desc = "Continue Claude in tmux",
      },
      {
        "<leader>ap",
        function()
          vim.ui.input({ prompt = "Plugin directory: ", completion = "dir" }, function(dir)
            if dir and dir ~= "" then
              vim.fn.system("tmux split-window -h -l 30% 'claude --plugin-dir " .. vim.fn.shellescape(dir) .. "'")
            end
          end)
        end,
        desc = "Claude with plugin-dir",
      },
      { "<leader>am", "<cmd>ClaudeCodeSelectModel<cr>", desc = "Select Claude model" },
      { "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add current buffer" },
      { "<leader>as", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send to Claude" },
      {
        "<leader>as",
        "<cmd>ClaudeCodeTreeAdd<cr>",
        desc = "Add file",
        ft = { "NvimTree", "neo-tree", "oil", "minifiles", "netrw" },
      },
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
      local is_windows = vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1
      local opencode_cmd = "opencode --port"

      ---@type opencode.Opts
      if is_windows then
        -- Use built-in terminal on Windows
        vim.g.opencode_opts = {}
      else
        -- Use tmux on Linux/macOS
        vim.g.opencode_opts = {
          server = {
            start = function()
              vim.fn.system("tmux split-window -h -l 30% '" .. opencode_cmd .. "'")
            end,
            stop = function()
              vim.fn.system("tmux kill-pane -t right")
            end,
            toggle = function()
              vim.fn.system("tmux split-window -h -l 30% '" .. opencode_cmd .. "'")
            end,
          },
        }
      end

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
