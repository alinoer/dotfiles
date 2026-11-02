-- Keymaps tambahan (dimuat saat VeryLazy)
-- Default LazyVim: https://www.lazyvim.org/keymaps

local map = vim.keymap.set

-- jk / jj untuk keluar insert mode
map("i", "jk", "<Esc>", { desc = "Escape insert mode" })
map("i", "jj", "<Esc>", { desc = "Escape insert mode" })

-- Scroll & pencarian dengan cursor tetap di tengah
map("n", "<C-d>", "<C-d>zz", { desc = "Scroll bawah (centered)" })
map("n", "<C-u>", "<C-u>zz", { desc = "Scroll atas (centered)" })
map("n", "n", "nzzzv", { desc = "Next result (centered)" })
map("n", "N", "Nzzzv", { desc = "Prev result (centered)" })

-- Paste di visual mode tanpa menimpa register
map("x", "<leader>p", '"_dP', { desc = "Paste tanpa overwrite register" })
