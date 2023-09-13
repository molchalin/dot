return {
  "nvim-lualine/lualine.nvim",
  config = function()
    require("lualine").setup {
      options = {
        theme = 'gruvbox-material',
      },
      tabline = {
        lualine_a = {
          {
            'tabs',
            mode = 2,
            max_length = vim.o.columns,
          },
        },
      },
    }
  end,
}
