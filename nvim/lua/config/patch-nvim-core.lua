-- Patch nvim core to remove unsafe `assert(not err, err)` calls in
-- vim._watch's libuv callbacks. When FSEvents fires an error during heavy
-- file I/O (e.g., .NET runtime loading dozens of DLLs through netcoredbg),
-- the assert throws inside a libuv callback with no Lua frame to catch it
-- and aborts nvim — no crash report, no stderr, just back to the shell.
--
-- This runs at startup before lazy.nvim and any LSP attaches, so the
-- patched file is what gets loaded the first time vim._watch is required.
-- Idempotent: detects already-patched state and exits. Self-heals if
-- `brew upgrade neovim` overwrites the file.
--
-- Same pattern is applied to nvim-dap via a `build = function()` in
-- plugins/dap.lua.

local function patch_watch()
  -- Locate the file via the runtime path so this survives nvim version
  -- bumps. $VIMRUNTIME is set by nvim before init.lua runs.
  local runtime = vim.env.VIMRUNTIME
  if not runtime or runtime == "" then
    return
  end
  local path = runtime .. "/lua/vim/_watch.lua"
  if vim.fn.filereadable(path) ~= 1 then
    return
  end

  local fd = io.open(path, "rb")
  if not fd then
    return
  end
  local content = fd:read("*a")
  fd:close()

  if not content:find("assert%(not err, err%)", 1, false) then
    return
  end

  -- Match either common indentation. Replace both occurrences (watch and
  -- watchdirs).
  local patched = content:gsub("(%s*)assert%(not err, err%)", "%1if err then return end")
  if patched == content then
    return
  end

  local out = io.open(path, "wb")
  if not out then
    vim.schedule(function()
      vim.notify("patch-nvim-core: could not open " .. path .. " for write", vim.log.levels.WARN)
    end)
    return
  end
  out:write(patched)
  out:close()

  -- Invalidate any bytecode cache for vim/_watch.lua so the next require
  -- picks up the rewritten source.
  local cache_dir = vim.fn.stdpath("cache") .. "/luac"
  for _, f in ipairs(vim.fn.glob(cache_dir .. "/*_watch.luac", false, true)) do
    pcall(vim.fn.delete, f)
  end
end

pcall(patch_watch)
