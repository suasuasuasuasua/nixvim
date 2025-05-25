{
  lib,
  config,
  ...
}:
let
  name = "lz-n";
  cfg = config.nixvim.plugins.${name};
in
{
  options.nixvim.plugins.${name} = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable ${name} plugin for neovim";
    };
  };

  config = lib.mkIf cfg.enable {
    # https://github.com/nvim-neorocks/lz.n
    plugins.lz-n = {
      enable = true;

      # :h autocmd-events
      settings = { };
    };
  };
}
