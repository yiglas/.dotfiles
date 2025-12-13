return {
  { import = "lazyvim.plugins.extras.test.core" },
  {
    "nvim-neotest/neotest",
    optional = true,
    dependencies = {
      "Issafalcon/neotest-dotnet",
    },
    opts = function(_, opts)
      -- Ensure adapters table exists
      opts.adapters = opts.adapters or {}
      
      -- Properly instantiate neotest-dotnet adapter
      table.insert(
        opts.adapters,
        require("neotest-dotnet")({
          -- Solution-level discovery (optimized for multi-project)
          discovery_root = "solution",

          -- Aggressive filtering for 2k test solution
          filter_dirs = {
            "bin",
            "obj",
            "node_modules",
            ".git",
            ".vs",
            "packages",
            "TestResults",
            ".nuget",
          },

          -- Skip build and restore for faster test execution
          -- NOTE: You must build manually first (e.g., dotnet build)
          dotnet_additional_args = {
            "--no-restore",
            "--no-build",  -- Skip build - tests run much faster
            "--logger:console;verbosity=normal",  -- Better output visibility
          },

          -- xUnit 2 support (future-compatible with xUnit 3)
          -- neotest-dotnet auto-detects xUnit, no special config needed
        })
      )

      -- Discovery settings (balanced for 2k tests)
      opts.discovery = {
        enabled = true, -- Enable discovery (needed to find tests)
        concurrent = 1, -- Single worker for 2k tests (conservative for stability)
        filter_dir = function(name, rel_path, root)
          -- Filter out build artifacts and packages
          local filtered = {
            "bin", "obj", "node_modules", ".git", ".vs", 
            "packages", "TestResults", ".nuget"
          }
          for _, dir in ipairs(filtered) do
            if name == dir then
              return false
            end
          end
          return true
        end,
      }

      -- Output panel configuration (split panel)
      opts.output = {
        enabled = true,
        open_on_run = "short",
      }

      opts.output_panel = {
        enabled = true,
        open = "botright split | resize 15",
      }
      
      -- Floating window configuration (borders for popups)
      opts.floating = {
        border = "rounded",  -- rounded, single, double, shadow
        max_height = 0.8,
        max_width = 0.9,
      }

      -- Performance tuning
      opts.quickfix = {
        enabled = true,
        open = false,
      }

      -- Visual feedback (inline status)
      opts.status = {
        enabled = true,
        signs = true,
        virtual_text = true,
      }

      -- Summary window
      opts.summary = {
        enabled = true,
        open = "botright vsplit | vertical resize 50",
      }

      opts.diagnostic = {
        enabled = true,
      }

      opts.run = {
        enabled = true,
      }
      
      return opts
    end,

    keys = {
      -- === PRIMARY WORKFLOWS ===

      -- Workflow 1: Run individual test
      {
        "<leader>tr",
        function()
          require("neotest").run.run()
        end,
        desc = "Run Nearest Test",
      },

      -- Workflow 2: Run test file
      {
        "<leader>tf",
        function()
          require("neotest").run.run(vim.fn.expand("%"))
        end,
        desc = "Run Current Test File",
      },

      -- Workflow 3: Run all tests (solution-wide)
      {
        "<leader>tT",
        function()
          require("neotest").run.run(vim.fn.getcwd())
        end,
        desc = "Run All Tests (Solution)",
      },

      -- === DEBUG SUPPORT ===

      {
        "<leader>td",
        function()
          require("neotest").run.run({ strategy = "dap" })
        end,
        desc = "Debug Nearest Test",
      },
      {
        "<leader>tD",
        function()
          require("neotest").run.run({ vim.fn.expand("%"), strategy = "dap" })
        end,
        desc = "Debug Test File",
      },

      -- === TEST MANAGEMENT ===

      -- Toggle summary (discovery happens automatically when opening)
      {
        "<leader>ts",
        function()
          require("neotest").summary.toggle()
        end,
        desc = "Toggle Test Summary",
      },

      -- Manual discovery refresh (not needed - discovery is automatic on summary open)
      -- But keeping for manual control if needed
      {
        "<leader>tR",
        function()
          -- Close and reopen summary to force re-discovery
          local neotest = require("neotest")
          local summary_open = false
          -- Check if summary is open
          for _, win in ipairs(vim.api.nvim_list_wins()) do
            local buf = vim.api.nvim_win_get_buf(win)
            if vim.api.nvim_buf_get_name(buf):match("Neotest Summary") then
              summary_open = true
              break
            end
          end
          
          if summary_open then
            neotest.summary.close()
            vim.defer_fn(function()
              neotest.summary.open()
            end, 100)
          else
            neotest.summary.open()
          end
          
          vim.notify("Test discovery triggered", vim.log.levels.INFO)
        end,
        desc = "Refresh Test Discovery",
      },

      {
        "<leader>to",
        function()
          require("neotest").output.open({ enter = true, auto_close = true })
        end,
        desc = "Show Test Output (floating with border)",
      },
      {
        "<leader>tO",
        function()
          require("neotest").output_panel.toggle()
        end,
        desc = "Toggle Test Output Panel",
      },

      -- Build solution before running tests (required with --no-build)
      {
        "<leader>tb",
        function()
          -- Open a terminal split and run dotnet build
          vim.cmd("botright split | resize 15 | terminal dotnet build")
          vim.cmd("startinsert")
          
          vim.notify("Building solution in terminal...", vim.log.levels.INFO)
        end,
        desc = "Build Solution (in terminal split)",
      },

      -- Stop running tests (useful for 2k test suite)
      {
        "<leader>tS",
        function()
          require("neotest").run.stop()
        end,
        desc = "Stop Running Tests",
      },

      -- Watch mode (TDD workflow)
      {
        "<leader>tw",
        function()
          require("neotest").watch.toggle(vim.fn.expand("%"))
        end,
        desc = "Toggle Test Watch Mode",
      },

      -- === NAVIGATION ===

      {
        "]t",
        function()
          require("neotest").jump.next({ status = "failed" })
        end,
        desc = "Jump to Next Failed Test",
      },
      {
        "[t",
        function()
          require("neotest").jump.prev({ status = "failed" })
        end,
        desc = "Jump to Previous Failed Test",
      },
    },
  },
}
