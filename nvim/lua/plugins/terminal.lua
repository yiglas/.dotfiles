-- Store terminal instances
local terminals = {}

-- Toggle specific terminal with optional opencode auto-execution
local function toggle_terminal(id, auto_opencode)
  local Terminal = require("toggleterm.terminal").Terminal

  -- Create terminal instance if it doesn't exist
  if not terminals[id] then
    terminals[id] = Terminal:new({
      id = id,
      direction = "float",
      start_in_insert = true,
      on_open = function(term)
        -- Auto-execute opencode for terminal 2
        if id == 2 then
          vim.defer_fn(function()
            if term.job_id then
              -- Send the command followed by carriage return to execute
              vim.api.nvim_chan_send(term.job_id, "opencode\r")
            end
          end, 200)
        end
      end,
    })
  end

  -- Toggle the terminal
  terminals[id]:toggle()
end

return {
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    cmd = { "ToggleTerm" },
    keys = {
      -- Keep existing default toggle
      { "<C-/>", "<cmd>ToggleTerm<cr>", mode = { "n", "v", "x", "i", "t" }, desc = "Toggle Terminal" },
      -- { "<C-_>", "<cmd>ToggleTerm<cr>", mode = { "n", "t", "i" }, desc = "Toggle Terminal" },

      -- New specific terminal toggles
      {
        "<C-t>1",
        function()
          toggle_terminal(1)
        end,
        mode = { "n", "v", "i" },
        desc = "Toggle Terminal 1",
      },
      {
        "<C-t>2",
        function()
          toggle_terminal(2, true)
        end,
        mode = { "n", "v", "i" },
        desc = "Toggle Terminal 2 (OpenCode)",
      },
    },
    opts = function(_, opts)
      if vim.fn.has("win32") == 1 then
        opts.shell = "nu"
      end

      opts.direction = "float"
      opts.start_in_insert = true

      return opts
    end,
    config = function(_, opts)
      require("toggleterm").setup(opts)
    end,
  },
}
