return {
  {
    "hrsh7th/nvim-cmp",
    config = function()
      local cmp = require("cmp")

      local t = function(str)
        return vim.api.nvim_replace_termcodes(str, true, true, true)
      end

      cmp.setup({
        snippet = {
          expand = function(args)
            vim.fn["UltiSnips#Anon"](args.body)
          end,
        },
        completion = { autocomplete = false },
        preselect = cmp.PreselectMode.None,
        sources = cmp.config.sources({
          { name = "ultisnips", priority = 50 },
          { name = "nvim_lsp" },
          { name = "nvim_lsp_signature_help" },
          { name = "path" },
          { name = "calc" },
        }),
        mapping = cmp.mapping.preset.insert({
          ["<Tab>"] = cmp.mapping({
            c = function()
              if cmp.visible() then
                cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
              else
                cmp.complete()
              end
            end,
            i = function(fallback)
              if cmp.visible() then
                cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
              elseif vim.fn["UltiSnips#CanJumpForwards"]() == 1 then
                vim.api.nvim_feedkeys(t("<Plug>(ultisnips_jump_forward)"), 'm', true)
              else
                cmp.complete()
              end
            end,
            s = function(fallback)
              if vim.fn["UltiSnips#CanJumpForwards"]() == 1 then
                vim.api.nvim_feedkeys(t("<Plug>(ultisnips_jump_forward)"), 'm', true)
              else
                fallback()
              end
            end
          }),
          ["<S-Tab>"] = cmp.mapping({
            c = function()
              if cmp.visible() then
                cmp.select_prev_item({ behavior = cmp.SelectBehavior.Insert })
              else
                cmp.complete()
              end
            end,
            i = function(fallback)
              if cmp.visible() then
                cmp.select_prev_item({ behavior = cmp.SelectBehavior.Insert })
              elseif vim.fn["UltiSnips#CanJumpBackwards"]() == 1 then
                return vim.api.nvim_feedkeys( t("<Plug>(ultisnips_jump_backward)"), 'm', true)
              else
                fallback()
              end
            end,
            s = function(fallback)
              if vim.fn["UltiSnips#CanJumpBackwards"]() == 1 then
                return vim.api.nvim_feedkeys( t("<Plug>(ultisnips_jump_backward)"), 'm', true)
              else
                fallback()
              end
            end
          }),
          ['<Down>'] = cmp.mapping(cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }), {'i'}),
          ['<Up>'] = cmp.mapping(cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }), {'i'}),
          ['<C-n>'] = cmp.mapping({
            c = function()
              if cmp.visible() then
                cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
              else
                vim.api.nvim_feedkeys(t('<Down>'), 'n', true)
              end
            end,
            i = function(fallback)
              if cmp.visible() then
                cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
              else
                fallback()
              end
            end
          }),
          ['<C-p>'] = cmp.mapping({
            c = function()
              if cmp.visible() then
                  cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
              else
                vim.api.nvim_feedkeys(t('<Up>'), 'n', true)
              end
            end,
            i = function(fallback)
              if cmp.visible() then
                cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
              else
                fallback()
              end
            end
          }),
          ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), {'i', 'c'}),
          ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), {'i', 'c'}),
          ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), {'i', 'c'}),
          ['<C-e>'] = cmp.mapping({ i = cmp.mapping.close(), c = cmp.mapping.close() }),
          ['<CR>'] = cmp.mapping({
            i = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false }),
            c = function(fallback)
              if cmp.visible() then
                cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
              else
                fallback()
              end
            end
          }),
        }),
      })
    end,
    dependencies = {
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-nvim-lsp-signature-help",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-calc",
      "quangnguyen30192/cmp-nvim-ultisnips",
      {
        "SirVer/ultisnips",
        config = function()
          vim.g.UltiSnipsExpandTrigger = '<Plug>(ultisnips_expand)'      
          vim.g.UltiSnipsJumpForwardTrigger = '<Plug>(ultisnips_jump_forward)'
          vim.g.UltiSnipsJumpBackwardTrigger = '<Plug>(ultisnips_jump_backward)'
          vim.g.UltiSnipsListSnippets = '<c-x><c-s>'
          vim.g.UltiSnipsRemoveSelectModeMappings = 0
        end
      },
    }
  },
  {
    "hrsh7th/cmp-cmdline",
    event = "CmdlineEnter",
    config = function()
      local cmp = require("cmp")

      -- Use buffer source for `/`.
      cmp.setup.cmdline('/', {
        completion = { autocomplete = false },
        sources = {
          { name = 'buffer' }
        }
      })

      -- Use cmdline & path source for ':'.
      cmp.setup.cmdline(':', {
        completion = { autocomplete = false },
        sources = cmp.config.sources({
          { name = 'path' }
          }, {
          { name = 'cmdline' }
        })
      })
    end,
  },
}
