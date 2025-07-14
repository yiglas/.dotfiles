 return {
  -- {
  --   "shaunsingh/nord.nvim",
  --   lazy = false,
  --   priority = 1000,
  --   config = function()
  --     vim.g.nord_contrast = false
  --     vim.g.nord_borders = true
  --     vim.g.nord_disable_background = true
  --     vim.g.nord_cursorline_transparent = true
  --     vim.g.nord_enable_sidebar_background = false 
  --     vim.g.nord_italic = true
  --     vim.g.nord_uniform_diff_background = true
  --     vim.g.nord_bold = true
  --
  --     -- Load the colorscheme
  --     require("nord").set()
  --
  --     -- Toggle background transparency
  --     local bg_transparent = true
  --
  --     local toggle_transparency = function()
  --       bg_transparent = not bg_transparent
  --       vim.g.nord_disable_background = bg_transparent
  --       vim.cmd([[colorscheme nord]])
  --     end
  --
  --     vim.keymap.set(
  --       "n",
  --       "<leader>bg",
  --       toggle_transparency,
  --       { noremap = true, silent = true, desc = "Toggle background transparency" }
  --     )
  --   end,
  -- },
		{
        "folke/tokyonight.nvim",
				lazy = false,
        priority = 1000,
        config = function()
            local transparent = true
            local bg = "#011628"
            local bg_dark = "#011423"
            local bg_highlight = "#143652"
            local bg_search = "#0A64AC"
            local bg_visual = "#275378"
            local fg = "#CBE0F0"
            local fg_dark = "#B4D0E9"
            local fg_gutter = "#627E97"
            local border = "#547998"

            require("tokyonight").setup({
                style = "night",
                transparent = transparent,

                styles = {
                    comments = { italic = false },
                    keywords = { italic = false },
                    sidebars = transparent and "transparent" or "dark",
                    floats = transparent and "transparent" or "dark",
                },
                on_colors = function(colors)
                    colors.bg = transparent and colors.none or bg
                    colors.bg_dark = transparent and colors.none or bg_dark
                    colors.bg_float = transparent and colors.none or bg_dark
                    colors.bg_highlight = bg_highlight
                    colors.bg_popup = bg_dark
                    colors.bg_search = bg_search
                    colors.bg_sidebar = transparent and colors.none or bg_dark
                    colors.bg_statusline = transparent and colors.none or bg_dark
                    colors.bg_visual = bg_visual
                    colors.border = border
                    colors.fg = fg
                    colors.fg_dark = fg_dark
                    colors.fg_float = fg
                    colors.fg_gutter = fg_gutter
                    colors.fg_sidebar = fg_dark
                end,
            })
        end,
    },
}
