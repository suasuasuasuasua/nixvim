{ lib, config, ... }:
{

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
}
