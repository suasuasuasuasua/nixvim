{
  lib,
  config,
  pkgs,
  ...
}:
let
  name = "gopls";
  cfg = config.nixvim.lsp.languages.${name};
in
{
  options.nixvim.lsp.languages.${name} = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable ${name} LSP for neovim";
    };
  };

  config = lib.mkIf cfg.enable {
    plugins = {
      lsp.servers.gopls = {
        enable = true;
      };

      treesitter.grammarPackages =
        with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
          go
          gomod
          gosum
        ];
    };

    extraPackages = with pkgs; [
      go
    ];
  };
}
