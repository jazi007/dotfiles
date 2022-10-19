
-----------------------------------------------------------
-- Neovim settings
-----------------------------------------------------------

-----------------------------------------------------------
-- Neovim API aliases
-----------------------------------------------------------
local g = vim.g     -- global variables
local opt = vim.opt -- global/buffer/windows-scoped options
local cmd = vim.cmd -- execute Vim commands


-----------------------------------------------------------
-- General
-----------------------------------------------------------
--Remap space as leader key
vim.api.nvim_set_keymap('', '<Space>', '<Nop>', { noremap = true, silent = true })
g.mapleader = ' '
g.maplocalleader = ' '

--Remap for dealing with word wrap
vim.api.nvim_set_keymap('n', 'k', "v:count == 0 ? 'gk' : 'k'", { noremap = true, expr = true, silent = true })
vim.api.nvim_set_keymap('n', 'j', "v:count == 0 ? 'gj' : 'j'", { noremap = true, expr = true, silent = true })

opt.mouse     = 'a'           -- enable mouse support
opt.clipboard = 'unnamedplus' -- copy/paste to system clipboard
opt.swapfile  = false         -- don't use swapfile
opt.autoread  = true          -- auto read file if changed outside of vim
-- recursive :find in current dir
vim.cmd[[set path=.,,,$PWD/**]]

-----------------------------------------------------------
-- Neovim UI
-----------------------------------------------------------
opt.number            = true      -- show line number
opt.cursorline        = true
opt.showmatch         = true      -- highlight matching parenthesis
opt.foldmethod        = 'indent'  -- enable folding (default 'foldmarker')
-- opt.colorcolumn = '80'         -- line lenght marker at 80 columns
-- opt.showmode          = false      -- show current mode (insert, etc) under the cmdline
-- opt.showcmd           = false      -- show current command under the cmd line
-- opt.cmdheight         = 2         -- cmdline height
-- opt.laststatus        = 2         -- 2 = always show status line (filename, etc)
-- opt.linespace         = 0         -- font spacing
opt.ruler             = true      -- show line,col at the cursor pos
opt.splitright        = true      -- vertical split to the right
opt.splitbelow        = true      -- orizontal split to the bottom
opt.linebreak         = true      -- wrap on word boundary

opt.hidden            = true      -- enable background buffers
opt.history           = 100       -- remember n lines in history
opt.lazyredraw        = false     -- faster scrolling
opt.synmaxcol         = 240       -- max column for syntax highlight

-- Characters to display on ':set list',explore glyphs using:
-- `xfd -fa "InputMonoNerdFont:style:Regular"` or
-- `xfd -fn "-misc-fixed-medium-r-semicondensed-*-13-*-*-*-*-*-iso10646-1"`
-- input special chars with the sequence <C-v-u> followed by the hex code
opt.listchars = {
  tab       = '→ '  ,
  eol       = '↲'   ,
  nbsp      = '␣'   ,
  lead      = '␣'   ,
  space     = '␣'   ,
  trail     = '•'   ,
  extends   = '⟩'   ,
  precedes  = '⟨'   ,
}
opt.showbreak = '↪ '

-----------------------------------------------------------
-- Search
-----------------------------------------------------------
opt.hlsearch = true
opt.incsearch = true
opt.ignorecase = true         -- ignore case letters when search
opt.smartcase = true          -- ignore lowercase for the whole pattern
vim.o.inccommand = 'nosplit'

-----------------------------------------------------------
-- Colorscheme
-----------------------------------------------------------
opt.termguicolors = true      -- enable 24-bit RGB colors

-----------------------------------------------------------
-- Tabs, indent
-----------------------------------------------------------
opt.expandtab = true      -- use spaces instead of tabs
opt.shiftwidth = 4        -- shift 4 spaces when tab
opt.tabstop = 4           -- 1 tab == 4 spaces
opt.smartindent = true    -- autoindent new lines

-- 2 spaces for selected filetypes
cmd [[
  autocmd FileType xml,html,xhtml,css,scss,javascript,lua,yaml setlocal shiftwidth=2 tabstop=2
]]

-----------------------------------------------------------
-- Session
-----------------------------------------------------------
opt.sessionoptions="blank,buffers,curdir,folds,help,options,tabpages,winsize,resize,winpos,terminal"

-----------------------------------------------------------
-- Autocompletion
-----------------------------------------------------------
-- insert mode completion options
opt.completeopt = 'menuone,noselect'

-----------------------------------------------------------
-- Terminal
-----------------------------------------------------------
-- open a terminal pane on the right using :Term
cmd [[command Term :botright vsplit term://$SHELL]]

-- Terminal visual tweaks
--- enter insert mode when switching to terminal
--- close terminal buffer on process exit
-- cmd [[
--   autocmd TermOpen * setlocal listchars= nonumber norelativenumber nocursorline
--   autocmd TermOpen * startinsert
--   autocmd BufLeave term://* stopinsert
--   autocmd FileType termdebug setlocal listchars= nonumber norelativenumber nocursorline
--   autocmd FileType termdebug startinsert
-- ]]

-- Highlights trailing spaces
cmd [[
  highlight ExtraWhitespace ctermbg=red guibg=red
  autocmd ColorScheme * highlight ExtraWhitespace ctermbg=red guibg=red
  autocmd FileType * match ExtraWhitespace /\s\+$/
  autocmd FileType dashboard match ExtraWhitespace //
]]

-- Debug
cmd [[
  function! SetDebugMapping()
    let g:termdebug_wide = 162
    map <f5> :Continue<CR>
    map <f10> :Over<CR>
    map <f11> :Step<CR>
    map <m-k> :Evaluate<CR>
  endfunction
  function! UnSetDebugMapping()
    unmap <f5>
    unmap <f10>
    unmap <f11>
    unmap <m-k>
  endfunction
  autocmd User TermdebugStartPre call SetDebugMapping()
  autocmd User TermdebugStopPost call UnSetDebugMapping()
]]

-----------------------------------------------------------
-- Startup
-----------------------------------------------------------
-- disable builtins plugins
local disabled_built_ins = {
    "netrw",
    "netrwPlugin",
    "netrwSettings",
    "netrwFileHandlers",
    "gzip",
    "zip",
    "zipPlugin",
    "tar",
    "tarPlugin",
    "getscript",
    "getscriptPlugin",
    "vimball",
    "vimballPlugin",
    "2html_plugin",
    "logipat",
    "rrhelper",
    "spellfile_plugin",
    "matchit"
}

for _, plugin in pairs(disabled_built_ins) do
    g["loaded_" .. plugin] = 1
end

-- Disable providers we do not care a about
vim.g.loaded_python_provider  = 0
vim.g.loaded_ruby_provider    = 0
vim.g.loaded_perl_provider    = 0
vim.g.loaded_node_provider    = 0
