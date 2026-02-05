{
  lib,
  config,
  ...
}:
let
  name = "which-key";
  cfg = config.nixvim.plugins.kickstart.${name};
in
{
  options.nixvim.plugins.kickstart.${name} = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable ${name} plugin for neovim";
    };
  };

  config = lib.mkIf cfg.enable {
    # Useful plugin to show you pending keybinds.
    # https://nix-community.github.io/nixvim/plugins/which-key/index.html
    plugins.which-key = {
      enable = true;
      lazyLoad = lib.mkIf config.plugins.lz-n.enable {
        enable = true;
        settings = {
          event = [ "DeferredUIEnter" ];
        };
      };

      # Document existing key chains
      settings = {
        # delay between pressing a key and opening which-key (milliseconds)
        # this setting is independent of vim.opt.timeoutlen
        delay = 0;
        # one of “classic”, “modern”, “helix”
        preset = "classic";
        # check if we have a nerd font...
        icons.mappings = config.globals.have_nerd_font;
        spec = [
          {
            __unkeyed-1 = "<leader>s";
            group = "[S]earch";
            mode = [
              "n"
              "v"
            ];
          }
          {
            __unkeyed-1 = "<leader>t";
            group = "[T]oggle";
          }
          {
            __unkeyed-1 = "<leader>h";
            group = "Git [H]unk";
            mode = [
              "n"
              "v"
            ];
          }
        ];
      };
    };
  };
}
