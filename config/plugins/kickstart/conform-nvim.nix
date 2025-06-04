{
  lib,
  config,
  pkgs,
  ...
}:
let
  name = "conform-nvim";
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
    # Autoformat
    # https://nix-community.github.io/nixvim/plugins/conform-nvim.html
    plugins.conform-nvim = {
      enable = true;
      settings = {
        notifyOnError = false;
        format_on_save = {
          timeout_ms = 500;
          lsp_format = "fallback"; # TODO: performance issues?
        };
        formattersByFt = {
          lua = [ "stylua" ];
          # Conform can also run multiple formatters sequentially
          # python = [ "isort "black" ];
          #
          # You can use a sublist to tell conform to run *until* a formatter
          # is found
          # javascript = [ [ "prettierd" "prettier" ] ];
        };
      };

      lazyLoad = lib.mkIf config.plugins.lz-n.enable {
        enable = true;
        settings = {
          event = [ "BufWritePre" ];
          cmd = [ "ConformInfo" ];
          keys = [
            {
              __unkeyed-1 = "<leader>f";
              __unkeyed-3.__raw =
                # lua
                ''
                  function()
                    require('conform').format { async = true, lsp_fallback = true }
                  end
                '';
              mode = "n";
              desc = "[F]ormat buffer";
            }
          ];
        };
      };
    };

    # Dependencies
    #
    # https://nix-community.github.io/nixvim/NeovimOptions/index.html?highlight=extraplugins#extrapackages
    extraPackages = with pkgs; [
      # Used to format Lua code
      stylua
    ];
  };
}
