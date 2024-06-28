return {
  {
    "numToStr/Comment.nvim",
    opts = {
      -- add any options here
    },
    lazy = false,
  },
  {
    "dundalek/parpar.nvim",
    dependencies = { "gpanders/nvim-parinfer", "julienvincent/nvim-paredit" },
    config = function()
      local paredit = require("nvim-paredit")
      require("parpar").setup({
        paredit = {
          keys = {
            ["<localleader>h"] = { paredit.api.slurp_backwards, "Slurp backwards" },
            ["<localleader>j"] = { paredit.api.barf_backwards, "Barf backwards" },
            ["<localleader>k"] = { paredit.api.barf_forwards, "Barf forwards" },
            ["<localleader>l"] = { paredit.api.slurp_forwards, "Slurp forwards" },
          },
        },
      })
    end,
  },
}
