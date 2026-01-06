if vim.loader then
  vim.loader.enable()
end

_G.dd = function(...)
  vim.print(...)
end

require("config.lazy")
