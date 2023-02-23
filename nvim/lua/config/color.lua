--Set colorscheme (order is important here)
local M = {}

function M.config()
  vim.o.termguicolors = true
  -- vim.g.onedark_terminal_italics = 2
  -- vim.cmd [[colorscheme onedark]]
  vim.cmd [[colorscheme nord]]
end

return M
