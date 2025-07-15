return {
  {
    'NeogitOrg/neogit',
    dependencies = {
      'nvim-lua/plenary.nvim', -- required
      'sindrets/diffview.nvim', -- optional - Diff integration
    },
    cmd = { 'Neogit' },
    keys = {
      { '<leader>gg', ':Neogit kind=replace<Return>', silent = true, noremap = true },
    },
    config = true,
  },
}
