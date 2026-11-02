# dotfiles

Config pribadi untuk macOS, dikelola dengan [GNU Stow](https://www.gnu.org/software/stow/).
Setiap folder di sini adalah satu "paket" yang strukturnya meniru `$HOME`.

| Paket | Isi | Tujuan symlink |
|---|---|---|
| `nvim` | Neovim (lazy.nvim) | `~/.config/nvim` |
| `tmux` | tmux + TPM | `~/.config/tmux` |
| `ghostty` | terminal | `~/.config/ghostty` |
| `aerospace` | tiling window manager | `~/.config/aerospace` |
| `sketchybar` | menu bar | `~/.config/sketchybar` |
| `karabiner` | remap keyboard | `~/.config/karabiner` |
| `git` | global gitignore | `~/.config/git` |
| `fish` | env dari `uv` | `~/.config/fish` |

Shell utama: **zsh** (belum masuk repo).

---

## Pemakaian sehari-hari

Edit config seperti biasa lewat `~/.config/...` (itu symlink ke repo ini), lalu:

```zsh
cd ~/dotfiles
git add -A && git commit -m "nvim: ..." && git push
```

- Pesan commit diberi prefix nama paket: `nvim:`, `tmux:`, `ghostty:`, dst.
- Eksperimen besar → buat branch dulu (`git switch -c coba-xyz`), jangan copy folder backup.
- Jangan pernah memasukkan `gh`, `github-copilot`, atau file berisi token.

## Setup di mesin baru

```zsh
brew install stow neovim tmux tree-sitter-cli ripgrep fd lazygit
git clone git@github.com:alinoer/dotfiles.git ~/dotfiles
cd ~/dotfiles && stow */

# plugin tmux
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
# lalu buka tmux dan tekan: prefix I
```

Buka `nvim` sekali: plugin dan parser treesitter ter-install otomatis.

**Kebutuhan versi:** Neovim **0.12+** (nvim-treesitter branch `main`), tmux **3.1+**, `tree-sitter` CLI **0.26+** (dari brew, bukan npm).

---

# tmux

Prefix: **`Ctrl-a`** (ditulis `prefix` di bawah).

### Session & config
| Tombol | Fungsi |
|---|---|
| `prefix R` | Reload config |
| `prefix d` | Detach |
| `prefix s` | Daftar session (pilih/pindah) |
| `prefix $` | Rename session |
| `prefix Ctrl-s` | Simpan semua session (resurrect) |
| `prefix Ctrl-r` | Restore session yang disimpan |

### Window
| Tombol | Fungsi |
|---|---|
| `prefix c` | Window baru (di folder yang sama) |
| `prefix 1..9` | Pindah ke window nomor N |
| `prefix n` / `prefix p` | Window berikutnya / sebelumnya |
| `prefix ,` | Rename window |
| `prefix &` | Tutup window |

### Pane
| Tombol | Fungsi |
|---|---|
| `prefix \|` | Split kiri-kanan (di folder yang sama) |
| `prefix -` | Split atas-bawah (di folder yang sama) |
| `Ctrl-h/j/k/l` | Pindah pane, **juga lintas split nvim** (tanpa prefix) |
| `prefix h/j/k/l` | Pindah pane (cadangan) |
| `prefix H/J/K/L` | Resize pane (bisa ditekan berulang) |
| `prefix m` | Zoom / unzoom pane |
| `prefix x` | Tutup pane |
| `prefix Ctrl-l` | Clear screen (karena `Ctrl-l` dipakai navigasi) |

### Copy mode (gaya vi)
| Tombol | Fungsi |
|---|---|
| `prefix [` | Masuk copy mode |
| `v` / `Ctrl-v` | Mulai seleksi / seleksi kotak |
| `y` | Copy ke clipboard macOS dan keluar |
| `q` | Keluar copy mode |

### Plugin (TPM, disimpan di `~/.tmux/plugins`)
| Tombol | Fungsi |
|---|---|
| `prefix I` | Install plugin baru |
| `prefix U` | Update plugin |
| `prefix Alt-u` | Hapus plugin yang tidak ada di config |

Plugin: `tpm`, `vim-tmux-navigator`, `tmux-resurrect` (manual, tidak auto-restore, tidak menyimpan isi pane).

---

# Neovim

Leader: **`Space`**. Tekan `Space` lalu tunggu sebentar → **which-key** menampilkan semua shortcut.
Cari shortcut apa pun: `Space sk`.

### Dasar
| Tombol | Fungsi |
|---|---|
| `jk` / `jj` | Keluar insert mode |
| `Esc` | Hapus highlight pencarian |
| `Ctrl-s` | Save |
| `Space qq` | Keluar semua |
| `Alt-j` / `Alt-k` | Pindah baris ke bawah/atas |
| `<` / `>` (visual) | Indent tanpa kehilangan seleksi |
| `Ctrl-d` / `Ctrl-u` | Scroll setengah layar (cursor tetap di tengah) |

### Window & buffer
| Tombol | Fungsi |
|---|---|
| `Ctrl-h/j/k/l` | Pindah split, **juga ke pane tmux** |
| `Ctrl-Arrow` | Resize split |
| `Space wv` / `Space wh` / `Space wq` | Split vertikal / horizontal / tutup |
| `Shift-h` / `Shift-l` | Buffer sebelumnya / berikutnya |
| `Space bb` | Kembali ke buffer terakhir |
| `Space bd` | Tutup buffer |
| `Space bo` / `br` / `bl` | Tutup buffer lain / kanan / kiri |
| `Space bp` / `bP` | Pin buffer / tutup semua yang tidak di-pin |

### Cari file & teks (Telescope)
| Tombol | Fungsi |
|---|---|
| `Space ff` | Cari file |
| `Space fg` | Cari teks (live grep) |
| `Space fb` | Daftar buffer |
| `Space ?` | File yang baru dibuka |
| `Space sk` | Cari keymap |
| `Space sh` | Cari help |
| `Space sd` | Diagnostics |
| `Space sr` / `Space ss` | References / symbol (LSP) |
| `Space st` | Semua TODO/FIXME |
| Di Telescope: `Ctrl-j/k` | Naik/turun |
| Di Telescope: `Ctrl-q` | Kirim hasil ke quickfix |

### File manager (Oil)
| Tombol | Fungsi |
|---|---|
| `-` atau `Space o` | Buka folder file saat ini |
| Di Oil: edit seperti teks | Rename, hapus (`dd`), pindah (`dd` + `p`), lalu `:w` untuk menerapkan |
| Di Oil: `g.` | Tampilkan/sembunyikan dotfiles |
| Di Oil: `Ctrl-p` | Preview |

### LSP (aktif saat language server jalan)
| Tombol | Fungsi |
|---|---|
| `gd` / `gD` | Definition / declaration |
| `gi` / `gt` | Implementation / type definition |
| `gr` | References |
| `K` | Dokumentasi (hover) |
| `gK` (normal), `Ctrl-s` (insert) | Signature help |
| `Space lr` | Rename |
| `Space la` | Code action |
| `Space lf` | Format |
| `Space ld` | Detail diagnostic di baris ini |
| `[d` / `]d` | Diagnostic sebelumnya / berikutnya |
| `Space lm` | Buka Mason (install language server) |

Server: `ts_ls`, `eslint` (auto-fix saat save), `gopls`, `lua_ls`.

### Autocomplete (nvim-cmp)
| Tombol | Fungsi |
|---|---|
| `Ctrl-j` / `Ctrl-k` | Pilih item berikutnya / sebelumnya |
| `Enter` | Pakai item terpilih |
| `Ctrl-Space` | Munculkan completion |
| `Ctrl-e` | Tutup |
| `Tab` / `Shift-Tab` | Lompat di dalam snippet |

### Copilot (insert mode)
| Tombol | Fungsi |
|---|---|
| `Ctrl-j` | Terima saran (saat menu cmp tidak terbuka) |
| `Ctrl-l` | Terima satu kata |
| `Ctrl-k` / `Ctrl-h` | Saran berikutnya / sebelumnya |
| `Ctrl-]` | Tolak saran |

### Treesitter (struktur kode)
| Tombol | Fungsi |
|---|---|
| `af` / `if` | Seluruh function / isi function (contoh: `daf`, `cif`, `vaf`) |
| `ac` / `ic` | Class |
| `aa` / `ia` | Argumen |
| `ab` / `ib` | Block |
| `]f` / `[f` | Function berikutnya / sebelumnya (`]F` / `[F` = ujung function) |
| `]c` / `[c` | Class berikutnya / sebelumnya |
| `Space sa` / `Space sA` | Tukar argumen ke kanan / kiri |
| `v` lalu `an` / `in` | Perluas / perkecil seleksi berdasarkan struktur kode |

### Editing
| Tombol | Fungsi |
|---|---|
| `gcc` / `gc` (visual) | Toggle komentar |
| `sa` + objek + karakter | Tambah pembungkus (contoh: `saiw"` → `"kata"`) |
| `sd"` / `sr"'` | Hapus / ganti pembungkus |
| `Space y` / `Space Y` | Copy ke clipboard sistem |
| `Space p` (visual) | Paste tanpa menimpa register |
| `Space d` | Hapus tanpa masuk register |

### Git
| Tombol | Fungsi |
|---|---|
| `Space gg` | Lazygit (floating) |
| `]h` / `[h` | Perubahan (hunk) berikutnya / sebelumnya |
| `Space gp` | Preview hunk |
| `Space gs` / `Space gr` | Stage / reset hunk |
| `Space gS` / `Space gR` | Stage / reset seluruh file |
| `Space gb` | Blame baris ini |
| `Space gtb` / `Space gtd` | Toggle blame inline / tampilkan baris terhapus |
| `ih` | Text object hunk (contoh: `vih`) |

### Terminal
| Tombol | Fungsi |
|---|---|
| `Ctrl-\` | Toggle terminal (vertikal) |
| `Space tf` / `th` / `tv` | Terminal float / horizontal / vertikal |
| `Space tn` / `tp` / `tt` | Node REPL / Python REPL / htop |
| `Esc` (di terminal) | Kembali ke normal mode |

### Quickfix & lain-lain
| Tombol | Fungsi |
|---|---|
| `Space qo` / `Space qc` | Buka / tutup quickfix |
| `Space qn` / `Space qp` | Item quickfix berikutnya / sebelumnya |
| `]t` / `[t` | TODO berikutnya / sebelumnya |
| `Space tsc` | Toggle animasi cursor |
| `q` | Tutup jendela help, quickfix, checkhealth, dll |

### Plugin
- **UI:** catppuccin (mocha, transparan), lualine, bufferline, incline, indent-blankline, nvim-notify, neoscroll, smear-cursor, fidget
- **Navigasi:** telescope (+ fzf-native), oil, which-key, vim-tmux-navigator
- **Kode:** nvim-treesitter (`main`), treesitter-textobjects, mason, nvim-lspconfig, nvim-cmp + LuaSnip, copilot
- **Editing:** mini.pairs, mini.surround, mini.comment, gitsigns, todo-comments
- **Terminal:** toggleterm (+ lazygit)

Perintah berguna: `:Lazy` (kelola plugin), `:Mason`, `:checkhealth`, `:TSUpdate`.

---

## Catatan perubahan (2 Nov 2026)

**tmux**
- Plugin dimuat otomatis saat tmux start (sebelumnya harus `prefix I` dulu, jadi `Ctrl-h/j/k/l` ke nvim tidak jalan).
- Save/restore resurrect pindah ke bawaan plugin (`prefix Ctrl-s` / `prefix Ctrl-r`); `prefix s` kembali jadi daftar session.
- Split dan window baru terbuka di folder pane saat ini.
- Ditambah: `focus-events`, `set-clipboard`, true color untuk semua terminal, resize `prefix H/J/K/L`, `detach-on-destroy off`.

**nvim**
- **Treesitter diperbaiki.** Plugin sudah di branch `main` tapi config masih memakai API lama yang sudah dihapus, sehingga parser, highlight, dan textobjects diam-diam tidak aktif. Ditulis ulang dengan API baru.
- **LSP** memakai API bawaan Neovim (`vim.lsp.config` / `vim.lsp.enable`); hack yang menyembunyikan peringatan deprecated dihapus.
- **`Ctrl-k` bentrok** dengan signature help di buffer yang punya LSP, sehingga tidak bisa pindah ke split atas. Signature help pindah ke `gK` / `Ctrl-s` (insert).
- **`Space bb` bentrok** antara "buffer terakhir" dan daftar buffer Telescope. Daftar buffer pindah ke `Space fb`.
- Ditambah **vim-tmux-navigator** di sisi nvim (pasangan dari plugin tmux).
- gitsigns yang terdaftar dua kali disatukan; grup which-key dirapikan; API deprecated (`vim.highlight`, `vim.loop`) diganti.
