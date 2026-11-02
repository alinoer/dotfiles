return {

  -- ─── toggleterm.nvim ──────────────────────────────────────
  -- Terminal terintegrasi yang bisa toggle on/off dengan hotkey.
  -- Bisa buka multiple terminal, floating window, atau di split.
  -- Sangat berguna untuk workflow development tanpa keluar dari Neovim.
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    cmd = { "ToggleTerm", "TermExec" },
    keys = {
      { "<leader>tf", "<cmd>ToggleTerm direction=float<cr>", desc = "Float Terminal" },
      { "<leader>th", "<cmd>ToggleTerm direction=horizontal<cr>", desc = "Horizontal Terminal" },
      { "<leader>tv", "<cmd>ToggleTerm direction=vertical size=80<cr>", desc = "Vertical Terminal" },
      { "<C-\\>", "<cmd>ToggleTerm direction=vertical<cr>", desc = "Toggle Terminal" },
      { 
        "<leader>gg", 
        function()
          local Terminal = require("toggleterm.terminal").Terminal
          local lazygit = Terminal:new({
            cmd = "lazygit",
            hidden = true,
            direction = "float",
            float_opts = {
              border = "curved",
              width = function() 
                local width = math.floor(vim.o.columns * 0.85)
                return width
              end,
              height = function() 
                local height = math.floor(vim.o.lines * 0.85)
                return height
              end,
              row = function() 
                local height = math.floor(vim.o.lines * 0.85)
                return math.floor((vim.o.lines - height) / 2) - 1
              end,
              col = function() 
                local width = math.floor(vim.o.columns * 0.85)
                return math.floor((vim.o.columns - width) / 2)
              end,
            },
            on_open = function(term)
              vim.cmd("startinsert!")
              local opts = { buffer = term.bufnr, noremap = true, silent = true }
              -- Close lazygit dengan q dari terminal mode
              vim.keymap.set("t", "q", [[<Cmd>close<CR>]], opts)
              -- Close lazygit dengan Ctrl+\ dari terminal mode  
              vim.keymap.set("t", "<C-\\>", function() term:close() end, opts)
            end,
            on_close = function()
              vim.cmd("startinsert!")
            end,
          })
          lazygit:toggle()
        end,
        desc = "Lazygit"
      },
    },
    config = function()
      require("toggleterm").setup({
        -- Terminal window size
        size = function(term)
          if term.direction == "horizontal" then
            return 15
          elseif term.direction == "vertical" then
            return math.floor(vim.o.columns * 0.4)
          end
        end,

        -- Default opening direction: horizontal, vertical, float, tab
        direction = "vertical",
        
        -- Auto close terminal ketika process selesai
        close_on_exit = true,
        
        -- Shell yang digunakan (default: $SHELL atau powershell di Windows)
        shell = vim.o.shell,
        
        -- Auto insert mode ketika buka terminal
        start_in_insert = true,
        
        -- Persist ukuran terminal
        persist_size = true,
        
        -- Auto scroll ke bawah ketika ada output baru
        auto_scroll = true,

        -- Floating terminal configuration
        float_opts = {
          -- Border style: single, double, shadow, curved, etc.
          border = "curved",
          
          -- Ukuran floating window (0.0 - 1.0)
          width = function()
            return math.floor(vim.o.columns * 0.8)
          end,
          height = function()
            return math.floor(vim.o.lines * 0.8)
          end,
          
          -- Posisi window
          row = function()
            return math.floor(vim.o.lines * 0.1)
          end,
          col = function()
            return math.floor(vim.o.columns * 0.1)
          end,
          
          -- Transparency
          winblend = 0,
          
          -- Highlight groups
          highlights = {
            border = "Normal",
            background = "Normal",
          },
        },

        -- Keymaps yang aktif di dalam terminal
        on_create = function(term)
          local opts = { buffer = term.bufnr, noremap = true, silent = true }
          
          -- Keluar dari terminal mode dengan Esc
          vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], opts)
          
          -- Toggle terminal dari insert mode dengan Ctrl+\
          vim.keymap.set("t", "<C-\\>", [[<Cmd>ToggleTerm<CR>]], opts)
          
          -- Navigate window dengan Ctrl+hjkl dari terminal mode
          vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], opts)
          vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], opts)
          vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], opts)
          vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], opts)
        end,

        -- Highlight group untuk terminal
        highlights = {
          Normal = { link = "Normal" },
          NormalFloat = { link = "NormalFloat" },
          FloatBorder = { link = "FloatBorder" },
        },
      })

      -- Simple terminal commands using TermExec
      vim.keymap.set("n", "<leader>tt", function()
        if vim.fn.executable("htop") == 1 then
          vim.cmd("TermExec cmd='htop' direction=float")
        else
          vim.notify("Htop tidak terinstall. Install dengan: brew install htop", vim.log.levels.WARN)
        end
      end, { desc = "Htop" })
      
      vim.keymap.set("n", "<leader>tn", function()
        if vim.fn.executable("node") == 1 then
          vim.cmd("TermExec cmd='node' direction=float")
        else
          vim.notify("Node.js tidak terinstall. Install dengan: brew install node", vim.log.levels.WARN)
        end
      end, { desc = "Node REPL" })
      
      vim.keymap.set("n", "<leader>tp", function()
        if vim.fn.executable("python3") == 1 then
          vim.cmd("TermExec cmd='python3' direction=float")
        else
          vim.notify("Python3 tidak terinstall. Install dengan: brew install python", vim.log.levels.WARN)
        end
      end, { desc = "Python REPL" })
    end,
  },

}