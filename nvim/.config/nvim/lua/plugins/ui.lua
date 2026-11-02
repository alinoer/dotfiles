-- UI plugins: colorscheme, statusline
return {
  -- Colorscheme
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    opts = {
      transparent_background = true,
      flavour = "mocha",
      show_end_of_buffer = false,
      styles = {
        comments = { "italic" },
        conditionals = { "italic" },
      },
      integrations = {
        gitsigns = true,
        treesitter = true,
      },
    },
    config = function(_, opts)
      require("catppuccin").setup(opts)
      vim.cmd.colorscheme("catppuccin")
    end,
  },

  -- Icons
  { "nvim-tree/nvim-web-devicons" },

  -- Statusline
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "VeryLazy",
    opts = {
      options = {
        theme = "auto",
        globalstatus = true,
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch" },
        lualine_c = {
          {
            "filetype",
            icon_only = true,
            separator = "",
            padding = { left = 1, right = 0 },
          },
          { "filename", path = 1, symbols = { modified = "  ", readonly = "", unnamed = "" } },
        },
        lualine_x = {
          {
            "diff",
            symbols = {
              added = " ",
              modified = " ",
              removed = " ",
            },
          },
        },
        lualine_y = {
          { "progress", separator = " ", padding = { left = 1, right = 0 } },
          { "location", padding = { left = 0, right = 1 } },
        },
        lualine_z = {
          function()
            return " " .. os.date("%R")
          end,
        },
      },
    },
  },

  -- Filename in top right
  {
    "b0o/incline.nvim",
    dependencies = { "catppuccin/nvim" },
    event = "BufReadPre",
    priority = 1200,
    config = function()
      local colors = require("catppuccin.palettes").get_palette("mocha")
      require("incline").setup({
        highlight = {
          groups = {
            InclineNormal = { guibg = colors.mauve, guifg = colors.base },
            InclineNormalNC = { guifg = colors.lavender, guibg = colors.surface0 },
          },
        },
        window = { margin = { vertical = 0, horizontal = 1 } },
        hide = { cursorline = true },
        render = function(props)
          local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
          if vim.bo[props.buf].modified then
            filename = "[+] " .. filename
          end
          local icon, color = require("nvim-web-devicons").get_icon_color(filename)
          return { { icon, guifg = color }, { " " }, { filename } }
        end,
      })
    end,
  },

  -- Smooth scrolling
  {
    "karb94/neoscroll.nvim",
    event = "VeryLazy",
    opts = {
      mappings = { "<C-u>", "<C-d>", "<C-b>", "<C-f>", "<C-y>", "<C-e>", "zt", "zz", "zb" },
      hide_cursor = true,
      stop_eof = true,
      respect_scrolloff = false,
      cursor_scrolls_alone = true,
      easing_function = "quadratic",
    },
  },

  -- Animated cursor
  {
    "sphamba/smear-cursor.nvim",
    event = "VeryLazy",
    opts = {},
    keys = {
      { "<leader>tsc", "<cmd>SmearCursorToggle<cr>", desc = "Toggle Animation Cursor" },
    },
  },

  -- Git signs
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      signs = {
        add = { text = "▎" },
        change = { text = "▎" },
        delete = { text = "" },
        topdelete = { text = "" },
        changedelete = { text = "▎" },
        untracked = { text = "▎" },
      },
    },
  },

  -- ─── Indent Visual ───────────────────────────────────────
  -- indent-blankline: garis indent — sangat membantu di Go & nested TS
  {
    "lukas-reineke/indent-blankline.nvim",
    event = { "BufReadPost", "BufNewFile" },
    main  = "ibl",
    opts  = {
      indent = {
        char      = "│",    -- karakter garis — lebih tipis dari default
        tab_char  = "│",
      },
      scope = {
        enabled    = true,
        show_start = false,  -- jangan tampilkan underline di awal scope
        show_end   = false,
      },
      exclude = {
        filetypes = { "lazy", "mason", "help", "dashboard" },
      },
    },
  },

  -- ─── Notifikasi ──────────────────────────────────────────
  -- nvim-notify: notifikasi LSP & plugin jadi lebih rapi, tidak ganggu flow
  {
    "rcarriga/nvim-notify",
    event = "VeryLazy",
    opts  = {
      timeout      = 5000,       -- 2 detik, tidak terlalu lama
      max_width    = 50,
      render       = "minimal",  -- tanpa border mewah
      stages       = "static",   -- tanpa animasi — lebih cepat
      top_down     = false,      -- notifikasi dari bawah ke atas
    },
    config = function(_, opts)
      local notify = require("notify")
      notify.setup(opts)
      vim.notify = notify   -- override vim.notify global
    end,
  },

  -- ─── Bufferline ─────────────────────────────────────────
  -- bufferline: tab yang lebih informatif, bisa langsung close dari tab
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    keys = {
      { "<S-l>",      "<cmd>BufferLineCycleNext<cr>",      desc = "Buffer berikutnya" },
      { "<S-h>",      "<cmd>BufferLineCyclePrev<cr>",      desc = "Buffer sebelumnya" },
      { "<leader>bp", "<cmd>BufferLineTogglePin<cr>",      desc = "Pin buffer" },
      { "<leader>bP", "<cmd>BufferLineGroupClose ungrouped<cr>", desc = "Tutup buffer tidak di-pin" },
      { "<leader>bo", "<cmd>BufferLineCloseOthers<cr>",   desc = "Tutup buffer lain" },
      { "<leader>br", "<cmd>BufferLineCloseRight<cr>",    desc = "Tutup buffer kanan" },
      { "<leader>bl", "<cmd>BufferLineCloseLeft<cr>",     desc = "Tutup buffer kiri" },
    },
    opts = {
      options = {
        diagnostics = "nvim_lsp",
        diagnostics_indicator = function(_, _, diag)
          local icons = { error = " ", warning = " " }
          local ret = (diag.error and icons.error .. diag.error .. " " or "")
            .. (diag.warning and icons.warning .. diag.warning or "")
          return vim.trim(ret)
        end,

        show_buffer_close_icons = true,
        show_close_icon         = false,
        separator_style         = "thin",   -- ganti dari "slant" ke "thin"
        always_show_bufferline  = true,

        -- Hapus icon filetype kalau mau lebih minimal
        show_buffer_icons = false,

        sort_by = "insert_after_current",
      },
    },
  },
}
