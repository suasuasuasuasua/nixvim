{
  lib,
  config,
  ...
}:
let
  name = "surround";
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
    # https://github.com/kylechui/nvim-surround
    plugins.nvim-surround = {
      enable = true;

      lazyLoad = {
        enable = true;

        settings = {
          event = [
            "DeferredUIEnter"
          ];
        };
      };
    };
  };
}
