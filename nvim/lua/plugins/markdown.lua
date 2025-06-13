return {
  { import = "lazyvim.plugins.extras.lang.markdown" },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    opts = {
      heading = {
        sign = false,
        disable_background = true,
        width = "block",
        min_width = 30,
        icons = { "󰲡  ", "󰲣  ", "󰲥  ", "󰲧  ", "󰲩  ", "󰲫  " },
        border = true,
      },
      -- indent = {
      --   enabled = true,
      --   skip_heading = true,
      -- },
      checkbox = {
        enabled = true,
        render_modes = false,
        bullet = false,
        right_pad = 1,
        unchecked = {
          icon = "󰄱 ",
          highlight = "RenderMarkdownUnchecked",
          scope_highlight = nil,
        },
        checked = {
          icon = "󰱒 ",
          highlight = "RenderMarkdownChecked",
          scope_highlight = "@markup.strikethrough",
        },
        custom = {
          todo = { raw = "[-]", rendered = "󰥔 ", highlight = "RenderMarkdownTodo", scope_highlight = nil },
        },
      },
      code = {
        sign = false,
        disable_background = true,
        width = "block",
        border = "thin",
        below = "─",
        highlight_border = "CustomHighlightBorder",
      },
    },
  },
  -- {
  --   "MeanderingProgrammer/render-markdown.nvim",
  --   opts = function()
  --     return {
  --       heading = {
  --         disable_background = true,
  --         enabled = true,
  --         render_modes = false,
  --         atx = true,
  --         setext = true,
  --         sign = false,
  --         icons = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " },
  --         position = "overlay",
  --         -- width = "full",
  --         left_margin = 0,
  --         left_pad = 0,
  --         right_pad = 0,
  --         min_width = 0,
  --         border = false,
  --         border_virtual = false,
  --         border_prefix = false,
  --         -- above = "▄",
  --         -- below = "▀",
  --         -- backgrounds = {
  --         --   "RenderMarkdownH1Bg",
  --         --   "RenderMarkdownH2Bg",
  --         --   "RenderMarkdownH3Bg",
  --         --   "RenderMarkdownH4Bg",
  --         --   "RenderMarkdownH5Bg",
  --         --   "RenderMarkdownH6Bg",
  --         -- },
  --         foregrounds = {
  --           "RenderMarkdownH1",
  --           "RenderMarkdownH2",
  --           "RenderMarkdownH3",
  --           "RenderMarkdownH4",
  --           "RenderMarkdownH5",
  --           "RenderMarkdownH6",
  --         },
  --         custom = {},
  --       },
  --     }
  --   end,
  -- },
}
