return {
  {
    "esensar/nvim-dev-container",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    opts = {
      container_runtime = "docker",
      attach_mounts = {
        neovim_config = { enabled = true, options = { "readonly" } },
        neovim_data = { enabled = false },
        neovim_state = { enabled = false },
      },
    },
    cmd = {
      "DevcontainerStart",
      "DevcontainerAttach",
      "DevcontainerStop",
      "DevcontainerStopAll",
      "DevcontainerRemoveAll",
      "DevcontainerExec",
      "DevcontainerLogs",
      "DevcontainerEditNearestConfig",
    },
    keys = {
      { "<leader>Cs", "<cmd>DevcontainerStart<cr>", desc = "Start devcontainer" },
      { "<leader>Ca", "<cmd>DevcontainerAttach<cr>", desc = "Attach to devcontainer" },
      { "<leader>Cx", "<cmd>DevcontainerStop<cr>", desc = "Stop devcontainer" },
      { "<leader>Ce", "<cmd>DevcontainerExec<cr>", desc = "Exec in devcontainer" },
      { "<leader>Cl", "<cmd>DevcontainerLogs<cr>", desc = "Devcontainer logs" },
    },
  },
}
