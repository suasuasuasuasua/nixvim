{
  lib,
  config,
  pkgs,
  ...
}:
let
  name = "remote-nvim";
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
    plugins.remote-nvim = {
      enable = true;
      # https://github.com/amitds1997/remote-nvim.nvim/issues/209
      package = pkgs.vimPlugins.remote-nvim-nvim.overrideAttrs {
        src = pkgs.fetchFromGitHub {
          owner = "amitds1997";
          repo = "remote-nvim.nvim";
          rev = "v0.3.1";
          hash = "sha256-I/GrvTPcH9xs3pxvtWQrK8OUvOworgu0JataUe5rpGQ=";
        };
      };

      lazyLoad = lib.mkIf config.plugins.lz-n.enable {
        enable = true;

        settings = {
          cmd = [
            "RemoteCleanup"
            "RemoteConfigDel"
            "RemoteInfo"
            "RemoteLog"
            "RemoteStart"
            "RemoteStop"
          ];
        };
      };
    };

    extraPackages = with pkgs; [
      devpod
    ];
  };
}
