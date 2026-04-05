return {

  -- ─── mini.pairs ───────────────────────────────────────────
  -- Auto-close bracket, quote, dsb.
  -- Kenapa mini.pairs bukan nvim-autopairs?
  -- mini.pairs jauh lebih ringan (~100 baris vs ~1500 baris),
  -- tidak butuh treesitter integration untuk kerja benar,
  -- dan lebih predictable — tidak ada "magic" yang tiba-tiba.
  {
    "echasnovski/mini.pairs",
    version = false,
    event   = "InsertEnter",
    opts    = {
      -- Pasangan yang di-auto-close
      -- Setiap pasangan: { open, close }
      mappings = {
        ["("]  = { action = "open",  pair = "()", neigh_pattern = "[^\\]." },
        ["["]  = { action = "open",  pair = "[]", neigh_pattern = "[^\\]." },
        ["{"]  = { action = "open",  pair = "{}", neigh_pattern = "[^\\]." },
        [")"]  = { action = "close", pair = "()" },
        ["]"]  = { action = "close", pair = "[]" },
        ["}"]  = { action = "close", pair = "{}" },
        ['"']  = { action = "closeopen", pair = '""',
                   neigh_pattern = "[^\\].",
                   register = { cr = false } },
        ["'"]  = { action = "closeopen", pair = "''",
                   neigh_pattern = "[^%a\\].",
                   register = { cr = false } },
        ["`"]  = { action = "closeopen", pair = "``",
                   neigh_pattern = "[^\\].",
                   register = { cr = false } },
      },
    },
  },

  -- ─── mini.surround ────────────────────────────────────────
  -- Operasi "surrounding" — tambah/hapus/ganti karakter pembungkus.
  -- Ini menggantikan vim-surround dengan implementasi yang lebih modern
  -- dan konsisten dengan keymaps Neovim native.
  --
  -- Contoh penggunaan:
  --   saiw"    → surround add inner word dengan "  : hello → "hello"
  --   sd"      → surround delete "               : "hello" → hello
  --   sr"'     → surround replace " dengan '     : "hello" → 'hello'
  --   saif"    → surround add inner function dengan "
  {
    "echasnovski/mini.surround",
    version = false,
    keys    = { "sa", "sd", "sr", "sf", "sF", "sh", "sn" },
    opts    = {
      mappings = {
        add            = "sa",    -- add surrounding
        delete         = "sd",    -- delete surrounding
        find           = "sf",    -- find surrounding (kanan)
        find_left      = "sF",    -- find surrounding (kiri)
        highlight      = "sh",    -- highlight surrounding
        replace        = "sr",    -- replace surrounding
        update_n_lines = "sn",    -- update n_lines untuk search
      },
      -- Jumlah baris yang di-scan untuk mencari surrounding
      -- Default 20 cukup untuk kebanyakan kasus
      n_lines = 20,
    },
  },

  -- ─── mini.comment ─────────────────────────────────────────
  -- Toggle comment dengan gcc (baris) atau gc (visual/motion).
  -- Mendukung semua bahasa via treesitter — tahu comment syntax
  -- tiap bahasa secara otomatis (// untuk JS/Go, -- untuk Lua, # untuk Python).
  --
  -- Contoh:
  --   gcc       → toggle comment baris saat ini
  --   gc3j      → comment 3 baris ke bawah
  --   gcaf      → comment around function (butuh treesitter textobjects)
  --   (visual) gc → comment selection
  {
    "echasnovski/mini.comment",
    version = false,
    keys    = {
      { "gc",  mode = { "n", "v" } },
      { "gcc", mode = "n" },
    },
    opts = {
      -- Hook untuk integrasi dengan treesitter
      -- Ini yang membuat comment syntax otomatis tepat per bahasa
      options = {
        custom_commentstring = function()
          return require("ts_context_commentstring.internal").calculate_commentstring()
                 or vim.bo.commentstring
        end,
      },
    },
    dependencies = {
      -- ts_context_commentstring: deteksi bahasa dari context treesitter
      -- Berguna untuk file mixed-language: .tsx (JSX di dalam TS),
      -- template HTML dengan script JS di dalamnya
      {
        "JoosepAlviste/nvim-ts-context-commentstring",
        opts = { enable_autocmd = false },
      },
    },
  },

  -- ─── gitsigns.nvim ────────────────────────────────────────
  -- Tampilkan perubahan git langsung di sign column (kolom kiri).
  -- Plus operasi git per-hunk (potongan perubahan) tanpa keluar Neovim.
  --
  -- Yang kamu lihat di sign column:
  --   │  (baris biru)  → baris dimodifikasi
  --   +  (tanda hijau) → baris baru ditambahkan
  --   ‾  (tanda merah) → baris dihapus
  --
  -- Operasi per-hunk sangat berguna: bisa stage, reset, atau preview
  -- perubahan satu blok tanpa harus stage seluruh file
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts  = {
      signs = {
        add          = { text = "▎" },
        change       = { text = "▎" },
        delete       = { text = "" },
        topdelete    = { text = "" },
        changedelete = { text = "▎" },
        untracked    = { text = "▎" },
      },
      -- Preview hunk inline (bukan split window)
      preview_config = {
        border = "rounded",
      },
      on_attach = function(bufnr)
        local gs  = package.loaded.gitsigns
        local map = function(mode, keys, func, desc)
          vim.keymap.set(mode, keys, func,
            { buffer = bufnr, desc = "Git: " .. desc })
        end

        -- Navigasi antar hunk
        -- Hunk = blok perubahan yang bersebelahan
        map("n", "]h", function()
          if vim.wo.diff then return "]h" end
          vim.schedule(function() gs.next_hunk() end)
          return "<Ignore>"
        end, "Next hunk")

        map("n", "[h", function()
          if vim.wo.diff then return "[h" end
          vim.schedule(function() gs.prev_hunk() end)
          return "<Ignore>"
        end, "Prev hunk")

        -- Stage & reset per hunk
        -- Stage hunk = tambahkan perubahan ini ke git index (staging area)
        -- tanpa harus `git add` seluruh file
        map("n", "<leader>gs", gs.stage_hunk,   "Stage hunk")
        map("n", "<leader>gr", gs.reset_hunk,   "Reset hunk")
        map("v", "<leader>gs", function()
          gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end, "Stage hunk (visual)")
        map("v", "<leader>gr", function()
          gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end, "Reset hunk (visual)")

        -- Stage/reset seluruh buffer
        map("n", "<leader>gS", gs.stage_buffer,  "Stage buffer")
        map("n", "<leader>gR", gs.reset_buffer,  "Reset buffer")

        -- Preview & blame
        -- preview_hunk: lihat diff inline sebelum stage
        -- blame_line: lihat siapa yang menulis baris ini dan kapan
        map("n", "<leader>gp", gs.preview_hunk,  "Preview hunk")
        map("n", "<leader>gb", function()
          gs.blame_line({ full = true })
        end, "Blame line")

        -- Toggle
        map("n", "<leader>gtb", gs.toggle_current_line_blame, "Toggle blame")
        map("n", "<leader>gtd", gs.toggle_deleted,            "Toggle deleted")

        -- Text object: "ih" = inner hunk
        -- Contoh: "vih" = visual select perubahan saat ini
        --         "dih" = hapus perubahan saat ini (sama dengan reset)
        map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "Select hunk")
      end,
    },
  },

  -- ─── todo-comments ────────────────────────────────────────
  -- Highlight dan navigasi TODO/FIXME/HACK/NOTE di codebase.
  -- Berguna untuk codebase besar — tidak ada lagi TODO yang terlupakan.
  --
  -- Keyword yang dikenali:
  --   TODO  → biru   (sesuatu yang perlu dikerjakan)
  --   FIXME → merah  (bug yang diketahui)
  --   HACK  → kuning (solusi sementara)
  --   NOTE  → hijau  (informasi penting)
  --   WARN  → oranye (peringatan)
  {
    "folke/todo-comments.nvim",
    event        = { "BufReadPost", "BufNewFile" },
    dependencies = { "nvim-lua/plenary.nvim" },
    keys         = {
      { "]t",          function() require("todo-comments").jump_next() end, desc = "Next TODO" },
      { "[t",          function() require("todo-comments").jump_prev() end, desc = "Prev TODO" },
      { "<leader>st",  "<cmd>TodoTelescope<cr>",                            desc = "Search TODOs" },
    },
    opts = {
      signs     = true,
      keywords  = {
        FIX  = { icon = " ", color = "error",   alt = { "FIXME", "BUG", "FIXIT", "ISSUE" } },
        TODO = { icon = " ", color = "info" },
        HACK = { icon = " ", color = "warning" },
        WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
        NOTE = { icon = " ", color = "hint",    alt = { "INFO" } },
      },
    },
  },

}