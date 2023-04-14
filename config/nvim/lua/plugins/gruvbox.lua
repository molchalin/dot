return {
  {
    "sainnhe/gruvbox-material",
    lazy = false,
    priority = 1000,
    config = function()
      vim.o.background = "dark"
      vim.o.termguicolors = true
      vim.cmd([[colorscheme gruvbox-material]])
    end,
  }
}
