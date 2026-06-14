{
  # https://github.com/stevearc/overseer.nvim
  plugins.overseer = {
    enable = true;
    settings = { };

    luaConfig.post =
      # lua
      ''
        vim.api.nvim_create_user_command("Make", function(params)
          local cmd, num_subs = vim.o.makeprg:gsub("%$%*", params.args)
          if num_subs == 0 then
            cmd = cmd .. " " .. params.args
          end
          local task = require("overseer").new_task({
            cmd = vim.fn.expandcmd(cmd),
            components = {
              {
                "on_output_quickfix",
                open = not params.bang,
                open_height = 8,
                errorformat = vim.o.errorformat,
              },
              "default",
            },
          })
          task:start()
        end, {
          desc = "Run your makeprg as an Overseer task",
          nargs = "*",
          bang = true,
        })
      '';
  };

  keymaps = [
    {
      mode = "n";
      key = "<Leader>oo";
      action = "<Cmd>OverseerOpen<CR>";
      options = {
        desc = "[O]pen [O]verseer";
      };
    }
    {
      mode = "n";
      key = "<Leader>or";
      action = "<Cmd>OverseerRun<CR>";
      options = {
        desc = "[O]verseer [R]un";
      };
    }
    {
      mode = "n";
      key = "<Leader>ot";
      action = "<Cmd>OverseerToggle<CR>";
      options = {
        desc = "[O]verseer [T]oggle";
      };
    }
  ];
}
