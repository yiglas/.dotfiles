-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- Auto-reload buffers when file changes on disk
vim.o.autoread = true
vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "CursorHoldI" }, {
  group = vim.api.nvim_create_augroup("auto_reload_buffers", { clear = true }),
  callback = function()
    if vim.o.buftype ~= "nofile" then
      vim.cmd("checktime")
    end
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = "lazyvim_wrap_spell",
  pattern = { "text", "plaintex", "typst", "gitcommit", "markdown" },
  callback = function()
    -- if vim.g.vscode then
    vim.opt_local.wrap = false
    vim.opt_local.spell = false
    -- else
    --   vim.opt_local.wrap = true
    --   vim.opt_local.spell = true
    -- end
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "dbui",
  callback = function()
    local opts = { buffer = true, noremap = true, silent = true }
    vim.keymap.set("n", "l", "<Plug>(DBUI_SelectLine)", opts)
  end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = { "*.ts", "*.tsx", "*.js", "*.jsx", "*.cs", "*.go" }, -- Adjust file types as needed
  callback = function()
    local bufnr = vim.api.nvim_get_current_buf()
    local ft = vim.api.nvim_buf_get_option(bufnr, "filetype")

    -- Example for TypeScript/JavaScript (using source.organizeImports)
    if ft == "typescript" or ft == "typescriptreact" or ft == "javascript" or ft == "javascriptreact" then
      vim.lsp.buf.code_action({
        bufnr = bufnr,
        apply = true,
        context = {
          only = { "source.organizeImports" },
          diagnostics = {},
        },
      })
      -- Example for C# (using source.removeUnusedUsings)
    elseif ft == "cs" then
      vim.lsp.buf.code_action({
        bufnr = bufnr,
        apply = true,
        context = {
          only = { "source.removeUnusedUsings" }, -- Or a similar action provided by OmniSharp
          diagnostics = {},
        },
      })
    end
  end,
})
