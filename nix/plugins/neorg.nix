{
  lib,
  config,
  ...
}:
let
  name = "neorg";
  cfg = config.nixvim.plugins.${name};
in
{
  options.nixvim.plugins.${name} = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable ${name} plugin for neovim";
    };
  };

  config = lib.mkIf cfg.enable {
    # https://github.com/nvim-neorg/neorg
    plugins.neorg.enable = true;
  };
}
