local group = vim.api.nvim_create_augroup("LSP", { clear = true })

local is_alive = function(client)
  if client == nil then
    return false
  end
  if not client.initialized then
    return false
  end
  if client.is_stopped() then
    return false
  end
  return true
end

-- Organize imports.
--
-- https://github.com/neovim/nvim-lspconfig/issues/115#issuecomment-902680058
local organize_imports = function(client, bufnr, timeoutms)
  local params = vim.lsp.util.make_range_params(nil, client.offset_encoding)
  params.context = { only = { "source.organizeImports" } }
  local result = vim.lsp.buf_request_sync(bufnr, "textDocument/codeAction", params, timeoutms)
  for _, res in pairs(result or {}) do
    for _, r in pairs(res.result or {}) do
      if r.edit then
        vim.lsp.util.apply_workspace_edit(r.edit, client.offset_encoding)
      else
        vim.lsp.buf.execute_command(r.command)
      end
    end
  end
end

local on_attach = function(c, b)
  require("inlay-hints").on_attach(c, b)
  if c.server_capabilities.documentFormattingProvider then
    vim.api.nvim_create_autocmd({ "BufWritePre" }, {
      buffer = b,
      callback = function()
        vim.lsp.buf.format({
          filter = function(cli)
            return cli.name == c.name
          end,
        })
      end,
      group = group,
    })
  end

  if c.server_capabilities.codeActionProvider then
    vim.api.nvim_create_autocmd({ "BufWritePre" }, {
      buffer = bufnr,
      callback = function()
        organize_imports(c, b, 1500)
      end,
      group = group,
    })
  end

  if c.name == 'gopls' and not c.server_capabilities.semanticTokensProvider then
    local semantic = c.config.capabilities.textDocument.semanticTokens
    c.server_capabilities.semanticTokensProvider = {
      full = true,
      legend = {tokenModifiers = semantic.tokenModifiers, tokenTypes = semantic.tokenTypes},
      range = true,
    }
  end



  if c.server_capabilities.codeLensProvider then
    vim.lsp.codelens.refresh()
    vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
      buffer = b,
      callback = function()
        if is_alive(c) then
          vim.lsp.codelens.refresh()
        end
      end,
      group = group,
    })
    vim.api.nvim_create_autocmd("LspDetach", {
      buffer = b,
      callback = function()
        if is_alive(c) then
          vim.lsp.codelens.clear()
        end
      end,
      group = group,
    })
  end

  telescope = require("telescope.builtin")
  vim.api.nvim_buf_set_option(b, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  local bufopts = { noremap=true, silent=true, buffer=b }
  vim.keymap.set('n', 'gD',         vim.lsp.buf.declaration, bufopts)
  vim.keymap.set('n', 'K',          vim.lsp.buf.hover,       bufopts)
  vim.keymap.set('n', 'rn', vim.lsp.buf.rename,      bufopts)
  vim.keymap.set('n', 'ca',         vim.lsp.buf.code_action, bufopts)
  vim.keymap.set('n', 'cl',         vim.lsp.codelens.run,    bufopts)

  vim.keymap.set('n', 'gd',        telescope.lsp_definitions,      bufopts)
  vim.keymap.set('n', 'gr',        telescope.lsp_references,       bufopts)
  vim.keymap.set('n', 'gi',        telescope.lsp_implementations,  bufopts)
  vim.keymap.set('n', '<leader>d', telescope.lsp_type_definitions, bufopts)
  vim.keymap.set('n', 'ge',        telescope.diagnostics,          bufopts)

end

return {
  {
    "simrat39/inlay-hints.nvim",
    event = "BufEnter",
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
    event = "BufEnter",
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "simrat39/inlay-hints.nvim",
      "hrsh7th/nvim-cmp",
    },
    config = function()
      local capabilities = require('cmp_nvim_lsp').default_capabilities() --nvim-cmp
      require("lspconfig").gopls.setup{
        on_attach  = on_attach,
        cmd = {"gopls", "serve"},
        filetypes = {"go", "gomod"},
        root_dir = require("lspconfig/util").root_pattern("go.work", "go.mod", ".git"),
        capabilities = capabilities,
        settings = {
          gopls = {
            experimentalPostfixCompletions = false,
            semanticTokens = true,
            analyses = {
              unusedparams = true,
            },
            staticcheck = true,
            -- hints = {
              --assignVariableTypes = true,
              -- compositeLiteralFields = true,
              -- compositeLiteralTypes = true,
              -- constantValues = true,
              -- functionTypeParameters = true,
              -- parameterNames = true,
              -- rangeVariableTypes = true,
            -- },
            codelenses = {
              generate   = true,
              tidy       = true,
              vendor     = true,
              gc_details = true,
            },
          },
        },
        init_options = {
          -- usePlaceholders = true,
        },
      }
      require("lspconfig").golangci_lint_ls.setup{
        on_attach  = on_attach,
        capabilities = capabilities,
        filetypes = {"go", "gomod"},
      }
    end
  },
  {
    "fatih/vim-go",
    event = "BufEnter",
    ft = "go",
    config = function()
      vim.g.go_version_warning = 0
      vim.g.go_gopls_enabled = 0
      vim.g.go_code_completion_enabled = 0
      vim.g.go_fmt_autosave = 0
      vim.g.go_imports_autosave = 0
      vim.g.go_mod_fmt_autosave = 0
      vim.g.go_doc_keywordprg_enabled = 0
      vim.g.go_def_mapping_enabled = 0
      vim.g.go_textobj_enabled = 0
      vim.g.go_list_type = 'quickfix'
    end,
    keys = {
      {"<leader>ge", ":GoIfErr<cr>",          remap = false },
      {"<leader>gb", ":GoTestCompile<cr>",    remap = false },
      {"<leader>gt", ":GoTest<cr>",           remap = false },
      {"<leader>gc", ":GoCoverageToggle<cr>", remap = false },
      {"<leader>ga", ":GoAlternate<cr>",      remap = false },
    },
    build = function()
      vim.cmd[[ :GoUpdateBinaries ]]
    end
  },
  {
    "p00f/clangd_extensions.nvim",
    ft = { "c", "cpp" },
    config = function()
      require("clangd_extensions").setup({
        server = {
          on_attach  = on_attach,
        },
        extensions = {
          inlay_hints = {
            show_parameter_hints = true,
            parameter_hints_prefix = "← ",
            other_hints_prefix = "⇒ ",
          }
        }
      })
    end,
  },
}
