return{
  {
    "MeanderingProgrammer/render-markdown.nvim",
    event = "VeryLazy",
    ft = "markdown",
    keys = {
      { "<leader>m", ":RenderMarkdown toggle<CR>" , remap = false },
    },
    opts = {
      enabled = false,
      completions = {
        lsp = {
          enabled = true,
        },
      },
    },
  },
  {
    "tpope/vim-fugitive",
    event = "VeryLazy",
  },
}

