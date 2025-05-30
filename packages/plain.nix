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
      kickstart-plugins = lib.attrNames opts.plugins.kickstart;
    in
    {
      colorscheme.enable = false;
      lsp = {
        enable = false;
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
        kickstart = builtins.foldl' (
          acc: name:
          {
            ${name} = {
              inherit enable;
            };
          }
          // acc
        ) { } kickstart-plugins;
      };
    };
}
