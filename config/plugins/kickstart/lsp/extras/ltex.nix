{
  lib,
  config,
  ...
}:
let
  name = "ltex";
  cfg = config.nixvim.lsp.${name};
in
{
  options.nixvim.lsp.${name} = {
    enable = lib.mkEnableOption "Enable ${name} LSP for neovim";
  };

  config = lib.mkIf cfg.enable {

    plugins = {
      lsp.servers.ltex = {
        enable = true;
        # NOTE: add options as I need
      };

      ltex-extra = {
        enable = true;
      };
    };
  };
}
