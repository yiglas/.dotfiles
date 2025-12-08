return {
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = { "html-lsp" },
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      opts.servers = opts.servers or {}
      opts.servers.html = opts.servers.html or {}
      opts.servers.html.filetypes = { "html" }
      return opts
    end,
  },
}
