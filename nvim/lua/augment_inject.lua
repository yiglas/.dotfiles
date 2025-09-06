-- ~/.config/nvim/lua/augment_inject.lua
local M = {}

local function slurp(path)
  local ok, data = pcall(vim.fn.readfile, path)
  if not ok or not data or #data == 0 then
    return nil
  end
  return table.concat(data, "\n")
end

local function find_guidelines()
  -- search upward from current file for a repo-local guideline file
  local cwd_file = vim.api.nvim_buf_get_name(0)
  local start = cwd_file ~= "" and vim.fs.dirname(cwd_file) or vim.loop.cwd()
  local targets = { ".augment.md", "docs/augment-instructions.md" }
  local found = vim.fs.find(targets, { upward = true, path = start })[1]
  if found then
    return found
  end
  -- fallback to a personal/global file
  local home = vim.loop.os_homedir()
  local fallback = home .. "/.config/nvim/augment/instructions.md"
  if vim.uv.fs_stat(fallback) then
    return fallback
  end
  return nil
end

local function get_visual_text()
  -- returns selected text if we're in visual mode, else nil
  local mode = vim.fn.mode()
  if not (mode == "v" or mode == "V" or mode == "\22") then
    return nil
  end
  -- save & restore registers
  local save_reg = vim.fn.getreg('"')
  local save_t = vim.fn.getregtype('"')
  vim.cmd('normal! ""y')
  local text = vim.fn.getreg('"')
  vim.fn.setreg('"', save_reg, save_t)
  return text ~= "" and text or nil
end

function M.run(opts)
  opts = opts or {}
  local guideline_path = find_guidelines()
  local guidelines = guideline_path and slurp(guideline_path) or nil

  if not guidelines then
    vim.notify(
      "augment_inject: no instruction file found (.augment.md or docs/augment-instructions.md or ~/.config/nvim/augment/instructions.md)",
      vim.log.levels.WARN
    )
  end

  local selection = get_visual_text()
  local task = opts.task or vim.fn.input({ prompt = "Augment task: " })
  if task == nil or task == "" then
    vim.notify("augment_inject: cancelled (empty task).", vim.log.levels.INFO)
    return
  end

  -- Build the payload
  local chunks = {}
  if guidelines then
    table.insert(chunks, "# Project Guidelines\n" .. guidelines)
  end
  if selection then
    table.insert(chunks, "# Relevant Selection\n" .. selection)
  end
  table.insert(chunks, "# Task\n" .. task)
  local payload = table.concat(chunks, "\n\n")

  -- ▶️ Call your Augment entrypoint here.
  -- If your plugin uses a different command, change this:
  local cmd = "Augment chat " .. vim.fn.shellescape(payload)
  vim.cmd(cmd)
end

-- user commands
vim.api.nvim_create_user_command("AugmentWithGuidelines", function()
  require("augment_inject").run({})
end, { desc = "Augment: inject .augment.md and optional visual selection" })

-- convenience mappings:
-- normal mode: prompt for task
vim.keymap.set("n", "<leader>ag", function()
  require("augment_inject").run({})
end, { desc = "Augment with guidelines" })
-- visual mode: include selection as extra context
vim.keymap.set("v", "<leader>ag", function()
  require("augment_inject").run({})
end, { desc = "Augment with guidelines (visual)" })

return M
