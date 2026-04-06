{
  lib,
  config,
  ...
}:
let
  name = "diffview";
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
    # https://github.com/sindrets/diffview.nvim
    plugins.diffview = {
      enable = true;
    };
  };
}
