{
  lib,
  config,
  ...
}:
let
  name = "hardtime";
  cfg = config.nixvim.plugins.${name};
in
{
  options.nixvim.plugins.${name} = {
    enable = lib.mkEnableOption "Enable ${name} plugin for neovim";
  };

  config = lib.mkIf cfg.enable {
    # https://github.com/m4xshen/hardtime.nvim
    plugins.hardtime = {
      enable = true;
    };
  };
}
