return {
  "SirVer/ultisnips",
  event = "VeryLazy",
  config = function()
    vim.g.UltiSnipsExpandTrigger       ="<tab>"
    vim.g.UltiSnipsJumpForwardTrigger  ="<tab>"
    vim.g.UltiSnipsJumpBackwardTrigger ="<s-tab>"
  end
}
