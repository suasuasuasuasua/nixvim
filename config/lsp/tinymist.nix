{
  lib,
  config,
  ...
}:
let
  name = "tinymist";
  cfg = config.nixvim.lsp.languages.${name};
in
{
  options.nixvim.lsp.languages.${name} = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable ${name} LSP for neovim";
    };
  };

  config = lib.mkIf cfg.enable {
    plugins.lsp.servers.tinymist = {
      enable = true;
      settings = {
        formatterMode = "typstyle";
        formatterProseWrap = true;
        formatterPrintWidth = 80;
        formatterIndentSize = 2;
      };
    };
  };
}
