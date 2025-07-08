return {
  { import = "lazyvim.plugins.extras.lang.sql" },
  -- {
  --   "kndndrj/nvim-dbee",
  --   dependencies = {
  --     "MunifTanjim/nui.nvim",
  --   },
  --   build = function()
  --     -- Install tries to automatically detect the install method.
  --     -- if it fails, try calling it with one of these parameters:
  --     --    "curl", "wget", "bitsadmin", "go"
  --     require("dbee").install("curl")
  --   end,
  --   config = function()
  --     print("connections ", vim.g.dbs)
  --     require("dbee").setup({
  --       sources = {
  --         require("dbee.sources").MemorySource:new(vim.g.dbs),
  --       },
  --     })
  --   end,
  -- },
}
