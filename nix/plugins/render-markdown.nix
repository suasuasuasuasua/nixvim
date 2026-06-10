{
  lib,
  config,
  ...
}:
let
  name = "render-markdown";
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
    # https://github.com/MeanderingProgrammer/render-markdown.nvim
    plugins.render-markdown = {
      enable = true;

      settings = {
        latex = {
          enabled = false;
        };
      };
    };
  };
}
