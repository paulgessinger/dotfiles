local jit = require("jit")
local mason = true
if jit.os == "Linux" and jit.arch == "arm64" then
  mason = false
end
return {
  "neovim/nvim-lspconfig",
  ---@class PluginLspOpts
  opts = {
    ---@type lspconfig.options
    servers = {
      clangd = {
        mason = mason,
      },
    },
  },
}
