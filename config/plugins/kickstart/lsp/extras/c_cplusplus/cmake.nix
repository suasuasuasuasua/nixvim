{
  lib,
  config,
  pkgs,
  ...
}:
let
  name = "cmake";
  cfg = config.suasuasuasuasua.nixvim.lsp.${name};
in
{
  options.suasuasuasuasua.nixvim.lsp.${name} = {
    enable = lib.mkEnableOption "Enable ${name} LSP for neovim";
  };

  config = lib.mkIf cfg.enable {
    plugins = {
      lsp.servers.cmake = {
        enable = true;
        # NOTE: add options as I need
      };

      treesitter.grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
        cmake
      ];
    };
  };
}
