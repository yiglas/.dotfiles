-- Resolve the newest ms-dotnettools.csharp extension's bundled vsdbg-ui.
-- The C# extension installs to
-- ~/.vscode/extensions/ms-dotnettools.csharp-<version>-darwin-arm64 and bumps
-- <version> on every update, so we glob all installed copies and pick the
-- highest version instead of pinning one that goes stale on each upgrade.
local function latest_vsdbg_ui()
  local pattern = vim.fn.expand("~/.vscode/extensions")
    .. "/ms-dotnettools.csharp-*/.debugger/arm64/vsdbg-ui"
  local matches = vim.fn.glob(pattern, true, true)
  if #matches == 0 then
    return nil
  end

  -- Parse the x.y.z version embedded in the path into a comparable list of
  -- numbers so 2.140.10 sorts above 2.140.9 (a plain string sort wouldn't).
  local function version_key(path)
    local parts = {}
    local v = path:match("ms%-dotnettools%.csharp%-([%d%.]+)")
    if v then
      for n in v:gmatch("%d+") do
        parts[#parts + 1] = tonumber(n)
      end
    end
    return parts
  end

  local function is_newer(a, b)
    local ka, kb = version_key(a), version_key(b)
    for i = 1, math.max(#ka, #kb) do
      local x, y = ka[i] or 0, kb[i] or 0
      if x ~= y then
        return x > y
      end
    end
    return false
  end

  local best = matches[1]
  for i = 2, #matches do
    if is_newer(matches[i], best) then
      best = matches[i]
    end
  end
  return best
end

return {
  -- kmiterror/dotnet-debug.nvim wires nvim-dap up to vsdbg-ui (VS Code's
  -- signed debugger) by handling the signature handshake via VS Code's
  -- bundled vsda.node. It overrides dap.adapters.coreclr after load.
  -- ./dap.lua detects this plugin's install directory and skips its own
  -- netcoredbg coreclr setup so this adapter wins unambiguously.
  --
  -- defaults.lazy = true in lua/config/lazy.lua means custom plugins won't
  -- load without a trigger. lazy = false forces eager loading so
  -- dotnet-debug's setup runs and the coreclr adapter actually gets
  -- pointed at vsdbg-ui.
  {
    "kmiterror/dotnet-debug.nvim",
    dependencies = { "mfussenegger/nvim-dap", "rcarriga/nvim-dap-ui" },
    lazy = false,
    opts = {
      signer_path = "/Applications/Visual Studio Code.app/Contents/Resources/app/node_modules.asar.unpacked/vsda/build/Release/vsda.node",
      debugger_path = latest_vsdbg_ui(),
    },
    config = function(_, opts)
      require("dotnet-debug").setup(opts)
    end,
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
      ensure_installed = { "csharpier", "roslyn" },
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
              -- Disabled: nvim's built-in watch.watch uses assert(not err, err) in
              -- a libuv callback with no pcall — crashes nvim when FSEvents fires
              -- an error during heavy .NET module loading.
              dynamicRegistration = false,
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
      },
    },
    config = function(_, opts)
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
