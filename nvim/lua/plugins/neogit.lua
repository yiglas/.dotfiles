return {
  "NeogitOrg/neogit",
  dependencies = {
    "nvim-lua/plenary.nvim", -- required
    "sindrets/diffview.nvim", -- optional - Diff integration
    -- "nvim-telescope/telescope.nvim", -- optional
  },
  keys = {
    { "<leader>gg", ":Neogit kind=replace<Return>", silent = true, noremap = true },
  },
  config = {
    console_timeout = 3000,
    -- Performance optimizations
    disable_signs = false,
    disable_hint = true,
    disable_context_highlighting = true,
    disable_commit_confirmation = false,
    auto_refresh = false,
    sort_branches = "-committerdate",
    kind = "tab",
    status = {
      recent_commit_count = 50, -- Reduce from default to speed up status
    },
    integrations = {
      diffview = true,
      telescope = false, -- Disable if not using
    },
  },
}
