vim.api.nvim_create_autocmd("BufLeave", {
  pattern = "neo-tree*",
  callback = function()
    -- Delay slightly to allow command-mode operations like renaming to complete
    vim.defer_fn(function()
      -- Don't close if command-line is active (e.g., during rename)
      if vim.fn.getcmdwintype() ~= "" or vim.fn.mode() ~= "n" then
        return
      end

      require("neo-tree.command").execute({ action = "close" })
    end, 50)
  end,
})

-- TODO: use lazyvim's neo-tree configuration

return {
  -- { import = "lazyvim.plugins.extras.editor.neo-tree" },

  {
    "nvim-neo-tree/neo-tree.nvim",
    event = "VeryLazy",
    cmd = "Neotree",
    keys = {
      {
        "<leader>fe",
        function()
          require("neo-tree.command").execute({ toggle = true, dir = LazyVim.root() })
        end,
        desc = "Explorer NeoTree (Root Dir)",
      },
      {
        "<leader>fE",
        function()
          require("neo-tree.command").execute({ toggle = true, dir = vim.uv.cwd() })
        end,
        desc = "Explorer NeoTree (cwd)",
      },
      { "<leader>e", "<leader>fe", desc = "Explorer NeoTree (Root Dir)", remap = true },
      { "<leader>E", "<leader>fE", desc = "Explorer NeoTree (cwd)", remap = true },
      {
        "<leader>ge",
        function()
          require("neo-tree.command").execute({ source = "git_status", toggle = true })
        end,
        desc = "Git Explorer",
      },
      {
        "<leader>be",
        function()
          require("neo-tree.command").execute({ source = "buffers", toggle = true })
        end,
        desc = "Buffer Explorer",
      },
    },
    deactivate = function()
      vim.cmd([[Neotree close]])
    end,
    init = function()
      -- FIX: use `autocmd` for lazy-loading neo-tree instead of directly requiring it,
      -- because `cwd` is not set up properly.
      vim.api.nvim_create_autocmd("BufEnter", {
        group = vim.api.nvim_create_augroup("Neotree_start_directory", { clear = true }),
        desc = "Start Neo-tree with directory",
        once = true,
        callback = function()
          if package.loaded["neo-tree"] then
            return
          else
            local stats = vim.uv.fs_stat(vim.fn.argv(0))
            if stats and stats.type == "directory" then
              require("neo-tree")
            end
          end
        end,
      })
    end,
    opts = {
      sources = { "filesystem", "buffers", "git_status" },
      open_files_do_not_replace_types = { "terminal", "Trouble", "trouble", "qf", "Outline" },
      filesystem = {
        hijack_netrw_behavior = "open_default",
        -- bind_to_cwd = false,
        follow_current_file = { enabled = true },
        -- use_libuv_file_watcher = true,
        filtered_items = {
          show_hidden_count = false,
          group_empty_dirs = true,
          hide_dotfiles = false,
          always_show = {
            ".env.local",
            ".envrc",
            ".env",
          },
          never_show = {
            "__pycache__",
            ".DS_Store",
            ".git",
          },
        },
        bind_to_cwd = true,
      },
      window = {
        mappings = {
          ["<esc>"] = "close_window",
          ["l"] = "open",
          ["h"] = "close_node",
          ["<space>"] = "none",
          ["Y"] = {
            function(state)
              local node = state.tree:get_node()
              local path = node:get_id()
              vim.fn.setreg("+", path, "c")
            end,
            desc = "Copy Path to Clipboard",
          },
          ["O"] = {
            function(state)
              require("lazy.util").open(state.tree:get_node().path, { system = true })
            end,
            desc = "Open with System Application",
          },
          ["P"] = { "toggle_preview", config = { use_float = false } },
        },
      },
      default_component_configs = {
        icon = {
          folder_closed = "",
          folder_open = "",
          folder_empty = "",
        },
        indent = {
          indent_size = 2,
          marker_start_level = 1,
        },
        modified = {
          symbol = "*",
        },
        diagnostics = {
          symbols = {
            error = "×",
            warn = "▲",
            hint = "•",
            info = "•",
          },
          highlights = {
            hint = "DiagnosticHint",
            info = "DiagnosticInfo",
            warn = "DiagnosticWarn",
            error = "DiagnosticError",
          },
        },
        git_status = {
          symbols = {
            -- Change type
            added = "",
            deleted = "",
            modified = "●",
            renamed = "",
            -- Status type
            untracked = "?",
            unstaged = "",
            ignored = "○",
            staged = "✔",
            conflict = "!",
          },
        },
      },

      popup_border_style = "single",
      event_handlers = { -- Close neo-tree when opening a file.
        {
          event = "file_opened",
          handler = function()
            require("neo-tree.command").execute({ action = "close" })
          end,
        },
      },

      renderers = {
        directory = { --> this is for directories
          { "indent" },
          { "icon" }, --> left icon that you want to disable
          { "current_filter" },
          {
            "container",
            content = {
              { "name", zindex = 10 },
              { "clipboard", zindex = 10 },
              {
                "diagnostics",
                errors_only = true,
                zindex = 20,
                align = "right",
                hide_when_expanded = true,
              }, --> right icon that you want to config
              { "git_status", zindex = 20, align = "right", hide_when_expanded = true }, --> right icon that you want to config
            },
          },
        },
        file = { --> this is for files
          { "indent" },
          { "icon" }, --> left icon that you want to disable
          {
            "container",
            content = {
              { "name", zindex = 10 },
              { "clipboard", zindex = 10 },
              { "bufnr", zindex = 10 },
              { "modified", zindex = 20, align = "right" },
              { "diagnostics", zindex = 20, align = "right" }, --> right icon that you want to config
              { "git_status", zindex = 20, align = "right" }, --> right icon that you want to config
            },
          },
        },
      },
    },
    config = function(_, opts)
      local function on_move(data)
        Snacks.rename.on_rename_file(data.source, data.destination)
      end

      local events = require("neo-tree.events")
      opts.event_handlers = opts.event_handlers or {}
      vim.list_extend(opts.event_handlers, {
        { event = events.FILE_MOVED, handler = on_move },
        { event = events.FILE_RENAMED, handler = on_move },
      })
      require("neo-tree").setup(opts)
    end,
  },
}
