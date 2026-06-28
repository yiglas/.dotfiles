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

-- Render C#/Razor code lenses above the first non-whitespace char of the line
-- (the code's indentation) instead of aligning them to the symbol name.
--
-- Neovim 0.12's built-in code lens renderer pads each virtual line with
-- string.rep(' ', range.start_col), i.e. it indents the lens to the lens
-- range's start column. Roslyn reports that range starting at the identifier,
-- so the lens floats above the method/class name. There is no option for this,
-- so we wrap the (private) decoration provider's on_win and rewrite the start
-- column of *resolved* lenses to the line's indent just for rendering, then
-- restore it.
--
-- Only resolved lenses (those with a .command) are shifted, so unresolved
-- lenses still send their real range to codeLens/resolve. Only .character is
-- touched (never .line), so codelens run/execute is unaffected.
do
  pcall(require, "vim.lsp.codelens") -- force-load so the provider is registered
  local ok, cap = pcall(require, "vim.lsp._capability")
  local Provider = ok and cap.all and cap.all.codelens
  if Provider and not Provider.__align_left_patched then
    Provider.__align_left_patched = true
    local orig_on_win = Provider.on_win
    function Provider:on_win(toprow, botrow)
      local ft = vim.bo[self.bufnr].filetype
      if ft ~= "cs" and ft ~= "razor" then
        return orig_on_win(self, toprow, botrow)
      end

      local saved = {}
      for _, state in pairs(self.client_state or {}) do
        for row, lenses in pairs(state.row_lenses or {}) do
          -- Column of the first non-whitespace char on this row.
          local line = vim.api.nvim_buf_get_lines(self.bufnr, row, row + 1, false)[1] or ""
          local indent = #(line:match("^%s*") or "")
          for _, lens in ipairs(lenses) do
            if lens.command and lens.range and lens.range.start.character ~= indent then
              saved[#saved + 1] = { lens.range.start, lens.range.start.character }
              lens.range.start.character = indent
            end
          end
        end
      end

      local pok, perr = pcall(orig_on_win, self, toprow, botrow)
      for _, s in ipairs(saved) do
        s[1].character = s[2]
      end
      if not pok then
        error(perr)
      end
    end
  end
end

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
