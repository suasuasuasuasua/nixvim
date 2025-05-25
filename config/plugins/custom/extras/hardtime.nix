{
  lib,
  config,
  ...
}:
let
  name = "hardtime";
  cfg = config.suasuasuasuasua.nixvim.plugins.${name};
in
{
  options.suasuasuasuasua.nixvim.plugins.${name} = {
    enable = lib.mkEnableOption "Enable ${name} plugin for neovim";
  };

  config = lib.mkIf cfg.enable {
    # https://github.com/m4xshen/hardtime.nvim
    plugins.hardtime = {
      enable = true;
    };
  };
}
