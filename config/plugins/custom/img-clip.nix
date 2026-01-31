{
  lib,
  config,
  pkgs,
  ...
}:
let
  name = "img-clip";
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
    # https://github.com/HakonHarnes/img-clip.nvim
    plugins.img-clip = {
      enable = true;

      lazyLoad = lib.mkIf config.plugins.lz-n.enable {
        enable = true;

        settings = {
          event = [
            "DeferredUIEnter"
          ];
        };
      };
    };

    extraPackages =
      let
        inherit (lib) optionals;
        inherit (pkgs.stdenv.hostPlatform) isDarwin isLinux;
      in
      with pkgs;
      optionals isDarwin [
        pngpaste # macOS
      ]
      ++ optionals isLinux [
        wl-clipboard # wayland
      ];
  };
}
