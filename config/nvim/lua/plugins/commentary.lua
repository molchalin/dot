return {
  "tpope/vim-commentary",
  event = "VeryLazy",
  config = function()
    vim.keymap.set("n", "<leader>td", "oTODO(a.eremeev) <esc>:Commentary<cr>A", { remap = false })
  end,
}
