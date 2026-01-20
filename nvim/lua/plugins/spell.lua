-- lua/plugins/spell.lua
-- Uses the built-in cspell_ls from nvim-lspconfig
return {
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      table.insert(opts.ensure_installed, "cspell-lsp")
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        cspell_ls = {
          filetypes = {
            "markdown",
            "text",
            "gitcommit",
            "lua",
            "javascript",
            "typescript",
            "javascriptreact",
            "typescriptreact",
            "python",
            "go",
            "rust",
            "c",
            "cpp",
            "cs",
            "cshtml",
          },
        },
      },
    },
  },
}
