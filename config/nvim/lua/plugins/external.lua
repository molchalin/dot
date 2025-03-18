return{
  {
    "MeanderingProgrammer/render-markdown.nvim",
    event = "VeryLazy",
    ft = "markdown",
    opts = {
      completions = {
        lsp = {
          enabled = true
        },
      },
      anti_conceal = {
        enabled = true,
        above = 3,
        below = 3,
      },
    },
  },
  {
    "tpope/vim-fugitive",
    event = "VeryLazy",
  },
}

