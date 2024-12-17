vim.g.mapleader = ","

local noremap = function(mode, lhs, rhs, opts)
  if opts == nil then
    opts = {}
  end
  opts.remap = false
  vim.keymap.set(mode, lhs, rhs, opts)
end

noremap("n", "<leader>e",  ":tabedit<space>")
noremap("n", "<leader>q",  "<cmd>wq<cr>")

noremap("n", "*", "*``", { desc = "don't jump to next match" })

noremap("v", "J", ":m '>+1<CR>gv=gv", { desc = "move blocks of code in visual" })
noremap("v", "K", ":m '<-2<CR>gv=gv", { desc = "move blocks of code in visual" })

noremap("n", "J", "mzJ`z", { desc = "don't put cursor at the end of the line after J" })

-- put cursor in the middle of the screen when jumping
noremap("n", "<C-d>", "<C-d>zz")
noremap("n", "<C-u>", "<C-u>zz")
noremap("n", "n", "nzz")
noremap("n", "N", "Nzz")
noremap("n", "G", "Gzz")

noremap(
  "n",
  "<leader>s",
  [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
  {desc = "replace word under the cursor"}
)

noremap("x", "<leader>p", "\"_dP", { desc = "replace, but don't save to buffer" })
noremap({"n", "x"}, "<leader>d", "\"_d", { desc = "delete, but don't save to buffer" })

noremap("n", "cn", "<cmd>cnext<cr>", { desc = "next quicklist entry" })
noremap("n", "cp", "<cmd>cprev<cr>", { desc = "prev quicklist entry" })

noremap("n", "gco", "o<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", { desc = "add comment below" })
noremap("n", "gcO", "O<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", { desc = "add comment above" })
noremap("n", "<leader>tdO", "<cmd>normal gcOTODO(" .. vim.env.USER .. "): <cr>a", { desc = "todo comment above"})
noremap("n", "<leader>tdo", "<cmd>normal gcoTODO(" .. vim.env.USER .. "): <cr>a", { desc = "todo comment below"})

noremap("n", "<leader>ad", function()
  return "<cmd>normal a" .. vim.fn.strftime("%F") .. "<cr>"
end, { desc = "append date", expr = true })

noremap("n", "<leader>at", function()
  return "<cmd>normal a" .. vim.fn.strftime("%H:%M") .. "<cr>"
end, { desc = "append time", expr = true })
