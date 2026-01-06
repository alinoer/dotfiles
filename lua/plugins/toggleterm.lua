return {
  "akinsho/toggleterm.nvim",
  version = "*",
  config = function()
    require("toggleterm").setup({
      size = 12,
      open_mapping = "<C-t>",
      hide_numbers = true,
      shade_filetypes = {},
      shade_terminals = true,
      shading_factor = 2,
      start_in_insert = true,
      insert_mappings = true,
      terminal_mappings = true,
      persist_size = true,
      direction = "horizontal",
      close_on_exit = true,
      shell = vim.o.shell,
      float_opts = {
        border = "curved",
        winblend = 0,
        highlights = {
          border = "Normal",
          background = "Normal",
        },
      },
    })

    local Terminal = require("toggleterm.terminal").Terminal

    -- Horizontal terminal
    local horizontal_term = Terminal:new({
      direction = "horizontal",
      count = 1,
    })

    -- Vertical terminal
    local vertical_term = Terminal:new({
      direction = "vertical",
      count = 2,
    })

    -- Floating terminal
    local floating_term = Terminal:new({
      direction = "float",
      count = 3,
    })

    function _HORIZONTAL_TOGGLE()
      horizontal_term:toggle(12)
    end

    function _VERTICAL_TOGGLE()
      vertical_term:toggle(vim.o.columns * 0.4)
    end

    function _FLOATING_TOGGLE()
      floating_term:toggle()
    end

    -- Keymaps
    local opts = { noremap = true, silent = true }
    vim.keymap.set("n", "<leader>th", "<cmd>lua _HORIZONTAL_TOGGLE()<CR>", opts)
    vim.keymap.set("n", "<leader>tv", "<cmd>lua _VERTICAL_TOGGLE()<CR>", opts)
    vim.keymap.set("n", "<leader>tf", "<cmd>lua _FLOATING_TOGGLE()<CR>", opts)
    vim.keymap.set("n", "<leader>tt", "<cmd>ToggleTerm<CR>", opts)

    -- Terminal mode escape
    vim.keymap.set("t", "<esc>", [[<C-\><C-n>]], opts)
    vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], opts)
    vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], opts)
    vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], opts)
    vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], opts)
  end,
}