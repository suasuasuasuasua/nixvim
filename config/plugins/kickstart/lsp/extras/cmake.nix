{
  lib,
  config,
  pkgs,
  ...
}:
let
  name = "cmake";
  cfg = config.nixvim.lsp.languages.${name};
in
{
  options.nixvim.lsp.languages.${name} = {
    enable = lib.mkEnableOption "Enable ${name} LSP for neovim";
  };

  config = lib.mkIf cfg.enable {
    plugins = {
      lsp.servers.cmake = {
        enable = true;
        # NOTE: add options as I need
      };

      conform-nvim.settings.formattersByFt =
        lib.mkIf config.nixvim.plugins.kickstart.conform-nvim.enable
          {
            cmake = [ "cmake_format" ];
          };

      treesitter.grammarPackages =
        with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
          cmake
        ];
    };

    extraPackages = with pkgs; [
      cmake-format
    ];
  };
}
