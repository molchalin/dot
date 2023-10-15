return {
  "edkolev/tmuxline.vim",
  cond = function()
    return vim.env.TMUX ~= nil
  end,

  config = function()
    vim.cmd[[ :Tmuxline vim_statusline_3 ]]
  end,
}
