{
  lib,
  config,
  ...
}:
let
  name = "zen-mode";
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
    # https://github.com/folke/zen-mode.nvim
    plugins.zen-mode = {
      enable = true;

      lazyLoad = {
        enable = true;

        settings = {
          cmd = "ZenMode";
        };
      };
    };
  };
}
