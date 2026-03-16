local raw = vim.fn.system({ "tmux", "show-environment", "THEME" })
raw = string.gsub(raw, "%s+", "")

local idx = string.find(raw, "=")
local theme = (idx and string.sub(raw, idx + 1)) or "light"

local colorscheme
if theme == "light" then
  colorscheme = "catppuccin-latte"
else
  colorscheme = "catpuccin-frappe"
end

return {
  { "navarasu/onedark.nvim" },
  { "catppuccin/nvim" },

  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = colorscheme,
    },
  },
}
