{
  lib,
  config,
  ...
}:
let
  name = "zellij";
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
    # https://github.com/swaits/zellij-nav.nvim/
    plugins.zellij-nav = {
      enable = true;

      lazyLoad = lib.mkIf config.plugins.lz-n.enable {
        enable = true;
        settings = {
          event = [
            # VeryLazy so I can use the UI picker
            "DeferredUIEnter"
          ];
          keys = [
            {
              __unkeyed-1 = "<c-h>";
              __unkeyed-3 = "<cmd>ZellijNavigateLeftTab<cr>";
              mode = "n";
              options = {
                desc = "Zellij Navigate Left or Tab";
                silent = true;
              };
            }
            {
              __unkeyed-1 = "<c-j>";
              __unkeyed-3 = "<cmd>ZellijNavigateDown<cr>";
              mode = "n";
              options = {
                desc = "Zellij Navigate Down";
                silent = true;
              };
            }
            {
              __unkeyed-1 = "<c-k>";
              __unkeyed-3 = "<cmd>ZellijNavigateUp<cr>";
              mode = "n";
              options = {
                desc = "Zellij Navigate Up";
                silent = true;
              };
            }
            {
              __unkeyed-1 = "<c-l>";
              __unkeyed-3 = "<cmd>ZellijNavigateRightTab<cr>";
              mode = "n";
              options = {
                desc = "Zellij Navigate Right or Tab";
                silent = true;
              };
            }
          ];
        };
      };
    };
  };
}
