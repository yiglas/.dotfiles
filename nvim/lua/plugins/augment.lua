return {
  {
    "saghen/blink.cmp",
    opts = {
      keymap = {
        -- disable Blink’s default preset OR keep it and only disable <C-y>
        -- preset = "none",
        ["<C-y>"] = false, -- turn off Blink’s accept on <C-y>
      },
    },
  },
  {
    "augmentcode/augment.vim",
    event = "BufReadPre",
    keys = {
      { "<C-y>", "<cmd>call augment#Accept()<CR>", mode = "i", desc = "Augment: accept" },
    },
    init = function()
      vim.g.augment_disable_tab_mapping = true
    end,
  },
}
