return{
  {
    "matze/wastebin.nvim",
    event = "VeryLazy",
    name = "wastebin",
    cond = function()
      return vim.env.WASTEBIN_URL ~= nil
    end,
    opts = {},
  },
  {
    "iamcco/markdown-preview.nvim",
    event = "VeryLazy",
    ft = "markdown",
    build = function ()
      vim.fn["mkdp#util#install"]()
    end,
  },
  {
    "tpope/vim-fugitive",
    event = "VeryLazy",
  },
}

