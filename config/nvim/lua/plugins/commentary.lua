return {
  "tpope/vim-commentary",
  event = "VeryLazy",
  config = function()
    vim.keymap.set("n", "<leader>td", ":Commentary<cr>A", { remap = false })
  end,
}
