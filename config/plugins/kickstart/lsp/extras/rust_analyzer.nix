{
  lib,
  config,
  pkgs,
  ...
}:
let
  name = "rust_analyzer";
  cfg = config.nixvim.lsp.${name};
in
{
  options.nixvim.lsp.${name} = {
    enable = lib.mkEnableOption "Enable ${name} LSP for neovim";
  };

  config = lib.mkIf cfg.enable {
    plugins = {
      lsp.servers.rust_analyzer = {
        enable = true;
        # NOTE: add options as I need
        installCargo = false;
        installRustc = false;
      };

      treesitter.grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
        rust
      ];
    };
  };
}
