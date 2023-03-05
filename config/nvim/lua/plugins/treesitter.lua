return {
  "nvim-treesitter/nvim-treesitter",
  event = "BufRead",
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
      "make",
      "perl",
    },
    highlight = { enable = true },
    indent    = { enable = true },
  },
  config = function(_, opts)
    require("nvim-treesitter.configs").setup(opts)
  end,
}
