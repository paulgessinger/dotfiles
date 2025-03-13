local raw = vim.fn.system({ "tmux", "show-environment", "THEME" })
raw = string.gsub(raw, "%s+", "")
local idx = string.find(raw, "=")
local theme = string.sub(raw, idx + 1)
local colorscheme
if theme == "light" then
  colorscheme = "monokai-pro-light"
else
  colorscheme = "onedark"
end
return {
  { "navarasu/onedark.nvim" },
  { "loctvl842/monokai-pro.nvim" },

  -- Configure LazyVim to load gruvbox
  {
    "LazyVim/LazyVim",
    opts = {
      -- colorscheme = "onedark",
      colorscheme = colorscheme,
    },
  },
}
