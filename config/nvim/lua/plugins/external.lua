return{
  {
    "iamcco/markdown-preview.nvim",
    ft = "markdown",
    keys = {
      { "<leader>m", ":MarkdownPreviewToggle<CR>" , remap = false },
    },
    build = ":call mkdp#util#install()",
  },
  {
    "tpope/vim-fugitive",
    event = "VeryLazy",
  },
}

