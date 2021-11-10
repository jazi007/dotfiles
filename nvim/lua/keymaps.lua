
-----------------------------------------------------------
-- Keymaps configuration file: keymaps of neovim
-- and plugins.
-----------------------------------------------------------

local map = vim.api.nvim_set_keymap
local default_opts = { noremap = true, silent = true }
local cmd = vim.cmd

-----------------------------------------------------------
-- Neovim shortcuts:
-----------------------------------------------------------

-- clear search highlighting
map('n', '<leader>c', ':nohl<CR>', default_opts)

-- Edit mapping
map('c', '%%', 'getcmdtype() == \':\' ? fnameescape(expand(\'%:h\')).\'/\' : \'%%\'', {expr = true})
map('', '<leader>ew', ':e %%', {})
map('', '<leader>es', ':sp %%', {})
map('', '<leader>ev', ':vsp %%', {})
map('', '<leader>et', ':tabe %%', {})

--  Fix the & command in normal+visual modes {{{2
map('n', '&', ':&&<Enter>', default_opts)
map('x', '&', ':&&<Enter>', default_opts)

-- buffers: mapping for french keyboard
local tbl = {'n', 'o', 'x'}
for _, t in pairs(tbl) do
  map(t, '(', '[', {})
  map(t, ')', ']', {})
end

-- remap shift insert
map('i', '<S-Insert>', '<C-R>+', default_opts)
map('c', '<S-Insert>', '<C-R>+', default_opts)

-- Highlight on yank
vim.api.nvim_exec(
  [[
  augroup YankHighlight
    autocmd!
    autocmd TextYankPost * silent! lua vim.highlight.on_yank()
  augroup end
]],
  false
)

-- Y yank until the end of line
map('n', 'Y', 'y$', default_opts)

-- window moves
-- https://github.com/neovim/neovim/pull/2076#issuecomment-76998265
map('n', '<a-h>', '<c-w>h', default_opts)
map('n', '<a-j>', '<c-w>j', default_opts)
map('n', '<a-k>', '<c-w>k', default_opts)
map('n', '<a-l>', '<c-w>l', default_opts)
local tbl = {'v', 'i', 'c', 't'}
for _, t in pairs(tbl) do
  map(t, '<a-h>', '<c-\\><c-n><c-w>h', default_opts)
  map(t, '<a-j>', '<c-\\><c-n><c-w>j', default_opts)
  map(t, '<a-k>', '<c-\\><c-n><c-w>k', default_opts)
  map(t, '<a-l>', '<c-\\><c-n><c-w>l', default_opts)
end
map('t', '<Esc>', '<C-\\><C-n>', default_opts)

