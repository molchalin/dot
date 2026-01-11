require("config.mappings")
require("config.lazy")
require("config.options")

vim.opt.runtimepath:append('~/.local/nvim')
local config_file = vim.fn.expand('~/.local/nvim/init.lua')
if vim.fn.filereadable(config_file) == 1 then
    dofile(config_file)
end
