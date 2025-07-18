return {
  {
    "coffebar/neovim-project",
    opts = {
      projects = { -- define project roots
        "~/code/filevine/*",
        "~/.dotfiles/*",
        "~/.dotfiles",
        "~/code/dirtsailor/*",
      },
      picker = {
        type = "snacks", -- one of "telescope", "fzf-lua", or "snacks"
      },
    },
    init = function()
      -- enable saving the state of plugins in the session
      vim.opt.sessionoptions:append("globals") -- save global variables that start with an uppercase letter and contain at least one lowercase letter.
    end,
    dependencies = {
      { "nvim-lua/plenary.nvim" },
      { "folke/snacks.nvim" },
      { "Shatur/neovim-session-manager" },
    },
    lazy = false,
    priority = 100,
    keys = {
      { "<leader>fp", "<cmd>NeovimProjectDiscover<cr>", desc = "Project Manager" },
    },
  },
}
