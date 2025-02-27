return {
  "b0o/incline.nvim",
  dependencies = {},
  event = "BufReadPre",
  priority = 1200,
  config = function()
    local helpers = require("incline.helpers")
    require("incline").setup({
      window = {
        padding = 0,
        margin = { horizontal = 0 },
      },
      render = function(props)
        local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
        local ft_icon, ft_color = require("nvim-web-devicons").get_icon_color(filename)
        local modified = vim.bo[props.buf].modified
        local m = vim.api.nvim_get_mode().mode

        local mode = ""
        if m ~= "n" then
          mode = " " .. m
        end

        local modified_icon = {}
        if modified then
          modified_icon = vim.tbl_extend("force", { " ● " }, { guifg = "#d6991d" })
        end

        local buffer = {
          ft_icon and { " ", ft_icon, "  ", guibg = ft_color, guifg = helpers.contrast_color(ft_color) } or "",
          " ",
          { filename, gui = modified and "bold,italic" or "bold" },
          modified_icon,
          mode,
          " ",
          guibg = "#363944",
        }
        return buffer
      end,
    })
  end,
}
