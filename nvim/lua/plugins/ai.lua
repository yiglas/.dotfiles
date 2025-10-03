-- Autocommand to re-enable Copilot suggestions when an LSP client restarts.
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("CopilotOnLspAttach", { clear = true }),
  callback = function(args)
    -- Only enable Copilot for the buffer that the LSP client attached to.
    -- If using `zbirenbaum/copilot.lua`, this command will enable automatic suggestions.
    -- The command can be different if you use another Copilot plugin.
    require("copilot.suggestion").toggle_auto_trigger(args.buf)
  end,
})

return {
  {
    "saghen/blink.cmp",
    opts = {
      keymap = {
        -- disable Blink’s default preset OR keep it and only disable <C-y>
        -- preset = "none",
        ["<C-y>"] = false, -- turn off Blink’s accept on <C-y>
      },
    },
  },
  -- {
  --   "augmentcode/augment.vim",
  --   event = "BufReadPre",
  --   keys = {
  --     { "<C-y>", "<cmd>call augment#Accept()<CR>", mode = "i", desc = "Augment: accept" },
  --   },
  --   init = function()
  --     vim.g.augment_disable_tab_mapping = true
  --   end,
  -- },
  {
    "yetone/avante.nvim",
    -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
    -- ⚠️ must add this setting! ! !
    build = vim.fn.has("win32") ~= 0 and "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false"
      or "make",
    event = "VeryLazy",
    version = false, -- Never set this value to "*"! Never!
    ---@module 'avante'
    ---@type avante.Config
    opts = {
      -- add any opts here
      -- this file can contain specific instructions for your project
      instructions_file = "instructions.md",
      -- for example
      provider = "claude",
      providers = {
        claude = {
          endpoint = "https://api.anthropic.com",
          model = "claude-sonnet-4-20250514",
          timeout = 30000, -- Timeout in milliseconds
          extra_request_body = {
            temperature = 0.75,
            max_tokens = 20480,
          },
        },
        moonshot = {
          endpoint = "https://api.moonshot.ai/v1",
          model = "kimi-k2-0711-preview",
          timeout = 30000, -- Timeout in milliseconds
          extra_request_body = {
            temperature = 0.75,
            max_tokens = 32768,
          },
        },
      },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      --- The below dependencies are optional,
      -- "nvim-mini/mini.pick", -- for file_selector provider mini.pick
      -- "nvim-telescope/telescope.nvim", -- for file_selector provider telescope
      -- "hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
      -- "ibhagwan/fzf-lua", -- for file_selector provider fzf
      -- "stevearc/dressing.nvim", -- for input provider dressing
      "folke/snacks.nvim", -- for input provider snacks
      -- "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
      -- "zbirenbaum/copilot.lua", -- for providers='copilot'
      {
        -- support for image pasting
        "HakonHarnes/img-clip.nvim",
        event = "VeryLazy",
        opts = {
          -- recommended settings
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = {
              insert_mode = true,
            },
            -- required for Windows users
            use_absolute_path = true,
          },
        },
      },
      {
        -- Make sure to set this up properly if you have lazy=true
        "MeanderingProgrammer/render-markdown.nvim",
        opts = {
          file_types = { "markdown", "Avante" },
        },
        ft = { "markdown", "Avante" },
      },
    },
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      filesystem = {
        commands = {
          avante_add_files = function(state)
            local node = state.tree:get_node()
            local filepath = node:get_id()
            local relative_path = require("avante.utils").relative_path(filepath)

            local sidebar = require("avante").get()

            local open = sidebar:is_open()
            -- ensure avante sidebar is open
            if not open then
              require("avante.api").ask()
              sidebar = require("avante").get()
            end

            sidebar.file_selector:add_selected_file(relative_path)

            -- remove neo tree buffer
            if not open then
              sidebar.file_selector:remove_selected_file("neo-tree filesystem [1]")
            end
          end,
        },
        window = {
          mappings = {
            ["oa"] = "avante_add_files",
          },
        },
      },
    },
  },
  {
    "zbirenbaum/copilot.lua",
    event = "VeryLazy",
    config = function()
      require("copilot").setup({
        suggestion = {
          enabled = true,
          auto_trigger = true,
          accept = false,
        },
        panel = {
          enabled = false,
        },
        filetypes = {
          ["*"] = true,
        },
      })

      vim.keymap.set("i", "<C-y>", function()
        if require("copilot.suggestion").is_visible() then
          require("copilot.suggestion").accept()
        else
          vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-y>", true, false, true), "n", false)
        end
      end, {
        silent = true,
      })
    end,
  },
  -- {
  --   "saghen/blink.cmp",
  --   dependencies = {
  --     "Kaiser-Yang/blink-cmp-avante",
  --     -- ... Other dependencies
  --   },
  --   opts = {
  --     sources = {
  --       -- Add 'avante' to the list
  --       default = { "avante", "lsp", "path", "luasnip", "buffer" },
  --       providers = {
  --         avante = {
  --           module = "blink-cmp-avante",
  --           name = "Avante",
  --           opts = {
  --             -- options for blink-cmp-avante
  --           },
  --         },
  --       },
  --     },
  --   },
  -- },
}
