{ pkgs, ... }:
{
  plugins = {
    lsp.servers.gopls.enable = true;
    conform-nvim.settings.formattersByFt.go = [ "gofmt" ];
    treesitter.grammarPackages =
      with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
        go
        gomod
        gosum
      ];
  };
}
