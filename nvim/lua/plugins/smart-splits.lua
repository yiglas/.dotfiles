local function lazymap(module, fn)
  return function()
    require(module)[fn]()
  end
end

return {
  "mrjones2014/smart-splits.nvim",
  lazy = false,
  keys = {
    { "<C-h>", lazymap("smart-splits", "move_cursor_left"), desc = "Move to left window" },
    { "<C-j>", lazymap("smart-splits", "move_cursor_down"), desc = "Move to downward window" },
    { "<C-k>", lazymap("smart-splits", "move_cursor_up"), desc = "Move to upward window" },
    { "<C-l>", lazymap("smart-splits", "move_cursor_right"), desc = "Move to right window" },
    { "<Left>", lazymap("smart-splits", "resize_left"), desc = "Resize window left" },
    { "<Down>", lazymap("smart-splits", "resize_down"), desc = "Resize window down" },
    { "<Up>", lazymap("smart-splits", "resize_up"), desc = "Resize window up" },
    { "<Right>", lazymap("smart-splits", "resize_right"), desc = "Resize window right" },
    { "<leader><leader>h", lazymap("smart-splits", "swap_buf_left"), desc = "Swap buffer left" },
    { "<leader><leader>j", lazymap("smart-splits", "swap_buf_up"), desc = "Swap buffer left" },
    { "<leader><leader>k", lazymap("smart-splits", "swap_buf_down"), desc = "Swap buffer left" },
    { "<leader><leader>l", lazymap("smart-splits", "swap_buf_right"), desc = "Swap buffer left" },
  },
}
