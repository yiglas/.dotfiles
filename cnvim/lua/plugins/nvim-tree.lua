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
      })
    end,
  },
}
