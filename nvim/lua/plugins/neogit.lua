return {
  "NeogitOrg/neogit",
  dependencies = {
    "nvim-lua/plenary.nvim", -- required
    "sindrets/diffview.nvim", -- optional - Diff integration
    "nvim-telescope/telescope.nvim", -- optional
  },
  keys = {
    { "<leader>gg", ":Neogit kind=replace<Return>", silent = true, noremap = true },
  },
  config = true,
}
