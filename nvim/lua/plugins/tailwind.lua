return {
  { import = "lazyvim.plugins.extras.lang.tailwind" },
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      opts.servers = opts.servers or {}
      opts.servers.tailwindcss = opts.servers.tailwindcss or {}
      opts.servers.tailwindcss.filetypes = {
        "html",
        "css",
        "scss",
        "sass",
        "javascript",
        "javascriptreact",
        "typescript",
        "typescriptreact",
        "vue",
        "svelte",
      }
      return opts
    end,
  },
}
