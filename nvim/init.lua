-- Leader/local leader - lazy.nvim needs these set first
vim.g.mapleader = [[ ]]
vim.g.maplocalleader = [[ ]]
-- start directory
vim.g.start_directory = vim.fn.getcwd()

-- require('impatient')
require('core')
require('custom.lazy')
-- vim.lsp.set_log_level("info")

