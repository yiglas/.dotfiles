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

return {
  { "neovim/nvim-lspconfig", opts = {
    codelens = {
      enabled = true,
    },
  } },
  { "mason-lspconfig.nvim" },
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      -- Start from base client capabilities
      local caps = vim.lsp.protocol.make_client_capabilities()

      -- If you use nvim-cmp:
      local ok_cmp, cmp = pcall(require, "cmp_nvim_lsp")
      if ok_cmp then
        caps = cmp.default_capabilities(caps)
      end

      -- If you use blink.cmp instead, prefer this (harmless if missing):
      local ok_blink, blink = pcall(require, "blink.cmp")
      if ok_blink and blink.get_lsp_capabilities then
        caps = blink.get_lsp_capabilities(caps)
      end

      -- Add file-operations per LSP 3.16+
      caps.workspace = caps.workspace or {}
      caps.workspace.fileOperations = {
        dynamicRegistration = false,
        didCreate = true,
        willCreate = true,
        didRename = true,
        willRename = true,
        didDelete = true,
        willDelete = true,
      }

      -- Merge into LazyVim’s global capabilities
      opts.servers["*"].capabilities = vim.tbl_deep_extend("force", opts.servers["*"].capabilities or {}, caps)
    end,
  },
}
