return {
  "edkolev/tmuxline.vim",
  dependencies = {
    "vim-airline/vim-airline",
    config = function()
      vim.g.airline_theme = 'gruvbox_material'
    end,
    dependencies = {
      "vim-airline/vim-airline-themes",
    },
  },
}
