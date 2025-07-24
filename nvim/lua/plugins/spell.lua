return {
  {
    "psliwka/vim-dirtytalk",
    build = ":DirtytalkUpdate",
    config = function()
      vim.opt.spell = true
      vim.opt.spelllang = { "en", "programming" } -- <- Important!
    end,
    event = "BufReadPre",
  },
}
