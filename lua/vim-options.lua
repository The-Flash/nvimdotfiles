vim.cmd("set expandtab")
vim.cmd("set tabstop=4")
vim.cmd("set softtabstop=4")
vim.cmd("set shiftwidth=4")
vim.cmd("set number")
vim.cmd("set relativenumber")
vim.o.clipboard = "unnamedplus"
vim.g.mapleader = " "
vim.keymap.set("n", "<leader>sf", ":w<enter>", { desc = "Save current buffer" })
