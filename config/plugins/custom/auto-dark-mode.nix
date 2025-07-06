{
  lib,
  config,
  pkgs,
  ...
}:
let
  name = "auto-dark-mode";
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
    extraPlugins = [
      # https://github.com/f-person/auto-dark-mode.nvim
      (pkgs.vimUtils.buildVimPlugin {
        name = "auto-dark-mode";
        src = pkgs.fetchFromGitHub {
          owner = "f-person";
          repo = "auto-dark-mode.nvim";
          rev = "97a86c9402c784a254e5465ca2c51481eea310e3";
          hash = "sha256-zedwqG5PeJiSAZCl3GeyHwKDH/QjTz2OqDsFRTMTH/A=";
        };
      })
    ];

    plugins.lz-n = lib.mkIf config.plugins.lz-n.enable {
      # https://nix-community.github.io/nixvim/plugins/lz-n/plugins.html
      plugins = [
        {
          __unkeyed-1 = "auto-dark-mode.nvim"; # the plugin's name (:h packadd)
          after =
            # lua
            ''
              function()
                require('auto-dark-mode').setup {
                  set_dark_mode = function()
                    vim.api.nvim_set_option_value("background", "dark", {})
                  end,
                  set_light_mode = function()
                    vim.api.nvim_set_option_value("background", "light", {})
                  end,
                  update_interval = 3000,
                  fallback = "dark"
                };
              end
            '';
          event = [
            "DeferredUIEnter"
          ];
        }
      ];
    };
  };
}
