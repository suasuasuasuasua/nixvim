{
  lib,
  config,
  ...
}:
let
  name = "zen-mode";
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
    # https://github.com/folke/zen-mode.nvim
    plugins.zen-mode = {
      enable = true;

      settings = {
        window = {
          signcolumn = "no";
          number = false;
          relativenumber = false;
          cursorline = false;
          cursorcolumn = false;
          foldcolumn = "0";
          list = false;
        };
        plugins = {
          gitsigns.enabled = true;
          twilight.enabled = true;
          tmux.enabled = true;
          todo.enabled = true;
        };
      };

      # NOTE: disable lazy loading so this can be called
      # performance impact is negligible
    };
  };
}
