{
  lib,
  config,
  pkgs,
  ...
}:
let
  name = "nginx_language_server";
  cfg = config.nixvim.lsp.${name};
in
{
  options.nixvim.lsp.${name} = {
    enable = lib.mkEnableOption "Enable ${name} LSP for neovim";
  };

  config = lib.mkIf cfg.enable {
    plugins = {
      lsp.servers.nginx_language_server = {
        enable = true;
        # NOTE: add options as I need
      };

      treesitter.grammarPackages =
        with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
          nginx
        ];
    };
  };
}
