return {
  "iamcco/markdown-preview.nvim",
  event = "VeryLazy",
  ft = "markdown",
  build = function ()
    vim.fn["mkdp#util#install"]()
  end,
}
