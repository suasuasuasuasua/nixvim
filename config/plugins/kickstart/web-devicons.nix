{
  lib,
  config,
  ...
}:
let
  name = "web-devicons";
  cfg = config.nixvim.plugins.kickstart.${name};
in
{
  options.nixvim.plugins.kickstart.${name} = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable ${name} plugin for neovim";
    };
  };

  config = lib.mkIf cfg.enable {
    plugins.web-devicons = {
      enable = true;
    };
  };
}
