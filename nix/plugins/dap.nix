{ pkgs, ... }:
{
  # Debug Adapter Protocol client
  # https://nix-community.github.io/nixvim/plugins/dap/index.html
  plugins = {
    dap = {
      enable = true;

      signs = {
        dapBreakpoint = {
          text = "";
          texthl = "DapBreak";
        };
        dapBreakpointCondition = {
          text = "";
          texthl = "DapBreak";
        };
        dapBreakpointRejected = {
          text = "";
          texthl = "DapBreak";
        };
        dapLogPoint = {
          text = "";
          texthl = "DapBreak";
        };
        dapStopped = {
          text = "";
          texthl = "DapStop";
        };
      };
    };

    dap-ui = {
      enable = true;
      settings = {
        icons = {
          expanded = "▾";
          collapsed = "▸";
          current_frame = "*";
        };
        controls.icons = {
          pause = "⏸";
          play = "▶";
          step_into = "⏎";
          step_over = "⏭";
          step_out = "⏮";
          step_back = "b";
          run_last = "▶▶";
          terminate = "⏹";
          disconnect = "⏏";
        };
      };
    };

    dap-go = {
      enable = true;
      settings.delve.detached.__raw = "vim.fn.has 'win32' == 0";
    };

    dap-python.enable = true;
  };

  keymaps = [
    {
      mode = "n";
      key = "<F5>";
      action = "<Cmd>DapContinue<CR>";
      options.desc = "Debug: Start/Continue";
    }
    {
      mode = "n";
      key = "<F1>";
      action = "<Cmd>DapStepOver<CR>";
      options.desc = "Debug: Step Over";
    }
    {
      mode = "n";
      key = "<F2>";
      action = "<Cmd>DapStepInto<CR>";
      options.desc = "Debug: Step Into";
    }
    {
      mode = "n";
      key = "<F3>";
      action = "<Cmd>DapStepOut<CR>";
      options.desc = "Debug: Step Out";
    }
    {
      mode = "n";
      key = "<leader>b";
      action = "<Cmd>DapToggleBreakpoint<CR>";
      options.desc = "Debug: Toggle Breakpoint";
    }
    {
      mode = "n";
      key = "<leader>B";
      action.__raw = "function() require('dap').set_breakpoint(vim.fn.input 'Breakpoint condition: ') end";
      options.desc = "Debug: Set Breakpoint";
    }
    {
      mode = "n";
      key = "<F7>";
      action = "<Cmd>DapShowLastSessionResult<CR>";
      options.desc = "Debug: Show Last Session Result";
    }
  ];

  extraConfigLua =
    # lua
    # ${"$"}{...} escapes DAP-specific template strings so Nix does not interpolate them
    ''
      local dap = require 'dap'
      local dapui = require 'dapui'

      vim.api.nvim_set_hl(0, 'DapBreak', { fg = '#e51400' })
      vim.api.nvim_set_hl(0, 'DapStop', { fg = '#ffcc00' })

      dap.listeners.after.event_initialized['dapui_config'] = dapui.open
      dap.listeners.before.event_terminated['dapui_config'] = dapui.close
      dap.listeners.before.event_exited['dapui_config'] = dapui.close

      require("dap-python").setup()

      dap.adapters.codelldb = {
        type = 'server',
        port = '${"$"}{port}',
        executable = {
          command = vim.fn.exepath('codelldb'),
          args = { '--port', '${"$"}{port}' },
        },
      }

      dap.configurations.python = {
        {
          name = "Python Debugger: Current File",
          type = "debugpy",
          request = "launch",
          program = '${"$"}{file}',
          args = {},
          console = "integratedTerminal"
        },
      }

      dap.configurations.cpp = {
        {
          name = "(gdb) Launch",
          type = "cppdbg",
          request = "launch",
          program = function()
            local result = nil
            require("mini.pick").start {
              source = {
                name = "Select executable",
                cwd = vim.fn.getcwd(),
                items = vim.fn.systemlist({ "fd", "--type", "x", "--no-ignore", "--absolute-path" }),
                choose = function(item) result = item end,
              },
            }
            return result
          end,
          args = {},
          cwd = '${"$"}{fileDirname}',
          environment = {},
          externalConsole = false,
          MIMode = "gdb",
          setupCommands = { { text = "set follow-fork-mode child", ignoreFailures = true } },
        },
        {
          name = "(lldb) Launch",
          type = "codelldb",
          request = "launch",
          program = function()
            local result = nil
            require("mini.pick").start {
              source = {
                name = "Select executable",
                cwd = vim.fn.getcwd(),
                items = vim.fn.systemlist({ "fd", "--type", "x", "--no-ignore", "--absolute-path" }),
                choose = function(item) result = item end,
              },
            }
            return result
          end,
          args = {},
          cwd = '${"$"}{fileDirname}',
          stopOnEntry = false,
        },
        {
          name = "Attach to Python (GDB)",
          type = "cppdbg",
          request = "attach",
          processId = function()
            return require('dap.utils').pick_process({ filter = "python" })
          end,
          program = "python",
          MIMode = "gdb",
          setupCommands = { { text = "set follow-fork-mode child", ignoreFailures = true } },
        }
      }
    '';

  extraPackages = [
    pkgs.delve
    pkgs.python313Packages.debugpy
  ];
}
