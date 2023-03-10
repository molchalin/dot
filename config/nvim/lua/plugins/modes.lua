return {
  {
    "mvllow/modes.nvim",
    event = "ModeChanged",
    config = function()
      require('modes').setup({
        line_opacity = 0.1,
      })
    end
  },
}
