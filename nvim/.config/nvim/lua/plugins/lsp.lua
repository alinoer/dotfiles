-- LSP configuration: mason, lspconfig, cmp
return {

  -- ─── Mason: LSP Package Manager ──────────────────────────
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    keys = { { "<leader>lm", "<cmd>Mason<cr>", desc = "Mason" } },
    opts = {
      ui = {
        border = "rounded",
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    },
  },

  -- ─── Mason-lspconfig: install server via Mason ─────────
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      ensure_installed = { "ts_ls", "gopls", "eslint", "lua_ls" },
      -- Server yang terinstall via Mason otomatis di-enable (vim.lsp.enable)
      automatic_enable = true,
    },
  },

  -- ─── LSP (API bawaan Neovim 0.11+: vim.lsp.config / vim.lsp.enable) ──
  -- nvim-lspconfig hanya menyediakan config default tiap server (folder lsp/).
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      { "j-hui/fidget.nvim", opts = {} },
    },
    config = function()
      vim.lsp.log.set_level(vim.log.levels.ERROR)

      -- Diagnostic
      vim.diagnostic.config({
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = "",
            [vim.diagnostic.severity.WARN]  = "",
            [vim.diagnostic.severity.HINT]  = "",
            [vim.diagnostic.severity.INFO]  = "",
          },
        },
        virtual_text     = { prefix = "●", source = "if_many" },
        float            = { border = "rounded", source = true, header = "", prefix = "" },
        underline        = true,
        update_in_insert = false,
        severity_sort    = true,
      })

      -- Config untuk semua server
      vim.lsp.config("*", {
        capabilities = require("cmp_nvim_lsp").default_capabilities(),
      })

      -- Config khusus per server
      vim.lsp.config("lua_ls", {
        settings = {
          Lua = {
            runtime     = { version = "LuaJIT" },
            workspace   = { checkThirdParty = false, library = { vim.env.VIMRUNTIME } },
            diagnostics = { globals = { "vim" } },
            telemetry   = { enable = false },
          },
        },
      })

      vim.lsp.enable({ "ts_ls", "gopls", "eslint", "lua_ls" })

      -- Keymap & perilaku saat LSP attach ke buffer
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("lsp_attach", { clear = true }),
        callback = function(args)
          local bufnr  = args.buf
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if not client then return end

          -- Matikan semantic tokens (lebih ringan, warna tetap dari treesitter)
          client.server_capabilities.semanticTokensProvider = nil

          local map = function(keys, func, desc)
            vim.keymap.set("n", keys, func, { buffer = bufnr, desc = "LSP: " .. desc })
          end

          -- Navigasi
          map("gd", vim.lsp.buf.definition,      "Go to definition")
          map("gD", vim.lsp.buf.declaration,     "Go to declaration")
          map("gi", vim.lsp.buf.implementation,  "Go to implementation")
          map("gr", vim.lsp.buf.references,      "References")
          map("gt", vim.lsp.buf.type_definition, "Type definition")

          -- Info (signature help di insert mode: <C-s>, bawaan Neovim)
          map("K",  vim.lsp.buf.hover,          "Hover docs")
          map("gK", vim.lsp.buf.signature_help, "Signature help")

          -- Aksi
          map("<leader>lr", vim.lsp.buf.rename,      "Rename")
          map("<leader>la", vim.lsp.buf.code_action, "Code action")
          map("<leader>lf", function() vim.lsp.buf.format({ async = true }) end, "Format")

          -- Diagnostic ([d / ]d sudah bawaan Neovim)
          map("<leader>ld", vim.diagnostic.open_float, "Line diagnostics")

          -- ESLint: fix otomatis saat save
          if client.name == "eslint" then
            vim.api.nvim_create_autocmd("BufWritePre", {
              buffer  = bufnr,
              command = "silent! LspEslintFixAll",
            })
          end
        end,
      })
    end,
  },

  -- ─── Autocompletion ─────────────────────────────────────
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      {
        "L3MON4D3/LuaSnip",
        version = "v2.*",
        build = "make install_jsregexp",
        dependencies = {
          "rafamadriz/friendly-snippets",
        },
        config = function()
          require("luasnip.loaders.from_vscode").lazy_load()
        end,
      },
      "saadparwaiz1/cmp_luasnip",
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        formatting = {
          format = function(entry, item)
            local source_labels = {
              nvim_lsp = "[LSP]",
              luasnip = "[Snip]",
              buffer = "[Buf]",
              path = "[Path]",
            }
            item.menu = source_labels[entry.source.name] or ""
            return item
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-j>"] = cmp.mapping.select_next_item(),
          ["<C-k>"] = cmp.mapping.select_prev_item(),
          ["<C-d>"] = cmp.mapping.scroll_docs(4),
          ["<C-u>"] = cmp.mapping.scroll_docs(-4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
            select = false,
          }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if luasnip.expand_or_locally_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if luasnip.locally_jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp", max_item_count = 20 },
          { name = "luasnip", max_item_count = 10 },
          { name = "path" },
        }, {
          { name = "buffer", max_item_count = 5 },
        }),
        preselect = cmp.PreselectMode.None,
        experimental = {
          ghost_text = true,
        },
      })
    end,
  },
}