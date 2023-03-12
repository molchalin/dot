return {
  "matze/wastebin.nvim",
  name = "wastebin",
  cond = function()
    return vim.env.WASTEBIN_URL ~= nil
  end,
  opts = {},
}
