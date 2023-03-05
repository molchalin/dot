return {
  "edkolev/tmuxline.vim",
  dependencies = {
    "vim-airline/vim-airline",
    config = function()
      vim.g.airline_theme = "base16_gruvbox_dark_pale"
    end,
    dependencies = {
      "vim-airline/vim-airline-themes",
    },
  },
}
