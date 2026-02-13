{
  lib,
  config,
  ...
}:
let
  name = "direnv";
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
    # https://github.com/direnv/direnv.vim
    plugins.direnv = {
      enable = true;

      # TODO: available in 26.05
      # lazyLoad = lib.mkIf config.plugins.lz-n.enable {
      #   enable = true;
      #
      #   settings = {
      #     event = [ "DeferredUIEnter" ];
      #   };
      # };
    };
  };
}
