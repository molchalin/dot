vim.opt.number         = true
vim.opt.relativenumber = true

vim.opt.mouse = ""

vim.opt.tabstop     = 4
vim.opt.shiftwidth  = 4
vim.opt.softtabstop = 4
vim.opt.expandtab   = true
vim.opt.smartindent = true

-- search related
vim.opt.showmatch  = true
vim.opt.hlsearch   = true
vim.opt.ignorecase = true
vim.opt.smartcase  = true

-- how to show not displayable characters
vim.opt.list      = true
vim.opt.listchars = { tab = "│·", trail = "·", nbsp = "␣" }

vim.opt.scrolloff     = 8 -- ensures that you have at least 8 lines above and below your cursor
vim.opt.sidescrolloff = 8 -- same for left/right

vim.opt.clipboard = "unnamedplus"

vim.opt.textwidth = 120

-- disable sound
vim.opt.errorbells = false

-- ask for confirmation before quit
vim.opt.confirm = true

--omnifunc
vim.opt.completeopt = "menu,menuone,noselect"

vim.opt.updatetime = 750

-- highlight char when line size exceed 120
vim.cmd([[
highlight ColorColumn ctermbg=LightYellow
call matchadd('ColorColumn', '\%121v', 120)
]])
