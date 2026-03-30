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
    "chrisgrieser/nvim-spider",
    keys = {
      { "w", "<cmd>lua require('spider').motion('w')<CR>", mode = { "n", "o", "x" } },
      { "e", "<cmd>lua require('spider').motion('e')<CR>", mode = { "n", "o", "x" } },
      { "b", "<cmd>lua require('spider').motion('b')<CR>", mode = { "n", "o", "x" } },
      { "ge", "<cmd>lua require('spider').motion('ge')<CR>", mode = { "n", "o", "x" } },
    },
    opts = {
      skipInsignificantPunctuation = false,
    },
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
    keys = {
      { "<leader>f", function() MiniJump2d.start(MiniJump2d.builtin_opts.single_character) end, remap = false },
    },
    opts = {
      mappings = {
        start_jumping = '',
      },
    },
  },
  {
    'tpope/vim-speeddating',
    event = "VeryLazy",
  },
  { 'LunarVim/bigfile.nvim' },
}
