return {
  "nvim-treesitter/nvim-treesitter",
  event = "BufEnter",
  build = ":TSUpdate",
  opts = {
    ensure_installed = {
      "bash",
      "c",
      "cpp",
      "css",
      "html",
      "json",
      "lua",
      "yaml",
      "go",
      "gomod",
      "gosum",
      "markdown",
      "rust",
      "perl",
      "vue",
      "javascript",
      "proto",
      "vim",
      "dot",
    },
    highlight = { enable = true },
    indent    = { enable = true },
  },
  config = function(_, opts)
    require("nvim-treesitter.configs").setup(opts)
  end,
}
