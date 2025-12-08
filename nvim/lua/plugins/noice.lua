return {
  {
    "folke/noice.nvim",
    opts = {
      presets = {
        lsp_doc_border = true,
      },
      routes = {
        {
          filter = {
            event = "notify",
            kind = "error",
            find = "TextDocument was found instead",
          },
          opts = { skip = true },
        },
        {
          filter = {
            event = "notify",
            kind = "error",
            find = "Attempted to retrieve a Document",
          },
          opts = { skip = true },
        },
      },
    },
    init = function()
      local original_handler = vim.lsp.handlers["$/progress"]
      
      vim.lsp.handlers["$/progress"] = function(err, result, ctx, cfg)
        if not result then
          return
        end
        
        local params = result.params or result
        
        if not params or not params.token or params.token == nil or params.token == "" then
          return
        end
        
        if type(original_handler) == "function" then
          return original_handler(err, result, ctx, cfg)
        end
      end
    end,
  },
}
