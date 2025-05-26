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

      lsp-names = lib.attrNames opts.lsp;
      custom-plugins = lib.attrNames opts.plugins.custom;
      kickstart-plugins = lib.attrNames opts.plugins.kickstart;
    in
    {
      colorscheme = {
        inherit enable;
      };
      lsp = builtins.foldl' (
        acc: name:
        {
          ${name} = {
            inherit enable;
          };
        }
        // acc
      ) { } lsp-names;
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
