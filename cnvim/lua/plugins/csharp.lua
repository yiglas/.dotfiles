vim.filetype.add({
  extension = {
    cshtml = 'razor',
  },
})

return {
  {
    'seblyng/roslyn.nvim',
    ft = { 'cs', 'razor' },
    {
      -- By loading as a dependencies, we ensure that we are available to set
      -- the handlers for Roslyn.
      'tris203/rzls.nvim',
      config = true,
    },
    ---@module 'roslyn.config'
    ---@type RoslynNvimConfig
    opts = {
      -- your configuration comes here; leave empty for default settings
    },
  },
  {
    'nvim-treesitter/nvim-treesitter',
    opts = { ensure_installed = { 'c_sharp' } },
  },
  -- {
  --   'Cliffback/netcoredbg-macOS-arm64.nvim',
  --   config = function()
  --     require('netcoredbg-macOS-arm64').setup(require('dap'))
  --   end,
  --   enabled = not (vim.fn.has('win32') == 1 or vim.fn.has('win64') == 1),
  -- },
  {
    'mason-org/mason.nvim',
    opts = { ensure_installed = { 'csharpier', 'netcoredbg', 'roslyn', 'rzls' } },
  },
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      {
        'mason-org/mason.nvim',
        opts = {
          registries = {
            'github:mason-org/mason-registry',
            'github:Crashdummyy/mason-registry',
          },
        },
      },
    },
    opts = {
      servers = {
        roslyn = {
          enable_roslyn_analyzers = true,
          organize_imports_on_format = true,
          enable_import_completion = true,
        },
      },
    },
  },
  {
    'stevearc/conform.nvim',
    opts = {
      formatters_by_ft = {
        cs = { 'csharpier' },
      },
      formatters = {
        csharpier = {
          command = 'csharpier',
          args = { 'fromat', '--write-stdout' },
        },
      },
    },
  },
}
