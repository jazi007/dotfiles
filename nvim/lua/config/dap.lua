local dap, dapui = require("dap"), require("dapui")

-- Debugpy
dap.adapters.python = {
  type = 'executable',
  command = 'python',
  args = { '-m', 'debugpy.adapter' },
}

dap.configurations.python = {
  {
    type = 'python',
    request = 'launch',
    name = 'Launch file',
    program = '${file}',
    pythonPath = function()
      local venv_path = vim.fn.getenv 'VIRTUAL_ENVIRONMENT'
      if venv_path ~= vim.NIL and venv_path ~= '' then
        return venv_path .. '/bin/python'
      else
        return '/usr/bin/python'
      end
    end,
  },
}

-- lldb
dap.adapters.lldb = {
  type = 'executable',
  command = '/usr/bin/lldb-vscode-14',
  name = 'lldb',
}

dap.configurations.cpp = {
  {
    name = 'Launch',
    type = 'lldb',
    request = 'launch',
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    cwd = vim.fn.getcwd(),
    stopOnEntry = true,
    args = {},
    runInTerminal = false,
  },
}

dap.configurations.c = dap.configurations.cpp
dap.configurations.rust = dap.configurations.cpp

-- dapui
dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
end
