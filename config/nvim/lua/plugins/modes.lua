return {
  {
    "mvllow/modes.nvim",
    event = "BufEnter",
    config = function()
      require('modes').setup({
        line_opacity = 0.1,
      })
    end
  },
}
