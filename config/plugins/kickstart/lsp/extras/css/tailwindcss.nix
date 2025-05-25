{
  lib,
  config,
  pkgs,
  ...
}:
let
  name = "tailwindcss";
  cfg = config.suasuasuasuasua.nixvim.lsp.${name};
in
{
  options.suasuasuasuasua.nixvim.lsp.${name} = {
    enable = lib.mkEnableOption "Enable ${name} LSP for neovim";
  };

  config = lib.mkIf cfg.enable {
    plugins = {
      lsp.servers.tailwindcss = {
        enable = true;
        # NOTE: add options as I need
      };

      treesitter.grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
        css
      ];
    };
  };
}
