return {
  {
    "sainnhe/gruvbox-material",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd([[colorscheme gruvbox-material]])
    end,
  },
  {
    "mvllow/modes.nvim",
    event = "BufEnter",
    config = function()
      require('modes').setup({
        line_opacity = 0.1,
      })
    end
  },
  {
    "nvim-lualine/lualine.nvim",
    config = function()
      require("lualine").setup {
        options = {
          theme = 'gruvbox-material',
        },
        sections = {
          lualine_a = {'mode'},
          lualine_b = {'branch', 'diff', 'diagnostics'},
          lualine_c = {{'filename', path = 1}},
          lualine_x = {'encoding', 'fileformat', 'filetype'},
          lualine_y = {'progress'},
          lualine_z = {'location'}
        },
        tabline = {
          lualine_a = {
            {
              'tabs',
              mode = 2,
              max_length = vim.o.columns,
            },
          },
        },
      }
    end,
  },
  {
    "edkolev/tmuxline.vim",
    event = "VeryLazy",
    cond = function()
      return vim.env.TMUX ~= nil
    end,

    config = function()
      vim.g.tmuxline_preset = {
        a = '#S',
        -- b = '',
        -- c = '',
        win = {'#I', "\\uea83#(tmux-realpath #{session_path} #{pane_current_path})", '#W'},
        cwin = {'#I', "\\ueaf6#(tmux-realpath #{session_path} #{pane_current_path})", '#W'},
        x = {
          "#(~/.config/tmux/plugins/tmux-weather/scripts/forecast.sh)",
          '%Y-%m-%d',
          '%H:%M'
        },
        y = { '#(~/.config/tmux/plugins/tmux-ping/scripts/ping_status.sh)ms' },
        z = "#(whoami)",
        options = {
          ["status-justify"] = 'left',
        },
      }
      vim.g.tmuxline_theme = {
        a = {'#282828', '#a89984', 'bold'},
        b = {'#ddc7a1', '#32302f'},
        c = {'#928374', '#32302f'},
        x = {'#ddc7a1', '#3a3735'},
        y = {'#ddc7a1', '#504945'},
        z = {'#282828', '#a89984', 'bold'},
        bg = {'#3a3735', '#3a3735'},
        win = {'#ddc7a1', '#3a3735'},
        cwin = {'#ddc7a1', '#504945'},
        pane = { '#504945' },
        cpane = { '#a89984' },
      }
      vim.cmd[[ :Tmuxline ]]
    end,
  },
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

        map('n', '<leader>bl', function() gs.blame_line{full=true} end)
      end,
      attach_to_untracked = false,
    },
    config = function(_, opts)
      require('gitsigns').setup(opts)
    end
  },
  {
    "nvim-tree/nvim-web-devicons",
    config = function()
      require("nvim-web-devicons").setup({
        color_icons = false,
      })
    end
  },
  {
    "echasnovski/mini.trailspace",
    version = false,
    config = function()
      require("mini.trailspace").setup()
    end
  },
}
