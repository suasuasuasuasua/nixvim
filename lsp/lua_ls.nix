{ pkgs, ... }:
{
  plugins = {
    lsp.servers.lua_ls = {
      enable = true;
      onAttach.function = ''
        -- Reduce very long list of triggers for better mini.completion experience
        client.server_capabilities.completionProvider.triggerCharacters = { '.', ':', '#', '(' }
      '';
      settings = {
        Lua = {
          runtime = {
            version = "LuaJIT";
            path.__raw = "vim.split(package.path, ';')";
          };
          workspace = {
            ignoreSubmodules = true;
            library.__raw = "{ vim.env.VIMRUNTIME }";
          };
          diagnostics.globals = [ "vim" ];
        };
      };
    };
    treesitter.grammarPackages =
      with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
        lua
        luadoc
      ];
  };
}
