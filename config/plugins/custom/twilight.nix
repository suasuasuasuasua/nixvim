{
  lib,
  config,
  ...
}:
let
  name = "twilight";
  cfg = config.suasuasuasuasua.nixvim.plugins.${name};
in
{
  options.suasuasuasuasua.nixvim.plugins.${name} = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable ${name} plugin for neovim";
    };
  };

  config = lib.mkIf cfg.enable {
    # https://github.com/folke/twilight.nvim
    plugins.twilight = {
      enable = true;

      lazyLoad = {
        enable = true;

        settings = {
          cmd = "Twilight";
        };
      };
    };
  };
}
