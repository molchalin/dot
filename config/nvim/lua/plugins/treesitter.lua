vim.api.nvim_create_autocmd({ 'FileType' }, {
  callback = function(event)
    local ok, nvim_treesitter = pcall(require, 'nvim-treesitter')
    if not ok then return end

    local parsers = require('nvim-treesitter.parsers')
    if not parsers[event.match] or not nvim_treesitter.install then return end

    local ft = vim.bo[event.buf].ft
    local lang = vim.treesitter.language.get_lang(ft)
    local installed = nvim_treesitter.get_installed('parsers')
    if vim.list_contains(installed, lang) then
      pcall(vim.treesitter.start, event.buf)
      -- vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
    end
  end,
})

return {
  "nvim-treesitter/nvim-treesitter",
  lazy = false,
  build = function()
    require("nvim-treesitter").install{
      "bash",
      "c",
      "cpp",
      "css",
      "html",
      "json",
      "lua",
      "yaml",
      "go",
      "gomod",
      "gosum",
      "markdown",
      "rust",
      "perl",
      "vue",
      "javascript",
      "java",
      "proto",
      "vim",
      "dot",
      "helm",
      "comment",
      "typst",
      "luadoc",
      "vimdoc",
      "gitcommit",
    }
  end,
  branch = "main",
  opts = {
    highlight = { enable = true },
    indent    = { enable = false },
  },
}
