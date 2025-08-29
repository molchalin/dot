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
    'nvim-mini/mini.splitjoin',
    version = false,
    opts = {},
  },
  {
    'nvim-mini/mini.jump',
    version = false,
    opts = {
      delay = {
        highlight = 10000000,
        idle_stop = 10000,
      },
    },
  },
  {
    'nvim-mini/mini.jump2d',
    version = false,
    opts = {
      mappings = {
        start_jumping = '<leader>f',
      },
    },
  },
  {
    'tpope/vim-speeddating',
    event = "VeryLazy",
  },
}
