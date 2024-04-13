-----------------------------------------------------------
-- Keymaps configuration file: keymaps of neovim
-- and plugins.
-----------------------------------------------------------

local map = vim.api.nvim_set_keymap
local keymap = vim.keymap -- for conciseness
local default_opts = { noremap = true, silent = true }

-----------------------------------------------------------
-- Neovim shortcuts:
-----------------------------------------------------------

keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })

-- increment/decrement numbers
keymap.set("n", "<leader>+", "<C-a>", { desc = "Increment number" }) -- increment
keymap.set("n", "<leader>-", "<C-x>", { desc = "Decrement number" }) -- decrement

-- window management
keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" }) -- split window vertically
keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" }) -- split window horizontally
keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" }) -- make split windows equal width & height
keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" }) -- close current split window

-- Edit mapping
map("", "<leader>ew", ":e %%", { desc = "Edit file in same directory" })
map("c", "%%", "getcmdtype() == ':' ? fnameescape(expand('%:h')).'/' : '%%'", { expr = true })

--  Fix the & command in normal+visual modes {{{2
map("n", "&", ":&&<Enter>", default_opts)
map("x", "&", ":&&<Enter>", default_opts)

-- buffers: mapping for french keyboard
local tbl = { "n", "o", "x" }
for _, t in pairs(tbl) do
	map(t, "(", "[", {})
	map(t, ")", "]", {})
end

-- remap shift insert
map("i", "<S-Insert>", "<C-R>+", default_opts)
map("c", "<S-Insert>", "<C-R>+", default_opts)

-- Y yank until the end of line
map("n", "Y", "y$", default_opts)

-- window moves
-- https://github.com/neovim/neovim/pull/2076#issuecomment-76998265
map("n", "<a-h>", "<c-w>h", default_opts)
map("n", "<a-j>", "<c-w>j", default_opts)
map("n", "<a-k>", "<c-w>k", default_opts)
map("n", "<a-l>", "<c-w>l", default_opts)
local tbl = { "v", "i", "c", "t" }
for _, t in pairs(tbl) do
	map(t, "<a-h>", "<c-\\><c-n><c-w>h", default_opts)
	map(t, "<a-j>", "<c-\\><c-n><c-w>j", default_opts)
	map(t, "<a-k>", "<c-\\><c-n><c-w>k", default_opts)
	map(t, "<a-l>", "<c-\\><c-n><c-w>l", default_opts)
end
map("t", "<Esc>", "<C-\\><C-n>", default_opts)
