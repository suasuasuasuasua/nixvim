{ lib, config, ... }:
{
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
}
