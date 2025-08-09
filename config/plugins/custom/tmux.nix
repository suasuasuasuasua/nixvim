{
  lib,
  config,
  ...
}:
let
  name = "tmux";
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
    # https://github.com/christoomey/vim-tmux-navigator
    plugins.tmux-navigator = {
      enable = true;
    };
  };
}
