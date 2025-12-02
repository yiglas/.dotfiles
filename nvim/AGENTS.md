# Agent Guidelines for LazyVim Configuration

## Build/Test/Lint Commands

- No build/test/lint commands - this is a Neovim configuration
- Format Lua files: `stylua .` (uses stylua.toml config)
- Check syntax: Open nvim and observe for errors

## Code Style

**Formatting:**

- Use 2 spaces for indentation (never tabs)
- Max line width: 120 characters
- Format with StyLua before committing

**Plugin Structure:**

- Plugin files in `lua/plugins/*.lua` return a table/array of plugin specs
- Use lazy-loading: `event`, `cmd`, `keys`, `ft` for performance
- Example: `{ "plugin/name", event = "VeryLazy", opts = {} }`

**Lua Conventions:**

- Use `local` for all variables/functions unless global needed
- Prefer `vim.keymap.set()` over `vim.api.nvim_set_keymap()`
- Use `pcall()` for optional requires: `local ok, module = pcall(require, "module")`
- Comments: `--` for single line, avoid block comments

**Naming:**

- Snake_case for local variables/functions: `local my_function`
- Descriptive names: `toggle_terminal(id)` not `toggle(i)`
