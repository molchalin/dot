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
    'echasnovski/mini.splitjoin',
    version = false,
    opts = {},
  },
  {
    'echasnovski/mini.jump',
    version = false,
    opts = {
      delay = {
        idle_stop = 10000,
      },
    },
  },
  {
    'echasnovski/mini.jump2d',
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
