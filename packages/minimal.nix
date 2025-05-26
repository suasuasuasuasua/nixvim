{
  nvim,
  lib,
  ...
}:
nvim.extend {
  config.nixvim =
    let
      inherit (nvim) options;
      opts = options.nixvim;

      enable = false;

      lsp-languages = lib.attrNames opts.lsp.languages;
      custom-plugins = lib.attrNames opts.plugins.custom;
    in
    {
      colorscheme.enable = true;
      lsp = {
        enable = true;
        languages = builtins.foldl' (
          acc: name:
          {
            ${name} = {
              inherit enable;
            };
          }
          // acc
        ) { } lsp-languages;
      };
      plugins = {
        custom = builtins.foldl' (
          acc: name:
          {
            ${name} = {
              inherit enable;
            };
          }
          // acc
        ) { } custom-plugins;
      };
    };
}
