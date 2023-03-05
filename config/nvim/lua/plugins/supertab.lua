return {
  "ervandew/supertab",
  event = "VeryLazy",
  config = function()
    vim.g.SuperTabDefaultCompletionType = "context"
    vim.g.SuperTabContextTextOmniPrecedence = { "&omnifunc", "&completefunc" }
  end
}
