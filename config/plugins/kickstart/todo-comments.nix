{ lib, config, ... }:
{
  # Highlight todo, notes, etc in comments
  # https://nix-community.github.io/nixvim/plugins/todo-comments/index.html
  plugins.todo-comments = {
    enable = true;

    settings = {
      signs = false;
    };

    lazyLoad = lib.mkIf config.plugins.lz-n.enable {
      enable = true;
      settings = {
        # LazyFile is a shorthand that lazy.nvim uses
        event = [
          "BufReadPost"
          "BufWritePost"
          "BufNewFile"
        ];
      };
    };
  };
}
