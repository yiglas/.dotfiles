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
    -- nvim-dap's libuv stdout/stderr read callbacks contain unsafe
    -- `assert(not err, err)` calls. When the adapter's pipe gets a transient
    -- libuv error (e.g., EAGAIN/EINTR during .NET runtime startup), the
    -- assert throws inside the libuv callback with no Lua frame to catch it,
    -- crashing nvim. We replace the asserts with a silent skip: drop the
    -- problem chunk and keep reading. EOF still arrives via `chunk == nil`.
    -- Re-run with `:Lazy build nvim-dap` after plugin updates.
    build = function()
      local session_path = vim.fn.stdpath("data") .. "/lazy/nvim-dap/lua/dap/session.lua"
      if vim.fn.filereadable(session_path) ~= 1 then
        return
      end
      local lines = vim.fn.readfile(session_path)
      local changed = false
      for i, line in ipairs(lines) do
        if line:match("^%s*assert%(not err, err%)%s*$")
          or line:match("^%s*if err then pipe:close%(%); return end%s*$")
          or line:match("^%s*if err then stderr:close%(%); return end%s*$")
        then
          local indent = line:match("^(%s*)") or ""
          lines[i] = indent .. "if err then return end"
          changed = true
        end
      end
      if changed then
        vim.fn.writefile(lines, session_path)
        local cache_dir = vim.fn.stdpath("cache") .. "/luac"
        for _, f in ipairs(vim.fn.glob(cache_dir .. "/*session.luac", false, true)) do
          vim.fn.delete(f)
        end
      end
    end,
    init = function()
      -- Set highlight on VimEnter and ColorScheme to ensure it persists
      vim.api.nvim_create_autocmd({ "VimEnter", "ColorScheme" }, {
        callback = function()
          vim.api.nvim_set_hl(0, "DapStoppedLine", { bg = "#3d3d00" })
        end,
      })

      -- nvim-dap reads .vscode/launch.json on demand (see :help dap-providers
      -- and the F5 keymap below). We override the coreclr adapter to a
      -- locally-built netcoredbg with Roslyn 4.11 (vs upstream's Roslyn
      -- 2.3.0-beta4 from 2017). Source at ~/code/netcoredbg, built per
      -- docs/build.md. Skipped when dotnet-debug.nvim owns coreclr.
      vim.api.nvim_create_autocmd("User", {
        pattern = "LazyLoad",
        callback = function(args)
          if args.data ~= "nvim-dap" then
            return
          end

          local dap = require("dap")
          dap.set_log_level("TRACE")

          -- Skip the netcoredbg coreclr adapter when dotnet-debug.nvim is
          -- installed — that plugin owns coreclr (vsdbg-ui). See the
          -- dotnet-debug.nvim spec in ./omnisharp.lua. Remove that spec to
          -- switch back to the local netcoredbg build.
          local dotnet_debug_installed = vim.fn.isdirectory(vim.fn.stdpath("data") .. "/lazy/dotnet-debug.nvim") == 1
          if not dotnet_debug_installed then
            dap.adapters.coreclr = {
              type = "executable",
              command = vim.fn.expand("~/code/netcoredbg/build/src/netcoredbg"),
              args = { "--interpreter=vscode" },
            }
          end

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

          -- Open dap-ui as soon as a session initializes (launch or attach),
          -- including coreclr. The earlier coreclr-specific defer-until-stop
          -- workaround was for nvim-dap pipe-error crashes during netcoredbg
          -- startup; those are addressed by the session.lua patch in `build`
          -- above and we're on vsdbg-ui now anyway. LazyVim's dap extra
          -- already wires the matching close listeners on terminate/exit.
          dap.listeners.after.event_initialized["dapui_config"] = function()
            local dapui_ok, dapui = pcall(require, "dapui")
            if dapui_ok then
              pcall(dapui.open, {})
            end
          end

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
