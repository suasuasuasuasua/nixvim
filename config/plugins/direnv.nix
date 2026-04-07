{
  lib,
  config,
  ...
}:
let
  name = "direnv";
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
    # https://github.com/direnv/direnv.vim
    plugins.direnv = {
      enable = true;
    };
  };
}
