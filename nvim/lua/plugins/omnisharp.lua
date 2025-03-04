return {
  { import = "lazyvim.plugins.extras.lang.omnisharp" },
  {
    "Cliffback/netcoredbg-macOS-arm64.nvim",
    config = function()
      require("netcoredbg-macOS-arm64").setup(require("dap"))
    end,
  },
}
