{ pkgs, ... }:
{
  plugins = {
    lsp.servers.vtsls.enable = true;
    conform-nvim.settings.formattersByFt = {
      javascript = [ "prettierd" ];
      typescript = [ "prettierd" ];
    };
    treesitter.grammarPackages =
      with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
        javascript
        typescript
      ];
  };

  extraPackages = [ pkgs.prettierd ];
}
