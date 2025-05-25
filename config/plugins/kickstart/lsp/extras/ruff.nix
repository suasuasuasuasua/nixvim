{
  lib,
  config,
  pkgs,
  ...
}:
let
  name = "ruff";
  cfg = config.nixvim.lsp.${name};
in
{
  options.nixvim.lsp.${name} = {
    enable = lib.mkEnableOption "Enable ${name} LSP for neovim";
  };

  config = lib.mkIf cfg.enable {
    plugins = {
      lsp.servers.ruff = {
        enable = true;
        # NOTE: add options as I need
      };

      treesitter.grammarPackages =
        with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
          python
        ];
    };
  };
}
