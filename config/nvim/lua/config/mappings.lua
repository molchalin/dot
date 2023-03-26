vim.g.mapleader = ","

vim.keymap.set("n", "<leader>e",  ":tabedit<space>",  { remap = false })
vim.keymap.set("n", "<leader>q",  ":wqa<cr>",         { remap = false })
vim.keymap.set("n", "*",          "*``",              { remap = false })

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "J", "mzJ`z")

vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzz")
vim.keymap.set("n", "N", "Nzz")

vim.keymap.set("x", "<leader>p", "\"_dP")
