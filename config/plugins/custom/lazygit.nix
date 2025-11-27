{
  lib,
  config,
  ...
}:
let
  name = "lazygit";
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
    # https://github.com/kdheepak/lazygit.nvim
    plugins.lazygit = {
      enable = true;
    };

    keymaps = [
      {
        mode = "n";
        key = "<leader>lg";
        action = "<CMD>LazyGit<CR>";
        options = {
          desc = "[L]azy[G]it";
        };
      }
    ];
  };
}
