local M = {}

function M.config()
  require'nvim-tree'.setup {
    disable_netrw       = true,
    hijack_netrw        = true,
    open_on_setup       = false,
    ignore_ft_on_setup  = {},
    -- auto_close          = false,
    open_on_tab         = false,
    hijack_cursor       = true,
    update_cwd          = false,
    -- update_to_buf_dir   = {
    --   enable = true,
    --   auto_open = true,
    -- },
    diagnostics = {
      enable = false,
      icons = {
        hint = "",
        info = "",
        warning = "",
        error = "",
      }
    },
    update_focused_file = {
      enable      = true,
      update_cwd  = false,
      ignore_list = {}
    },
    system_open = {
      cmd  = nil,
      args = {}
    },
    filters = {
      dotfiles = false,
      custom = {}
    },
    view = {
      width = 30,
      -- height = 30,
      hide_root_folder = false,
      side = 'left',
      -- auto_resize = true,
      mappings = {
        custom_only = false,
        list = {}
      }
    }
  }

  local map = vim.api.nvim_set_keymap
  local opts = {noremap = true, silent = true}

  -- New commands
  vim.cmd [[
    command! NvimTreeChangeDir lua require'nvim-tree'.change_dir(vim.fn.expand("%:h"))
    command! NvimTreeChangeHome lua require'nvim-tree'.change_dir(vim.g.start_directory)
  ]]

  -- Add leader shortcuts
  map('n', '<leader>nt', ':NvimTreeToggle<CR>', opts)
  map('n', '<leader>nf', ':NvimTreeChangeDir<CR>', opts)
  map('n', '<leader>nb', ':NvimTreeChangeHome<CR>', opts)
end

return M
