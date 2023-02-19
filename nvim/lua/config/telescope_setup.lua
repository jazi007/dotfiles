local map = vim.api.nvim_set_keymap
local opts = {noremap = true, silent = true}

--Add leader shortcuts
map('n', '<leader><space>', [[<cmd>Telescope buffers<CR>]], opts)
map('n', '<leader>sf', [[<cmd>Telescope find_files<CR>]], opts)
map('n', '<leader>sb', [[<cmd>Telescope current_buffer_fuzzy_find<CR>]], opts)
map('n', '<leader>sd', [[<cmd>Telescope grep_string<CR>]], opts)
map('n', '<leader>sp', [[<cmd>Telescope live_grep<CR>]], opts)
map('n', '<leader>?', [[<cmd>Telescope oldfiles<CR>]], opts)
