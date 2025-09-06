-- lua/plugins/cspell-lsp.lua
return {
  -- make sure the server binary is available (uses npm)
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      -- the package name is from npm; mason won’t install this automatically,
      -- but keeping it listed makes it obvious you need it:
      table.insert(opts.ensure_installed, "cspell-lsp")
    end,
  },

  -- register the LSP
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      local lspconfig = require("lspconfig")
      local configs = require("lspconfig.configs")

      local project_config = lspconfig.util.root_pattern("cspell.json")(vim.fn.getcwd())
      local cspell_config = vim.g.cspell_config or project_config or vim.fn.expand("~/.config/cspell/cspell.json")

      if not configs.cspell_lsp then
        configs.cspell_lsp = {
          default_config = {
            cmd = { "cspell-lsp", "--stdio" }, -- <-- important
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
            root_dir = lspconfig.util.root_pattern(".git"),
            single_file_support = true,
            settings = {
              cspell = {
                -- optional; if your config is at project root you can omit it
                configFile = vim.g.cspell_config or vim.fn.expand("~/.config/cspell/cspell.json"),
              },
            },
          },
        }
      end

      opts.servers = opts.servers or {}
      opts.servers.cspell_lsp = {}
    end,
  },
}
