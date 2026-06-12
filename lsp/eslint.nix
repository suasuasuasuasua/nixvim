{ pkgs, ... }:
{
  plugins = {
    lsp.servers.eslint.enable = true;
    conform-nvim.settings.formattersByFt.javascript = [ "eslint_d" ];
    treesitter.grammarPackages =
      with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
        javascript
        typescript
      ];
  };

  extraPackages = [ pkgs.eslint_d ];
}
