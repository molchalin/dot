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

custom_highlight_augroup = vim.api.nvim_create_augroup("CustomHighlight", { clear = true })

vim.api.nvim_create_autocmd({"BufEnter", "WinEnter", "InsertLeave"}, {
  group = custom_highlight_augroup,
  callback = function(ev)
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

vim.api.nvim_create_autocmd({"BufLeave", "WinLeave", "InsertEnter"}, {
  group = custom_highlight_augroup,
  callback = function(ev)
    local delete_if_not_empty = function(id_name)
      if vim.w[id_name] ~= nil then
        vim.fn.matchdelete(vim.w[id_name])
        vim.w[id_name] = nil
      end
    end

    delete_if_not_empty("empty_lines_id")
    delete_if_not_empty("trailing_space_id")
    delete_if_not_empty("color_column_id")
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
