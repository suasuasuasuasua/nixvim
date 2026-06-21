-- Debug adapters are provided by Nix (lspsAndRuntimeDeps.dap in flake.nix)
-- mason and mason-nvim-dap are intentionally omitted

vim.keymap.set('n', '<F5>', function() require('dap').continue() end, { desc = 'Debug: Start/Continue' })
vim.keymap.set('n', '<F1>', function() require('dap').step_into() end, { desc = 'Debug: Step Into' })
vim.keymap.set('n', '<F2>', function() require('dap').step_over() end, { desc = 'Debug: Step Over' })
vim.keymap.set('n', '<F3>', function() require('dap').step_out() end, { desc = 'Debug: Step Out' })
vim.keymap.set('n', '<leader>b', function() require('dap').toggle_breakpoint() end, { desc = 'Debug: Toggle Breakpoint' })
vim.keymap.set('n', '<leader>B', function() require('dap').set_breakpoint(vim.fn.input 'Breakpoint condition: ') end, { desc = 'Debug: Set Breakpoint' })
vim.keymap.set('n', '<F7>', function() require('dapui').toggle() end, { desc = 'Debug: See last session result.' })

local dap = require 'dap'
local dapui = require 'dapui'

dapui.setup {
  icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
  controls = {
    icons = {
      pause = '⏸',
      play = '▶',
      step_into = '⏎',
      step_over = '⏭',
      step_out = '⏮',
      step_back = 'b',
      run_last = '▶▶',
      terminate = '⏹',
      disconnect = '⏏',
    },
  },
}

vim.api.nvim_set_hl(0, 'DapBreak', { fg = '#e51400' })
vim.api.nvim_set_hl(0, 'DapStop', { fg = '#ffcc00' })
local breakpoint_icons = vim.g.have_nerd_font and { Breakpoint = '', BreakpointCondition = '', BreakpointRejected = '', LogPoint = '', Stopped = '' }
  or { Breakpoint = '●', BreakpointCondition = '⊜', BreakpointRejected = '⊘', LogPoint = '◆', Stopped = '⭔' }
for type, icon in pairs(breakpoint_icons) do
  local tp = 'Dap' .. type
  local hl = (type == 'Stopped') and 'DapStop' or 'DapBreak'
  vim.fn.sign_define(tp, { text = icon, texthl = hl, numhl = hl })
end

dap.listeners.after.event_initialized['dapui_config'] = dapui.open
dap.listeners.before.event_terminated['dapui_config'] = dapui.close
dap.listeners.before.event_exited['dapui_config'] = dapui.close

require('dap-go').setup {
  delve = {
    detached = vim.fn.has 'win32' == 0,
  },
}

require('dap-python').setup()

-- codelldb adapter: provided by pkgs.lldb (lldb-dap) or a vscode-lldb derivation
-- TODO: wire up the exact path if vim.fn.exepath('codelldb') is empty
dap.adapters.codelldb = {
  type = 'server',
  port = '${port}',
  executable = {
    command = vim.fn.exepath 'codelldb',
    args = { '--port', '${port}' },
  },
}

dap.configurations = {
  python = {
    {
      name = 'Python Debugger: Current File',
      type = 'debugpy',
      request = 'launch',
      program = '${file}',
      args = {},
      console = 'integratedTerminal',
    },
  },
  cpp = {
    {
      name = '(gdb) Launch',
      type = 'cppdbg',
      request = 'launch',
      program = function()
        local result = nil
        require('mini.pick').start {
          source = {
            name = 'Select executable',
            cwd = vim.fn.getcwd(),
            items = vim.fn.systemlist { 'fd', '--type', 'x', '--no-ignore', '--absolute-path' },
            choose = function(item) result = item end,
          },
        }
        return result
      end,
      args = {},
      cwd = '${fileDirname}',
      environment = {},
      externalConsole = false,
      MIMode = 'gdb',
      setupCommands = {
        { text = 'set follow-fork-mode child', ignoreFailures = true },
      },
    },
    {
      name = '(lldb) Launch',
      type = 'codelldb',
      request = 'launch',
      program = function()
        local result = nil
        require('mini.pick').start {
          source = {
            name = 'Select executable',
            cwd = vim.fn.getcwd(),
            items = vim.fn.systemlist { 'fd', '--type', 'x', '--no-ignore', '--absolute-path' },
            choose = function(item) result = item end,
          },
        }
        return result
      end,
      args = {},
      cwd = '${fileDirname}',
      stopOnEntry = false,
    },
    {
      name = 'Attach to Python (GDB)',
      type = 'cppdbg',
      request = 'attach',
      processId = function() return require('dap.utils').pick_process { filter = 'python' } end,
      program = 'python',
      MIMode = 'gdb',
      setupCommands = {
        { text = 'set follow-fork-mode child', ignoreFailures = true },
      },
    },
  },
}
