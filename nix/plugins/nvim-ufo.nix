{
  lib,
  config,
  ...
}:
let
  name = "nvim-ufo";
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
    # https://github.com/kevinhwang91/nvim-ufo
    plugins.nvim-ufo = {
      enable = true;
      settings.provider_selector.__raw = ''
        function(bufnr, filetype, buftype)
          return { 'treesitter', 'indent' }
        end
      '';
    };

    keymaps = [
      {
        mode = "n";
        key = "zR";
        action.__raw = "require('ufo').openAllFolds";
        options.desc = "Open all folds [ufo]";
      }
      {
        mode = "n";
        key = "zM";
        action.__raw = "require('ufo').closeAllFolds";
        options.desc = "Close all folds [ufo]";
      }
    ];
  };
}
