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

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true
vim.opt.smarttab = true

vim.opt.clipboard = "unnamedplus"

-- disable sound
vim.opt.errorbells = false

if vim.env.CUSTOM_SSH_SPEEDUP then
  vim.opt.lazyredraw = true
end

-- don't show syntax for big lines
vim.opt.synmaxcol=512

vim.opt.foldmethod = 'indent'
-- don't fold automatically
vim.opt.foldlevelstart = 99

-- ask for confirmation before quit
vim.opt.confirm = true

-- omnifunc
vim.opt.completeopt = "menu,menuone,noselect"

vim.opt.spelllang:append { "ru", "de" }

-- vim supports checking spelling only in comments when syntax is on.
-- so it's safe to enable it everywhere.
vim.api.nvim_create_autocmd({"BufWinEnter", "BufWinLeave"}, {
  group = vim.api.nvim_create_augroup("DisableSpellCheck", { clear = true }),
  callback = function(ev)
    vim.opt_local.spell = vim.bo[ev.buf].modifiable
  end,
})

vim.filetype.add({
  filename ={
    ["Jenkinsfile"] = "groovy",
  }
})

vim.api.nvim_create_autocmd({"BufEnter", "WinEnter", "WinNew", "VimResized"}, {
  group = vim.api.nvim_create_augroup("CenterCursor", { clear = true }),
  callback = function(ev)
    -- ensures that you have at least third of the screen above and below your cursor
    vim.opt.scrolloff     = math.floor(vim.api.nvim_win_get_height(0) / 3)
    -- same for left/right
    vim.opt.sidescrolloff = math.floor(vim.api.nvim_win_get_width(0) / 3)
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("FixCommentString", { clear = true }),
  callback = function(ev)
    vim.bo[ev.buf].commentstring = "// %s"
  end,
  pattern = { "proto", "cpp", "c", "java", "typst" },
})

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("SetDefaultTabstop", { clear = true }),
  callback = function(ev)
    vim.bo[ev.buf].tabstop = 2
    vim.bo[ev.buf].shiftwidth = 2
    vim.bo[ev.buf].softtabstop = 2
  end,
  pattern = { "java", "cpp", "c", "java", "typst", "lua", "sh" }
})

local matchdelete_if_not_empty = function(id_name)
  if vim.w[id_name] ~= nil then
    vim.fn.matchdelete(vim.w[id_name])
    vim.w[id_name] = nil
  end
end

local clear_all_matches = function()
  matchdelete_if_not_empty("empty_lines_id")
  matchdelete_if_not_empty("trailing_space_id")
  matchdelete_if_not_empty("color_column_id")
end

custom_highlight_augroup = vim.api.nvim_create_augroup("CustomHighlight", { clear = true })

vim.api.nvim_create_autocmd({"BufEnter", "WinEnter", "InsertLeave"}, {
  group = custom_highlight_augroup,
  callback = function(ev)
    if not vim.bo[ev.buf].modifiable then
      clear_all_matches()
      return
    end
    -- highlight 2+ empty lines
    if vim.w.empty_lines_id == nil then
      vim.w.empty_lines_id = vim.fn.matchadd("FormatProblem", [[\n\n\zs\n\+\ze]])
    end
    if vim.w.trailing_space_id == nil then
      vim.w.trailing_space_id = vim.fn.matchadd("FormatProblem", [[\s\+$]])
    end

    local textwidth = 120
    if string.find(vim.fn.hostname(), "quobyte") then
      if vim.bo[ev.buf].filetype == 'java' then
        textwidth = 100
      elseif vim.bo[ev.buf].filetype == 'gitcommit' then
        textwidth = 72
      else
        textwidth = 80
      end
    end

    -- smart color column highlight
    matchdelete_if_not_empty("color_column_id")
    vim.w.color_column_id = vim.fn.matchadd("ColorColumn", "\\%" .. textwidth + 1 .. "v.")
    vim.bo[ev.buf].textwidth = textwidth
  end,
})

vim.api.nvim_create_autocmd({"BufLeave", "WinLeave", "InsertEnter"}, {
  group = custom_highlight_augroup,
  callback = function(ev)
    clear_all_matches()
  end,
})

vim.cmd.highlight({ "FormatProblem", "guibg=#ea6962" }) -- gruvbox-material red
vim.cmd.highlight({ "ColorColumn",   "guibg=#945e80" }) -- gruvbox-material purple

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
