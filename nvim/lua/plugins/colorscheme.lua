return {
  "shaunsingh/nord.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    -- Example config in lua
    -- vim.g.nord_contrast = true
    -- vim.g.nord_borders = false
    -- vim.g.nord_disable_background = true
    -- vim.g.nord_italic = false
    -- vim.g.nord_uniform_diff_background = true
    -- vim.g.nord_bold = false

    vim.g.nord_contrast = false
    vim.g.nord_borders = true
    vim.g.nord_disable_background = true
    vim.g.nord_cursorline_transparent = true
    vim.g.nord_enable_sidebar_background = false
    vim.g.nord_italic = true
    vim.g.nord_uniform_diff_background = true
    vim.g.nord_bold = true

    -- Load the colorscheme
    require("nord").set()

    -- Toggle background transparency
    local bg_transparent = true

    local toggle_transparency = function()
      bg_transparent = not bg_transparent
      vim.g.nord_disable_background = bg_transparent
      vim.cmd([[colorscheme nord]])
    end

    vim.keymap.set(
      "n",
      "<leader>bg",
      toggle_transparency,
      { noremap = true, silent = true, desc = "Toggle background transparency" }
    )
  end,
}
