{
  lib,
  config,
  ...
}:
let
  name = "nvim-autopairs";
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
    # Inserts matching pairs of parens, brackets, etc.
    # https://nix-community.github.io/nixvim/plugins/nvim-autopairs/index.html

    plugins.nvim-autopairs = {
      enable = true;

      lazyLoad = lib.mkIf config.plugins.lz-n.enable {
        enable = true;

        settings = {
          event = [ "InsertEnter" ];
        };
      };
    };
  };
}
