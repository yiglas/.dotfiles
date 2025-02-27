if vim.g.vscode then
  return {}
end

return {
  "nvim-tree/nvim-tree.lua",
  config = function()
    local function natural_cmp(left, right)
      left = left.name:lower()
      right = right.name:lower()

      if left == right then
        return false
      end

      for i = 1, math.max(string.len(left), string.len(right)), 1 do
        local l = string.sub(left, i, -1)
        local r = string.sub(right, i, -1)

        if type(tonumber(string.sub(l, 1, 1))) == "number" and type(tonumber(string.sub(r, 1, 1))) == "number" then
          local l_number = tonumber(string.match(l, "^[0-9]+"))
          local r_number = tonumber(string.match(r, "^[0-9]+"))

          if l_number ~= r_number then
            return l_number < r_number
          end
        elseif string.sub(l, 1, 1) ~= string.sub(r, 1, 1) then
          return l < r
        end
      end
    end

    require("nvim-tree").setup({
      on_attach = function(bufnr)
        local api = require("nvim-tree.api")

        api.events.subscribe(api.events.Event.FileCreated, function(file)
          vim.cmd("edit " .. vim.fn.fnameescape(file.fname))
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
            desc = "nvim-tree: " .. desc,
            buffer = bufnr,
            noremap = true,
            silent = true,
            nowait = true,
          }
        end

        -- default mappings
        api.config.mappings.default_on_attach(bufnr)

        -- custom mappings
        vim.keymap.set("n", "t", api.node.open.tab, opts("Tab"))
        vim.keymap.set("n", "h", api.tree.toggle_hidden_filter, opts("Toggle hidden files"))
        vim.keymap.set("n", "l", edit_or_open, opts("Edit Or Open"))
        vim.keymap.set("n", "L", vsplit_preview, opts("Vsplit Preview"))
        -- vim.keymap.set('n', 'h', api.tree.close, opts 'Close')
        vim.keymap.set("n", "H", api.tree.collapse_all, opts("Collapse All"))
      end,
      actions = {
        open_file = {
          quit_on_open = true,
        },
      },
      sort_by = function(nodes)
        table.sort(nodes, natural_cmp)
      end,
      sort = {
        sorter = "case_sensitive",
      },
      view = {
        width = 30,
        number = false,
        relativenumber = false,
        signcolumn = "yes",
      },
      renderer = {
        group_empty = true,
        root_folder_label = ":t",
      },
      filters = {
        dotfiles = false,
        custom = {
          "node_modules",
        },
      },
      log = {
        enable = true,
        truncate = true,
        types = {
          diagnostics = true,
          git = true,
          profile = true,
          watcher = true,
        },
      },
    })

    if vim.fn.argc(-1) == 0 then
      vim.cmd("NvimTreeFocus")
    end

    -- Make :bd and :q behave as usual when tree is visible
    vim.api.nvim_create_autocmd({ "BufEnter", "QuitPre" }, {
      nested = false,
      callback = function(e)
        local tree = require("nvim-tree.api").tree

        -- Nothing to do if tree is not opened
        if not tree.is_visible() then
          return
        end

        -- How many focusable windows do we have? (excluding e.g. incline status window)
        local winCount = 0
        for _, winId in ipairs(vim.api.nvim_list_wins()) do
          if vim.api.nvim_win_get_config(winId).focusable then
            winCount = winCount + 1
          end
        end

        -- We want to quit and only one window besides tree is left
        if e.event == "QuitPre" and winCount == 2 then
          vim.api.nvim_cmd({ cmd = "qall" }, {})
        end

        -- :bd was probably issued an only tree window is left
        -- Behave as if tree was closed (see `:h :bd`)
        if e.event == "BufEnter" and winCount == 1 then
          -- Required to avoid "Vim:E444: Cannot close last window"
          vim.defer_fn(function()
            -- close nvim-tree: will go to the last buffer used before closing
            tree.toggle({ find_file = true, focus = true })
            -- re-open nivm-tree
            tree.toggle({ find_file = true, focus = false })
          end, 10)
        end
      end,
    })

    vim.keymap.set("n", "<leader>e", ":NvimTreeFindFileToggle<Return>", { noremap = true, silent = true })
  end,
}
