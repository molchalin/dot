return {
  {
    "lewis6991/gitsigns.nvim",
    event = "BufEnter",
    config = function()
      require("gitsigns").setup({
        attach_to_untracked = false,
        keymaps = {
          ["n <leader>gb"] = "<cmd>lua require('gitsigns').blame_line{full=true}<CR>",
        }
      })
    end
  },
  {
    "tpope/vim-fugitive",
    event = "VeryLazy",
  },
}
