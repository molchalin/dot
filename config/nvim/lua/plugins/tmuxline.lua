return {
  "edkolev/tmuxline.vim",
  cond = function()
    return vim.env.TMUX ~= nil
  end,

  config = function()
    vim.g.tmuxline_preset = { 
      a = '#S',
      -- b = '',
      -- c = '',
      win = {'#I', '#W'},
      cwin = {'#I', '#W'},
      x = {"#(~/.tmux/plugins/tmux-weather/scripts/forecast.sh)"},
      y = {'%Y-%m-%d', '%H:%M'},
      z = "#(whoami)",
      options = {
        ["status-justify"] = 'left',
      },
    }
    vim.cmd[[ :Tmuxline vim_statusline_3 ]]
  end,
}
