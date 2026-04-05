return {

  -- ─── nvim-treesitter ──────────────────────────────────────
  -- Treesitter adalah parser — ia membaca kode sebagai AST (pohon sintaks),
  -- bukan sekedar regex. Dampaknya: highlight jauh lebih akurat,
  -- Neovim "mengerti" struktur kode, bukan hanya mencocokkan pola teks.
  --
  -- Tanpa treesitter: highlight berbasis regex → sering salah di edge case
  -- Dengan treesitter: highlight berbasis struktur bahasa → selalu akurat
  {
    "nvim-treesitter/nvim-treesitter",
    build  = ":TSUpdate",           -- update parser saat plugin update
    event  = { "BufReadPost", "BufNewFile" },
    dependencies = {
      -- Textobjects berbasis AST: "af" = around function, "ac" = around class
      -- Tanpa ini, "daf" (delete around function) tidak tersedia
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
    config = function()
      local status_ok, configs = pcall(require, "nvim-treesitter.configs")
      if not status_ok then
        return
      end
      
      configs.setup({

        -- Parser yang di-install otomatis
        -- Setiap bahasa punya parser sendiri yang di-compile lokal
        ensure_installed = {
          "typescript", "tsx",        -- TypeScript & React
          "javascript",               -- JavaScript biasa
          "go", "gomod", "gosum",     -- Go + module files
          "lua",                      -- config Neovim
          "json", "jsonc",            -- config files
          "yaml",                     -- docker-compose, k8s, CI
          "toml",                     -- config files modern
          "markdown", "markdown_inline", -- dokumentasi
          "bash",                     -- shell scripts
          "html", "css",              -- web basics
          "regex",                    -- regex di dalam kode
          "vim", "vimdoc",            -- built-in help
        },

        -- Highlight berbasis AST — ini fitur utamanya
        -- Menggantikan highlight bawaan Neovim yang berbasis regex
        highlight = {
          enable = true,
          -- Matikan highlight bawaan Vim untuk bahasa yang sudah ada parsernya
          -- Kalau keduanya aktif, bisa terjadi konflik warna
          additional_vim_regex_highlighting = false,
        },

        -- Indentasi cerdas berbasis AST
        -- Ketika tekan Enter di dalam function/object, indent langsung tepat
        indent = {
          enable = true,
        },

        -- Incremental selection: perluas/perkecil selection berdasarkan node AST
        -- Contoh: cursor di dalam string → <CR> select string →
        --         <CR> lagi → select argument → <CR> lagi → select pemanggilan fungsi
        -- Sangat berguna untuk refactor tanpa perlu hafal posisi kurung
        incremental_selection = {
          enable  = true,
          keymaps = {
            init_selection    = "<CR>",   -- mulai selection di node saat ini
            node_incremental  = "<CR>",   -- perluas ke parent node
            node_decremental  = "<BS>",   -- perkecil kembali
            scope_incremental = "<S-CR>", -- langsung ke scope (function/class)
          },
        },

        -- Textobjects berbasis AST — ini yang mengubah workflow editing
        -- Kamu bisa "target" bagian kode secara semantik:
        --   "daf" = delete around function (hapus seluruh fungsi termasuk signature)
        --   "cif" = change inner function (ganti isi fungsi, pertahankan signature)
        --   "yac" = yank around class
        --   "vic" = visual inner class
        textobjects = {
          select = {
            enable    = true,
            lookahead = true,    -- lompat ke textobject berikutnya kalau cursor tidak di atasnya
            keymaps   = {
              ["af"] = { query = "@function.outer", desc = "Around function" },
              ["if"] = { query = "@function.inner", desc = "Inner function" },
              ["ac"] = { query = "@class.outer",    desc = "Around class" },
              ["ic"] = { query = "@class.inner",    desc = "Inner class" },
              ["aa"] = { query = "@parameter.outer", desc = "Around argument" },
              ["ia"] = { query = "@parameter.inner", desc = "Inner argument" },
              ["ab"] = { query = "@block.outer",    desc = "Around block" },
              ["ib"] = { query = "@block.inner",    desc = "Inner block" },
            },
          },

          -- Pindah ke function/class berikutnya/sebelumnya
          -- Sangat berguna di file Go yang punya banyak function
          move = {
            enable              = true,
            set_jumps           = true,    -- catat di jumplist, bisa Ctrl-O untuk balik
            goto_next_start     = {
              ["]f"] = { query = "@function.outer", desc = "Next function" },
              ["]c"] = { query = "@class.outer",    desc = "Next class" },
            },
            goto_next_end       = {
              ["]F"] = { query = "@function.outer", desc = "Next function end" },
            },
            goto_previous_start = {
              ["[f"] = { query = "@function.outer", desc = "Prev function" },
              ["[c"] = { query = "@class.outer",    desc = "Prev class" },
            },
            goto_previous_end   = {
              ["[F"] = { query = "@function.outer", desc = "Prev function end" },
            },
          },

          -- Swap argument: berguna untuk reorder parameter fungsi
          -- Contoh: function foo(a, b) → cursor di "a" → <leader>sa → foo(b, a)
          swap = {
            enable   = true,
            swap_next = {
              ["<leader>sa"] = { query = "@parameter.inner", desc = "Swap argument next" },
            },
            swap_previous = {
              ["<leader>sA"] = { query = "@parameter.inner", desc = "Swap argument prev" },
            },
          },
        },
      })
    end,
  },

}