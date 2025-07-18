vim.api.nvim_create_autocmd("FileType", {
  pattern = "sql",
  callback = function()
    vim.keymap.set("n", "<C-c><C-c>", "<cmd>DB<cr>", { buffer = true, silent = true })
    vim.keymap.set("v", "<C-c><C-c>", "<cmd>'<,'>DB<cr>", { buffer = true, silent = true })
  end,
})

return {
  { import = "lazyvim.plugins.extras.lang.sql" },
  {
    "kndndrj/nvim-dbee",
    dependencies = {
      "MunifTanjim/nui.nvim",
    },
    build = function()
      -- Install tries to automatically detect the install method.
      -- if it fails, try calling it with one of these parameters:
      --    "curl", "wget", "bitsadmin", "go"
      require("dbee").install("curl")
    end,
    config = function()
      print("connections ", vim.g.dbs)
      require("dbee").setup({
        sources = {
          require("dbee.sources").MemorySource:new(vim.g.dbs),
        },
      })
    end,
  },
}
