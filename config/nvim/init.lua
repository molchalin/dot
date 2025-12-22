require("config.mappings")
require("config.lazy")
require("config.options")

vim.opt.runtimepath:append('~/.local/nvim')
dofile(vim.fn.expand('~/.local/nvim/init.lua'))
