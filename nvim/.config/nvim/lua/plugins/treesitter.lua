-- Treesitter (branch `main`, butuh Neovim 0.12+ dan `tree-sitter` CLI)
--
-- Branch `main` tidak lagi punya `require("nvim-treesitter.configs").setup()`.
-- Highlight dinyalakan lewat `vim.treesitter.start()` per FileType,
-- dan textobjects dipasang manual dengan keymap.
--
-- Incremental selection sekarang bawaan Neovim 0.12:
--   v lalu `an` = perluas ke node induk, `in` = perkecil lagi

local parsers = {
  "typescript", "tsx", "javascript",
  "go", "gomod", "gosum",
  "lua", "luadoc",
  "json", "yaml", "toml",
  "markdown", "markdown_inline",
  "bash", "html", "css", "regex",
  "vim", "vimdoc",
}

return {

  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy   = false,          -- plugin ini tidak mendukung lazy-loading
    build  = ":TSUpdate",
    config = function()
      -- Install parser yang belum ada (async, no-op kalau sudah terpasang)
      require("nvim-treesitter").install(parsers)

      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("treesitter_start", { clear = true }),
        callback = function(args)
          local lang = vim.treesitter.language.get_lang(args.match)
          if not lang or not pcall(vim.treesitter.start, args.buf, lang) then
            return
          end
          -- Indentasi berbasis treesitter
          vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end,
      })
    end,
  },

  -- Textobjects berbasis AST:
  --   daf = hapus seluruh function, cif = ganti isi function
  --   ]f / [f = function berikutnya/sebelumnya, ]c / [c = class
  --   <leader>sa / <leader>sA = tukar argumen
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    event  = { "BufReadPost", "BufNewFile" },
    config = function()
      require("nvim-treesitter-textobjects").setup({
        select = { lookahead = true },
        move   = { set_jumps = true },
      })

      local select = require("nvim-treesitter-textobjects.select")
      local move   = require("nvim-treesitter-textobjects.move")
      local swap   = require("nvim-treesitter-textobjects.swap")
      local map    = vim.keymap.set

      local objects = {
        f = { "@function", "function" },
        c = { "@class",    "class" },
        a = { "@parameter", "argument" },
        b = { "@block",    "block" },
      }
      for key, o in pairs(objects) do
        map({ "x", "o" }, "a" .. key, function()
          select.select_textobject(o[1] .. ".outer", "textobjects")
        end, { desc = "Around " .. o[2] })
        map({ "x", "o" }, "i" .. key, function()
          select.select_textobject(o[1] .. ".inner", "textobjects")
        end, { desc = "Inner " .. o[2] })
      end

      local nxo = { "n", "x", "o" }
      map(nxo, "]f", function() move.goto_next_start("@function.outer", "textobjects") end,     { desc = "Next function" })
      map(nxo, "[f", function() move.goto_previous_start("@function.outer", "textobjects") end, { desc = "Prev function" })
      map(nxo, "]F", function() move.goto_next_end("@function.outer", "textobjects") end,       { desc = "Next function end" })
      map(nxo, "[F", function() move.goto_previous_end("@function.outer", "textobjects") end,   { desc = "Prev function end" })
      map(nxo, "]c", function() move.goto_next_start("@class.outer", "textobjects") end,        { desc = "Next class" })
      map(nxo, "[c", function() move.goto_previous_start("@class.outer", "textobjects") end,    { desc = "Prev class" })

      map("n", "<leader>sa", function() swap.swap_next("@parameter.inner") end,     { desc = "Swap argument next" })
      map("n", "<leader>sA", function() swap.swap_previous("@parameter.inner") end, { desc = "Swap argument prev" })
    end,
  },

}
