-- Auto-attach to the Azure Functions .NET isolated worker, driven from a
-- project's .vscode/launch.json + .vscode/tasks.json rather than from here.
--
-- The build and `func host start` come from the launch.json `preLaunchTask`:
-- overseer runs it (see the `overseer.patch_dap` call in ./dap.lua) and blocks
-- the launch until the task's background problemMatcher hits its endsPattern.
-- nvim-dap reads launch.json on demand, so nothing needs registering.
--
-- Only picking the worker process is left. nvim-dap can't resolve VS Code's
-- `${command:azureFunctions.pickProcess}` (its placeholder table is a local),
-- and the built-in `${command:pickProcess}` is an unfiltered manual picker. So
-- an attach config sets `processName` to the worker's dll and this resolves it
-- to a pid:
--
--   {
--     "name": "Attach to LeadDocket.Core.Functions",
--     "type": "coreclr",
--     "request": "attach",
--     "preLaunchTask": "func: host start (debug)",
--     "processName": "${workspaceFolder}/Source/LeadDocket.Core.Functions/bin/Debug/net10.0/LeadDocket.Core.Functions.dll"
--   }
--
-- Use the full dll path, not the bare filename: worktrees of the same repo run
-- identically-named assemblies, and pgrep would otherwise attach to whichever
-- one has the lowest pid.
--
-- The pid lookup hangs off the adapter's `enrich_config`, which nvim-dap calls
-- from `maybe_enrich_config_and_run` *after* `prepare_config` has run every
-- `dap.listeners.on_config` handler. Resolving in an on_config handler instead
-- does not work: nvim-dap dispatches those with `pairs()`, so ours can land
-- before overseer's preLaunchTask handler, and since they share one coroutine,
-- waiting for a process the not-yet-started task is supposed to spawn
-- deadlocks until the timeout. enrich_config has no such ordering problem, and
-- is callback-based, so the poll needs no coroutine of its own.

local TIMEOUT_MS = 60000
local INTERVAL_MS = 250

--- pgrep takes an ERE, so escape the dots and dashes in a dll path.
local function worker_pattern(dll)
  return "dotnet.*" .. dll:gsub("[%.%+%-%*%?%[%]%^%$%(%)%{%}|\\]", "\\%0")
end

--- Wait for the isolated worker hosting `dll`, then hand its pid to `cb`.
local function await_pid(dll, cb)
  local pattern = worker_pattern(dll)
  local waited = 0

  local function poll()
    local pids = vim.fn.systemlist({ "pgrep", "-f", pattern })
    local pid = vim.v.shell_error == 0 and tonumber(pids[1]) or nil
    if pid then
      vim.notify("Attaching to process " .. pid, vim.log.levels.INFO)
      return cb(pid)
    end

    if waited >= TIMEOUT_MS then
      return vim.notify("No process matching /" .. pattern .. "/", vim.log.levels.ERROR)
    end

    waited = waited + INTERVAL_MS
    vim.defer_fn(poll, INTERVAL_MS)
  end

  poll()
end

-- Worker dll of the live session, so ending it can take the host down with it.
local attached_dll = nil
-- Output subscription to drop when the session ends.
local piped_task, pipe_output = nil, nil

--- The running func host task for `dir`, if there is one. Keying on the
--- directory the worker dll was loaded from keeps this out of a sibling
--- worktree's host.
local function find_host_task(dir)
  local ok, overseer = pcall(require, "overseer")
  if not ok then
    return nil
  end
  local function is_our_host(task)
    return task:is_running() and task.cwd == dir and vim.startswith(task.name, "func: ")
  end
  return overseer.list_tasks({ filter = is_our_host })[1]
end

--- Mirror the func host's output into the dap-ui bottom panel.
local function pipe_host_output(dir)
  local task = find_host_task(dir)
  if not task then
    return
  end

  -- The repl element, not the console one: dapui's console only mirrors
  -- nvim-dap's integrated terminal, and an attach session never creates one.
  local clean = require("overseer.util").clean_job_line
  pipe_output = function(_, lines)
    for _, line in ipairs(lines) do
      if line ~= "" then
        require("dap").repl.append(clean(line))
      end
    end
    -- Task:dispatch unsubscribes on a truthy return, so return nothing.
  end

  task:subscribe("on_output_lines", pipe_output)
  piped_task = task
end

--- Stop the func host started for the session that just ended.
local function stop_host()
  local dll = attached_dll
  if not dll then
    return
  end
  attached_dll = nil

  if piped_task and pipe_output then
    piped_task:unsubscribe("on_output_lines", pipe_output)
  end
  piped_task, pipe_output = nil, nil

  local dir = vim.fs.dirname(dll)
  local task = find_host_task(dir)
  if task then
    task:stop()
  end

  -- func orphans the isolated worker when it goes down rather than shutting
  -- it down, and an orphan keeps holding 7071. Give the task a moment to stop
  -- on its own, then take out whatever is left of this project's worker.
  vim.defer_fn(function()
    vim.fn.jobstart({ "pkill", "-f", worker_pattern(dll) })
  end, 2000)
end

--- Wrap the adapter for `config` so `processName` becomes `processId`.
local function ensure_enriched(config)
  local adapter = require("dap").adapters[config.type]
  if type(adapter) ~= "table" or adapter.resolves_process_name then
    return
  end
  adapter.resolves_process_name = true

  local base = adapter.enrich_config
  adapter.enrich_config = function(cfg, on_config)
    local function resolve(c)
      local dll = c.processName
      if not dll then
        return on_config(c)
      end
      c.processName = nil
      await_pid(dll, function(pid)
        c.processId = pid
        attached_dll = dll
        pipe_host_output(vim.fs.dirname(dll))
        on_config(c)
      end)
    end

    if base then
      base(cfg, resolve)
    else
      resolve(cfg)
    end
  end
end

local function install()
  local dap = require("dap")

  -- Only needs to beat enrich_config, so the `pairs()` dispatch order that
  -- rules out resolving here is harmless for installing the wrapper.
  dap.listeners.on_config.azure_functions = function(config)
    if config.processName then
      ensure_enriched(config)
    end
    return config
  end

  -- Ending the session leaves the host running otherwise. Both hooks are
  -- needed: `disconnect` covers detaching from the worker (what <leader>dt
  -- does on an attach session), `event_terminated` covers the adapter ending
  -- it first. stop_host() clears its own state, so whichever lands second is
  -- a no-op. Keyed away from `overseer`, which owns postDebugTask here.
  dap.listeners.after.disconnect.azure_functions = stop_host
  dap.listeners.after.event_terminated.azure_functions = stop_host

  -- overseer gives every `isBackground` VS Code task an on_complete_restart
  -- component, so a func host that dies on startup (a stale host still holding
  -- 7071, most often) rebuilds and relaunches in a loop until the task is
  -- disposed. VS Code does not restart these either.
  local ok, overseer = pcall(require, "overseer")
  if ok then
    overseer.add_template_hook({ name = "^func: " }, function(task_defn, util)
      util.remove_component(task_defn, "on_complete_restart")
    end)
  end
end

-- Hooked via `opts` rather than a `User LazyLoad` autocmd: LazyVim's overseer
-- extra pulls nvim-dap in during startup (its own nvim-dap fragment calls
-- `overseer.enable_dap()`), so an autocmd registered while this spec file is
-- being evaluated can miss the event entirely. lazy.nvim resolves `opts`
-- when the plugin is configured and merges fragments, so this runs exactly
-- once, after dap is loaded, without clobbering ./dap.lua's own fragment.
return {
  {
    "mfussenegger/nvim-dap",
    opts = install,
  },
}
