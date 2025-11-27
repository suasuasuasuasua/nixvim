{
  lib,
  config,
  ...
}:
let
  name = "neogit";
  cfg = config.nixvim.plugins.custom.${name};
in
{
  options.nixvim.plugins.custom.${name} = {
    enable = lib.mkEnableOption "Enable ${name} plugin for neovim";
  };

  config = lib.mkIf cfg.enable {
    # https://github.com/NeogitOrg/neogit/
    plugins.neogit = {
      enable = true;

      lazyLoad = lib.mkIf config.plugins.lz-n.enable {
        enable = true;
        settings = {
          cmd = "Neogit";
        };
      };
    };
  };
}
