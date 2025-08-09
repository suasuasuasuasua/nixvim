{
  lib,
  config,
  ...
}:
let
  name = "undotree";
  cfg = config.nixvim.plugins.custom.${name};
in
{
  options.nixvim.plugins.custom.${name} = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable ${name} plugin for neovim";
    };
  };

  config = lib.mkIf cfg.enable {
    # https://github.com/mbbill/undotree/
    plugins.undotree = {
      enable = true;

      # https://nix-community.github.io/nixvim/plugins/undotree.html#pluginsundotreesettings
      settings = { };
    };

    keymaps = [
      # toggle the undo tree
      {
        mode = "n";
        key = "<leader>u";
        action = "<cmd>UndotreeToggle<cr>";
        options = {
          desc = "Toggle [U]ndo Tree";
        };
      }
    ];
  };
}
