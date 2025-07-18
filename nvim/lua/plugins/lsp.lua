return {
  { "neovim/nvim-lspconfig", opts = {
    codelens = {
      enabled = true,
    },
  } },
  { "mason-lspconfig.nvim", event = "VeryLazy" },
}
