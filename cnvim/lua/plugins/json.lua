vim.filetype.add({
  extension = {
    json = 'jsonc',
  },
})

return {
  {
    'nvim-treesitter/nvim-treesitter',
    opts = {
      ensure_installed = {
        'json',
        'jsonc',
        'json5',
      },
    },
  },
  {
    'b0o/SchemaStore.nvim',
    lazy = true,
    version = false, -- last release is way too old
  },
  {
    'neovim/nvim-lspconfig',
    opts = {
      servers = {
        jsonls = {
          on_new_config = function(config)
            config.settings.json.schemas = config.settings.json.schemas or {}
            vim.list_extend(config.settings.json.schemas, require('schemastore').json.schemas())
          end,
          settings = {
            json = {
              format = {
                enable = true,
              },
              validate = {
                enable = true,
              },
            },
          },
          filetypes = { 'json', 'jsonc' }, -- Add jsonc support
        },
      },
    },
  },
}
