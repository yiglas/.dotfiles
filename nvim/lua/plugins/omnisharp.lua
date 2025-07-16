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
  { import = "lazyvim.plugins.extras.lang.omnisharp" },

  {
    "GustavEikaas/easy-dotnet.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    ft = { "cs" },
    cmd = { "Dotnet" },
    opts = {
      picker = "snacks",
    },
    config = function()
      local dotnet = require("easy-dotnet")
      dotnet.setup({
        test_runner = {
          enable_buffer_test_execution = true,
          viewmode = "vsplit",
          vsplit_width = 30,
          mappings = {
            run_test_from_buffer = { lhs = "<leader>r", desc = "run test from buffer" },
            filter_failed_tests = { lhs = "<leader>fe", desc = "filter failed tests" },
            debug_test = { lhs = "<leader>d", desc = "debug test" },
            go_to_file = { lhs = "g", desc = "go to file" },
            run_all = { lhs = "<leader>R", desc = "run all tests" },
            run = { lhs = "<leader>r", desc = "run test" },
            peek_stacktrace = { lhs = "<leader>p", desc = "peek stacktrace of failed test" },
            expand = { lhs = "l", desc = "expand" },
            expand_node = { lhs = "E", desc = "expand node" },
            expand_all = { lhs = "-", desc = "expand all" },
            collapse_all = { lhs = "W", desc = "collapse all" },
            close = { lhs = "q", desc = "close testrunner" },
            refresh_testrunner = { lhs = "r", desc = "refresh testrunner" },
          },
        },
        auto_bootstrap_namespace = {
          type = "file_scoped",
          enabled = true,
        },
        terminal = function(path, action, args)
          local commands = {
            run = function()
              return string.format("dotnet run --project %s %s", path, args)
            end,
            test = function()
              return string.format("dotnet test %s %s", path, args)
            end,
            restore = function()
              return string.format("dotnet restore %s %s", path, args)
            end,
            build = function()
              return string.format("dotnet build %s %s", path, args)
            end,
            watch = function()
              return string.format("dotnet watch --project %s %s", path, args)
            end,
          }

          local command = commands[action]() .. "\r"
          require("toggleterm").exec(command, nil, nil, nil, "float")
        end,
      })

      local function add_dotnet_mappings()
        vim.keymap.set("n", "<leader>to", function()
          vim.cmd("Dotnet testrunner")
        end, { desc = "Show testrunner" })

        -- vim.keymap.set("n", "<C-p>", dotnet.run_with_profile, { desc = "Run with profile" })
        -- vim.keymap.set("n", "<C-b>", dotnet.build, { desc = "Build" })
        vim.keymap.set("n", "<C-r>", dotnet.run, { desc = "Run" })
        vim.keymap.set("n", "<leader>tt", function()
          require("easy-dotnet").show_test_runner()
        end, { desc = "Toggle test runner" })
      end

      vim.api.nvim_create_autocmd("VimEnter", {
        callback = function()
          if dotnet.is_dotnet_project() then
            add_dotnet_mappings()
          end
        end,
      })
    end,
  },

  -- {
  --   "seblyng/roslyn.nvim",
  --   ft = { "cs", "razor" },
  --   dependencies = {
  --     {
  --       "tris203/rzls.nvim",
  --       config = true,
  --     },
  --   },
  --   config = function()
  --     local lspconfig = require("lspconfig")
  --     local configs = require("lspconfig.configs")
  --
  --     -- Manually define the 'roslyn' server if it's not already defined
  --     if not configs.roslyn then
  --       configs.roslyn = {
  --         default_config = {
  --           cmd = { "dotnet", "roslyn-lsp", "--stdio" },
  --           filetypes = { "cs", "razor" },
  --           root_dir = lspconfig.util.root_pattern("*.sln", "*.csproj", ".git"),
  --           settings = {},
  --           handlers = require("rzls.roslyn_handlers"),
  --         },
  --       }
  --     end
  --
  --     -- Now setup the custom server
  --     lspconfig.roslyn.setup({})
  --   end,
  --
  --   init = function()
  --     vim.filetype.add({
  --       extension = {
  --         razor = "razor",
  --         cshtml = "razor",
  --       },
  --     })
  --   end,
  -- },

  -- {
  --   "seblyng/roslyn.nvim",
  --   ft = { "cs", "razor", "cshtml" },
  --   dependencies = {
  --     {
  --       "tris203/rzls.nvim",
  --       config = true,
  --     },
  --   },
  --   config = function()
  --     local cmd = { "dotnet", "roslyn-lsp", "--stdio" }
  --     require("lspconfig").roslyn.setup({
  --       cmd = cmd,
  --       handlers = require("rzls.roslyn_handlers"),
  --       settings = {
  --         ["csharp|inlay_hints"] = {
  --           csharp_enable_inlay_hints_for_implicit_variable_types = true,
  --         },
  --         ["csharp|code_lens"] = {
  --           dotnet_enable_references_code_lens = true,
  --         },
  --       },
  --     })
  --   end,
  --   init = function()
  --     vim.filetype.add({
  --       extension = {
  --         razor = "razor",
  --         cshtml = "razor",
  --       },
  --     })
  --   end,
  -- },

  -- {
  --   "nvim-telescope/telescope-dap.nvim",
  --   dependencies = { "nvim-telescope/telescope.nvim" },
  --   config = function()
  --     require("telescope").load_extension("dap")
  --     vim.keymap.set("n", "<leader>dc", "<cmd>Telescope dap commands<cr>", { desc = "DAP Commands" })
  --   end,
  -- },

  -- {
  --   "mason-org/mason.nvim",
  --   opts = {
  --     registries = {
  --       "github:mason-org/mason-registry",
  --       "github:Crashdummyy/mason-registry",
  --     },
  --   },
  -- },
  -- {
  --   "seblyng/roslyn.nvim",
  --   ft = { "cs", "razor" },
  --   dependencies = {
  --     {
  --       -- By loading as a dependencies, we ensure that we are available to set
  --       -- the handlers for Roslyn.
  --       "tris203/rzls.nvim",
  --       config = true,
  --     },
  --   },
  --   config = function()
  --     -- Use one of the methods in the Integration section to compose the command.
  --     local cmd = {}
  --
  --     vim.lsp.config("roslyn", {
  --       cmd = cmd,
  --       handlers = require("rzls.roslyn_handlers"),
  --       settings = {
  --         ["csharp|inlay_hints"] = {
  --           csharp_enable_inlay_hints_for_implicit_object_creation = true,
  --           csharp_enable_inlay_hints_for_implicit_variable_types = true,
  --
  --           csharp_enable_inlay_hints_for_lambda_parameter_types = true,
  --           csharp_enable_inlay_hints_for_types = true,
  --           dotnet_enable_inlay_hints_for_indexer_parameters = true,
  --           dotnet_enable_inlay_hints_for_literal_parameters = true,
  --           dotnet_enable_inlay_hints_for_object_creation_parameters = true,
  --           dotnet_enable_inlay_hints_for_other_parameters = true,
  --           dotnet_enable_inlay_hints_for_parameters = true,
  --           dotnet_suppress_inlay_hints_for_parameters_that_differ_only_by_suffix = true,
  --           dotnet_suppress_inlay_hints_for_parameters_that_match_argument_name = true,
  --           dotnet_suppress_inlay_hints_for_parameters_that_match_method_intent = true,
  --         },
  --         ["csharp|code_lens"] = {
  --           dotnet_enable_references_code_lens = true,
  --         },
  --       },
  --     })
  --     vim.lsp.enable("roslyn")
  --   end,
  --   init = function()
  --     -- We add the Razor file types before the plugin loads.
  --     vim.filetype.add({
  --       extension = {
  --         razor = "razor",
  --         cshtml = "razor",
  --       },
  --     })
  --   end,
  -- },
  {
    "Cliffback/netcoredbg-macOS-arm64.nvim",
    config = function()
      require("netcoredbg-macOS-arm64").setup(require("dap"))
    end,
    enabled = not (vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1),
  },
  -- {
  --   "GustavEikaas/easy-dotnet.nvim",
  --   dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim" },
  --   config = function()
  --     local dotnet = require("easy-dotnet")
  --     dotnet.setup({
  --       test_runner = {
  --         enable_buffer_test_execution = true,
  --         viewmode = "float",
  --       },
  --       auto_bootstrap_namespace = {
  --         type = "file_scoped",
  --         enabled = true,
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
  --     vim.api.nvim_create_autocmd("VimEnter", {
  --       callback = function()
  --         if dotnet.is_dotnet_project() then
  --           add_dotnet_mappings()
  --         end
  --       end,
  --     })
  --   end,
  -- },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters = {
        csharpier = {
          command = "csharpier",
          args = { "format", "--write-stdout" },
        },
      },
    },
  },
  -- {
  --   "mfussenegger/nvim-dap",
  --   optional = true,
  --   opts = function()
  --     local dap = require("dap")
  --     if not dap.adapters["netcoredbg"] then
  --       require("dap").adapters["netcoredbg"] = {
  --         type = "executable",
  --         command = vim.fn.exepath("netcoredbg"),
  --         args = { "--interpreter=vscode" },
  --         options = {
  --           detached = false,
  --         },
  --       }
  --     end
  --     for _, lang in ipairs({ "cs", "fsharp", "vb" }) do
  --       if not dap.configurations[lang] then
  --         dap.configurations[lang] = {
  --           {
  --             type = "netcoredbg",
  --             name = "Launch file",
  --             request = "launch",
  --             ---@diagnostic disable-next-line: redundant-parameter
  --             program = function()
  --               return vim.fn.input("Path to dll: ", vim.fn.getcwd() .. "/", "file")
  --             end,
  --             cwd = "${workspaceFolder}",
  --           },
  --         }
  --       end
  --     end
  --   end,
  -- },
  -- {
  --   "mfussenegger/nvim-dap",
  --   config = function()
  --     local dap = require("dap")
  --
  --     vim.keymap.set("n", "<F5>", dap.continue, {})
  --     vim.keymap.set("n", "<F10>", dap.step_over, {})
  --     vim.keymap.set("n", "<F11>", dap.step_into, {})
  --     vim.keymap.set("n", "<F12>", dap.step_out, {})
  --     vim.keymap.set("n", "<F2>", require("dap.ui.widgets").hover, {})
  --     vim.keymap.set("n", "<F9>", dap.toggle_breakpoint, {})
  --
  --     local dotnet = require("easy-dotnet")
  --     local debug_dll = nil
  --
  --     local function ensure_dll()
  --       if debug_dll ~= nil then
  --         return debug_dll
  --       end
  --       local dll = dotnet.get_debug_dll(true)
  --       debug_dll = dll
  --       return dll
  --     end
  --
  --     for _, value in ipairs({ "cs", "fsharp" }) do
  --       dap.configurations[value] = {
  --         {
  --           type = "coreclr",
  --           name = "Program",
  --           request = "launch",
  --           env = function()
  --             local dll = ensure_dll()
  --             local vars = dotnet.get_environment_variables(dll.project_name, dll.relative_project_path)
  --             return vars or nil
  --           end,
  --           program = function()
  --             local dll = ensure_dll()
  --             local co = coroutine.running()
  --             rebuild_project(co, dll.project_path)
  --             return dll.relative_dll_path
  --           end,
  --           cwd = function()
  --             local dll = ensure_dll()
  --             return dll.relative_project_path
  --           end,
  --         },
  --         {
  --           type = "coreclr",
  --           name = "Test",
  --           request = "attach",
  --           processId = function()
  --             local res = require("easy-dotnet").experimental.start_debugging_test_project()
  --             return res.process_id
  --           end,
  --         },
  --       }
  --     end
  --
  --     dap.listeners.before["event_terminated"]["easy-dotnet"] = function()
  --       debug_dll = nil
  --     end
  --
  --     dap.adapters.coreclr = {
  --       type = "executable",
  --       command = vim.fn.exepath("netcoredbg"),
  --       args = { "--interpreter=vscode" },
  --     }
  --   end,
  -- },
}
