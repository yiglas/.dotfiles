return {
  {
    "Cliffback/netcoredbg-macOS-arm64.nvim",
    ft = { "cs" },
    config = function()
      require("netcoredbg-macOS-arm64").setup(require("dap"))
    end,
    enabled = vim.fn.has("macunix") == 1,
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
        -- LSP client names to hook into
        client_names = { "roslyn_ls", "roslyn", "roslyn_lsp" },

        -- Auto-detect project type (unity, console, large, etc.)
        preset = "auto",

        -- Parse .sln to limit watch scope to project folders (improves performance)
        solution_aware = true,

        -- Respect .gitignore patterns
        respect_gitignore = true,

        -- Enable dotnet CLI commands (:RoslynBuild, :RoslynRun, :RoslynWatch, :RoslynClean)
        enable_dotnet_commands = true,

        -- Enable NuGet commands (:RoslynNuget, :RoslynNugetRemove, :RoslynRestore)
        enable_nuget_commands = true,

        -- Auto-restore NuGet packages when .csproj changes
        enable_autorestore = true,

        -- Diagnostic throttling to reduce UI lag during heavy file changes
        diagnostic_throttling = {
          enabled = true,
          debounce_ms = 500,
          visible_only = true,
        },

        -- Logging level (set to INFO for debugging, WARN for normal use)
        log_level = vim.log.levels.WARN,
      })

      -- Auto-restart Roslyn on git branch changes (via Neogit)
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
    end,
  },
  -- =============================================================================
  -- C# Debug Configuration
  -- Automatically discovers .NET projects and configures DAP for debugging
  -- =============================================================================
  {
    "mfussenegger/nvim-dap",
    ft = { "cs", "razor" },
    config = function()
      local dap = require("dap")
      local M = {}

      -- Set up DAP signs with nice icons
      vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DiagnosticError", linehl = "", numhl = "" })
      vim.fn.sign_define("DapBreakpointCondition", { text = "●", texthl = "DiagnosticWarn", linehl = "", numhl = "" })
      vim.fn.sign_define("DapLogPoint", { text = "◆", texthl = "DiagnosticInfo", linehl = "", numhl = "" })
      vim.fn.sign_define("DapStopped", { text = "→", texthl = "DiagnosticOk", linehl = "DapStoppedLine", numhl = "" })
      vim.fn.sign_define("DapBreakpointRejected", { text = "○", texthl = "DiagnosticError", linehl = "", numhl = "" })

      -- Yellow background for stopped line
      vim.api.nvim_set_hl(0, "DapStoppedLine", { bg = "#3d3d00" })

      -- Configuration options
      M.config = {
        project_dirs = { "Source", "src", "." },
        framework_versions = { "net9.0", "net8.0", "net7.0", "net6.0" },
        build_configuration = "Debug",
      }

      --- Find all .csproj files in configured directories
      function M.find_csproj_files()
        local projects = {}
        local cwd = vim.fn.getcwd()

        for _, dir in ipairs(M.config.project_dirs) do
          local search_dir = cwd .. "/" .. dir
          if vim.fn.isdirectory(search_dir) == 1 then
            local csproj_files = vim.fn.glob(search_dir .. "/**/*.csproj", false, true)
            for _, csproj_path in ipairs(csproj_files) do
              csproj_path = csproj_path:gsub("\\", "/")
              local project_name = vim.fn.fnamemodify(csproj_path, ":t:r")
              projects[project_name] = csproj_path
            end
          end
        end

        return projects
      end

      --- Parse launchSettings.json for a given project
      function M.parse_launch_settings(project_dir, project_name)
        local launch_settings_path = project_dir .. "/Properties/launchSettings.json"

        if vim.fn.filereadable(launch_settings_path) ~= 1 then
          return nil
        end

        local content = vim.fn.readfile(launch_settings_path)
        if not content or #content == 0 then
          return nil
        end

        -- Remove // comments from JSON
        local clean_lines = {}
        for _, line in ipairs(content) do
          local in_string = false
          local result = ""
          local i = 1
          while i <= #line do
            local char = line:sub(i, i)
            local next_char = line:sub(i + 1, i + 1)
            if char == '"' and (i == 1 or line:sub(i - 1, i - 1) ~= "\\") then
              in_string = not in_string
              result = result .. char
            elseif not in_string and char == "/" and next_char == "/" then
              break
            else
              result = result .. char
            end
            i = i + 1
          end
          table.insert(clean_lines, result)
        end

        local ok, parsed = pcall(vim.fn.json_decode, table.concat(clean_lines, "\n"))
        if not ok or not parsed then
          return nil
        end

        if parsed.profiles and parsed.profiles[project_name] then
          return parsed.profiles[project_name]
        end

        return nil
      end

      --- Detect the output DLL path for a project
      function M.detect_dll_path(project_dir, project_name)
        local debug_dir = project_dir .. "/bin/" .. M.config.build_configuration

        for _, framework in ipairs(M.config.framework_versions) do
          local dll_path = debug_dir .. "/" .. framework .. "/" .. project_name .. ".dll"
          if vim.fn.filereadable(dll_path) == 1 then
            return dll_path
          end
        end

        local direct_path = debug_dir .. "/" .. project_name .. ".dll"
        if vim.fn.filereadable(direct_path) == 1 then
          return direct_path
        end

        if vim.fn.isdirectory(debug_dir) == 1 then
          local subdirs = vim.fn.glob(debug_dir .. "/net*", false, true)
          if #subdirs > 0 then
            table.sort(subdirs, function(a, b)
              return a > b
            end)
            return subdirs[1]:gsub("\\", "/") .. "/" .. project_name .. ".dll"
          end
        end

        return debug_dir .. "/" .. M.config.framework_versions[1] .. "/" .. project_name .. ".dll"
      end

      --- Build environment variables from launch profile
      function M.build_env_vars(profile)
        local env = {}
        if profile.environmentVariables then
          for key, value in pairs(profile.environmentVariables) do
            env[key] = value
          end
        end
        if profile.applicationUrl then
          env.ASPNETCORE_URLS = profile.applicationUrl
        end
        return env
      end

      --- Normalize path for the current OS
      function M.normalize_path(path)
        if vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1 then
          return path:gsub("/", "\\")
        end
        return path
      end

      --- Generate DAP configurations from discovered projects
      function M.generate_dap_configurations()
        local configurations = {}
        local projects = M.find_csproj_files()
        local cwd = vim.fn.getcwd():gsub("\\", "/")

        for project_name, csproj_path in pairs(projects) do
          local project_dir = vim.fn.fnamemodify(csproj_path, ":h")
          local profile = M.parse_launch_settings(project_dir, project_name)

          if profile and profile.commandName == "Project" then
            local dll_path = M.detect_dll_path(project_dir, project_name)
            local env = M.build_env_vars(profile)
            local relative_csproj = csproj_path:gsub(cwd .. "/", "")
            local workspace_root = M.normalize_path(cwd)

            table.insert(configurations, {
              type = "coreclr",
              name = project_name,
              request = "launch",
              program = M.normalize_path(dll_path),
              cwd = M.normalize_path(project_dir),
              args = {},
              env = env,
              stopAtEntry = false,
              justMyCode = false,
              console = "internalConsole",
              externalTerminal = false,
              sourceFileMap = {
                [workspace_root] = workspace_root,
              },
              _csproj_path = relative_csproj,
              _project_name = project_name,
            })
          end
        end

        table.sort(configurations, function(a, b)
          return a.name < b.name
        end)

        return configurations
      end

      --- Register Overseer build tasks for discovered projects
      function M.register_build_tasks()
        local overseer_ok, overseer = pcall(require, "overseer")
        if not overseer_ok then
          return
        end

        local projects = M.find_csproj_files()
        local cwd = vim.fn.getcwd():gsub("\\", "/")

        for project_name, csproj_path in pairs(projects) do
          local relative_csproj = csproj_path:gsub(cwd .. "/", "")

          overseer.register_template({
            name = "dotnet: build " .. project_name,
            builder = function()
              return {
                cmd = { "dotnet", "build", "-c", M.config.build_configuration, "-v:q", relative_csproj },
                cwd = vim.fn.getcwd(),
                components = {
                  { "on_output_quickfix", open_on_exit = "failure" },
                  "default",
                },
              }
            end,
            condition = {
              filetype = { "cs", "razor" },
            },
          })
        end
      end

      --- Find netcoredbg executable
      function M.find_netcoredbg()
        local mason_path = vim.fn.stdpath("data") .. "/mason"
        local mason_netcoredbg = mason_path .. "/packages/netcoredbg/netcoredbg/netcoredbg"

        if vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1 then
          mason_netcoredbg = mason_netcoredbg .. ".exe"
        end

        if vim.fn.filereadable(mason_netcoredbg) == 1 then
          return M.normalize_path(mason_netcoredbg)
        end

        if vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1 then
          local local_path = vim.fn.expand("$LOCALAPPDATA/netcoredbg/netcoredbg/netcoredbg.exe")
          if vim.fn.filereadable(local_path) == 1 then
            return M.normalize_path(local_path)
          end
        end

        return "netcoredbg"
      end

      --- Setup DAP for C# debugging
      function M.setup_dap()
        dap.set_log_level("TRACE")

        local netcoredbg_cmd = M.find_netcoredbg()
        dap.adapters.coreclr = {
          type = "executable",
          command = netcoredbg_cmd,
          args = { "--interpreter=vscode" },
        }

        dap.defaults.coreclr = dap.defaults.coreclr or {}
        dap.defaults.coreclr.force_external_terminal = false
        dap.defaults.coreclr.external_terminal = nil

        if vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1 then
          dap.listeners.after.event_initialized["fix_breakpoint_paths"] = function(session)
            local breakpoints_module = require("dap.breakpoints")
            local bps = breakpoints_module.get()

            for bufnr, buf_bps in pairs(bps) do
              if #buf_bps > 0 then
                local path = vim.api.nvim_buf_get_name(bufnr)
                local win_path = path:gsub("/", "\\")

                local bp_lines = {}
                for _, bp in ipairs(buf_bps) do
                  table.insert(bp_lines, { line = bp.line })
                end

                if session and session.request then
                  session:request("setBreakpoints", {
                    source = {
                      path = win_path,
                      name = vim.fn.fnamemodify(win_path, ":t"),
                    },
                    breakpoints = bp_lines,
                  })
                end
              end
            end
          end
        end

        local configurations = M.generate_dap_configurations()

        dap.configurations.cs = dap.configurations.cs or {}

        local filtered = {}
        for _, config in ipairs(dap.configurations.cs) do
          if not config._project_name then
            table.insert(filtered, config)
          end
        end
        dap.configurations.cs = filtered

        for _, config in ipairs(configurations) do
          table.insert(dap.configurations.cs, config)
        end

        table.insert(dap.configurations.cs, {
          type = "coreclr",
          name = "Attach to Process",
          request = "attach",
          processId = require("dap.utils").pick_process,
        })

        return true, #configurations
      end

      --- Run pre-launch build for a configuration
      function M.run_pre_launch_build(config, callback)
        if not config._csproj_path or not config._project_name then
          callback(true)
          return
        end

        local overseer_ok, overseer = pcall(require, "overseer")
        if not overseer_ok then
          vim.notify("Overseer not available for pre-launch build", vim.log.levels.WARN)
          callback(true)
          return
        end

        vim.notify("Building " .. config._project_name .. "...", vim.log.levels.INFO)

        local task = overseer.new_task({
          cmd = { "dotnet", "build", "-c", M.config.build_configuration, "-v:q", config._csproj_path },
          cwd = vim.fn.getcwd(),
          components = {
            { "on_output_quickfix", open_on_exit = "failure" },
            "default",
          },
        })

        task:subscribe("on_complete", function(_, result)
          if result == "SUCCESS" then
            vim.notify("Build succeeded, starting debugger...", vim.log.levels.INFO)
            callback(true)
          else
            vim.notify("Build failed", vim.log.levels.ERROR)
            callback(false)
          end
        end)

        task:start()
      end

      --- Refresh DAP configurations
      function M.refresh()
        M.register_build_tasks()
        local ok, count = M.setup_dap()
        if ok then
          vim.notify("Loaded " .. (count or 0) .. " C# debug configurations", vim.log.levels.INFO)
        end
      end

      -- Auto-scroll console/repl to bottom on output
      dap.listeners.after.event_output["auto_scroll"] = function()
        local repl_buf = dap.repl.buf
        if repl_buf then
          local wins = vim.fn.win_findbuf(repl_buf)
          for _, win in ipairs(wins) do
            vim.api.nvim_win_call(win, function()
              vim.cmd("normal! G")
            end)
          end
        end
      end

      -- Store module globally for commands
      _G.CsharpDebug = M

      -- Commands
      vim.api.nvim_create_user_command("DapRefreshCsharp", M.refresh, {
        desc = "Refresh C# DAP configurations from launchSettings.json files",
      })

      vim.api.nvim_create_user_command("DapShowConfig", function()
        print("=== DAP Adapter (coreclr) ===")
        print(vim.inspect(dap.adapters.coreclr))
        print("\n=== DAP Configurations (cs) ===")
        for i, config in ipairs(dap.configurations.cs or {}) do
          print(string.format("\n[%d] %s", i, config.name))
          print("  program: " .. (config.program or "nil"))
          print("  cwd: " .. (config.cwd or "nil"))
        end
      end, { desc = "Show current DAP configuration" })

      vim.api.nvim_create_user_command("DapSelectProject", function()
        M.setup_dap()

        local configs = dap.configurations.cs or {}
        if #configs == 0 then
          vim.notify("No C# debug configurations found", vim.log.levels.WARN)
          return
        end

        vim.ui.select(configs, {
          prompt = "Select project to debug:",
          format_item = function(config)
            local env_info = ""
            if config.env and config.env.ASPNETCORE_URLS then
              env_info = " (" .. config.env.ASPNETCORE_URLS .. ")"
            end
            return config.name .. env_info
          end,
        }, function(config)
          if config then
            M.run_pre_launch_build(config, function(success)
              if success then
                vim.schedule(function()
                  dap.run(config)
                end)
              end
            end)
          end
        end)
      end, { desc = "Select a C# project to debug from launchSettings.json" })

      -- Initialize
      M.register_build_tasks()
      vim.defer_fn(function()
        M.setup_dap()
      end, 500)

      -- F5 handler with auto-refresh and build support for C#
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "cs", "razor" },
        callback = function()
          vim.keymap.set("n", "<F5>", function()
            if dap.session() then
              dap.continue()
              return
            end

            -- Auto-refresh configurations before starting
            M.setup_dap()

            local configs = dap.configurations.cs or {}
            if #configs == 0 then
              vim.notify("No C# debug configurations found", vim.log.levels.WARN)
              return
            end

            local function run_with_build(config)
              M.run_pre_launch_build(config, function(success)
                if success then
                  vim.schedule(function()
                    dap.run(config)
                  end)
                end
              end)
            end

            vim.ui.select(configs, {
              prompt = "Select configuration:",
              format_item = function(config)
                return config.name
              end,
            }, function(config)
              if config then
                run_with_build(config)
              end
            end)
          end, { buffer = true, desc = "Debug: Start/Continue (C#)" })

          vim.keymap.set("n", "<leader>dp", function()
            vim.cmd("DapSelectProject")
          end, { buffer = true, desc = "Debug: Select Project" })
        end,
      })
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
