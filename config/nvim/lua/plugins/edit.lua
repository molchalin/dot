return {
  { "tpope/vim-sensible" },
  {
    "tpope/vim-sleuth",
    event = "VeryLazy",
  },
  {
    "tpope/vim-surround",
    event = "VeryLazy",
  },
  {
    event = "VeryLazy",
    "chaoren/vim-wordmotion",
  },
  {
    "easymotion/vim-easymotion",
    event = "VeryLazy",
    config = function()
      vim.keymap.set("n", "<leader>",  "<Plug>(easymotion-prefix)")
    end,
  },
  {
    'stevearc/oil.nvim',
    opts = {},
  },
  {
    'echasnovski/mini.splitjoin',
    version = false,
    opts = {},
  },
  {
    'tpope/vim-speeddating',
    event = "VeryLazy",
  },
}
