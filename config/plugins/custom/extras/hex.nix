{
  lib,
  config,
  ...
}:
let
  name = "hex";
  cfg = config.suasuasuasuasua.nixvim.plugins.${name};
in
{
  options.suasuasuasuasua.nixvim.plugins.${name} = {
    enable = lib.mkEnableOption "Enable ${name} plugin for neovim";
  };

  config = lib.mkIf cfg.enable {
    # https://github.com/RaafatTurki/hex.nvim/
    plugins.hex = {
      enable = true;
    };
  };
}
