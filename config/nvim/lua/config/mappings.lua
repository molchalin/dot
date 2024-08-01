vim.g.mapleader = ","

vim.keymap.set("n", "<leader>e",  ":tabedit<space>", { remap = false })
vim.keymap.set("n", "<leader>q",  ":wq<cr>", { remap = false })

-- don't jump to next match
vim.keymap.set("n", "*",          "*``", { remap = false })

-- move blocks of code in visual mode
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { remap = false })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { remap = false })

-- don't put cursor at the end of the line after J
vim.keymap.set("n", "J", "mzJ`z", { remap = false })

-- put cursor in the middle of the screen when jumping
vim.keymap.set("n", "<C-d>", "<C-d>zz", { remap = false })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { remap = false })
vim.keymap.set("n", "n", "nzz", { remap = false })
vim.keymap.set("n", "N", "Nzz", { remap = false })
vim.keymap.set("n", "G", "Gzz", { remap = false })

-- replace word under the cursor
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { remap = false })

-- paste, but without saving replaced data
vim.keymap.set("x", "<leader>p", "\"_dP", { remap = false })
vim.keymap.set("x", "<leader>d", "\"_d", { remap = false })
vim.keymap.set("n", "<leader>d", "\"_d", { remap = false })

-- quicklist
vim.keymap.set("n", "cn", ":cnext<cr>", { remap = false })
vim.keymap.set("n", "cp", ":cprev<cr>", { remap = false })

vim.keymap.set("n", "gco", "o<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", { remap = false, desc = "add comment below"})
vim.keymap.set("n", "gcO", "O<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", { remap = false, desc = "add comment above"})
