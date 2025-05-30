{
  lib,
  config,
  ...
}:
let
  name = "typst";
  cfg = config.nixvim.plugins.custom.${name};
in
{
  options.nixvim.plugins.custom.${name} = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable ${name} plugin for neovim";
    };
  };

  config = lib.mkIf cfg.enable {
    # https://github.com/kaarmu/typst.vim/
    plugins.typst-vim = {
      enable = true;
    };

    # https://github.com/chomosuke/typst-preview.nvim/
    plugins.typst-preview = {
      enable = true;

      lazyLoad = lib.mkIf config.plugins.lz-n.enable {
        enable = true;
        settings = {
          cmd = "TypstPreview";
          ft = "typst";
        };
      };
    };
  };
}
