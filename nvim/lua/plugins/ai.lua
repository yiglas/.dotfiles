return {
  { import = "lazyvim.plugins.extras.ai.claudecode" },
  { import = "lazyvim.plugins.extras.ai.copilot" },

  {
    "coder/claudecode.nvim",
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
          vim.ui.input({ prompt = "Resume Id: " }, function(id)
            if id and id ~= "" then
              vim.fn.system("tmux split-window -h -l 30% 'skim resume " .. vim.fn.shellescape(id) .. "'")
            end
          end)
        end,
        desc = "Resume skim session in tmux",
      },
      {
        "<leader>aR",
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
}
