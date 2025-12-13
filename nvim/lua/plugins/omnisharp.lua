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
      -- your configuration comes here; leave empty for default settings
    },
    config = function()
      -- Load mason settings to make $MASON available
      local _ = require("mason.settings").current.install_root_dir
      vim.lsp.config("roslyn", {})
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
