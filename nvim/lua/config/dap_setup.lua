local map = vim.api.nvim_set_keymap
local create_cmd = vim.api.nvim_create_user_command

create_cmd('BreakpointToggle', function()
  require('dap').toggle_breakpoint()
end, {})
create_cmd('Debug', function()
  require('dap').continue()
end, {})
create_cmd('DapREPL', function()
  require('dap').repl.open()
end, {})

map('n', '<F5>', '', {
  callback = function()
    require('dap').continue()
  end,
  noremap = true,
})
map('n', '<F10>', '', {
  callback = function()
    require('dap').step_over()
  end,
  noremap = true,
})
map('n', '<F11>', '', {
  callback = function()
    require('dap').step_into()
  end,
  noremap = true,
})
map('n', '<F12>', '', {
  callback = function()
    require('dap').step_out()
  end,
  noremap = true,
})
map('n', '<M-k>', ':lua require("dapui").eval()<CR>', {noremap = true, silent = true})
map('v', '<M-k>', ':lua require("dapui").eval()<CR>', {noremap = true, silent = true})
