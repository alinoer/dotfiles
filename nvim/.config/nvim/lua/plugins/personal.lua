-- Plugin & override pribadi di atas LazyVim
return {

  -- Colorscheme: catppuccin mocha (background penuh, bukan transparan)
  {
    "catppuccin/nvim",
    name = "catppuccin",
    opts = {
      flavour = "mocha",
      transparent_background = false,
    },
  },
  {
    "LazyVim/LazyVim",
    opts = { colorscheme = "catppuccin-mocha" },
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
  -- Terminal: default vertikal (kanan), tetap bisa horizontal (bawah)
  -- Posisi hanya diatur di tombol ini, supaya lazygit dkk. tetap float.
  --   Ctrl-/       buka/fokus terminal vertikal di root project
  --   <leader>ft   terminal vertikal (root project), <leader>fT (cwd)
  --   <leader>fv   toggle terminal vertikal
  --   <leader>fh   toggle terminal horizontal (terminal terpisah)
  {
    "folke/snacks.nvim",
    keys = function(_, keys)
      local right = { position = "right", width = 0.4 }
      local bottom = { position = "bottom", height = 0.3 }
      local function vfocus()
        Snacks.terminal.focus(nil, { cwd = LazyVim.root(), win = right })
      end
      vim.list_extend(keys, {
        { "<c-/>", vfocus, mode = { "n", "t" }, desc = "Terminal vertikal" },
        { "<c-_>", vfocus, mode = { "n", "t" }, desc = "which_key_ignore" },
        { "<leader>ft", vfocus, desc = "Terminal vertikal (root)" },
        {
          "<leader>fT",
          function() Snacks.terminal.focus(nil, { win = right }) end,
          desc = "Terminal vertikal (cwd)",
        },
        {
          "<leader>fv",
          function() Snacks.terminal.toggle(nil, { cwd = LazyVim.root(), win = right }) end,
          desc = "Toggle terminal vertikal",
        },
        {
          "<leader>fh",
          function() Snacks.terminal.toggle(nil, { cwd = LazyVim.root(), count = 2, win = bottom }) end,
          desc = "Toggle terminal horizontal",
        },
      })
      return keys
    end,
  },
}
