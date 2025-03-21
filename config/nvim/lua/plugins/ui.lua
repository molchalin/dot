return {
  {
    "sainnhe/gruvbox-material",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd.colorscheme("gruvbox-material")
    end,
  },
  {
    "mvllow/modes.nvim",
    event = "BufEnter",
    opts = {
      line_opacity = 0.1,
    },
  },
  {
    "nvim-lualine/lualine.nvim",
    opts = {
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
    },
  },
  {
    "edkolev/tmuxline.vim",
    event = "VeryLazy",
    cond = function()
      return vim.env.TMUX ~= nil
    end,

    config = function()
      local format_mode = function(prefix, copy, normal)
        return "#{?client_prefix," .. prefix .. ",#{?pane_in_mode," .. copy .. "," .. normal .. "}}"
      end
      vim.g.tmuxline_preset = {
        a = {format_mode("PREFIX", "COPY  ", "NORMAL")},
        b = {'\\ueb46  #S'},
        -- c = '',
        win = {'#I', '\\uea83#(tmux.plx realpath "#{session_path}" "#{pane_current_path}")', '#W'},
        cwin = {'#I', '\\ueaf6#(tmux.plx realpath "#{session_path}" "#{pane_current_path}")', '#W'},
        x = {
          "#(pomodoro status)#{forecast}",
          '%Y-%m-%d',
          '%H:%M'
        },
        y = { '#{ping}ms' },
        z = "#(whoami)",
        options = {
          ["status-justify"] = 'left',
        },
      }
      vim.g.tmuxline_theme = {
        a = {'#282828', format_mode("blue", "yellow", "#a89984"), 'bold'},
        b = {'#ddc7a1', '#504945'},
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
      if vim.fn.filereadable(vim.fn.expand("~/.config/tmux/tmuxline.conf")) == 0 then
        vim.cmd(":Tmuxline")
        vim.cmd(":TmuxlineSnapshot! ~/.config/tmux/tmuxline.conf")
      end
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
  },
  {
    "nvim-tree/nvim-web-devicons",
    opts = {
      color_icons = false,
    },
  },
  {
    'echasnovski/mini.indentscope',
    version = false,
    opts = {
      draw = {
        animation = function(a, b)
          return 0
        end
      },
      options = {
        try_as_border = true,
      },
    },
  },
}
