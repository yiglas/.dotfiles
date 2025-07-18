return {
  -- { import = "lazyvim.plugins.extras.editor.snacks_picker" },
  -- { import = "lazyvim.plugins.extras.editor.snacks_explorer" },
  {
    "folke/snacks.nvim",
    opts = {
      -- explorer = {
      --   sync_cwd = false,
      -- },
      picker = {
        enabled = true,
        -- sources = {
        --   explorer = {
        --     auto_close = true,
        --     layout = {
        --       auto_hide = { "input" },
        --     },
        --   },
        -- },
        layout = {
          preset = "telescope",
        },
        layouts = {
          telescope = {
            reverse = true, -- set to false for search bar to be on top
            layout = {
              box = "horizontal",
              backdrop = false,
              width = 0.8,
              height = 0.9,
              border = "none",
              {
                box = "vertical",
                { win = "list", title = " Results ", title_pos = "center", border = "rounded" },
                {
                  win = "input",
                  height = 1,
                  border = "rounded",
                  title = "{title} {live} {flags}",
                  title_pos = "center",
                },
              },
              {
                win = "preview",
                title = "{preview:Preview}",
                width = 0.50,
                border = "rounded",
                title_pos = "center",
              },
            },
          },
        },
      },
    },
  },
}
