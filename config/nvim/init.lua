require("config.mappings")
require("config.lazy")
require("config.options")

local local_init = vim.fn.stdpath("config") .. "/local_init.lua"
pcall(dofile, local_init)

