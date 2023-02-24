local M = {}

function M.config()
  require('lualine').setup {
    options = {
      icons_enabled = true,
      theme = 'auto',
      disabled_filetypes = {
        'NvimTree',
        'fugitive',
        'fugitiveblame',
        'termdebug',
      },
    };
  }
  vim.api.nvim_exec(
  [[
  augroup Session
  autocmd!
  autocmd VimLeave * NvimTreeClose
  augroup end
  ]],
  false
  )
end

return M

