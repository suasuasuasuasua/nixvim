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

      enable = true;

      lsp-names = lib.attrNames opts.lsp;
      custom-plugins = lib.attrNames opts.plugins.custom;
    in
    {
      colorscheme = {
        inherit enable;
      };
      lsp =
        builtins.foldl'
          (
            acc: name:
            {
              ${name} = {
                inherit enable;
              };
            }
            // acc
          )
          {
            enable = true;
          }
          lsp-names;
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
