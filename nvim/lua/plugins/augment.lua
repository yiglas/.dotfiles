vim.g.augment_disable_tab_mapping = true
vim.g.augment_accept_key = "<C-y>"

return {
  {
    "augmentcode/augment.vim",
    -- enabled = false,
    event = "InsertEnter",
  },
}
