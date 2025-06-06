{
  lib,
  config,
  pkgs,
  ...
}:
let
  name = "tinymist";
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
      lsp.servers.tinymist = {
        enable = true;
        # NOTE: add options as I need
        settings = {
          formatterMode = "typstyle";
          # generally i like 80, but links, math blocks, etc. can be large
          formatterPrintWidth = 120;
        };

        # See https://github.com/neovim/neovim/issues/30675
        extraOptions = {
          # offset_encoding = "utf-8";
          offset_encoding = "utf-16";
        };
      };

      conform-nvim.settings.formattersByFt =
        lib.mkIf config.nixvim.plugins.kickstart.conform-nvim.enable
          {
            typst = [ "typstyle" ];
          };

      treesitter.grammarPackages =
        with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
          typst
        ];
    };

    extraPackages = with pkgs; [
      typstyle
    ];
  };
}
