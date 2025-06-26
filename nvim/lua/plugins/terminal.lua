return {
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    opts = function(_, opts)
      if vim.fn.has("win32") == 1 then
        -- opts.shell = "pwsh --NoLogo"
        opts.shell = "nu"
      end

      opts.direction = "float"
      opts.start_in_insert = true

      return opts
    end,
  },
}
