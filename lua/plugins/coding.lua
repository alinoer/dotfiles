return {
  -- Incremental rename
  {
    "smjonas/inc-rename.nvim",
    cmd = "IncRename",
    config = true,
  },

  -- Go forward/backward with square brackets
  {
    "nvim-mini/mini.bracketed",
    event = "BufReadPost",
    config = function()
      local bracketed = require("mini.bracketed")
      bracketed.setup({
        file = { suffix = "" },
        window = { suffix = "" },
        quickfix = { suffix = "" },
        yank = { suffix = "" },
        treesitter = { suffix = "n" },
      })
    end,
  },

  -- Better increase/descrease
  {
    "monaqa/dial.nvim",
    -- stylua: ignore
    keys = {
      { "<C-a>", function() return require("dial.map").inc_normal() end, expr = true, desc = "Increment" },
      { "<C-x>", function() return require("dial.map").dec_normal() end, expr = true, desc = "Decrement" },
    },
    config = function()
      local augend = require("dial.augend")
      require("dial.config").augends:register_group({
        default = {
          augend.integer.alias.decimal,
          augend.integer.alias.hex,
          augend.date.alias["%Y/%m/%d"],
          augend.constant.alias.bool,
          augend.semver.alias.semver,
          augend.constant.new({ elements = { "let", "const" } }),
        },
      })
    end,
  },

  -- copilot
  {
    "zbirenbaum/copilot.lua",
    opts = {
      suggestion = {
        auto_trigger = true,
        keymap = {
          accept = "<C-l>",
          accept_word = "<M-l>",
          accept_line = "<M-S-l>",
          next = "<M-]>",
          prev = "<M-[>",
          dismiss = "<C-]>",
        },
      },
      filetypes = {
        markdown = true,
        help = true,
      },
    },
  },

  -- commenting 
  {
    "echasnovski/mini.comment",
    event = "VeryLazy",
    opts = {
      options = {
        custom_commentstring = function()
          if vim.bo.filetype == "vue" then
            local line = vim.fn.getline(".")
            local cursor_line = vim.fn.line(".")
            
            -- Get all lines up to cursor to determine context
            local lines_above = vim.fn.getline(1, cursor_line)
            local in_script = false
            local in_template = false
            local in_style = false
            
            for _, line_content in ipairs(lines_above) do
              if line_content:match("<%s*script") then
                in_script = true
                in_template = false
                in_style = false
              elseif line_content:match("<%s*template") then
                in_template = true
                in_script = false
                in_style = false
              elseif line_content:match("<%s*style") then
                in_style = true
                in_script = false
                in_template = false
              elseif line_content:match("<%/%s*script%s*>") then
                in_script = false
              elseif line_content:match("<%/%s*template%s*>") then
                in_template = false
              elseif line_content:match("<%/%s*style%s*>") then
                in_style = false
              end
            end
            
            if in_script then
              return "// %s"
            elseif in_style then
              return "/* %s */"
            else
              return "<!-- %s -->"
            end
          end
          return nil
        end,
      },
    },
  },
}
