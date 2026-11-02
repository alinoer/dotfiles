return {

  -- ─── Telescope ───────────────────────────────────────────
  -- Fuzzy finder utama — prioritas #4 kamu tapi dipakai sangat sering
  {
    "nvim-telescope/telescope.nvim",
    cmd  = "Telescope",           -- load hanya saat command dipanggil
    keys = {                      -- atau saat salah satu keymap ditekan
      { "<leader>ff", "<cmd>Telescope find_files<cr>",              desc = "Find files" },
      { "<leader>fg",       "<cmd>Telescope live_grep<cr>",               desc = "Live grep" },
      { "<leader>?",       "<cmd>Telescope oldfiles<cr>",                desc = "Recent files" },
      { "<leader>fb",      "<cmd>Telescope buffers<cr>",                 desc = "Buffers" },
      { "<leader>sh",      "<cmd>Telescope help_tags<cr>",               desc = "Help" },
      { "<leader>sk",      "<cmd>Telescope keymaps<cr>",                 desc = "Keymaps" },
      { "<leader>sd",      "<cmd>Telescope diagnostics<cr>",             desc = "Diagnostics" },
      { "<leader>sr",      "<cmd>Telescope lsp_references<cr>",          desc = "References" },
      { "<leader>ss",      "<cmd>Telescope lsp_document_symbols<cr>",    desc = "Symbols" },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      -- telescope-fzf-native: performa pencarian jauh lebih cepat
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",   -- perlu gcc/make — pastikan sudah terinstall
        cond  = function()
          return vim.fn.executable("make") == 1
        end,
      },
    },
    opts = function()
      local actions = require("telescope.actions")
      return {
        defaults = {
          prompt_prefix   = "   ",
          selection_caret = "  ",
          -- Sorting: smart > fuzzy > exact — optimal untuk codebase besar
          file_sorter     = require("telescope.sorters").get_fzf_sorter,
          generic_sorter  = require("telescope.sorters").get_fzf_sorter,
          mappings = {
            i = {
              ["<C-j>"]  = actions.move_selection_next,
              ["<C-k>"]  = actions.move_selection_previous,
              ["<C-q>"]  = actions.send_to_qflist + actions.open_qflist,
              ["<Esc>"]  = actions.close,
            },
          },
          -- Ignore file yang tidak relevan saat find_files
          file_ignore_patterns = {
            "node_modules", "%.git/", "dist/", "build/",
            "%.next/", "%.nuxt/",
          },
          layout_config = {
            prompt_position = "top",
            width           = 0.87,
            height          = 0.80,
          },
          sorting_strategy = "ascending",
        },
        pickers = {
          find_files = {
            hidden = true,    -- tampilkan dotfiles (penting untuk config files)
          },
          live_grep = {
            additional_args = { "--hidden" },
          },
        },
      }
    end,
    config = function(_, opts)
      local telescope = require("telescope")
      telescope.setup(opts)
      -- Load fzf extension untuk performa optimal
      pcall(telescope.load_extension, "fzf")
    end,
  },

  -- ─── Oil.nvim — File Manager ─────────────────────────────
  -- Edit filesystem seperti edit buffer biasa — paradigma berbeda dari neotree
  -- Keunggulan: rename massal, move file dengan dd/p, sangat cepat
  {
    "stevearc/oil.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    cmd = "Oil",
    keys = {
      { "<leader>o", "<cmd>Oil<cr>", desc = "Open Oil" },
      { "-", "<cmd>Oil<cr>", desc = "Open parent directory" },
    },
    config = function()
      require("oil").setup({
        default_file_explorer = true,
        columns = {
          "icon",
        },
        buf_options = {
          buflisted = false,
          bufhidden = "hide",
        },
        win_options = {
          wrap = false,
          signcolumn = "no",
          cursorcolumn = false,
          foldcolumn = "0",
          spell = false,
          list = false,
          conceallevel = 3,
          concealcursor = "nvic",
        },
        delete_to_trash = true,
        skip_confirm_for_simple_edits = false,
        prompt_save_on_select_new_entry = true,
        cleanup_delay_ms = 2000,
        lsp_file_methods = {
          timeout_ms = 1000,
          autosave_changes = false,
        },
        constrain_cursor = "editable",
        keymaps = {
          ["g?"] = "actions.show_help",
          ["<CR>"] = "actions.select",
          ["<C-s>"] = "actions.select_vsplit",
          ["<C-h>"] = "actions.select_split",
          ["<C-t>"] = "actions.select_tab",
          ["<C-p>"] = "actions.preview",
          ["<C-c>"] = "actions.close",
          ["<C-l>"] = "actions.refresh",
          ["-"] = "actions.parent",
          ["_"] = "actions.open_cwd",
          ["`"] = "actions.cd",
          ["~"] = "actions.tcd",
          ["gs"] = "actions.change_sort",
          ["gx"] = "actions.open_external",
          ["g."] = "actions.toggle_hidden",
          ["g\\"] = "actions.toggle_trash",
          ["q"] = "actions.close",
        },
        use_default_keymaps = true,
        view_options = {
          show_hidden = false,
          is_hidden_file = function(name, bufnr)
            return vim.startswith(name, ".")
          end,
          is_always_hidden = function(name, bufnr)
            return false
          end,
          natural_order = true,
          sort = {
            { "type", "asc" },
            { "name", "asc" },
          },
        },
        float = {
          padding = 2,
          max_width = 0.8,
          max_height = 0.8,
          border = "rounded",
          win_options = {
            winblend = 0,
          },
        },
        preview = {
          max_width = 0.9,
          min_width = { 40, 0.4 },
          max_height = 0.9,
          min_height = { 5, 0.1 },
          border = "rounded",
          win_options = {
            winblend = 0,
          },
        },
      })
    end,
  },

  -- ─── Which-key ───────────────────────────────────────────
  -- Tampilkan keymaps yang tersedia — sangat membantu saat lupa shortcut
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts  = {
      delay  = 500,      -- muncul setelah 500ms diam
      preset = "classic",
      spec   = {
        -- Daftarkan grup leader key supaya rapi di which-key
        { "<leader>b",  group = "buffer" },
        { "<leader>f",  group = "find" },
        { "<leader>s",  group = "search" },
        { "<leader>g",  group = "git" },
        { "<leader>gt", group = "git toggle" },
        { "<leader>l",  group = "lsp" },
        { "<leader>q",  group = "quit/quickfix" },
        { "<leader>t",  group = "terminal" },
        { "<leader>w",  group = "window" },
      },
    },
  },

  -- ─── vim-tmux-navigator ──────────────────────────────────
  -- <C-h/j/k/l> pindah antar split nvim DAN pane tmux tanpa prefix.
  -- Pasangannya ada di tmux.conf (plugin dengan nama yang sama).
  {
    "christoomey/vim-tmux-navigator",
    cmd = {
      "TmuxNavigateLeft", "TmuxNavigateDown", "TmuxNavigateUp",
      "TmuxNavigateRight", "TmuxNavigatePrevious",
    },
    keys = {
      { "<C-h>", "<cmd>TmuxNavigateLeft<cr>",  desc = "Window/pane kiri" },
      { "<C-j>", "<cmd>TmuxNavigateDown<cr>",  desc = "Window/pane bawah" },
      { "<C-k>", "<cmd>TmuxNavigateUp<cr>",    desc = "Window/pane atas" },
      { "<C-l>", "<cmd>TmuxNavigateRight<cr>", desc = "Window/pane kanan" },
    },
    init = function()
      vim.g.tmux_navigator_no_wrap = 1
    end,
  },

}