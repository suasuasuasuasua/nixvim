{
  lib,
  config,
  ...
}:
let
  name = "guess-indent";
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
    # Detect tabstop and shiftwidth automatically
    plugins.guess-indent = {
      enable = true;

      lazyLoad = lib.mkIf config.plugins.lz-n.enable {
        enable = true;
        settings = {
          # LazyFile is a shorthand that lazy.nvim uses
          event = [
            "BufReadPost"
            "BufWritePost"
            "BufNewFile"
          ];
        };
      };
    };
  };
}
