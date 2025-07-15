return {
  {
    'folke/todo-comments.nvim',
    event = 'VeryLazy',
    opts = {},
    -- stylua: ignore
		keys = {
			{ "<leader>st", function() Snacks.picker.todo_comments() end, desc = "Todo" },
			{ "<leader>sT", function () Snacks.picker.todo_comments({ keywords = { "TODO", "FIX", "FIXME" } }) end, desc = "Todo/Fix/Fixme" },
		},
  },
}
-- todo
-- TODO:
