{ pkgs, ... }:
{
  plugins = {
    lsp.servers.ruff.enable = true;
    conform-nvim.settings.formattersByFt.python = {
      __unkeyed-1 = "black";
      __unkeyed-2 = "ruff";
      stop_after_first = true;
    };
    treesitter.grammarPackages =
      with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [ python ];
  };

  extraPackages = [ pkgs.ruff ];
}
