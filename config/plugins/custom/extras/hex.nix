{
  lib,
  config,
  ...
}:
let
  name = "hex";
  cfg = config.nixvim.plugins.custom.${name};
in
{
  options.nixvim.plugins.custom.${name} = {
    enable = lib.mkEnableOption "Enable ${name} plugin for neovim";
  };

  config = lib.mkIf cfg.enable {
    # https://github.com/RaafatTurki/hex.nvim/
    plugins.hex = {
      enable = true;
    };
  };
}
