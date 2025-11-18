vim.api.nvim_create_autocmd("VimLeavePre", {
  callback = function()
    local log_path = vim.fn.stdpath("cache") .. "/lsp.log"
    local stat = vim.loop.fs_stat(log_path)

    if stat and stat.size > 20 * 1024 * 1024 then -- 20MB
      vim.fn.delete(log_path)
      print("Deleted lsp.log (over 20MB)")
    end
  end,
})

vim.diagnostic.config({
  float = {
    show_header = true,
    source = "if_many", -- Only show source when there are many diagnostics
    border = "rounded",
    focusable = false,
  },
  -- Other options for virtual_text, signs, etc.
})

return {}
