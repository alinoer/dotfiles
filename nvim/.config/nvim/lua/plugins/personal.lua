-- Plugin & override pribadi di atas LazyVim
return {

  -- Colorscheme: catppuccin mocha, background transparan
  {
    "catppuccin/nvim",
    name = "catppuccin",
    opts = {
      flavour = "mocha",
      transparent_background = true,
    },
  },
  {
    "LazyVim/LazyVim",
    opts = { colorscheme = "catppuccin" },
  },

  -- Ctrl-h/j/k/l pindah mulus antara split nvim dan pane tmux
  -- (pasangannya ada di tmux.conf)
  {
    "christoomey/vim-tmux-navigator",
    cmd = {
      "TmuxNavigateLeft", "TmuxNavigateDown", "TmuxNavigateUp",
      "TmuxNavigateRight", "TmuxNavigatePrevious",
    },
    keys = {
      { "<C-h>", "<cmd>TmuxNavigateLeft<cr>", desc = "Window/pane kiri" },
      { "<C-j>", "<cmd>TmuxNavigateDown<cr>", desc = "Window/pane bawah" },
      { "<C-k>", "<cmd>TmuxNavigateUp<cr>", desc = "Window/pane atas" },
      { "<C-l>", "<cmd>TmuxNavigateRight<cr>", desc = "Window/pane kanan" },
    },
    init = function()
      vim.g.tmux_navigator_no_wrap = 1
    end,
  },

  -- Oil: edit folder seperti buffer teks. Buka dengan "-"
  {
    "stevearc/oil.nvim",
    dependencies = { "nvim-mini/mini.icons" },
    cmd = "Oil",
    keys = {
      { "-", "<cmd>Oil<cr>", desc = "Oil: buka folder file ini" },
    },
    opts = {
      delete_to_trash = true,
      skip_confirm_for_simple_edits = false,
      view_options = { show_hidden = false, natural_order = true },
    },
  },
}
