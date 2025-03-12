return {
  "folke/snacks.nvim",
  event = "VeryLazy",
  keys = {
    { "<C-p>",      function() Snacks.picker.files()        end, remap = false },
    { "<C-f>",      function() Snacks.picker.grep()         end, remap = false },
    { "<C-g>",      function() Snacks.picker.grep_word()    end, remap = false },
    { "-",          function() Snacks.picker.explorer()     end, remap = false },
    { "<leader>gl", function() Snacks.picker.git_log_file() end, remap = false },
  },
  opts = {
    picker = {
      ui_select = true,
      layout = {
        preset = "telescope",
      },
      matcher = {
        history_bonus = true,
        frecency = true,
      },
    },
  },
}
