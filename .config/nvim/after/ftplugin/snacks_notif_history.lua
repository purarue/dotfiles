-- Close notification buffer with q/Esc
vim.keymap.set("n", "q", "<Cmd>bdelete<CR>", { buffer = 0 })
vim.keymap.set("n", "<Esc>", "<Cmd>bdelete<CR>", { buffer = 0 })
