return {
  {
    "folke/tokyonight.nvim",
    config = function()
      require("tokyonight").setup({
        style = "storm", -- or "night", "moon", "day"
        transparent = true, -- This enables the transparent background
        styles = {
          sidebars = "transparent",
          floats = "transparent",
        },
      })
    end,
  },
}
