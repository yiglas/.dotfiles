vim.filetype.add({
  extension = {
    json = "jsonc",
  },
})

return {
  { import = "lazyvim.plugins.extras.lang.json" },
}
