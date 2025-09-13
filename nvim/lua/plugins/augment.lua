vim.g.augment_disable_tab_mapping = true
vim.g.augment_accept_key = "<C-y>"

return {
  {
    "augmentcode/augment.vim",
    event = "InsertEnter",
    config = function()
      vim.keymap.set("i", "<C-y>", vim.fn["augment#accept"], { silent = true, expr = false, noremap = true })
    end,
  },
}
