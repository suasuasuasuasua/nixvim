{
  lib,
  config,
  ...
}:
let
  name = "dropbar";
  cfg = config.nixvim.plugins.custom.${name};
in
{
  options.nixvim.plugins.custom.${name} = {
    enable = lib.mkEnableOption "Enable ${name} plugin for neovim";
  };

  config = lib.mkIf cfg.enable {
    # https://github.com/Bekaboo/dropbar.nvim/
    plugins.dropbar = {
      enable = true;

      luaConfig.post =
        # lua
        ''
          -- Dropbar can be used as a drop-in replacement for Neovim's builtin
          -- vim.ui.select menu.
          --
          -- To enable this functionality, simply replace vim.ui.select with
          -- dropbar.utils.menu.select:
          vim.ui.select = require('dropbar.utils.menu').select
        '';
    };

    keymaps = [
      {
        mode = "n";
        key = "<leader>;";
        action.__raw =
          # lua
          ''
            function()
              require('dropbar.api').pick()
            end
          '';
        options = {
          desc = "Pick symbols in winbar";
        };
      }
      {
        mode = "n";
        key = "[;";
        action.__raw =
          # lua
          ''
            function()
              require('dropbar.api').goto_context_start()
            end
          '';
        options = {
          desc = "Go to start of current context";
        };
      }
      {
        mode = "n";
        key = "];";
        action.__raw =
          # lua
          ''
            function()
              require('dropbar.api').select_next_context()
            end
          '';
        options = {
          desc = "Select next context";
        };
      }
    ];

    opts = {
      # allows cursor hovering for file preview
      mousemoveevent = true;
    };
  };
}
