-- Entry point, hanya require modul

-- Set leader keys
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Load core configuration
require("core.options")
require("core.keymaps")
require("core.autocmds")

-- Load plugins
require("plugins")