if not vim.g.vscode then
  -- bootstrap lazy.nvim, LazyVim and your plugins
  require 'init'
else
  -- bootstrap vscode
  require 'vscode-init'
end
