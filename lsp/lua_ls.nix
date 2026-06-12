{ pkgs, ... }:
{
  plugins = {
    lsp.servers.lua_ls = {
      enable = true;
      settings = {
        Lua.diagnostics.globals = [ "vim" ];
      };
    };
    treesitter.grammarPackages =
      with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
        lua
        luadoc
      ];
  };
}
