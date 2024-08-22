vim.opt.number         = true
vim.opt.relativenumber = true

vim.opt.mouse = ""

-- search related
vim.opt.showmatch  = true
vim.opt.hlsearch   = true
vim.opt.ignorecase = true
vim.opt.smartcase  = true


vim.opt.background = "dark"
vim.opt.termguicolors = true

-- how to show not displayable characters
vim.opt.list      = true
vim.opt.listchars = { tab = "│·", nbsp = "␣" }

vim.opt.scrolloff     = 8 -- ensures that you have at least 8 lines above and below your cursor
vim.opt.sidescrolloff = 8 -- same for left/right

vim.opt.clipboard = "unnamedplus"

-- disable sound
vim.opt.errorbells = false

-- ask for confirmation before quit
vim.opt.confirm = true

-- omnifunc
vim.opt.completeopt = "menu,menuone,noselect"

-- smart color column highlight
if string.find(vim.fn.hostname(), "quobyte") then
  vim.opt.textwidth = 100
  vim.cmd([[ call matchadd('ColorColumn', '\%101v.') ]])
else
  vim.opt.textwidth = 120
  vim.cmd([[ call matchadd('ColorColumn', '\%121v.') ]])
end
vim.cmd([[ highlight ColorColumn guibg=DarkMagenta ]])

-- vim supports checking spelling only in comments when syntax is on.
-- so it's safe to enable it everywhere.
vim.opt.spell = true
vim.opt.spelllang:append { "ru", "de" }


vim.filetype.add({
  filename ={
    ["Jenkinsfile"] = "groovy",
  }
})

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("FixProtoCommentString", { clear = true }),
  callback = function(ev)
    vim.bo[ev.buf].commentstring = "// %s"
  end,
  pattern = { "proto" },
})

