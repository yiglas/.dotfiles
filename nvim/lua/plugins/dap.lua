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

      -- nvim-dap reads .vscode/launch.json on demand (see :help dap-providers).
      -- We override the coreclr adapter to a locally-built netcoredbg with
      -- Roslyn 4.11 (vs upstream's Roslyn 2.3.0-beta4 from 2017). Source at
      -- ~/code/netcoredbg, built per docs/build.md. If the local build is
      -- missing, falls back to the Cliffback arm64 plugin's bundled binary.
      vim.api.nvim_create_autocmd("User", {
        pattern = "LazyLoad",
        callback = function(args)
          if args.data ~= "nvim-dap" then
            return
          end

          local dap = require("dap")
          dap.set_log_level("TRACE")

          local local_build = vim.fn.expand("~/code/netcoredbg/build/src/netcoredbg")
          local plugin_build = vim.fn.stdpath("data") .. "/lazy/netcoredbg-macOS-arm64.nvim/netcoredbg/netcoredbg"
          local netcoredbg = vim.fn.filereadable(local_build) == 1 and local_build or plugin_build
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

          -- LazyVim's dap extra auto-opens dap-ui on event_initialized. On
          -- nvim 0.12, that timing is flaky during heavy DAP startup. For
          -- coreclr we defer the open until the first event_stopped, when
          -- the session is in a stable state. Non-coreclr sessions keep
          -- the original eager-open behavior.
          local coreclr_dapui_opened = false
          dap.listeners.after.event_initialized["dapui_config"] = function(session)
            if session and session.config and session.config.type == "coreclr" then
              coreclr_dapui_opened = false
              return
            end
            local dapui_ok, dapui = pcall(require, "dapui")
            if dapui_ok then
              pcall(dapui.open, {})
            end
          end
          dap.listeners.after.event_stopped["dapui_config_coreclr"] = function(session)
            if session and session.config and session.config.type == "coreclr" and not coreclr_dapui_opened then
              local dapui_ok, dapui = pcall(require, "dapui")
              if dapui_ok then
                pcall(dapui.open, {})
              end
              coreclr_dapui_opened = true
            end
          end
          local function safe_dapui_close(session)
            local dapui_ok, dapui = pcall(require, "dapui")
            if dapui_ok then
              pcall(dapui.close, {})
            end
            if session and session.config and session.config.type == "coreclr" then
              coreclr_dapui_opened = false
            end
          end
          dap.listeners.before.event_terminated["dapui_config"] = safe_dapui_close
          dap.listeners.before.event_exited["dapui_config"] = safe_dapui_close

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
