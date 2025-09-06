local function rebuild_project(co, path)
  local spinner = require("easy-dotnet.ui-modules.spinner").new()
  spinner:start_spinner("building")

  vim.fn.jobstart(string.format("dotnet build %s", path), {
    on_exit = function(_, return_code)
      if return_code == 0 then
        spinner:stop_spinner("Built Successfully")
      else
        spinner:stop_spinner("Build failed with exit code" .. return_code, vim.log.levels.ERROR)
        error("Build failed")
      end
      coroutine.resume(co)
    end,
  })
end

-- local function add_dotnet_mappings()
--   local dotnet = require("easy-dotnet")
--
--   vim.keymap.set({ "n", "v" }, "<leader>to", function()
--     vim.cmd("Dotnet testrunner")
--   end, { nowait = true, desc = "Show testrunner" })
--
--   vim.keymap.set({ "n", "v" }, "<C-p>", function()
--     dotnet.run_with_profile(true)
--   end, { nowait = true, desc = "Run with profile" })
--
--   vim.keymap.set("n", "<C-b>", dotnet.build, { nowait = true, desc = "Build" })
--
--   vim.keymap.set("n", "<C-r>", dotnet.run, { nowait = true, desc = "Run" })
-- end

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

      vim.lsp.config("roslyn", {
        cmd = cmd,
        handlers = require("rzls.roslyn_handlers"),
        settings = {
          ["csharp|inlay_hints"] = {
            csharp_enable_inlay_hints_for_implicit_object_creation = true,
            csharp_enable_inlay_hints_for_implicit_variable_types = true,

            csharp_enable_inlay_hints_for_lambda_parameter_types = true,
            csharp_enable_inlay_hints_for_types = true,
            dotnet_enable_inlay_hints_for_indexer_parameters = true,
            dotnet_enable_inlay_hints_for_literal_parameters = true,
            dotnet_enable_inlay_hints_for_object_creation_parameters = true,
            dotnet_enable_inlay_hints_for_other_parameters = true,
            dotnet_enable_inlay_hints_for_parameters = true,
            dotnet_suppress_inlay_hints_for_parameters_that_differ_only_by_suffix = true,
            dotnet_suppress_inlay_hints_for_parameters_that_match_argument_name = true,
            dotnet_suppress_inlay_hints_for_parameters_that_match_method_intent = true,
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
    "mfussenegger/nvim-dap",
    optional = true,
    opts = function()
      local dap = require("dap")
      local netcoredbg_adapter = {
        type = "executable",
        command = vim.fn.exepath("netcoredbg"),
        args = { "--interpreter=vscode" },
      }

      dap.adapters.netcoredbg = netcoredbg_adapter -- needed for normal debugging
      dap.adapters.coreclr = netcoredbg_adapter -- needed for unit test debugging
    end,
  },
  {
    "nvim-neotest/neotest",
    commit = "52fca6717ef972113ddd6ca223e30ad0abb2800c",
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
  -- { import = "lazyvim.plugins.extras.lang.omnisharp" },
  -- {
  --   "GustavEikaas/easy-dotnet.nvim",
  --   dependencies = { "nvim-lua/plenary.nvim" },
  --   ft = { "cs" },
  --   cmd = { "Dotnet" },
  --   opts = {
  --     picker = "snacks",
  --   },
  --   config = function()
  --     local dotnet = require("easy-dotnet")
  --     dotnet.setup({
  --       test_runner = {
  --         enable_buffer_test_execution = true,
  --         viewmode = "vsplit",
  --         vsplit_width = 30,
  --         mappings = {
  --           run_test_from_buffer = { lhs = "<leader>r", desc = "run test from buffer" },
  --           filter_failed_tests = { lhs = "<leader>fe", desc = "filter failed tests" },
  --           debug_test = { lhs = "<leader>d", desc = "debug test" },
  --           go_to_file = { lhs = "g", desc = "go to file" },
  --           run_all = { lhs = "<leader>R", desc = "run all tests" },
  --           run = { lhs = "<leader>r", desc = "run test" },
  --           peek_stacktrace = { lhs = "<leader>p", desc = "peek stacktrace of failed test" },
  --           expand = { lhs = "l", desc = "expand" },
  --           expand_node = { lhs = "E", desc = "expand node" },
  --           expand_all = { lhs = "-", desc = "expand all" },
  --           collapse_all = { lhs = "W", desc = "collapse all" },
  --           close = { lhs = "q", desc = "close testrunner" },
  --           refresh_testrunner = { lhs = "r", desc = "refresh testrunner" },
  --         },
  --       },
  --       auto_bootstrap_namespace = {
  --         type = "file_scoped",
  --         enabled = false,
  --       },
  --       terminal = function(path, action, args)
  --         local commands = {
  --           run = function()
  --             return string.format("dotnet run --project %s %s", path, args)
  --           end,
  --           test = function()
  --             return string.format("dotnet test %s %s", path, args)
  --           end,
  --           restore = function()
  --             return string.format("dotnet restore %s %s", path, args)
  --           end,
  --           build = function()
  --             return string.format("dotnet build %s %s", path, args)
  --           end,
  --           watch = function()
  --             return string.format("dotnet watch --project %s %s", path, args)
  --           end,
  --         }
  --
  --         local command = commands[action]() .. "\r"
  --         require("toggleterm").exec(command, nil, nil, nil, "float")
  --       end,
  --     })
  --
  --     local function add_dotnet_mappings()
  --       vim.keymap.set("n", "<leader>to", function()
  --         vim.cmd("Dotnet testrunner")
  --       end, { desc = "Show testrunner" })
  --
  --       -- vim.keymap.set("n", "<C-p>", dotnet.run_with_profile, { desc = "Run with profile" })
  --       -- vim.keymap.set("n", "<C-b>", dotnet.build, { desc = "Build" })
  --       vim.keymap.set("n", "<C-r>", dotnet.run, { desc = "Run" })
  --       vim.keymap.set("n", "<leader>tt", function()
  --         require("easy-dotnet").show_test_runner()
  --       end, { desc = "Toggle test runner" })
  --     end
  --
  --     vim.api.nvim_create_autocmd("VimEnter", {
  --       pattern = "*.cs",
  --       callback = function()
  --         if dotnet.is_dotnet_project() then
  --           add_dotnet_mappings()
  --         end
  --       end,
  --     })
  --   end,
  -- },
}
