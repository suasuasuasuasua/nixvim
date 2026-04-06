{
  lib,
  config,
  ...
}:
let
  name = "todo-comments";
  cfg = config.nixvim.plugins.${name};
in
{
  options.nixvim.plugins.${name} = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable ${name} plugin for neovim";
    };
  };

  config = lib.mkIf cfg.enable {
    # Highlight todo, notes, etc in comments
    # https://nix-community.github.io/nixvim/plugins/todo-comments/index.html
    plugins.todo-comments = {
      enable = true;
      settings = {
        signs = false;
      };
    };
  };
}
