{
  lib,
  config,
  ...
}:
let
  name = "persistence";
  cfg = config.nixvim.plugins.custom.${name};
in
{
  options.nixvim.plugins.custom.${name} = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable ${name} plugin for neovim";
    };
  };

  config = lib.mkIf cfg.enable {
    # https://github.com/folke/persistence.nvim
    plugins.persistence = {
      enable = true;

      settings = { };

      lazyLoad = lib.mkIf config.plugins.lz-n.enable {
        enable = true;
        settings = {
          event = [ "BufReadPre" ];
          keys = [
            {
              __unkeyed-1 = "<leader>qs";
              __unkeyed-3.__raw =
                # lua
                ''
                  function() require('persistence').load() end
                '';
              mode = "n";
              desc = "Load the session for the current directory";
            }
            {
              __unkeyed-1 = "<leader>qS";
              __unkeyed-3.__raw =
                # lua
                ''
                  function() require('persistence').select() end
                '';
              mode = "n";
              desc = "Select a session to load";
            }
            {
              __unkeyed-1 = "<leader>ql";
              __unkeyed-3.__raw =
                # lua
                ''
                  function() require('persistence').load({ last = true }) end
                '';
              mode = "n";
              desc = "load the last session";
            }
            {
              __unkeyed-1 = "<leader>qd";
              __unkeyed-3.__raw =
                # lua
                ''
                  function() require('persistence').stop() end
                '';
              mode = "n";
              desc = "Stop persistence => session won't be saved on exit";
            }
          ];
        };
      };
    };
  };
}
