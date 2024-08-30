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
vim.opt.listchars = { tab = "| ", nbsp = "␣"}
vim.opt.showbreak = "↳ "

vim.opt.scrolloff     = 8 -- ensures that you have at least 8 lines above and below your cursor
vim.opt.sidescrolloff = 8 -- same for left/right

vim.opt.clipboard = "unnamedplus"

-- disable sound
vim.opt.errorbells = false

-- ask for confirmation before quit
vim.opt.confirm = true

-- omnifunc
vim.opt.completeopt = "menu,menuone,noselect"

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
  group = vim.api.nvim_create_augroup("FixCommentString", { clear = true }),
  callback = function(ev)
    vim.bo[ev.buf].commentstring = "// %s"
  end,
  pattern = { "proto", "cpp", "c", "java" },
})

vim.api.nvim_create_autocmd("BufWinEnter", {
  group = vim.api.nvim_create_augroup("CustomHighlight", { clear = true }),
  callback = function(ev)
    -- highlight 2+ empty lines
    if vim.w.empty_lines_id == nil then
      vim.w.empty_lines_id = vim.fn.matchadd("EmptyLines", "\\n\\n\\zs\\n\\+\\ze")
    end

    local textwidth = 120
    if string.find(vim.fn.hostname(), "quobyte") then
      if vim.bo[ev.buf].filetype == 'java' then
        textwidth = 100
      else
        textwidth = 80
      end
    end

    -- smart color column highlight
    if vim.w.color_column_id ~= nil then
      vim.fn.matchdelete(vim.w.color_column_id)
    end
    vim.w.color_column_id = vim.fn.matchadd("ColorColumn", "\\%" .. textwidth + 1 .. "v.")
    vim.bo[ev.buf].textwidth = textwidth
  end,
})

vim.cmd([[
  highlight EmptyLines guibg=Red
  highlight ColorColumn guibg=DarkMagenta
]])

vim.diagnostic.config({
  virtual_text = {
    severity = {
      vim.diagnostic.severity.ERROR,
    },
  },
  underline = {
    severity = {
      vim.diagnostic.severity.ERROR,
    },
  },
  severity_sort = true,
})
