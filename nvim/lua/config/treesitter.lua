local M = {}

function M.config()
  if vim.fn.has "win32" == 1 then
    -- https://github.com/nvim-treesitter/nvim-treesitter/wiki/Windows-support#troubleshooting
    require 'nvim-treesitter.install'.compilers = { "clang" }
  end
  require('nvim-treesitter.configs').setup {
    ensure_installed = {"bash", "c", "cmake", "comment", "lua", "json", "python", "toml", "yaml", "rust"},
    highlight = {
      enable = true, -- false will disable the whole extension
    },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = 'gnn',
        node_incremental = 'grn',
        scope_incremental = 'grc',
        node_decremental = 'grm',
      },
    },
    indent = {
      enable = true,
    },
    textobjects = {
      select = {
        enable = true,
        lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
        keymaps = {
          -- You can use the capture groups defined in textobjects.scm
          ['af'] = '@function.outer',
          ['if'] = '@function.inner',
          ['ac'] = '@class.outer',
          ['ic'] = '@class.inner',
        },
      },
      move = {
        enable = true,
        set_jumps = true, -- whether to set jumps in the jumplist
        goto_next_start = {
          [']m'] = '@function.outer',
          [']]'] = '@class.outer',
        },
        goto_next_end = {
          [']M'] = '@function.outer',
          [']['] = '@class.outer',
        },
        goto_previous_start = {
          ['[m'] = '@function.outer',
          ['[['] = '@class.outer',
        },
        goto_previous_end = {
          ['[M'] = '@function.outer',
          ['[]'] = '@class.outer',
        },
      },
    },
  }

  -- Folding using treesitter
  vim.opt.foldlevel  = 20
  vim.opt.foldmethod = 'expr'
  vim.opt.foldexpr   = 'nvim_treesitter#foldexpr()'
end

return M
