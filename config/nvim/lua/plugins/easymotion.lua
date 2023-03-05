return {
  "easymotion/vim-easymotion",
  event = "VeryLazy",
  config = function()
    vim.keymap.set("n", "<leader>",  "<Plug>(easymotion-prefix)")
  end,
}
