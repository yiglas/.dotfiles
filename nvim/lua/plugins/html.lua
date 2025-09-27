vim.filetype.add({
  extension = {
    razor = "cshtml",
  },
})

return {
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = { "html-lsp" },
    },
  },
}
