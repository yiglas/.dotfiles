return {
  {
    "augmentcode/augment.vim",
    event = "InsertEnter",
    config = function()
      vim.g.augment_accept_key = "<C-y>"
      vim.g.augment_disable_tab_mapping = true
    end,
  },
}
