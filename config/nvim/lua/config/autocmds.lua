vim.api.nvim_create_autocmd("FileType", {
  pattern = {"css,lua,vue,groovy"},
  callback = function()
    vim.opt_local.shiftwidth = 2
    vim.opt_local.tabstop = 2
  end
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = {"markdown,gitcommit"},
  callback = function()
    vim.opt_local.spell = true
    vim.opt_local.complete:append { "kspell" }
    vim.opt_local.spelllang:append { "ru", "de" }
  end
})
