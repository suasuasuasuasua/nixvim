{
  lib,
  config,
  pkgs,
  ...
}:
let
  name = "vimtex";
  cfg = config.nixvim.plugins.custom.${name};
in
{
  options.nixvim.plugins.custom.${name} = {
    enable = lib.mkEnableOption "Enable ${name} plugin for neovim";
  };

  config = lib.mkIf cfg.enable {
    # https://github.com/lervag/vimtex
    plugins.vimtex = {
      enable = true;
    };

    extraPackages = with pkgs; [
      biber
    ];
  };
}
