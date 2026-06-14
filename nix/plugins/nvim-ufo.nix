{
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
      options.desc = "ufo: Open all folds";
    }
    {
      mode = "n";
      key = "zM";
      action.__raw = "require('ufo').closeAllFolds";
      options.desc = "ufo: Close all folds";
    }
  ];
}
