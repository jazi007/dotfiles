local M = {}

function M.config()
  local session_opts = {
    log_level = 'error',
    auto_session_enable_last_session = true,
    auto_session_root_dir = vim.fn.stdpath('data').."/sessions/",
    auto_session_enabled = true,
    auto_save_enabled = true,
    auto_restore_enabled = true,
    auto_session_suppress_dirs = { '/tmp/' },
  }
  require('auto-session').setup(session_opts)
  require('session-lens').setup()
  -- require("telescope").load_extension("session-lens")
  local map = vim.api.nvim_set_keymap
  local opts = {noremap = true, silent = true}

  --Add leader shortcuts
  map('', '<F10>', ':SearchSession<CR>', opts)
end

return M
