{
  lib,
  config,
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
          # Use the "_" filetype to run formatters on filetypes that don't
          # have other formatters configured.
          "_" = [
            "trim_whitespace"
            "trim_newlines"
          ];
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
                    require('conform').format { async = true, lsp_format = 'fallback' }
                  end
                '';
              mode = "";
              desc = "[F]ormat buffer";
            }
          ];
        };
      };
    };
  };
}
