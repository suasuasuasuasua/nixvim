{
  lib,
  config,
  ...
}:
let
  name = "diffview";
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
    # https://github.com/sindrets/diffview.nvim
    plugins.diffview = {
      enable = true;
    };

    plugins.lz-n = lib.mkIf config.plugins.lz-n.enable {
      # https://nix-community.github.io/nixvim/plugins/lz-n/plugins.html
      plugins = [
        {
          __unkeyed-1 = "diffview.nvim"; # the plugin's name (:h packadd)
          after =
            # lua
            ''
              function()
                require('diffview').setup()
              end
            '';
          cmd = [ "DiffviewOpen" ];
        }
      ];
    };
  };
}
