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
      ensure_installed = { "csharpier", "netcoredbg", "roslyn", "rzls" },
    },
  },

  {
    "seblyng/roslyn.nvim",
    ---@module 'roslyn.config'
    ---@type RoslynNvimConfig
    ft = { "cs", "razor" },
    opts = {
      -- your configuration comes here; leave empty for default settings
    },

    -- ADD THIS:

    dependencies = {
      {
        -- By loading as a dependencies, we ensure that we are available to set
        -- the handlers for Roslyn.
        "tris203/rzls.nvim",
        config = true,
      },
    },
    lazy = false,
    config = function()
      -- Use one of the methods in the Integration section to compose the command.
      local mason_registry = require("mason-registry")

      local rzls_path = vim.fn.expand("$MASON/packages/rzls/libexec")
      local cmd = {
        "roslyn",
        "--stdio",
        "--logLevel=Information",
        "--extensionLogDirectory=" .. vim.fs.dirname(vim.lsp.get_log_path()),
        "--razorSourceGenerator=" .. vim.fs.joinpath(rzls_path, "Microsoft.CodeAnalysis.Razor.Compiler.dll"),
        "--razorDesignTimePath=" .. vim.fs.joinpath(rzls_path, "Targets", "Microsoft.NET.Sdk.Razor.DesignTime.targets"),
        "--extension",
        vim.fs.joinpath(rzls_path, "RazorExtension", "Microsoft.VisualStudioCode.RazorExtension.dll"),
      }

      local rz_handlers = require("rzls.roslyn_handlers")

      rz_handlers["$/progress"] = function(err, result, ctx, cfg)
        if not result or result.token == nil then
          return
        end

        --after guarding, forward to whatever global handler (e.g. Noice) is installed
        local h = vim.lsp.handlers["$/progress"]
        if type(h) == "function" then
          return h(err, result, ctx, cfg)
        end
      end

      vim.lsp.config("roslyn", {
        cmd = cmd,
        handlers = rz_handlers,
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
            dotnet_suppress_inlay_hints_for_parameters_that_differ_only_by_suffix = false,
            dotnet_suppress_inlay_hints_for_parameters_that_match_argument_name = false,
            dotnet_suppress_inlay_hints_for_parameters_that_match_method_intent = false,
          },
          ["csharp|code_lens"] = {
            dotnet_enable_references_code_lens = true,
          },
        },
      })
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
    config = function()
      require("roslyn_filewatch").setup({})
    end,
  },
  {
    "mfussenegger/nvim-dap",
    optional = true,
    event = "VeryLazy",
    opts = function()
      local dap = require("dap")
      local netcoredbg_adapter = {
        type = "executable",
        command = vim.fn.exepath("netcoredbg"),
        args = { "--interpreter=vscode" },
      }

      dap.adapters.netcoredbg = netcoredbg_adapter -- needed for normal debugging
      dap.adapters.coreclr = netcoredbg_adapter -- needed for unit test debugging

      dap.configurations.cs = {
        {
          type = "coreclr",
          name = "launch - netcoredbg",
          request = "launch",
          program = function()
            -- return vim.fn.input("Path to dll: ", vim.fn.getcwd() .. "/src/", "file")
            return vim.fn.input("Path to dll: ", vim.fn.getcwd() .. "/bin/Debug/net9.0/", "file")
          end,

          -- justMyCode = false,
          -- stopAtEntry = false,
          -- -- program = function()
          -- --   -- todo: request input from ui
          -- --   return "/path/to/your.dll"
          -- -- end,
          -- env = {
          --   ASPNETCORE_ENVIRONMENT = function()
          --     -- todo: request input from ui
          --     return "Development"
          --   end,
          --   ASPNETCORE_URLS = function()
          --     -- todo: request input from ui
          --     return "http://localhost:5050"
          --   end,
          -- },
          -- cwd = function()
          --   -- todo: request input from ui
          --   return vim.fn.getcwd()
          -- end,
        },
      }
    end,
  },
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
