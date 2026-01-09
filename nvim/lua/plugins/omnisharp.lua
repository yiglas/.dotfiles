return {
  {
    "Cliffback/netcoredbg-macOS-arm64.nvim",
    ft = { "cs" },
    config = function()
      require("netcoredbg-macOS-arm64").setup(require("dap"))
    end,
    enabled = not (vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1),
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "c_sharp", "razor" } },
  },
  {
    "nvimtools/none-ls.nvim",
    optional = true,
    opts = function(_, opts)
      local nls = require("null-ls")
      opts.sources = opts.sources or {}
      table.insert(opts.sources, nls.builtins.formatting.csharpier)
    end,
  },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        cs = { "csharpier" },
      },
      formatters = {
        csharpier = {
          command = "csharpier",
          args = { "format", "--write-stdout" },
        },
      },
    },
  },
  {
    "mason-org/mason.nvim",
    opts = {
      registries = {
        "github:mason-org/mason-registry",
        "github:Crashdummyy/mason-registry",
      },
      ensure_installed = { "csharpier", "netcoredbg", "roslyn" },
    },
  },

  {
    "seblyng/roslyn.nvim",
    ---@module 'roslyn.config'
    ---@type RoslynNvimConfig
    ft = { "cs", "razor" },
    opts = {
      config = {
        -- Roslyn uses UTF-16 for character positions, must match to avoid
        -- "character out of range" errors
        positionEncoding = "utf-16",
        capabilities = {
          general = {
            positionEncodings = { "utf-16" },
          },
          workspace = {
            didChangeWatchedFiles = {
              dynamicRegistration = true,
            },
            fileOperations = {
              dynamicRegistration = true,
              didCreate = true,
              willCreate = true,
              didRename = true,
              willRename = true,
              didDelete = true,
              willDelete = true,
            },
          },
        },
        settings = {
          ["csharp|inlay_hints"] = {
            csharp_enable_inlay_hints_for_implicit_object_creation = false,
            csharp_enable_inlay_hints_for_implicit_variable_types = false,
            csharp_enable_inlay_hints_for_lambda_parameter_types = false,
            csharp_enable_inlay_hints_for_types = false,
            dotnet_enable_inlay_hints_for_indexer_parameters = false,
            dotnet_enable_inlay_hints_for_literal_parameters = false,
            dotnet_enable_inlay_hints_for_object_creation_parameters = false,
            dotnet_enable_inlay_hints_for_other_parameters = false,
            dotnet_enable_inlay_hints_for_parameters = false,
            dotnet_suppress_inlay_hints_for_parameters_that_differ_only_by_suffix = true,
            dotnet_suppress_inlay_hints_for_parameters_that_match_argument_name = true,
            dotnet_suppress_inlay_hints_for_parameters_that_match_method_intent = true,
          },
          ["csharp|code_lens"] = {
            dotnet_enable_references_code_lens = true,
            dotnet_enable_tests_code_lens = true,
          },
        },
        on_attach = function(client, bufnr)
          -- Enable file watcher for workspace changes
          if client.server_capabilities.workspace then
            client.server_capabilities.workspace.fileOperations = {
              didCreate = true,
              willCreate = true,
              didRename = true,
              willRename = true,
              didDelete = true,
              willDelete = true,
            }
          end
        end,
      },
    },
    config = function(_, opts)
      -- Load mason settings to make $MASON available
      local _ = require("mason.settings").current.install_root_dir

      -- Configure roslyn with proper capabilities
      vim.lsp.config("roslyn", opts.config)
      vim.lsp.enable("roslyn")
    end,
    init = function()
      -- We add the Razor file types before the plugin loads.
      vim.filetype.add({
        extension = {
          razor = "razor",
          cshtml = "razor",
        },
      })
    end,
  },
  {
    "khoido2003/roslyn-filewatch.nvim",
    ft = { "cs", "razor" },
    config = function()
      require("roslyn_filewatch").setup({
        -- Watch for file changes in the workspace
        watch_patterns = { "**/*.cs", "**/*.csproj", "**/*.sln" },
      })

      -- Auto-restart Roslyn on git branch changes
      vim.api.nvim_create_autocmd("User", {
        pattern = "NeogitStatusRefresh",
        callback = function()
          -- Restart Roslyn clients when git state changes
          for _, client in ipairs(vim.lsp.get_clients({ name = "roslyn" })) do
            vim.lsp.stop_client(client.id, true)
            vim.defer_fn(function()
              vim.cmd("edit") -- Reload buffer to restart LSP
            end, 500)
          end
        end,
      })

      -- Watch for .csproj and .sln changes
      vim.api.nvim_create_autocmd({ "BufWritePost" }, {
        pattern = { "*.csproj", "*.sln" },
        callback = function()
          -- Restart Roslyn when project files change
          for _, client in ipairs(vim.lsp.get_clients({ name = "roslyn" })) do
            vim.notify("Restarting Roslyn due to project file changes", vim.log.levels.INFO)
            vim.lsp.stop_client(client.id, true)
            vim.defer_fn(function()
              vim.cmd("edit")
            end, 500)
          end
        end,
      })
    end,
  },
  -- DAP adapter configuration is handled in .lazy.lua for proper Windows path handling
  -- This section is intentionally minimal to avoid conflicts
  {
    "nvim-neotest/neotest",
    optional = true,
    dependencies = {
      "Issafalcon/neotest-dotnet",
    },
    opts = {
      adapters = {
        ["neotest-dotnet"] = {
          -- Here we can set options for neotest-dotnet
        },
      },
    },
  },
}
