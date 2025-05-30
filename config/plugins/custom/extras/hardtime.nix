{
  lib,
  config,
  ...
}:
let
  name = "hardtime";
  cfg = config.nixvim.plugins.custom.${name};
in
{
  options.nixvim.plugins.custom.${name} = {
    enable = lib.mkEnableOption "Enable ${name} plugin for neovim";
  };

  config = lib.mkIf cfg.enable {
    # https://github.com/m4xshen/hardtime.nvim
    plugins.hardtime = {
      enable = true;
    };
  };
}
