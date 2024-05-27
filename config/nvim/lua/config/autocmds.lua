vim.api.nvim_create_autocmd("FileType", {
  pattern = {"css,lua,vue,groovy"},
  callback = function()
    vim.opt_local.shiftwidth = 2
    vim.opt_local.tabstop = 2
  end
})
