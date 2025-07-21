function _G.inspect_floats()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local cfg = vim.api.nvim_win_get_config(win)
    if cfg.relative ~= '' then
      local buf = vim.api.nvim_win_get_buf(win)
      print('FLOAT WINDOW:', win)
      print('Filetype:', vim.bo[buf].filetype)
      print('Buf name:', vim.api.nvim_buf_get_name(buf))
      print('Top line:', vim.api.nvim_buf_get_lines(buf, 0, 1, false)[1])
      print('Config:', vim.inspect(cfg))
    end
  end
end
vim.api.nvim_create_user_command('ListFloats', inspect_floats, {})
