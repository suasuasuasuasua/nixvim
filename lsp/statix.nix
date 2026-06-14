{ pkgs, ... }:
{
  plugins = {
    lsp.servers.statix.enable = true;
    treesitter.grammarPackages =
      with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [ nix ];
  };
}
