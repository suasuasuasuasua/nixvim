{
  lib,
  config,
  ...
}:
let
  name = "repeat";
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
    # https://github.com/tpope/vim-repeat
    plugins.repeat = {
      enable = true;
    };
  };
}
