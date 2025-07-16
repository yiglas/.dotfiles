return {
  {
    'nvim-tree/nvim-tree.lua',
    version = '*',
    lazy = false,
    dependencies = {
      'nvim-tree/nvim-web-devicons',
    },
    config = function()
      require('nvim-tree').setup({
        on_attach = function(bufnr)
          local api = require('nvim-tree.api')

          api.events.subscribe(api.events.Event.FileCreated, function(file)
            vim.cmd('edit ' .. vim.fn.fnameescape(file.fname))
          end)

          local function edit_or_open()
            local node = api.tree.get_node_under_cursor()

            if node.nodes ~= nil then
              -- expand or collapse folder
              api.node.open.edit()
            else
              -- open file
              api.node.open.edit()
              -- Close the tree if file was opened
              api.tree.close()
            end
          end

          -- open as vsplit on current node
          local function vsplit_preview()
            local node = api.tree.get_node_under_cursor()

            if node.nodes ~= nil then
              -- expand or collapse folder
              api.node.open.edit()
            else
              -- open file as vsplit
              api.node.open.vertical()
            end

            -- Finally refocus on tree if it was lost
            api.tree.focus()
          end
          local function opts(desc)
            return {
              desc = 'nvim-tree: ' .. desc,
              buffer = bufnr,
              noremap = true,
              silent = true,
              nowait = true,
            }
          end

          api.config.mappings.default_on_attach(bufnr)

          -- custom mappings
          vim.keymap.set('n', 't', api.node.open.tab, opts('Tab'))
          vim.keymap.set('n', 'h', api.tree.toggle_hidden_filter, opts('Toggle hidden files'))
          vim.keymap.set('n', 'l', edit_or_open, opts('Edit Or Open'))
          vim.keymap.set('n', 'L', vsplit_preview, opts('Vsplit Preview'))
          -- vim.keymap.set('n', 'h', api.tree.close, opts 'Close')
          vim.keymap.set('n', 'H', api.tree.collapse_all, opts('Collapse All'))
        end,
        sort_by = 'case_sensitive',
        view = {
          width = 35,
          side = 'left',
          preserve_window_proportions = true,
          number = false,
          relativenumber = false,
          signcolumn = 'yes',
        },
        renderer = {
          highlight_git = true,
          highlight_opened_files = 'name',
          root_folder_modifier = ':t',
          indent_markers = {
            enable = true,
            icons = {
              corner = '└ ',
              edge = '│ ',
              item = '├ ',
              none = '  ',
            },
          },
          icons = {
            show = {
              file = true,
              folder = true,
              folder_arrow = false,
              git = true,
            },
            glyphs = {
              default = '󰈚',
              symlink = '',
              folder = {
                arrow_closed = '',
                arrow_open = '',
                default = '',
                open = '',
                empty = '',
                empty_open = '',
                symlink = '',
              },
              git = {
                unstaged = '✗',
                staged = '✓',
                unmerged = '',
                renamed = '➜',
                deleted = '',
                untracked = '★',
                ignored = '◌',
              },
            },
          },
        },
        diagnostics = {
          enable = true,
          show_on_dirs = true,
          show_on_open_dirs = true,
          icons = {
            hint = '',
            info = '',
            warning = '',
            error = '',
          },
        },
        update_focused_file = {
          enable = true,
          update_root = true,
        },
        git = {
          enable = true,
          ignore = false,
        },
        actions = {
          open_file = {
            quit_on_open = false,
            resize_window = true,
          },
        },
        filters = {
          dotfiles = false,
          custom = { '.DS_Store' },
        },
      })

      vim.keymap.set('n', '<leader>E', ':NvimTreeFindFileToggle<Return>', { noremap = true, silent = true })
    end,
  },
}
