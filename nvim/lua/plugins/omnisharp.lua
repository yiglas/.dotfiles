return {
  { import = "lazyvim.plugins.extras.lang.omnisharp" },
  {
    "Cliffback/netcoredbg-macOS-arm64.nvim",
    config = function()
      require("netcoredbg-macOS-arm64").setup(require("dap"))
    end,
    enabled = not (vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1),
  },
  {
    "GustavEikaas/easy-dotnet.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim" },
    config = function()
      require("easy-dotnet").setup()
    end,
  },
}
