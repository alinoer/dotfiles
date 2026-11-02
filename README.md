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

**Kebutuhan versi:** Neovim **0.11.2+** (disarankan 0.12), tmux **3.1+**, `tree-sitter` CLI **0.26+** (dari brew, bukan npm).

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

# Neovim (LazyVim)

Distribusi [LazyVim](https://www.lazyvim.org). Daftar lengkap shortcut bawaan: https://www.lazyvim.org/keymaps

Leader: **`Space`**. Tekan `Space` lalu tunggu → **which-key** menampilkan semua shortcut. Cari keymap: `Space sk`.

### Isi config ini
| File | Isi |
|---|---|
| `lazyvim.json` | Extras yang aktif (atur lewat `:LazyExtras`) |
| `lua/config/keymaps.lua` | Keymap tambahan pribadi |
| `lua/config/options.lua` | Option tambahan (masih kosong, pakai default LazyVim) |
| `lua/plugins/personal.lua` | Plugin & override pribadi |

**Extras aktif:** copilot, mini-surround, prettier, lang go / json / markdown / typescript, eslint.
**Tambahan pribadi:** catppuccin mocha transparan, vim-tmux-navigator, oil.nvim, `jk`/`jj` untuk Esc, scroll & pencarian dengan cursor di tengah.

### Shortcut yang paling sering dipakai
| Tombol | Fungsi |
|---|---|
| `jk` / `jj` | Keluar insert mode |
| `Ctrl-s` | Save |
| `Ctrl-h/j/k/l` | Pindah split, **juga ke pane tmux** |
| `Shift-h` / `Shift-l` | Buffer sebelumnya / berikutnya |
| `Space bd` / `Space bo` | Tutup buffer / tutup buffer lain |
| `Space Space` atau `Space ff` | Cari file |
| `Space /` | Cari teks di project (grep) |
| `Space ,` | Daftar buffer |
| `Space fr` | File yang baru dibuka |
| `Space e` | File explorer (sidebar) |
| `-` | Oil: edit folder seperti teks (`:w` untuk menerapkan) |
| `Space gg` | Lazygit |
| `]h` / `[h`, `Space ghp` | Hunk git berikutnya / sebelumnya, preview hunk |
| `gd` / `gr` / `K` | Definition / references / dokumentasi |
| `Space cr` / `Space ca` / `Space cf` | Rename / code action / format |
| `Space cd`, `]d` / `[d` | Detail diagnostic, diagnostic berikutnya / sebelumnya |
| `Space xx` | Daftar semua masalah (Trouble) |
| `Ctrl-/` | Toggle terminal |
| `gsa` / `gsd` / `gsr` | Surround: tambah / hapus / ganti pembungkus (contoh `gsaiw"`) |
| `gcc` / `gc` | Toggle komentar |
| `Alt-j` / `Alt-k` | Pindah baris |
| `Space p` (visual) | Paste tanpa menimpa register |
| `Space l` | Buka Lazy (kelola plugin) |
| `Space cm` | Buka Mason (language server) |
| `Space qq` | Keluar |

Copilot tampil sebagai saran di menu completion (blink.cmp); `Tab` untuk menerima.

Perintah berguna: `:Lazy`, `:LazyExtras`, `:Mason`, `:checkhealth`, `:TSUpdate`.

Config nvim custom yang lama tersimpan di tag git `nvim-custom-lama`
(`git show nvim-custom-lama:nvim/.config/nvim/lua/plugins/lsp.lua`, dst).

---

## Catatan perubahan (2 Nov 2026)

**tmux**
- Plugin dimuat otomatis saat tmux start (sebelumnya harus `prefix I` dulu, jadi `Ctrl-h/j/k/l` ke nvim tidak jalan).
- Save/restore resurrect pindah ke bawaan plugin (`prefix Ctrl-s` / `prefix Ctrl-r`); `prefix s` kembali jadi daftar session.
- Split dan window baru terbuka di folder pane saat ini.
- Ditambah: `focus-events`, `set-clipboard`, true color untuk semua terminal, resize `prefix H/J/K/L`, `detach-on-destroy off`.

**nvim** — config custom diganti **LazyVim** (lihat di atas). Perbaikan di bawah ini berlaku untuk config lama (tag `nvim-custom-lama`):
- **Treesitter diperbaiki.** Plugin sudah di branch `main` tapi config masih memakai API lama yang sudah dihapus, sehingga parser, highlight, dan textobjects diam-diam tidak aktif. Ditulis ulang dengan API baru.
- **LSP** memakai API bawaan Neovim (`vim.lsp.config` / `vim.lsp.enable`); hack yang menyembunyikan peringatan deprecated dihapus.
- **`Ctrl-k` bentrok** dengan signature help di buffer yang punya LSP, sehingga tidak bisa pindah ke split atas. Signature help pindah ke `gK` / `Ctrl-s` (insert).
- **`Space bb` bentrok** antara "buffer terakhir" dan daftar buffer Telescope. Daftar buffer pindah ke `Space fb`.
- Ditambah **vim-tmux-navigator** di sisi nvim (pasangan dari plugin tmux).
- gitsigns yang terdaftar dua kali disatukan; grup which-key dirapikan; API deprecated (`vim.highlight`, `vim.loop`) diganti.
