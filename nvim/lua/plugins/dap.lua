return {
  { import = "lazyvim.plugins.extras.dap.core" },

  -- Override LazyVim's DAP icons
  {
    "LazyVim/LazyVim",
    opts = {
      icons = {
        dap = {
          Stopped = { "→", "DiagnosticWarn", "DapStoppedLine" },
          Breakpoint = { "●", "DiagnosticError" },
          BreakpointCondition = { "●", "DiagnosticWarn" },
          BreakpointRejected = { "○", "DiagnosticError" },
          LogPoint = { "◆", "DiagnosticInfo" },
        },
      },
    },
  },

  -- Configure the stopped line highlight
  {
    "mfussenegger/nvim-dap",
    init = function()
      -- Set highlight on VimEnter and ColorScheme to ensure it persists
      vim.api.nvim_create_autocmd({ "VimEnter", "ColorScheme" }, {
        callback = function()
          vim.api.nvim_set_hl(0, "DapStoppedLine", { bg = "#3d3d00" })
        end,
      })

      -- nvim-dap reads .vscode/launch.json on demand (see :help dap-providers).
      -- We override the coreclr adapter to the current netcoredbg arm64 build
      -- bundled by Cliffback/netcoredbg-macOS-arm64.nvim. mason-nvim-dap defaults
      -- coreclr to Mason's netcoredbg, which is a 2020 build that can't attach
      -- to .NET 8+. We also register the VS Code `type` -> filetype map and
      -- wire overseer once nvim-dap finishes loading.
      vim.api.nvim_create_autocmd("User", {
        pattern = "LazyLoad",
        callback = function(args)
          if args.data ~= "nvim-dap" then
            return
          end

          local dap = require("dap")
          dap.set_log_level("TRACE")

          local netcoredbg = vim.fn.stdpath("data") .. "/lazy/netcoredbg-macOS-arm64.nvim/netcoredbg/netcoredbg"
          dap.adapters.coreclr = {
            type = "executable",
            command = netcoredbg,
            args = { "--interpreter=vscode" },
          }

          dap.configurations.cs = {
            {
              type = "coreclr",
              name = "Launch",
              request = "launch",
              program = function()
                local cwd = vim.fn.getcwd()
                local csproj = vim.fn.glob(cwd .. "/*.csproj")
                local default = cwd .. "/bin/Debug/"
                if csproj ~= "" then
                  local name = vim.fn.fnamemodify(csproj, ":t:r")
                  for _, tfm in ipairs({ "net10.0", "net9.0", "net8.0" }) do
                    local candidate = cwd .. "/bin/Debug/" .. tfm .. "/" .. name .. ".dll"
                    if vim.fn.filereadable(candidate) == 1 then
                      default = candidate
                      break
                    end
                  end
                end
                return vim.fn.input("Path to dll: ", default, "file")
              end,
              cwd = "${workspaceFolder}",
              stopAtEntry = false,
            },
          }

          local vscode = require("dap.ext.vscode")
          vscode.type_to_filetypes = vim.tbl_extend("force", vscode.type_to_filetypes or {}, {
            coreclr = { "cs", "fsharp" },
            node = { "javascript", "typescript", "javascriptreact", "typescriptreact" },
            ["pwa-node"] = { "javascript", "typescript", "javascriptreact", "typescriptreact" },
            ["pwa-chrome"] = { "javascript", "typescript", "javascriptreact", "typescriptreact" },
            chrome = { "javascript", "typescript", "javascriptreact", "typescriptreact" },
          })

          local ok, overseer = pcall(require, "overseer")
          if ok and overseer.patch_dap then
            overseer.patch_dap(true)
          end
        end,
      })
    end,
    keys = {
      {
        "<F5>",
        function()
          require("dap").continue()
        end,
        desc = "Run/Continue",
      },
      {
        "<F10>",
        function()
          require("dap").step_over()
        end,
        desc = "Step Over",
      },
      {
        "<F11>",
        function()
          require("dap").step_into()
        end,
        desc = "Step Into",
      },
      {
        "<F12>",
        function()
          require("dap").step_out()
        end,
        desc = "Step Out",
      },
      {
        "<F9>",
        function()
          require("dap").toggle_breakpoint()
        end,
        desc = "Toggle Breakpoint",
      },
    },
  },
}
