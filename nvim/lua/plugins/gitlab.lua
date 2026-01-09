return {
  "harrisoncramer/gitlab.nvim",
  dependencies = {
    "MunifTanjim/nui.nvim",
    "nvim-lua/plenary.nvim",
    "sindrets/diffview.nvim",
    "nvim-tree/nvim-web-devicons",
  },
  build = function()
    require("gitlab.server").build(true)
  end,
  event = "VeryLazy",
  keys = {
    { "<leader>glr", function() require("gitlab").review() end, desc = "GitLab: Review MR" },
    { "<leader>glm", function() require("gitlab").choose_merge_request() end, desc = "GitLab: Choose MR" },
    { "<leader>gla", function() require("gitlab").approve() end, desc = "GitLab: Approve MR" },
    { "<leader>glA", function() require("gitlab").revoke() end, desc = "GitLab: Revoke Approval" },
    { "<leader>glc", function() require("gitlab").create_comment() end, desc = "GitLab: Create Comment" },
    { "<leader>gln", function() require("gitlab").create_note() end, desc = "GitLab: Create Note" },
    { "<leader>gld", function() require("gitlab").toggle_discussions() end, desc = "GitLab: Toggle Discussions" },
    { "<leader>glp", function() require("gitlab").pipeline() end, desc = "GitLab: View Pipeline" },
    { "<leader>glM", function() require("gitlab").merge() end, desc = "GitLab: Merge MR" },
    { "<leader>glo", function() require("gitlab").open_in_browser() end, desc = "GitLab: Open in Browser" },
    { "<leader>glS", function() require("gitlab").summary() end, desc = "GitLab: MR Summary" },
  },
  config = function()
    require("gitlab").setup()
  end,
}
