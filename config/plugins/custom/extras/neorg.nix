{
  lib,
  config,
  pkgs,
  ...
}:
let
  name = "neorg";
  cfg = config.nixvim.plugins.custom.${name};
in
{
  options.nixvim.plugins.custom.${name} = {
    enable = lib.mkEnableOption "Enable ${name} plugin for neovim";
    workspaces = lib.mkOption {
      type =
        with lib.types;
        let
          valueType = either str (attrsOf valueType) // {
            description = "attribute sets of strings";
          };
        in
        nullOr valueType;
      default = { };
    };
    default_workspace = lib.mkOption {
      type = lib.types.str;
      default = "";
    };
  };

  config = lib.mkIf cfg.enable {
    # https://github.com/nvim-neorg/neorg
    plugins.neorg = {
      enable = true;

      settings = {
        load = {
          "core.concealer" = {
            config = {
              icon_preset = "varied";
            };
          };
          "core.defaults" = {
            __empty = null;
          };
          "core.dirman" = {
            config = {
              inherit (cfg) workspaces default_workspace;
              index = "index.norg";
            };
          };
          "core.integrations.telescope" = {
            config = {
              insert_file_link = {
                # Whether to show the title preview in telescope. Affects
                # performance with a large number of files.
                show_title_preview = true;
              };
            };
          };
          "core.summary" = {
            __empty = null;
          };
        };
      };
      telescopeIntegration.enable = true;
    };

    keymaps = [
      {
        mode = "n";
        key = "<Leader>sn";
        action = "<cmd>Neorg<CR>";
        options = {
          desc = "[S]earch [N]eorg options";
        };
      }
    ];
    plugins.treesitter.grammarPackages =
      with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
        norg
      ];
  };
}
