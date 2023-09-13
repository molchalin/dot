return {
  {
    "lewis6991/gitsigns.nvim",
    event = "BufEnter",
    opts = {
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        map('n', 'gb', function() gs.blame_line{full=true} end)
      end,
      attach_to_untracked = false,
    },
    config = function(_, opts)
      require('gitsigns').setup(opts)
    end
  },
  {
    "tpope/vim-fugitive",
    event = "VeryLazy",
  },
  {
    "sindrets/diffview.nvim",
    event = "VeryLazy",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
  },
}
