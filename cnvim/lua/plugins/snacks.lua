return {
  {
    'folke/snacks.nvim',
    priority = 1000,
    lazy = false,
    opts = {
      bigfile = { enabled = true },
      bufdelete = { enabled = true },
      input = { enabled = true },
      indent = { enabled = true },
      scope = { enabled = true },
      scroll = { enabled = true },
      words = { enabled = true },
      notifier = { enabled = true },
      notify = { enabled = true },
      quickfile = { enabled = true },
      rename = { enabled = true },
      scratch = { enabled = true },
      explorer = { enabled = true },
      picker = {
        enabled = true,
        sources = {
          explorer = {
            auto_close = true,
            layout = {
              auto_hide = { 'input' },
            },
          },
        },
        layout = {
          preset = 'telescope',
        },
        layouts = {
          telescope = {
            reverse = true, -- set to false for search bar to be on top
            layout = {
              box = 'horizontal',
              backdrop = false,
              width = 0.8,
              height = 0.9,
              border = 'none',
              {
                box = 'vertical',
                { win = 'list', title = ' Results ', title_pos = 'center', border = 'rounded' },
                {
                  win = 'input',
                  height = 1,
                  border = 'rounded',
                  title = '{title} {live} {flags}',
                  title_pos = 'center',
                },
              },
              {
                win = 'preview',
                title = '{preview:Preview}',
                width = 0.50,
                border = 'rounded',
                title_pos = 'center',
              },
            },
          },
        },
      },
    },
    keys = {
      {
        '<leader>e',
        function()
          Snacks.explorer()
        end,
        desc = 'File Explorer',
      },
      {
        '<leader>,',
        function()
          Snacks.picker.buffers()
        end,
        desc = 'Buffers',
      },
      {
        '<leader>/',
        function()
          Snacks.picker.grep()
        end,
        desc = 'Grep',
      },
      {
        '<leader>ff',
        function()
          Snacks.picker.files()
        end,
        desc = 'Find Files',
      },
      {
        '<leader><space>',
        function()
          Snacks.picker.files()
        end,
        desc = 'Find Files',
      },
      {
        '<leader>sH',
        function()
          Snacks.picker.highlights()
        end,
        desc = 'Highlights',
      },
      {
        '<leader>sk',
        function()
          Snacks.picker.keymaps()
        end,
        desc = 'Keymaps',
      },
      -- scratch
      {
        '<leader>.',
        function()
          Snacks.scratch()
        end,
        desc = 'Toggle Scratch Buffer',
      },
      {
        '<leader>n',
        function()
          if Snacks.config.picker and Snacks.config.picker.enabled then
            Snacks.picker.notifications()
          else
            Snacks.notifier.show_history()
          end
        end,
        desc = 'Notification History',
      },
      {
        '<leader>un',
        function()
          Snacks.notifier.hide()
        end,
        desc = 'Dismiss All Notifications',
      },
    },
  },
}
