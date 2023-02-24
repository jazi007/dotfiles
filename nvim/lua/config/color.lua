--Set colorscheme (order is important here)
local M = {}

function M.config()
  vim.o.termguicolors = true
  -- vim.g.onedark_terminal_italics = 2
  -- vim.cmd [[colorscheme onedark]]
  vim.g.nord_contrast = true
  vim.g.nord_borders = false
  vim.g.nord_disable_background = false
  vim.g.nord_italic = false
  vim.g.nord_uniform_diff_background = true
  vim.g.nord_bold = false
  require('nord').set()
  vim.cmd [[colorscheme nord]]
end

return M
