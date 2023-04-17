return {
  "edkolev/tmuxline.vim",

  event = "VeryLazy",
  dependencies = {
    "vim-airline/vim-airline",
    config = function()
      vim.g.airline_theme = 'gruvbox_material'
    end,
    dependencies = {
      "vim-airline/vim-airline-themes",
      "tpope/vim-fugitive",
      "lewis6991/gitsigns.nvim",
      "sainnhe/gruvbox-material",
    },
  },
}
