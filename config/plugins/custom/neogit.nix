{
  lib,
  config,
  ...
}:
let
  name = "neogit";
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
    # https://github.com/NeogitOrg/neogit/
    plugins.neogit = {
      enable = true;
    };

    keymaps = [
      {
        mode = "n";
        key = "<Leader>gg";
        action = "<CMD>Neogit<CR>";
        options = {
          desc = "Show Neogit UI";
        };
      }
    ];
  };
}
