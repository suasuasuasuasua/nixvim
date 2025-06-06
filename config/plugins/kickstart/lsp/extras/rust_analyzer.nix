{
  lib,
  config,
  pkgs,
  ...
}:
let
  name = "rust_analyzer";
  cfg = config.nixvim.lsp.languages.${name};
in
{
  options.nixvim.lsp.languages.${name} = {
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

      conform-nvim.settings.formattersByFt =
        lib.mkIf config.nixvim.plugins.kickstart.conform-nvim.enable
          {
            rust = [ "rustfmt" ];
          };

      treesitter.grammarPackages =
        with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
          rust
        ];
    };

    extraPackages = with pkgs; [
      rustfmt
    ];
  };
}
