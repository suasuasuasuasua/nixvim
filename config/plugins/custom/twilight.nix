{
  lib,
  config,
  ...
}:
let
  name = "twilight";
  cfg = config.nixvim.plugins.${name};
in
{
  options.nixvim.plugins.${name} = {
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

      lazyLoad = lib.mkIf config.plugins.lz-n.enable {
        enable = true;

        settings = {
          cmd = "Twilight";
        };
      };
    };
  };
}
