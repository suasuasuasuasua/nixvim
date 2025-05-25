{
  lib,
  config,
  ...
}:
let
  name = "lualine";
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
    # https://github.com/nvim-lualine/lualine.nvim
    plugins.lualine = {
      enable = true;
      settings = {
        options = {
          theme = "auto";
        };
      };
    };
  };
}
