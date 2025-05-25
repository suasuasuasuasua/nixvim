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
      plugins = lib.attrNames opts.plugins;
    in
    {
      colorscheme.enable = false;
      lsp = builtins.foldl' (
        acc: name:
        {
          ${name} = {
            inherit enable;
          };
        }
        // acc
      ) { } lsp-names;
      plugins = builtins.foldl' (
        acc: name:
        {
          ${name} = {
            inherit enable;
          };
        }
        // acc
      ) { } plugins;
    };
}
