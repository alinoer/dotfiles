-- Leader key — WAJIB di-set di sini, sebelum lazy load
vim.g.mapleader      = " "
vim.g.maplocalleader = "\\"

local map = vim.keymap.set

-- ─── Escape ──────────────────────────────────────────────
-- jk/jj lebih ergonomis dari Esc untuk tangan di home row
map("i", "jk", "<ESC>",    { desc = "Escape insert mode" })
map("i", "jj", "<ESC>",    { desc = "Escape insert mode" })
map("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlights" })

-- ─── Navigasi baris ──────────────────────────────────────
-- gj/gk: gerak per visual line, bukan per logical line
-- Berguna saat wrap on atau di markdown panjang
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- ─── Navigasi window ─────────────────────────────────────
map("n", "<C-h>", "<C-w>h", { desc = "Window kiri" })
map("n", "<C-j>", "<C-w>j", { desc = "Window bawah" })
map("n", "<C-k>", "<C-w>k", { desc = "Window atas" })
map("n", "<C-l>", "<C-w>l", { desc = "Window kanan" })

-- ─── Resize window ───────────────────────────────────────
map("n", "<C-Up>",    "<cmd>resize +2<cr>",          { desc = "Tambah tinggi" })
map("n", "<C-Down>",  "<cmd>resize -2<cr>",          { desc = "Kurangi tinggi" })
map("n", "<C-Left>",  "<cmd>vertical resize -2<cr>", { desc = "Kurangi lebar" })
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Tambah lebar" })

-- ─── Pindah baris ────────────────────────────────────────
-- Alt-j/k bekerja di semua mode — lebih konsisten dari J/K visual only
map("n", "<A-j>", "<cmd>m .+1<cr>==",      { desc = "Pindah baris bawah" })
map("n", "<A-k>", "<cmd>m .-2<cr>==",      { desc = "Pindah baris atas" })
map("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Pindah baris bawah" })
map("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Pindah baris atas" })
map("v", "<A-j>", ":m '>+1<cr>gv=gv",     { desc = "Pindah baris bawah" })
map("v", "<A-k>", ":m '<-2<cr>gv=gv",     { desc = "Pindah baris atas" })

-- ─── Buffer ──────────────────────────────────────────────
-- Pakai Shift-h/l saja — lebih cepat dari [b/]b
-- [b/]b dihapus karena duplikat
map("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Buffer sebelumnya" })
map("n", "<S-l>", "<cmd>bnext<cr>",     { desc = "Buffer berikutnya" })
map("n", "<leader>bb", "<cmd>e #<cr>",  { desc = "Switch buffer terakhir" })
map("n", "<leader>bd", "<cmd>bdelete<cr>", { desc = "Hapus buffer" })

-- ─── Scroll (cursor tetap di tengah) ─────────────────────
-- Tanpa zz, cursor bisa loncat ke tepi layar saat scroll cepat
-- Sangat membantu saat review kode panjang
map("n", "<C-d>", "<C-d>zz", { desc = "Scroll bawah (centered)" })
map("n", "<C-u>", "<C-u>zz", { desc = "Scroll atas (centered)" })
map("n", "n",     "nzzzv",   { desc = "Next result (centered)" })
map("n", "N",     "Nzzzv",   { desc = "Prev result (centered)" })

-- ─── Indenting ───────────────────────────────────────────
map("v", "<", "<gv", { desc = "Indent kiri" })
map("v", ">", ">gv", { desc = "Indent kanan" })

-- ─── Save & Quit ─────────────────────────────────────────
map({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save file" })
map("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Quit all" })

-- ─── Clipboard & Register ────────────────────────────────
-- Masalah umum: paste menimpa register, sehingga paste berikutnya
-- mengeluarkan teks yang baru saja dihapus, bukan yang ingin di-paste
-- "_d = hapus ke void register, tidak polusi clipboard
map({ "n", "v" }, "<leader>y", '"+y',  { desc = "Copy ke clipboard sistem" })
map("n",          "<leader>Y", '"+Y',  { desc = "Copy baris ke clipboard" })
map({ "n", "v" }, "<leader>d", '"_d',  { desc = "Hapus ke void register" })
map("x",          "<leader>p", '"_dP', { desc = "Paste tanpa overwrite register" })

-- ─── Window management ───────────────────────────────────
map("n", "<leader>wv", "<cmd>vsplit<cr>", { desc = "Split vertikal" })
map("n", "<leader>wh", "<cmd>split<cr>",  { desc = "Split horizontal" })
map("n", "<leader>wq", "<cmd>close<cr>",  { desc = "Tutup window" })

-- ─── Quickfix ────────────────────────────────────────────
map("n", "<leader>qo", "<cmd>copen<cr>",  { desc = "Buka quickfix" })
map("n", "<leader>qc", "<cmd>cclose<cr>", { desc = "Tutup quickfix" })
map("n", "<leader>qn", "<cmd>cnext<cr>",  { desc = "Quickfix next" })
map("n", "<leader>qp", "<cmd>cprev<cr>",  { desc = "Quickfix prev" })

-- ─── Terminal ────────────────────────────────────────────
map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Keluar terminal mode" })

-- ─── Which-key groups ────────────────────────────────────
local wk_ok, wk = pcall(require, "which-key")
if wk_ok then
  wk.add({
    { "<leader>b",  group = "buffer" },
    { "<leader>s",  group = "search" },
    { "<leader>g",  group = "git" },
    { "<leader>gt", group = "git toggle" },
    { "<leader>l",  group = "lsp" },
    { "<leader>q",  group = "quickfix" },
    { "<leader>t",  group = "terminal" },
    { "<leader>w",  group = "window" },
  })
end