return {
  "nvim-telescope/telescope.nvim",
  event = "VeryLazy",
  keys = {
    { "<C-p>",     "<cmd>Telescope find_files<CR>",  remap = false },
    { "<C-f>",     "<cmd>Telescope live_grep<CR>",   remap = false },
    { "<C-g>",     "<cmd>Telescope grep_string<CR>", remap = false },
    { "ge",        "<cmd>Telescope diagnostics<CR>", remap = false },
    { "<leader>r", "<cmd>Telescope resume<CR>",      remap = false },
  },
  opts = {
    defaults = {
      file_ignore_patterns = {
        "thirdparty/",
      },
    },
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
    {
      "nvim-telescope/telescope-ui-select.nvim",
      config = function()
        require("telescope").load_extension("ui-select")
      end
    },
  },
}
