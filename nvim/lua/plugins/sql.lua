-- vim.api.nvim_create_autocmd("FileType", {
--   pattern = "sql",
--   callback = function()
--     vim.keymap.set("n", "<C-c><C-c>", "<cmd>DB<cr>", { buffer = true, silent = true })
--     vim.keymap.set("v", "<C-c><C-c>", "<cmd>'<,'>DB<cr>", { buffer = true, silent = true })
--   end,
-- })

local function is_line_blank(line)
  return vim.fn.getline(line):match("^%s*$") ~= nil
end

local function get_visual_selection_range()
  local mode = vim.fn.mode()
  if mode ~= "v" and mode ~= "V" and mode ~= "" then
    return nil
  end

  local start_pos = vim.fn.getpos("'<")
  local end_pos = vim.fn.getpos("'>")
  return start_pos[2], end_pos[2]
end

local function run_sql()
  local mode = vim.fn.mode()
  local start_line, end_line

  -- If in visual mode, use the selection
  local visual_start, visual_end = get_visual_selection_range()
  if visual_start and visual_end then
    start_line = visual_start
    end_line = visual_end
  else
    local current_line = vim.fn.line(".")

    if is_line_blank(current_line) then
      -- If current line is blank, run the whole file
      start_line = 1
      end_line = vim.fn.line("$")
    else
      -- Otherwise, run the current SQL paragraph
      start_line = vim.fn.search("^\\s*$", "bnW") + 1
      end_line = vim.fn.search("^\\s*$", "nW") - 1

      if start_line > end_line then
        start_line = current_line
        end_line = current_line
      end
    end
  end

  -- Yank the lines to register
  vim.cmd(string.format("%d,%dy", start_line, end_line))
  -- Execute using :DB
  vim.cmd("DB " .. vim.fn.getreg('"'))
end

return {
  { import = "lazyvim.plugins.extras.lang.sql" },
  {
    "tpope/vim-dadbod",
    keys = {
      {
        "<C-c><C-c>",
        function()
          run_sql()
        end,
        mode = "n",
        ft = "sql",
        desc = "Run SQL under cursor",
      },
      {
        "<C-c><C-c>",
        function()
          run_sql()
        end,
        mode = "v",
        ft = "sql",
        desc = "Run selected SQL",
      },
    },
  },
  {
    "Maxteabag/sqlit.nvim",
    opts = {},
    build = function()
      if vim.fn.executable("sqlit") == 0 then
        if vim.fn.executable("pipx") == 0 then
          vim.notify("Installing pipx...", vim.log.levels.INFO)
          vim.fn.system({ "brew", "install", "pipx" })
          if vim.v.shell_error ~= 0 then
            vim.notify("Failed to install pipx. Install manually: pip install --user pipx", vim.log.levels.ERROR)
            return
          end
          vim.fn.system({ "pipx", "ensurepath" })
        end
        vim.notify("Installing sqlit-tui...", vim.log.levels.INFO)
        vim.fn.system({ "pipx", "install", "sqlit-tui" })
        if vim.v.shell_error == 0 then
          vim.notify("sqlit-tui installed successfully", vim.log.levels.INFO)
        else
          vim.notify("Failed to install sqlit-tui. Install manually: pipx install sqlit-tui", vim.log.levels.ERROR)
        end
      end
    end,
    keys = {
      { "<leader>D", function() require("sqlit").open() end, desc = "Database (sqlit)" },
    },
  },
  -- {
  --   "kndndrj/nvim-dbee",
  --   dependencies = {
  --     "MunifTanjim/nui.nvim",
  --   },
  --   command = "Dbee",
  --   build = function()
  --     -- Install tries to automatically detect the install method.
  --     -- if it fails, try calling it with one of these parameters:
  --     --    "curl", "wget", "bitsadmin", "go"
  --     require("dbee").install("curl")
  --   end,
  --   config = function()
  --     print("connections ", vim.g.dbs)
  --     require("dbee").setup({
  --       sources = {
  --         require("dbee.sources").MemorySource:new(vim.g.dbs),
  --       },
  --     })
  --   end,
  -- },
}
