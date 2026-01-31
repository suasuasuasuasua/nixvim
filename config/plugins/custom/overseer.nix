{
  lib,
  config,
  ...
}:
let
  name = "overseer";
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
    # https://github.com/stevearc/overseer.nvim
    plugins.overseer = {
      enable = true;

      settings = {
      };

      lazyLoad = lib.mkIf config.plugins.lz-n.enable {
        enable = true;

        settings = {
          event = [ "DeferredUIEnter" ];
          keys = [
            {
              __unkeyed-1 = "<leader>oo";
              __unkeyed-3 = "<CMD>OverseerToggle<CR>";
              mode = "n";
              desc = "[O]verseer T[O]ggle";
            }
            {
              __unkeyed-1 = "<leader>or";
              __unkeyed-3 = "<CMD>OverseerRun<CR>";
              mode = "n";
              desc = "[O]verseer [R]run";
            }
          ];
        };
      };
    };
  };
}
