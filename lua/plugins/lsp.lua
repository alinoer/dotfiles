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

  -- ─── Mason-lspconfig: Bridge Mason ↔ lspconfig ─────────
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      ensure_installed = {
        "ts_ls",       -- TypeScript/JavaScript
        "gopls",        -- Go
        "eslint",       -- ESLint
        "lua_ls",       -- Lua
      },
      automatic_installation = true,
    },
  },

  -- ─── LSP Configuration ─────────────────────────────────
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      { "j-hui/fidget.nvim", opts = {} },
    },
    config = function()
      -- Disable LSP logging to prevent spam
      vim.lsp.set_log_level("ERROR")
      
      -- Suppress deprecation warnings temporarily
      local notify = vim.notify
      vim.notify = function(msg, level, opts)
        if type(msg) == "string" then
          -- Filter out lspconfig deprecation warnings
          if msg:match("require.*lspconfig.*framework.*deprecated") or
             msg:match("tsserver is deprecated") or
             msg:match("Feature will be removed") then
            return
          end
        end
        notify(msg, level, opts)
      end
      
      -- Diagnostic configuration
      vim.diagnostic.config({
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = "",
            [vim.diagnostic.severity.WARN] = "",
            [vim.diagnostic.severity.HINT] = "",
            [vim.diagnostic.severity.INFO] = "",
          },
        },
        virtual_text = {
          prefix = "●",
          source = "if_many",
        },
        float = {
          border = "rounded",
          source = true,
          header = "",
          prefix = "",
        },
        underline = true,
        update_in_insert = false,
        severity_sort = true,
      })

      -- LSP keymaps (only when LSP is attached)
      local on_attach = function(client, bufnr)
        -- Disable semantic tokens for better performance
        if client.supports_method("textDocument/semanticTokens") then
          client.server_capabilities.semanticTokensProvider = nil
        end
        
        local map = function(keys, func, desc)
          vim.keymap.set("n", keys, func, { buffer = bufnr, desc = "LSP: " .. desc })
        end

        -- Navigation
        map("gd", vim.lsp.buf.definition, "Go to definition")
        map("gD", vim.lsp.buf.declaration, "Go to declaration")
        map("gi", vim.lsp.buf.implementation, "Go to implementation")
        map("gr", vim.lsp.buf.references, "References")
        map("gt", vim.lsp.buf.type_definition, "Type definition")

        -- Info
        map("K", vim.lsp.buf.hover, "Hover docs")
        map("<C-k>", vim.lsp.buf.signature_help, "Signature help")

        -- Actions
        map("<leader>lr", vim.lsp.buf.rename, "Rename")
        map("<leader>la", vim.lsp.buf.code_action, "Code action")
        map("<leader>lf", function()
          vim.lsp.buf.format({ async = true })
        end, "Format")

        -- Diagnostics
        map("<leader>ld", vim.diagnostic.open_float, "Line diagnostics")
        map("[d", vim.diagnostic.goto_prev, "Prev diagnostic")
        map("]d", vim.diagnostic.goto_next, "Next diagnostic")
      end

      -- LSP capabilities (will be enhanced by cmp)
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities.textDocument.completion.completionItem.snippetSupport = true
      capabilities.textDocument.foldingRange = {
        dynamicRegistration = false,
        lineFoldingOnly = true,
      }
      
      -- Try to enhance capabilities with cmp if available
      local ok, cmp_lsp = pcall(require, "cmp_nvim_lsp")
      if ok then
        capabilities = cmp_lsp.default_capabilities(capabilities)
      end
      
      -- Very simple server setup using new vim.lsp.config API
      vim.notify = notify -- Restore notify immediately
      
      -- Setup LSP servers with the new API
      local servers = {
        ts_ls = {
          on_attach = on_attach,
          capabilities = capabilities,
        },
        eslint = {
          on_attach = function(client, bufnr)
            on_attach(client, bufnr)
            vim.api.nvim_create_autocmd("BufWritePre", {
              buffer = bufnr,
              command = "EslintFixAll",
            })
          end,
          capabilities = capabilities,
        },
        gopls = {
          on_attach = on_attach,
          capabilities = capabilities,
        },
        lua_ls = {
          on_attach = on_attach,
          capabilities = capabilities,
          settings = {
            Lua = {
              runtime = { version = "LuaJIT" },
              workspace = {
                checkThirdParty = false,
                library = vim.api.nvim_get_runtime_file("", true),
              },
              diagnostics = { globals = { "vim" } },
              telemetry = { enable = false },
            },
          },
        },
      }
      
      -- Use new vim.lsp.config API if available, fallback to lspconfig
      if vim.lsp.config then
        for server, config in pairs(servers) do
          pcall(function()
            vim.lsp.config[server] = config
          end)
        end
      else
        -- Fallback to old lspconfig for older Neovim versions
        local ok, lspconfig = pcall(require, "lspconfig")
        if ok then
          for server, config in pairs(servers) do
            pcall(function()
              lspconfig[server].setup(config)
            end)
          end
        end
      end
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