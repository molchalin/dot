function on_attach(c, b)
  require("inlay-hints").on_attach(c, b)
  telescope = require("telescope.builtin")
  vim.lsp.codelens.refresh()
  vim.api.nvim_buf_set_option(b, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  local bufopts = { noremap=true, silent=true, buffer=b }
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
  vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, bufopts)
  vim.keymap.set('n', 'ca', vim.lsp.buf.code_action, bufopts)
  vim.keymap.set('n', 'cl', vim.lsp.codelens.run, bufopts)

  vim.keymap.set('n', 'gd', telescope.lsp_definitions, bufopts)
  vim.keymap.set('n', 'gr', telescope.lsp_references, bufopts)
  vim.keymap.set('n', 'gi', telescope.lsp_implementations, bufopts)
  vim.keymap.set('n', '<leader>D', telescope.lsp_type_definitions, bufopts)
end

return {
  {
    "simrat39/inlay-hints.nvim",
    event = "BufRead",
    opts = {
      renderer = "inlay-hints/render/eol",
      only_current_line = false,
      eol = {
        -- right_align = true,
        parameter = {
          format = function(hints)
            return string.format(" <- (%s)", hints):gsub(":", "")
          end,
        },
        type = {
          format = function(hints)
            return string.format(" » (%s)", hints):gsub(":", "")
          end,
        },
      },
    },
    config = function(_, opts)
      require("inlay-hints").setup(opts)
    end,
  },
  {
    "neovim/nvim-lspconfig",
    event = "BufRead",
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "simrat39/inlay-hints.nvim"
    },
    config = function()
      require("lspconfig").gopls.setup{
        on_attach = on_attach,
        cmd = {"gopls", "serve"},
        filetypes = {"go", "gomod"},
        root_dir = require("lspconfig/util").root_pattern("go.work", "go.mod", ".git"),
        settings = {
          gopls = {
            analyses = {
              unusedparams = true,
            },
            staticcheck = true,
            hints = {
              --assignVariableTypes = true,
              compositeLiteralFields = true,
              compositeLiteralTypes = true,
              constantValues = true,
              functionTypeParameters = true,
              -- parameterNames = true,
              rangeVariableTypes = true,
            },
            codelenses = {
              generate   = true,
              tidy       = true,
              vendor     = true,
              gc_details = true,
            },
          },
        },
      }
    end
  },
  {
    "fatih/vim-go",
    ft = "go",
    config = function()
      vim.g.go_fmt_command = "gofmt"
      vim.g.go_fmt_options = { gofmt = "-s" }
      vim.g.go_version_warning = 0
      vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
    end,
    keys = {
      {"n", "<leader>i", ":GoIfErr<cr>",       remap = false },
      {"n", "<leader>c", ":GoTestCompile<cr>", remap = false },
    },
    build = function()
      vim.cmd[[ :GoUpdateBinaries ]]
    end
  },
}
