local group = vim.api.nvim_create_augroup("LSP", { clear = true })

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
  if c.name == "gopls" and c.server_capabilities.documentFormattingProvider then
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

  if c.name == "gopls" and c.server_capabilities.codeActionProvider then
    vim.api.nvim_create_autocmd({ "BufWritePre" }, {
      buffer = bufnr,
      callback = function()
        organize_imports(c, b, 1500)
      end,
      group = group,
    })
  end

  telescope = require("telescope.builtin")

  local bufopts = { noremap=true, silent=true, buffer=b }
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration,    bufopts)
  vim.keymap.set('n', 'K',  vim.lsp.buf.hover,          bufopts)
  vim.keymap.set('n', 'gK', vim.lsp.buf.signature_help, bufopts)
  vim.keymap.set('n', 'rn', vim.lsp.buf.rename,         bufopts)
  vim.keymap.set('n', 'ca', vim.lsp.buf.code_action,    bufopts)
  vim.keymap.set('n', 'cl', vim.lsp.codelens.run,       bufopts)
  vim.keymap.set('n', 'gl', vim.diagnostic.open_float,  bufopts)

  vim.keymap.set('n', 'gd',        telescope.lsp_definitions,      bufopts)
  vim.keymap.set('n', 'gr',        telescope.lsp_references,       bufopts)
  vim.keymap.set('n', 'gi',        telescope.lsp_implementations,  bufopts)
  vim.keymap.set('n', 'ge',        telescope.diagnostics,          bufopts)

end

return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "hrsh7th/nvim-cmp",
    },
    config = function()
      local capabilities = require('cmp_nvim_lsp').default_capabilities() --nvim-cmp
      local lspconfig = require 'lspconfig'
      lspconfig.gopls.setup{
        on_attach  = on_attach,
        cmd = {"gopls", "serve"},
        filetypes = {"go", "gomod"},
        root_dir = require("lspconfig/util").root_pattern("go.work", "go.mod", ".git"),
        capabilities = capabilities,
        settings = {
          gopls = {
            codelenses = {
              generate   = true,
              tidy       = true,
              vendor     = true,
              gc_details = true,
            },
            -- disable snippets
            experimentalPostfixCompletions = false,
          },
        },
      }

      lspconfig.golangci_lint_ls.setup{
        on_attach  = on_attach,
        capabilities = capabilities,
        filetypes = {"go", "gomod"},
      }

      lspconfig.rust_analyzer.setup{
        capabilities = capabilities,
        on_attach = on_attach,
        filetypes = {'rust'},
      }

      lspconfig.clangd.setup{
        capabilities = capabilities,
        on_attach = on_attach,
        filetypes = {'cpp', 'c'},
      }

      lspconfig.jdtls.setup{
        capabilities = capabilities,
        on_attach = on_attach,
        filetypes = {"java"},
        cmd = { 'jdtls' },
        root_dir = function(fname)
          return require("lspconfig/util").root_pattern(".git")(fname) .. "/eclipse"
        end,
        settings = {
          java = {
            configuration = {
              runtimes = {
                {
                  name = "JavaSE-11",
                  path = "/usr/lib/jvm/java-11-openjdk/",
                },
                {
                  name = "JavaSE-17",
                  path = "/usr/lib/jvm/java-17-openjdk/",
                },
              },
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
      {"<leader>ga", ":GoAlternate!<cr>",     remap = false },
    },
    build = function()
      vim.cmd[[ :GoUpdateBinaries ]]
    end
  },
  {
    "mfussenegger/nvim-jdtls",
    ft = "java",
  },
}
