vim.filetype.add({
  extension = {
    cshtml = 'razor',
  },
})

return {
  {
    'nvim-treesitter/nvim-treesitter',
    opts = { ensure_installed = { 'c_sharp' } },
  },
  {
    'nvimtools/none-ls.nvim',
    opts = function(_, opts)
      local nls = require('null-ls')
      opts.sources = opts.sources or {}
      table.insert(opts.sources, nls.builtins.formatting.csharpier)
    end,
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
    opts = { ensure_installed = { 'csharpier', 'netcoredbg' } },
  },
  {
    'neovim/nvim-lspconfig',
    opts = {
      servers = {
        omnisharp = {
          handlers = {
            ['textDocument/definition'] = function(...)
              return require('omnisharp_extended').handler(...)
            end,
          },
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
          args = { 'format', '--write-stdout' },
        },
      },
    },
  },
}
