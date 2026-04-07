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

      lsp-languages = lib.attrNames opts.lsp.languages;
      custom-plugins = lib.attrNames opts.plugins;
    in
    {
      colorscheme.enable = true;
      lsp = {
        enable = true;
        languages = builtins.foldl' (
          acc: name:
          {
            ${name} = {
              enable = true;
            };
          }
          // acc
        ) { } lsp-languages;
      };
      plugins = builtins.foldl' (
        acc: name:
        {
          ${name} = {
            enable = false;
          };
        }
        // acc
      ) { } custom-plugins;
    };
}
