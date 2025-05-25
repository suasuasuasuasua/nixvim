{
  lib,
  config,
  pkgs,
  ...
}:
let
  name = "grug-far";
  cfg = config.suasuasuasuasua.nixvim.plugins.${name};
in
{
  options.suasuasuasuasua.nixvim.plugins.${name} = {
    enable = lib.mkEnableOption "Enable ${name} plugin for neovim";
  };

  config = lib.mkIf cfg.enable {
    # https://github.com/MagicDuck/grug-far.nvim/
    plugins.grug-far = {
      enable = true;
    };

    extraPackages = with pkgs; [
      ast-grep
    ];
  };
}
