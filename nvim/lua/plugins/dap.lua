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
