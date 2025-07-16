return {
  {
    'mason-org/mason.nvim',
    dependencies = { 'mason-org/mason-lspconfig.nvim', 'WhoIsSethDaniel/mason-tool-installer.nvim' },
    opts = {
      ui = {
        border = 'rounded', -- other options: "none", "single", "double", "shadow", "solid"
      },
    },
  },
}
