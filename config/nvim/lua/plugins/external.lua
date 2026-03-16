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
  {
    "zk-org/zk-nvim",
    ft = "markdown",
    keys = {
      { "<Leader>zp", "<cmd>:ZkNotes<CR>", remap = false },
      { "<Leader>zl", "<cmd>:ZkInsertLink<CR>", mode = "n", remap = false },
    },
    config = function()
      require("zk").setup({
        picker = "snacks_picker",
      })
    end
  },
}

