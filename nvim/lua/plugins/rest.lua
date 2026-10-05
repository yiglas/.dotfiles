return {
  { import = "lazyvim.plugins.extras.util.rest" },
  -- Pinned before 7e740be (license-server integration): newer versions prompt
  -- for a license token via inputsecret() on VimLeavePre, hanging :qa.
  { "mistweaverco/kulala.nvim", commit = "0bd9fa3" },
}
